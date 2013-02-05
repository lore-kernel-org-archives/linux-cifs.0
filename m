From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Read speed
Date: Tue, 5 Feb 2013 15:17:42 -0500
Message-ID: <20130205151742.2e375400@corrin.poochiereds.net>
References: <51105F16.8070603@kickflop.net>
	<CAH2r5mvbbuo9e30kuRFp9eegJqq_9HLR9=oaGvFqyMi-aBKXTQ@mail.gmail.com>
	<51113D76.80609@kickflop.net>
	<20130205142058.7618dfcf@corrin.poochiereds.net>
	<20130205142307.58d87a21@corrin.poochiereds.net>
	<5111656C.90109@kickflop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5111656C.90109-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 05 Feb 2013 15:02:52 -0500
Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org> wrote:

> >> I believe Sachin is looking at backporting the async read patches for
> >> 6.5. The async write code is already in 6.3 (I think). You should
> >> definitely open a support case since documented customer demand helps
> >> us make the case for including these sorts of changes in an update.
> 
> I opened one an hour or so ago, so that's done.
> 
> Should I test with Fedora 17 or Fedora 18 for the sake of this?
> Just because 18 is newer doesn't mean it's the most appropriate
> for this test need, eh?

In general, later is better, but either should be fine. The async read
code went into mainline about a year or so ago, so both should have it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
