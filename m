From: Jeff Layton <jlayton@samba.org>
Subject: Re: [linux-cifs-client][patch] Make NTLMv2 as auth mech withing
 NTLMSSP and enable signing using crypto shash APIs
Date: Sat, 21 Aug 2010 19:38:17 -0400
Message-ID: <20100821193817.7800d19d@tlielax.poochiereds.net>
References: <1280975679-9096-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100821071441.3b9cbef5@tlielax.poochiereds.net>
	<AANLkTi=79uJyM-i99KxrEmyECPoCPXPnsdY7HwGc9UtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	samba-technical@samba.org, linux-crypto@vger.kernel.org
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=79uJyM-i99KxrEmyECPoCPXPnsdY7HwGc9UtA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, 21 Aug 2010 09:23:11 -0500
Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:

> On Sat, Aug 21, 2010 at 6:14 AM, Jeff Layton <jlayton@samba.org> wrot=
e:
> > On Wed, =A04 Aug 2010 21:34:39 -0500
> > shirishpargaonkar@gmail.com wrote:
> >
> >> Make ntlmv2 as an authentication mechanism within ntlmssp
> >> instead of ntlmv1.
> >> Parse type 2 response in ntlmssp negotiation to pluck
> >> AV pairs and use them to calculate ntlmv2 response token.
> >> Also, assign domain name from the sever response in type 2
> >> packet of ntlmssp and use that (netbios) domain name in
> >> calculation of response.
> >>
> >> Enable cifs/smb signing using rc4 and md5.
> >>
> >> Changed name of the structure mac_key to session_key to reflect
> >> the type of key it holds.
> >>
> >> Use kernel crypto_shash_* APIs instead of the equivalent cifs func=
tions.
> >>
> >>
> >> From 6ab552fd60804f3c708e1745ca936112fc9f9821 Mon Sep 17 00:00:00 =
2001
> >> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> >> Date: Wed, 4 Aug 2010 17:24:07 -0500
> >> Subject: [PATCH] Make ntlmv2 as auth mech and enable signing using=
 crypto_shash APIs
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> >> ---
> >> =A0fs/cifs/asn1.c =A0 =A0 =A0 =A0| =A0 =A06 +-
> >> =A0fs/cifs/cifsencrypt.c | =A0416 ++++++++++++++++++++++++++++++++=
++--------------
> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 18 ++-
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +-
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 12 +-
> >> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 13 +-
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 13 ++-
> >> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 13 ++
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0118 +++++++++++----
> >> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
> >> =A010 files changed, 450 insertions(+), 172 deletions(-)
> >>
> >
> > Overall this looks like a good change, but this patch is rather lar=
ge.
> > That makes it tough to bisect for bugs and to review...
> >
> > Would it be possible to break it up some? Maybe a patch (or patches=
) to
> > convert the existing code to using the crypto api's and then anothe=
r
> > set to fix up the NTLMSSP code?
> >
> > Also, with the conversion to the crypto API's can we remove some of=
 the
> > cifs private crypto routines in smbencrypt.c? That would be a nice
> > follow-on patch. It seems like switching to use the crypto API's sh=
ould
> > mean a net reduction in code.
> >
> >> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
> >> index cfd1ce3..21f0fbd 100644
> >> --- a/fs/cifs/asn1.c
> >> +++ b/fs/cifs/asn1.c
> >> @@ -597,13 +597,13 @@ decode_negTokenInit(unsigned char *security_=
blob, int length,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (co=
mpare_oid(oid, oidlen, MSKRB5_OID,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 MSKRB5_OID_LEN))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 server->sec_mskerberos =3D true;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if =
(compare_oid(oid, oidlen, KRB5U2U_OID,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (comp=
are_oid(oid, oidlen, KRB5U2U_OID,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0KRB5U2U_OID_LEN))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 server->sec_kerberosu2u =3D true;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if =
(compare_oid(oid, oidlen, KRB5_OID,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (comp=
are_oid(oid, oidlen, KRB5_OID,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0KRB5_OID_LEN))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 server->sec_kerberos =3D true;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if =
(compare_oid(oid, oidlen, NTLMSSP_OID,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (comp=
are_oid(oid, oidlen, NTLMSSP_OID,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NTLMSSP_OID_LEN))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 server->sec_ntlmssp =3D true;
> >>
> >
> > Why change the above? If compare_oid returns true on any of them, t=
hen
> > the others will return false. The else clauses ought to stay, IMO..=
=2E
>=20
> Jeff, with this the authentication mechanism always defaults to kerbe=
ros
> (if server supports it) even if an user wants to use a different auth
> mech this way
> e.g. sec=3Dntlm/ntlmi or sec=3Dntlmv2/ntlmv2i.
>=20

I don't think we're talking about the same thing here.

The above change doesn't change which of the sec_* flags end up set
when decode_negTokenInit returns. It just means that the function does
more parsing than it needs to.

The change you're talking about is the one in CIFS_SessSetup. That one
looks correct, I think.

--=20
Jeff Layton <jlayton@samba.org>
