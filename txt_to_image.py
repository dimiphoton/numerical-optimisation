import matplotlib.pyplot as plt
import matplotlib.cm as cm
import numpy as np


def main():
    path_in = "reconstructed_l1_M3042.txt"
    array = np.loadtxt(path_in)
    plt.imshow(array, interpolation='nearest', cmap=cm.Greys_r)
    plt.show()


if __name__ == '__main__':
    main()
