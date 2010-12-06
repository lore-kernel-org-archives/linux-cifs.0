From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 6 Dec 2010 05:35:42 +0100
Message-ID: <E1PPSnw-00DDbF-Dl@intern.SerNet.DE>
References: <20101203212811.17594274@tlielax.poochiereds.net>
 <E1POnFL-00BKfp-6h@intern.SerNet.DE>
 <1291603591.22122.3.camel@ruth>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Mon, 6 Dec 2010 05:35:42 +0100
Content-Disposition: inline
In-Reply-To: <1291603591.22122.3.camel@ruth>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Dec 06, 2010 at 01:46:31PM +1100, Andrew Bartlett wrote:
> Is it correct to say that this is how Samba3 deals with slow calls and
> Windows clients, using the echo handling child?

Yes.

Volker
