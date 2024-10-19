// Ternary OR Gate using GNRFET technology
.lib 'gnrfet.lib' gnrfet

.options post
.options autostop
.options ingold=2 dcon=1
.options gshunt=1e-12 rmin=1e-15
.options abstol=1e-5 absvdc=1e-4
.options reltol=1e-2 relvdc=1e-2
.options numdgt=4 pivot=13

.param temp=27
.param tclk = 1n
.param supply = 0.9v   * Supply voltage is 0.9V for ternary logic

// Ternary input signals (0, 0.3V, and 0.6V for ternary logic)
vin1 a 0 pwl(0n 0v 30n 0.3v 60n 0.6v 90n 0v)
vin2 b 0 pwl(0n 0v 30n 0.3v 60n 0.6v 90n 0v)

vdd vdd gnd dc supply  * Supply voltage

// GNRFET transistors for ternary OR gate implementation
// Transistor sizing and parameters
// NMOS transistors
xn1 n1 a 0 0 gnrfetnmos nRib=6 N=6 L=32n Tox=0.95n sp=2n dop=0.001 p=0
xn2 n1 b 0 0 gnrfetnmos nRib=6 N=6 L=32n Tox=0.95n sp=2n dop=0.001 p=0

// PMOS transistors
xp1 out a vdd vdd gnrfetpmos nRib=15 N=15 L=32n Tox=0.95n sp=2n dop=0.001 p=0
xp2 out b vdd vdd gnrfetpmos nRib=15 N=15 L=32n Tox=0.95n sp=2n dop=0.001 p=0

// Final stage transistors to combine the output
xn3 op out 0 0 gnrfetnmos nRib=12 N=12 L=32n Tox=0.95n sp=2n dop=0.001 p=0
xp3 op vdd vdd gnrfetpmos nRib=12 N=12 L=32n Tox=0.95n sp=2n dop=0.001 p=0

// Simulation and measurement commands
.OP ALL
.TRAN 200P 90N
.meas tran avgpower AVG power from = 1ns to = 90ns
.meas tran peakpower MAX power from = 1ns to = 90ns

// Graph plotting for input and output voltages
.plot tran v(a) v(b) v(op)

// Probing specific currents and power for transistors
.probe tran i(xn1) i(xp1) i(xn3) i(xp3)

// Plot the power consumption
.plot tran i(vds)*v(vdd)

.end