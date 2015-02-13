From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Fix another bug from patch  Re: [PATCH] Fix that several functions
 handle incorrect value of mapchars
Date: Fri, 13 Feb 2015 16:50:56 +0900
Message-ID: <54DDACE0.20407@nttcom.co.jp>
References: <1423366419.2402.24.camel@trilug.org> <54D9D6C0.100@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D9D6C0.100-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

convert_to_sfm_char(char src_char)
> [BUG2] : forget to convert '\'
> +    case '\\':
> +        dest_char = cpu_to_le16(SFM_SLASH);
> +        break;

I remove [BUG2]  from patch.
This modify causes another bug.

When server is windows, path is represented by "\directory\file" .
This modify changes path to "(SFM_SLASH)directory(SFM_SLASH)file"
and send request to server with this path
, then server returns "no such file or directory" .


On 2015/02/10 19:00, Nakajima Akira wrote:
> On 2015/02/08 12:33, Carl Schaefer wrote:
>> Hello, I would like to offer a comment on your patch:
>>
>> [BUG5] : /proc/mounts don't show "mapchars" when using mapposix mount option
>> -    if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
>> +    if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR ||
>> +        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
>>           seq_puts(s, ",mapchars");
>>
>> I suggest it would be more accurate to display "mapposix", for example:
>>
>>     if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
>>           seq_puts(s, ",mapchars");
>> +    if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
>> +         seq_puts(s, ",mapposix");
>>
>> Carl
>
> I modified patch by Carl's comment.

 From 27408a9a3fe8a2896084bf7c6c295e9da5608f00 Mon Sep 17 00:00:00 2001
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
-- 
1.7.1
