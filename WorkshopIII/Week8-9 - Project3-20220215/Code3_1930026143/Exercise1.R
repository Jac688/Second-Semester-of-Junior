install.packages("seewave")
install.packages("tuneR")
library(seewave)
library(tuneR)

# Change the working directory 
setwd("E:/Desktop_xsj/Desktop/Second Semester of Junior/WorkshopIII/Week8-9 - Project3-20220215/data")


### 1. start
# Read and get the .wav file
s <- readWave("Allobates_femoralis.wav")
s

# Get the class of the wave
class(s)

# Get the duration of the wave
duration(s)


### 2. oscillogram
# Visualizes as an oscillo gram
oscillo(s)

# Listen in the s, it will open the player can play the sound.
listen(s)


# From the graph, we can find that there are four calls.
# The first call is from 0 to around 0.3.
# The last call is approximately from 1.1 to 1.4

# c1 contains only the first call
c1 <- extractWave(s, from=0, to=.3, xunit="time")

# Visualizes the pitch as oscillo gram
oscillo(c1)

# Save c1 object into a new audio file
savewav(c1, filename = "Allobates_femoralis_c1.wav")


### 3. Temporal Analysis
# Take manual time measurements to c1
timer(c1, ssmooth=300, threshold=3)


### 4. Dominant frequency
spectro(c1)
spectro(c1, l=1024, ovlp=87.5)


plot.new()
df <- dfreq(c1, threshold=5, wl=1024, ovlp=87.5)

plot.new()
fund(c1, threshold=5, wl=1024, ovlp=87.5, fmax=2000)


### 5. Spectral analysis
timer <- timer(c1, ssmooth=300, threshold=3, plot = FALSE)

timer

# Compute the mean frequency spectrum of c1
specmean <- meanspec(c1, plot=FALSE, from=timer$.start[1], to=timer$s.end[2], col="red")
head(specmean, 10)

# Find the main frequency peaks
fpeaks(specmean, amp=c(0.01, 0.01))

# Get the main properties
specprop(specmean)


# Find the dominant frequency
domfreq <- specmean[which.max(specmean[,2]), ]
domfreq

# Plot with meanspec
plot.new()
meanspec(c1, from=timer$s.start[1], to=timer$s.end[2], lwd=2, col="red")

# Plot the spectrogram of frequencie
plot.new()
soundscapespec(c1)
