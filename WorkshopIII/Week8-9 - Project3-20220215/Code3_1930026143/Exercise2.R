# 1- Install and load libraries
library(tuneR)
library(seewave)
# setwd("E:/Desktop_xsj/Desktop/Second Semester of Junior/WorkshopIII/Week8-9 - Project3-20220215/data/")
path <- "E:/Desktop_xsj/Desktop/Second Semester of Junior/WorkshopIII/Week8-9 - Project3-20220215/data/"


# 2- Play a file
tuneR::play(paste0(path, "Allobates_femoralis.wav"))


# 3- Generate a sound
# A duration of 3 seconds
t = seq(0, 3, 1/8000)
# 440 Hz sine wave 
u = (2^15 - 1) * sin(2 * pi * 440 * t)
# Generate the wave 
w = Wave(u, samp.rate = 8000, bit=16)

# Get the values number, min, max, and mean values.
summary(u)
summary(w) # Same as u

tuneR::play(w)


# 4- Play a series of notes 
sr = 8000;   # The sampling rate used in playing function
tatum= .1;   # The length of time (secs) of the smallest musical time unit


playit <- function(f, fname){ 
    h <- NULL; 
    bits <- 16       # bit depth 
    f[f<1] <-  f[f<1] + 8 
    for (i in 1:length(f)){ 
        fr = 440 * 2^((f[i]-69) / 12); 
        h = c(h, rep(fr, sr * tatum)) 
    } 
    y = sin(2 * pi * cumsum(h / sr)) 
    u = Wave(2^(bits-4) * y,samp.rate=sr, bit=bits) 
    tuneR::play(u) 
    savewav(u, filename=fname)
}

# Initialization 
lo <- 80;  
hi <- 100; 
p <- .8 
notes <- 50 
s <- rep(0,notes); 
s[1] <- lo; 
up <- 1 

# fill out the list s
for (i in 2:notes){ 
    if (up){  # up==1
        s[i] <- min(s[i-1]+1, hi);  
    }  # if up move upward if possible 
    else{ 
        s[i] <- max(lo, s[i-1]-1);
    } 
    # Generate the random music
    if (runif(1) > p) 
        up <- 1-up; 
}

playit(s, "output_file.wav")

table1 <-data.frame("Midivalue" = seq(68,100), "American notation" = 
                      c("G","A","A","B","C","C","D","D","E","F",
                        "F","G","G","A","A","B","C","C","D","D",
                        "E","F","F","G","G","A","A","B","C","C",
                        "D","D","E")) 

# Note:	     C	 D	 E	 F	 G	 A	 B
# Syllable:	DO	RE	MI	FA	SOL	LA	SI
playit(c(91, 91, 1, 91, 91, 1, 91, 91, 1, 87, 87, 87, 87, 87,
         87, 87, 1, 89, 89, 1, 89, 89, 1, 89, 89, 1, 86, 86, 
         86, 86, 86, 86, 86) , paste0(path,"beethoven.wav"))

transcribeMusic <- function(wavFile, widthSample = 4096) {
    perioWav <- periodogram(wavFile, width = widthSample ) 
    freqWav <- FF(perioWav) 
    noteWav <- noteFromFF(freqWav) 
    noteWavNames <- noteWav[!is.na(noteWav)] 
    print(noteWavNames) 
    print(notenames(noteWavNames)) 
    return(notenames(noteWavNames)) 
} 

playit(c(92, 92, 94, 98, 92, 93, 91, 1, 1, 1, 93, 92, 
         93, 94, 93, 93, 92) , paste0(path,"bird.wav"))

originalSound <- readWave("Allobates_femoralis.wav")
notes = transcribeMusic(originalSound)


# Convert the files in wave format
wav_ch_mp <- readMP3("champagne.mp3")
wav_vo_mp <- readMP3("Vonstroke.mp3")
writeWave(wav_ch_mp, filename = paste0(path, "champagne.wav")) 
writeWave(wav_vo_mp, filename = paste0(path, "Vonstroke.wav"))


wav_ch <- readWave( paste0(path, "champagne.wav")) 
wav_vo <- readWave( paste0(path, "Vonstroke.wav"))
wav_ch_1 <- extractWave(wav_ch, from = 0, to = 3, xunit = "time") 
wav_ch_2 <- extractWave(wav_ch, from = 3, to = 6, xunit = "time") 
wav_ch_3 <- extractWave(wav_ch, from = 6, to = 9, xunit = "time") 
wav_vo_1 <- extractWave(wav_vo, from = 0, to = 3, xunit = "time") 
wav_vo_2 <- extractWave(wav_vo, from = 3, to = 6, xunit = "time") 
wav_vo_3 <- extractWave(wav_vo, from = 6, to = 9, xunit = "time") 

