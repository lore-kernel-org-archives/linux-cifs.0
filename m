From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: default security mechanism for 3.1
Date: Fri, 23 Sep 2011 11:26:24 -0400
Message-ID: <20110923112624.6449194e@tlielax.poochiereds.net>
References: <20110923081620.40c0aa17@tlielax.poochiereds.net>
	<4E7C7AA1.2060402@suse.com>
	<20110923094321.1e848857@tlielax.poochiereds.net>
	<CADT32e+KDBM=_jOm4m0cirQGeO7YfH4RADb5fbv7dcvUGG9j+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+KDBM=_jOm4m0cirQGeO7YfH4RADb5fbv7dcvUGG9j+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Sep 2011 10:14:32 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Sep 23, 2011 at 8:43 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 23 Sep 2011 17:55:05 +0530
> > Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> >
> >> On 09/23/2011 05:46 PM, Jeff Layton wrote:
> >> > A printk warning was added to the kernel about the default secur=
ity
> >> > mode changing in 3.1. As best I can tell though, that has not ha=
ppened
> >> > even though the release is imminent. Are you still planning to c=
hange
> >> > that? If not, are you planning to fix the printk?
> >> >
> >>
> >> Did you mean this one?
> >> =C2=A0 =C2=A0http://www.spinics.net/lists/linux-cifs/msg03976.html
> >>
> >> I remember Steve posted this patch sometime ago but I'm not seeing=
 them
> >> in the cifs development tree..
> >>
> >>
> >> -Suresh
> >
> > Yeah, that's the one. Seems a little late to be adding these sorts =
of
> > behavior changes in 3.1 though, so I'm just wondering what the plan=
 is.
> >
> > I also have some concerns about defaulting to raw NTLMv2 auth since=
 (at
> > least) win2k8 rejects unless you go in and tweak registry keys. It
> > would seem to me to be better to decide the default based on the
> > negotiation:
> >
> > Set extended security bit in the NegProt by default
> >
> > If the server sets it, then use NTLMSSP
>=20
> Not sure if there are any cifs/smb servers that support
> extended security mechanisms but ntlmssp not being
> one of them, we ought to consider that such a setup
> before choosing ntlmssp if the server set extended
> security bit in negprot response.
>=20

Seems unlikely. If the server doesn't support NTLMSSP then it probably
won't allow login via any password mechanism. That said, it wouldn't
hurt to also fall back to non-NTLMSSP auth if the server doesn't list
NTLMSSP in the SPNEGO blob in the NEGOTIATE reply. That has a (slight)
chance of working...

> >
> > If it doesn't then use old NTLM (or NTLMv2)
> >
> > That means an overhaul of how sec_mode is handled though, since tha=
t's
> > currently decided too early to do it that way.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
