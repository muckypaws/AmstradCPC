Choice Cheats Volume 1
======================

The files contained here are the production encrypted version of choice cheats that was protected using JaceLock on Disk.

At the time I was working on a disk protection scheme that relied on a bug in the uPD765a Disc Controller and the Gap#3 value that is written when a sector is updated.

According to the specs GAP#3 can be fixed when formatting and writing to the disk, which was correct, however when you updated a sector, the Gap#3 would be mofied also (side effect).  Knowing this, you can create a disk syste that the current copies of the time i.e. Pro Copy, Nirvana, Discology etc couldn't replicate.

Whilst there's a couple of pesky XOR routines in the code to slow you down, the trick was to get the correct GAP#3 to decrypt the payload.

The DSK file was copied using Discology and won't work (so the copy protection system did it's job), The real physical disk works in the original hardware.

The payload, loads in at address #5000 and executes at #5000

Who's up to the task of decrypting this disk?
