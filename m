From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Read speed
Date: Mon, 11 Mar 2013 12:57:53 -0500
Message-ID: <CAH2r5mtHzMvTqcGc6w2fWqWOgmFG-st0CXkwmOxeGbwryUBNbQ@mail.gmail.com>
References: <51105F16.8070603@kickflop.net>
	<CAH2r5mvbbuo9e30kuRFp9eegJqq_9HLR9=oaGvFqyMi-aBKXTQ@mail.gmail.com>
	<51113D76.80609@kickflop.net>
	<20130205142058.7618dfcf@corrin.poochiereds.net>
	<20130205142307.58d87a21@corrin.poochiereds.net>
	<5111656C.90109@kickflop.net>
	<513E1A3E.1080404@kickflop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513E1A3E.1080404-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Mar 11, 2013 at 12:54 PM, Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org> wrote:
> [ suggestion by Jeff Layton to try to ensure that a modern  ]
> [ kernel addresses the issues we were seeing over WAN links ]
>
> Just following up.
>
> * Fedora 18 CIFS-over-WAN read performance, as recorded with the same
>   testing that was done previously, is ~3.4x that of RHEL 6.3
>   (or any common production distro running a pre-3.2 kernel).
>
> So yes, the work done to CIFS addresses our situation directly.

That is great - hope the SMB2.1 leases (and SMB3 directory leases)
will help even more over WAN as we look to the future


-- 
Thanks,

Steve
