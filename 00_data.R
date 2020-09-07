# 设置app标题-----

app_title <-'雷神数据处理平台';

# store data into rdbe in the rds database
app_id <- 'appTpl'
#app_id <- 'caas'

#设置数据库链接---

conn_be <- conn_rds('rdbe')



#设置链接---
conn <- conn_rds('rpsrds')

#设置测试数据
library(readxl)
# acctList <- read_excel("www/acctList.xlsx", 
#                        sheet = "ALA", col_types = c("numeric", 
#                                                     "numeric", "numeric", "numeric", 
#                                                     "text", "text", "text", "text", "text", 
#                                                     "text", "text", "text", "text", "text", 
#                                                     "text", "numeric", "numeric", "numeric", 
#                                                     "text", "text", "text", "text"))
# #saveRDS(acctList,'www/acctList.RDS')
acctList <- readRDS('www/acctList.RDS')


#View(acctList)

acct_cols <- names(acctList)


#acct_cols

col_value <-list('借方发生额','贷方发生额','Transactiona Amount (Dr+/Cr.-)')

col_dim <-list('会计年度','会计年月','科目代码','科目名称','客户','部门','职员','Project','Cashflow code','Mgmt Report Code','Mgmt Report Name','Report purpose (Corp / Actual / Stat)')
# 
# myform <- as.formula('`Mgmt Report Code`+`Mgmt Report Name`~`Project`')
# 
# mydata <- reshape2::dcast(acctList,myform,sum,value.var = 'Transactiona Amount (Dr+/Cr.-)')
# 
# View(mydata)





