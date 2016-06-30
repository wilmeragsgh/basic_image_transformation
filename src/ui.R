ui <- shinyUI(
    fluidPage(
        tags$head(
            tags$style(
                HTML("
                    .shiny-text-output {
                      background-color:#fff;
                    }
                    .table.data{
                    width: 100%;
                    }
                    #exportImage{
                    margin-left: 25%;
                    }")
                )
            ),
        h1("BIT", 
            span("Basic Image Transformation", style = "font-weight: 300"), 
            style = "font-family: 'Source Sans Pro';
                color: #fff; text-align: center;
                background-image: url('texturebg.png');
                padding: 1%"
           ),
        br(),
        fluidRow(
            column(6,
                   offset = 4,
                   sidebarPanel(
                       width=8,
                       style = 'align: center; text-align: center',
                       fileInput(inputId = 'files', 
                           label = 'Select an Image',
                           accept=c('image/bmp', 'image/bmp','.bmp')
                           )
                       )
                   )
            ),
        hr(),
        tableOutput('hdr'),
        fluidRow(
            column(8,
                   offset=1,
                   wellPanel(
                       uiOutput(
                           'images',
                           style = 'overflow: auto'
                           )
                       )
                   ),
            column(2,
                   actionButton('reloadInput',
                                'Reload image',
                                style = 'margin-left: 20%'),
                   hr(),
                   wellPanel(
                       h5('Negative:',
                          style = 'font-weight: 700; text-align: center'
                          ),
                       actionButton(
                           'negativeT',
                           'Go!',
                           style = 'margin-left: 35%'
                           ),
                       hr(),
                       sliderInput(
                           "degrees", 
                           "Rotation:",
                           min=-270, 
                           max=270, 
                           value=0
                           ),
                       hr(),
                       h5('Mirroring:',
                           style = 'font-weight: 700; text-align: center'
                           ),
                       fluidRow(
                       actionButton('MirrorV',
                                    'V',
                                    style = 'margin-left: 25%'
                                    ),
                       actionButton('MirrorH',
                                    'H',
                                    style = 'margin-left: 10%'
                                    )
                           )
                   ),
                   downloadButton('exportImage',
                                      'Export')
                )
        )
    )
)