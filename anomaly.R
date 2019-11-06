library('anomalize')
library(tidyverse) 
library(coindeskr) 

btc<-read.csv("trueAg.csv", sep=",")
btc$date<-lubridate::ymd(btc$par_date)

btc<-data.frame(i1 = btc$i1, date= btc$date)
btc<-as.tibble(btc)

### Time Series Decomposition with Anomalies#######
btc %>% 
  time_decompose(i1, method = "stl", frequency = "auto", trend = "auto") %>%
  anomalize(remainder, method = "gesd", alpha = 0.05, max_anoms = 0.8) %>%
  plot_anomaly_decomposition()

### Anomaly Detection ######
btc %>% 
  time_decompose(i1) %>%
  anomalize(remainder) %>%
  time_recompose() %>%
  plot_anomalies(time_recomposed = TRUE, ncol = 2, alpha_dots = 1)

#### Extract Anomaly Values ######
btc %>% 
  time_decompose(i1) %>%
  anomalize(remainder) %>%
  time_recompose() %>%
  filter(anomaly == 'Yes') 