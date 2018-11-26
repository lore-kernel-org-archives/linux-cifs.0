From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warnings after merge of the cifs tree
Date: Mon, 26 Nov 2018 17:51:35 +1100
Message-ID: <20181126175135.0565aac5@canb.auug.org.au>
References: <20181126111415.5cf17f39@canb.auug.org.au>
        <CAH2r5mvtFzp=nYK+J92vh9y4tsNLT3rD4a2+mB9LMyWcFN-EHA@mail.gmail.com>
        <20181126115247.53cbf7be@canb.auug.org.au>
        <CAGXu5jJDbUZBmbx1ODS72WJKfcv20aMZczq=k4p4OhG8SV0roQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UEm_H+MQSISvw_W=pTyeV2T"; protocol="application/pgp-signature"
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, smfrench@gmail.com,
        sprabhu@redhat.com, linux-cifs@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJDbUZBmbx1ODS72WJKfcv20aMZczq=k4p4OhG8SV0roQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/UEm_H+MQSISvw_W=pTyeV2T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kees,

On Sun, 25 Nov 2018 21:48:10 -0800 Kees Cook <keescook@google.com> wrote:
>
> On Sun, Nov 25, 2018 at 4:52 PM Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > On Sun, 25 Nov 2018 18:31:40 -0600 Steve French <smfrench@gmail.com> wr=
ote: =20
> > >
> > > Both of those cases are intentional fallthroughs and there are
> > > existing comments in the code noting the reasons for them to
> > > fallthrough
> > >
> > > (also can see the reasoning for these in the commits which introduced
> > > them from Sachin c369c9a4a7c82) and dde2356c84662) =20
> >
> > I am not questioning that :-)
> >
> > The gcc warning can be turned off by adding a /* fall through */
> > comment at the point the fall through happens.  Kees and others are
> > working on the several hundred other places that need annotating. =20
>=20
> Right. The goal is to avoid adding any _new_ cases of this. :)
>=20
> > This one just popped up. =20
>=20
> It's already working! :) Thanks Stephen!

Actually this one was the product of how I filter out warnings ... it
was an old one, but the line numbers changed.   I have now started
ignoring these if just the line numbers change.

--=20
Cheers,
Stephen Rothwell

--Sig_/UEm_H+MQSISvw_W=pTyeV2T
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlv7l/cACgkQAVBC80lX
0GxSXwf/fqJUCWHyZZqhrb1v7n3vzWH/3jC+zrJo8oh2mNXgwja9WVHHqnQT5iP8
eJnQOSw5PH5+lhLc+IKnSRI6l3UDHTMG363PXnik000cc4N9e7bhfv8glqgKMpOK
9yqTlx1ekwkzjo5t5+j6UJ79dAJ8JZkHel/LbS9PdH56FPZWv29rmuPGI4vqN+rk
VH3HJ0HWtv9JEtJOLOy69xqVUO0AbjrYcgI6J9uvxYG59Z1naqPWFRryo3yQl+me
oZ1qIn0D4BbHPjnuwxYgLoAaKbOMsqlU2suxd8RYI5GKL465u1LfdnyOiunyyiIS
HMiwkL5tilwbWjG14Ep+SEqoKBHTyA==
=7Cht
-----END PGP SIGNATURE-----

--Sig_/UEm_H+MQSISvw_W=pTyeV2T--
