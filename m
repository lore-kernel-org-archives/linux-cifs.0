From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS in 2.6.32.24 kernel
Date: Mon, 1 Nov 2010 09:16:55 -0400
Message-ID: <20101101091655.02f0b9d1@tlielax.poochiereds.net>
References: <20101028075119.687aaef2@tlielax.poochiereds.net>
	<274617.31831.qm@web38103.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt <mbedynek-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <274617.31831.qm-wLybadgZ6zavuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Oct 2010 10:17:10 -0700 (PDT)
Matt <mbedynek-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:

(re-cc'ing linux-cifs) 

> > It's very odd to have a single set of quotes around the
> > "device" and
> > "target" strings like that. Does this work any better if
> > you do quote
> > them separately. For instance?
> 
> My apologies.  That is my mistake error in reformatting for e-mail.  In the actual usage it is :
> 

Ok, that may be part of the problem. Does this work any better if you
supply an 'ip=' mount option with the ip address of the server?

> 
> Few additional pieces of information:
> 
> I have tested this on Debian Lenny and Debian Etch.  In both cases, I am using the same kernel (2.6.32.24) because I had even more crashes in kernels older than 2.6.32. 
> 
> Debian etch uses samba 3.0.24 whereas Lenny uses 3.2.5.
> 
> In both cases, I have tested with mount.cifs installed and with it not.
> 


The problem is likely to be in the kernel. My suspicion is a
refcounting bug of some sort. I fixed up some problems recently that
might have these sorts of symptoms, does this fare any better with a
more recent kernel (2.6.36 or so) ?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
