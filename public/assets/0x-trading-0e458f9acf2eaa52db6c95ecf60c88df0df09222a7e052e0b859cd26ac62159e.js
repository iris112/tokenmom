let TESTRPC_NETWORK_ID = 1;
// Provider pointing to local TestRPC on default port 8545
let provider;
let providerEngine;
let zeroEx;
let currentWalletAddress;
let web3Status;

//Ropsten link
// let http_link = "https://ropsten.etherscan.io/";

//Main Net link
let http_link = "https://etherscan.io/";

// Main Net
// let wethAddress = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
// const zrxAddress = "0xe41d2489571d322189246dafa5ebde1f4699f498";
// const tmAddress = "0x554b520b298be389f0d87bf3376eb4d6510456ec";
// const usdcAddress = "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48";
// let serverAddress = "0x9c8372f5ee2c2e22826a316ea5b5ff8878adc582";
// let exchange_address = "0x12459c951127e0c374ff9105dda097662a027093";

// Ropsten Net
let wethAddress = "0xc778417e063141139fce010982780140aa0cd5ab";
const zrxAddress = "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d";
const tmAddress = "0x91495D6969120fc016BB687EaD5F5cE56F135504";
const usdcAddress = "0x83e8a9E9F44e19927708F4bB181F9a62141E2a90";
const wbtcAddress = "0x83e8a9E9F44e19927708F4bB181F9a62141E2a90";
let serverAddress = "0x7cc2768c52deab5bc304485c0fd82bed287372cd";
let exchange_address = "0x479cc461fecd078f766ecc58533d6f69580cf3ac";

let null_address = '0x0000000000000000000000000000000000000000';

//Decimal Parameters;
const weth_decimals = 18;
const tm_decimals = 18;
const usdc_decimals = 6;
const wbtc_decimals = 8;

