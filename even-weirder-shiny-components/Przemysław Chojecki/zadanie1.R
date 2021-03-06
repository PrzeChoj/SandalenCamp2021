library(shiny)

shinyApp(
  ui = fluidPage(uiOutput("sliders")),
  
  server = function(input, output, session) {
    rv <- reactiveValues(number_of_sliders = 1)
    
    observeEvent(input[["input_slider1"]], {
      if(is.null(input[["input_slider1"]])) {
        number_of_sliders <- 1
      } else {
        number_of_sliders <- input[["input_slider1"]]
      }
      
      rv[["number_of_sliders"]] <- number_of_sliders
    })
    
    output[["sliders"]] <- renderUI({
      lapply(1L:rv[["number_of_sliders"]], function(ith_slider) {
        sliderInput(inputId = paste0("input_slider", ith_slider),
                    label = "Select the number of sliders", 
                    min = 1, max = 10, value = 1, 
                    step = 1)
      })
    })
    
    observe({
      updateSliderInput(session, "input_slider1", value = rv[["number_of_sliders"]])
    })
  }
)
