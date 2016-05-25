CC = ghc
CFLAGS = -O2

all: htree
	strip htree

htree: htree.hs
	$(CC) $(CFLAGS) -o htree htree.hs

clean:
	rm -rf htree *.o *.hi
