From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: Fix another bug from patch Re: [PATCH] Fix that several functions
 handle incorrect value of mapchars
Date: Mon, 23 Feb 2015 15:26:45 +0900
Message-ID: <54EAC825.1070807@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------080405050205090601030502"
To: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >> Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--------------080405050205090601030502
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit

On 2015/02/22 16:10, Steve French wrote:
> Would you resend the patch, preferably cleaned up so it will merge?
> I don't mind if you also send the patch as an attachment to me
>  (use "git format-patch" for example to generate it), but the patch above is corrupted.


I resend the patch (both email and attachment).
When Copy&Paste to email, [SPACE] has disappeared.
I apologize trouble.



>From 27408a9a3fe8a2896084bf7c6c295e9da5608f00 Mon Sep 17 00:00:00 2001
From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Date: Fri, 13 Feb 2015 15:35:58 +0900
Subject: [PATCH] Fix that several functions handle incorrect value of mapchars

Cifs client has problem with reserved chars filename.

[BUG1] : several functions handle incorrect value of mapchars
-	cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	cifs_remap(cifs_sb));

[BUG2] : forget to convert reserved chars when creating SymbolicLink.
-	CIFSUnixCreateSymLink() calls cifs_strtoUTF16
+	CIFSUnixCreateSymLink() calls cifsConvertToUTF16() with remap

[BUG3] : forget to convert reserved chars when getting SymbolicLink.
-	CIFSSMBUnixQuerySymLink() calls cifs_strtoUTF16
+	CIFSSMBUnixQuerySymLink() calls cifsConvertToUTF16() with remap

[BUG4] : /proc/mounts don't show "mapposix" when using mapposix mount option
+	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
+ 		seq_puts(s, ",mapposix");

Reported-by: t.wede-Ux+P5dQ3ksgb1SvskN2V4Q@public.gmane.org
Reported-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Signed-off-by: Carl Schaefer <schaefer-zb67Qyrvlmkdnm+yROfE0A@public.gmane.org>

---
 fs/cifs/cifs_dfs_ref.c |    3 ++-
 fs/cifs/cifsfs.c       |    2 ++
 fs/cifs/cifsproto.h    |    4 ++--
 fs/cifs/cifssmb.c      |   21 +++++++++++----------
 fs/cifs/dir.c          |    3 +--
 fs/cifs/file.c         |    3 +--
 fs/cifs/inode.c        |    6 ++----
 fs/cifs/link.c         |    3 ++-
 fs/cifs/smb1ops.c      |    3 ++-
 9 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b8602f1..7c3dde9 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -24,6 +24,7 @@
 #include "cifsfs.h"
 #include "dns_resolve.h"
 #include "cifs_debug.h"
+#include "cifs_unicode.h"
 
 static LIST_HEAD(cifs_dfs_automount_list);
 
@@ -312,7 +313,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	xid = get_xid();
 	rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
 		&num_referrals, &referrals,
-		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+		cifs_remap(cifs_sb));
 	free_xid(xid);
 
 	cifs_put_tlink(tlink);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d72fe37..59df559 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -469,6 +469,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",nouser_xattr");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
 		seq_puts(s, ",mapchars");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
+		seq_puts(s, ",mapposix");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
 		seq_puts(s, ",sfu");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c31ce98..c63fd1d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -361,11 +361,11 @@ extern int CIFSUnixCreateHardLink(const unsigned int xid,
 extern int CIFSUnixCreateSymLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage);
+			const struct nls_table *nls_codepage, int remap);
 extern int CIFSSMBUnixQuerySymLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const unsigned char *searchName, char **syminfo,
-			const struct nls_table *nls_codepage);
+			const struct nls_table *nls_codepage, int remap);
 extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 			       __u16 fid, char **symlinkinfo,
 			       const struct nls_table *nls_codepage);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 61d00a6..e588901 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2784,7 +2784,7 @@ copyRetry:
 int
 CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *fromName, const char *toName,
