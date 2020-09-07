

#shinyserver start point----
 shinyServer(function(input, output,session) {
    #00-基础框设置-------------
    #读取用户列表
    user_base <- getUsers(conn_be,app_id)
    
    
    
    credentials <- callModule(shinyauthr::login, "login", 
                              data = user_base,
                              user_col = Fuser,
                              pwd_col = Fpassword,
                              hashed = TRUE,
                              algo = "md5",
                              log_out = reactive(logout_init()))
    
    
    
    logout_init <- callModule(shinyauthr::logout, "logout", reactive(credentials()$user_auth))
    
    observe({
       if(credentials()$user_auth) {
          shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
       } else {
          shinyjs::addClass(selector = "body", class = "sidebar-collapse")
       }
    })
    
    user_info <- reactive({credentials()$info})
    
    #显示用户信息
    output$show_user <- renderUI({
       req(credentials()$user_auth)
       
       dropdownButton(
          fluidRow(  box(
             title = NULL, status = "primary", width = 12,solidHeader = FALSE,
             collapsible = FALSE,collapsed = FALSE,background = 'black',
             #2.01.01工具栏选项--------
             
             
             actionLink('cu_updatePwd',label ='修改密码',icon = icon('gear') ),
             br(),
             br(),
             actionLink('cu_UserInfo',label = '用户信息',icon = icon('address-card')),
             br(),
             br(),
             actionLink(inputId = "closeCuMenu",
                        label = "关闭菜单",icon =icon('window-close' ))
             
             
          )) 
          ,
          circle = FALSE, status = "primary", icon = icon("user"), width = "100px",
          tooltip = FALSE,label = user_info()$Fuser,right = TRUE,inputId = 'UserDropDownMenu'
       )
       #
       
       
    })
    
    observeEvent(input$closeCuMenu,{
       toggleDropdownButton(inputId = "UserDropDownMenu")
    }
    )
    
    #修改密码
    observeEvent(input$cu_updatePwd,{
       req(credentials()$user_auth)
       
       showModal(modalDialog(title = paste0("修改",user_info()$Fuser,"登录密码"),
                             
                             mdl_password('cu_originalPwd',label = '输入原密码'),
                             mdl_password('cu_setNewPwd',label = '输入新密码'),
                             mdl_password('cu_RepNewPwd',label = '重复新密码'),
                             
                             footer = column(shiny::modalButton('取消'),
                                             shiny::actionButton('cu_savePassword', '保存'),
                                             width=12),
                             size = 'm'
       ))
    })
    
    #处理密码修改
    
    var_originalPwd <-var_password('cu_originalPwd')
    var_setNewPwd <- var_password('cu_setNewPwd')
    var_RepNewPwd <- var_password('cu_RepNewPwd')
    
    observeEvent(input$cu_savePassword,{
       req(credentials()$user_auth)
       #获取用户参数并进行加密处理
       var_originalPwd <- password_md5(var_originalPwd())
       var_setNewPwd <-password_md5(var_setNewPwd())
       var_RepNewPwd <- password_md5(var_RepNewPwd())
       check_originalPwd <- password_checkOriginal(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_originalPwd)
       check_newPwd <- password_equal(var_setNewPwd,var_RepNewPwd)
       if(check_originalPwd){
          #原始密码正确
          #进一步处理
          if(check_newPwd){
             password_setNew(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_setNewPwd)
             pop_notice('新密码设置成功:)') 
             shiny::removeModal()
             
          }else{
             pop_notice('两次输入的密码不一致，请重试:(') 
          }
          
          
       }else{
          pop_notice('原始密码不对，请重试:(')
       }
       
       
       
       
       
    }
    )
    
    
    
    #查看用户信息
    
    #修改密码
    observeEvent(input$cu_UserInfo,{
       req(credentials()$user_auth)
       
       user_detail <-function(fkey){
          res <-tsui::userQueryField(conn = conn_be,app_id = app_id,user =user_info()$Fuser,key = fkey)
          return(res)
       } 
       
       
       showModal(modalDialog(title = paste0("查看",user_info()$Fuser,"用户信息"),
                             
                             textInput('cu_info_name',label = '姓名:',value =user_info()$Fname ),
                             textInput('cu_info_role',label = '角色:',value =user_info()$Fpermissions ),
                             textInput('cu_info_email',label = '邮箱:',value =user_detail('Femail') ),
                             textInput('cu_info_phone',label = '手机:',value =user_detail('Fphone') ),
                             textInput('cu_info_rpa',label = 'RPA账号:',value =user_detail('Frpa') ),
                             textInput('cu_info_dept',label = '部门:',value =user_detail('Fdepartment') ),
                             textInput('cu_info_company',label = '公司:',value =user_detail('Fcompany') ),
                             
                             
                             footer = column(shiny::modalButton('确认(不保存修改)'),
                                             
                                             width=12),
                             size = 'm'
       ))
    })
    
    
    
    #针对用户信息进行处理
    
    sidebarMenu <- reactive({
       
       res <- setSideBarMenu(conn_rds('rdbe'),app_id,user_info()$Fpermissions)
       return(res)
    })
    
    
    #针对侧边栏进行控制
    output$show_sidebarMenu <- renderUI({
       if(credentials()$user_auth){
          return(sidebarMenu())
       } else{
          return(NULL) 
       }
       
       
    })
    
    #针对工作区进行控制
    output$show_workAreaSetting <- renderUI({
       if(credentials()$user_auth){
          return(workAreaSetting)
       } else{
          return(NULL) 
       }
       
       
    })
   
   
   #处理数据

    
    observeEvent(input$div22,{
      print(input$div22)
      output$txtShow2 <- renderPrint({
        print(input$div22)
        cat(input$div22)
      })
    })
    
   #读取数据原
    observeEvent(input$acct_preview,{
      run_dataTable2('acct_data_show',data = acctList)
    })
    #下载模板
    acct_tpl <- list(head(acctList,100))
    names(acct_tpl) <-'凭证调整分录'
    run_download_xlsx('acct_adj_tpl',data = acct_tpl,filename = '凭证调整分录模板下载.xlsx')
    
    #生成公司报表
    observeEvent(input$CorpRpt_gen,{
      row1 = c('Mgmt Report Code','Mgmt Report Name')
      col1 = c('部门')
      myform = dcast_getFormula(row1,col1)
      data <- reshape2::dcast(data = acctList,formula = myform,fun.aggregate = sum,value.var = 'Transactiona Amount (Dr+/Cr.-)')
      run_dataTable2('CorpRpt_dataShow',data = data)
      
    })
    #显示现金流量表
    observeEvent(input$cf_gen,{
      row1 = c('Cashflow code')
      col1 = c('会计年月')
      myform = dcast_getFormula(row1,col1)
      data <- reshape2::dcast(data = acctList,formula = myform,fun.aggregate = sum,value.var = 'Transactiona Amount (Dr+/Cr.-)')
      run_dataTable2('cf_dataShow',data = data)
      
    })
    #生成项目报表
    observeEvent(input$prj_gen,{
      row1 = c('Mgmt Report Code','Mgmt Report Name')
      col1 = c('Project')
      myform = dcast_getFormula(row1,col1)
      data <- reshape2::dcast(data = acctList,formula = myform,fun.aggregate = sum,value.var = 'Transactiona Amount (Dr+/Cr.-)')
      run_dataTable2('prj_dataShow',data = data)
      
    })
    
    #生产OLAP报表
    var_olap_row <- var_ListChooseN('olap_row')
    var_olap_col <- var_ListChooseN('olap_col')
    var_olap_value <- var_ListChoose1('olap_value')
    observeEvent(input$olap_gen,{
      row1 <- var_olap_row()
      print(row1)
      col1 <- var_olap_col()
      print(col1)
      value1 <- var_olap_value()
      print(value1)
      myform <- dcast_getFormula(row1,col1)
      
      data<- reshape2::dcast(data = acctList,formula = myform,fun.aggregate = sum,value.var = value1)
      
      run_dataTable2('olap_dataShow',data = data)
      run_download_xlsx('olap_dl',data = data,filename = '凭证OLAP多维分析报表下载.xlsx')
      
      
    })
    
    
  
})
