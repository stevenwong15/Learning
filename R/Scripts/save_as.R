#================================================================================= 
# save as .pdf or .eps file in the current directory
#=================================================================================
save_as <- function(name, h, w) {

  type = strsplit(name, '\\.')[[1]][2]

  # PDF
  if (type == 'pdf') {
  	dev.copy(device = pdf, file = name, height = h, width = w, 
  	         onefile = F, paper = "special")
  
  # SVG
  } else if (type == 'svg') {
    dev.copy(device = svg, file = name, height = h, width = w, 
             onefile = F)

  # EPS
  } else if (type == 'eps') {
  	dev.copy(device = postscript, file = name, height = h, width = w, 
  	         horizontal = F, onefile = F, paper = "special")
  }

  dev.off()
}