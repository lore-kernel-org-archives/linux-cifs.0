From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 40/45] CIFS: Add readdir support for SMB2
Date: Wed, 18 Jul 2012 19:48:56 +0400
Message-ID: <1342626541-29872-41-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2misc.c  |    8 ++-
 fs/cifs/smb2ops.c   |   57 +++++++++++++++++
 fs/cifs/smb2pdu.c   |  168 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   28 +++++++++
 fs/cifs/smb2proto.h |    5 +-
 5 files changed, 264 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index cbb69e2..81fb162 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -246,6 +246,11 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 		*len = le32_to_cpu(((struct smb2_read_rsp *)hdr)->DataLength);
 		break;
 	case SMB2_QUERY_DIRECTORY:
+		*off = le16_to_cpu(
+		  ((struct smb2_query_directory_rsp *)hdr)->OutputBufferOffset);
+		*len = le32_to_cpu(
+		  ((struct smb2_query_directory_rsp *)hdr)->OutputBufferLength);
+		break;
 	case SMB2_IOCTL:
 	case SMB2_CHANGE_NOTIFY:
 	default:
@@ -288,8 +293,9 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
  * portion, the number of word parameters and the data portion of the message.
  */
 unsigned int
-smb2_calc_size(struct smb2_hdr *hdr)
+smb2_calc_size(void *buf)
 {
+	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
 	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
 	int offset; /* the offset from the beginning of SMB to data area */
 	int data_length; /* the length of the variable length data area */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7ecb117..0ea6cfe 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -415,6 +415,59 @@ smb2_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
 			    cfile->fid.volatile_fid, cfile->pid, &eof);
 }
 
+static int
+smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
+		     const char *path, struct cifs_sb_info *cifs_sb,
+		     struct cifs_fid *fid, __u16 search_flags,
+		     struct cifs_search_info *srch_inf)
+{
+	__le16 *utf16_path;
+	int rc;
+	__u64 persistent_fid, volatile_fid;
+
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
+		       FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0,
+		       NULL);
+	kfree(utf16_path);
+	if (rc) {
+		cERROR(1, "open dir failed");
+		return rc;
+	}
+
+	srch_inf->entries_in_buffer = 0;
+	srch_inf->index_of_last_entry = 0;
+	fid->persistent_fid = persistent_fid;
+	fid->volatile_fid = volatile_fid;
+
+	rc = SMB2_query_directory(xid, tcon, persistent_fid, volatile_fid, 0,
+				  srch_inf);
+	if (rc) {
+		cERROR(1, "query directory failed");
+		SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	}
+	return rc;
+}
+
+static int
+smb2_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
+		    struct cifs_fid *fid, __u16 search_flags,
+		    struct cifs_search_info *srch_inf)
+{
+	return SMB2_query_directory(xid, tcon, fid->persistent_fid,
+				    fid->volatile_fid, 0, srch_inf);
+}
+
+static int
+smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
+	       struct cifs_fid *fid)
+{
+	return SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -464,6 +517,10 @@ struct smb_version_operations smb21_operations = {
 	.async_writev = smb2_async_writev,
 	.sync_read = smb2_sync_read,
 	.sync_write = smb2_sync_write,
+	.query_dir_first = smb2_query_dir_first,
+	.query_dir_next = smb2_query_dir_next,
+	.close_dir = smb2_close_dir,
+	.calc_smb_size = smb2_calc_size,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1587761..181b4db 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -45,6 +45,7 @@
 #include "ntlmssp.h"
 #include "smb2status.h"
 #include "smb2glob.h"
+#include "cifspdu.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -1598,6 +1599,173 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	return rc;
 }
 
+static unsigned int
+num_entries(char *bufstart, char *end_of_buf, char **lastentry, size_t size)
+{
+	int len;
+	unsigned int entrycount = 0;
+	unsigned int next_offset = 0;
+	FILE_DIRECTORY_INFO *entryptr;
+
+	if (bufstart == NULL)
+		return 0;
+
+	entryptr = (FILE_DIRECTORY_INFO *)bufstart;
+
+	while (1) {
+		entryptr = (FILE_DIRECTORY_INFO *)
+					((char *)entryptr + next_offset);
+
+		if ((char *)entryptr + size > end_of_buf) {
+			cERROR(1, "malformed search entry would overflow");
+			break;
+		}
+
+		len = le32_to_cpu(entryptr->FileNameLength);
+		if ((char *)entryptr + len + size > end_of_buf) {
+			cERROR(1, "directory entry name would overflow frame "
+				  "end of buf %p", end_of_buf);
+			break;
+		}
+
+		*lastentry = (char *)entryptr;
+		entrycount++;
+
+		next_offset = le32_to_cpu(entryptr->NextEntryOffset);
+		if (!next_offset)
+			break;
+	}
+
+	return entrycount;
+}
+
+/*
+ * Readdir/FindFirst
+ */
+int
+SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
+		     u64 persistent_fid, u64 volatile_fid, int index,
+		     struct cifs_search_info *srch_inf)
+{
+	struct smb2_query_directory_req *req;
+	struct smb2_query_directory_rsp *rsp = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int len;
+	int resp_buftype;
+	unsigned char *bufptr;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	__le16 asteriks = cpu_to_le16('*');
+	char *end_of_smb;
+	unsigned int output_size = CIFSMaxBufSize;
+	size_t info_buf_size;
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_QUERY_DIRECTORY, tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	switch (srch_inf->info_level) {
+	case SMB_FIND_FILE_DIRECTORY_INFO:
+		req->FileInformationClass = FILE_DIRECTORY_INFORMATION;
+		info_buf_size = sizeof(FILE_DIRECTORY_INFO) - 1;
+		break;
+	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
+		req->FileInformationClass = FILEID_FULL_DIRECTORY_INFORMATION;
+		info_buf_size = sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
+		break;
+	default:
+		cERROR(1, "info level %u isn't supported",
+		       srch_inf->info_level);
+		rc = -EINVAL;
+		goto qdir_exit;
+	}
+
+	req->FileIndex = cpu_to_le32(index);
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
+
+	len = 0x2;
+	bufptr = req->Buffer;
+	memcpy(bufptr, &asteriks, len);
+
+	req->FileNameOffset =
+		cpu_to_le16(sizeof(struct smb2_query_directory_req) - 1 - 4);
+	req->FileNameLength = cpu_to_le16(len);
+	/*
+	 * BB could be 30 bytes or so longer if we used SMB2 specific
+	 * buffer lengths, but this is safe and close enough.
+	 */
+	output_size = min_t(unsigned int, output_size, server->maxBuf);
+	output_size = min_t(unsigned int, output_size, 2 << 15);
+	req->OutputBufferLength = cpu_to_le32(output_size);
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for RFC1001 length and 1 for Buffer */
+	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+
+	iov[1].iov_base = (char *)(req->Buffer);
+	iov[1].iov_len = len;
+
+	inc_rfc1001_len(req, len - 1 /* Buffer */);
+
+	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, 0);
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
+		goto qdir_exit;
+	}
+	rsp = (struct smb2_query_directory_rsp *)iov[0].iov_base;
+
+	rc = validate_buf(le16_to_cpu(rsp->OutputBufferOffset),
+			  le32_to_cpu(rsp->OutputBufferLength), &rsp->hdr,
+			  info_buf_size);
+	if (rc)
+		goto qdir_exit;
+
+	srch_inf->unicode = true;
+
+	if (srch_inf->ntwrk_buf_start) {
+		if (srch_inf->smallBuf)
+			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
+		else
+			cifs_buf_release(srch_inf->ntwrk_buf_start);
+	}
+	srch_inf->ntwrk_buf_start = (char *)rsp;
+	srch_inf->srch_entries_start = srch_inf->last_entry = 4 /* rfclen */ +
+		(char *)&rsp->hdr + le16_to_cpu(rsp->OutputBufferOffset);
+	/* 4 for rfc1002 length field */
+	end_of_smb = get_rfc1002_length(rsp) + 4 + (char *)&rsp->hdr;
+	srch_inf->entries_in_buffer =
+			num_entries(srch_inf->srch_entries_start, end_of_smb,
+				    &srch_inf->last_entry, info_buf_size);
+	srch_inf->index_of_last_entry += srch_inf->entries_in_buffer;
+	cFYI(1, "num entries %d last_index %lld srch start %p srch end %p",
+		srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
+		srch_inf->srch_entries_start, srch_inf->last_entry);
+	if (resp_buftype == CIFS_LARGE_BUFFER)
+		srch_inf->smallBuf = false;
+	else if (resp_buftype == CIFS_SMALL_BUFFER)
+		srch_inf->smallBuf = true;
+	else
+		cERROR(1, "illegal search buffer type");
+
+	if (rsp->hdr.Status == STATUS_NO_MORE_FILES)
+		srch_inf->endOfSearch = 1;
+	else
+		srch_inf->endOfSearch = 0;
+
+	return rc;
+
+qdir_exit:
+	free_rsp_buf(resp_buftype, rsp);
+	return rc;
+}
+
 static int
 send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	       u64 persistent_fid, u64 volatile_fid, u32 pid, int info_class,
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 45ecae9..cd64385 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -536,6 +536,34 @@ struct smb2_echo_rsp {
 	__u16  Reserved;
 } __packed;
 
