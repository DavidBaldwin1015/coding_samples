import random
def main():
		x=1
		f = open('C:/Users/David/Documents/Python scripts/randnums.txt', 'w')
		while(x<10**1000000000000):
			y=random.getrandbits(x)
			print(y)
			f.write(str(y))
			x=x+1
		f.close()

if __name__=="__main__":
	main()