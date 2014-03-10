From: Rolf Anderegg <rolf.anderegg-6BMQn13C9Rk@public.gmane.org>
Subject: slow cifs read on 3.12/3.10 kernel
Date: Mon, 10 Mar 2014 20:36:18 +0100
Message-ID: <531E1432.3040706@weiss.ch>
Reply-To: <rolf.anderegg-6BMQn13C9Rk@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In the course of evaluating realtime kernels for an Intel Atom based setup, I
ran across major read-speed problems on CIFS mounts when using a 3.12 kernel
(also tried 3.10, same issue). This resulted in transmissions @ <800KB/s
compared to >10MB when using 3.4 kernel's CIFS. At first I thought it had to do
with either one of these old buffer size related solutions:

https://bugzilla.samba.org/show_bug.cgi?id=7699
https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/810606
http://ubuntuforums.org/showthread.php?t=1578068

However, fiddling around with rsize/wsize, resp. CIFSMaxBufSize, did not change
anything.
Increasing the CIFS debug verbosity and dumping TCP traffic showed that in the
3.12 case, smaller packets are negotiated and transmitted which obviously
results in lower throughput. Here are my test logs:

Kernel 3.12.10-rt15 CIFS test log (slow speed):
http://7f42b4439bec450b.paste.se

Kernel 3.4.82-rt100 CIFS test log (normal speed):
http://863be082c9262448.paste.se

I'm all out of handles to crank, so before I dive further into the kernel's CIFS
code, I thought I'd call out for some expert help to check if this is a known issue.

Thanks in advance,

Rolf Anderegg