combi <- bind( wav_ch_1 , wav_vo_1, wav_ch_2, wav_vo_2, wav_ch_3, wav_vo_3) 
tuneR::play(combi)

wav_ch_mp <- readMP3("champagne.mp3") 
wav_el_mp <- readMP3("electro.mp3") 
writeWave(wav_ch_mp, filename = paste0(path, "champagne.wav") ) 
writeWave(wav_el_mp, filename = paste0(path, "electro.wav") )

wav_ch <- readWave( paste0(path, "champagne.wav") ) 
wav_el <- readWave( paste0(path, "electro.wav") )  # this is mono, only has left channel
wav_ch_1 <- extractWave(wav_ch, from = 1, to = 500000) 
wav_ch_2 <- extractWave(wav_el, from = 1, to = 500000)
www = Wave(wav_ch_1@left+wav_ch_2@left, samp.rate= 44100, bit=16) #if one is mono
tuneR::play(normalize(www, unit=c("16")))

www = Wave(wav_ch_1@right+wav_ch_2@left, samp.rate= 44100, bit=16) #if one is mono
tuneR::play(normalize(www, unit=c("16")))

# Harmonious music
wav_sa_mp <- readMP3("satie_gymnopedie_no_1.mp3")
wav_lo_mp <- readMP3("bass-lounge.mp3") 
writeWave(wav_sa_mp, filename = paste0(path, "satie_gymnopedie_no_1.wav") ) 
writeWave(wav_lo_mp, filename = paste0(path, "bass-lounge.wav") )

wav_sa <- readWave( paste0(path, "satie_gymnopedie_no_1.wav") ) 
wav_lo <- readWave( paste0(path, "bass-lounge.wav") ) 
wav_ch_1 <- extractWave(wav_sa, from = 400001, to = 1400000) 
wav_ch_2 <- extractWave(wav_lo, from = 1, to = 1000000) 
www = wav_ch_1+wav_ch_2 
writeWave(www, filename= paste0(path,"satie-lounge.wav")) 
tuneR::play(normalize(www, unit=c("16")))


# Mix step 9 and step 10
wav_ch_mp <- readMP3("electro.mp3")
wav_vo_mp <- readMP3("Vonstroke.mp3")
writeWave(wav_ch_mp, filename = paste0(path, "electro.wav") ) 
writeWave(wav_vo_mp, filename = paste0(path, "Vonstroke.wav") )

# Concatenate the two music in a single one, and export it as one wav file.
combi = bind( wav_ch_mp , wav_vo_mp ) 
tuneR::play(combi)
writeWave(combi, filename = paste0(path, "two_my.wav"))

wav_ch <- readWave( paste0(path, "electro.wav") )
wav_vo<- readWave( paste0(path, "Vonstroke.wav") )
wav_ch_1 <- extractWave(wav_ch, from = 0, to = 3, xunit = "time") 
wav_ch_2 <- extractWave(wav_ch, from = 3, to = 6, xunit = "time") 
wav_ch_3 <- extractWave(wav_ch, from = 6, to = 9, xunit = "time") 
wav_vo_1 <- extractWave(wav_vo, from = 0, to = 3, xunit = "time") 
wav_vo_2 <- extractWave(wav_vo, from = 3, to = 6, xunit = "time") 
wav_vo_3 <- extractWave(wav_vo, from = 6, to = 9, xunit = "time") 
combi <- bind( wav_ch_1 , wav_vo_1, wav_ch_2, wav_vo_2, wav_ch_3, wav_vo_3) 
tuneR::play(combi)

wav_ch_mp <- readMP3("Vonstroke.mp3")
wav_el_mp <- readMP3("electro.mp3")
writeWave(wav_ch_mp, filename = paste0(path, "Vonstroke.wav") ) 
writeWave(wav_el_mp, filename = paste0(path, "electro.wav") )
wav_ch <- readWave( paste0(path, "Vonstroke.wav") ) 
wav_el <- readWave( paste0(path, "electro.wav") )  # this is mono, only has left channel
wav_ch_1 <- extractWave(wav_ch, from = 1, to = 500000) 
wav_ch_2 <- extractWave(wav_el, from = 1, to = 500000)
www <- Wave(wav_ch_1 @ left + wav_ch_2 @ left, samp.rate= 44100, bit=16) #if one is mono
tuneR::play(normalize(www, unit=c("16")))


