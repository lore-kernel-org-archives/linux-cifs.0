From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Thu, 3 Nov 2011 15:42:13 +0000
Message-ID: <81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>,
	Unix Support <unix-support@ucs.cam.ac.uk>
To: Steve French <sfrench@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
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

Hi,

I should add that we are using iocharset=3Dutf8 mount option which means =
that the dcache hash/compare functions done in the cifs module do not =
work because it uses nls_tolower() and nls_strnicmp() both of which for =
utf8 NLS in the kernel do not do anything at all and effectively behave =
case sensitively!

Thus this bug/problem in all likelyhood only affects utf8 iocharset =
users on a case-insensitive but case-preserving CIFS server that does =
not support server inode numbers.

That probably explains why it has not been noticed before!

We need utf8 thus we still need to fix this issue.

Best regards,

	Anton

On 3 Nov 2011, at 15:20, Anton Altaparmakov wrote:

> Hi,
>=20
> Our CIFS server problems seem to have no end=85  The Novell CIFS =
server does not support server inode numbers (when I try the mount =
option I get the message it is being turned off as server does not =
support it) and thus each inode gets a different number each time it is =
accessed and it gets a different number again for each readdir call.
>=20
> The fun happens with rename() when the rename source and target only =
differ in case, e.g.
>=20
> 	touch foo
> 	mv foo Foo
>=20
> The result?  Because of the difference in inode numbers, the request =
gets through to the CIFS module which promptly does:
>=20
> 	cifs_unlink(target_dir, target_dentry)
> 	rc =3D cifs_do_rename(=85)
>=20
> And because the cifs_unlink() just removed the source of the rename =
(as it is the same as the target), "rc" comes back as -ENOENT.
>=20
> And indeed the file is gone so we just lost the user's file for ever.  =
)-:
>=20
> We are tossing around ideas how to fix this but we would be interested =
in your input as to what you think the fix should be.
>=20
> In any case this probably should be fixed in the standard kernel CIFS =
module, too, and not just for us locally as this presumably affects =
anyone who is using the CIFS module against case-insensitive, =
non-server-inode-number-supporting CIFS servers...
>=20
> Best regards,
>=20
> 	Anton

--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
