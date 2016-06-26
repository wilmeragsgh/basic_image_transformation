options(shiny.maxRequestSize=30*1024^2)

shinyServer(function(input, output) {
      output$files <- renderTable(input$files)
      
      files <- reactive({
        files <- input$files
        arc <- file(files$datapath,'rb')
        files$datapath <- gsub("\\\\", "/", files$datapath)
        headr <- c()
        headr <- cbind(headr,firm = readBin(arc,what = integer(),size = 2))
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
        image_output_list <- 
          lapply(1:nrow(files()),
                 function(i)
                 {
                   imagename = paste0("image", i)
                   imageOutput(imagename)
                 })
        
        do.call(tagList, image_output_list)
      })
      
      observe({
        if(is.null(input$files)) return(NULL)
        for (i in 1:nrow(files()))
        {
          print(i)
          local({
            my_i <- i
            imagename = paste0("image", my_i)
            print(imagename)
            output[[imagename]] <- 
              renderImage({
                list(src = files()$datapath[my_i],
                     alt = "Image failed to render")
              }, deleteFile = FALSE)
          })
        }
      })
      
    })