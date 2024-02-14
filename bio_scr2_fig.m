
figure(1)
subplot(211)
plot(dyn1l1p0a_new.tt,([mean(dyn1l1p0a_new.FLUX,2),...
                        mean(dyn1l1p0b_new.FLUX,2),...
                        mean(dyn1l1p0c_new.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 30ms 5Hz','1mW 10ms 5Hz','1mW 2ms 5Hz'),
subplot(212)
plot(dyn1l1p0a_new.tt,([mean(dyn1l1p0a_new.TB,2),...
                        mean(dyn1l1p0b_new.TB,2),...
                        mean(dyn1l1p0c_new.TB,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('TB (a.u.)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 30ms 5Hz','1mW 10ms 5Hz','1mW 2ms 5Hz'),


figure(2)
subplot(211)
plot(dyn1l1p0a_new.tt,([mean(dyn1l1p0a_new.FLUX,2),...
                        mean(dyn2l1p0b_new.FLUX,2),...
                        mean(dyn4l1p0b_new.FLUX,2),...
                        mean(dyn8l1p0b_new.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 10ms 5Hz','1mW 10ms 10Hz','1mW 10ms 20Hz','1mW 10ms 40Hz'),
subplot(212)
plot(dyn1l1p0a_new.tt,([mean(dyn1l1p0b_new.TB,2),...
                        mean(dyn2l1p0b_new.TB,2),...
                        mean(dyn4l1p0b_new.TB,2),...
                        mean(dyn8l1p0b_new.TB,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 44 tmpax(3:4)]);
ylabel('TB (a.u.)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 10ms 5Hz','1mW 10ms 10Hz','1mW 10ms 20Hz','1mW 10ms 40Hz'),


figure(3)
subplot(211)
plot(dyn1l1p0bS_new.tt,([mean(dyn1l1p0aS_new.FLUX,2),...
                         mean(dyn1l1p0bS_new.FLUX,2),...
                         mean(dyn1l1p0cS_new.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 28 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 30ms 5Hz','10ms','2ms'),
subplot(212)
plot(dyn1l1p0bS_new.tt,([mean(dyn1l1p0aS_new.TB,2),...
                         mean(dyn1l1p0bS_new.TB,2),...
                         mean(dyn1l1p0cS_new.TB,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 28 tmpax(3:4)]);
ylabel('TB (a.u.)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 30ms 5Hz','10ms','2ms'),


figure(4)
subplot(211)
plot(dyn1l1p0bS_new.tt,([mean(dyn1l1p0bS_new.FLUX,2),...
                         mean(dyn2l1p0bS_new.FLUX,2),...
                         mean(dyn4l1p0bS_new.FLUX,2),...
                         mean(dyn8l1p0bS_new.FLUX,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 28 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 10ms 5Hz','10Hz','20Hz','40Hz'),
subplot(212)
plot(dyn1l1p0bS_new.tt,([mean(dyn1l1p0bS_new.TB,2),...
                         mean(dyn2l1p0bS_new.TB,2),...
                         mean(dyn4l1p0bS_new.TB,2),...
                         mean(dyn8l1p0bS_new.TB,2)]-1)*100)
axis('tight'), grid('on'), tmpax=axis; axis([-4 28 tmpax(3:4)]);
ylabel('TB (a.u.)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 10ms 5Hz','10Hz','20Hz','40Hz'),


figure(5)
subplot(211)
plot(dyn1l1p0bL_new.tt,([mean(dyn1l1p0bL_new.FLUX,2)]-1)*100),
axis('tight'), grid('on'), tmpax=axis; axis([-4 38 tmpax(3:4)]);
ylabel('LDF (CBF; %)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 10ms 5Hz'),
subplot(212)
plot(dyn1l1p0bL_new.tt,([mean(dyn1l1p0bL_new.TB,2)]-1)*100),
axis('tight'), grid('on'), tmpax=axis; axis([-4 38 tmpax(3:4)]);
ylabel('TB (a.u.)'), xlabel('Time (s)'),
dofontsize(15); legend('1mW 10ms 5Hz'),

