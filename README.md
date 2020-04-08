# FB Stock Forecast
FB Stock Forecast in R with ARIMA (Autoregressive Integrated Moving Average).

Step 1: Importing data

Daily close prices for the period 2015-2020 (4th column)

![Image](https://github.com/adaynygmanov/FB-forecast/blob/master/Charts/FB%20Close%20Prices.png)

Step 2: Initial ACF and PACF 

![Image](https://github.com/adaynygmanov/FB-forecast/blob/master/Charts/ACF%20and%20PACF1.png)

Step 3: Looking at residuals for the auto.arima and custom arima models based on the determined pdq values. Below is Custom Arima from fit2 applied to original dataset

![Image](https://github.com/adaynygmanov/FB-forecast/blob/master/Charts/Custom%20arima%20model%20residuals.png)

Step 4: Forecasts from ARIMA, looking closely at auto arima on original dataset

![Image](https://github.com/adaynygmanov/FB-forecast/blob/master/Charts/Forecasts%20with%20ARIMA2.png)

Step 5: Checking for accuracy 

![Image](https://github.com/adaynygmanov/FB-forecast/blob/master/Charts/Accuracy.png)

Step 6: Actual forecasted values

![Image](https://github.com/adaynygmanov/FB-forecast/blob/master/Charts/Actual%20forecasted%20values.png)


