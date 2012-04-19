From: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier
	<fredlwm-fLz7/M+a0ZzR7s880joybQ@public.gmane.org>
Subject: Re: CIFS shares keep hanging with VirtualBox
Date: Thu, 19 Apr 2012 20:39:06 -0300
Message-ID: <20120419233906.GB4574@pervalidus>
References: <20120419173627.GA4337@pervalidus>
 <20120419135151.6745d624@corrin.poochiereds.net>
 <20120419194357.GA4574@pervalidus>
 <CAH2r5muAnRf-cNbE2WH6a1fZmX+diti+bbtCK-iju7wdKm7L8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muAnRf-cNbE2WH6a1fZmX+diti+bbtCK-iju7wdKm7L8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Apr 19, 2012 at 03:19:13PM -0500, Steve French wrote:
> On Thu, Apr 19, 2012 at 2:43 PM, Fr=E9d=E9ric L. W. wrote:
> >
> > I captured a log with 'tcpdump', but I don't think it's of any use.=
 It
> > stopped logging at 16:01 but the hang happened after that. It didn'=
t log
> > anything from the problematic 'ls', 'kill -9' and 'umount /mnt/ntfs=
2'.
>=20
> Maybe capture a log (with netmon on wireshark) on the windows side
> to see what the trace shows.
>=20
> Presumably some odd networking issue with virtual box, but
> may  be useful to see which command fails/timesout by
> looking at dmesg output on the client (running the
> test after enabling /proc/fs/cifs/cifsFYI setting it
> to 7 e.g.).
>=20
> At least with the server returning maxmpx of 50, it is less
> likely to be the bug with too many outstanding requests.

I noticed that if I change the connection in VirtualBox from NAT to=20
Bridged Adapter, the hangs don't occur (at least after about 2h).

Are you still interested in a log from Windows in NAT mode, where the=20
hangs happen, or this is definitely an issue / "feature" in VirtualBox =
?

What I don't know is if CIFS could do anything to exit gracefully=20
instead of deadlocking the application trying to access the share.
