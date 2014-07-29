From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 00/16] SMB 2.1/3 multicredit requests for reading/writing
Date: Tue, 29 Jul 2014 09:40:03 +0200
Message-ID: <53D74FD3.4050004@samba.org>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>	<53D6AF1E.4030804@samba.org> <CAKywueRBDjsDVz_uR39xAGbp6VQD40erCvWGX5bWLpFOUJqYtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4sn3CGjH3bSehA5bSI4V09Jess63vn0kQ"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRBDjsDVz_uR39xAGbp6VQD40erCvWGX5bWLpFOUJqYtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4sn3CGjH3bSehA5bSI4V09Jess63vn0kQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

> 2014-07-29 0:14 GMT+04:00 Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> Hi Pavel,
>>
>>> The goal of this patchset is to add large MTU/multicredits support fo=
r reading and writing from the CIFS client to servers > that support SMB =
2.1 and higher versions of the protocol.
>>
>> Are looking at the returned capabilities from the server or just the
>> dialect?
>> The answer should really be the capability, it's wrong to rely on the
>> dialect...
>>
>> metze
>=20
> Hi Stefan,
>=20
> The code of the patchset is looking at the returned
> MaxReadSize/MaxWriteSize values from the server. If they are greater
> than 64K, the module uses multicredit requests. Also it only works for
> SMB 2.1 and higher versions and is disabled for SMB2.0.
>=20
> The spec says (http://msdn.microsoft.com/en-us/library/cc246768.aspx):
>=20
> "If the common dialect is SMB 2.1 or 3.x dialect family and the
> underlying connection is either TCP port 445 or RDMA,
> Connection.SupportsMultiCreditMUST be set to TRUE; otherwise, it MUST
> be set to FALSE."
>=20
> So, it seems like the server must should multicredit requests if
> negotiating SMB 2.1 or 3.x protocols.
>=20
> Anyway, if the server sets MaxRead(Write)Size value to more than 64K
> and does not support multicredit requests, this server looks like a
> broken one.
>=20
> I can add a check for MTU capability bit for SMB 2.1 and 3.x protocols
> before the check of MaxRead(Write)Size value and let the code fall
> back to the 64K per request if this bit is missed.

I'd prefer to have this extra check, you never know if some vendors are
crazy
enough to run Samba 4.0.0alpha* release. Samba got SMB2.1 support in
September 2011
and multi-credit support in February 2012.

metze



--4sn3CGjH3bSehA5bSI4V09Jess63vn0kQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPXT9YACgkQm70gjA5TCD/JDACdGU6Zwelrw78WHsmxb20tl7zt
5FcAoK/BeDHrTvKOfE7ohgPIRWoh1N+y
=i5ir
-----END PGP SIGNATURE-----

--4sn3CGjH3bSehA5bSI4V09Jess63vn0kQ--
