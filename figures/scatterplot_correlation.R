library("carData")
library("car")
library(ggplot2)
setwd("~/Desktop/figure")

######## clinical traits ##############
demo <- read.spss("~/Desktop/demo.sav", to.data.frame = TRUE)
x <- demo[c(27:67)]  

############ gPPI-fc#######
data1 <-read.xlsx("~/Desktop/Second_FC_Reappraisal.xlsx")
y <- subset(data1, select = -ID)

############## plot ############

plot_data <- data.frame(
  sigX = as.numeric(x$CR),              
  sigY = as.numeric(y$FC), 
  Group = as.factor(demo$diagnosis)       
)

plot_data$Group <- ifelse(plot_data$Group == 1, "aADHD", 
                          ifelse(plot_data$Group == 2, "HC", NA))

dcolors <- c("aADHD" = rgb(219/255, 160/255, 22/255),
             "HC" = rgb(20/255, 153/255, 165/255))
colors <- c("aADHD" = rgb(231/255, 214/255, 150/255),
            "HC" = rgb(155/255, 211/255, 215/255))
line_colors <- c("aADHD" = rgb(175/255, 128/255, 18/255),
                 "HC"    = rgb(16/255, 122/255, 132/255))

p1 <- ggplot(plot_data, aes(x = sigX, y = sigY, color = Group, fill = Group)) + 
  
  # y=0的横线
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey15", linewidth = 0.5) +
  # 散点图
  geom_smooth(aes(color = Group, fill = Group), 
              method = "lm", size = 1.0, se = FALSE, alpha = 0.15) + 
  
  geom_point(aes(fill = Group), shape = 21, size = 3, color = "white", stroke = 0.2, alpha = 0.75) +
  
  scale_color_manual(values = line_colors) +  
  scale_fill_manual(values = dcolors) +     
  
  labs(x = "CR", 
       y = "FC") +
  
  scale_x_continuous(breaks = seq(10, 40, by = 10)) + 
  scale_y_continuous(breaks = seq(-5, 5, by = 2.5)) +

  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.title = element_blank(),
        
        axis.title.x = element_text(size = 14, face = "bold"), 
        axis.title.y = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12), # 刻度文字
  
        legend.text = element_text(size = 12)
  )

print(p1)

ggsave("Plot_FC_CR.jpg", plot = p1, width=5, height=4.8, units = "in", dpi=300)

