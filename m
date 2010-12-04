From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 06:28:37 -0500
Message-ID: <20101204062837.55cb13a2@tlielax.poochiereds.net>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF9BB65.2010307-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 03 Dec 2010 21:54:13 -0600
"Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Jeff Layton wrote:
> :
> :
> > Timeouts:
> > =========
> > It's tempting to think of SMB as being very similar to NFS/RPC, but
> > when it comes to low-level transport, there are significant
> > differences. ONC-RPC was designed for connectionless transports and has
> > the concept of a retransmission. SMB however does not -- it was
> > originally layered on NetBIOS sessions and so has always been assumed
> > to run on a connection-based transport.
> 
> ...with the exception of the Direct Hosted IPX transport.  IPX is
> connectionless.  In order to accommodate this connectionless transport, SMB
> was actually modified (slightly).
> 
> That may seem to be in the "who cares" category, since those old transports
> are essentially dead (much more dead than NBT, or even NBF).  Unfortunately,
> the code to handle the old transports is still there in Windows, so there
> are behaviors -- things like the timeouts you're talking about and the weird
> VC=0 shutdown behvior -- that exist because of these old disused transports.
> 
> Ugh.  Eh?
> 

Yeah, Direct Hosted IPX is a lot more like NFS/RPC. MS essentially
shoehorned in a way to do request retransmissions. It's a pretty
impressive kludge! I suppose we could theorize that that legacy is why
Windows times out individual requests so aggressively, but maybe there
are other design concerns behind that behavior.

In this case however it really is a "don't care" for us in Linux CIFS
land since we have never implemented it on top of IPX or any other
non-connected transport and have no plans to do so.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
