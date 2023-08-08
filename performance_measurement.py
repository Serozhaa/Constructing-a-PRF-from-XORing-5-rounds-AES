import matplotlib.pyplot as plt
x = list(range(1, 1001))

#Enter the performance results here
improved=[]
mixcolumns=[]
four_rounds_invmixcolumns=[]
four_rounds_mixcolumns=[]

#print(len(improved))
#print(len(mixcolumns))
#print(len(four_rounds_mixcolumns))
#print(len(four_rounds_invmixcolumns))
def count_intervals(numbers):
    intervals = {}
    for num in numbers:
        start = (num // 100) * 100
        end = start + 100
        interval = (start, end)
        intervals[interval] = intervals.get(interval, 0) + 1

    return intervals

def plot_intervals(intervals):
    x = []
    y = []
    for interval, count in intervals.items():
        x.append(f"{interval[0]}-{interval[1]}")
        y.append(count)

    plt.bar(x, y)
    plt.xlabel('Cycles in Intervals', weight="normal", size=24)
    plt.ylabel('Frequency', weight="normal", size=24)
    plt.title('Frequency-Measurement')
    plt.xticks(rotation=45)
    plt.show()
#plot_intervals(count_intervals(improved))
#plot_intervals(count_intervals(mixcolumns))
#plot_intervals(count_intervals(four_rounds_mixcolumns))
#plot_intervals(count_intervals(four_rounds_invmixcolumns))


#Compute the average amount of cycles
def average_cycles(list):
    return str(sum(list)/len(list))

#print("Improved: "+average_cycles(improved))
#print("MixColumns: "+average_cycles(mixcolumns))
#print("4R Base PRF: "+average_cycles(four_rounds_invmixcolumns))
#print("4R MixColumns: "+average_cycles(four_rounds_mixcolumns))
