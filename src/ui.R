ui <- shinyUI(fluidPage(
    tags$head(tags$style(HTML("
    .shiny-text-output {
      background-color:#fff;
    }
  "))),
    
    h1("BIP", span("Basic Image Processing", style = "font-weight: 300"), 
       style = "font-family: 'Source Sans Pro';
        color: #fff; text-align: center;
        background-image: url('texturebg.png');
        padding: 20px"),
    br(),
  sidebarLayout(
    sidebarPanel(
      fileInput(inputId = 'files', 
                label = 'Select an Image',
                accept=c('image/bmp', 'image/bmp','.bmp'))
    ),
    mainPanel(
        tableOutput('hdr'),
      uiOutput('images')
    )
  )
))