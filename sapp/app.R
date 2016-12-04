# Single file version of Shiny
# http://shiny.rstudio.com/articles/single-file.html

library(shiny)
library(data.table)
library(ccfun)
cc <- readRDS(file="../data/cc.RDS")
data_fields <- yaml::yaml.load_file("../config/data_fields.yaml")
ccfun::relabel_cols(cc, "NHICcode", "shortName", dict=data_fields)
setnames(cc, "episode_id", "id")

pts.n <- uniqueN(cc$id)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(cc[id %in% sample(cc$id, input$pts)]$hrate)
    # hist(rnorm(input$obs), col = 'skyblue', border = 'white')
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
        img(src = "ccd-logo.png", height=72),
        h2("Sidebar heading 2"),
        sliderInput("pts", "Number of patients:", min = 1, max = pts.n, value = 10)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

shinyApp(ui = ui, server = server)