From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: slow cifs read on 3.12/3.10 kernel
Date: Mon, 10 Mar 2014 14:52:40 -0500
Message-ID: <CAH2r5mvuOhJOamHXT8JXTDmQF2e_ORHaU17HoZ8ScfviHts=UQ@mail.gmail.com>
References: <531E1432.3040706@weiss.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: rolf.anderegg-6BMQn13C9Rk@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531E1432.3040706-6BMQn13C9Rk@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There are some quick obvious things to check:
1) since server is Samba - check if unix extensions negotiated and
check default rsize
(you can simply do cat /proc/mounts to see what was negotiated)

2) with unix extensions enabled, the maximum read size (and write
size) is much larger (which usually should help) so check if
differences in rsize or wsize can explain performance differences.

3) Similarly, increasing the maximum number of simultaneous requests
that the server can support for each client can have an impact on
performance ("max mux = 50" is the default in the server's smb.conf
but it can be increased if your workload has many requests from one
client at the same time).

4) caching behavior changes - we moved to a much stricter caching
policy ("cache=strict") on later kernels so mounting with
"cache=loose," and allowing more efficient client side write caching
which is usually sufficient for most workloads, may also help.



On Mon, Mar 10, 2014 at 2:36 PM, Rolf Anderegg <rolf.anderegg-6BMQn13C9Rk@public.gmane.org> wrote:
> In the course of evaluating realtime kernels for an Intel Atom based setup, I
> ran across major read-speed problems on CIFS mounts when using a 3.12 kernel
> (also tried 3.10, same issue). This resulted in transmissions @ <800KB/s
> compared to >10MB when using 3.4 kernel's CIFS. At first I thought it had to do
> with either one of these old buffer size related solutions:
>
> https://bugzilla.samba.org/show_bug.cgi?id=7699
> https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/810606
> http://ubuntuforums.org/showthread.php?t=1578068
>
> However, fiddling around with rsize/wsize, resp. CIFSMaxBufSize, did not change
> anything.
> Increasing the CIFS debug verbosity and dumping TCP traffic showed that in the
> 3.12 case, smaller packets are negotiated and transmitted which obviously
> results in lower throughput. Here are my test logs:
>
> Kernel 3.12.10-rt15 CIFS test log (slow speed):
> http://7f42b4439bec450b.paste.se
>
> Kernel 3.4.82-rt100 CIFS test log (normal speed):
> http://863be082c9262448.paste.se
>
> I'm all out of handles to crank, so before I dive further into the kernel's CIFS
> code, I thought I'd call out for some expert help to check if this is a known issue.
>
> Thanks in advance,
>
> Rolf Anderegg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
