sal_PT30_B = readImage("~/To/My/Image")
display(sal_PT30_B, method="raster")
imageData(sal_PT30_B)
hist(sal_PT30_B)
grayimage<-channel(sal_PT30_B,"gray")
display(grayimage, method="raster")
img_crop = grayimage[,1:450]
img_thresh = img_crop > .5
display(sal_PT30_B)
display(img_crop)

img_median = medianFilter(img_crop, 5)
display(img_median)
#my_array = as.array(img_median)

threshold = otsu(img_median)
nuc_th = combine( mapply(function(frame, th) frame > th, getFrames(img_median), threshold, SIMPLIFY=FALSE) )
nmask = watershed( distmap(nuc_th), 2 )

nmask = thresh(nmask, w=10, h=10, offset=0.05)
nmask = opening(nmask, makeBrush(5, shape='disc'))
nmask = fillHull(nmask)
nmask = bwlabel(nmask)

display(colorLabels(nmask), all=TRUE)



display(nuc_th)
ft = computeFeatures.shape(nmask)
hist(ft)
df = data.frame(ft)
barplot(df$s.area)
hist(df$s.area)
write.csv(df, file= "~/Desktop/Pres_2-7-22/test.csv")

df = df[df$s.area > 100]

voronoiExamp = propagate(seeds = nmask, x = nmask, lambda = 100)
voronoiPaint = colorLabels (voronoiExamp)
display(voronoiPaint)


ft.area = computeFeatures.shape(voronoiExamp)
write.csv(ft.area, file= "~/Desktop/Pres_2-7-22/test_area.csv")