-		      const struct nls_table *nls_codepage)
+		      const struct nls_table *nls_codepage, int remap)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -2804,9 +2804,9 @@ createSymLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifs_strtoUTF16((__le16 *) pSMB->FileName, fromName,
-				    /* find define for this maxpathcomponent */
-				    PATH_MAX, nls_codepage);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fromName,
+				/* find define for this maxpathcomponent */
+					PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -2828,9 +2828,9 @@ createSymLinkRetry:
 	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len_target =
-		    cifs_strtoUTF16((__le16 *) data_offset, toName, PATH_MAX
-				    /* find define for this maxpathcomponent */
-				    , nls_codepage);
+		    cifsConvertToUTF16((__le16 *) data_offset, toName,
+				/* find define for this maxpathcomponent */
+					PATH_MAX, nls_codepage, remap);
 		name_len_target++;	/* trailing null */
 		name_len_target *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3034,7 +3034,7 @@ winCreateHardLinkRetry:
 int
 CIFSSMBUnixQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 			const unsigned char *searchName, char **symlinkinfo,
-			const struct nls_table *nls_codepage)
+			const struct nls_table *nls_codepage, int remap)
 {
 /* SMB_QUERY_FILE_UNIX_LINK */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
@@ -3055,8 +3055,9 @@ querySymLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-			cifs_strtoUTF16((__le16 *) pSMB->FileName, searchName,
-					PATH_MAX, nls_codepage);
+			cifsConvertToUTF16((__le16 *) pSMB->FileName,
+					   searchName, PATH_MAX, nls_codepage,
+					   remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index b72bc29..d0cbda2 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -620,8 +620,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 		}
 		rc = CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
 					    cifs_sb->local_nls,
-					    cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					    cifs_remap(cifs_sb));
 		if (rc)
 			goto mknod_out;
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d535e16..7c679c7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -140,8 +140,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	posix_flags = cifs_posix_convert_flags(f_flags);
 	rc = CIFSPOSIXCreate(xid, tcon, posix_flags, mode, pnetfid, presp_data,
 			     poplock, full_path, cifs_sb->local_nls,
-			     cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+			     cifs_remap(cifs_sb));
 	cifs_put_tlink(tlink);
 
 	if (rc)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0c3ce46..7eee3d0 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -373,8 +373,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 
 	/* could have done a find first instead but this returns more info */
 	rc = CIFSSMBUnixQPathInfo(xid, tcon, full_path, &find_data,
-				  cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				  cifs_sb->local_nls, cifs_remap(cifs_sb));
 	cifs_put_tlink(tlink);
 
 	if (!rc) {
@@ -2215,8 +2214,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		pTcon = tlink_tcon(tlink);
 		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, args,
 				    cifs_sb->local_nls,
-				    cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+				    cifs_remap(cifs_sb));
 		cifs_put_tlink(tlink);
 	}
 
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 2ec6037..fa864dd 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -717,7 +717,8 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
 	else if (pTcon->unix_ext)
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
-					   cifs_sb->local_nls);
+					   cifs_sb->local_nls,
+					   cifs_remap(cifs_sb));
 	/* else
 	   rc = CIFSCreateReparseSymLink(xid, pTcon, fromName, toName,
 					cifs_sb_target->local_nls); */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index d297903..020c8dd 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -960,7 +960,8 @@ cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	/* Check for unix extensions */
 	if (cap_unix(tcon->ses)) {
 		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, target_path,
-					     cifs_sb->local_nls);
+					     cifs_sb->local_nls,
+					     cifs_remap(cifs_sb));
 		if (rc == -EREMOTE)
 			rc = cifs_unix_dfs_readlink(xid, tcon, full_path,
 						    target_path,
-- 1.7.1 .

.


--------------080405050205090601030502
Content-Type: text/plain; charset="Shift_JIS";
	name="0001-Fix-that-several-functions-handle-incorrect-value-of.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0="0001-Fix-that-several-functions-handle-incorrect-value-of.pa";
	filename*1="tch"

RnJvbSAyNzQwOGE5YTNmZThhMjg5NjA4NGJmN2M2YzI5NWU5ZGE1NjA4ZjAwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBOYWthamltYSBBa2lyYSA8bmFrYWppbWEuYWtpcmFA
bnR0Y29tLmNvLmpwPgpEYXRlOiBGcmksIDEzIEZlYiAyMDE1IDE1OjM1OjU4ICswOTAwClN1
YmplY3Q6IFtQQVRDSF0gRml4IHRoYXQgc2V2ZXJhbCBmdW5jdGlvbnMgaGFuZGxlIGluY29y
cmVjdCB2YWx1ZSBvZiBtYXBjaGFycwoKQ2lmcyBjbGllbnQgaGFzIHByb2JsZW0gd2l0aCBy
ZXNlcnZlZCBjaGFycyBmaWxlbmFtZS4KCltCVUcxXSA6IHNldmVyYWwgZnVuY3Rpb25zIGhh
bmRsZSBpbmNvcnJlY3QgdmFsdWUgb2YgbWFwY2hhcnMKLQljaWZzX3NiLT5tbnRfY2lmc19m
bGFncyAmIENJRlNfTU9VTlRfTUFQX1NQRUNJQUxfQ0hSKTsKKwljaWZzX3JlbWFwKGNpZnNf
c2IpKTsKCltCVUcyXSA6IGZvcmdldCB0byBjb252ZXJ0IHJlc2VydmVkIGNoYXJzIHdoZW4g
Y3JlYXRpbmcgU3ltYm9saWNMaW5rLgotCUNJRlNVbml4Q3JlYXRlU3ltTGluaygpIGNhbGxz
IGNpZnNfc3RydG9VVEYxNgorCUNJRlNVbml4Q3JlYXRlU3ltTGluaygpIGNhbGxzIGNpZnND
b252ZXJ0VG9VVEYxNigpIHdpdGggcmVtYXAKCltCVUczXSA6IGZvcmdldCB0byBjb252ZXJ0
IHJlc2VydmVkIGNoYXJzIHdoZW4gZ2V0dGluZyBTeW1ib2xpY0xpbmsuCi0JQ0lGU1NNQlVu
aXhRdWVyeVN5bUxpbmsoKSBjYWxscyBjaWZzX3N0cnRvVVRGMTYKKwlDSUZTU01CVW5peFF1
ZXJ5U3ltTGluaygpIGNhbGxzIGNpZnNDb252ZXJ0VG9VVEYxNigpIHdpdGggcmVtYXAKCltC
VUc0XSA6IC9wcm9jL21vdW50cyBkb24ndCBzaG93ICJtYXBwb3NpeCIgd2hlbiB1c2luZyBt
YXBwb3NpeCBtb3VudCBvcHRpb24KKwkgICAgY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBD
SUZTX01PVU5UX01BUF9TRk1fQ0hSKQorIAkJc2VxX3B1dHMocywgIixtYXBwb3NpeCIpOwoK
UmVwb3J0ZWQtYnk6IHQud2VkZUBrdy1yZW5lZy5kZQpSZXBvcnRlZC1ieTogTmFrYWppbWEg
QWtpcmEgPG5ha2FqaW1hLmFraXJhQG50dGNvbS5jby5qcD4KU2lnbmVkLW9mZi1ieTogTmFr
YWppbWEgQWtpcmEgPG5ha2FqaW1hLmFraXJhQG50dGNvbS5jby5qcD4KU2lnbmVkLW9mZi1i
eTogQ2FybCBTY2hhZWZlciA8c2NoYWVmZXJAdHJpbHVnLm9yZz4KCi0tLQogZnMvY2lmcy9j
aWZzX2Rmc19yZWYuYyB8ICAgIDMgKystCiBmcy9jaWZzL2NpZnNmcy5jICAgICAgIHwgICAg
MiArKwogZnMvY2lmcy9jaWZzcHJvdG8uaCAgICB8ICAgIDQgKystLQogZnMvY2lmcy9jaWZz
c21iLmMgICAgICB8ICAgMjEgKysrKysrKysrKystLS0tLS0tLS0tCiBmcy9jaWZzL2Rpci5j
ICAgICAgICAgIHwgICAgMyArLS0KIGZzL2NpZnMvZmlsZS5jICAgICAgICAgfCAgICAzICst
LQogZnMvY2lmcy9pbm9kZS5jICAgICAgICB8ICAgIDYgKystLS0tCiBmcy9jaWZzL2xpbmsu
YyAgICAgICAgIHwgICAgMyArKy0KIGZzL2NpZnMvc21iMW9wcy5jICAgICAgfCAgICAzICsr
LQogOSBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNfZGZzX3JlZi5jIGIvZnMvY2lmcy9jaWZzX2Rm
c19yZWYuYwppbmRleCBiODYwMmYxLi43YzNkZGU5IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Np
ZnNfZGZzX3JlZi5jCisrKyBiL2ZzL2NpZnMvY2lmc19kZnNfcmVmLmMKQEAgLTI0LDYgKzI0
LDcgQEAKICNpbmNsdWRlICJjaWZzZnMuaCIKICNpbmNsdWRlICJkbnNfcmVzb2x2ZS5oIgog
I2luY2x1ZGUgImNpZnNfZGVidWcuaCIKKyNpbmNsdWRlICJjaWZzX3VuaWNvZGUuaCIKIAog
c3RhdGljIExJU1RfSEVBRChjaWZzX2Rmc19hdXRvbW91bnRfbGlzdCk7CiAKQEAgLTMxMiw3
ICszMTMsNyBAQCBzdGF0aWMgc3RydWN0IHZmc21vdW50ICpjaWZzX2Rmc19kb19hdXRvbW91
bnQoc3RydWN0IGRlbnRyeSAqbW50cHQpCiAJeGlkID0gZ2V0X3hpZCgpOwogCXJjID0gZ2V0
X2Rmc19wYXRoKHhpZCwgc2VzLCBmdWxsX3BhdGggKyAxLCBjaWZzX3NiLT5sb2NhbF9ubHMs
CiAJCSZudW1fcmVmZXJyYWxzLCAmcmVmZXJyYWxzLAotCQljaWZzX3NiLT5tbnRfY2lmc19m
bGFncyAmIENJRlNfTU9VTlRfTUFQX1NQRUNJQUxfQ0hSKTsKKwkJY2lmc19yZW1hcChjaWZz
X3NiKSk7CiAJZnJlZV94aWQoeGlkKTsKIAogCWNpZnNfcHV0X3RsaW5rKHRsaW5rKTsKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IGQ3
MmZlMzcuLjU5ZGY1NTkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMv
Y2lmcy9jaWZzZnMuYwpAQCAtNDY5LDYgKzQ2OSw4IEBAIGNpZnNfc2hvd19vcHRpb25zKHN0
cnVjdCBzZXFfZmlsZSAqcywgc3RydWN0IGRlbnRyeSAqcm9vdCkKIAkJc2VxX3B1dHMocywg
Iixub3VzZXJfeGF0dHIiKTsKIAlpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZT
X01PVU5UX01BUF9TUEVDSUFMX0NIUikKIAkJc2VxX3B1dHMocywgIixtYXBjaGFycyIpOwor
CWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTUFQX1NGTV9DSFIp
CisJCXNlcV9wdXRzKHMsICIsbWFwcG9zaXgiKTsKIAlpZiAoY2lmc19zYi0+bW50X2NpZnNf
ZmxhZ3MgJiBDSUZTX01PVU5UX1VOWF9FTVVMKQogCQlzZXFfcHV0cyhzLCAiLHNmdSIpOwog
CWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTk9fQlJMKQpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9jaWZzcHJvdG8uaCBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKaW5k
ZXggYzMxY2U5OC4uYzYzZmQxZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcHJvdG8uaAor
KysgYi9mcy9jaWZzL2NpZnNwcm90by5oCkBAIC0zNjEsMTEgKzM2MSwxMSBAQCBleHRlcm4g
aW50IENJRlNVbml4Q3JlYXRlSGFyZExpbmsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIGV4
dGVybiBpbnQgQ0lGU1VuaXhDcmVhdGVTeW1MaW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQs
CiAJCQlzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJY29uc3QgY2hhciAqZnJvbU5hbWUs
IGNvbnN0IGNoYXIgKnRvTmFtZSwKLQkJCWNvbnN0IHN0cnVjdCBubHNfdGFibGUgKm5sc19j
b2RlcGFnZSk7CisJCQljb25zdCBzdHJ1Y3QgbmxzX3RhYmxlICpubHNfY29kZXBhZ2UsIGlu
dCByZW1hcCk7CiBleHRlcm4gaW50IENJRlNTTUJVbml4UXVlcnlTeW1MaW5rKGNvbnN0IHVu
c2lnbmVkIGludCB4aWQsCiAJCQlzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJY29uc3Qg
dW5zaWduZWQgY2hhciAqc2VhcmNoTmFtZSwgY2hhciAqKnN5bWluZm8sCi0JCQljb25zdCBz
dHJ1Y3QgbmxzX3RhYmxlICpubHNfY29kZXBhZ2UpOworCQkJY29uc3Qgc3RydWN0IG5sc190
YWJsZSAqbmxzX2NvZGVwYWdlLCBpbnQgcmVtYXApOwogZXh0ZXJuIGludCBDSUZTU01CUXVl
cnlTeW1MaW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24sCiAJCQkgICAgICAgX191MTYgZmlkLCBjaGFyICoqc3ltbGlua2luZm8sCiAJCQkgICAg
ICAgY29uc3Qgc3RydWN0IG5sc190YWJsZSAqbmxzX2NvZGVwYWdlKTsKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9jaWZzc21iLmMKaW5kZXggNjFkMDBhNi4u
ZTU4ODkwMSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzc21iLmMKKysrIGIvZnMvY2lmcy9j
aWZzc21iLmMKQEAgLTI3ODQsNyArMjc4NCw3IEBAIGNvcHlSZXRyeToKIGludAogQ0lGU1Vu
aXhDcmVhdGVTeW1MaW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiAJCSAgICAgIGNvbnN0IGNoYXIgKmZyb21OYW1lLCBjb25zdCBjaGFyICp0
b05hbWUsCi0JCSAgICAgIGNvbnN0IHN0cnVjdCBubHNfdGFibGUgKm5sc19jb2RlcGFnZSkK
KwkJICAgICAgY29uc3Qgc3RydWN0IG5sc190YWJsZSAqbmxzX2NvZGVwYWdlLCBpbnQgcmVt
YXApCiB7CiAJVFJBTlNBQ1RJT04yX1NQSV9SRVEgKnBTTUIgPSBOVUxMOwogCVRSQU5TQUNU
SU9OMl9TUElfUlNQICpwU01CciA9IE5VTEw7CkBAIC0yODA0LDkgKzI4MDQsOSBAQCBjcmVh
dGVTeW1MaW5rUmV0cnk6CiAKIAlpZiAocFNNQi0+aGRyLkZsYWdzMiAmIFNNQkZMRzJfVU5J
Q09ERSkgewogCQluYW1lX2xlbiA9Ci0JCSAgICBjaWZzX3N0cnRvVVRGMTYoKF9fbGUxNiAq
KSBwU01CLT5GaWxlTmFtZSwgZnJvbU5hbWUsCi0JCQkJICAgIC8qIGZpbmQgZGVmaW5lIGZv
ciB0aGlzIG1heHBhdGhjb21wb25lbnQgKi8KLQkJCQkgICAgUEFUSF9NQVgsIG5sc19jb2Rl
cGFnZSk7CisJCSAgICBjaWZzQ29udmVydFRvVVRGMTYoKF9fbGUxNiAqKSBwU01CLT5GaWxl
TmFtZSwgZnJvbU5hbWUsCisJCQkJLyogZmluZCBkZWZpbmUgZm9yIHRoaXMgbWF4cGF0aGNv
bXBvbmVudCAqLworCQkJCQlQQVRIX01BWCwgbmxzX2NvZGVwYWdlLCByZW1hcCk7CiAJCW5h
bWVfbGVuKys7CS8qIHRyYWlsaW5nIG51bGwgKi8KIAkJbmFtZV9sZW4gKj0gMjsKIApAQCAt
MjgyOCw5ICsyODI4LDkgQEAgY3JlYXRlU3ltTGlua1JldHJ5OgogCWRhdGFfb2Zmc2V0ID0g
KGNoYXIgKikgKCZwU01CLT5oZHIuUHJvdG9jb2wpICsgb2Zmc2V0OwogCWlmIChwU01CLT5o
ZHIuRmxhZ3MyICYgU01CRkxHMl9VTklDT0RFKSB7CiAJCW5hbWVfbGVuX3RhcmdldCA9Ci0J
CSAgICBjaWZzX3N0cnRvVVRGMTYoKF9fbGUxNiAqKSBkYXRhX29mZnNldCwgdG9OYW1lLCBQ
QVRIX01BWAotCQkJCSAgICAvKiBmaW5kIGRlZmluZSBmb3IgdGhpcyBtYXhwYXRoY29tcG9u
ZW50ICovCi0JCQkJICAgICwgbmxzX2NvZGVwYWdlKTsKKwkJICAgIGNpZnNDb252ZXJ0VG9V
VEYxNigoX19sZTE2ICopIGRhdGFfb2Zmc2V0LCB0b05hbWUsCisJCQkJLyogZmluZCBkZWZp
bmUgZm9yIHRoaXMgbWF4cGF0aGNvbXBvbmVudCAqLworCQkJCQlQQVRIX01BWCwgbmxzX2Nv
ZGVwYWdlLCByZW1hcCk7CiAJCW5hbWVfbGVuX3RhcmdldCsrOwkvKiB0cmFpbGluZyBudWxs
ICovCiAJCW5hbWVfbGVuX3RhcmdldCAqPSAyOwogCX0gZWxzZSB7CS8qIEJCIGltcHJvdmUg
dGhlIGNoZWNrIGZvciBidWZmZXIgb3ZlcnJ1bnMgQkIgKi8KQEAgLTMwMzQsNyArMzAzNCw3
IEBAIHdpbkNyZWF0ZUhhcmRMaW5rUmV0cnk6CiBpbnQKIENJRlNTTUJVbml4UXVlcnlTeW1M
aW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CQljb25zdCB1bnNpZ25lZCBjaGFyICpzZWFyY2hOYW1lLCBjaGFyICoqc3ltbGlua2luZm8s
Ci0JCQljb25zdCBzdHJ1Y3QgbmxzX3RhYmxlICpubHNfY29kZXBhZ2UpCisJCQljb25zdCBz
dHJ1Y3QgbmxzX3RhYmxlICpubHNfY29kZXBhZ2UsIGludCByZW1hcCkKIHsKIC8qIFNNQl9R
VUVSWV9GSUxFX1VOSVhfTElOSyAqLwogCVRSQU5TQUNUSU9OMl9RUElfUkVRICpwU01CID0g
TlVMTDsKQEAgLTMwNTUsOCArMzA1NSw5IEBAIHF1ZXJ5U3ltTGlua1JldHJ5OgogCiAJaWYg
KHBTTUItPmhkci5GbGFnczIgJiBTTUJGTEcyX1VOSUNPREUpIHsKIAkJbmFtZV9sZW4gPQot
CQkJY2lmc19zdHJ0b1VURjE2KChfX2xlMTYgKikgcFNNQi0+RmlsZU5hbWUsIHNlYXJjaE5h
bWUsCi0JCQkJCVBBVEhfTUFYLCBubHNfY29kZXBhZ2UpOworCQkJY2lmc0NvbnZlcnRUb1VU
RjE2KChfX2xlMTYgKikgcFNNQi0+RmlsZU5hbWUsCisJCQkJCSAgIHNlYXJjaE5hbWUsIFBB
VEhfTUFYLCBubHNfY29kZXBhZ2UsCisJCQkJCSAgIHJlbWFwKTsKIAkJbmFtZV9sZW4rKzsJ
LyogdHJhaWxpbmcgbnVsbCAqLwogCQluYW1lX2xlbiAqPSAyOwogCX0gZWxzZSB7CS8qIEJC
IGltcHJvdmUgdGhlIGNoZWNrIGZvciBidWZmZXIgb3ZlcnJ1bnMgQkIgKi8KZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvZGlyLmMgYi9mcy9jaWZzL2Rpci5jCmluZGV4IGI3MmJjMjkuLmQwY2Jk
YTIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZGlyLmMKKysrIGIvZnMvY2lmcy9kaXIuYwpAQCAt
NjIwLDggKzYyMCw3IEBAIGludCBjaWZzX21rbm9kKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0
cnVjdCBkZW50cnkgKmRpcmVudHJ5LCB1bW9kZV90IG1vZGUsCiAJCX0KIAkJcmMgPSBDSUZT
U01CVW5peFNldFBhdGhJbmZvKHhpZCwgdGNvbiwgZnVsbF9wYXRoLCAmYXJncywKIAkJCQkJ
ICAgIGNpZnNfc2ItPmxvY2FsX25scywKLQkJCQkJICAgIGNpZnNfc2ItPm1udF9jaWZzX2Zs
YWdzICYKLQkJCQkJCUNJRlNfTU9VTlRfTUFQX1NQRUNJQUxfQ0hSKTsKKwkJCQkJICAgIGNp
ZnNfcmVtYXAoY2lmc19zYikpOwogCQlpZiAocmMpCiAJCQlnb3RvIG1rbm9kX291dDsKIApk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCBkNTM1
ZTE2Li43YzY3OWM3IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9jaWZz
L2ZpbGUuYwpAQCAtMTQwLDggKzE0MCw3IEBAIGludCBjaWZzX3Bvc2l4X29wZW4oY2hhciAq
ZnVsbF9wYXRoLCBzdHJ1Y3QgaW5vZGUgKipwaW5vZGUsCiAJcG9zaXhfZmxhZ3MgPSBjaWZz
X3Bvc2l4X2NvbnZlcnRfZmxhZ3MoZl9mbGFncyk7CiAJcmMgPSBDSUZTUE9TSVhDcmVhdGUo
eGlkLCB0Y29uLCBwb3NpeF9mbGFncywgbW9kZSwgcG5ldGZpZCwgcHJlc3BfZGF0YSwKIAkJ
CSAgICAgcG9wbG9jaywgZnVsbF9wYXRoLCBjaWZzX3NiLT5sb2NhbF9ubHMsCi0JCQkgICAg
IGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYKLQkJCQkJQ0lGU19NT1VOVF9NQVBfU1BFQ0lB
TF9DSFIpOworCQkJICAgICBjaWZzX3JlbWFwKGNpZnNfc2IpKTsKIAljaWZzX3B1dF90bGlu
ayh0bGluayk7CiAKIAlpZiAocmMpCmRpZmYgLS1naXQgYS9mcy9jaWZzL2lub2RlLmMgYi9m
cy9jaWZzL2lub2RlLmMKaW5kZXggMGMzY2U0Ni4uN2VlZTNkMCAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMzczLDggKzM3Myw3IEBA
IGludCBjaWZzX2dldF9pbm9kZV9pbmZvX3VuaXgoc3RydWN0IGlub2RlICoqcGlub2RlLAog
CiAJLyogY291bGQgaGF2ZSBkb25lIGEgZmluZCBmaXJzdCBpbnN0ZWFkIGJ1dCB0aGlzIHJl
dHVybnMgbW9yZSBpbmZvICovCiAJcmMgPSBDSUZTU01CVW5peFFQYXRoSW5mbyh4aWQsIHRj
b24sIGZ1bGxfcGF0aCwgJmZpbmRfZGF0YSwKLQkJCQkgIGNpZnNfc2ItPmxvY2FsX25scywg
Y2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJgotCQkJCQlDSUZTX01PVU5UX01BUF9TUEVDSUFM
X0NIUik7CisJCQkJICBjaWZzX3NiLT5sb2NhbF9ubHMsIGNpZnNfcmVtYXAoY2lmc19zYikp
OwogCWNpZnNfcHV0X3RsaW5rKHRsaW5rKTsKIAogCWlmICghcmMpIHsKQEAgLTIyMTUsOCAr
MjIxNCw3IEBAIGNpZnNfc2V0YXR0cl91bml4KHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LCBz
dHJ1Y3QgaWF0dHIgKmF0dHJzKQogCQlwVGNvbiA9IHRsaW5rX3Rjb24odGxpbmspOwogCQly
YyA9IENJRlNTTUJVbml4U2V0UGF0aEluZm8oeGlkLCBwVGNvbiwgZnVsbF9wYXRoLCBhcmdz
LAogCQkJCSAgICBjaWZzX3NiLT5sb2NhbF9ubHMsCi0JCQkJICAgIGNpZnNfc2ItPm1udF9j
aWZzX2ZsYWdzICYKLQkJCQkJQ0lGU19NT1VOVF9NQVBfU1BFQ0lBTF9DSFIpOworCQkJCSAg
ICBjaWZzX3JlbWFwKGNpZnNfc2IpKTsKIAkJY2lmc19wdXRfdGxpbmsodGxpbmspOwogCX0K
IApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9saW5rLmMgYi9mcy9jaWZzL2xpbmsuYwppbmRleCAy
ZWM2MDM3Li5mYTg2NGRkIDEwMDY0NAotLS0gYS9mcy9jaWZzL2xpbmsuYworKysgYi9mcy9j
aWZzL2xpbmsuYwpAQCAtNzE3LDcgKzcxNyw4IEBAIGNpZnNfc3ltbGluayhzdHJ1Y3QgaW5v
ZGUgKmlub2RlLCBzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSwgY29uc3QgY2hhciAqc3ltbmFt
ZSkKIAkJcmMgPSBjcmVhdGVfbWZfc3ltbGluayh4aWQsIHBUY29uLCBjaWZzX3NiLCBmdWxs
X3BhdGgsIHN5bW5hbWUpOwogCWVsc2UgaWYgKHBUY29uLT51bml4X2V4dCkKIAkJcmMgPSBD
SUZTVW5peENyZWF0ZVN5bUxpbmsoeGlkLCBwVGNvbiwgZnVsbF9wYXRoLCBzeW1uYW1lLAot
CQkJCQkgICBjaWZzX3NiLT5sb2NhbF9ubHMpOworCQkJCQkgICBjaWZzX3NiLT5sb2NhbF9u
bHMsCisJCQkJCSAgIGNpZnNfcmVtYXAoY2lmc19zYikpOwogCS8qIGVsc2UKIAkgICByYyA9
IENJRlNDcmVhdGVSZXBhcnNlU3ltTGluayh4aWQsIHBUY29uLCBmcm9tTmFtZSwgdG9OYW1l
LAogCQkJCQljaWZzX3NiX3RhcmdldC0+bG9jYWxfbmxzKTsgKi8KZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvc21iMW9wcy5jIGIvZnMvY2lmcy9zbWIxb3BzLmMKaW5kZXggZDI5NzkwMy4uMDIw
YzhkZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIxb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIx
b3BzLmMKQEAgLTk2MCw3ICs5NjAsOCBAQCBjaWZzX3F1ZXJ5X3N5bWxpbmsoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkvKiBDaGVjayBmb3Ig
dW5peCBleHRlbnNpb25zICovCiAJaWYgKGNhcF91bml4KHRjb24tPnNlcykpIHsKIAkJcmMg
PSBDSUZTU01CVW5peFF1ZXJ5U3ltTGluayh4aWQsIHRjb24sIGZ1bGxfcGF0aCwgdGFyZ2V0
X3BhdGgsCi0JCQkJCSAgICAgY2lmc19zYi0+bG9jYWxfbmxzKTsKKwkJCQkJICAgICBjaWZz
X3NiLT5sb2NhbF9ubHMsCisJCQkJCSAgICAgY2lmc19yZW1hcChjaWZzX3NiKSk7CiAJCWlm
IChyYyA9PSAtRVJFTU9URSkKIAkJCXJjID0gY2lmc191bml4X2Rmc19yZWFkbGluayh4aWQs
IHRjb24sIGZ1bGxfcGF0aCwKIAkJCQkJCSAgICB0YXJnZXRfcGF0aCwKLS0gCjEuNy4xCgo=
--------------080405050205090601030502--
