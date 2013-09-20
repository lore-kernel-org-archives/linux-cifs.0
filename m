From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [PATCH] cifs: stop trying to use virtual circuits
Date: Thu, 19 Sep 2013 17:24:23 -0700
Message-ID: <E1VMoWX-003V7i-7T@intern.SerNet.DE>
References: <1379345025-10868-1-git-send-email-jlayton@redhat.com>
 <E1VMJ0n-001ZxR-I8@intern.SerNet.DE>
 <20130918110535.6abc3372@tlielax.poochiereds.net>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sauron99-Mmb7MZpHnFY@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Thu, 19 Sep 2013 17:24:23 -0700
Content-Disposition: inline
In-Reply-To: <20130918110535.6abc3372-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 18, 2013 at 11:05:35AM -0400, Jeff Layton wrote:
> Agreed, but I'm not convinced that there's really a downside.
>=20
> We don't currently use share modes, so that shouldn't be an issue.
> Pavel's patchset may eventually change that, but I don't see it
> happening anytime too soon.
>=20
> My initial thinking was that we might end up not getting an oplock on=
 a
> reconnect when we held one before. OTOH, one would think that if the
> client was reclaiming the open file, the server would try to issue an
> oplock break on the previous connection. At that point, it should fin=
d
> that it's dead anyway, so that also shouldn't be an issue.
>=20
> Implementing CIFS clearly states that VC handling by servers is spott=
y
> at best, so I think we're best off avoiding any use of them.
>=20
> In principle, we could add a knob that tells the server to use vcnum=3D=
=3D0
> on the first session to allow it to opt-in to this behavior, but I'd
> prefer not to do that until someone demonstrates a clear need for it =
so
> we can understand how best to implement it.
>=20
> If we did need to do that, there's clearly no need to use a different
> vcnum on every session. Simply using vcnum=3D=3D0 on the first one an=
d then
> vcnum=3D=3D1 on every subsequent one would be sufficient.

Ack.

Volker

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