let max_trading_eth = 100;
let max_trading_tm = 100000000;
let max_trading_usdc = 5000;
let max_trading_wbtc = 1;
let max_token_amount = 100000000;
const txOpts = {
    gasLimit: 89000,
    gasPrice: new BigNumber(20000000000)
};
let fee_percent = 0.00;
let tm_fee_percent = 0.00;
let usdc_fee_percent = 0.05;
let wbtc_fee_percent = 0.05;
let initial_tm_fee = 100;
let initial_usdc_fee = 0.25;
let initial_wbtc_fee = 0.000070;
let initial_fee = 0.002;
let reward_request_amount = 10000;
let is_wallet_loaded = false;
var web3js;
let login_method = 0;
let cur_nick_name = '';
// let reward_request_amount = 100;
jQuery(function($) {
    $(document).ready(function () {
        function load_js(){
            var address = get_wallet().address

            if ((address == undefined || address == null || address == "") && ($("#trade_workspace").length || $("#reward_body").length)) {
                async function provider_enable() {
                    if (window.ethereum) {
                    window.web3 = new Web3(ethereum);
                    try {
                        // Request account access if needed
                        await ethereum.enable();
                        // Acccounts now exposed
                        web3.eth.sendTransaction({/* ... */});
                    } catch (error) {
                        // User denied account access...
                    }
                    }
                    // Legacy dapp browsers...
                    else if (window.web3) {
                        window.web3 = new Web3(web3.currentProvider);
                        // Acccounts always exposed
                        web3.eth.sendTransaction({/* ... */});
                    }
                    // Non-dapp browsers...
                    else {
                        console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
                    }
                }
                provider_enable();
            }

            function metamask_login() {
                if ($('#metamask_connect_btn').text() === 'Disconnect') {
                    metamask_disconnect();
                    return;
                }

                console.log("MetaMask login");
                login_method = 2;
                get_nick_name();
            }

            function create_tokenmom_wallet() {
                if ($('#tokenmom_connect_btn').text() === 'Disconnect') {
                    tokenmom_disconnect();
                    return;
                }

                login_method = 1;
                get_nick_name();
            }

            function import_tokenmom_wallet() {
                if ($('#privatekey_connect_btn').text() === 'Disconnect') {
                    privatekey_disconnect();
                    return;
                }

                login_method = 3;
                get_nick_name();
            }

            function import_json_wallet() {
                if ($('#json_connect_btn').text() === 'Disconnect') {
                    json_disconnect();
                    return;
                }

                login_method = 4;
                get_nick_name();
            }

            if ($("#account_body").length) {
                $("#metamask_login").click(metamask_login);
                $("#create_tokenmom_wallet").click(create_tokenmom_wallet);
                $("#import_tokenmom_wallet").click(import_tokenmom_wallet);
                $("#import_json_wallet").click(import_json_wallet);
                $("#importBrowserWallet .trade-by-address").click(function () {

                    var privkey = $("#importBrowserWallet .token-address-input").val();
                    var addr = keythereum.privateKeyToAddress(privkey);
                    if (!verifyPrivateKey(addr, privkey)) {
                        console.log("false")
                        let alert = "<span>Please enter valid private key</span>";
                        $(this).parent().next().children().remove();
                        $(this).parent().next().html(alert);
                        $("#importBrowserWallet .trade-by-address").addClass("disabled");
                        return;
                    }
                    $("#importBrowserWallet").hide();
                    wallet_disconnect();
                    set_wallet(addr, privkey, 3);
                    var wallet = get_wallet();
                    var title = $.i18n('import_tokenmom_wallet_successed');
                    var message = '';
                    var data = [{"name": $.i18n('wallet_address'), "value": wallet.address, "link": true},
                                {"name": $.i18n('private_key'), "value": wallet.privkey}];
                    showBrowserWalletResult(title, message, data);
                    currentWalletAddress = get_wallet().address;
                    wallet_login(cur_nick_name, 'PRIVATE_KEY')
                });
                $("#importJsonWallet .trade-by-address").click(function () {
                    if( $("#json_file")[0].files.length == 0 )
                        return;

                    var fileReader = new FileReader();
                    fileReader.onload = function(e) {
                        var json = e.target.result;

                        if (ethers.utils.getJsonWalletAddress(json)) {
                            console.log('Decrypting Wallet...');

                            var password = $("#json_password").val();
                            var updateLoading = (function() {
                                return (function(progress) {
                                    console.log((parseInt(progress * 100)) + '%');
                                    return false;
                                });
                            })();

                            ethers.Wallet.fromEncryptedJson(json, password, null).then(function(wallet) {
                                $("#importJsonWallet").hide();
                                wallet_disconnect();
                                console.log(wallet);
                                set_wallet(wallet.address, wallet.privateKey, 4);
                                var wallet = get_wallet();
                                var title = $.i18n('import_tokenmom_wallet_successed');
                                var message = '';
                                var data = [{"name": $.i18n('wallet_address'), "value": wallet.address, "link": true},
                                            {"name": $.i18n('private_key'), "value": wallet.privkey}];
                                showBrowserWalletResult(title, message, data);
                                currentWalletAddress = get_wallet().address;
                                wallet_login(cur_nick_name, 'JSON')

                            }, function(error) {
                                if (error.message === 'invalid password') {
                                    console.log('Wrong Password');
                                } else {
                                    console.log(error);
                                    console.log('Error Decrypting Wallet');
                                }
                                $("#importJsonWallet").hide();
                            });
                        } else {
                            console.log('Unknown JSON wallet format');
                            $("#importJsonWallet").hide();
                        }
                    };
                    fileReader.readAsText($("#json_file")[0].files[0]);
                });

                $("#enterNickName .trade-by-address").click(function () {
                    var cur_nick_name = $("#nick_name").val();
                    if (cur_nick_name.trim() === '') {
                        $("#enterNickName .text-danger").css("display", "block");
                        $("#enterNickName .text-danger").text("Please input nick name.");
                        $("#importBrowserWallet .trade-by-address").addClass("disabled");
                        return;
                    }

                    $("#enterNickName").hide();

                    if (login_method == 1) {
                        wallet_disconnect();
                        var wallet = create_wallet();
                        console.log('Created Account:', wallet.address, ' ', wallet.privkey)
                        var title = $.i18n('create_a_tokenmom_wallet');
                        var message = '';
                        var data = [{"name": $.i18n('wallet_address'), "value": wallet.address, "link": true},
                                    {"name": $.i18n('private_key'), "value": wallet.privkey}];


                        showBrowserWalletResult(title, message, data);
                        currentWalletAddress = wallet.address;
                        wallet_login(cur_nick_name, 'TOKENMOM');
                    } else if (login_method == 2) {
                        wallet_disconnect();
                        // console.log("MetaMask Provider", metamask_provider);
                        // if (metamask_provider != undefined && metamask_provider != null) {
                        //     web3Status = 1
                        //     web3 = new Web3(metamask_provider);
                        // }
                        if ((typeof web3) !== 'undefined') {
                            web3Status = 1;
                            web3js = new Web3(web3.currentProvider);
                        }
                        var account = web3js.eth.accounts.length > 0 ? web3js.eth.accounts[0] : null;
                        currentWalletAddress = account;
                        wallet_login(cur_nick_name, 'META_MASK');
                    } else if (login_method == 3) {
                        // $("#detect_popup").removeClass("show");
                        $("#importBrowserWallet").show();
                        $("#importBrowserWallet").addClass("show");
                        $("#importBrowserWallet").addClass("in");
                    } else if (login_method == 4) {
                        // $("#detect_popup").removeClass("show");
                        $("#importJsonWallet").show();
                        $("#importJsonWallet").addClass("show");
                        $("#importJsonWallet").addClass("in");
                    }

                    login_method = 0;
                });
            }
            var wallet = get_wallet();

            if (wallet.address != null && wallet.address != "") {
                web3Status = wallet.type;
                web3js = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/"));
            } else if ((typeof web3) !== 'undefined') {
                web3Status = 1;
                web3js = new Web3(web3.currentProvider);
            } else {
                web3Status = 0;
            }
            if (web3Status == 0) {
                return
            }
            zeroex_login()

            const accountAsync = async () => {
                currentWalletAddress = "";
                auto_login()
                setInterval(function () {
                    auto_login()
                }, 500);
            };
            accountAsync().catch(console.error);

            if ($("#trade_workspace").length) {
                let walletType = '';
                var connection_status_ele = document.getElementById("connection_status");

                if (web3Status == 1)
                    walletType = 'MetaMask';
                else if (web3Status >= 2)
                    walletType = 'Tokenmom';
                else
                    walletType = 'select_wallet';

                $('#connected_wallet').attr('data-i18n', walletType);
                $('#connected_wallet').text($.i18n(walletType));

                if (web3Status == 0) {
                    $('#connected_info').attr('data-i18n', 'no_accounts_detected');
                    $('#connected_info').text($.i18n('no_accounts_detected'));

                    connection_status_ele.classList.add("not-connected");
                    connection_status_ele.classList.remove("connection-issue");
                    connection_status_ele.classList.remove("connected");
                } else {
                    $('#connected_info').attr('data-i18n', '');
                    $('#connected_info').text(normalize_string(currentWalletAddress));

                    connection_status_ele.classList.remove("not-connected");
                    connection_status_ele.classList.remove("connection-issue");
                    connection_status_ele.classList.add("connected");
                }
            }

        }
        function auto_login() {
            if (web3Status == 1)  {
                if (web3js.eth.accounts.length > 0 && web3js.eth.accounts[0] !== currentWalletAddress) {
                    currentWalletAddress = web3js.eth.accounts[0];
                    is_wallet_loaded = true;
                    if (currentWalletAddress == null || currentWalletAddress == undefined || currentWalletAddress == "") {
                        clear();
                    }
                    if ($("#account_body").length) {
                        get_user_info(function (nick_name){
                            wallet_login(nick_name, 'META_MASK');
                        });
                    }
                }
            } else if (web3Status == 2) {
                if (currentWalletAddress !== get_wallet().address) {
                    currentWalletAddress = get_wallet().address;
                    is_wallet_loaded = true;
                    if (currentWalletAddress === null || currentWalletAddress === "") {
                        clear();
                    } else {
                        if ($("#account_body").length) {
                            get_user_info(function (nick_name){
                                wallet_login(nick_name, 'TOKENMOM')
                            });
                        }
                    }
                }
            } else if (web3Status == 3) {
                if (currentWalletAddress !== get_wallet().address) {
                    currentWalletAddress = get_wallet().address;
                    is_wallet_loaded = true;
                    if (currentWalletAddress === null || currentWalletAddress === "") {
                        clear();
                    } else {
                        if ($("#account_body").length) {
                            get_user_info(function (nick_name){
                                wallet_login(nick_name, 'PRIVATE_KEY')
                            });
                        }
                    }
                }
            } else if (web3Status == 4) {
                if (currentWalletAddress !== get_wallet().address) {
                    currentWalletAddress = get_wallet().address;
                    is_wallet_loaded = true;
                    if (currentWalletAddress === null || currentWalletAddress === "") {
                        clear();
                    } else {
                        if ($("#account_body").length) {
                            get_user_info(function (nick_name){
                                wallet_login(nick_name, 'JSON')
                            });
                        }
                    }
                }
            }
        }
        $(document).on('click','#cancel_metamask_login',function(){
            metamask_cancel();
        });
        $(document).on('click', '#cancel_metamask_install', function(){
            metamask_cancel();
        });
        $(document).on('click', '#metamask_install', function () {
            metamask_install();
        });
        function metamask_cancel() {
            var connection_status_ele = document.getElementById("connection_status");
            document.getElementById('sign_in').style.display = "block";
            document.getElementById('metamask_logined').style.display = "none";
            document.getElementById('metamask_install').style.display = "none";
            document.getElementById('metamask_logoutted').style.display = "none";
            //document.getElementById('connected_info').textContent = 'No accounts detected';
            //document.getElementById('connected_wallet').textContent = 'Select Wallet';
            $('#connected_wallet').attr('data-i18n', 'select_wallet');
            $('#connected_wallet').text($.i18n('select_wallet'));
            $('#connected_info').attr('data-i18n', 'no_accounts_detected');
            $('#connected_info').text($.i18n('no_accounts_detected'));
            connection_status_ele.classList.add("not-connected");
            connection_status_ele.classList.remove("connection-issue");
            connection_status_ele.classList.remove("connected");
        }
        function metamask_install() {
            var win = window.open('https://metamask.io/', '_blank');
            win.focus();
        }
        function get_user_info(callback) {
            var get_user = async () => {
                $.ajax({
                    url: '/user_sessions/get_user',
                    type: 'GET',
                    dataType: 'json',
                    data: {
                        wallet_address: currentWalletAddress
                    },
                    success: function (response) {
                        if ( response === null || response['nick_name'] == null) {
                            callback("");
                        } else {
                            var nick_name = response['nick_name'];
                            $('#message_body').attr('data-user-id', response['id']);
                            $('#message_body').attr('data-i18n', '[placeholder]enter_message');
                            $('#message_body').attr('placeholder',$.i18n('enter_message'))
                            $('#message_body').attr('disabled', false);
                            console.log("Nick Name:", nick_name);
                            callback(nick_name);
                        }
                    }
                });
            };
            get_user().catch(console.error);
        }
        function clear() {
                $('#message_body').attr('data-user-id', '');
                $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
                $('#message_body').attr('placeholder', $.i18n('connect_wallet'));
                $('#message_body').attr('disabled', true);
                document.getElementById('sign_in').style.display = "block";
                document.getElementById('metamask_logined').style.display = "none";
                document.getElementById('metamask_install').style.display = "none";
                document.getElementById('metamask_logoutted').style.display = "none";
                //Wallet disable when metamask logout
                // document.getElementById("wallet_widget").children[0].classList.remove('is-active');
        }

        $('#createBrowserWallet .btn-cancel-tradebyaddr').click(function(){
                $("#createBrowserWallet").hide();
        });


        $("#importBrowserWallet").on('hidden.bs.modal', function (e){
            $("#importBrowserWallet .token-address-input").val("");
            $("#importBrowserWallet .trade-by-address").addClass("disabled");
        });

        $("#enterNickName").on('hidden.bs.modal', function (e){
            $("#nick_name").val("");
            $("#enterNickName .text-danger").css("display", "block");
            $("#enterNickName .text-danger").text("Please input nick name.");
            $("#enterNickName .trade-by-address").addClass("disabled");
        });

        $(document).on('click','#importBrowserWallet .btn-cancel-tradebyaddr',function(){
            $("#importBrowserWallet").hide();
        });
        $(document).on('click','#importJsonWallet .btn-cancel-tradebyaddr',function(){
            $("#importJsonWallet").hide();
        });
        $(document).on('click','#enterNickName .btn-cancel-tradebyaddr',function(){
            $("#enterNickName").hide();
        });

        $('#json_file').change(function() {
            $("#importJsonWallet .trade-by-address").removeClass("disabled");
        });

       $(document).on('change paste keyup', "#nick_name", function(){
            var nickname = $("#nick_name").val();
            if(nickname.trim() === ''){
                $("#enterNickName .text-danger").css("display", "block");
                $("#enterNickName .text-danger").text("Please input nick name.");
                $("#enterNickName .trade-by-address").addClass("disabled");
            }else{
                $("#enterNickName .text-danger").css("display", "none");
                $("#enterNickName .text-danger").text("");
                $("#enterNickName .trade-by-address").removeClass("disabled");
            }
        });

       $(document).on('change paste keyup', "#importBrowserWallet .token-address-input", function(){
            var hex_value = $("#importBrowserWallet .token-address-input").val();
            if(!isValidPrivateKey(hex_value)){
                let alert = "<span>Please enter valid private key</span>";
                $(this).parent().next().children().remove();
                $(this).parent().next().html(alert);
                $("#importBrowserWallet .trade-by-address").addClass("disabled");
            }else{
                $(this).parent().next().children().remove();
                $("#importBrowserWallet .trade-by-address").removeClass("disabled");
            }
        });

        function isValidPrivateKey(privateKeyIn) {
            var privateKey = privateKeyIn;

            return privateKey && "0x" !== privateKey.substring(0, 2) && privateKey.length == 64 && (privateKey = "0x" + privateKey);
        }
        function verifyPrivateKey(addr, privateKeyIn) {
            var privateKey = privateKeyIn;

            return privateKey && "0x" !== privateKey.substring(0, 2) && (privateKey = "0x" + privateKey), addr.toLowerCase() === EthJS.Util.toChecksumAddress("0x" + EthJS.Util.privateToAddress(privateKey).toString("hex")).toLowerCase();
        }
        function create_wallet() {
            var privateKey = keythereum.create().privateKey;
            var addr = keythereum.privateKeyToAddress(privateKey);
            var privkey = privateKey.toString("hex");
            set_wallet(addr, privkey, 2);
            return get_wallet();
        }


        function set_wallet(addr, privkey, type) {
            localStorage.setItem('wallet_privatekey', privkey);
            localStorage.setItem('wallet_address', addr);
            localStorage.setItem('wallet_type', type);
        }

        function remove_wallet() {
            localStorage.setItem('wallet_privatekey', '');
            localStorage.setItem('wallet_address', '');
        }

        function get_nick_name() {
            // var nick_name_ele = document.getElementById("nick_name");
            // var nick_name = nick_name_ele.value;
            // if (nick_name.length === 0 || !nick_name.trim()) {
            //     nick_name_ele.classList.add();
            //     $("#account_body .text-danger").css("display", "block");
            //     $("#account_body .text-danger").text("Please input nick name.");
            //     return null;
            // }
            // nick_name_ele.classList.remove();
            // return nick_name;

            $("#enterNickName").show();
            $("#enterNickName").addClass("show");
            $("#enterNickName").addClass("in");
        }

        function init_nick_name() {
            var nick_name_ele = document.getElementById("nick_name");
            nick_name_ele.value = "";
            $("#account_body .text-danger").css("display", "none");
            $("#account_body .text-danger").text("");
        }

        function wallet_disconnect() {
            if (web3Status == 1) {
                metamask_disconnect();
            } else if (web3Status == 2) {
                tokenmom_disconnect();
            } else if (web3Status == 3) {
                privatekey_disconnect();
            } else if (web3Status == 4) {
                json_disconnect();
            }
        }

        function wallet_login(nick_name, wallet_type) {
            if (currentWalletAddress != undefined && currentWalletAddress != null && currentWalletAddress != "") {
                refer_id = $(".navbar-brand").attr("refer_id");

                if(refer_id != "" && refer_id != null){

                }
                $.ajax({
                    url: '/user_sessions/user_login',
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        login_type: wallet_type,
                        wallet_address: currentWalletAddress,
                        nick_name: nick_name,
                        refer_id:refer_id
                    },
                    success: function (response) {
                        $('#message_body').attr('data-user-id', response['id']);
                        $('#message_body').attr('data-i18n', '[placeholder]enter_message');
                        $('#message_body').attr('placeholder', $.i18n('enter_message'));
                        $('#message_body').attr('disabled', false);
                    }
                });
                let wallet_address = normalize_string(currentWalletAddress);
                //document.getElementById('connected_info').textContent = normalize_string(currentWalletAddress);

                if (wallet_type == 'META_MASK') {
                    web3Status = 1;
                    web3js = new Web3(web3.currentProvider);

                    // document.getElementById('sign_in').style.display = "none";
                    document.getElementById('metamask_logined').style.display = "block";
                    document.getElementById('metamask_desc').style.display = "none";
                    // document.getElementById('tokenmom_logined').style.display = "none";
                    // document.getElementById('metamask_install').style.display = "none";
                    // document.getElementById('metamask_logoutted').style.display = "none";

                    $('#wallet_address').attr('data-i18n', '');
                    $('#wallet_address').text(wallet_address);
                    $('#wallet_address').attr('href', http_link + 'address/' + currentWalletAddress);
                    //$('#wallet_address').children('a').text("Hello");
                    $('#metamask_nick_name').text(nick_name);
                    // $('#connected_wallet').attr('data-i18n', 'metamask');
                    // $('#connected_wallet').text($.i18n('metamask'));
                    $('#metamask_connect_btn').text('Disconnect')
                    $("#metamask_login").css("background", "#FF4B57");

                } else if (wallet_type == 'TOKENMOM') {
                    web3Status = 2;
                    web3js = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/"));

                    // document.getElementById('sign_in').style.display = "none";
                    // document.getElementById('metamask_logined').style.display = "none";
                    document.getElementById('tokenmom_logined').style.display = "block";
                    document.getElementById('tokenmom_desc').style.display = "none";
                    // document.getElementById('metamask_install').style.display = "none";
                    // document.getElementById('metamask_logoutted').style.display = "none";

                    $('#tokenmom_wallet_address').attr('data-i18n', '');
                    $('#tokenmom_wallet_address').text(wallet_address);
                    $('#tokenmom_wallet_address').attr('href', http_link + 'address/' + currentWalletAddress);
                    //$('#wallet_address').children('a').text("Hello");
                    $('#tokenmom_nick_name').text(nick_name);
                    // $('#connected_wallet').attr('data-i18n', 'tokenmom');
                    // $('#connected_wallet').text($.i18n('tokenmom'));
                    $('#tokenmom_connect_btn').text('Disconnect')
                    $("#create_tokenmom_wallet").css("background", "#FF4B57");
                } else if (wallet_type == 'PRIVATE_KEY') {
                    web3Status = 3;
                    web3js = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/"));

                    // document.getElementById('sign_in').style.display = "none";
                    // document.getElementById('metamask_logined').style.display = "none";
                    document.getElementById('privatekey_logined').style.display = "block";
                    document.getElementById('privatekey_desc').style.display = "none";
                    // document.getElementById('metamask_install').style.display = "none";
                    // document.getElementById('metamask_logoutted').style.display = "none";

                    $('#privatekey_wallet_address').attr('data-i18n', '');
                    $('#privatekey_wallet_address').text(wallet_address);
                    $('#privatekey_wallet_address').attr('href', http_link + 'address/' + currentWalletAddress);
                    //$('#wallet_address').children('a').text("Hello");
                    $('#privatekey_nick_name').text(nick_name);
                    // $('#connected_wallet').attr('data-i18n', 'tokenmom');
                    // $('#connected_wallet').text($.i18n('tokenmom'));
                    $('#privatekey_connect_btn').text('Disconnect');
                    $("#import_tokenmom_wallet").css("background", "#FF4B57");
                } else if (wallet_type == 'JSON') {
                    web3Status = 4;
                    web3js = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/"));

                    // document.getElementById('sign_in').style.display = "none";
                    // document.getElementById('metamask_logined').style.display = "none";
                    document.getElementById('json_logined').style.display = "block";
                    document.getElementById('json_desc').style.display = "none";
                    // document.getElementById('metamask_install').style.display = "none";
                    // document.getElementById('metamask_logoutted').style.display = "none";

                    $('#json_wallet_address').attr('data-i18n', '');
                    $('#json_wallet_address').text(wallet_address);
                    $('#json_wallet_address').attr('href', http_link + 'address/' + currentWalletAddress);
                    //$('#wallet_address').children('a').text("Hello");
                    $('#json_nick_name').text(nick_name);
                    // $('#connected_wallet').attr('data-i18n', 'tokenmom');
                    // $('#connected_wallet').text($.i18n('tokenmom'));
                    $('#json_connect_btn').text('Disconnect')
                    $("#import_json_wallet").css("background", "#FF4B57");
                }

                zeroex_login()
                //document.getElementById('wallet_address').textContent = normalize_string(currentWalletAddress);
                //document.getElementById('connected_wallet').textContent = 'Metamask';

                // $('#connected_wallet').text($.i18n('metamask'));

                //Change login icon to wallet image;
                // $("#connection_status").children("img").attr("src", "/assets/wallet.svg");
                //Get token balance and weth balance;
                let token_addr = $(".contract-address").children("a").attr("value");
                let base_token = $(".token-info").attr("base_token");
                Trade.get_token_amount(token_addr,base_token);
            } else {
                // if (web3Status === 1) {
                //     document.getElementById('sign_in').style.display = "none";
                //     document.getElementById('metamask_logined').style.display = "none";
                //     document.getElementById('metamask_install').style.display = "none";
                //     document.getElementById('metamask_logoutted').style.display = "block";
                // } else if (web3Status === 0) {
                //     document.getElementById('sign_in').style.display = "none";
                //     document.getElementById('metamask_logined').style.display = "none";
                //     document.getElementById('metamask_install').style.display = "block";
                //     document.getElementById('metamask_logoutted').style.display = "none";
                // }
            }
            init_nick_name();
        }

        function metamask_disconnect() {
            web3Status = 0;
            currentWalletAddress = "";
            // $('#message_body').attr('data-user-id', '');
            // $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
            // $('#message_body').attr('placeholder', $.i18n('connect_wallet'));
            // $('#message_body').attr('disabled', true);
            // document.getElementById('sign_in').style.display = "block";
            document.getElementById('metamask_logined').style.display = "none";
            document.getElementById('metamask_desc').style.display = "block";
            // document.getElementById('tokenmom_logined').style.display = "none";
            // document.getElementById('metamask_install').style.display = "none";
            // document.getElementById('metamask_logoutted').style.display = "none";
            // //document.getElementById('connected_info').textContent = 'No accounts detected';
            // //document.getElementById('connected_wallet').textContent = 'Select Wallet';
            // $('#connected_wallet').attr('data-i18n', 'select_wallet');
            // $('#connected_wallet').text($.i18n('select_wallet'));
            // $('#connected_info').attr('data-i18n', 'no_accounts_detected');
            // $('#connected_info').text($.i18n('no_accounts_detected'));
            // //Change login icon to lock key icon
            // var connection_status_ele = document.getElementById("connection_status");
            // $("#connection_status").children("img").attr("src", "/assets/lock.svg");
            // connection_status_ele.classList.add("not-connected");
            // connection_status_ele.classList.remove("connection-issue");
            // connection_status_ele.classList.remove("connected");

            $('#metamask_connect_btn').text('Connect');
            $("#metamask_login").css("background", "");
        }

        function tokenmom_disconnect() {
            remove_wallet();
            web3Status = 0;
            currentWalletAddress = "";
            // $('#message_body').attr('data-user-id', '');
            // $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
            // $('#message_body').attr('placeholder', $.i18n('connect_wallet'));
            // $('#message_body').attr('disabled', true);
            // document.getElementById('sign_in').style.display = "block";
            // document.getElementById('metamask_logined').style.display = "none";
            document.getElementById('tokenmom_logined').style.display = "none";
            document.getElementById('tokenmom_desc').style.display = "block";
            // document.getElementById('metamask_install').style.display = "none";
            // document.getElementById('metamask_logoutted').style.display = "none";
            // //document.getElementById('connected_info').textContent = 'No accounts detected';
            // //document.getElementById('connected_wallet').textContent = 'Select Wallet';
            // $('#connected_wallet').attr('data-i18n', 'select_wallet');
            // $('#connected_wallet').text($.i18n('select_wallet'));
            // $('#connected_info').attr('data-i18n', 'no_accounts_detected');
            // $('#connected_info').text($.i18n('no_accounts_detected'));
            // //Change login icon to lock key icon
            // var connection_status_ele = document.getElementById("connection_status");
            // $("#connection_status").children("img").attr("src", "/assets/lock.svg");
            // connection_status_ele.classList.add("not-connected");
            // connection_status_ele.classList.remove("connection-issue");
            // connection_status_ele.classList.remove("connected");

            $('#tokenmom_connect_btn').text('Connect');
            $("#create_tokenmom_wallet").css("background", "");
        }

        function privatekey_disconnect() {
            remove_wallet();
            web3Status = 0;
            currentWalletAddress = "";
            // $('#message_body').attr('data-user-id', '');
            // $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
            // $('#message_body').attr('placeholder', $.i18n('connect_wallet'));
            // $('#message_body').attr('disabled', true);
            // document.getElementById('sign_in').style.display = "block";
            // document.getElementById('metamask_logined').style.display = "none";
            document.getElementById('privatekey_logined').style.display = "none";
            document.getElementById('privatekey_desc').style.display = "block";
            // document.getElementById('metamask_install').style.display = "none";
            // document.getElementById('metamask_logoutted').style.display = "none";
            // //document.getElementById('connected_info').textContent = 'No accounts detected';
            // //document.getElementById('connected_wallet').textContent = 'Select Wallet';
            // $('#connected_wallet').attr('data-i18n', 'select_wallet');
            // $('#connected_wallet').text($.i18n('select_wallet'));
            // $('#connected_info').attr('data-i18n', 'no_accounts_detected');
            // $('#connected_info').text($.i18n('no_accounts_detected'));
            // //Change login icon to lock key icon
            // var connection_status_ele = document.getElementById("connection_status");
            // $("#connection_status").children("img").attr("src", "/assets/lock.svg");
            // connection_status_ele.classList.add("not-connected");
            // connection_status_ele.classList.remove("connection-issue");
            // connection_status_ele.classList.remove("connected");

            $('#privatekey_connect_btn').text('Import');
            $("#import_tokenmom_wallet").css("background", "");
        }

        function json_disconnect() {
            remove_wallet();
            web3Status = 0;
            currentWalletAddress = "";
            // $('#message_body').attr('data-user-id', '');
            // $('#message_body').attr('data-i18n', '[placeholder]connect_wallet');
            // $('#message_body').attr('placeholder', $.i18n('connect_wallet'));
            // $('#message_body').attr('disabled', true);
            // document.getElementById('sign_in').style.display = "block";
            // document.getElementById('metamask_logined').style.display = "none";
            document.getElementById('json_logined').style.display = "none";
            document.getElementById('json_desc').style.display = "block";
            // document.getElementById('metamask_install').style.display = "none";
            // document.getElementById('metamask_logoutted').style.display = "none";
            // //document.getElementById('connected_info').textContent = 'No accounts detected';
            // //document.getElementById('connected_wallet').textContent = 'Select Wallet';
            // $('#connected_wallet').attr('data-i18n', 'select_wallet');
            // $('#connected_wallet').text($.i18n('select_wallet'));
            // $('#connected_info').attr('data-i18n', 'no_accounts_detected');
            // $('#connected_info').text($.i18n('no_accounts_detected'));
            // //Change login icon to lock key icon
            // var connection_status_ele = document.getElementById("connection_status");
            // $("#connection_status").children("img").attr("src", "/assets/lock.svg");
            // connection_status_ele.classList.add("not-connected");
            // connection_status_ele.classList.remove("connection-issue");
            // connection_status_ele.classList.remove("connected");

            $('#json_connect_btn').text('Import');
            $("#import_json_wallet").css("background", "");
        }

        $('#metamask_disconnect').click(metamask_disconnect);
        $('#tokenmom_disconnect').click(tokenmom_disconnect);

        // show Result of Browser Wallet
        $(document).on('click','#browserWalletResult .btn-cancel-tradebyaddr',function(){
            $("#browserWalletResult").hide();
        });
        function showBrowserWalletResult(title, message, data = []) {
            $("#browserWalletResult .modal-title").text(title);
            $("#browserWalletResult .text-message label").text(message);

            $("#browserWalletResult .modal-body .control-wrapper").remove();

            for(var i = 0; i < data.length; i ++) {
                var item = data[i];
                var label = "<div class='item-label'>" +
                                item.name + "</label>" +
                            "</div>";
                var value = "<div class='item-value'>" +
                "<label data-tooltip='" + "Click to Copy" + "' class='item-value-1'>" + (item.link ? "<a href='" + item.value + "' data-i18n='" + item.value + "'>" + item.value + "</a>" : "<span data-i18n='" + item.value + "'>" + item.value + "</span>") + "</label>" +
                            "</div>";

                $("#browserWalletResult .modal-body").append("<div class='control-wrapper'>" + label + value + "</div>");
            }

            // var trigger = $("#browserWalletResult .modal-body .item-value-1")[1];
            // var toolTip =  new Tooltip(trigger, {
            //     title: trigger.getAttribute('data-tooltip'),
            //     trigger: "hover",
            //   });
            // console.log("ToolTip:", toolTip);
            // var timer_id = -1;
            // $(trigger).click(function () {
            //     trigger.setAttribute('data-tooltip', "Copied");
            //     toolTip.updateTitleContent(trigger.getAttribute('data-tooltip'));
            //     copy($("#browserWalletResult .modal-body .item-value-1 span").text());
            //     setTimeout(function () {
            //         trigger.setAttribute('data-tooltip', "Click to Copy");
            //         toolTip.updateTitleContent(trigger.getAttribute('data-tooltip'));
            //     }, 1000);
            // });

            $("#browserWalletResult").show();
            $("#browserWalletResult").addClass("show");
            $("#browserWalletResult").addClass("in");
        }
        function copy(text) {
            var input = document.createElement('input');
            input.setAttribute('value', text);
            document.body.appendChild(input);
            input.select();
            var result = document.execCommand('copy');
            document.body.removeChild(input)
            return result;
         }
        function zeroex_login() {
            web3js.version.getNetwork((err, netId) => {
                TESTRPC_NETWORK_ID = netId;
                if (netId != "1") {
                    Trade.wrong_network_alert();
                }
                switch (netId) {
                    case "1":
                        console.log('This is mainnet');
                        wethAddress = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
                        break;
                    case "2":
                        console.log('This is the deprecated Morden test network.');
                        break;
                    case "3":
                        console.log('This is the ropsten test network.');
                        wethAddress = "0xc778417e063141139fce010982780140aa0cd5ab";
                        break;
                    case "4":
                        console.log('This is the Rinkeby test network.');
                        break;
                    case "42":
                        console.log('This is the Kovan test network.');
                        wethAddress = "0xd0a1e359811322d97991e03f863a0c30c2cf029c";
                        break;
                    default:
                        console.log('This is an unknown network.');
                }
                const configs = {
                    networkId: new Number(TESTRPC_NETWORK_ID),
                };

                providerEngine = new ZeroEx.Web3ProviderEngine();
                if (web3Status == 1) {
                    // ---- using MetaMask ----
                    providerEngine.addProvider(new ZeroEx.MetamaskSubprovider(web3js.currentProvider));
                } else if (web3Status == 2) {
                    var wallet = get_wallet();
                    providerEngine.addProvider(new ZeroEx.PrivateKeyWalletSubprovider(wallet.privkey));
                }

                // ---- using private key wallet ----
                // providerEngine.addProvider(new ZeroEx.PrivateKeyWalletSubprovider('privatekey'));
                // ----------------------------------

                providerEngine.addProvider(new ZeroEx.RPCSubprovider('https://ropsten.infura.io/'));
                providerEngine.start();

                zeroEx = new ZeroEx.ContractWrappers(providerEngine, configs);
            });
        }
        function get_wallet() {
            return {address: localStorage.getItem('wallet_address'),
                    privkey: localStorage.getItem('wallet_privatekey'),
                    type: localStorage.getItem('wallet_type')}
        }
        load_js();
    });
});
