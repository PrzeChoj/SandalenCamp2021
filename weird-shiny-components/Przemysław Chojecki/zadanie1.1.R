library(shiny)
library(ggplot2)

ui <- fluidPage(title = "Let's do components",
                plotOutput("iris_plot", hover = "iris_plot_hover"),
                uiOutput("iris_plot_tooltip"))

server <- function(input, output) {
  
  output[["iris_plot"]] <- renderPlot({
    ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
      geom_point()
  })
  
  output[["iris_plot_tooltip"]] <- renderUI({
    
    if(!is.null(input[["iris_plot_hover"]])) {
      
      hv <- input[["iris_plot_hover"]]
      
      tt_df <- nearPoints(iris, hv, maxpoints = 1)
      
      if(nrow(tt_df) != 0) { 
        
        tt_pos_adj <- ifelse(hv[["coords_img"]][["x"]]/hv[["range"]][["right"]] < 0.5,
                             "left", "right")
        
        tt_pos <- ifelse(hv[["coords_img"]][["x"]]/hv[["range"]][["right"]] < 0.5,
                         hv[["coords_css"]][["x"]], 
                         hv[["range"]][["right"]]/hv[["img_css_ratio"]][["x"]] - hv[["coords_css"]][["x"]])
        
        
        style <- paste0("position:absolute; z-index:1000; background-color: rgba(245, 245, 245, 1); pointer-events: none;",
                        tt_pos_adj, ":", tt_pos, 
                        "px; top:", hv[["coords_css"]][["y"]], "px; padding: 0px;")
        
        div(
          style = style,
          p(HTML(paste0("Species: ", tt_df[["Species"]],
                        "<br/> Sepal length: ", tt_df[["Sepal.Length"]],
                        "<br/> Petal Length: ", tt_df[["Petal.Length"]])))
        )
      }
    }
  })
  
}

shinyApp(ui, server)