print "Welcome to CrissCross!"

import os, sys, time, random

import snappy 

def potholder(n,m):
    assert n%2 == m%2 == 1
    res = [0] * (2*n*m-3)
    for k in range(1,n*m-1):
        i,j = divmod(k,n)
        first = i*n + [j,n-1-j][i%2]
        second = 2*m*n - j*m - [i,m-i-1][j%2] - 3
        res[first] = second
        res[second] = first
        #print first, second, '\t',
        #if j+1==n: print
    return res[1::2]

def fence(n,m):
    res = [] 
    for i in range(m):
        for j in range(n):
            k = 2*(n*i + j)
            res.append(4*n*(i+1) - k)
            res.append(4*n*i - (k+1))
    res = [x for x in res if 0 < x <= 2*m*n]
    tr = {j:2*(i+1) for i,j in enumerate(sorted(res))}
    return [tr[x] for x in res]

def circular(n,m):
    assert m%2 == 0
    res = [] 
    for i in range(m):
        for j in range(n):
            k = 2*(n*i + j)
            res.append(4*n*(i+1) - k)
            res.append(4*n*i - (k+1))
    res = [(x-1) % (2*m*n) for x in res]
    tr = {j:2*(i+1) for i,j in enumerate(sorted(res))}
    return [tr[x] for x in res]

def knit(n,m):
    res = []
    n = 2*n+1
    assert n%2 == m%2 == 1	
    for i in range(m):
        for j in range(n):
            k = 2*(n*i + j)
            if (i+j) % 2:
                res.append(4*n*(i+1) - (k+1))
                res.append(4*n*i - k)
            else:
                res.append(4*n*i - (k+1))
                res.append(4*n*(i+1) - k)
    res = [x for x in res if 0 < x <= 2*m*n]
    tr = {j:2*(i+1) for i,j in enumerate(sorted(res))}
    return [tr[x] for x in res]

def tube(n,m):
    res = []
    n = 2*n+1
    assert n%2 == 1 != m%2	
    for i in range(m):
        for j in range(n):
            k = 2*(n*i + j)
            if (i+j) % 2:
                res.append(4*n*(i+1) - (k+1))
                res.append(4*n*i - k)
            else:
                res.append(4*n*i - (k+1))
                res.append(4*n*(i+1) - k)
    res = [(x-1)%(2*m*n) for x in res]
    tr = {j:2*(i+1) for i,j in enumerate(sorted(res))}
    return [tr[x] for x in res]
	
def sample(dt, nsamples, seed, ver = 0):
    res = {}
    for i in range(nsamples):
        sdt = tuple([random.choice([x,-x]) for x in dt])
        try:
            M = snappy.Manifold('DT[%s]' % str(sdt))
            knot = str(snappy.HTLinkExteriors.identify(M))
            vol = M.volume()
            if vol < 1:
                vol = 0.0
        except ValueError:
            knot, vol = 'ValueError', -1.0
        if ver:
            print i, '\t', sdt, '\t', vol, '\t', knot
        if knot not in res:
            signs = ''.join(['+' if x>0 else '-' for x in sdt])
            res[knot] = [signs, vol, 1]
        else:
            res[knot][2] += 1
    return res

def save(res, filename):
    lines = []
    for k in res.keys():
        lines.append(('K % 2s %s % 5s' % \
                tuple(k[1:].replace('a','-a-').replace('n','-n-').replace('(0,0)','').split('-'))
                if k[0]=='K' else 'V  - -     -') + '   ' + 
                '%8d' % res[k][2] + '   ' + 
                '% 3.13f' % float(res[k][1]) + '   ' +
                str(res[k][0]) + '\n')
    open(filename, 'w').write(''.join(sorted(lines)))

if __name__ == '__main__':
    
    print "argv =", sys.argv
    curve = eval(sys.argv[1])
    params = eval(sys.argv[2])
    samples = eval(sys.argv[3])
    seed = eval(sys.argv[4])
    
    savefile = sys.argv[5] if len(sys.argv) > 5 else '.'
    if os.path.isdir(savefile):
        savefile += '/' + '.'.join(sys.argv[1:5]).replace(',','.')
    print "output =", savefile
    
    dt = curve(*params) 
    print "DT =", dt
    print time.ctime()
    res = sample(dt, samples, seed)
    print time.ctime()
    save(res,savefile)  
    
    #for k in sorted(res.keys()):
    #    print k, '\t', res[k] 

        
    
