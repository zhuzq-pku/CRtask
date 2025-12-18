library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse) 

data <- read_excel("~/Desktop/FC.xlsx")

original_colnames <- colnames(data)
fc1_name <- original_colnames[2]
fc2_name <- original_colnames[3]

colnames(data) <- c("Subject", "FC1", "FC2", "Group")

# 准备长格式数据
data_long <- data %>%
  tidyr::pivot_longer(cols = c(FC1, FC2), 
                      names_to = "FC_Type", 
                      values_to = "Value") %>%
  mutate(FC_Label = ifelse(FC_Type == "FC1", fc1_name, fc2_name))

# 计算统计量
stats <- data_long %>%
  group_by(FC_Label, Group) %>%
  summarise(
    mean = mean(Value, na.rm = TRUE),
    se = sd(Value, na.rm = TRUE) / sqrt(n()),
    .groups = 'drop'
  )

# 进行t检验
get_significance <- function(df, fc_label) {
  fc_data <- df %>% filter(FC_Label == fc_label)
  aADHD_data <- fc_data %>% filter(Group == "aADHD") %>% pull(Value)
  HC_data <- fc_data %>% filter(Group == "HC") %>% pull(Value)
  
  test_result <- t.test(aADHD_data, HC_data)
  p_value <- test_result$p.value
  
  if (p_value < 0.001) {
    return(list(sig = "***", p = p_value))
  } else if (p_value < 0.005) {
    return(list(sig = "**", p = p_value))
  } else if (p_value < 0.05) {
    return(list(sig = "*", p = p_value))
  } else {
    return(list(sig = "ns", p = p_value))
  }
}

# 计算两个FC的显著性
sig1 <- get_significance(data_long, fc1_name)
sig2 <- get_significance(data_long, fc2_name)

# 定义新的标签向量
new_fc_labels <- c("FC1", "FC2")

# 设置颜色
colors <- c("aADHD" = rgb(231/255, 214/255, 150/255),
            "HC" = rgb(155/255, 211/255, 215/255))
dcolors <- c("aADHD" = rgb(219/255, 160/255, 22/255),
            "HC" = rgb(20/255, 153/255, 165/255))

# 为每个FC类型和组创建x轴位置
data_long <- data_long %>%
  mutate(x_pos = case_when(
    FC_Label == fc1_name & Group == "aADHD" ~ 1.0,
    FC_Label == fc1_name & Group == "HC" ~ 1.4,
    FC_Label == fc2_name & Group == "aADHD" ~ 2.1,
    FC_Label == fc2_name & Group == "HC" ~ 2.5
  ))

stats <- stats %>%
  mutate(x_pos = case_when(
    FC_Label == fc1_name & Group == "aADHD" ~ 1.0,
    FC_Label == fc1_name & Group == "HC" ~ 1.4,
    FC_Label == fc2_name & Group == "aADHD" ~ 2.1,
    FC_Label == fc2_name & Group == "HC" ~ 2.5
  ))

# 计算统一的显著性标记高度
global_max <- max(stats$mean + stats$se, data_long$Value, na.rm = TRUE)
sig_y <- global_max * 1.12

# 创建图形
p <- ggplot() +
  # 柱状图 - 边框和填充都使用对应组的颜色
  geom_bar(data = stats, 
           aes(x = x_pos, y = mean, fill = Group, color = Group),
           stat = "identity", alpha = 0.5, width = 0.35, linewidth = 0.35) +
  # 散点
  geom_jitter(data = data_long, 
              aes(x = x_pos, y = Value, color = Group),
              width = 0.08, size = 1.85, alpha = 0.7) +
  # errorbar在散点上方
  geom_errorbar(data = stats, 
                aes(x = x_pos, ymin = mean - se, ymax = mean + se),
                width = 0.06, linewidth = 0.35, color = "black") +

  geom_hline(yintercept = 0, linetype = "solid", color = "grey60", linewidth = 0.3) +

  geom_vline(xintercept = 1.75, linetype = "dashed", color = "grey50", linewidth = 0.4) +
  # FC1的显著性标记
  annotate("segment", x = 1.0, xend = 1.4, y = sig_y - 0.02 * global_max, 
           yend = sig_y - 0.02 * global_max, linewidth = 0.5, color = "black") +
  annotate("text", x = 1.2, y = sig_y, label = sig1$sig, size = 5) +
  # FC2的显著性标记
  annotate("segment", x = 2.1, xend = 2.5, y = sig_y - 0.02 * global_max, 
           yend = sig_y - 0.02 * global_max, linewidth = 0.5, color = "black") +
  annotate("text", x = 2.3, y = sig_y, label = sig2$sig, size = 5) +
  # 颜色设置
  scale_fill_manual(values = colors) +
  scale_color_manual(values = dcolors) +
  # 标签刻度
  scale_x_continuous(breaks = c(1.2, 2.3), labels = new_fc_labels) +
  scale_y_continuous(breaks = c(-2, -1, 0, 1, 2), labels = c("-2", "-1", "0", "1", "2")) +
  labs(y = "FC during CR", x = "") +
  theme_classic() +
  theme(
    panel.grid = element_blank(),
    legend.position = "right",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    axis.title.y = element_text(size = 15, face = "bold"),
    axis.title.x = element_text(size = 15, face = "bold"),
    axis.text.x = element_text(size = 11, face = "bold"),
    axis.text.y = element_text(size = 10),
    axis.line = element_line(linewidth = 0.5), 
    axis.ticks = element_line(linewidth = 1)
  ) +
  ylim(NA, sig_y * 1.05)

# 显示图形
print(p)

# 保存图片
ggsave("FC_group_comparison.png", plot = p, 
       width = 6.5, height = 6, dpi = 300)

