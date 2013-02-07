From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Writes greater than 64k fails with -ENOSPC
Date: Thu, 7 Feb 2013 08:55:46 -0500
Message-ID: <20130207085546.3ebe3b09@corrin.poochiereds.net>
References: <5107BF75.704@suse.com>
	<20130129192913.4942c635@tlielax.poochiereds.net>
	<614F550557B82C44AC27C492ADA391AA044F2484@TK5EX14MBXC283.redmond.corp.microsoft.com>
	<20130130093729.736ad582@corrin.poochiereds.net>
	<614F550557B82C44AC27C492ADA391AA044F2E62@TK5EX14MBXC283.redmond.corp.microsoft.com>
	<510A3ECF.2080505@suse.com>
	<20130131062400.6aa8fb6d@tlielax.poochiereds.net>
	<51136B34.30609@suse.com>
	<20130207065018.0c18868e@tlielax.poochiereds.net>
	<614F550557B82C44AC27C492ADA391AA044FC781@TK5EX14MBXC283.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <614F550557B82C44AC27C492ADA391AA044FC781-Jfd81uAzPQsmBPcf4Gwd0Fir+X/St4rqwBk/1ggFUS45P9zcU8sUGwC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 7 Feb 2013 13:37:00 +0000
Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:

> > -----Original Message-----
> > From: Jeff Layton [mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > Sent: Thursday, February 7, 2013 6:50 AM
> > To: Suresh Jayaraman
> > Cc: Tom Talpey; linux-cifs
> > Subject: Re: Writes greater than 64k fails with -ENOSPC
> > 
> > On Thu, 07 Feb 2013 14:22:04 +0530
> > Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> > 
> > > On 01/31/2013 04:54 PM, Jeff Layton wrote:
> > > > On Thu, 31 Jan 2013 15:22:15 +0530
> > > > Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > >> On 01/30/2013 09:36 PM, Tom Talpey wrote:
> > > >>>> -----Original Message-----
> > > >>>> From: Jeff Layton [mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > > >>>> Sent: Wednesday, January 30, 2013 9:37 AM
> > > >>>> To: Tom Talpey
> > > >>>> Cc: Suresh Jayaraman; linux-cifs
> > > >>>> Subject: Re: Writes greater than 64k fails with -ENOSPC
> > > >>
> > > >>>>
> > > >>>> The spec is not 100% clear on whether servers are *required* to
> > > >>>> support arbitrarily large writes up to the 128k limit. Clearly
> > > >>>> there are some that do not, and a larger default is problematic against
> > those servers.
> > > >>>
> > > >>> I'd be very interested to see traces of negotiate, large read and large
> > write from such a server.
> > > >>
> > > >> I'm not sure whether I can share the complete trace (without
> > > >> customer's
> > > >> permission) but I can get you the specific bits that might be
> > > >> interesting. I have asked for a full trace (including negotiate protocol).
> > > >>
> > > >>
> > > >> Thanks
> > > >>
> > > >>
> > > >
> > > > We probably don't need the whole capture. Just the "Capabilities"
> > > > and "MaxBufferSize" values from the NEGOTIATE would be enough...
> > > >
> > >
> > > The commit ce91acb3acae26f4163c5a6f1f695d1a1e8d9009 did fix the
> > problem.
> > >
> > > Finally, got the packet capture too. From the NEGOTIATE response, the
> > > MaxBufferSize was 65280 and CAP_LARGE_WRITEX (and LARGE_READX)
> > had been set.
> > >
> > > The complete Capabilities were
> > >
> > > .... .... .... .... .... .... .... ...0 = Raw Mode: Read Raw and Write
> > > Raw are not supported .... .... .... .... .... .... .... ..0. = MPX
> > > Mode: Read Mpx and Write Mpx are not supported .... .... .... ....
> > > .... .... .... .1.. = Unicode: Unicode strings are supported .... ....
> > > .... .... .... .... .... 1... = Large Files: Large files are supported
> > > .... .... .... .... .... .... ...1 .... = NT SMBs: NT SMBs are
> > > supported .... .... .... .... .... .... ..1. .... = RPC Remote APIs:
> > > RPC remote APIs are supported .... .... .... .... .... .... .1.. ....
> > > = NT Status Codes: NT status codes are supported .... .... .... ....
> > > .... .... 1... .... = Level 2 Oplocks: Level 2 oplocks are supported
> > > .... .... .... .... .... ...0 .... .... = Lock and Read: Lock and Read
> > > is not supported .... .... .... .... .... ..1. .... .... = NT Find: NT
> > > Find is supported .... .... .... .... ...1 .... .... .... = Dfs: Dfs
> > > is supported .... .... .... .... ..1. .... .... .... = Infolevel
> > > Passthru: NT information level request passthrough is supported ....
> > > .... .... .... .1.. .... .... .... = Large ReadX: Large Read andX is
> > > supported .... .... .... .... 1... .... .... .... = Large WriteX:
> > > Large Write andX is supported .... .... .... ...0 .... .... .... ....
> > > = LWIO: LWIO ioctl/fsctl is not supported .... .... 0... .... ....
> > > .... .... .... = UNIX: UNIX extensions are not supported .... ..0.
> > > .... .... .... .... .... .... = Compressed Data: Compressed data
> > > transfer is not supported ..0. .... .... .... .... .... .... .... =
> > > Dynamic Reauth: Dynamic Reauth is not supported 0... .... .... ....
> > > .... .... .... .... = Extended Security: Extended security exchanges
> > > are not supported
> > >
> > >
> > > I'm not sure whether restricting it to MaxBufferSize even in case
> > CAP_LARGE_WRITEX was set would make sense..
> > >
> > 
> > No, I think that server just happens to have an unusually large
> > MaxBufferSize. Most servers send values that are smaller than that. The
> > whole idea behind CAP_LARGE_WRITEX is that it allows you to send a write
> > that's larger than the MaxBufferSize.
> 
> I agree, but it's still unhelpful that this server accepts only 64KB in response to the client's 124KB large write. In my opinion the server should not be offering CAP_LARGE_WRITEX, although it's certainly legal for it to do so. Perhaps your client should be ignoring it, when MaxBufferSize permits >64KB.
> 

Right. That was the crux of my question a few months ago -- the spec
doesn't say how much larger than the MaxBufferSize a server is required
to support. In practice, it seems a lot of server vendors didn't do any
more than they perceived they had to.

> BTW, we're investigating the large write size behaviors for a related MS-SMB doc bug. I don't have the full picture yet, but it appears that Windows SMB servers will process somewhere between 124KB and 128KB-1 bytes when issued a large WRITE_ANDX in this situation.
> 
> Tom.
> 

It's been a while since I wrote this code, but I originally did quite a
bit of testing vs. windows versions that were current at the time
(win2k8?). At that time, I never saw windows return a short write, but
we would generally issue writes that were no larger than 124k or so.

We generally use a max of 2^17-1, minus the length of the WRITE_ANDX
header (which is small), and then squeeze as many pages as we can fit
within it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
