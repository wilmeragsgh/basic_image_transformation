library('Rcpp')

#system('export PKG_CXXFLAGS=`Rscript -e "Rcpp:::CxxFlags()"`')
#system('export PKG_LIBS=`Rscript -e "Rcpp:::LdFlags()"`')

#system('R CMD SHLIB trial.cpp')
dyn.load('../build/trial.so')

options(shiny.maxRequestSize=30*1024^2)

shinyServer(function(input, output) {

# reading image:
    output$files <- renderTable(input$files)
    
    files <- reactive({
        files <- input$files
        arc <- file(files$datapath,'rb')
        # creating the table:
        headr <- c()
        readBin(arc,what = integer(),size = 2)
        headr <- cbind(headr,filesize = readBin(arc,what = integer(),size = 4))
        readBin(arc,what = integer(),size = 4) #skipping reserved
        readBin(arc,what = integer(),size = 4) #skipping offset 
        readBin(arc,what = integer(),size = 4) #skipping headersize
        headr <- cbind(headr,width = readBin(arc,what = integer(),size = 4))
        headr <- cbind(headr,height = readBin(arc,what = integer(),size = 4))
        headr <- cbind(headr,colourPlanes = readBin(arc,what = integer(),size = 2))
        headr <- cbind(headr,bitsPerPixel = readBin(arc,what = integer(),size = 2))
        headr <- cbind(headr,compressionType = readBin(arc,what = integer(),size = 4))
        headr <- cbind(headr,imageSize = readBin(arc,what = integer(),size = 4))
        headr <- cbind(headr,xResolution = readBin(arc,what = integer(),size = 4))
        headr <- cbind(headr,yResolution = readBin(arc,what = integer(),size = 4))
        headr <- cbind(headr,nColors = readBin(arc,what = integer(),size = 4))
        headr <- cbind(headr,impColors = readBin(arc,what = integer(),size = 4))
        close(arc)
        output$hdr <- renderTable(as.data.frame(headr))
        files
    })
    
      output$images <- renderUI({
        if(is.null(input$files)) return(NULL)
        if(input$reloadInput > 0){
            image_output_list <- list(imageOutput('image1'))
            do.call(tagList, image_output_list)  
        } else
            if(input$negativeT > 0){
                image_output_list <- list(imageOutput('image1'))
                do.call(tagList, image_output_list)  
            } else
          image_output_list <- list(imageOutput('image1'))
          do.call(tagList, image_output_list)
      })
      
      observe({
          if(is.null(input$files)) return(NULL)
          local({
              output[['image1']] <- 
                  renderImage({
                      list(src = files()$datapath,
                           alt = "Image failed to render")
                  }, deleteFile = F)
          })
      })

# processing transformation:

# reload image:      
      observe({
          if(input$reloadInput == 0) return(NULL)
          local({
              output[['image1']] <- 
                  renderImage({
                      list(src = files()$datapath,
                           alt = "Image failed to render")
                  }, deleteFile = F)
          })
      })
#/      
# image negative:
      observe({
          if(input$negativeT == 0) return(NULL)
          local({
              print(files()$datapath)
              print(route <- .Call('readData',files()$datapath))
              output[['image1']] <- 
                  renderImage({
                      list(src = route,
                           alt = "Image failed to render")
                  }, deleteFile = F)
          })
      })
      
# downloader:
      output$exportImage <- downloadHandler(
          filename = function() { 
              paste(
                  unlist(
                      strsplit(
                          tail(
                              unlist(
                                  strsplit(input$files$datapath,
                                           split = '/'
                                  )
                              ),
                              n = 1
                          ),
                          split = '.',
                          fixed = T
                      )
                  )[1],
                  '_Processed',
                  '.bmp', 
                  sep='') 
          },
          content = function(file) {
              imgInput <- load.image(input$files$datapath)
              bmp(file)
              plot(imgInput)
              dev.off()
          }
      )
#/
    })