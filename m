From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Source for winucase.c
Date: Fri, 18 Oct 2013 06:43:05 -0400
Message-ID: <20131018064305.57a78574@tlielax.poochiereds.net>
References: <1382058269.2794.11.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/76m6tIMD/vxy9yO8lWvx.vA"; protocol="application/pgp-signature"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	"Bradley M. Kuhn" <bkuhn-vUrtt4mpz3m9WkS168ly19i2O/JbrIOy@public.gmane.org>
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382058269.2794.11.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/76m6tIMD/vxy9yO8lWvx.vA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Oct 2013 02:04:29 +0100
Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org> wrote:

> fs/cifs/winucase.c is commented as:
>=20
>  * The const tables in this file were converted from the following info
>  * provided by Microsoft:
>  *
>  * 3.1.5.3 Mapping UTF-16 Strings to Upper Case:
>  *
>  * http://msdn.microsoft.com/en-us/library/hh877830.aspx
>  * http://www.microsoft.com/en-us/download/details.aspx?displaylang=3Den&=
id=3D10921
>  *
>  * In particular, the table in "Windows 8 Upper Case Mapping Table.txt" w=
as
>  * post-processed using the winucase_convert.pl script.
>=20
> Isn't "Windows 8 Upper Case Mapping Table.txt" then the preferred form
> for modification of the tables?  In which case, it should be included in
> the kernel sources.
>=20
> Also, shouldn't this file acknowledge Microsoft's copyright, if it's a
> derivative work of their file?
>=20
> Ben.
>=20

(cc'ing samba-technical and Bradley Kuhn in the hopes that he can help
clarify)

Good questions. I'm not certain on either point. When I queried the MS
folks about the licensing on that file, they said:

"I discovered the content you used is in fact referenced by the
 MS-UCODEREF document, in section 3.1.5.2.3.1   Windows Sorting Weight
 Table. I discussed with the appropriate folks here, and for use in
 Samba it's certainly covered under Samba's existing PFIF license."

Bradley, any thoughts as to Ben's questions?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--Sig_/76m6tIMD/vxy9yO8lWvx.vA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYRC5AAoJEAAOaEEZVoIV8RgP/27xte29S8/Ca8u/cEXDXUac
OPdqaWRYHfrBJiZdshiUbYvrF6yVKrdMquTBL7C0FIZWlUamYkd3LEMSFPlsCbWz
x7HBof1gDDyQMpcGxq2E5tsUfyIBsnACi4BJaOt/wmAnsBWqY/uHMRsmHRb3uTum
3TJYBOBhESmVAqEHy5fk7BmecVECLmY/pC7UuLG/M9xw++p+GmdJX1x0ukXnuxu7
HWKJQgfBM2FB3cbrfyA8IUl7jUIFROX8GcxcbflPF2AnmaSpSRVrmFvuCK4AzA8U
2I/6dKyKLywltiupD5UtXrdA6aZUBBOZIw72TSPeGZ4QfPxEAOysxpJn9Fztg+DK
YOOwRqDj+3ZXbwdPKEsdXxg7kqG4jRQ/Edo1dIkuQBz9EiLFs/fvZk6oEGWGW2DN
NFUOK7/9X5sOF2lg/m8pbqUYijVYCE7xmygo147ZGlgfNpq9k/2ptgTZ9aac/H/6
Mk+Zo/AxL8IwnZmlS1mpNR3AGGjgU1WUFVd/i6flbRTW9zK6G1XKTxujR3t9/g5o
S5KzBtF0rF/ihjCKqqR2jAZ3lgRTsMOxGUNixfuC1ukPMUigAHUW1/mmRUjXDkRb
imnJaCNuTdQ6l/iTedVMB3QpokgGtB4Quhe5KSyqco/AyX7qPxVn45aRon3mj9hs
K3mLnFo5l/0ahEtuDZ3s
=F5y/
-----END PGP SIGNATURE-----

--Sig_/76m6tIMD/vxy9yO8lWvx.vA--
