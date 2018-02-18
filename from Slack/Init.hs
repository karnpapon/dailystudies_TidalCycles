module Init where

import Sound.Tidal.SpectralTricks

import Sound.Tidal.Utils

import Data.Maybe

import Control.Applicative

:def hoogi (\x -> return $ ":!/Users/jarm/.cabal/bin/hoogle --info "++x)

(accel,_)      = pF "accel"      (Just 0)
(bits,_)       = pI "bits"       (Just 0)
(carPartial,_) = pF "carPartial" (Just 0)
(detune,_)     = pF "detune"     (Just 0)
(fm,_)         = pF "fm"         (Just 0)
(fmf,_)        = pF "fmf"        (Just 0)
(fmod,_)       = pF "fmod"       (Just 0)
(freq,_)       = pI "freq"       (Just 80)
(index,_)      = pI "index"      (Just 0)
(kcutoff,_)    = pF "kcutoff"    (Just 0)
(krush,_)      = pF "krush"      (Just 0)
(modPartial,_) = pF "modPartial" (Just 0)
(modFreq,_)    = pF "modFreq"    (Just 100) -- bassfm
(modAmount,_)  = pF "modAmount"  (Just 100) -- bassfm
(mul,_)        = pF "mul"        (Just 0)
(nharm,_)      = pI "nharm"      (Just 0)
(noisy,_)      = pF "noisy"      (Just 0)
(rate,_)       = pI "rate"       (Just 1)
(ring,_)       = pF "ring"       (Just 0)
(ringf,_)      = pF "ringf"      (Just 0)
(slide,_)      = pI "slide"      (Just 0)
(slidefrom,_)  = pI "slidefrom"  (Just 1)
(vib,_)        = pI "vib"        (Just 0)
(wah,_)        = pF "wah"        (Just 0)
(wahf,_)       = pF "wahf"       (Just 0)
-- TODO: turn ^ intro groups

-- FX groups
adsr = grp [attack_p,  decay_p, sustain_p, release_p]
del  = grp [delay_p,   delaytime_p, delayfeedback_p]
scc  = grp [shape_p,   coarse_p, crush_p]
lpf  = grp [cutoff_p,  resonance_p]
bpf  = grp [bandf_p,   bandq_p]
hpf  = grp [hcutoff_p, hresonance_p]
spa  = grp [speed_p,   accelerate_p]
rvb  = grp [room_p,    size_p]
gco  = grp [gain_p,    cut_p, orbit_p]
go   = grp [gain_p,    orbit_p]
io   = grp [begin_p,   end_p]
-- eq   = grp [cutoff_p,  resonance_p,bandf_p,   bandq_p,hcutoff_p, hresonance_p]
tremolo = grp [tremolorate_p, tremolodepth_p]
phaser  = grp [phaserrate_p,  phaserdepth_p]
-- TODO: add SpectralTricks / SC FX groups
-- FX groups' function version
adsr' a d s r = attack a # decay d # sustain s # release r 
del' l t f  = delay l # delaytime t # delayfeedback f
scc' s c c' = shape s # coarse c # crush c'
lpf' c r = cutoff c  # resonance r
bpf' f q = bandf f   # bandq q
hpf' c r = hcutoff c # hresonance r
spa' s a = speed s   # accelerate a
gco' g c o  = gain g # cut c # orbit o
go' g o  = gain g    # orbit o
rvb' r s = room r    # size s
io' i o  = begin i   # end o
eq h b l q = cutoff l # resonance q # bandf b # bandq q # hcutoff h # hresonance q
tremolo' r d = tremolorate r # tremolodepth d
phaser'  r d = phaserrate  r # phaserdepth  d

-- custom synth / param groups
ring' f r = ringf f # ring r
wah' f r = wahf f # wah r
superfmbass l f a = lfo l # modFreq f # modAmount a
bkfm a b c d e f = carPartial a # modPartial b # mul c # detune d # index e # nharm f
fmB a b c d e f = carPartial a # modPartial b # mul c # detune d # index e # nharm f

