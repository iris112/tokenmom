function getLanguageFromURL() {
	const regex = new RegExp('[\\?&]lang=([^&#]*)');
	const results = regex.exec(location.search);

	return results === null ? null : decodeURIComponent(results[1].replace(/\+/g, ' '));
}

TradingView.onready(function() {

    if($("#tradeview-panel").length){
        window.override_dark = {
            "volumePaneSize": "small",

            "paneProperties.background": "#141414",
            "paneProperties.vertGridProperties.color": "#141414",
            "paneProperties.horzGridProperties.color": "#141414",
            "paneProperties.crossHairProperties.color": "#989898",
            "paneProperties.crossHairProperties.width": 1,

            "paneProperties.topMargin": 15,
            "paneProperties.bottomMargin": 15,


            "paneProperties.leftAxisProperties.autoScale": true,
            "paneProperties.leftAxisProperties.autoScaleDisabled": false,
            "paneProperties.leftAxisProperties.percentage": false,
            "paneProperties.leftAxisProperties.percentageDisabled": false,
            "paneProperties.leftAxisProperties.log": false,
            "paneProperties.leftAxisProperties.logDisabled": false,
            "paneProperties.leftAxisProperties.alignLabels": true,

            "paneProperties.legendProperties.showStudyArguments": true,
            "paneProperties.legendProperties.showStudyTitles": true,
            "paneProperties.legendProperties.showStudyValues": true,
            "paneProperties.legendProperties.showSeriesTitle": true,
            "paneProperties.legendProperties.showSeriesOHLC": true,

            "scalesProperties.showLeftScale": false,
            "scalesProperties.showRightScale": true,
            "scalesProperties.backgroundColor": "#ffffff",
            "scalesProperties.fontSize": 11,
            "scalesProperties.lineColor": "#555",
            "scalesProperties.textColor": "#555",
            "scalesProperties.scaleSeriesOnly": false,
            "scalesProperties.showSeriesLastValue": true,
            "scalesProperties.showSeriesPrevCloseValue": false,
            "scalesProperties.showStudyLastValue": false,
            "scalesProperties.showStudyPlotLabels": false,
            "scalesProperties.showSymbolLabels": false,

            "timeScale.rightOffset": 5,

            "mainSeriesProperties.style": 1,

            "mainSeriesProperties.showCountdown": true,
            "mainSeriesProperties.visible": true,
            "mainSeriesProperties.showPriceLine": true,
            "mainSeriesProperties.priceLineWidth": 1,
            "mainSeriesProperties.lockScale": false,
            "mainSeriesProperties.minTick": "default",

            "mainSeriesProperties.priceAxisProperties.autoScale": true,
            "mainSeriesProperties.priceAxisProperties.autoScaleDisabled": false,
            "mainSeriesProperties.priceAxisProperties.percentage": false,
            "mainSeriesProperties.priceAxisProperties.percentageDisabled": false,
            "mainSeriesProperties.priceAxisProperties.log": false,
            "mainSeriesProperties.priceAxisProperties.logDisabled": false,


            "symbolWatermarkProperties.color": "rgba(0, 0, 0, 0.00)",
        };

        window.override_light = {
            "volumePaneSize": "small",

            "paneProperties.background": "#ffffff",
            "paneProperties.vertGridProperties.color": "#ffffff",
            "paneProperties.horzGridProperties.color": "#ffffff",
            "paneProperties.crossHairProperties.color": "#787878",
            "paneProperties.crossHairProperties.width": 1,

            "paneProperties.topMargin": 0,
            "paneProperties.bottomMargin": 0,

            "paneProperties.leftAxisProperties.autoScale": true,
            "paneProperties.leftAxisProperties.autoScaleDisabled": false,
            "paneProperties.leftAxisProperties.percentage": false,
            "paneProperties.leftAxisProperties.percentageDisabled": false,
            "paneProperties.leftAxisProperties.log": false,
            "paneProperties.leftAxisProperties.logDisabled": false,
            "paneProperties.leftAxisProperties.alignLabels": true,

            "paneProperties.legendProperties.showStudyArguments": true,
            "paneProperties.legendProperties.showStudyTitles": true,
            "paneProperties.legendProperties.showStudyValues": true,
            "paneProperties.legendProperties.showSeriesTitle": true,
            "paneProperties.legendProperties.showSeriesOHLC": true,

            "scalesProperties.showLeftScale": false,
            "scalesProperties.showRightScale": true,
            "scalesProperties.backgroundColor": "#ffffff",
            "scalesProperties.fontSize": 11,
            "scalesProperties.lineColor": "#555",
            "scalesProperties.textColor": "#555",
            "scalesProperties.scaleSeriesOnly": false,
            "scalesProperties.showSeriesLastValue": true,
            "scalesProperties.showSeriesPrevCloseValue": false,
            "scalesProperties.showStudyLastValue": false,
            "scalesProperties.showStudyPlotLabels": false,
            "scalesProperties.showSymbolLabels": false,

            "timeScale.rightOffset": 5,

            "mainSeriesProperties.style": 1,

            "mainSeriesProperties.showCountdown": true,
            "mainSeriesProperties.visible": true,
            "mainSeriesProperties.showPriceLine": true,
            "mainSeriesProperties.priceLineWidth": 1,
            "mainSeriesProperties.lockScale": false,
            "mainSeriesProperties.minTick": "default",

            "mainSeriesProperties.priceAxisProperties.autoScale": true,
            "mainSeriesProperties.priceAxisProperties.autoScaleDisabled": false,
            "mainSeriesProperties.priceAxisProperties.percentage": false,
            "mainSeriesProperties.priceAxisProperties.percentageDisabled": false,
            "mainSeriesProperties.priceAxisProperties.log": false,
            "mainSeriesProperties.priceAxisProperties.logDisabled": false,
            "symbolWatermarkProperties.color": "rgba(0, 0, 0, 0.00)"
        };

        const toolbar_bg_dark = '#141414';
        const toolbar_bg_light = '#ffffff';
        let token_symbol = localStorage.getItem("select_token") || "ZRX"

        token_symbol = $(".token-info").attr("token_symbol");
        base_token = $(".token-info").attr("base_token");
        symbol_pair = token_symbol + "-" + base_token;
        // console.log(token_symbol);
        var widget = window.tvWidget = new TradingView.widget({
            symbol: symbol_pair,
            interval: '1D',
            pricescale: 1000000,
            toolbar_bg: toolbar_bg_dark,
            allow_symbol_change: false,
            container_id: 'tv_chart_container',
            datafeed: new Datafeeds.UDFCompatibleDatafeed('https://tokenmom.com/api/v1/datafeeds'),
            library_path: '/assets/charting_library/',
            locale: getLanguageFromURL() || "en",
            overrides: override_dark,
            studies_overrides: {},
            charts_storage_url: 'http://saveload.tradingview.com',
            client_id: 'tradingview.com',
            user_id: 'public_user_id',
            fullscreen: false,
            autosize: true,
            custom_css_url: "theme_style.css",
            loading_screen: { backgroundColor: "#000000", foregroundColor: "#000000" },
            disabled_features: [
                "support_multicharts",
                "header_symbol_search",
                "header_interval_dialog_button",
                "symbol_search_hot_key",
                "show_interval_dialog_on_key_press",
                "left_toolbar"],
            enabled_features: [
                "move_logo_to_main_pane",
            ]
        });

        widget.onChartReady(() => {

            if (localStorage.getItem('theme_color') == "dark") {
                window.tvWidget.applyOverrides(override_dark);
                window.tvWidget.changeTheme("Dark");
            } else if (localStorage.getItem('theme_color') == "light") {
                window.tvWidget.applyOverrides(override_light);
                window.tvWidget.changeTheme("Light");
            } else {
                window.tvWidget.applyOverrides(override_dark);
                window.tvWidget.changeTheme("Dark");
            }
            window.tvWidget.chart().removeAllStudies();
            window.tvWidget.chart().createStudy("volume", false, false);

            // let override = {
            //     "defaults.styles.plot_0.color": "#FF0000"
            // };
            window.tvWidget.chart().createStudy("moving average", true, lock=false, inputs=[length=15,source="close"]/*, overrides=override*/);
            window.tvWidget.chart().createStudy("moving average1", true, false, inputs=[length=60,source="close"]);
        });

        /*
        var token_items = document.getElementsByClassName("token-link-item");
        for (var i = 0; i < token_items.length; i++) {
            token_items[i].addEventListener('click', function (e) {
                var symbol = this.getAttribute('value');
                widget.setSymbol(symbol, '1D', function () {
                    console.log(symbol);
                });
            });
        }
        */
    }
});

// BEWARE: no trailing slash is expected in feed URL
// tslint:disable-next-line:no-any
// http://localhost:3000/api/v1/datafeeds
// https://demo_feed.tradingview.com
























;
