ui <- shinyUI(fluidPage(
    tags$head(tags$style(HTML("
    .shiny-text-output {
      background-color:#fff;
    }
    .table.data{
    width: 100%;
    }
  "))),
    
    h1("BIP", span("Basic Image Processing", style = "font-weight: 300"), 
       style = "font-family: 'Source Sans Pro';
        color: #fff; text-align: center;
        background-image: url('texturebg.png');
        padding: 1%"),
    br(),
    fluidRow(column(6,offset = 4,sidebarPanel(width=8,style = 'align: center; text-align: center',fileInput(inputId = 'files', 
                       label = 'Select an Image',
                       accept=c('image/bmp', 'image/bmp','.bmp'))))),
    hr(),
        tableOutput('hdr'),
    fluidRow(column(4,offset=1,wellPanel(uiOutput('images',style = 'overflow: auto'))),
             column(3,actionButton('negativeT','Negative')),
             column(4,offset=2,wellPanel(p('imgT'))))
))