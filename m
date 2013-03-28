From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Packet signing and sequence numbers
Date: Thu, 28 Mar 2013 06:51:52 -0400
Message-ID: <20130328065152.3f340f60@corrin.poochiereds.net>
References: <51536712.9060504@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hzcTRn2X8SZ407OeSMHrgVU"; protocol="application/pgp-signature"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51536712.9060504-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/hzcTRn2X8SZ407OeSMHrgVU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Mar 2013 17:39:30 -0400
Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I notice the patch in this message
>=20
> http://thread.gmane.org/gmane.linux.kernel.cifs/7655/focus=3D7671
>=20
> Never made it into Linus's tree. It's also not in Debian or RedHat's
> kernels. I'm running into this on CentOS.
>=20
> Has there been any activity on this issue since December?
>=20
> Incidentally, I filed a bug report on bugs.redhat.com relating to what
> I'm hitting:
>=20
> https://bugzilla.redhat.com/show_bug.cgi?id=3D928516
>=20

If you have a support contract with Red Hat, then it would be best to
open a support case, which will help make the case for its inclusion
into the RHEL kernel.

> I'm looking for a good reason to (or to not) apply the patches to the
> current RH kernel on my systems; I rather need it for my current project.
>=20
> (I'd respond via the linux-cifs list, but Thunderbird is being a PITA
> and preventing me from subscribing to it via gmane's NNTP, through which
> I'd be able to reply to the thread directly...)
>

You're correct that it never made it in. I think the patch makes
sense...Steve, was there some reason you didn't merge it?

In the meantime, if you're able to test the patch and reply on-list
with the results then that would be helpful.

Thanks,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--Sig_/hzcTRn2X8SZ407OeSMHrgVU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRVCDPAAoJEAAOaEEZVoIV4TEP/0UALA6+KPkFYkX7GfZgx6N7
bgGC2uOfTcgWxsB6uJSoc9CGD+iNJzac6jnMESY+STC9h1/BwmOdfA8x/bVEJFz9
QcTNjRdTtM0f3EqB5rDiyWoi6zsVFECFb9Nma8PvSHGvdKDeBSGB655IbdUVWRI0
2ekmvUlHgnF0254r83ckNhoAArh6GFgw7UATV5FTtSnXbY7vTEvGtNvTnhR7ldHV
9QeM5z+XReP42DCxXlkkmVus1he2uVj4Ma8kDxIzsMAvB5scurtkUO1q+ugXIm11
+eiywSe/1PwC0HgjE+WDI8SXPgi36XUYHI8h5aQFoOVdMPlBW1J73Tix4aMScGTz
jLU7vQbnmZCQppxrCvAWfmMRukIOGAS4bkq7QXoYcTUgTLpWXAP9pRs0xWJzaMz7
zmZ5xrF08fR3mlaXSqkKtVjX7ozGTdn/N4yafLTEgcneu5JZU+j2bAkld69Iq/pL
Ms7p+zmohVz7SNgZRm/7weEA6b/9xhna6VahQoEAnquBpSwW9FyjGp3qyLsSra1B
ok0metEcfLl7LUcDMPSHcg9jv5Zv1q7VD9JtVdM0lrkGw6UVfDlZejmSsd+5L0Sr
qkfYXC2qPeSBDFvStx1nlVPmi5BCxY/jhZPY7jQ2ZLxAavcjKLU5j2YfSyz5tDAt
Yo1DsyQmgfZxIaW/vL+q
=yc+0
-----END PGP SIGNATURE-----

--Sig_/hzcTRn2X8SZ407OeSMHrgVU--
