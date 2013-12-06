From: Patrick Noffke <patrick-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Subject: Re: hung system with cifsd, cannot reduce timeout
Date: Fri, 06 Dec 2013 09:50:27 -0600
Message-ID: <1774674.CzhmRQMMgZ@dingofarm.qg.com>
References: <52A0EA24.9000600@noffke.me> <52A0F1CB.5060709@noffke.me>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart6345695.XLvWINr691"
Content-Transfer-Encoding: 7Bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52A0F1CB.5060709-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart6345695.XLvWINr691
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, December 05, 2013 03:36:11 PM you wrote:
> On 12/05/2013 03:03 PM, Patrick Noffke wrote:
> > Hi,
> > 
> > I did check the cifsd stack (cat /proc/<cifsd PID>/stack) for previous
> > tests, and it was waiting on a recv, and its state was SW (not DW).
> > Unfortunately, I did not get the stack for this test.
> 
> I just repeated this test, and this time cifsd was in the SW state.
> 
> The stack was as follows:
> sk_wait_data
> tcp_recvmsg
> inet_recvmsg
> sock_recvmsg
> kernel_recvmsg
> cifs_readv_from_socket
> cifs_read_from_socket
> cifs_readv_discard
> cifs_readv_receive
> cifs_demultiplex_thread
> kthread
> ret_from_fork
> 
> For this test, my process and ps were hung after the first time pulling
> the cable (I hadn't rebooted from my earlier test, but I think the CIFS
> connection had disconnected due to inactivity).
> 
> As before, an Echo Request was sent on a previous connection after
> sending the SYN and Negotiate on a new connection.  The server RST the
> old connection right after the Echo Request, and 115 seconds later RST
> the new connection.  Another new connection was then made, and the
> process resumed and ps completed.
> 

I have a little more info from yet another test with the same symptoms.  I 
did:

echo 1 > /proc/fs/cifs/cifsFYI

and ran the test again.  I had klogd running, so the cifs debug logs went to 
the syslog.  I've attached the syslogs around the time when I pulled the 
cable, reattached it, and up until the system recovers.

A few notes about these logs:

22:29:18:  Ethernet cable is disconnected.
22:29:22:  Echo request is sent
22:29:27:  Second echo request is sent
22:29:31:  Reconnect due to no echo response.  Socket is created at this time.
22:29:31:  (Last log for this timestamp) Ethernet cable is reconnected.  I 
believe the echo request must have been queued up for sending, which is why I 
see it in wireshark after reconnecting the cable (even though the echo 
requests were logged prior to the reconnection).  Server also sends RST for 
first connection at this time.
22:29:57:  Last cifs log until server sends RST.  Last message is 
"fs/cifs/inode.c: Getting info on"
22:32:09:  Server sends RST on second connection, client reconnects, and the 
system recovers.

It seems like the "Getting info on" log message is missing a filename.  Would 
this explain why it's hung until the server sends a RST?

There are also logs like the following before the cable is reattached:
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release

Best regards,
Patrick
--nextPart6345695.XLvWINr691
Content-Disposition: attachment; filename="cifs-lockup-syslogs.gz"
Content-Transfer-Encoding: base64
Content-Type: application/gzip; name="cifs-lockup-syslogs.gz"

