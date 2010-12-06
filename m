From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next: Tree for December 3 (cifs)
Date: Mon, 6 Dec 2010 10:50:21 -0500
Message-ID: <20101206105021.2b6bfc96@tlielax.poochiereds.net>
References: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
	<20101203094844.68f2bc40.randy.dunlap@oracle.com>
	<20101206070956.GA5570@elte.hu>
	<20101206073513.54ca2c71@tlielax.poochiereds.net>
	<AANLkTimTFi6jji5wmnBTT25XYAXAhJYNY+YmqhW5McEC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>,
	Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimTFi6jji5wmnBTT25XYAXAhJYNY+YmqhW5McEC-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 6 Dec 2010 09:40:33 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Dec 6, 2010 at 6:35 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Mon, 6 Dec 2010 08:09:56 +0100
> > Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org> wrote:
> >
> >>
> >> * Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> > On Fri, 3 Dec 2010 13:04:40 +1100 Stephen Rothwell wrote:
> >> >
> >> > > Hi all,
> >> > >
> >> > > Changes since 20101202:
> >> >
> >> >
> >> > When CIFS_EXPERIMENTAL is not enabled:
> >> >
> >> > (.text+0xdf6c9): undefined reference to `get_cifs_acl'
> >> >
> >> > from fs/cifs/xattr.c:cifs_getxattr()
> >> >
> >> >
> >> > CONFIG_CIFS=3Dy
> >> > # CONFIG_CIFS_STATS is not set
> >> > CONFIG_CIFS_WEAK_PW_HASH=3Dy
> >> > # CONFIG_CIFS_UPCALL is not set
> >> > CONFIG_CIFS_XATTR=3Dy
> >> > CONFIG_CIFS_POSIX=3Dy
> >> > # CONFIG_CIFS_DEBUG2 is not set
> >> > # CONFIG_CIFS_DFS_UPCALL is not set
> >> > CONFIG_CIFS_FSCACHE=3Dy
> >> > CONFIG_CIFS_ACL=3Dy
> >> > # CONFIG_CIFS_EXPERIMENTAL is not set
> >>
> >> And this build regression has been pushed upstream now, as of:
> >>
> >> =A0 =A08520eeaa1235: Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/sfrench/cifs-2.6
> >>
> >> and it is triggering for me too:
> >>
> >> =A0 =A0fs/built-in.o: In function `cifs_getxattr':
> >> =A0 =A0(.text+0xc518e): undefined reference to `get_cifs_acl'
> >>
> >> The regression got introduced by:
> >>
> >> =A0 =A0fbeba8bb16d7: cifs: Handle extended attribute name cifs_acl=
 to generate cifs acl blob (try #4)
> >>
> >> Which introduced the new CIFS_ACL option.
> >>
> >> Thanks,
> >>
> >> =A0 =A0 =A0 Ingo
> >
> > Yeah, looks like this new Kconfig option depends on some code that'=
s
> > under the (much-overloaded) CIFS_EXPERIMENTAL Kconfig option. I thi=
nk
> > this patch needs some rework. The simple fix would be to make it
> > dependent on CIFS_EXPERIMENTAL, but that's rather icky since
>=20
> Making CONFIG_CIFS_ACL dependent on CONFIG_CIFS_EXPERIMENTAL
> works
>=20
>  config CIFS_ACL
>           bool "Provide CIFS ACL support (EXPERIMENTAL)"
> -         depends on EXPERIMENTAL && CIFS_XATTR
> +         depends on CIFS_EXPERIMENTAL && CIFS_XATTR
>           help
>             Allows to fetch CIFS/NTFS ACL from the server.  The DACL =
blob
>             is handed over to the application/caller.
>=20
> At the minimum function find_readable_file() and three functions
> in cifssmb.c would not have to be in CIFS_EXPERIMENTAL.
> And we would need to move some other cifs acl related functions
> from under CIFS_ACL from CIFS_EXPERIMENTAL.
>=20

Ugh, let's not do that. CONFIG_CIFS_EXPERIMENTAL is like a box of
chocolates...when you enable it you just never know what you're going
to get...

I think the patch below is a better way to deal with this. It's larger
than I would like to see at this point in the release cycle, but we
might as well fix it the right way.

I also have some other patches to clean up CONFIG_CIFS_EXPERIMENTAL,
but I'll send those along separately for 2.6.38.

Steve, if this looks good, I'll send it along to you as a "formal"
patch for inclusion via your tree.

-------------------[snip]---------------------

cifs: fix use of CONFIG_CIFS_ACL

Some of the code under CONFIG_CIFS_ACL is dependent upon code under
CONFIG_CIFS_EXPERIMENTAL, but the Kconfig options don't reflect that
dependency. Move more of the ACL code out from under
CONFIG_CIFS_EXPERIMENTAL and under CONFIG_CIFS_ACL.

Also move find_readable_file out from other any sort of Kconfig
option and make it a function normally compiled in.

Reported-by: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Makefile    |    4 +-
 fs/cifs/cifsacl.c   |    3 -
 fs/cifs/cifsacl.h   |    4 -
 fs/cifs/cifsproto.h |    2 -
 fs/cifs/cifssmb.c   |  183 ++++++++++++++++++++++++++-----------------=
--------
 fs/cifs/file.c      |    2 -
 fs/cifs/inode.c     |    8 +-
 7 files changed, 99 insertions(+), 107 deletions(-)

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index adefa60..43b19dd 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -6,7 +6,9 @@ obj-$(CONFIG_CIFS) +=3D cifs.o
 cifs-y :=3D cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o ino=
de.o \
 	  link.o misc.o netmisc.o smbdes.o smbencrypt.o transport.o asn1.o \
 	  md4.o md5.o cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
-	  readdir.o ioctl.o sess.o export.o cifsacl.o
+	  readdir.o ioctl.o sess.o export.o
+
+cifs-$(CONFIG_CIFS_ACL) +=3D cifsacl.o
=20
 cifs-$(CONFIG_CIFS_UPCALL) +=3D cifs_spnego.o
=20
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index c6ebea0..a437ec3 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -30,8 +30,6 @@
 #include "cifs_debug.h"
=20
=20
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-
 static struct cifs_wksid wksidarr[NUM_WK_SIDS] =3D {
 	{{1, 0, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0} }, "null user"},
 	{{1, 1, {0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0} }, "nobody"},
@@ -774,4 +772,3 @@ int mode_to_cifs_acl(struct inode *inode, const cha=
r *path, __u64 nmode)
=20
 	return rc;
 }
-#endif /* CONFIG_CIFS_EXPERIMENTAL */
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 6c8096c..c4ae7d0 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -74,11 +74,7 @@ struct cifs_wksid {
 	char sidname[SIDNAMELENGTH];
 } __attribute__((packed));
=20
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-
 extern int match_sid(struct cifs_sid *);
 extern int compare_sids(const struct cifs_sid *, const struct cifs_sid=
 *);
=20
-#endif /*  CONFIG_CIFS_EXPERIMENTAL */
-
 #endif /* _CIFSACL_H */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 38cdec9..cb65499 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -80,9 +80,7 @@ extern bool is_valid_oplock_break(struct smb_hdr *smb=
,
 				  struct TCP_Server_Info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *,=
 bool);
-#ifdef CONFIG_CIFS_EXPERIMENTAL
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *,=
 bool);
-#endif
 extern unsigned int smbCalcSize(struct smb_hdr *ptr);
 extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
 extern int decode_negTokenInit(unsigned char *security_blob, int lengt=
h,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0ef7c3a..d7957a3 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2478,95 +2478,6 @@ querySymLinkRetry:
 }
=20
 #ifdef CONFIG_CIFS_EXPERIMENTAL
-/* Initialize NT TRANSACT SMB into small smb request buffer.
-   This assumes that all NT TRANSACTS that we init here have
-   total parm and data under about 400 bytes (to fit in small cifs
-   buffer size), which is the case so far, it easily fits. NB:
-	Setup words themselves and ByteCount
-	MaxSetupCount (size of returned setup area) and
-	MaxParameterCount (returned parms size) must be set by caller */
-static int
-smb_init_nttransact(const __u16 sub_command, const int setup_count,
-		   const int parm_len, struct cifsTconInfo *tcon,
-		   void **ret_buf)
-{
-	int rc;
-	__u32 temp_offset;
-	struct smb_com_ntransact_req *pSMB;
-
-	rc =3D small_smb_init(SMB_COM_NT_TRANSACT, 19 + setup_count, tcon,
-				(void **)&pSMB);
-	if (rc)
-		return rc;
-	*ret_buf =3D (void *)pSMB;
-	pSMB->Reserved =3D 0;
-	pSMB->TotalParameterCount =3D cpu_to_le32(parm_len);
-	pSMB->TotalDataCount  =3D 0;
-	pSMB->MaxDataCount =3D cpu_to_le32((tcon->ses->server->maxBuf -
-					  MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
-	pSMB->ParameterCount =3D pSMB->TotalParameterCount;
-	pSMB->DataCount  =3D pSMB->TotalDataCount;
-	temp_offset =3D offsetof(struct smb_com_ntransact_req, Parms) +
-			(setup_count * 2) - 4 /* for rfc1001 length itself */;
-	pSMB->ParameterOffset =3D cpu_to_le32(temp_offset);
-	pSMB->DataOffset =3D cpu_to_le32(temp_offset + parm_len);
-	pSMB->SetupCount =3D setup_count; /* no need to le convert byte field=
s */
-	pSMB->SubCommand =3D cpu_to_le16(sub_command);
-	return 0;
-}
-
-static int
-validate_ntransact(char *buf, char **ppparm, char **ppdata,
-		   __u32 *pparmlen, __u32 *pdatalen)
-{
-	char *end_of_smb;
-	__u32 data_count, data_offset, parm_count, parm_offset;
-	struct smb_com_ntransact_rsp *pSMBr;
-
-	*pdatalen =3D 0;
-	*pparmlen =3D 0;
-
-	if (buf =3D=3D NULL)
-		return -EINVAL;
-
-	pSMBr =3D (struct smb_com_ntransact_rsp *)buf;
-
-	/* ByteCount was converted from little endian in SendReceive */
-	end_of_smb =3D 2 /* sizeof byte count */ + pSMBr->ByteCount +
-			(char *)&pSMBr->ByteCount;
-
-	data_offset =3D le32_to_cpu(pSMBr->DataOffset);
-	data_count =3D le32_to_cpu(pSMBr->DataCount);
-	parm_offset =3D le32_to_cpu(pSMBr->ParameterOffset);
-	parm_count =3D le32_to_cpu(pSMBr->ParameterCount);
-
-	*ppparm =3D (char *)&pSMBr->hdr.Protocol + parm_offset;
-	*ppdata =3D (char *)&pSMBr->hdr.Protocol + data_offset;
-
-	/* should we also check that parm and data areas do not overlap? */
-	if (*ppparm > end_of_smb) {
-		cFYI(1, "parms start after end of smb");
-		return -EINVAL;
-	} else if (parm_count + *ppparm > end_of_smb) {
-		cFYI(1, "parm end after end of smb");
-		return -EINVAL;
-	} else if (*ppdata > end_of_smb) {
-		cFYI(1, "data starts after end of smb");
-		return -EINVAL;
-	} else if (data_count + *ppdata > end_of_smb) {
-		cFYI(1, "data %p + count %d (%p) past smb end %p start %p",
-			*ppdata, data_count, (data_count + *ppdata),
-			end_of_smb, pSMBr);
-		return -EINVAL;
-	} else if (parm_count + data_count > pSMBr->ByteCount) {
-		cFYI(1, "parm count and data count larger than SMB");
-		return -EINVAL;
-	}
-	*pdatalen =3D data_count;
-	*pparmlen =3D parm_count;
-	return 0;
-}
-
 int
 CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
@@ -3056,7 +2967,97 @@ GetExtAttrOut:
=20
 #endif /* CONFIG_POSIX */
=20
-#ifdef CONFIG_CIFS_EXPERIMENTAL
+#ifdef CONFIG_CIFS_ACL
+/*
+ * Initialize NT TRANSACT SMB into small smb request buffer.  This ass=
umes that
+ * all NT TRANSACTS that we init here have total parm and data under a=
bout 400
+ * bytes (to fit in small cifs buffer size), which is the case so far,=
 it
+ * easily fits. NB: Setup words themselves and ByteCount MaxSetupCount=
 (size of
+ * returned setup area) and MaxParameterCount (returned parms size) mu=
st be set
+ * by caller
+ */
+static int
+smb_init_nttransact(const __u16 sub_command, const int setup_count,
+		   const int parm_len, struct cifsTconInfo *tcon,
+		   void **ret_buf)
+{
+	int rc;
+	__u32 temp_offset;
+	struct smb_com_ntransact_req *pSMB;
+
+	rc =3D small_smb_init(SMB_COM_NT_TRANSACT, 19 + setup_count, tcon,
+				(void **)&pSMB);
+	if (rc)
+		return rc;
+	*ret_buf =3D (void *)pSMB;
+	pSMB->Reserved =3D 0;
+	pSMB->TotalParameterCount =3D cpu_to_le32(parm_len);
+	pSMB->TotalDataCount  =3D 0;
+	pSMB->MaxDataCount =3D cpu_to_le32((tcon->ses->server->maxBuf -
+					  MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
+	pSMB->ParameterCount =3D pSMB->TotalParameterCount;
+	pSMB->DataCount  =3D pSMB->TotalDataCount;
+	temp_offset =3D offsetof(struct smb_com_ntransact_req, Parms) +
+			(setup_count * 2) - 4 /* for rfc1001 length itself */;
+	pSMB->ParameterOffset =3D cpu_to_le32(temp_offset);
+	pSMB->DataOffset =3D cpu_to_le32(temp_offset + parm_len);
+	pSMB->SetupCount =3D setup_count; /* no need to le convert byte field=
s */
+	pSMB->SubCommand =3D cpu_to_le16(sub_command);
+	return 0;
+}
+
+static int
+validate_ntransact(char *buf, char **ppparm, char **ppdata,
+		   __u32 *pparmlen, __u32 *pdatalen)
+{
+	char *end_of_smb;
+	__u32 data_count, data_offset, parm_count, parm_offset;
+	struct smb_com_ntransact_rsp *pSMBr;
+
+	*pdatalen =3D 0;
+	*pparmlen =3D 0;
+
+	if (buf =3D=3D NULL)
+		return -EINVAL;
+
+	pSMBr =3D (struct smb_com_ntransact_rsp *)buf;
+
+	/* ByteCount was converted from little endian in SendReceive */
+	end_of_smb =3D 2 /* sizeof byte count */ + pSMBr->ByteCount +
+			(char *)&pSMBr->ByteCount;
+
+	data_offset =3D le32_to_cpu(pSMBr->DataOffset);
+	data_count =3D le32_to_cpu(pSMBr->DataCount);
+	parm_offset =3D le32_to_cpu(pSMBr->ParameterOffset);
+	parm_count =3D le32_to_cpu(pSMBr->ParameterCount);
+
+	*ppparm =3D (char *)&pSMBr->hdr.Protocol + parm_offset;
+	*ppdata =3D (char *)&pSMBr->hdr.Protocol + data_offset;
+
+	/* should we also check that parm and data areas do not overlap? */
+	if (*ppparm > end_of_smb) {
+		cFYI(1, "parms start after end of smb");
+		return -EINVAL;
+	} else if (parm_count + *ppparm > end_of_smb) {
+		cFYI(1, "parm end after end of smb");
+		return -EINVAL;
+	} else if (*ppdata > end_of_smb) {
+		cFYI(1, "data starts after end of smb");
+		return -EINVAL;
+	} else if (data_count + *ppdata > end_of_smb) {
+		cFYI(1, "data %p + count %d (%p) past smb end %p start %p",
+			*ppdata, data_count, (data_count + *ppdata),
+			end_of_smb, pSMBr);
+		return -EINVAL;
+	} else if (parm_count + data_count > pSMBr->ByteCount) {
+		cFYI(1, "parm count and data count larger than SMB");
+		return -EINVAL;
+	}
+	*pdatalen =3D data_count;
+	*pparmlen =3D parm_count;
+	return 0;
+}
+
 /* Get Security Descriptor (by handle) from remote server for a file o=
r dir */
 int
 CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
@@ -3214,7 +3215,7 @@ setCifsAclRetry:
 	return (rc);
 }
=20
-#endif /* CONFIG_CIFS_EXPERIMENTAL */
+#endif /* CONFIG_CIFS_ACL */
=20
 /* Legacy Query Path Information call for lookup to old servers such
    as Win9x/WinME */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b857ce5..5a28660 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1108,7 +1108,6 @@ static ssize_t cifs_write(struct cifsFileInfo *op=
en_file,
 	return total_written;
 }
=20
-#ifdef CONFIG_CIFS_EXPERIMENTAL
 struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_ino=
de,
 					bool fsuid_only)
 {
@@ -1142,7 +1141,6 @@ struct cifsFileInfo *find_readable_file(struct ci=
fsInodeInfo *cifs_inode,
 	spin_unlock(&cifs_file_list_lock);
 	return NULL;
 }
-#endif
=20
 struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_ino=
de,
 					bool fsuid_only)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0023146..10d1cab 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -687,7 +687,7 @@ int cifs_get_inode_info(struct inode **pinode,
 			cFYI(1, "cifs_sfu_type failed: %d", tmprc);
 	}
=20
-#ifdef CONFIG_CIFS_EXPERIMENTAL
+#ifdef CONFIG_CIFS_ACL
 	/* fill in 0777 bits from ACL */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 		rc =3D cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path,
@@ -698,7 +698,7 @@ int cifs_get_inode_info(struct inode **pinode,
 			goto cgii_exit;
 		}
 	}
-#endif
+#endif /* CONFIG_CIFS_ACL */
=20
 	/* fill in remaining high mode bits e.g. SUID, VTX */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
@@ -2128,7 +2128,7 @@ cifs_setattr_nounix(struct dentry *direntry, stru=
ct iattr *attrs)
=20
 	if (attrs->ia_valid & ATTR_MODE) {
 		rc =3D 0;
-#ifdef CONFIG_CIFS_EXPERIMENTAL
+#ifdef CONFIG_CIFS_ACL
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 			rc =3D mode_to_cifs_acl(inode, full_path, mode);
 			if (rc) {
@@ -2137,7 +2137,7 @@ cifs_setattr_nounix(struct dentry *direntry, stru=
ct iattr *attrs)
 				goto cifs_setattr_exit;
 			}
 		} else
-#endif
+#endif /* CONFIG_CIFS_ACL */
 		if (((mode & S_IWUGO) =3D=3D 0) &&
 		    (cifsInode->cifsAttrs & ATTR_READONLY) =3D=3D 0) {
=20
--=20
1.7.3.2
