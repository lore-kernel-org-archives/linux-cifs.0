From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Writes greater than 64k fails with -ENOSPC
Date: Thu, 31 Jan 2013 06:24:00 -0500
Message-ID: <20130131062400.6aa8fb6d@tlielax.poochiereds.net>
References: <5107BF75.704@suse.com>
	<20130129192913.4942c635@tlielax.poochiereds.net>
	<614F550557B82C44AC27C492ADA391AA044F2484@TK5EX14MBXC283.redmond.corp.microsoft.com>
	<20130130093729.736ad582@corrin.poochiereds.net>
	<614F550557B82C44AC27C492ADA391AA044F2E62@TK5EX14MBXC283.redmond.corp.microsoft.com>
	<510A3ECF.2080505@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510A3ECF.2080505-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 31 Jan 2013 15:22:15 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 01/30/2013 09:36 PM, Tom Talpey wrote:
> >> -----Original Message-----
> >> From: Jeff Layton [mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> >> Sent: Wednesday, January 30, 2013 9:37 AM
> >> To: Tom Talpey
> >> Cc: Suresh Jayaraman; linux-cifs
> >> Subject: Re: Writes greater than 64k fails with -ENOSPC
> 
> >>
> >> The spec is not 100% clear on whether servers are *required* to support
> >> arbitrarily large writes up to the 128k limit. Clearly there are some that do
> >> not, and a larger default is problematic against those servers.
> > 
> > I'd be very interested to see traces of negotiate, large read and large write from such a server.
> 
> I'm not sure whether I can share the complete trace (without customer's
> permission) but I can get you the specific bits that might be
> interesting. I have asked for a full trace (including negotiate protocol).
> 
> 
> Thanks
> 
> 

We probably don't need the whole capture. Just the "Capabilities" and
"MaxBufferSize" values from the NEGOTIATE would be enough...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