H4sICEDuoVIAA2NpZnMtbG9ja3VwLXN5c2xvZ3MAzV1tb9vIEf7eX7EfW6Cn21furgF/KJL6ELSX
HOKkV6AoDIovCS8yqYqU4/z7zlKmQllDmdol7dwH4yT75pndedl5Zpa811lCiCKcX3B7wTSp10tO
tnW2WaTZcvuJfMk2Zba6IP8hVku50DoSVv2X5PXPSQE/8mKVLZIL4j7cbLI4XcefsvqCuO8vc/jH
GMqYsVGkKCW38XpdlJ++/wJk5jY2pNze3rT/5SVTf3p9tkqSiu8quR/17XKvVVx/K5NWt7sLUuV5
nTWXQhgtLCfLbw1gRkxK6gWrv8M2m7is19WmccBX1YaADjdJdXsblymRkZd4OyD+OitT2EcHcdHi
rLLyUlkPDCXPNyZPM4obM2FZHmxMpeh5xoyopVqFGlMpPqcxlRJzG1OzSP9gkamZPtOYQkpjRKAx
AXZOY4L4+Y3JafSDRSaoZM+MTKY4C02zmjM2pzE5G/KV6YwpVC8yk6oss6RFeH/1ilHKyWfYtmxD
6H1OxdJHfsSGLdPaBH4mWXGXXZDbIgXzCyMnPQxBhRNn8CMVmqqJV+2Xl5EgadzEN53HCC9ohULT
C1JUdzfLuO4HSQY5L6Htb5w9PRGR4Myq/JIxMEUUaffhpijT7P6Sw597QZhjCLei9P7ScH20MrrM
85S78O9WBvWDTzxoc37i0bmxQ6fIBIlHmzMTjxBc2dCSQGs7a+LRdv7EYwziRaeMSdPY5Fk8ZMxE
0VBjGnsiV2HG5FZpwUKNaezQmT2JMU2fFc1kTKvZsTFZlxIMnhJYeEowKjqfJcybEkCls1PCBKec
Uf16dnIvAvFDGWcyLzKRPjO/z54STGTOZQkUHCw0vwPsnCwBxM/OEozlCOXjXUqwaErIkvCUYDVW
AYkHYEFx4GUwsKFRv87sgGUHzHDgOBzYUZljYNUBcxzYhgNz0W+IdMBRByxwYDMBsOmz6A5Yd8AS
B9bhwFD6Il5tOmCFA0fhwFJoBNh2wBEOrMKBFbfIVrOu3Bd4uZ/JCZAtR+KJdVWFwKuKTIQjR9JK
BLlLXmIgeYVTHKOZxQqpLnvJgewVXkkZLdESrktfciB90QmQ9UBbtc/FmaKCLLd5y4vbD5vsNi5K
d+b7HbIO1wyf7bu+QBKvVss4+dLvTdRN3GSXEhSot6vmkgYd9aBFvzV6W9SJU+HtdrVyy82zDVnH
dZ2lsBs7xepb0OkGfgcqrjKwx/mYkD97MT1508fJl0/t7FHTR03ZNHcqRKNVmLTp46A1Cj1X08ch
Ily6bfpEUmp70PSR1KMQBgiLHPUPpwCTBjkGUp6zCc56A77xY80OQCXJz2QFilGuQ31aSTkfK3Di
524UAEY03CgAN0LOdOdGE1RuQPkRWsD3yMiZ7pAnKN2gjEGqCdEhW+RMd8gT1G5WGSRo5R4ZOdMd
8gS1m7UMWbPaIyOcxCGH126WcjHMSQAZISUOObx2s1RGCLLeIyOsxCGH126WWoVUymaPjNAShxxe
u1nGsZaN3SMjvASQaT4BsjJYjb4/kSx+ItEsHJqDpYeJCUDjWYymE0AD5R5mJgCNpzEa3lexXEmM
jnV5TFE8j9HwzorlFuszdNwEoPFERsN7K1awCCcJ85ITwNVPltDH5ERNS05AC8OemZxYcXBoTU5O
nPwTxdsAOYmmvATiVBjPjyYlJw76eSfSDnHmibSDQJpjXYtK4g3QdIJDSFj2g12FcSqdexWGgx2C
XRqOpvm4iRM/98QCMDR2wHVehHez8wnOGCnoiVGJxLvZeXj/3kLBiqx432zEu9l5OKe3UKfYQWJi
JN7NzsNZINTJAtnqblQi8WZ2Hk4CrYqw/kk3KpF4LzsP54BAAS2SorpRicRb2Xk4BbQR2jHqRiUK
72TnEzDAKFInRiUKb2TnExBAzeUJSmIUfg7lExBArdQJRmLUQO6agABqw7Ck2SUvNTCKm+DstQqb
iO1HJWpgFjcB/7MW60juRyVqYBgXTP9AjuAvwEYcrvBgI9GkbMRpIenzshHANHPej3XyoxMXTAbY
iJ7wFnOrwvgrulOykRYav5o7ExtpEZEcPeGopIVAejR036zAe580uJ6DLaIYMtsj471PGlzQOeN4
PK0z55CmVence3hKMx12m9PBqvmu5rbiZ76aCxiSIjHC926EN7JpcHkOyBob0nxvMeKNbPpUfW56
yEWZV4fAasFUJNyS23sUkOQKyPPk7ZtX5J9F+YUUNXldfS0PZXJ+ejV2IY02Ck+sb0qSJZ8rOBb/
t83qxkdyNJptCy/xQ48Pok4mzCOM06ZWcqEgsxo89Z/enFGSBy88P7k5Y8SDt4VsjmA9jGyzOUQw
C8OZklDlvXpzdU3+dXXtxG7uoMRgmi9YtKALKDrimpRV4+qqdQVHVUqKEogGqTPw3LRekPfZQ6kC
6iwWixMaIKvc6dBnFP26pyeZNMkaMOu6qEovCItCPBwbD99A2RNvvrTbukOqiTNdk7h/y8Gg+7/0
UeGg/hhWocnijVMhhURA6ir5kvmh4bXktSuToUS4F+RqFX+q3b9SD/kRZaj836q6IfXnbbNTfyo0
hl8iOjJfdee2DorX2lXm601xBwqQVfE4uEei4n75GLWo6+0DLOmoSe2DxyflHCMx5fNjiid5yBHD
s91lODOC4Y3Uwj7/yuX53NaKyVeu1POvXOEX1U6unE+/cvP8K3+adR+vnE2+8mjS6epIzCenn8cr
p9OvXLzAyvHJ58kelp1+5dELrNzjorOZfuUvkNtPveRhaOV68pXrF4hzrfBasy1eSQKLb7LUSzBe
gNVlChoTOMKNJJvkzn0wWhjqPjTFbVZBncmW6hQdGsLU2G3C7wQJyM9Bq4kAPfp3kV4Q5p60/lo0
n8nWffSxncYm/Hsg14VoH+ESkhtOKYmbh24S6R70hjqbu+tXXtjInAFfdn/JInTJHA+a94DjSmrX
YdlFBKlKkkOBrbxQkI0dZ1MZvEBkcjQOWoVCY7dTMXdaJlz23alr9dN71d4f8cJG7l4/7U5R8JLx
imPYnaQFquyFhDShjzeXu6FrchCrD9fzIVaV9d3c0e7c31wdvLnermyCoZHshLiyYOnhbndvTaD3
vH0tiBc2cn/k6d22oUuW52ZG7oWCd0aHURxvPrWeo6Y3AFmthUtGg03vj2vSXk34dbmuyZWrVl5v
16vs/q/kalV9Ja+qstlUIO/9/c8f7h+Bn24yKwvLjDjHu+O9ESPjEJlnzLLH4SqcB9RZ0vbDwC+1
l9ixr9xjTHrJP+ude/LRGtTp1rZRC0qN7Z9ORVmlg3F1F6+KFCrImzQDN/h2EzfNphdpER2OtJGa
SESTj2uHSRxYsdw2bqZI2l+6+XvvHiVVKSVJtS0bwshOw4vvf0JTZahKICelN64wJT8xwayIIghv
Ki0csn8UeV5AeElBpZSMceO1BIUs4ZesaVvnbUhCxPUEC35B7SnBlkULxfnhawgPWvNuSJ+Ssmon
8wT8Lttsqs0Fye7XDy17SBUQUp+qBlZNpRf6wIWIpwcDoyGikZ3l8wcD41UY12Y+PRgYj4ZPQp4a
DIyWb/Exx3mDgbFoER23d+MGA6NRGR4V5w4GRuMdXMUaQbBHCxb4QnwI9mhMOXR47RoS7rIEbNjN
riEC397C4czkvkHYPXjihd2/0RDYHRmPidcAZfZpvXGD1QTSI/MSjLfUB4qL8WKHDv9epoWTDsrd
nyDvNdtN2e4X7BRsYOOm6XAG+gAPNMrDN2rg5te4UnosimY49ww0x0E/6jnNcdCNmtIcms3itwcd
rOfdKPzyV/hG8VByNh4Jt3WoSfhQqp/bJAN3lycwCW7r0I0SQ/d85t4ogRPj8I0S5/ru407ceKR5
fFe8lO+KuXxXzOO78qV8V87lu2c3xZQXylm9ofFio5cyB36sT2AOPCCCN+qF6tyhd5CFb1T/1RxI
Sw0YTMuCT/XV/nwP7nzZttX+4jS5dLo8KofZaWU4KCMkHajmh602TuzoV88etj7Hyx8Kn6dbn2Mx
IoG3SI6e89HKQ7oe/B+mjOHXku5f7OCDzfDM+bqIV21HhHoJfZJA+4nFW0fXWbLdFM038isE0K5F
9Spex8tiVTRF1naqWC7ylHwobrO/pX9sa1gXd71eLyV6uc3lnF2I1DX8aLZr0nxbZ4T5CBZDfnwc
J15eJobYFhonXJqzQaQwA73Ko0BZph7SrRl6euZUoKh9oETegeKwp7t2Ox4zOva1j29eQ47nVDHi
JVIfi1yusrwhzCM1gsD+g9zf48E9lPDu+vL3okyrr3X3lAKnVBChLW2/KJKM/BYnXzzCxeHyIdy3
A8Bqcf6x6IDkENDryo0bL39/9/4fv7x/9/E3L+kKkb5LJfkmy3ZxGe/cjBw87ag88pcDxJNoW3Rc
P9RQf4c4Wa6K+jM4dL1NEvg6B1f/5oU3dLgdpzUP/5OUnvXqeesR+xFlIx/zFR5RHtHI5/jX+6ym
/bNaRAcuAqZF/YXUn+NNRrrB3eNh3Tj5Bt+5Mm6Ku+yqWGXX3+omu718++Hq2ks+Pmf54O4r5N2c
yidTgmicfO+nRe0wcVdxewRiRLFXZ2PT9GqdlTfuD/ojdHYwQv8/IrhN8w5xAAA=

--nextPart6345695.XLvWINr691--