-- sequence generators    
r = run
ri a = rev (r a) -- run inverted
c = choose
odd    a = (((r a) + 1) * 2) - 1 -- run of odd numbers
even   a =  ((r a) + 1) * 2 -- run of even numbers
codd   a = c (patToList (odd   a)) -- choose odd
ceven  a = c (patToList (even  a)) -- choose even
oddi   a = rev (odd a) -- odd inverted
eveni  a = rev (even a) -- even inverted
coddi  a = rev (codd a) -- choose odd inverted
ceveni a = rev (ceven a) -- choose even inverted
-- TODO: primes ..?

-- transitions
j n  = jumpIn' n
j2   = jumpIn' 2
j4   = jumpIn' 4
j8   = jumpIn' 8
j16  = jumpIn' 16
xf n = xfadeIn  n
xf2  = xfadeIn  2
xf4  = xfadeIn  4
xf8  = xfadeIn  8
xf16 = xfadeIn  16
cl n = clutchIn n
cl2  = clutchIn 2
cl4  = clutchIn 4
cl8  = clutchIn 8
cl16 = clutchIn 16
swash = superwash

-- math/signal functions
sin = sine
cos = cosine
sq  = square
pulse w = sig $ \t -> if ((snd $ properFraction t) >= w) then 1.0 else 0.0
pulse' w = liftA2 (\a b -> if (a>=b) then 1.0 else 0.0) saw w
pw = pulse
pw' = pulse'
scale' from to p = (p*to - p*from) + from
sc' = scale'
sc  = scale
scx = scalex
sinf  f = fast f $ sin    -- sine at freq
cosf  f = fast f $ cos    -- cosine at freq
trif  f = fast f $ tri    -- triangle at freq
sawf  f = fast f $ saw   -- saw at freq
sqf   f = fast f $ sq     -- square at freq
pwf w f = fast f $ pw w -- pulse at freq
pwf' w f = fast f $ pw' w -- pulse' at freq
randf f = fast f $ rand   -- rand at freq
ssin  i o = sc  i o sin   -- scaled sine
scos  i o = sc  i o cos   -- scaled cosine
stri  i o = sc  i o tri   -- scaled triangle
ssaw i o = sc  i o saw   -- scaled saw
ssq   i o = sc  i o sq    -- scaled square
spw i o w = sc i o pw w -- scaled pulse
spw' i o w = sc i o pw' w -- scaled pulse'
srand i o = sc  i o rand  -- scaled rand
sxsin i o = scx i o sin   -- scaled exponential sine
sxcos i o = scx i o cos   -- scaled exponential cosine
sxtri i o = scx i o tri   -- scaled exponential triangle
sxsaw i o = scx i o saw  -- scaled exponential saw
sxsq  i o = scx i o sq    -- scaled exponential sqaure
sxpw i o w = scx i o pw w -- scaled exponential pulse
sxpw' i o w = scx i o pw' w -- scaled exponential pulse'
sxrand i o = scx i o rand -- scaled exponential rand
ssinf   i o f = fast f $ ssin   i o  -- scaled sine at freq
scosf   i o f = fast f $ scos   i o  -- scaled cosine at freq
strif   i o f = fast f $ stri   i o  -- scaled triangle at freq
ssawf  i o f = fast f $ ssaw   i o  -- scaled saw at freq
ssqf    i o f = fast f $ ssq    i o  -- scaled square at freq
spwf i o w f = fast f $ spw i o w -- scaled pulse at freq
srandf  i o f = fast f $ srand  i o  -- scaled rand at freq
sxsinf  i o f = fast f $ sxsin  i o  -- scaled exponential sine at freq
sxcosf  i o f = fast f $ sxcos  i o  -- scaled exponential cosine at freq
sxtrif  i o f = fast f $ sxtri  i o  -- scaled exponential triangle at freq
sxsawf  i o f = fast f $ sxsaw i o  -- scaled exponential saw at freq
sxsqf   i o f = fast f $ sxsq   i o  -- scaled exponential square at freq
sxpwf i o w f = fast f $ sxpw i o w -- scaled exponential pulse at freq
sxpwf' i o w f = fast f $ sxpw' i o w -- scaled exponential pulse' at freq
sxrandf i o f = fast f $ sxrand i o  -- scaled exponential random at freq
ssin'  i o = sc'  i o sin  -- scaled' sine
scos'  i o = sc'  i o cos  -- scaled' cosine
stri'  i o = sc'  i o tri  -- scaled' triangle
ssaw' i o = sc'  i o saw  -- scaled' saw
ssq'   i o = sc'  i o sq   -- scaled' square
srand' i o = sc' i o rand  -- scaled' rand
ssinf' i o f = fast f $ ssin'   i o -- scaled' sine at freq
scosf' i o f = fast f $ scos'   i o -- scaled' cosine at freq
strif' i o f = fast f $ stri'   i o -- scaled' triangle at freq
ssawf' i o f = fast f $ ssaw'  i o -- scaled' saw at freq
ssqf'   i o f = fast f $ ssq'   i o -- scaled' square at freq
srandf' i o f = fast f $ srand' i o -- scaled' rand at freq

