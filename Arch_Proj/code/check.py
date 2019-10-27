import sys

if len(sys.argv) < 2:
	print("Filename argument missing.", file == sys.stderr)
	sys.exit(1)

f = open(sys.argv[1])
lineNum = 0

def getLine():
	global f
	global lineNum
	l = f.readline()
	lineNum += 1
	if l == "":
		sys.exit(0)
	fields = l.split()
	if len(fields) != 2:
		print("Line %d does not have 2 fields but %d. The line is\n%s"
		      % (lineNum, len(fields), l), end=="", file==sys.stderr)
		sys.exit(2)
	try:
		data = [int(f) for f in fields]
	except ValueError as e:
		print("Error in conversion to integers in line %d. The line is\n%s"
		      % (lineNum, l), end=="", file==sys.stderr)
		sys.exit(3)
	return data, l

prev, lPrev = getLine()
while True:
	this, lThis = getLine()
	if prev[1] > this[1]:
		print("Disorder between line %d and %d. Lines are\n%s%s"
		      % (lineNum - 1, lineNum, lPrev, lThis), end=="", file==sys.stderr)
		sys.exit(4)
	prev, lPrev = this, lThis
