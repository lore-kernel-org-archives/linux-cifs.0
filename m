From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Fri, 4 Nov 2011 12:16:36 +0100
Message-ID: <E1RMHlS-00HYp9-Hk@intern.SerNet.DE>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org,
	Unix Support <unix-support@ucs.cam.ac.uk>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
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

On 2011-11-03 at 15:20 +0000 Anton Altaparmakov sent off:
> Hi,
>=20
> Our CIFS server problems seem to have no end=E2=80=A6  The Novell CIFS =
server does not support server inode numbers (when I try the mount option=
 I get the message it is being turned off as server does not support it) =
and thus each inode gets a different number each time it is accessed and =
it gets a different number again for each readdir call.
>=20
> The fun happens with rename() when the rename source and target only di=
ffer in case, e.g.
>=20
> 	touch foo
> 	mv foo Foo

somehow related seems https://bugzilla.kernel.org/show_bug.cgi?id=3D39512
(as long as kernel bugzilla is dead, see
http://www.linux.sgi.com/archives/xfs-masters/2011-07/msg00022.html )

Case insensitive filesystems seem to be a problem in general on Linux. No=
t sure
how far kernel and/or glibc are involved in the problem. As a workaround =
for
the mess you need to do a temporary rename to a different name (not just =
a case
equivalent name).

Bj=C3=B6rn
--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=C3=B6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=C3=B6ttingen, HRB 2816, GF: Dr. Johannes Loxen
