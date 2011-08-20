From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: untangle server->maxBuf and CIFSMaxBufSize
Date: Fri, 19 Aug 2011 21:21:48 -0400
Message-ID: <1313803308-32276-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

server->maxBuf is the maximum SMB size (including header) that the
server can handle. CIFSMaxBufSize is the maximum amount of data (sans
header) that the client can handle. Currently maxBuf is being capped at
CIFSMaxBufSize + the max headers size, and the two values are used
somewhat interchangeably in the code.

This makes little sense as these two values are not related at all.
Separate them and make sure the code uses the right values in the right
places.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |   33 ++++++++++-----------------------
 fs/cifs/connect.c |   11 +++++------
 fs/cifs/file.c    |    2 +-
 fs/cifs/sess.c    |    4 +++-
 4 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 7bac906..5a2f2bc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -458,8 +458,8 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		   (otherwise oplock break e.g. would fail) */
 		if (server->maxReq < 2)
 			server->maxReq = CIFS_MAX_REQ; /* 50 */
-		server->maxBuf = min((__u32)le16_to_cpu(rsp->MaxBufSize),
-				(__u32)CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
+
+		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
 		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
 		/* even though we do not use raw we might as well set this
 		accurately, in case we ever find a need for it */
@@ -571,8 +571,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 	if (server->maxReq < 2)
 		server->maxReq = CIFS_MAX_REQ; /* 50 */
 	/* probably no need to store and check maxvcs */
-	server->maxBuf = min(le32_to_cpu(pSMBr->MaxBufferSize),
-			(__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
+	server->maxBuf = le32_to_cpu(pSMBr->MaxBufferSize);
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
 	cFYI(DBG2, "Max buf = %d", ses->server->maxBuf);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
@@ -2822,8 +2821,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifs_tcon *tcon,
 	pSMB->TotalDataCount = 0;
 	pSMB->MaxParameterCount = cpu_to_le32(2);
 	/* BB find exact data count max from sess structure BB */
-	pSMB->MaxDataCount = cpu_to_le32((tcon->ses->server->maxBuf -
-					  MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
+	pSMB->MaxDataCount = cpu_to_le32(CIFSMaxBufSize & 0xFFFFFF00);
 	pSMB->MaxSetupCount = 4;
 	pSMB->Reserved = 0;
 	pSMB->ParameterOffset = 0;
@@ -3316,8 +3314,7 @@ smb_init_nttransact(const __u16 sub_command, const int setup_count,
 	pSMB->Reserved = 0;
 	pSMB->TotalParameterCount = cpu_to_le32(parm_len);
 	pSMB->TotalDataCount  = 0;
-	pSMB->MaxDataCount = cpu_to_le32((tcon->ses->server->maxBuf -
-					  MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
+	pSMB->MaxDataCount = cpu_to_le32(CIFSMaxBufSize & 0xFFFFFF00);
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
 	pSMB->DataCount  = pSMB->TotalDataCount;
 	temp_offset = offsetof(struct smb_com_ntransact_req, Parms) +
@@ -3987,8 +3984,7 @@ findFirstRetry:
 	params = 12 + name_len /* includes null */ ;
 	pSMB->TotalDataCount = 0;	/* no EAs */
 	pSMB->MaxParameterCount = cpu_to_le16(10);
-	pSMB->MaxDataCount = cpu_to_le16((tcon->ses->server->maxBuf -
-					  MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
+	pSMB->MaxDataCount = cpu_to_le16(CIFSMaxBufSize & 0xFFFFFF00);
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -4062,8 +4058,7 @@ findFirstRetry:
 			psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
 				psrch_inf->entries_in_buffer;
 			lnoff = le16_to_cpu(parms->LastNameOffset);
-			if (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE <
-			      lnoff) {
+			if (CIFSMaxBufSize < lnoff) {
 				cERROR(1, "ignoring corrupt resume name");
 				psrch_inf->last_entry = NULL;
 				return rc;
@@ -4106,9 +4101,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
 	byte_count = 0;
 	pSMB->TotalDataCount = 0;       /* no EAs */
 	pSMB->MaxParameterCount = cpu_to_le16(8);
-	pSMB->MaxDataCount =
-		cpu_to_le16((tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE) &
-				0xFFFFFF00);
+	pSMB->MaxDataCount = cpu_to_le16(CIFSMaxBufSize & 0xFFFFFF00);
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -4190,8 +4183,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
 			psrch_inf->index_of_last_entry +=
 				psrch_inf->entries_in_buffer;
 			lnoff = le16_to_cpu(parms->LastNameOffset);
-			if (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE <
-			      lnoff) {
+			if (CIFSMaxBufSize < lnoff) {
 				cERROR(1, "ignoring corrupt resume name");
 				psrch_inf->last_entry = NULL;
 				return rc;
@@ -6044,12 +6036,7 @@ int CIFSSMBNotify(const int xid, struct cifs_tcon *tcon,
 	pSMB->TotalParameterCount = 0 ;
 	pSMB->TotalDataCount = 0;
 	pSMB->MaxParameterCount = cpu_to_le32(2);
-	/* BB find exact data count max from sess structure BB */
-	pSMB->MaxDataCount = 0; /* same in little endian or be */
-/* BB VERIFY verify which is correct for above BB */
-	pSMB->MaxDataCount = cpu_to_le32((tcon->ses->server->maxBuf -
-					     MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
-
+	pSMB->MaxDataCount = cpu_to_le32(CIFSMaxBufSize & 0xFFFFFF00);
 	pSMB->MaxSetupCount = 4;
 	pSMB->Reserved = 0;
 	pSMB->ParameterOffset = 0;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 633c246..0ffba09 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -181,7 +181,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		-EINVAL = invalid transact2
 
  */
-static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSize)
+static int check2ndT2(struct smb_hdr *pSMB)
 {
 	struct smb_t2_rsp *pSMBt;
 	int remaining;
@@ -214,9 +214,9 @@ static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSize)
 
 	cFYI(1, "missing %d bytes from transact2, check next response",
 		remaining);
-	if (total_data_size > maxBufSize) {
+	if (total_data_size > CIFSMaxBufSize) {
 		cERROR(1, "TotalDataSize %d is over maximum buffer %d",
-			total_data_size, maxBufSize);
+			total_data_size, CIFSMaxBufSize);
 		return -EINVAL;
 	}
 	return remaining;
@@ -486,7 +486,7 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 		    mid->command != buf->Command)
 			continue;
 
-		if (*length == 0 && check2ndT2(buf, server->maxBuf) > 0) {
+		if (*length == 0 && check2ndT2(buf) > 0) {
 			/* We have a multipart transact2 resp */
 			*is_multi_rsp = true;
 			if (mid->resp_buf) {
@@ -3130,8 +3130,7 @@ try_mount_again:
 		cFYI(DBG2, "no very large read support, rsize now 127K");
 	}
 	if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
-		cifs_sb->rsize = min(cifs_sb->rsize,
-			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
+		cifs_sb->rsize = min(cifs_sb->rsize, CIFSMaxBufSize);
 
 	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9f41a10..fd57165 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1868,7 +1868,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		if ((pTcon->ses) &&
 			!(pTcon->ses->capabilities & CAP_LARGE_FILES)) {
 			current_read_size = min_t(const int, current_read_size,
-					pTcon->ses->server->maxBuf - 128);
+					CIFSMaxBufSize);
 		}
 		rc = -EAGAIN;
 		while (rc == -EAGAIN) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d3e6196..c7d80e2 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -124,7 +124,9 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
 	/*	that we use in next few lines                               */
 	/* Note that header is initialized to zero in header_assemble */
 	pSMB->req.AndXCommand = 0xFF;
-	pSMB->req.MaxBufferSize = cpu_to_le16(ses->server->maxBuf);
+	pSMB->req.MaxBufferSize = cpu_to_le16(min_t(u32,
+					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4,
+					USHRT_MAX));
 	pSMB->req.MaxMpxCount = cpu_to_le16(ses->server->maxReq);
 	pSMB->req.VcNumber = get_next_vcnum(ses);
 
-- 
1.7.6
