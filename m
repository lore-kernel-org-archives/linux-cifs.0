From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: remove rfc1002 header from all SMB2 response structures
Date: Wed,  3 Jan 2018 09:35:23 +1100
Message-ID: <20180102223524.8389-2-lsahlber@redhat.com>
References: <20180102223524.8389-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102223524.8389-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Separate out all the 4 byte rfc1002 headers so that they are no longer
part of the SMB2 header structures to prepare for future work to add
compounding support.

When using compounding, the wire format will consist of a single
rfc1002 length header followed by one, or more, SMB2 headers, like this :

* 4 byte rfc1002 length
* SMB2 header
* SMB2 header
* ...

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h      |   2 +
 fs/cifs/cifssmb.c       |   9 ++-
 fs/cifs/connect.c       |  28 ++++++---
 fs/cifs/misc.c          |   2 +-
 fs/cifs/smb1ops.c       |   1 +
 fs/cifs/smb2glob.h      |   5 --
 fs/cifs/smb2maperror.c  |   8 ++-
 fs/cifs/smb2misc.c      | 110 +++++++++++++++++----------------
 fs/cifs/smb2ops.c       | 159 ++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2pdu.c       | 105 +++++++++++++++-----------------
 fs/cifs/smb2pdu.h       |  65 ++++++--------------
 fs/cifs/smb2proto.h     |   5 +-
 fs/cifs/smb2transport.c |   6 +-
 fs/cifs/transport.c     |   4 +-
 14 files changed, 268 insertions(+), 241 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3fb1a2fe1ea9..14db722c4b0d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -460,6 +460,7 @@ struct smb_version_values {
 	__u32		exclusive_lock_type;
 	__u32		shared_lock_type;
 	__u32		unlock_lock_type;
+	size_t		header_preamble_size;
 	size_t		header_size;
 	size_t		max_header_size;
 	size_t		read_rsp_size;
@@ -656,6 +657,7 @@ struct TCP_Server_Info {
 	struct delayed_work	echo; /* echo ping workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
+	unsigned int total_size; /* Total size of this PDU */
 	unsigned int total_read; /* total amount of data read in this pass */
 #ifdef CONFIG_CIFS_FSCACHE
 	struct fscache_cookie   *fscache; /* client index cache cookie */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 35dc5bf01ee2..114e2a7ca77f 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1453,7 +1453,9 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	unsigned int data_offset, data_len;
 	struct cifs_readdata *rdata = mid->callback_data;
 	char *buf = server->smallbuf;
-	unsigned int buflen = get_rfc1002_length(buf) + 4;
+	unsigned int buflen;
+
+	buflen = server->total_size + server->vals->header_preamble_size;
 
 	cifs_dbg(FYI, "%s: mid=%llu offset=%llu bytes=%u\n",
 		 __func__, mid->mid, rdata->offset, rdata->bytes);
@@ -1464,7 +1466,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * the Mid.
 	 */
 	len = min_t(unsigned int, buflen, server->vals->read_rsp_size) -
-							HEADER_SIZE(server) + 1;
+		HEADER_SIZE(server) + 1;
 
 	length = cifs_read_from_socket(server,
 				       buf + HEADER_SIZE(server) - 1, len);
@@ -1502,7 +1504,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return cifs_readv_discard(server, mid);
 	}
 
-	data_offset = server->ops->read_data_offset(buf) + 4;
+	data_offset = server->ops->read_data_offset(buf) +
+		server->vals->header_preamble_size;
 	if (data_offset < server->total_read) {
 		/*
 		 * win2k8 sometimes sends an offset of 0 when the read
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 64be6f9e54a2..23d69657ca06 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -763,10 +763,11 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length;
 	char *buf = server->smallbuf;
-	unsigned int pdu_length = get_rfc1002_length(buf);
+	unsigned int pdu_length = server->total_size;
 
 	/* make sure this will fit in a large buffer */
-	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server) - 4) {
+	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server) -
+		server->vals->header_preamble_size) {
 		cifs_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
@@ -781,8 +782,11 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* now read the rest */
-	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
-				pdu_length - HEADER_SIZE(server) + 1 + 4);
+	length = cifs_read_from_socket(server,
+				       buf + HEADER_SIZE(server) - 1,
+				       pdu_length - HEADER_SIZE(server) + 1
+				       + server->vals->header_preamble_size);
+
 	if (length < 0)
 		return length;
 	server->total_read += length;
@@ -862,20 +866,26 @@ cifs_demultiplex_thread(void *p)
 		length = cifs_read_from_socket(server, buf, pdu_length);
 		if (length < 0)
 			continue;
-		server->total_read = length;
+
+		if (server->vals->header_preamble_size == 0)
+			server->total_read = 0;
+		else
+			server->total_read = length;
 
 		/*
 		 * The right amount was read from socket - 4 bytes,
 		 * so we can now interpret the length field.
 		 */
 		pdu_length = get_rfc1002_length(buf);
+		server->total_size = pdu_length;
 
 		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
 			continue;
 
 		/* make sure we have enough to get to the MID */
