From: Rolf Anderegg <rolf.anderegg-6BMQn13C9Rk@public.gmane.org>
Subject: Re: slow cifs read on 3.12/3.10 kernel
Date: Tue, 11 Mar 2014 18:42:28 +0100
Message-ID: <531F4B04.9050505@weiss.ch>
References: <531E1432.3040706@weiss.ch> <CAH2r5mvuOhJOamHXT8JXTDmQF2e_ORHaU17HoZ8ScfviHts=UQ@mail.gmail.com>
Reply-To: <rolf.anderegg-6BMQn13C9Rk@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvuOhJOamHXT8JXTDmQF2e_ORHaU17HoZ8ScfviHts=UQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 10.03.2014 20:52, schrieb Steve French:
> There are some quick obvious things to check:
> 1) since server is Samba - check if unix extensions negotiated and
> check default rsize
> (you can simply do cat /proc/mounts to see what was negotiated)
> 
> 2) with unix extensions enabled, the maximum read size (and write
> size) is much larger (which usually should help) so check if
> differences in rsize or wsize can explain performance differences.
> 
> 3) Similarly, increasing the maximum number of simultaneous requests
> that the server can support for each client can have an impact on
> performance ("max mux = 50" is the default in the server's smb.conf
> but it can be increased if your workload has many requests from one
> client at the same time).

Thanks Steve for your helpful pointers.
The first three points had no effect in my particular case.

> 4) caching behavior changes - we moved to a much stricter caching
> policy ("cache=strict") on later kernels so mounting with
> "cache=loose," and allowing more efficient client side write caching
> which is usually sufficient for most workloads, may also help.

The cache mode was the nail that hit it. The cache modes had a dramatic impact
on the CIFS mount read speed:

 ~29 MB/s with "cache=loose"
<800 kB/s with "cache=strict"

Having read the discussion that lead to this change in 3.7
(https://lists.samba.org/archive/samba-technical/2012-April/083228.html), I now
understand the reason for the default cache coherency strictness; albeit "a
little slower" is quite an understatement in my case.

Thanks,

Rolf
