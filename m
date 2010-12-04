From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Fri, 03 Dec 2010 21:54:13 -0600
Message-ID: <4CF9BB65.2010307@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101203212811.17594274-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton wrote:
:
:
> Timeouts:
> =========
> It's tempting to think of SMB as being very similar to NFS/RPC, but
> when it comes to low-level transport, there are significant
> differences. ONC-RPC was designed for connectionless transports and has
> the concept of a retransmission. SMB however does not -- it was
> originally layered on NetBIOS sessions and so has always been assumed
> to run on a connection-based transport.

...with the exception of the Direct Hosted IPX transport.  IPX is
connectionless.  In order to accommodate this connectionless transport, SMB
was actually modified (slightly).

That may seem to be in the "who cares" category, since those old transports
are essentially dead (much more dead than NBT, or even NBF).  Unfortunately,
the code to handle the old transports is still there in Windows, so there
are behaviors -- things like the timeouts you're talking about and the weird
VC=0 shutdown behvior -- that exist because of these old disused transports.

Ugh.  Eh?

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