-		if (pdu_length < HEADER_SIZE(server) - 1 - 4) {
+		if (pdu_length < HEADER_SIZE(server) - 1 -
+		    server->vals->header_preamble_size) {
 			cifs_dbg(VFS, "SMB response too short (%u bytes)\n",
 				 pdu_length);
 			cifs_reconnect(server);
@@ -884,8 +894,10 @@ cifs_demultiplex_thread(void *p)
 		}
 
 		/* read down to the MID */
-		length = cifs_read_from_socket(server, buf + 4,
-					       HEADER_SIZE(server) - 1 - 4);
+		length = cifs_read_from_socket(server,
+			     buf + server->vals->header_preamble_size,
+			     HEADER_SIZE(server) - 1
+			     - server->vals->header_preamble_size);
 		if (length < 0)
 			continue;
 		server->total_read += length;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index eea93ac15ef0..37022a34982b 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -151,7 +151,7 @@ cifs_buf_get(void)
 	 * SMB2 header is bigger than CIFS one - no problems to clean some
 	 * more bytes for CIFS.
 	 */
-	size_t buf_size = sizeof(struct smb2_hdr);
+	size_t buf_size = sizeof(struct smb2_sync_hdr);
 
 	/*
 	 * We could use negotiated size instead of max_msgsize -
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index a723df3e0197..4c87265050fc 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1120,6 +1120,7 @@ struct smb_version_values smb1_values = {
 	.exclusive_lock_type = 0,
 	.shared_lock_type = LOCKING_ANDX_SHARED_LOCK,
 	.unlock_lock_type = 0,
+	.header_preamble_size = 4,
 	.header_size = sizeof(struct smb_hdr),
 	.max_header_size = MAX_CIFS_HDR_SIZE,
 	.read_rsp_size = sizeof(READ_RSP),
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 401a5d856636..0ffa18094335 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -61,9 +61,4 @@
 /* Maximum buffer size value we can send with 1 credit */
 #define SMB2_MAX_BUFFER_SIZE 65536
 
-static inline struct smb2_sync_hdr *get_sync_hdr(void *buf)
-{
-	return &(((struct smb2_hdr *)buf)->sync_hdr);
-}
-
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 62c88dfed57b..8484058346cd 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -2450,10 +2450,14 @@ smb2_print_status(__le32 status)
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
-	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	struct smb2_sync_hdr *shdr;
 	unsigned int i;
 	int rc = -EIO;
-	__le32 smb2err = shdr->Status;
+	__le32 smb2err;
+
+	shdr = (struct smb2_sync_hdr *)buf;
+
+	smb2err = shdr->Status;
 
 	if (smb2err == 0)
 		return 0;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 76d03abaa38c..339c32a10936 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -96,17 +96,18 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 int
 smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 {
-	struct smb2_pdu *pdu = (struct smb2_pdu *)buf;
-	struct smb2_hdr *hdr = &pdu->hdr;
-	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	struct smb2_sync_pdu *pdu;
+	struct smb2_sync_hdr *shdr;
 	__u64 mid;
-	__u32 len = get_rfc1002_length(buf);
 	__u32 clc_len;  /* calculated length */
 	int command;
+	int pdu_size;
+	int hdr_size;
 
-	/* BB disable following printk later */
-	cifs_dbg(FYI, "%s length: 0x%x, smb_buf_length: 0x%x\n",
-		 __func__, length, len);
+	shdr = (struct smb2_sync_hdr *)buf;
+	pdu_size = sizeof(struct smb2_sync_pdu);
+	hdr_size = sizeof(struct smb2_sync_hdr);
+	pdu = (struct smb2_sync_pdu *)shdr;
 
 	/*
 	 * Add function to do table lookup of StructureSize by command
@@ -136,8 +137,8 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 	}
 
 	mid = le64_to_cpu(shdr->MessageId);
-	if (length < sizeof(struct smb2_pdu)) {
-		if ((length >= sizeof(struct smb2_hdr))
+	if (length < pdu_size) {
+		if ((length >= hdr_size)
 		    && (shdr->Status != 0)) {
 			pdu->StructureSize2 = 0;
 			/*
@@ -150,7 +151,7 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 		}
 		return 1;
 	}
-	if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
+	if (length > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
 		cifs_dbg(VFS, "SMB length greater than maximum, mid=%llu\n",
 			 mid);
 		return 1;
@@ -189,26 +190,20 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 		}
 	}
 
-	if (4 + len != length) {
-		cifs_dbg(VFS, "Total length %u RFC1002 length %u mismatch mid %llu\n",
-			 length, 4 + len, mid);
-		return 1;
-	}
+	clc_len = smb2_calc_size(buf);
 
-	clc_len = smb2_calc_size(hdr);
-
-	if (4 + len != clc_len) {
+	if (length != clc_len) {
 		cifs_dbg(FYI, "Calculated size %u length %u mismatch mid %llu\n",
-			 clc_len, 4 + len, mid);
+			 clc_len, length, mid);
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
 		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
-		if (clc_len + 20 == len && command == SMB2_OPLOCK_BREAK_HE)
+		if (clc_len + 24 == length && command == SMB2_OPLOCK_BREAK_HE)
 			return 0;
 		/* server can return one byte more due to implied bcc[0] */
-		if (clc_len == 4 + len + 1)
+		if (clc_len == length + 1)
 			return 0;
 
 		/*
@@ -218,10 +213,10 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 		 * Log the server error (once), but allow it and continue
 		 * since the frame is parseable.
 		 */
-		if (clc_len < 4 /* RFC1001 header size */ + len) {
+		if (clc_len < length) {
 			printk_once(KERN_WARNING
 				"SMB2 server sent bad RFC1001 len %d not %d\n",
-				len, clc_len - 4);
+				length, clc_len);
 			return 0;
 		}
 
@@ -262,15 +257,14 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
  * area and the offset to it (from the beginning of the smb are also returned.
  */
 char *
-smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
+smb2_get_data_area_len(int *off, int *len, struct smb2_sync_hdr *shdr)
 {
-	struct smb2_sync_hdr *shdr = get_sync_hdr(hdr);
 	*off = 0;
 	*len = 0;
 
 	/* error responses do not have data area */
 	if (shdr->Status && shdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
-	    (((struct smb2_err_rsp *)hdr)->StructureSize) ==
+	    (((struct smb2_err_rsp *)shdr)->StructureSize) ==
 						SMB2_ERROR_STRUCTURE_SIZE2)
 		return NULL;
 
@@ -282,42 +276,44 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	switch (shdr->Command) {
 	case SMB2_NEGOTIATE:
 		*off = le16_to_cpu(
-		    ((struct smb2_negotiate_rsp *)hdr)->SecurityBufferOffset);
+		    ((struct smb2_negotiate_rsp *)shdr)->SecurityBufferOffset);
 		*len = le16_to_cpu(
-		    ((struct smb2_negotiate_rsp *)hdr)->SecurityBufferLength);
+		    ((struct smb2_negotiate_rsp *)shdr)->SecurityBufferLength);
 		break;
 	case SMB2_SESSION_SETUP:
 		*off = le16_to_cpu(
-		    ((struct smb2_sess_setup_rsp *)hdr)->SecurityBufferOffset);
+		  ((struct smb2_sess_setup_rsp *)shdr)->SecurityBufferOffset);
 		*len = le16_to_cpu(
-		    ((struct smb2_sess_setup_rsp *)hdr)->SecurityBufferLength);
+		  ((struct smb2_sess_setup_rsp *)shdr)->SecurityBufferLength);
 		break;
 	case SMB2_CREATE:
 		*off = le32_to_cpu(
-		    ((struct smb2_create_rsp *)hdr)->CreateContextsOffset);
+		    ((struct smb2_create_rsp *)shdr)->CreateContextsOffset);
 		*len = le32_to_cpu(
-		    ((struct smb2_create_rsp *)hdr)->CreateContextsLength);
+		    ((struct smb2_create_rsp *)shdr)->CreateContextsLength);
 		break;
 	case SMB2_QUERY_INFO:
 		*off = le16_to_cpu(
-		    ((struct smb2_query_info_rsp *)hdr)->OutputBufferOffset);
+		    ((struct smb2_query_info_rsp *)shdr)->OutputBufferOffset);
 		*len = le32_to_cpu(
-		    ((struct smb2_query_info_rsp *)hdr)->OutputBufferLength);
+		    ((struct smb2_query_info_rsp *)shdr)->OutputBufferLength);
 		break;
 	case SMB2_READ:
