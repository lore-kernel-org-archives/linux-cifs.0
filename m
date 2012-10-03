From: "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: SMB3 Session Setup
Date: Wed, 03 Oct 2012 16:18:27 +0200
Message-ID: <506C4933.3050003@samba.org>
References: <CAH2r5msryv+HwGes5wy-3wugDGv+FbUk01M3HDHziVfgzCZ=DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigA1CD65D2A07E678E770393F4"
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5msryv+HwGes5wy-3wugDGv+FbUk01M3HDHziVfgzCZ=DA@mail.gmail.com>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA1CD65D2A07E678E770393F4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Steve,

> I noticed some odd differences between Samba 4 (current master) and
> Windows 8 in SMB3 session setup handling (both fail for different
> reasons at the moment from the linux cifs client, while smb2.1 works).
>=20
> negotiate protocol to both (Samba and Windows 8) look similar.  In
> this case I am requesting only one dialect smb3
> session setup phase 1 (raw ntlmssp) looks similar.
> three cases for session setup phase two
> 1) if bad password:  then I get STATUS_LOGON_FAILURE as expected
> 2) if good password (which worked with smb2.1) then to Samba server I
> get Samba sending back a signed response (success), even though I
> didn't ask for signing

That is expected, the final session setup response is always signed,
if the session is not anonymous.

> 3) if good password (which worked with smb2.1) then to Windows 8
> server I get Windows 8 sending back an error response
> "STATUS_USER_SESSION_DELETED"
> Any idea what that error means?

I also got something like that, but I think only
I tried to negotiate SMB 2.1 against a Windows 2012 server.
(I think it's a bug in windows as it worked with Windows 2012 server RC).=

And there's otherwise no difference.

However a Win 7 client seems to work. It uses some more advanced NTLMSSP
stuff, where even the final session setup response returns a blob.

Please include captures...

metze


--------------enigA1CD65D2A07E678E770393F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBsSTcACgkQm70gjA5TCD/MHQCgoiknzH5m/yIFT0zeVIyz+0xW
kyoAoMqljjmru2sSZ88jxnviQeWqDKHH
=oSvI
-----END PGP SIGNATURE-----

--------------enigA1CD65D2A07E678E770393F4--
