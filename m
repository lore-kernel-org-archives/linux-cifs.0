From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] Add ioctl to set integrity
Date: Sun, 28 Jun 2015 18:36:09 -0500
Message-ID: <1435534570-10864-4-git-send-email-steve.french@primarydata.com>
References: <1435534570-10864-1-git-send-email-steve.french@primarydata.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435534570-10864-1-git-send-email-steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

set integrity increases reliability of files stored on SMB3 servers.
Add ioctl to allow setting this on files on SMB3 and later mounts.

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/ioctl.c    | 11 +++++++++++
 fs/cifs/smb2ops.c  | 24 ++++++++++++++++++++++++
 fs/cifs/smb2pdu.h  |  1 +
 4 files changed, 38 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 81194e6..b406a32 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -372,6 +372,8 @@ struct smb_version_operations {
 	void (*new_lease_key)(struct cifs_fid *);
 	int (*generate_signingkey)(struct cifs_ses *);
 	int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *);
+	int (*set_integrity)(const unsigned int, struct cifs_tcon *tcon,
+			     struct cifsFileInfo *src_file);
 	int (*query_mf_symlink)(unsigned int, struct cifs_tcon *,
 				struct cifs_sb_info *, const unsigned char *,
 				char *, unsigned int *);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 7843b19..49b8b6e 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -35,6 +35,7 @@
 
 #define CIFS_IOCTL_MAGIC	0xCF
 #define CIFS_IOC_COPYCHUNK_FILE	_IOW(CIFS_IOCTL_MAGIC, 3, int)
+#define CIFS_IOC_SET_INTEGRITY  _IO(CIFS_IOCTL_MAGIC, 4)
 
 static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 			unsigned long srcfd, u64 off, u64 len, u64 destoff,
@@ -217,6 +218,16 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 		case BTRFS_IOC_CLONE:
 			rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, true);
 			break;
+		case CIFS_IOC_SET_INTEGRITY:
+			if (pSMBFile == NULL)
+				break;
+			tcon = tlink_tcon(pSMBFile->tlink);
+			if (tcon->ses->server->ops->set_integrity)
+				rc = tcon->ses->server->ops->set_integrity(xid,
+						tcon, pSMBFile);
+			else
+				rc = -EOPNOTSUPP;
+			break;
 		default:
 			cifs_dbg(FYI, "unsupported ioctl\n");
 			break;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d8a124c..f92960b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -862,6 +862,28 @@ smb2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static int
+smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
+		   struct cifsFileInfo *cfile)
+{
+	struct fsctl_set_integrity_information_req integr_info;
+	char *retbuf = NULL;
+	unsigned int ret_data_len;
+
+	integr_info.ChecksumAlgorithm = cpu_to_le16(CHECKSUM_TYPE_UNCHANGED);
+	integr_info.Flags = 0;
+	integr_info.Reserved = 0;
+
+	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+			cfile->fid.volatile_fid,
+			FSCTL_SET_INTEGRITY_INFORMATION,
+			true /* is_fsctl */, (char *)&integr_info,
+			sizeof(struct fsctl_set_integrity_information_req),
+			(char **)&retbuf,
+			&ret_data_len);
+
+}
+
+static int
 smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		     const char *path, struct cifs_sb_info *cifs_sb,
 		     struct cifs_fid *fid, __u16 search_flags,
@@ -1671,6 +1693,7 @@ struct smb_version_operations smb30_operations = {
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb3signingkey,
 	.calc_signature = smb3_calc_signature,
+	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
 	.create_lease_buf = smb3_create_lease_buf,
@@ -1756,6 +1779,7 @@ struct smb_version_operations smb311_operations = {
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb3signingkey,
 	.calc_signature = smb3_calc_signature,
+	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
 	.create_lease_buf = smb3_create_lease_buf,
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index c302e82..2d91c2a 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -638,6 +638,7 @@ struct fsctl_get_integrity_information_rsp {
 /* Integrity ChecksumAlgorithm choices for above */
 #define	CHECKSUM_TYPE_NONE	0x0000
 #define	CHECKSUM_TYPE_CRC64	0x0002
+#define CHECKSUM_TYPE_UNCHANGED	0xFFFF	/* set only */
 
 /* Integrity flags for above */
 #define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF	0x00000001
-- 
2.1.4
