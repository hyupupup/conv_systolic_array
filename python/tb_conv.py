import numpy as np

# initial data
ifm = np.random.random_integers(63, high=None, size=(3,5,5)) # 0-63 太大会溢出
w = np.random.random_integers(63, high=None, size=(3,3,3,3))
ofm = np.zeros((3,3,3))

# compute conv
for co in range(3): #output_channel
    for ci in range(3): #input_channel
        for h_lt in range(3): #滑窗左上角的h坐标
            for w_lt in range(3): #滑窗左上角的w坐标
                for kx in range(3):
                    for ky in range(3):
                        ofm[co,h_lt,w_lt] += ifm[ci,h_lt+ky,w_lt+kx] * w[co,ci,ky,kx]

#ifm_bus
for h_lt in range(3): #滑窗左上角的h坐标
    for w_lt in range(3): #滑窗左上角的w坐标  
        ifm_file = 'ifm_win' + str(h_lt*3 + w_lt) + '.txt'
        f = open(ifm_file,'w')
        for ci in range(3): #input_channel
            for kx in range(3):
                for ky in range(3):
                    f.write(bin(ifm[ci,h_lt+ky,w_lt+kx]).replace('0b','')+'\n')
                    #f.write(str(ifm[ci,h_lt+ky,w_lt+kx])+'\n')
        f.write(bin(ifm[ci,h_lt+ky,w_lt+kx]).replace('0b','')+'\n') # 每27个数据中间停1个clk;
        f.close()


#w_bus
for co in range(3): #output_channel
    w_file = 'w_' + str(co) + '.txt'
    f = open(w_file,'w')
    for ci in range(3): #input_channel
        for kx in range(3):
            for ky in range(3):
                f.write(bin(w[co,ci,ky,kx]).replace('0b','')+'\n')
                #f.write(str(w[co,ci,ky,kx])+'\n')
    f.write(bin(w[co,ci,ky,kx]).replace('0b','')+'\n') # 每27个数据中间停1个clk;
    f.close()

#result
for co in range(3): #output_channel
    ofm_file = 'ofm_' + str(co) + '.txt'
    f = open(ofm_file,'w')
    for h_lt in range(3): #滑窗左上角的h坐标
        for w_lt in range(3): #滑窗左上角的w坐标
            f.write(str(ofm[co,h_lt,w_lt])+'\n')
    f.close()            

                