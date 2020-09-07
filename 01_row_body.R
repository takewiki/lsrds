menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(width = 12,
                             tabBox(title ="row工作台",width = 12,
                                    id='tabSet_row',height = '300px',
                                    tabPanel('数据源-凭证列表',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        actionButton('acct_preview','读取凭证列表DEMO数据')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('acct_data_show','显示安全库存'))
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('数据源-凭证调整',tagList(
                                      fluidRow(column(3,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                
                                        mdl_download_button('acct_adj_tpl', '没有模板?请点此下载'),
                                        mdl_file('acct_adj_data','请上传凭证调整数据.xlsx:'),
                                        actionButton('inv_rpt_preview','上传服务器')
                                
                                      )),
                                      column(9, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        
                                        div(style = 'overflow-x: scroll', mdl_dataTable('inv_rpt_dataShow','显示安全库存'))
                                      )
                                      ))
                                      
                                    )),
                                  
                                    
                                    tabPanel('Corp Report',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        actionButton('CorpRpt_gen','生成公司报表')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('CorpRpt_dataShow','显示安全库存'))
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('Cash Flow',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        actionButton('cf_gen','生成现金流量表')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('cf_dataShow','显示安全库存'))
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('ProjectRpt',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        actionButton('prj_gen','生成项目报表')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('prj_dataShow','显示安全库存'))
                                      )
                                      ))
                                      
                                    )),
                                    tabPanel('OLAP多维报表查询',tagList(
                                      fluidRow(column(4,box(
                                        title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        mdl_ListChooseN('olap_row','请选择行轴维度,可多选择',choiceNames = col_dim,choiceValues = col_dim),
                                        mdl_ListChooseN('olap_col','请选择列轴维度,可多选择',choiceNames = col_dim,choiceValues = col_dim),
                                        mdl_ListChoose1('olap_value','请选择分析值，单选',choiceNames = col_value,choiceValues = col_value,selected = 'Transactiona Amount (Dr+/Cr.-)'),
                                        actionButton('olap_gen','生成OLAP报表'),
                                        mdl_download_button('olap_dl','下载OLAP报表')
                                      )),
                                      column(8, box(
                                        title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        div(style = 'overflow-x: scroll', mdl_dataTable('olap_dataShow','显示安全库存'))
                                      )
                                      ))
                                      
                                    ))
                                    
                                    
                                    
                             )
                      )
                    )
)