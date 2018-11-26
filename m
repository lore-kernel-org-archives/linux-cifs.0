From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warnings after merge of the cifs tree
Date: Mon, 26 Nov 2018 11:52:47 +1100
Message-ID: <20181126115247.53cbf7be@canb.auug.org.au>
References: <20181126111415.5cf17f39@canb.auug.org.au>
        <CAH2r5mvtFzp=nYK+J92vh9y4tsNLT3rD4a2+mB9LMyWcFN-EHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/914m7+LezhCz7kA/2bBuqhG"; protocol="application/pgp-signature"
Cc: Sachin Prabhu <sprabhu@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>, keescook@google.com,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mvtFzp=nYK+J92vh9y4tsNLT3rD4a2+mB9LMyWcFN-EHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/914m7+LezhCz7kA/2bBuqhG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Sun, 25 Nov 2018 18:31:40 -0600 Steve French <smfrench@gmail.com> wrote:
>
> Both of those cases are intentional fallthroughs and there are
> existing comments in the code noting the reasons for them to
> fallthrough
>=20
> (also can see the reasoning for these in the commits which introduced
> them from Sachin c369c9a4a7c82) and dde2356c84662)

I am not questioning that :-)

The gcc warning can be turned off by adding a /* fall through */
comment at the point the fall through happens.  Kees and others are
working on the several hundred other places that need annotating.

This one just popped up.

--=20
Cheers,
Stephen Rothwell

--Sig_/914m7+LezhCz7kA/2bBuqhG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlv7Q98ACgkQAVBC80lX
0GxJXwf/YbJmvqG4cflEZDjeqL/qziZ5xfP7S3vWetuFVBU+fYrAGVxeKhRHmb2F
6fk3UNhtanCj895jn4xW7JhyKJ3PBkrtwJRcYtnfGR1TwhXvLX/wwGOFi1PqfUKe
1tdBF29iXUoKik8lqMGUpJFCDpTSems77gMSuvz1I3B5/rMMueXqdLBaQpGROm1q
/OrNs0yJ89EKiIrGNLH/ii6c5Fx2z66/P6fkx2rO0fACbgJy1V3UimaStofutHJw
8WyLjhiYzUBnuEnLB8GbBJCIz8iFUw6UnfrZgdXsjpIwxNhPd3t/38oScK+FzWm9
9eaTlVopq0D91mJbp5BVElIsdjC6aQ==
=p9lr
-----END PGP SIGNATURE-----

--Sig_/914m7+LezhCz7kA/2bBuqhG--