-		*off = ((struct smb2_read_rsp *)hdr)->DataOffset;
-		*len = le32_to_cpu(((struct smb2_read_rsp *)hdr)->DataLength);
+		/* TODO: is this a bug ? */
+		*off = ((struct smb2_read_rsp *)shdr)->DataOffset;
+		*len = le32_to_cpu(((struct smb2_read_rsp *)shdr)->DataLength);
 		break;
 	case SMB2_QUERY_DIRECTORY:
 		*off = le16_to_cpu(
-		  ((struct smb2_query_directory_rsp *)hdr)->OutputBufferOffset);
+		  ((struct smb2_query_directory_rsp *)shdr)->OutputBufferOffset);
 		*len = le32_to_cpu(
-		  ((struct smb2_query_directory_rsp *)hdr)->OutputBufferLength);
+		  ((struct smb2_query_directory_rsp *)shdr)->OutputBufferLength);
 		break;
 	case SMB2_IOCTL:
 		*off = le32_to_cpu(
-		  ((struct smb2_ioctl_rsp *)hdr)->OutputOffset);
-		*len = le32_to_cpu(((struct smb2_ioctl_rsp *)hdr)->OutputCount);
+		  ((struct smb2_ioctl_rsp *)shdr)->OutputOffset);
+		*len = le32_to_cpu(
+		  ((struct smb2_ioctl_rsp *)shdr)->OutputCount);
 		break;
 	case SMB2_CHANGE_NOTIFY:
 	default:
@@ -362,13 +358,16 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 unsigned int
 smb2_calc_size(void *buf)
 {
-	struct smb2_pdu *pdu = (struct smb2_pdu *)buf;
-	struct smb2_hdr *hdr = &pdu->hdr;
-	struct smb2_sync_hdr *shdr = get_sync_hdr(hdr);
+	struct smb2_sync_pdu *pdu;
+	struct smb2_sync_hdr *shdr;
 	int offset; /* the offset from the beginning of SMB to data area */
 	int data_length; /* the length of the variable length data area */
 	/* Structure Size has already been checked to make sure it is 64 */
-	int len = 4 + le16_to_cpu(shdr->StructureSize);
+	int len;
+
+	pdu = (struct smb2_sync_pdu *)buf;
+	shdr = &pdu->sync_hdr;
+	len = le16_to_cpu(shdr->StructureSize);
 
 	/*
 	 * StructureSize2, ie length of fixed parameter area has already
@@ -379,7 +378,7 @@ smb2_calc_size(void *buf)
 	if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
 		goto calc_size_exit;
 
-	smb2_get_data_area_len(&offset, &data_length, hdr);
+	smb2_get_data_area_len(&offset, &data_length, shdr);
 	cifs_dbg(FYI, "SMB2 data length %d offset %d\n", data_length, offset);
 
 	if (data_length > 0) {
@@ -387,15 +386,14 @@ smb2_calc_size(void *buf)
 		 * Check to make sure that data area begins after fixed area,
 		 * Note that last byte of the fixed area is part of data area
 		 * for some commands, typically those with odd StructureSize,
-		 * so we must add one to the calculation (and 4 to account for
-		 * the size of the RFC1001 hdr.
+		 * so we must add one to the calculation.
 		 */
-		if (offset + 4 + 1 < len) {
+		if (offset + 1 < len) {
 			cifs_dbg(VFS, "data area offset %d overlaps SMB2 header %d\n",
-				 offset + 4 + 1, len);
+				 offset + 1, len);
 			data_length = 0;
 		} else {
-			len = 4 + offset + data_length;
+			len = offset + data_length;
 		}
 	}
 calc_size_exit:
@@ -578,7 +576,7 @@ smb2_is_valid_lease_break(char *buffer)
 bool
 smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 {
-	struct smb2_oplock_break_rsp *rsp = (struct smb2_oplock_break_rsp *)buffer;
+	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
 	struct list_head *tmp, *tmp1, *tmp2;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -587,7 +585,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "Checking for oplock break\n");
 
