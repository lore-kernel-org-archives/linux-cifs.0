From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 30/45] CIFS: Enable signing in SMB2
Date: Wed, 22 Aug 2012 15:46:06 +0200
Message-ID: <5034E29E.7030006@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org> <1342626541-29872-31-git-send-email-pshilovsky@samba.org> <k0vdnf$434$1@ger.gmane.org> <CADT32e+4DSN=CSCbL+8GoRePknpD3X0HSq1hjVsXf3KHXQcmTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3C399DB6E50AEE4A062A6288"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+4DSN=CSCbL+8GoRePknpD3X0HSq1hjVsXf3KHXQcmTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3C399DB6E50AEE4A062A6288
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Shirish,

> On Tue, Aug 21, 2012 at 2:35 AM, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
>> Hi Pavel,
>>
>>> Use hmac-sha256 and rather than hmac-md5 that is used for CIFS/SMB.
>>>
>>> Signature field in SMB2 header is 16 bytes instead of 8 bytes.
>>
>> Sorry for the late reply, I just found a reference to this patch...
>>
>> To me it seems that this patch doesn't take care of the fact that
>> the signing key in SMB2/3 belongs to the session and not to the transp=
ort
>> connection.
>=20
> metze, where do you see that?  This is the signing key that is used to =
generate
> signature, server->session_key.response.

And 'server' is a per connection state not per session...
which is ok for smb1 but not for smb2.

>> Does the SMB2 code support multiuser mounts yet?
>>
>> Why are you using some "BSRSPYL " magic? I only saw that from Windows
>> clients
>> using SMB1. (Note: that servers just echo the signature from the
>> request, if they don't do signing).
>=20
> IIRC, Jeff Layton added that code to encode BSRSPYL magic (string).
> I could be wrong, it has been a while.
> But, I do think this is a problem, signature in a smb message is not ev=
en
> checked till key exchange handshake is session setup is done, right?

A session setup response with STATUS_SUCCESS is the first signed message.=

Before that the server just echos what the client sends.

For SMB1 windows client (and smbclient) send BSRSPYL if they would like t=
o
turn on signing later. But for SMB2 windows and samba send just zeros,
which cifs.ko should also do.

metze


--------------enig3C399DB6E50AEE4A062A6288
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlA04qIACgkQm70gjA5TCD+peACfQKf5syhg6yoS979Dc6FURaiC
hm8AnRWAVLlW4rHi8f9MjMW31OWP6TZz
=cwTF
-----END PGP SIGNATURE-----

--------------enig3C399DB6E50AEE4A062A6288--
