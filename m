From: "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Thu, 28 Feb 2013 01:15:49 +0100
Message-ID: <512EA1B5.5010801@samba.org>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig68FCC689876EF40A74DA37A6"
Cc: Steve French <sfrench@samba.org>, Dave Chiluk <chiluk@canonical.com>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20130227083419.0af9deaf@corrin.poochiereds.net>
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
--------------enig68FCC689876EF40A74DA37A6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 27.02.2013 17:34, schrieb Jeff Layton:
> On Wed, 27 Feb 2013 12:06:14 +0100
> "Stefan (metze) Metzmacher" <metze@samba.org> wrote:
>=20
>> Hi Dave,
>>
>>> When messages are currently in queue awaiting a response, decrease am=
ount of
>>> time before attempting cifs_reconnect to SMB_MAX_RTT =3D 10 seconds. =
The current
>>> wait time before attempting to reconnect is currently 2*SMB_ECHO_INTE=
RVAL(120
>>> seconds) since the last response was recieved.  This does not take in=
to account
>>> the fact that messages waiting for a response should be serviced with=
in a
>>> reasonable round trip time.
>>
>> Wouldn't that mean that the client will disconnect a good connection,
>> if the server doesn't response within 10 seconds?
>> Reads and Writes can take longer than 10 seconds...
>>
>=20
> Where does this magic value of 10s come from? Note that a slow server
> can take *minutes* to respond to writes that are long past the EOF.
>=20
>>> This fixes the issue where user moves from wired to wireless or vice =
versa
>>> causing the mount to hang for 120 seconds, when it could reconnect co=
nsiderably
>>> faster.  After this fix it will take SMB_MAX_RTT (10 seconds) from th=
e last
>>> time the user attempted to access the volume or SMB_MAX_RTT after the=
 last
>>> echo.  The worst case of the latter scenario being
>>> 2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130 sec=
onds).
>>> Statistically speaking it would normally reconnect sooner.  However i=
n the best
>>> case where the user changes nics, and immediately tries to access the=
 cifs
>>> share it will take SMB_MAX_RTT=3D10 seconds.
>>
>> I think it would be better to detect the broken connection
>> by using an AF_NETLINK socket listening for RTM_DELADDR
>> messages?
>>
>> metze
>>
>=20
> Ick -- that sounds horrid ;)

This is what winbindd uses to detect that a source ip of outgoing
connections
are gone. I don't know much of the kernel, there might be a better way
from within
the kernel to detect this. But this is exactly the correct thing to
do to failover to another interface, as it just happens when the ip is
removed
without messing with a timeout value.

Another optimization would be to use tcp keepalives (I think there 10
seconds would be ok),
I think that's what Windows SMB3 clients are using.

metze


--------------enig68FCC689876EF40A74DA37A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlEuob0ACgkQm70gjA5TCD9PRwCfbsg2/QHIwE80jCXtRntW0VCJ
1ncAoI6mpkEaWoX+ehy6qtVnTRlVBT3n
=SY8e
-----END PGP SIGNATURE-----

--------------enig68FCC689876EF40A74DA37A6--
