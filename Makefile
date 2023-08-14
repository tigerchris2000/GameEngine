.PHONY: all clear clean main

CC = gcc
CFLAGS =  std=c11 -pedantic -D_XOPEN_SOURCE=700 -Wall -Werror
LDFLAGS = -lglut -lGL -lGLU 

all: clear main 

main: main.o gameEngine.o
	$(CC) $(CFLGAS) -o main main.o gameEngine.o $(LDFLAGS) 

main.o: main.c gameEngine.h
	$(CC) $(CFLAGS) -c main.c 

gameEngine.o: gameEngine.c gameEngine.h
	$(CC) $(CFLAGS) -c gameEngine.c

clean:
	rm main.o main

clear:
	clear
