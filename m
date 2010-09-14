From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -v3 3/4 cifs] NTLMv2/NTLMSSP define crypto hash
 functions and create and send keys needed for key exchange
Date: Tue, 14 Sep 2010 10:33:14 -0400
Message-ID: <20100914103314.55c198ed@corrin.poochiereds.net>
References: <1284405339-31226-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100914083358.45c05914@corrin.poochiereds.net>
	<AANLkTim_S1kxVGRs-q1kSTAtsEvEE9ey-M2Aeb=yt76k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim_S1kxVGRs-q1kSTAtsEvEE9ey-M2Aeb=yt76k-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Sep 2010 09:15:38 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is =
an empirical value, large enought to
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* hol=
d authenticate message, max 10 of
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* av =
paris, doamin,user,workstation mames,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fla=
gs etc..
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspb=
lob =3D kmalloc(5 *
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 sizeof(struct _AUTHENTICATE_MESSAGE),
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 GFP_KERNEL);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^=
 when does this get freed?
>=20
> It gets freed in build_ntlmssp_auth_blob, once the contents are copie=
d.
>=20

I don't think it does. It gets passed to that function as the
'pbuffer', and then cast to 'sec_blob'. I don't see where it gets freed
at all.

Even if you're correct though, that's really messy and unclear. I
think it would be best to free it in this function before you exit that
block.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