+/* search (query_directory) Flags field */
+#define SMB2_RESTART_SCANS		0x01
+#define SMB2_RETURN_SINGLE_ENTRY	0x02
+#define SMB2_INDEX_SPECIFIED		0x04
+#define SMB2_REOPEN			0x10
+
+struct smb2_query_directory_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 33 */
+	__u8   FileInformationClass;
+	__u8   Flags;
+	__le32 FileIndex;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__le16 FileNameOffset;
+	__le16 FileNameLength;
+	__le32 OutputBufferLength;
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_query_directory_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 9 */
+	__le16 OutputBufferOffset;
+	__le32 OutputBufferLength;
+	__u8   Buffer[1];
+} __packed;
+
 /* Possible InfoType values */
 #define SMB2_O_INFO_FILE	0x01
 #define SMB2_O_INFO_FILESYSTEM	0x02
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 2774724..0d29db2 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -34,7 +34,7 @@ struct statfs;
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
 extern int smb2_check_message(char *buf, unsigned int length);
-extern unsigned int smb2_calc_size(struct smb2_hdr *hdr);
+extern unsigned int smb2_calc_size(void *buf);
 extern char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,
 					  struct cifs_sb_info *cifs_sb);
@@ -117,6 +117,9 @@ extern int smb2_async_writev(struct cifs_writedata *wdata);
 extern int SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec);
 extern int SMB2_echo(struct TCP_Server_Info *server);
+extern int SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
+				u64 persistent_fid, u64 volatile_fid, int index,
+				struct cifs_search_info *srch_inf);
 extern int SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 		       u64 persistent_fid, u64 volatile_fid,
 		       __le16 *target_file);
-- 
1.7.1
