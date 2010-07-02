From: Andrew Bartlett <abartlet@samba.org>
Subject: Re: [linux-cifs-client] Linux CIFS NTLMSSP mount failing against
	win2k8
Date: Fri, 02 Jul 2010 11:11:47 +1000
Message-ID: <1278033107.2358.23.camel@ruth>
References: <20100410181730.7fa0af32@tlielax.poochiereds.net>
	<20100411064103.3ec408a1@tlielax.poochiereds.net>
	<m2u4a4634331004111242u2954f28fh4bd703922c9aa534@mail.gmail.com>
	<20100411194008.77aad10c@corrin.poochiereds.net>
	<1271199692.2518.19.camel@naomi.s4.naomi.abartlet.net>
	<20100414082944.3fc80df9@tlielax.poochiereds.net>
	<20100414113453.6a523b21@tlielax.poochiereds.net>
	<20100416224413.60b4566a@tlielax.poochiereds.net>
	<1271483903.28751.4.camel@naomi.s4.naomi.abartlet.net>
	<20100417062900.75e94f36@tlielax.poochiereds.net>
	<n2m4a4634331004210729u77f95ed6m329464437b5c3eeb@mail.gmail.com>
	<20100421161950.20fb979a@tlielax.poochiereds.net>
	<AANLkTime8fdm-Wbu2PT1rXw0edjzE1-4pTVJpHWcYUd0@mail.gmail.com>
	<1277767520.2276.41.camel@ruth>
	<AANLkTil7d6jny1qklx16KtopjjwpCPAw6jECBxmnCfKF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1";
	protocol="application/pgp-signature";
	boundary="=-xaCaWcmeygT8z7Tki5g6"
Cc: smfrench@gmail.com, samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTil7d6jny1qklx16KtopjjwpCPAw6jECBxmnCfKF@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org


--=-xaCaWcmeygT8z7Tki5g6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-07-01 at 12:22 -0500, Shirish Pargaonkar wrote:
> On Mon, Jun 28, 2010 at 6:25 PM, Andrew Bartlett <abartlet@samba.org> wro=
te:
> > On Mon, 2010-06-28 at 17:47 -0500, Shirish Pargaonkar wrote:
> >
> >> When I look at Windows - Windows smb2 traces, the (16 bytes) signature
> >> looks nothing like
> >> version (which is 1), ciphertext of 8 bytes of hmac-md5, sequence numb=
er
> >
> > SMB2 SMB Signing does not use the NTLMSSP packet signing algorithm.
> > Instead, like SMB, it takes the session key already calculated and
> > applies a unique-to-SMB2 algorithm to it.  This involves sha256 I
> > think.
> >
> > Andrew Bartlett
> >
> > --
> > Andrew Bartlett                                http://samba.org/~abartl=
et/
> > Authentication Developer, Samba Team           http://samba.org
> > Samba Developer, Cisco Inc.
> >
>=20
>=20
> I have had luck with some kernel crypto apis while working on this code.
> I have been able to use arc4 and md5 hash apis successfully while
> not being able to figure out hmac-md5 apis and I had not even
> looked at sha, which I will.
>=20
> What is confusing to me is, current cifs code using ntlmv2 within
> ntlmssp authenticates and signs against Windows 2003 server
> successfully/
>=20
> But it does not against Windows 7 and Windows 2008 (I do not have
> a Windows Vista installation). I am currently changing to code and
> I am sure I would be able to authenticate using ntlmv2 within ntlmssp.
> singing is what is confusing.
>=20
> With smb2 client also, I can authenticate against Windows 7 and
> Windows 2008 but signing fails.
>=20
> So I am confused about what algorithm to use for cifs to sign
> against Windows 7 and Windows 2008 server for ntlmv2 within ntlmssp
> and what algorithm to use for smb2 to sign against a Windows 7
> and Windows 2008 server for ntlmv2 within ntlmssp.
>=20
> I have been reading and following MS-NLMP and
> http://davenport.sourceforge.net/ntlm.html

The trick here is only to follow these up to the point at which the
master key is generated, not the signing or sealing keys.  The master
key (16 bytes) is the input the special SMB and SMB2 signing algorithms.

Andrew Bartlett

--=20
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
Samba Developer, Cisco Inc.

--=-xaCaWcmeygT8z7Tki5g6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMLTzTz4A8Wyi0NrsRAngDAJ9lBMHwXTU89XbwOjoF0m3gODfh6QCfbY1U
ppjEenV2EQtyVTs+3e9K1DE=
=BHHu
-----END PGP SIGNATURE-----

--=-xaCaWcmeygT8z7Tki5g6--
