CC=ghc

all: htree

htree: htree.hs
	$(CC) -o htree htree.hs

clean:
	rm -rf htree *.o *.hi