-	if (rsp->hdr.sync_hdr.Command != SMB2_OPLOCK_BREAK)
+	if (rsp->sync_hdr.Command != SMB2_OPLOCK_BREAK)
 		return false;
 
 	if (rsp->StructureSize !=
@@ -678,11 +676,15 @@ smb2_cancelled_close_fid(struct work_struct *work)
 int
 smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *sync_hdr = get_sync_hdr(buffer);
-	struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
+	struct smb2_sync_hdr *sync_hdr;
+	struct smb2_create_rsp *rsp;
 	struct cifs_tcon *tcon;
 	struct close_cancelled_open *cancelled;
 
+	sync_hdr = (struct smb2_sync_hdr *)buffer;
+
+	rsp = (struct smb2_create_rsp *)sync_hdr;
+
 	if (sync_hdr->Command != SMB2_CREATE ||
 	    sync_hdr->Status != STATUS_SUCCESS)
 		return 0;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ed88ab8a4774..590c5e4b7b1d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -122,7 +122,14 @@ smb2_get_credits_field(struct TCP_Server_Info *server, const int optype)
 static unsigned int
 smb2_get_credits(struct mid_q_entry *mid)
 {
-	struct smb2_sync_hdr *shdr = get_sync_hdr(mid->resp_buf);
+	char *buf = mid->resp_buf;
+	struct smb2_sync_hdr *shdr;
+
+	if ( *(__u32 *)buf == SMB2_PROTO_NUMBER ||
+	     *(__u32 *)buf == SMB2_TRANSFORM_PROTO_NUM)
+		shdr = (struct smb2_sync_hdr *)buf;
+	else
+		shdr = (struct smb2_sync_hdr *)(buf + 4);
 
 	return le16_to_cpu(shdr->CreditRequest);
 }
@@ -189,8 +196,12 @@ static struct mid_q_entry *
 smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 {
 	struct mid_q_entry *mid;
-	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
-	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
+	struct smb2_sync_hdr *shdr;
+	__u64 wire_mid;
+
+	shdr = (struct smb2_sync_hdr *)buf;
+
+	wire_mid = le64_to_cpu(shdr->MessageId);
 
 	if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
 		cifs_dbg(VFS, "encrypted frame parsing not supported yet");
@@ -214,7 +225,9 @@ static void
 smb2_dump_detail(void *buf)
 {
 #ifdef CONFIG_CIFS_DEBUG2
-	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	struct smb2_sync_hdr *shdr;
+	
+	shdr = (struct smb2_sync_hdr *)buf;
 
 	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
@@ -1230,7 +1243,9 @@ smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 static bool
 smb2_is_status_pending(char *buf, struct TCP_Server_Info *server, int length)
 {
-	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	struct smb2_sync_hdr *shdr;
+
+	shdr = (struct smb2_sync_hdr *)buf;
 
 	if (shdr->Status != STATUS_PENDING)
 		return false;
@@ -1248,7 +1263,9 @@ smb2_is_status_pending(char *buf, struct TCP_Server_Info *server, int length)
 static bool
 smb2_is_session_expired(char *buf)
 {
-	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	struct smb2_sync_hdr *shdr;
+
+	shdr = (struct smb2_sync_hdr *)buf;
 
 	if (shdr->Status != STATUS_NETWORK_SESSION_EXPIRED)
 		return false;
@@ -1444,6 +1461,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
+	struct kvec err_iov = {NULL, 0};
 	struct smb2_err_rsp *err_buf = NULL;
 	struct smb2_symlink_err_rsp *symlink;
 	unsigned int sub_len;
@@ -1464,15 +1482,16 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, &err_buf);
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, &err_iov);
 
 	if (!rc || !err_buf) {
 		kfree(utf16_path);
 		return -ENOENT;
 	}
 
+	err_buf = err_iov.iov_base;
 	if (le32_to_cpu(err_buf->ByteCount) < sizeof(struct smb2_symlink_err_rsp) ||
-	    get_rfc1002_length(err_buf) + 4 < SMB2_SYMLINK_STRUCT_SIZE) {
+	    err_iov.iov_len < SMB2_SYMLINK_STRUCT_SIZE) {
 		kfree(utf16_path);
 		return -ENOENT;
 	}
@@ -1485,13 +1504,13 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	print_len = le16_to_cpu(symlink->PrintNameLength);
 	print_offset = le16_to_cpu(symlink->PrintNameOffset);
 
-	if (get_rfc1002_length(err_buf) + 4 <
+	if (err_iov.iov_len <
 			SMB2_SYMLINK_STRUCT_SIZE + sub_offset + sub_len) {
 		kfree(utf16_path);
 		return -ENOENT;
 	}
 
-	if (get_rfc1002_length(err_buf) + 4 <
+	if (err_iov.iov_len <
 			SMB2_SYMLINK_STRUCT_SIZE + print_offset + print_len) {
 		kfree(utf16_path);
 		return -ENOENT;
@@ -2048,7 +2067,7 @@ static void
 fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, struct smb_rqst *old_rq)
 {
 	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)old_rq->rq_iov[1].iov_base;
+			(struct smb2_sync_hdr *)old_rq->rq_iov[2].iov_base;
 	unsigned int orig_len = get_rfc1002_length(old_rq->rq_iov[0].iov_base);
 
 	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
@@ -2057,15 +2076,13 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, struct smb_rqst *old_rq)
 	tr_hdr->Flags = cpu_to_le16(0x01);
 	get_random_bytes(&tr_hdr->Nonce, SMB3_AES128CMM_NONCE);
 	memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
-	inc_rfc1001_len(tr_hdr, sizeof(struct smb2_transform_hdr) - 4);
-	inc_rfc1001_len(tr_hdr, orig_len);
 }
 
 static struct scatterlist *
 init_sg(struct smb_rqst *rqst, u8 *sign)
 {
 	unsigned int sg_len = rqst->rq_nvec + rqst->rq_npages + 1;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	struct scatterlist *sg;
 	unsigned int i;
 	unsigned int j;
@@ -2075,10 +2092,10 @@ init_sg(struct smb_rqst *rqst, u8 *sign)
 		return NULL;
 
 	sg_init_table(sg, sg_len);
-	sg_set_buf(&sg[0], rqst->rq_iov[0].iov_base + 24, assoc_data_len);
+	sg_set_buf(&sg[0], rqst->rq_iov[1].iov_base + 20, assoc_data_len);
 	for (i = 1; i < rqst->rq_nvec; i++)
-		sg_set_buf(&sg[i], rqst->rq_iov[i].iov_base,
-						rqst->rq_iov[i].iov_len);
+		sg_set_buf(&sg[i], rqst->rq_iov[i+1].iov_base,
+						rqst->rq_iov[i+1].iov_len);
 	for (j = 0; i < sg_len - 1; i++, j++) {
 		unsigned int len = (j < rqst->rq_npages - 1) ? rqst->rq_pagesz
 							: rqst->rq_tailsz;
@@ -2110,17 +2127,18 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 }
 /*
  * Encrypt or decrypt @rqst message. @rqst has the following format:
- * iov[0] - transform header (associate data),
- * iov[1-N] and pages - data to encrypt.
- * On success return encrypted data in iov[1-N] and pages, leave iov[0]
+ * iov[0] - rfc1002 length
+ * iov[1] - transform header (associate data),
+ * iov[2-N] and pages - data to encrypt.
+ * On success return encrypted data in iov[2-N] and pages, leave iov[0-1]
  * untouched.
  */
 static int
 crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 {
 	struct smb2_transform_hdr *tr_hdr =
-			(struct smb2_transform_hdr *)rqst->rq_iov[0].iov_base;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
+			(struct smb2_transform_hdr *)rqst->rq_iov[1].iov_base;
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc = 0;
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
@@ -2207,6 +2225,9 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 	return rc;
 }
 
+/* This is called from smb_send_rqst. At this point we have the rfc1002
+ * header as the first element in the vector.
+ */
 static int
 smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 		       struct smb_rqst *old_rq)
@@ -2233,24 +2254,32 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 			goto err_free_pages;
 	}
 
-	iov = kmalloc_array(old_rq->rq_nvec, sizeof(struct kvec), GFP_KERNEL);
+	/* Make space for one extra iov to hold the transform header */
+	iov = kmalloc_array(old_rq->rq_nvec + 1, sizeof(struct kvec),
+			    GFP_KERNEL);
 	if (!iov)
 		goto err_free_pages;
 
 	/* copy all iovs from the old except the 1st one (rfc1002 length) */
-	memcpy(&iov[1], &old_rq->rq_iov[1],
+	memcpy(&iov[2], &old_rq->rq_iov[1],
 				sizeof(struct kvec) * (old_rq->rq_nvec - 1));
+	/* copy the rfc1002 iov */
+	memcpy(iov[0].iov_base, old_rq->rq_iov[0].iov_base,
+	       old_rq->rq_iov[0].iov_len);
+
 	new_rq->rq_iov = iov;
-	new_rq->rq_nvec = old_rq->rq_nvec;
+	new_rq->rq_nvec = old_rq->rq_nvec + 1;
 
 	tr_hdr = kmalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
 	if (!tr_hdr)
 		goto err_free_iov;
 
-	/* fill the 1st iov with a transform header */
+	/* fill the 2nd iov with a transform header */
 	fill_transform_hdr(tr_hdr, old_rq);
-	new_rq->rq_iov[0].iov_base = tr_hdr;
-	new_rq->rq_iov[0].iov_len = sizeof(struct smb2_transform_hdr);
+	inc_rfc1001_len(new_rq->rq_iov[0].iov_base,
+			sizeof(struct smb2_transform_hdr));
+	new_rq->rq_iov[1].iov_base = tr_hdr;
+	new_rq->rq_iov[1].iov_len = sizeof(struct smb2_transform_hdr);
 
 	/* copy pages form the old */
 	for (i = 0; i < npages; i++) {
@@ -2307,18 +2336,19 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		 unsigned int buf_data_size, struct page **pages,
 		 unsigned int npages, unsigned int page_data_size)
 {
-	struct kvec iov[2];
+	struct kvec iov[3];
 	struct smb_rqst rqst = {NULL};
-	struct smb2_hdr *hdr;
 	int rc;
 
-	iov[0].iov_base = buf;
-	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
-	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
-	iov[1].iov_len = buf_data_size;
+	iov[0].iov_base = NULL;
+	iov[0].iov_len = 0;
+	iov[1].iov_base = buf;
+	iov[1].iov_len = sizeof(struct smb2_transform_hdr);
+	iov[2].iov_base = buf + sizeof(struct smb2_transform_hdr);
+	iov[2].iov_len = buf_data_size;
 
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
+	rqst.rq_nvec = 3;
 	rqst.rq_pages = pages;
 	rqst.rq_npages = npages;
 	rqst.rq_pagesz = PAGE_SIZE;
@@ -2330,10 +2360,10 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 	if (rc)
 		return rc;
 
-	memmove(buf + 4, iov[1].iov_base, buf_data_size);
-	hdr = (struct smb2_hdr *)buf;
-	hdr->smb2_buf_length = cpu_to_be32(buf_data_size + page_data_size);
-	server->total_read = buf_data_size + page_data_size + 4;
+
+	memmove(buf, iov[0].iov_base, buf_data_size);
+
+	server->total_read = buf_data_size + page_data_size;
 
 	return rc;
 }
@@ -2406,12 +2436,14 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int cur_page_idx;
 	unsigned int pad_len;
 	struct cifs_readdata *rdata = mid->callback_data;
-	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	struct smb2_sync_hdr *shdr;
 	struct bio_vec *bvec = NULL;
 	struct iov_iter iter;
 	struct kvec iov;
 	int length;
 
+	shdr = (struct smb2_sync_hdr *)buf;
+
 	if (shdr->Command != SMB2_READ) {
 		cifs_dbg(VFS, "only big read responses are supported\n");
 		return -ENOTSUPP;
@@ -2529,11 +2561,11 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid)
 	unsigned int npages;
 	struct page **pages;
 	unsigned int len;
-	unsigned int buflen = get_rfc1002_length(buf) + 4;
+	unsigned int buflen = server->total_read;
 	int rc;
 	int i = 0;
 
-	len = min_t(unsigned int, buflen, server->vals->read_rsp_size - 4 +
+	len = min_t(unsigned int, buflen, server->vals->read_rsp_size +
 		sizeof(struct smb2_transform_hdr)) - HEADER_SIZE(server) + 1;
 
 	rc = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1, len);
@@ -2541,7 +2573,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid)
 		return rc;
 	server->total_read += rc;
 
-	len = le32_to_cpu(tr_hdr->OriginalMessageSize) + 4 -
+	len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
 						server->vals->read_rsp_size;
 	npages = DIV_ROUND_UP(len, PAGE_SIZE);
 
@@ -2568,7 +2600,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid)
 	if (rc)
 		goto free_pages;
 
-	rc = decrypt_raw_data(server, buf, server->vals->read_rsp_size - 4,
+	rc = decrypt_raw_data(server, buf, server->vals->read_rsp_size,
 			      pages, npages, len);
 	if (rc)
 		goto free_pages;
@@ -2600,12 +2632,12 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 {
 	int length;
 	char *buf = server->smallbuf;
-	unsigned int pdu_length = get_rfc1002_length(buf);
+	unsigned int pdu_length = server->total_read;
 	unsigned int buf_size;
 	struct mid_q_entry *mid_entry;
 
 	/* switch to large buffer if too big for a small one */
-	if (pdu_length + 4 > MAX_CIFS_SMALL_BUFFER_SIZE) {
+	if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE) {
 		server->large_buf = true;
 		memcpy(server->bigbuf, buf, server->total_read);
 		buf = server->bigbuf;
@@ -2613,12 +2645,12 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 
 	/* now read the rest */
 	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
-				pdu_length - HEADER_SIZE(server) + 1 + 4);
+				pdu_length - HEADER_SIZE(server) + 1);
 	if (length < 0)
 		return length;
 	server->total_read += length;
 
-	buf_size = pdu_length + 4 - sizeof(struct smb2_transform_hdr);
+	buf_size = pdu_length - sizeof(struct smb2_transform_hdr);
 	length = decrypt_raw_data(server, buf, buf_size, NULL, 0, 0);
 	if (length)
 		return length;
@@ -2643,12 +2675,12 @@ static int
 smb3_receive_transform(struct TCP_Server_Info *server, struct mid_q_entry **mid)
 {
 	char *buf = server->smallbuf;
-	unsigned int pdu_length = get_rfc1002_length(buf);
+	unsigned int pdu_length = server->total_read;
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
 	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
-	if (pdu_length + 4 < sizeof(struct smb2_transform_hdr) +
-						sizeof(struct smb2_sync_hdr)) {
+	if (pdu_length < sizeof(struct smb2_transform_hdr) +
+	    sizeof(struct smb2_sync_hdr)) {
 		cifs_dbg(VFS, "Transform message is too small (%u)\n",
 			 pdu_length);
 		cifs_reconnect(server);
@@ -2656,14 +2688,14 @@ smb3_receive_transform(struct TCP_Server_Info *server, struct mid_q_entry **mid)
 		return -ECONNABORTED;
 	}
 
-	if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)) {
+	if (pdu_length < orig_len + sizeof(struct smb2_transform_hdr)) {
 		cifs_dbg(VFS, "Transform message is broken\n");
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return -ECONNABORTED;
 	}
 
-	if (pdu_length + 4 > CIFSMaxBufSize + MAX_HEADER_SIZE(server))
+	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server))
 		return receive_encrypted_read(server, mid);
 
 	return receive_encrypted_standard(server, mid);
@@ -3078,7 +3110,8 @@ struct smb_version_values smb20_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_hdr),
+	.header_preamble_size = 0,
+	.header_size = sizeof(struct smb2_sync_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
@@ -3098,7 +3131,8 @@ struct smb_version_values smb21_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_hdr),
+	.header_preamble_size = 0,
+	.header_size = sizeof(struct smb2_sync_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
@@ -3118,7 +3152,8 @@ struct smb_version_values smb3any_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_hdr),
+	.header_preamble_size = 0,
+	.header_size = sizeof(struct smb2_sync_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
@@ -3138,7 +3173,8 @@ struct smb_version_values smbdefault_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_hdr),
+	.header_preamble_size = 0,
+	.header_size = sizeof(struct smb2_sync_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
@@ -3158,7 +3194,8 @@ struct smb_version_values smb30_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_hdr),
+	.header_preamble_size = 0,
+	.header_size = sizeof(struct smb2_sync_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
@@ -3178,7 +3215,8 @@ struct smb_version_values smb302_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_hdr),
+	.header_preamble_size = 0,
+	.header_size = sizeof(struct smb2_sync_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
@@ -3199,7 +3237,8 @@ struct smb_version_values smb311_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_hdr),
+	.header_preamble_size = 0,
+	.header_size = sizeof(struct smb2_sync_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c0dc0491af93..ad178150fbf3 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -577,7 +577,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	server->capabilities |= SMB2_NT_FIND | SMB2_LARGE_FILES;
 
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
-					       &rsp->hdr);
+					       (struct smb2_sync_hdr *)rsp);
 	/*
 	 * See MS-SMB2 section 2.2.4: if no blob, client picks default which
 	 * for us will be
@@ -921,7 +921,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 		goto out_put_spnego_key;
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
-	ses->Suid = rsp->hdr.sync_hdr.SessionId;
+	ses->Suid = rsp->sync_hdr.SessionId;
 
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 
@@ -997,13 +997,13 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	/* If true, rc here is expected and not an error */
 	if (sess_data->buf0_type != CIFS_NO_BUFFER &&
-		rsp->hdr.sync_hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
+		rsp->sync_hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
 		rc = 0;
 
 	if (rc)
 		goto out;
 
-	if (offsetof(struct smb2_sess_setup_rsp, Buffer) - 4 !=
+	if (offsetof(struct smb2_sess_setup_rsp, Buffer) !=
 			le16_to_cpu(rsp->SecurityBufferOffset)) {
 		cifs_dbg(VFS, "Invalid security buffer offset %d\n",
 			le16_to_cpu(rsp->SecurityBufferOffset));
@@ -1018,7 +1018,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 	cifs_dbg(FYI, "rawntlmssp session setup challenge phase\n");
 
 
-	ses->Suid = rsp->hdr.sync_hdr.SessionId;
+	ses->Suid = rsp->sync_hdr.SessionId;
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 
 out:
@@ -1076,7 +1076,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
 
-	ses->Suid = rsp->hdr.sync_hdr.SessionId;
+	ses->Suid = rsp->sync_hdr.SessionId;
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 
 	rc = SMB2_sess_establish_session(sess_data);
@@ -1298,7 +1298,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	}
 
 	if (tcon == NULL) {
-		ses->ipc_tid = rsp->hdr.sync_hdr.TreeId;
+		ses->ipc_tid = rsp->sync_hdr.TreeId;
 		goto tcon_exit;
 	}
 
@@ -1325,7 +1325,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	tcon->maximal_access = le32_to_cpu(rsp->MaximalAccess);
 	tcon->tidStatus = CifsGood;
 	tcon->need_reconnect = false;
-	tcon->tid = rsp->hdr.sync_hdr.TreeId;
+	tcon->tid = rsp->sync_hdr.TreeId;
 	strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
@@ -1345,7 +1345,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	return rc;
 
 tcon_error_exit:
-	if (rsp && rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
+	if (rsp && rsp->sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
 		cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
 	}
 	goto tcon_exit;
@@ -1451,7 +1451,7 @@ parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp,
 	unsigned int remaining;
 	char *name;
 
-	data_offset = (char *)rsp + 4 + le32_to_cpu(rsp->CreateContextsOffset);
+	data_offset = (char *)rsp + le32_to_cpu(rsp->CreateContextsOffset);
 	remaining = le32_to_cpu(rsp->CreateContextsLength);
 	cc = (struct create_context *)data_offset;
 	while (remaining >= sizeof(struct create_context)) {
@@ -1679,7 +1679,7 @@ alloc_path_with_tree_prefix(__le16 **out_path, int *out_size, int *out_len,
 int
 SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	  __u8 *oplock, struct smb2_file_all_info *buf,
-	  struct smb2_err_rsp **err_buf)
+	  struct kvec *err_iov)
 {
 	struct smb2_create_req *req;
 	struct smb2_create_rsp *rsp;
@@ -1815,9 +1815,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
-		if (err_buf && rsp)
-			*err_buf = kmemdup(rsp, get_rfc1002_length(rsp) + 4,
-					   GFP_KERNEL);
+		if (err_iov && rsp) {
+			*err_iov = rsp_iov;
+			rsp = NULL;
+		}
 		goto creat_exit;
 	}
 
@@ -1856,7 +1857,6 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 {
 	struct smb2_ioctl_req *req;
 	struct smb2_ioctl_rsp *rsp;
-	struct smb2_sync_hdr *shdr;
 	struct cifs_ses *ses;
 	struct kvec iov[2];
 	struct kvec rsp_iov;
@@ -1987,7 +1987,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		goto ioctl_exit;
 	}
 
-	if (get_rfc1002_length(rsp) < le32_to_cpu(rsp->OutputOffset) + *plen) {
+	if (rsp_iov.iov_len < le32_to_cpu(rsp->OutputOffset) + *plen) {
 		cifs_dbg(VFS, "Malformed ioctl resp: len %d offset %d\n", *plen,
 			le32_to_cpu(rsp->OutputOffset));
 		*plen = 0;
@@ -2001,8 +2001,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		goto ioctl_exit;
 	}
 
-	shdr = get_sync_hdr(rsp);
-	memcpy(*out_data, (char *)shdr + le32_to_cpu(rsp->OutputOffset), *plen);
+	memcpy(*out_data, (char *)rsp + le32_to_cpu(rsp->OutputOffset), *plen);
 ioctl_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
@@ -2083,13 +2082,12 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static int
-validate_buf(unsigned int offset, unsigned int buffer_length,
-	     struct smb2_hdr *hdr, unsigned int min_buf_size)
-
+validate_iov(unsigned int offset, unsigned int buffer_length,
+	     struct kvec *iov, unsigned int min_buf_size)
 {
-	unsigned int smb_len = be32_to_cpu(hdr->smb2_buf_length);
-	char *end_of_smb = smb_len + 4 /* RFC1001 length field */ + (char *)hdr;
-	char *begin_of_buf = 4 /* RFC1001 len field */ + offset + (char *)hdr;
+	unsigned int smb_len = iov->iov_len;
+	char *end_of_smb = smb_len + (char *)iov->iov_base;
+	char *begin_of_buf = offset + (char *)iov->iov_base;
 	char *end_of_buf = begin_of_buf + buffer_length;
 
 
@@ -2119,18 +2117,17 @@ validate_buf(unsigned int offset, unsigned int buffer_length,
  * Caller must free buffer.
  */
 static int
-validate_and_copy_buf(unsigned int offset, unsigned int buffer_length,
-		      struct smb2_hdr *hdr, unsigned int minbufsize,
+validate_and_copy_iov(unsigned int offset, unsigned int buffer_length,
+		      struct kvec *iov, unsigned int minbufsize,
 		      char *data)
-
 {
-	char *begin_of_buf = 4 /* RFC1001 len field */ + offset + (char *)hdr;
+	char *begin_of_buf = offset + (char *)iov->iov_base;
 	int rc;
 
 	if (!data)
 		return -EINVAL;
 
-	rc = validate_buf(offset, buffer_length, hdr, minbufsize);
+	rc = validate_iov(offset, buffer_length, iov, minbufsize);
 	if (rc)
 		return rc;
 
@@ -2208,9 +2205,9 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 	}
 
-	rc = validate_and_copy_buf(le16_to_cpu(rsp->OutputBufferOffset),
+	rc = validate_and_copy_iov(le16_to_cpu(rsp->OutputBufferOffset),
 				   le32_to_cpu(rsp->OutputBufferLength),
-				   &rsp->hdr, min_len, *data);
+				   &rsp_iov, min_len, *data);
 
 qinf_exit:
 	free_rsp_buf(resp_buftype, rsp);
@@ -2279,7 +2276,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 	unsigned int credits_received = 1;
 
 	if (mid->mid_state == MID_RESPONSE_RECEIVED)
-		credits_received = le16_to_cpu(rsp->hdr.sync_hdr.CreditRequest);
+		credits_received = le16_to_cpu(rsp->sync_hdr.CreditRequest);
 
 	DeleteMidQEntry(mid);
 	add_credits(server, credits_received, CIFS_ECHO_OP);
@@ -2629,7 +2626,6 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	int resp_buftype, rc = -EACCES;
 	struct smb2_read_plain_req *req = NULL;
 	struct smb2_read_rsp *rsp = NULL;
-	struct smb2_sync_hdr *shdr;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	unsigned int total_len;
@@ -2670,10 +2666,8 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		*nbytes = 0;
 	}
 
-	shdr = get_sync_hdr(rsp);
-
 	if (*buf) {
-		memcpy(*buf, (char *)shdr + rsp->DataOffset, *nbytes);
+		memcpy(*buf, (char *)rsp + rsp->DataOffset, *nbytes);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	} else if (resp_buftype != CIFS_NO_BUFFER) {
 		*buf = rsp_iov.iov_base;
@@ -2700,7 +2694,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		credits_received = le16_to_cpu(rsp->hdr.sync_hdr.CreditRequest);
+		credits_received = le16_to_cpu(rsp->sync_hdr.CreditRequest);
 		wdata->result = smb2_check_receive(mid, tcon->ses->server, 0);
 		if (wdata->result != 0)
 			break;
@@ -3018,7 +3012,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (rc) {
 		if (rc == -ENODATA &&
-		    rsp->hdr.sync_hdr.Status == STATUS_NO_MORE_FILES) {
+		    rsp->sync_hdr.Status == STATUS_NO_MORE_FILES) {
 			srch_inf->endOfSearch = true;
 			rc = 0;
 		}
@@ -3026,8 +3020,8 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdir_exit;
 	}
 
-	rc = validate_buf(le16_to_cpu(rsp->OutputBufferOffset),
-			  le32_to_cpu(rsp->OutputBufferLength), &rsp->hdr,
+	rc = validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+			  le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
 			  info_buf_size);
 	if (rc)
 		goto qdir_exit;
@@ -3041,10 +3035,9 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 			cifs_buf_release(srch_inf->ntwrk_buf_start);
 	}
 	srch_inf->ntwrk_buf_start = (char *)rsp;
-	srch_inf->srch_entries_start = srch_inf->last_entry = 4 /* rfclen */ +
-		(char *)&rsp->hdr + le16_to_cpu(rsp->OutputBufferOffset);
-	/* 4 for rfc1002 length field */
-	end_of_smb = get_rfc1002_length(rsp) + 4 + (char *)&rsp->hdr;
+	srch_inf->srch_entries_start = srch_inf->last_entry =
+		(char *)rsp + le16_to_cpu(rsp->OutputBufferOffset);
+	end_of_smb = rsp_iov.iov_len + (char *)rsp;
 	srch_inf->entries_in_buffer =
 			num_entries(srch_inf->srch_entries_start, end_of_smb,
 				    &srch_inf->last_entry, info_buf_size);
@@ -3280,7 +3273,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		  __u8 oplock_level)
 {
 	int rc;
-	struct smb2_oplock_break_req *req = NULL;
+	struct smb2_oplock_break *req = NULL;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = CIFS_OBREAK_OP;
 	unsigned int total_len;
@@ -3356,7 +3349,7 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
 	req->InputBufferOffset =
 			cpu_to_le16(sizeof(struct smb2_query_info_req) - 1);
 	req->OutputBufferLength = cpu_to_le32(
-		outbuf_len + sizeof(struct smb2_query_info_rsp) - 1 - 4);
+		outbuf_len + sizeof(struct smb2_query_info_rsp) - 1);
 
 	iov->iov_base = (char *)req;
 	iov->iov_len = total_len;
@@ -3393,10 +3386,10 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
-	info = (struct smb2_fs_full_size_info *)(4 /* RFC1001 len */ +
-		le16_to_cpu(rsp->OutputBufferOffset) + (char *)&rsp->hdr);
-	rc = validate_buf(le16_to_cpu(rsp->OutputBufferOffset),
-			  le32_to_cpu(rsp->OutputBufferLength), &rsp->hdr,
+	info = (struct smb2_fs_full_size_info *)(
+		le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
+	rc = validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+			  le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
 			  sizeof(struct smb2_fs_full_size_info));
 	if (!rc)
 		copy_fs_info_to_kstatfs(info, fsdata);
@@ -3451,20 +3444,20 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rsp_len = le32_to_cpu(rsp->OutputBufferLength);
 	offset = le16_to_cpu(rsp->OutputBufferOffset);
-	rc = validate_buf(offset, rsp_len, &rsp->hdr, min_len);
+	rc = validate_iov(offset, rsp_len, &rsp_iov, min_len);
 	if (rc)
 		goto qfsattr_exit;
 
 	if (level == FS_ATTRIBUTE_INFORMATION)
-		memcpy(&tcon->fsAttrInfo, 4 /* RFC1001 len */ + offset
-			+ (char *)&rsp->hdr, min_t(unsigned int,
+		memcpy(&tcon->fsAttrInfo, offset
+			+ (char *)rsp, min_t(unsigned int,
 			rsp_len, max_len));
 	else if (level == FS_DEVICE_INFORMATION)
-		memcpy(&tcon->fsDevInfo, 4 /* RFC1001 len */ + offset
-			+ (char *)&rsp->hdr, sizeof(FILE_SYSTEM_DEVICE_INFO));
+		memcpy(&tcon->fsDevInfo, offset
+			+ (char *)rsp, sizeof(FILE_SYSTEM_DEVICE_INFO));
 	else if (level == FS_SECTOR_SIZE_INFORMATION) {
 		struct smb3_fs_ss_info *ss_info = (struct smb3_fs_ss_info *)
-			(4 /* RFC1001 len */ + offset + (char *)&rsp->hdr);
+			(offset + (char *)rsp);
 		tcon->ss_flags = le32_to_cpu(ss_info->Flags);
 		tcon->perf_sector_size =
 			le32_to_cpu(ss_info->PhysicalBytesPerSectorForPerf);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 19d34881815f..91fd17f5c2eb 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -122,25 +122,10 @@ struct smb2_sync_pdu {
 	__le16 StructureSize2; /* size of wct area (varies, request specific) */
 } __packed;
 
-struct smb2_hdr {
-	__be32 smb2_buf_length;	/* big endian on wire */
-				/* length is only two or three bytes - with */
-				/* one or two byte type preceding it that MBZ */
-	struct smb2_sync_hdr sync_hdr;
-} __packed;
-
-struct smb2_pdu {
-	struct smb2_hdr hdr;
-	__le16 StructureSize2; /* size of wct area (varies, request specific) */
-} __packed;
-
 #define SMB3_AES128CMM_NONCE 11
 #define SMB3_AES128GCM_NONCE 12
 
 struct smb2_transform_hdr {
-	__be32 smb2_buf_length;	/* big endian on wire */
-				/* length is only two or three bytes - with
-				 one or two byte type preceding it that MBZ */
 	__le32 ProtocolId;	/* 0xFD 'S' 'M' 'B' */
 	__u8   Signature[16];
 	__u8   Nonce[16];
@@ -171,7 +156,7 @@ struct smb2_transform_hdr {
 #define SMB2_ERROR_STRUCTURE_SIZE2 cpu_to_le16(9)
 
 struct smb2_err_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;
 	__le16 Reserved; /* MBZ */
 	__le32 ByteCount;  /* even if zero, at least one byte follows */
@@ -259,7 +244,7 @@ struct smb2_encryption_neg_context {
 } __packed;
 
 struct smb2_negotiate_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 65 */
 	__le16 SecurityMode;
 	__le16 DialectRevision;
@@ -299,7 +284,7 @@ struct smb2_sess_setup_req {
 #define SMB2_SESSION_FLAG_IS_NULL	0x0002
 #define SMB2_SESSION_FLAG_ENCRYPT_DATA	0x0004
 struct smb2_sess_setup_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 SessionFlags;
 	__le16 SecurityBufferOffset;
@@ -314,7 +299,7 @@ struct smb2_logoff_req {
 } __packed;
 
 struct smb2_logoff_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -332,7 +317,7 @@ struct smb2_tree_connect_req {
 } __packed;
 
 struct smb2_tree_connect_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 16 */
 	__u8   ShareType;  /* see below */
 	__u8   Reserved;
@@ -381,7 +366,7 @@ struct smb2_tree_disconnect_req {
 } __packed;
 
 struct smb2_tree_disconnect_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -516,7 +501,7 @@ struct smb2_create_req {
 } __packed;
 
 struct smb2_create_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 89 */
 	__u8   OplockLevel;
 	__u8   Reserved;
@@ -771,7 +756,7 @@ struct smb2_ioctl_req {
 } __packed;
 
 struct smb2_ioctl_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u16 Reserved;
 	__le32 CtlCode;
@@ -798,7 +783,7 @@ struct smb2_close_req {
 } __packed;
 
 struct smb2_close_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
@@ -821,7 +806,7 @@ struct smb2_flush_req {
 } __packed;
 
 struct smb2_flush_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;
 	__le16 Reserved;
 } __packed;
@@ -853,7 +838,7 @@ struct smb2_read_plain_req {
 } __packed;
 
 struct smb2_read_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 17 */
 	__u8   DataOffset;
 	__u8   Reserved;
@@ -884,7 +869,7 @@ struct smb2_write_req {
 } __packed;
 
 struct smb2_write_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 17 */
 	__u8   DataOffset;
 	__u8   Reserved;
@@ -918,7 +903,7 @@ struct smb2_lock_req {
 } __packed;
 
 struct smb2_lock_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -930,7 +915,7 @@ struct smb2_echo_req {
 } __packed;
 
 struct smb2_echo_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__u16  Reserved;
 } __packed;
@@ -956,7 +941,7 @@ struct smb2_query_directory_req {
 } __packed;
 
 struct smb2_query_directory_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
@@ -1005,7 +990,7 @@ struct smb2_query_info_req {
 } __packed;
 
 struct smb2_query_info_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
@@ -1027,12 +1012,11 @@ struct smb2_set_info_req {
 } __packed;
 
 struct smb2_set_info_rsp {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 2 */
 } __packed;
 
-/* oplock break without an rfc1002 header */
-struct smb2_oplock_break_req {
+struct smb2_oplock_break {
 	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 24 */
 	__u8   OplockLevel;
@@ -1042,21 +1026,10 @@ struct smb2_oplock_break_req {
 	__u64  VolatileFid;
 } __packed;
 
-/* oplock break with an rfc1002 header */
-struct smb2_oplock_break_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* Must be 24 */
-	__u8   OplockLevel;
-	__u8   Reserved;
-	__le32 Reserved2;
-	__u64  PersistentFid;
-	__u64  VolatileFid;
-} __packed;
-
 #define SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED cpu_to_le32(0x01)
 
 struct smb2_lease_break {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 44 */
 	__le16 Reserved;
 	__le32 Flags;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index e9ab5227e7a8..089a6ef936b8 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -37,7 +37,8 @@ extern int map_smb2_to_linux_error(char *buf, bool log_err);
 extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
 extern unsigned int smb2_calc_size(void *buf);
-extern char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr);
+extern char *smb2_get_data_area_len(int *off, int *len,
+				    struct smb2_sync_hdr *shdr);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,
 					  struct cifs_sb_info *cifs_sb);
 
@@ -122,7 +123,7 @@ extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
 extern int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
 		     __le16 *path, __u8 *oplock,
 		     struct smb2_file_all_info *buf,
-		     struct smb2_err_rsp **err_buf);
+		     struct kvec *err_iov);
 extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
 		     bool is_fsctl, bool use_ipc,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 99493946e2f9..cf37c6651bf6 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -624,10 +624,10 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	struct smb_rqst rqst = { .rq_iov = iov,
 				 .rq_nvec = 2 };
 
-	iov[0].iov_base = (char *)mid->resp_buf;
+	iov[0].iov_base = NULL;
 	iov[0].iov_len = 4;
-	iov[1].iov_base = (char *)mid->resp_buf + 4;
-	iov[1].iov_len = len;
+	iov[1].iov_base = (char *)mid->resp_buf;
+	iov[1].iov_len = server->total_size;
 
 	dump_smb(mid->resp_buf, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 510f41a435c8..5cecf67af8f1 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -779,7 +779,9 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 	buf = (char *)midQ->resp_buf;
 	resp_iov->iov_base = buf;
-	resp_iov->iov_len = get_rfc1002_length(buf) + 4;
+	resp_iov->iov_len = ses->server->total_size +
+		ses->server->vals->header_preamble_size;
+
 	if (midQ->large_buf)
 		*resp_buf_type = CIFS_LARGE_BUFFER;
 	else
-- 
2.13.3