-- random shit
screw l c p = loopAt l $ chop c $ p
mute p = (const $ sound "~") p
toggle t f p = if (1 == t) then f $ p else id $ p
tog = toggle
t = tog
p2l = patToList
l2p = listToPat

-- sound bank protoype https://github.com/tidalcycles/Tidal/issues/231
bank p = with s_p (liftA2 (++) (p::Pattern String))
b = bank

-- extreme mode
str = striate
strL = striateL
str' = striate'
strL' = striateL'
fE = foldEvery
ev = every
oa = offadd
sp = speed
ac = accelerate
sl = slow
fa = fast
m = mute
i = id
g = gain
o = orbit
u = up
(>) = (#)
deg = degrade
degBy = degradeBy
disc = discretise

-- (<) = ($)
contToPat  n p = round <$> discretise n p
contToPat' a b = round <$> struct a b
c2p  = contToPat
c2p' = contToPat'

-- harmony
chordTable = Chords.chordTable
scaleTable = Scales.scaleTable
majork = ["major", "minor", "minor", "major", "major", "minor", "dim7"]
minork = ["minor", "minor", "major", "minor", "major", "major", "major"]
doriank = ["minor", "minor", "major", "major", "minor", "dim7", "major"]
phrygiank = ["minor", "major", "major", "minor", "dim7", "major", "minor"]
lydiank = ["major", "major", "minor", "dim7", "major", "minor", "minor"]
mixolydiank = ["major", "minor", "dim7", "major", "minor", "minor", "major"]
locriank = ["dim7", "major", "minor", "minor", "major", "major", "minor"]
keyTable = [("major", majork),("minor", minork),("dorian", doriank),("phrygian", phrygiank),("lydian", lydiank),("mixolydian", mixolydiank),("locrian", locriank),("ionian", majork),("aeolian", minork)]
keyL p = (\name -> fromMaybe [] $ lookup name keyTable) <$> p
harmonise ch p = scaleP ch p + chord (flip (!!!) <$> p <*> keyL ch)
scaleUP c p = fromIntegral <$> scaleP c p

-- tidal-midi.scd
(midicmd, midicmd_p) = pS "midicmd" (Nothing)
(chan, chan_p) = pF "chan" (Nothing)
(progNum, progNum_p) = pF "progNum" (Nothing)
(val, val_p) = pF "val" (Nothing)
(uid, uid_p) = pF "uid" (Nothing)
(array, array_p) = pF "array" (Nothing)
(frames, frames_p) = pF "frames" (Nothing)
(seconds, seconds_p) = pF "seconds" (Nothing)
(minutes, minutes_p) = pF "minutes" (Nothing)
(hours, hours_p) = pF "hours" (Nothing)
(frameRate, frameRate_p) = pF "frameRate" (Nothing)
(songPtr, songPtr_p) = pF "songPtr" (Nothing)
(ctlNum, ctlNum_p) = pF "ctlNum" (Nothing)
(control, control_p) = pF "control" (Nothing)
(midichan, midichan_p) = pF "midichan" (Nothing)
(amp, amp_p) = pF "amp" (Nothing)
