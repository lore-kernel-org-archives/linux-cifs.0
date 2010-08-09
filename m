From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 3/8] cifs: add CIFSCheckMFSymlink() as stub
Date: Mon, 09 Aug 2010 16:04:26 +0200
Message-ID: <4C600AEA.607@samba.org>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com>	<1280931109-22380-4-git-send-email-metze@samba.org>	<20100804103748.521163e6@tlielax.poochiereds.net>	<4C5AAA3C.1000304@suse.de> <20100805083113.2e7bfbb9@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig737EDAD8209ADFB63DE1BEEC"
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100805083113.2e7bfbb9-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig737EDAD8209ADFB63DE1BEEC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed that I also need to hook the cifs_readdir() path.

Can someone tell me how I can construct the file name
relative to the mount point. The TODO in this change.

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -679,7 +679,7 @@ static int cifs_get_name_from_search_buf(struct qstr
*pqst,
        return rc;
 }

-static int cifs_filldir(char *pfindEntry, struct file *file, filldir_t
filldir,
+static int cifs_filldir(int xid, char *pfindEntry, struct file *file,
filldir_t filldir,
                        void *direntry, char *scratch_buf, unsigned int
max_len)
 {
        int rc =3D 0;
@@ -731,6 +731,15 @@ static int cifs_filldir(char *pfindEntry, struct
file *file, filldir_t filldir,
                cifs_dir_info_to_fattr(&fattr, (FILE_DIRECTORY_INFO *)
                                        pfindEntry, cifs_sb);

+       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+               int tmprc;
+               const char *full_path =3D qstring.name;
+               /* TODO: build full path relative to the mount point */
+               tmprc =3D CIFSCheckMFSymlink(&fattr, full_path, cifs_sb, =
xid);
+               if (tmprc)
+                       cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
+       }
+
        if (inum && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {=

                fattr.cf_uniqueid =3D inum;
        } else {
@@ -856,7 +865,7 @@ int cifs_readdir(struct file *file, void *direntry,
filldir_t filldir)
                        }
                        /* if buggy server returns . and .. late do
                        we want to check for that here? */
-                       rc =3D cifs_filldir(current_entry, file,
+                       rc =3D cifs_filldir(xid, current_entry, file,
                                        filldir, direntry, tmp_buf,
max_len);
                        if (rc =3D=3D -EOVERFLOW) {
                                rc =3D 0;

metze

Am 05.08.2010 14:31, schrieb Jeff Layton:
> On Thu, 05 Aug 2010 17:40:36 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>=20
>> On 08/04/2010 08:07 PM, Jeff Layton wrote:
>>> On Wed,  4 Aug 2010 16:11:44 +0200
>>> Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>>
>>>> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>>> ---
>>>>  fs/cifs/cifsproto.h |    3 +++
>>>>  fs/cifs/inode.c     |    7 +++++++
>>>>  fs/cifs/link.c      |    8 ++++++++
>>>>  3 files changed, 18 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>>>> index 2eaebbd..e94e095 100644
>>>> --- a/fs/cifs/cifsproto.h
>>>> +++ b/fs/cifs/cifsproto.h
>>>> @@ -409,4 +409,7 @@ extern int CIFSSMBSetPosixACL(const int xid, str=
uct cifsTconInfo *tcon,
>>>>  extern int CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,=

>>>>  			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
>>>>  extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb=
);
>>>> +extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>>>> +		const unsigned char *path,
>>>> +		struct cifs_sb_info *cifs_sb, int xid);
>>>>  #endif			/* _CIFSPROTO_H */
>>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>>>> index a15b3a9..c4121de 100644
>>>> --- a/fs/cifs/inode.c
>>>> +++ b/fs/cifs/inode.c
>>>> @@ -661,6 +661,13 @@ int cifs_get_inode_info(struct inode **pinode,
>>>>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
>>>>  		cifs_sfu_mode(&fattr, full_path, cifs_sb, xid);
>>>> =20
>>>> +	/* query for SFU type info if supported and needed */
>>>> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
>>>> +		tmprc =3D CIFSCheckMFSymlink(&fattr, full_path, cifs_sb, xid);
>>>> +		if (tmprc)
>>>> +			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
>>>> +	}
>>>> +
>>>
>>> 		^^^^^^^^^^^^^^
>>>
>>> This only seems to touch the codepath without posix extensions. What
>>> about when unix extensions are enabled? The previous patch seems to
>>> indicate that the behavior is that mfsymlinks are always used when th=
at
>>> mount option is used even if unix extensions are enabled. If so, then=
 I
>>> think you'll need a similar change in cifs_get_inode_info_unix.
>>>
>>
>> I initially thought so. But, looking again - there is no point in
>> querying for SFU type info if unix extensions are enabled..?
>>
>> Thanks,
>>
>=20
> I'm not sure that addresses the concern. It's very confusing, but:
>=20
>     SFU !=3D POSIX extensions
>=20
> The SFU codepath goes through the "normal" cifs code
> (cifs_get_inode_info). The POSIX extensions codepath goes through a
> different codepath (cifs_get_inode_info_unix). Yes, all of this is
> sorely in need of being cleaned up, but that's the way it works today..=
=2E
>=20
> Metze's patches seem to indicate that mfsymlinks and unix extensions
> aren't mutually exclusive. The unix codepaths that determine inode
> type and fill out inode data should be using the mfsymlink stuff too.
>=20


--------------enig737EDAD8209ADFB63DE1BEEC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkxgCuoACgkQm70gjA5TCD+GxACeLrbGF52cRPlYvEMcJpA5h7wV
g9kAn1FfHH299CdWvpcJz1cEQa2qkHRH
=jszS
-----END PGP SIGNATURE-----

--------------enig737EDAD8209ADFB63DE1BEEC--
