# dpoislnorm works as expected

    Code
      dpoislnorm(x = 1, meanlog = 1, sdlog = 1)
    Output
      [1] 0.1757334

---

    Code
      dpoislnorm(x = 1:10, meanlog = 1, sdlog = 1)
    Output
       [1] 0.17573342 0.14691182 0.11325601 0.08550612 0.06458689 0.04920390
       [7] 0.03791369 0.02956797 0.02333243 0.01861790

# ppoislnorm works as expected

    Code
      ppoislnorm(q = 1, meanlog = 1, sdlog = 1)
    Output
      [1] 0.3327376

---

    Code
      ppoislnorm(q = 1:10, meanlog = 1, sdlog = 1)
    Output
       [1] 0.3327376 0.4796494 0.5929054 0.6784115 0.7429984 0.7922023 0.8301160
       [8] 0.8596840 0.8830164 0.9016343

# dpisweibull works as expected

    Code
      dpoisweibull(x = 1, shape = 1, scale = 1)
    Output
      [1] 0.25

---

    Code
      dpoisweibull(x = 1:10, shape = 1, scale = 1)
    Output
       [1] 0.2500000000 0.1250000000 0.0625000001 0.0312500000 0.0156250000
       [6] 0.0078125000 0.0039062500 0.0019531250 0.0009765625 0.0004882813

# ppoisweibull works as expected

    Code
      ppoisweibull(q = 1, shape = 1, scale = 1)
    Output
      [1] 0.75

---

    Code
      ppoisweibull(q = 1:10, shape = 1, scale = 1)
    Output
       [1] 0.7500000 0.8750000 0.9375000 0.9687500 0.9843750 0.9921875 0.9960937
       [8] 0.9980469 0.9990234 0.9995117

