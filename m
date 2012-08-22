From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 00/10] SMB2 brlocks, leases and multicredit io
Date: Wed, 22 Aug 2012 15:47:26 +0200
Message-ID: <5034E2EE.3060908@samba.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org> <k0vjao$hck$1@ger.gmane.org> <CAKywueRsBYRyCFMjWEhtTS5GP2PWqv4Y_W49q+Q+egBo-xCY3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC719E186F4C7AD01BEFBCE7E"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRsBYRyCFMjWEhtTS5GP2PWqv4Y_W49q+Q+egBo-xCY3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC719E186F4C7AD01BEFBCE7E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

>>> This is a patchset that includes the rest of SMB2 changes: brlocks, l=
eases and multicredit io.
>>>
>>> The changes are applied on top of Jeff's recent patchset and can be f=
ound here:
>>> http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3Ds=
hortlog;h=3Drefs/heads/smb2-dev-cork
>>>
>>> Pavel Shilovsky (10):
>>>   CIFS: Improve byte-range locks handling
>>>   CIFS: Handle SMB2 lock flags
>>>   CIFS: Move brlock code to ops struct
>>>   CIFS: Add brlock support for SMB2
>>>   CIFS: Request SMB2.1 leases
>>>   CIFS: Add SMB2.1 lease break support
>>>   CIFS: Fix cache coherency for read oplock case
>>>   CIFS: Make use of multicredit write for SMB2
>>>   CIFS: Make use of multicredit reads for SMB2
>>
>> Leases and multi-credit support are negotiated features in the capabil=
ities
>> bits of the server. You should not rely on the dialect before you use =
them,
>> as there're servers which support SMB 2.1, but do not support leases o=
r
>> multi-credit.
>=20
> Ok, thanks - will fix this.
>=20
>>
>> I think smb2_get_credit_size() should return 1 if the value in the hea=
der
>> is 0.
>=20
> It brings no problem because CreditCharge value is set to 1 in header
> assemble (and can be rewritten further in async read and write
> codepath) - so, get_credit_size gets at least 1.

If the server doesn't support multi-credit, the client should send 0.

metze


--------------enigC719E186F4C7AD01BEFBCE7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlA04vIACgkQm70gjA5TCD8tQACcDZjSoDj1gVI4nFI0DqQORzp2
clsAoKP4JSMyyw7m+JrLnJRAaZIYFQrB
=S270
-----END PGP SIGNATURE-----

--------------enigC719E186F4C7AD01BEFBCE7E--
