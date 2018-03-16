# Sine Wave Ball Demo In Assembly
Written by Jason Brooks in 1991

This project start off initially as trying to write a more authentic Pinball Simulator for the Amstrad CPC.  The project was never finished as I'd moved on to HP Unix.

However, it could be an exercise in how not to do it, but I'm sharing this with the community to learn from the code (hopefully)

## How to compile

You will need ADAM (Assembler, Disassembler and Monitor) also known as DAMS in Europe.

If you have a 6128 or extra RAM installed, I recommend loading ADAM as follows :-

**OUT &7F00,196**  
**RUN"ADAM**  

it will load into address &4000 (16384 Decimal)

Press Control + B to enter HEX Mode

**g0,sindex6.adm**  
**a**  
**j**  


You can see a video of how to on youTube: https://www.youtube.com/watch?v=ztGfUInMFP0

Good Luck!
