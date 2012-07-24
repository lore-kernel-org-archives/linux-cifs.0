From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 1/45] CIFS: Make CAP_* checks protocol independent
Date: Tue, 24 Jul 2012 11:21:42 +0400
Message-ID: <1343114502-7908-1-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-2-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since both CIFS and SMB2 use ses->capabilities (server->capabilities)
field but flags are different we should make such checks protocol
independent.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |   14 ++++++++++++--
 fs/cifs/connect.c  |    6 +++---
 fs/cifs/dir.c      |    3 +--
 fs/cifs/file.c     |   33 ++++++++++++++++-----------------
 fs/cifs/inode.c    |   26 ++++++++++++--------------
 fs/cifs/link.c     |    6 +++---
 fs/cifs/readdir.c  |   16 ++++++++--------
 fs/cifs/smb1ops.c  |    3 +++
 fs/cifs/smb2ops.c  |    3 +++
 fs/cifs/smb2pdu.c  |    2 ++
 fs/cifs/smb2pdu.h  |    3 +++
 11 files changed, 66 insertions(+), 49 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 12b1176..bcdf4d4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -258,6 +258,9 @@ struct smb_version_values {
 	size_t		max_header_size;
 	size_t		read_rsp_size;
 	__le16		lock_cmd;
+	unsigned int	cap_unix;
+	unsigned int	cap_nt_find;
+	unsigned int	cap_large_files;
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
@@ -408,7 +411,7 @@ struct TCP_Server_Info {
 	unsigned int max_vcs;	/* maximum number of smb sessions, at least
 				   those that can be specified uniquely with
 				   vcnumbers */
-	int capabilities; /* allow selective disabling of caps by smb sess */
+	unsigned int capabilities; /* selective disabling of caps by smb sess */
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
 	__u64 CurrentMid;         /* multiplex id - rotating counter */
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
@@ -532,7 +535,7 @@ struct cifs_ses {
 	__u64 Suid;		/* remote smb uid  */
 	uid_t linux_uid;        /* overriding owner of files on the mount */
 	uid_t cred_uid;		/* owner of credentials */
-	int capabilities;
+	unsigned int capabilities;
 	char serverName[SERVER_NAME_LEN_WITH_NULL * 2];	/* BB make bigger for
 				TCP names - will ipv6 and sctp addresses fit? */
 	char *user_name;	/* must not be null except during init of sess
@@ -554,6 +557,13 @@ struct cifs_ses {
    which do not negotiate NTLM or POSIX dialects, but instead
    negotiate one of the older LANMAN dialects */
 #define CIFS_SES_LANMAN 8
+
+static inline bool
+cap_unix(struct cifs_ses *ses)
+{
+	return ses->server->vals->cap_unix & ses->capabilities;
+}
+
 /*
  * there is one of these for each connection to a resource on a particular
  * session
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5ab173f..6df6fa1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3634,7 +3634,7 @@ try_mount_again:
 	}
 
 	/* tell server which Unix caps we support */
-	if (tcon->ses->capabilities & CAP_UNIX) {
+	if (cap_unix(tcon->ses)) {
 		/* reset of caps checks mount to see if unix extensions
 		   disabled for just this mount */
 		reset_cifs_unix_caps(xid, tcon, cifs_sb, volume_info);
@@ -3993,7 +3993,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	ses->flags = 0;
 	ses->capabilities = server->capabilities;
 	if (linuxExtEnabled == 0)
-		ses->capabilities &= (~CAP_UNIX);
+		ses->capabilities &= (~server->vals->cap_unix);
 
 	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
 		 server->sec_mode, server->capabilities, server->timeAdj);
@@ -4100,7 +4100,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 		goto out;
 	}
 
-	if (ses->capabilities & CAP_UNIX)
+	if (cap_unix(ses))
 		reset_cifs_unix_caps(0, tcon, NULL, vol_info);
 out:
 	kfree(vol_info->username);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 2caba0b..cbe709a 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -182,8 +182,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		goto out;
 	}
 
-	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
-	    !tcon->broken_posix_open &&
+	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		rc = cifs_posix_open(full_path, &newinode,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 93b3b13..07e9d41 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -385,9 +385,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		oplock = 0;
 
 	if (!tcon->broken_posix_open && tcon->unix_ext &&
-	    (tcon->ses->capabilities & CAP_UNIX) &&
-	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
-			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
+	    cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
+				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		/* can not refresh inode info since size could be stale */
 		rc = cifs_posix_open(full_path, &inode, inode->i_sb,
 				cifs_sb->mnt_file_mode /* ignored */,
@@ -509,10 +508,9 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 	else
 		oplock = 0;
 
-	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
+	if (tcon->unix_ext && cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
-			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-
+				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		/*
 		 * O_CREAT, O_EXCL and O_TRUNC already had their effect on the
 		 * original open. Must mask them off for a reopen.
@@ -1071,7 +1069,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
-	if ((tcon->ses->capabilities & CAP_UNIX) &&
+	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return cifs_push_posix_locks(cfile);
@@ -1419,7 +1417,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	netfid = cfile->netfid;
 	cinode = CIFS_I(file->f_path.dentry->d_inode);
 
-	if ((tcon->ses->capabilities & CAP_UNIX) &&
+	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
@@ -2745,7 +2743,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	unsigned int current_read_size;
 	unsigned int rsize;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	unsigned int xid;
 	char *current_offset;
 	struct cifsFileInfo *open_file;
@@ -2765,7 +2763,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		return rc;
 	}
 	open_file = file->private_data;
-	pTcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(open_file->tlink);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
@@ -2779,11 +2777,12 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	     read_size > total_read;
 	     total_read += bytes_read, current_offset += bytes_read) {
 		current_read_size = min_t(uint, read_size - total_read, rsize);
-
-		/* For windows me and 9x we do not want to request more
-		than it negotiated since it will refuse the read then */
-		if ((pTcon->ses) &&
-			!(pTcon->ses->capabilities & CAP_LARGE_FILES)) {
+		/*
+		 * For windows me and 9x we do not want to request more than it
+		 * negotiated since it will refuse the read then.
+		 */
+		if ((tcon->ses) && !(tcon->ses->capabilities &
+				tcon->ses->server->vals->cap_large_files)) {
 			current_read_size = min_t(uint, current_read_size,
 					CIFSMaxBufSize);
 		}
@@ -2796,7 +2795,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 			}
 			io_parms.netfid = open_file->netfid;
 			io_parms.pid = pid;
-			io_parms.tcon = pTcon;
+			io_parms.tcon = tcon;
 			io_parms.offset = *poffset;
 			io_parms.length = current_read_size;
 			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
@@ -2810,7 +2809,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 				return rc;
 			}
 		} else {
-			cifs_stats_bytes_read(pTcon, total_read);
+			cifs_stats_bytes_read(tcon, total_read);
 			*poffset += bytes_read;
 		}
 	}
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index def1006..35cb6a3 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1149,9 +1149,8 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 		goto unlink_out;
 	}
 
-	if ((tcon->ses->capabilities & CAP_UNIX) &&
-		(CIFS_UNIX_POSIX_PATH_OPS_CAP &
-			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
+	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
+				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		rc = CIFSPOSIXDelFile(xid, tcon, full_path,
 			SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
@@ -1226,7 +1225,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	char *full_path = NULL;
 	struct inode *newinode = NULL;
 	struct cifs_fattr fattr;
@@ -1237,7 +1236,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
+	tcon = tlink_tcon(tlink);
 
 	xid = get_xid();
 
@@ -1247,9 +1246,8 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 		goto mkdir_out;
 	}
 
-	if ((pTcon->ses->capabilities & CAP_UNIX) &&
-		(CIFS_UNIX_POSIX_PATH_OPS_CAP &
-			le64_to_cpu(pTcon->fsUnixInfo.Capability))) {
+	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
+				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		u32 oplock = 0;
 		FILE_UNIX_BASIC_INFO *pInfo =
 			kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
@@ -1259,7 +1257,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 		}
 
 		mode &= ~current_umask();
-		rc = CIFSPOSIXCreate(xid, pTcon, SMB_O_DIRECTORY | SMB_O_CREAT,
+		rc = CIFSPOSIXCreate(xid, tcon, SMB_O_DIRECTORY | SMB_O_CREAT,
 				mode, NULL /* netfid */, pInfo, &oplock,
 				full_path, cifs_sb->local_nls,
 				cifs_sb->mnt_cifs_flags &
@@ -1303,14 +1301,14 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	}
 mkdir_retry_old:
 	/* BB add setting the equivalent of mode via CreateX w/ACLs */
-	rc = CIFSSMBMkDir(xid, pTcon, full_path, cifs_sb->local_nls,
+	rc = CIFSSMBMkDir(xid, tcon, full_path, cifs_sb->local_nls,
 			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
 		cFYI(1, "cifs_mkdir returned 0x%x", rc);
 		d_drop(direntry);
 	} else {
 mkdir_get_info:
-		if (pTcon->unix_ext)
+		if (tcon->unix_ext)
 			rc = cifs_get_inode_info_unix(&newinode, full_path,
 						      inode->i_sb, xid);
 		else
@@ -1328,7 +1326,7 @@ mkdir_get_info:
 		if (inode->i_mode & S_ISGID)
 			mode |= S_ISGID;
 
-		if (pTcon->unix_ext) {
+		if (tcon->unix_ext) {
 			struct cifs_unix_set_info_args args = {
 				.mode	= mode,
 				.ctime	= NO_CHANGE_64,
@@ -1346,7 +1344,7 @@ mkdir_get_info:
 				args.uid = NO_CHANGE_64;
 				args.gid = NO_CHANGE_64;
 			}
-			CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, &args,
+			CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
 					       cifs_sb->local_nls,
 					       cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
@@ -1361,7 +1359,7 @@ mkdir_get_info:
 				cifsInode = CIFS_I(newinode);
 				dosattrs = cifsInode->cifsAttrs|ATTR_READONLY;
 				pInfo.Attributes = cpu_to_le32(dosattrs);
-				tmprc = CIFSSMBSetPathInfo(xid, pTcon,
+				tmprc = CIFSSMBSetPathInfo(xid, tcon,
 						full_path, &pInfo,
 						cifs_sb->local_nls,
 						cifs_sb->mnt_cifs_flags &
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index f789715..09e4b3a 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -495,8 +495,8 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	 * but there doesn't seem to be any harm in allowing the client to
 	 * read them.
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
-	    && !(tcon->ses->capabilities & CAP_UNIX)) {
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) &&
+	    !cap_unix(tcon->ses)) {
 		rc = -EACCES;
 		goto out;
 	}
@@ -518,7 +518,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 
-	if ((rc != 0) && (tcon->ses->capabilities & CAP_UNIX))
+	if ((rc != 0) && cap_unix(tcon->ses))
 		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
 					     cifs_sb->local_nls);
 
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index da30d96..d87f826 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -228,7 +228,7 @@ static int initiate_cifs_search(const unsigned int xid, struct file *file)
 	struct cifsFileInfo *cifsFile;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	struct tcon_link *tlink = NULL;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 
 	if (file->private_data == NULL) {
 		tlink = cifs_sb_tlink(cifs_sb);
@@ -242,10 +242,10 @@ static int initiate_cifs_search(const unsigned int xid, struct file *file)
 		}
 		file->private_data = cifsFile;
 		cifsFile->tlink = cifs_get_tlink(tlink);
-		pTcon = tlink_tcon(tlink);
+		tcon = tlink_tcon(tlink);
 	} else {
 		cifsFile = file->private_data;
-		pTcon = tlink_tcon(cifsFile->tlink);
+		tcon = tlink_tcon(cifsFile->tlink);
 	}
 
 	cifsFile->invalidHandle = true;
@@ -262,11 +262,11 @@ static int initiate_cifs_search(const unsigned int xid, struct file *file)
 ffirst_retry:
 	/* test for Unix extensions */
 	/* but now check for them on the share/mount not on the SMB session */
-/*	if (pTcon->ses->capabilities & CAP_UNIX) { */
-	if (pTcon->unix_ext)
+	/* if (cap_unix(tcon->ses) { */
+	if (tcon->unix_ext)
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_UNIX;
-	else if ((pTcon->ses->capabilities &
-			(CAP_NT_SMBS | CAP_NT_FIND)) == 0) {
+	else if ((tcon->ses->capabilities &
+		  tcon->ses->server->vals->cap_nt_find) == 0) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_INFO_STANDARD;
 	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
@@ -278,7 +278,7 @@ ffirst_retry:
 	if (backup_cred(cifs_sb))
 		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
 
-	rc = CIFSFindFirst(xid, pTcon, full_path, cifs_sb->local_nls,
+	rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb->local_nls,
 		&cifsFile->netfid, search_flags, &cifsFile->srch_inf,
 		cifs_sb->mnt_cifs_flags &
 			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5817409..c40356d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -632,4 +632,7 @@ struct smb_version_values smb1_values = {
 	.max_header_size = MAX_CIFS_HDR_SIZE,
 	.read_rsp_size = sizeof(READ_RSP),
 	.lock_cmd = cpu_to_le16(SMB_COM_LOCKING_ANDX),
+	.cap_unix = CAP_UNIX,
+	.cap_nt_find = CAP_NT_SMBS | CAP_NT_FIND,
+	.cap_large_files = CAP_LARGE_FILES,
 };
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1018c5c..410cf92 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -325,4 +325,7 @@ struct smb_version_values smb21_values = {
 	.header_size = sizeof(struct smb2_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.lock_cmd = SMB2_LOCK,
+	.cap_unix = 0,
+	.cap_nt_find = SMB2_NT_FIND,
+	.cap_large_files = SMB2_LARGE_FILES,
 };
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e4eb1d3..62b3f17 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -428,6 +428,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	/* BB Do we need to validate the SecurityMode? */
 	server->sec_mode = le16_to_cpu(rsp->SecurityMode);
 	server->capabilities = le32_to_cpu(rsp->Capabilities);
+	/* Internal types */
+	server->capabilities |= SMB2_NT_FIND | SMB2_LARGE_FILES;
 
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
 					       &rsp->hdr);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 59aae60..f37a1b4 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -167,6 +167,9 @@ struct smb2_negotiate_req {
 #define SMB2_GLOBAL_CAP_DFS		0x00000001
 #define SMB2_GLOBAL_CAP_LEASING		0x00000002 /* Resp only New to SMB2.1 */
 #define SMB2_GLOBAL_CAP_LARGE_MTU	0X00000004 /* Resp only New to SMB2.1 */
+/* Internal types */
+#define SMB2_NT_FIND			0x00100000
+#define SMB2_LARGE_FILES		0x00200000
 
 struct smb2_negotiate_rsp {
 	struct smb2_hdr hdr;
-- 
1.7.1
