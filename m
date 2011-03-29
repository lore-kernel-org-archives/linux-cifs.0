From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: keep received ByteCount in little-endian format
Date: Tue, 29 Mar 2011 09:40:07 -0400
Message-ID: <1301406007-2265-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, the ByteCount is usually converted to host-endian on receive.
This is confusing however, as we need to keep two sets of routines for
accessing it, and keep track of when to use each routine. Munging
received packets like this also limits when the signature can be
calulated.

Simplify the code by keeping the received ByteCount in little-endian
format. This allows us to eliminate a set of routines for accessing it
and we can now drop the _le suffixes from the accessor functions since
that's now implied.

While we're at it, switch all of the places that read the ByteCount
directly to use the get_bcc inline which should also clean up some
unaligned accesses.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/cifspdu.h    |   22 +----------------
 fs/cifs/cifsproto.h  |    1 -
 fs/cifs/cifssmb.c    |   61 +++++++++++++++++++++++++------------------------
 fs/cifs/connect.c    |    4 +-
 fs/cifs/misc.c       |    4 +-
 fs/cifs/netmisc.c    |    7 -----
 fs/cifs/sess.c       |    2 +-
 fs/cifs/transport.c  |   19 +--------------
 9 files changed, 40 insertions(+), 82 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 6dc9da5..b444449 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -63,7 +63,7 @@ void cifs_dump_detail(struct smb_hdr *smb)
 	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
 		  smb->Command, smb->Status.CifsError,
 		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cERROR(1, "smb buf %p len %d", smb, smbCalcSize_LE(smb));
+	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
 }
 
 
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index eac95e2..291d735 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -435,36 +435,18 @@ struct smb_hdr {
 /* given a pointer to an smb_hdr retrieve the pointer to the byte area */
 #define pByteArea(smb_var) (BCC(smb_var) + 2)
 
-/* get the converted ByteCount for a SMB packet and return it */
-static inline __u16
-get_bcc(struct smb_hdr *hdr)
-{
-	__u16 *bc_ptr = (__u16 *)BCC(hdr);
-
-	return get_unaligned(bc_ptr);
-}
-
 /* get the unconverted ByteCount for a SMB packet and return it */
 static inline __u16
-get_bcc_le(struct smb_hdr *hdr)
+get_bcc(struct smb_hdr *hdr)
 {
 	__le16 *bc_ptr = (__le16 *)BCC(hdr);
 
 	return get_unaligned_le16(bc_ptr);
 }
 
-/* set the ByteCount for a SMB packet in host-byte order */
-static inline void
-put_bcc(__u16 count, struct smb_hdr *hdr)
-{
-	__u16 *bc_ptr = (__u16 *)BCC(hdr);
-
-	put_unaligned(count, bc_ptr);
-}
-
 /* set the ByteCount for a SMB packet in little-endian */
 static inline void
-put_bcc_le(__u16 count, struct smb_hdr *hdr)
+put_bcc(__u16 count, struct smb_hdr *hdr)
 {
 	__le16 *bc_ptr = (__le16 *)BCC(hdr);
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e42dc82..76c4dc7f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -91,7 +91,6 @@ extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern unsigned int smbCalcSize(struct smb_hdr *ptr);
-extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 92e33d4..1622978 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -581,7 +581,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 
 	if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC) &&
 		(server->capabilities & CAP_EXTENDED_SECURITY)) {
-		count = pSMBr->ByteCount;
+		count = get_bcc(&pSMBr->hdr);
 		if (count < 16) {
 			rc = -EIO;
 			goto neg_err_exit;
@@ -735,7 +735,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	smb->hdr.Tid = 0xffff;
 	smb->hdr.WordCount = 1;
 	put_unaligned_le16(1, &smb->EchoCount);
-	put_bcc_le(1, &smb->hdr);
+	put_bcc(1, &smb->hdr);
 	smb->Data[0] = 'a';
 	inc_rfc1001_len(smb, 3);
 
@@ -1078,7 +1078,7 @@ PsxCreat:
 	cFYI(1, "copying inode info");
 	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-	if (rc || (pSMBr->ByteCount < sizeof(OPEN_PSX_RSP))) {
+	if (rc || get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)) {
 		rc = -EIO;	/* bad smb */
 		goto psx_create_err;
 	}
@@ -1099,7 +1099,7 @@ PsxCreat:
 		pRetData->Type = cpu_to_le32(-1); /* unknown */
 		cFYI(DBG2, "unknown type");
 	} else {
-		if (pSMBr->ByteCount < sizeof(OPEN_PSX_RSP)
+		if (get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)
 					+ sizeof(FILE_UNIX_BASIC_INFO)) {
 			cERROR(1, "Open response data too small");
 			pRetData->Type = cpu_to_le32(-1);
@@ -1866,7 +1866,7 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < sizeof(struct cifs_posix_lock))) {
+		if (rc || (get_bcc(&pSMBr->hdr) < sizeof(struct cifs_posix_lock))) {
 			rc = -EIO;      /* bad smb */
 			goto plk_err_exit;
 		}
@@ -2493,7 +2493,7 @@ querySymLinkRetry:
 
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		/* BB also check enough total bytes returned */
-		if (rc || (pSMBr->ByteCount < 2))
+		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			rc = -EIO;
 		else {
 			bool is_unicode;
@@ -2575,14 +2575,14 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifs_tcon *tcon,
 	} else {		/* decode response */
 		__u32 data_offset = le32_to_cpu(pSMBr->DataOffset);
 		__u32 data_count = le32_to_cpu(pSMBr->DataCount);
-		if ((pSMBr->ByteCount < 2) || (data_offset > 512)) {
-		/* BB also check enough total bytes returned */
+		if (get_bcc(&pSMBr->hdr) < 2 || data_offset > 512) {
+			/* BB also check enough total bytes returned */
 			rc = -EIO;	/* bad smb */
 			goto qreparse_out;
 		}
 		if (data_count && (data_count < 2048)) {
 			char *end_of_smb = 2 /* sizeof byte count */ +
-				pSMBr->ByteCount + (char *)&pSMBr->ByteCount;
+				get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
 
 			struct reparse_data *reparse_buf =
 						(struct reparse_data *)
@@ -2840,7 +2840,7 @@ queryAclRetry:
 		/* decode response */
 
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-		if (rc || (pSMBr->ByteCount < 2))
+		if (rc || get_bcc(&pSMBr->hdr) < 2)
 		/* BB also check enough total bytes returned */
 			rc = -EIO;      /* bad smb */
 		else {
@@ -2990,7 +2990,7 @@ GetExtAttrRetry:
 	} else {
 		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-		if (rc || (pSMBr->ByteCount < 2))
+		if (rc || get_bcc(&pSMBr->hdr) < 2)
 		/* BB also check enough total bytes returned */
 			/* If rc should we check for EOPNOSUPP and
 			   disable the srvino flag? or in caller? */
@@ -3066,6 +3066,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 	char *end_of_smb;
 	__u32 data_count, data_offset, parm_count, parm_offset;
 	struct smb_com_ntransact_rsp *pSMBr;
+	u16 bcc;
 
 	*pdatalen = 0;
 	*pparmlen = 0;
@@ -3075,8 +3076,8 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 
 	pSMBr = (struct smb_com_ntransact_rsp *)buf;
 
-	/* ByteCount was converted from little endian in SendReceive */
-	end_of_smb = 2 /* sizeof byte count */ + pSMBr->ByteCount +
+	bcc = get_bcc(&pSMBr->hdr);
+	end_of_smb = 2 /* sizeof byte count */ + bcc +
 			(char *)&pSMBr->ByteCount;
 
 	data_offset = le32_to_cpu(pSMBr->DataOffset);
@@ -3102,7 +3103,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 			*ppdata, data_count, (data_count + *ppdata),
 			end_of_smb, pSMBr);
 		return -EINVAL;
-	} else if (parm_count + data_count > pSMBr->ByteCount) {
+	} else if (parm_count + data_count > bcc) {
 		cFYI(1, "parm count and data count larger than SMB");
 		return -EINVAL;
 	}
@@ -3388,7 +3389,7 @@ QFileInfoRetry:
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = -EIO;
-		else if (pSMBr->ByteCount < 40)
+		else if (get_bcc(&pSMBr->hdr) < 40)
 			rc = -EIO;	/* bad smb */
 		else if (pFindData) {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -3476,9 +3477,9 @@ QPathInfoRetry:
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = -EIO;
-		else if (!legacy && (pSMBr->ByteCount < 40))
+		else if (!legacy && get_bcc(&pSMBr->hdr) < 40)
 			rc = -EIO;	/* bad smb */
-		else if (legacy && (pSMBr->ByteCount < 24))
+		else if (legacy && get_bcc(&pSMBr->hdr) < 24)
 			rc = -EIO;  /* 24 or 26 expected but we do not read
 					last field */
 		else if (pFindData) {
@@ -3554,7 +3555,7 @@ UnixQFileInfoRetry:
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < sizeof(FILE_UNIX_BASIC_INFO))) {
+		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
 				   "Unix Extensions can be disabled on mount "
 				   "by specifying the nosfu mount option.");
@@ -3640,7 +3641,7 @@ UnixQPathInfoRetry:
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < sizeof(FILE_UNIX_BASIC_INFO))) {
+		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
 				   "Unix Extensions can be disabled on mount "
 				   "by specifying the nosfu mount option.");
@@ -4045,7 +4046,7 @@ GetInodeNumberRetry:
 	} else {
 		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-		if (rc || (pSMBr->ByteCount < 2))
+		if (rc || get_bcc(&pSMBr->hdr) < 2)
 		/* BB also check enough total bytes returned */
 			/* If rc should we check for EOPNOSUPP and
 			disable the srvino flag? or in caller? */
@@ -4271,13 +4272,13 @@ getDFSRetry:
 	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 	/* BB Also check if enough total bytes returned? */
-	if (rc || (pSMBr->ByteCount < 17)) {
+	if (rc || get_bcc(&pSMBr->hdr) < 17) {
 		rc = -EIO;      /* bad smb */
 		goto GetDFSRefExit;
 	}
 
 	cFYI(1, "Decoding GetDFSRefer response BCC: %d  Offset %d",
-				pSMBr->ByteCount,
+				get_bcc(&pSMBr->hdr),
 				le16_to_cpu(pSMBr->t2.DataOffset));
 
 	/* parse returned result into more usable form */
@@ -4343,12 +4344,12 @@ oldQFSInfoRetry:
 	} else {                /* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < 18))
+		if (rc || get_bcc(&pSMBr->hdr) < 18)
 			rc = -EIO;      /* bad smb */
 		else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 			cFYI(1, "qfsinf resp BCC: %d  Offset %d",
-				 pSMBr->ByteCount, data_offset);
+				 get_bcc(&pSMBr->hdr), data_offset);
 
 			response_data = (FILE_SYSTEM_ALLOC_INFO *)
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);
@@ -4422,7 +4423,7 @@ QFSInfoRetry:
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < 24))
+		if (rc || get_bcc(&pSMBr->hdr) < 24)
 			rc = -EIO;	/* bad smb */
 		else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4502,7 +4503,7 @@ QFSAttributeRetry:
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < 13)) {
+		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			/* BB also check if enough bytes returned */
 			rc = -EIO;	/* bad smb */
 		} else {
@@ -4573,7 +4574,7 @@ QFSDeviceRetry:
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < sizeof(FILE_SYSTEM_DEVICE_INFO)))
+		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_SYSTEM_DEVICE_INFO))
 			rc = -EIO;	/* bad smb */
 		else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4642,7 +4643,7 @@ QFSUnixRetry:
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < 13)) {
+		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			rc = -EIO;	/* bad smb */
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4787,7 +4788,7 @@ QFSPosixRetry:
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-		if (rc || (pSMBr->ByteCount < 13)) {
+		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			rc = -EIO;	/* bad smb */
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -5516,7 +5517,7 @@ QAllEAsRetry:
 	of these trans2 responses */
 
 	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-	if (rc || (pSMBr->ByteCount < 4)) {
+	if (rc || get_bcc(&pSMBr->hdr) < 4) {
 		rc = -EIO;	/* bad smb */
 		goto QAllEAsOut;
 	}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 96544a4..66d8de3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -315,9 +315,9 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
 	total_in_buf += total_in_buf2;
 	put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCount);
-	byte_count = get_bcc_le(pTargetSMB);
+	byte_count = get_bcc(pTargetSMB);
 	byte_count += total_in_buf2;
-	put_bcc_le(byte_count, pTargetSMB);
+	put_bcc(byte_count, pTargetSMB);
 
 	byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
 	byte_count += total_in_buf2;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 6863acf..c828e1d 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -462,7 +462,7 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 
 	if (check_smb_hdr(smb, mid))
 		return 1;
-	clc_len = smbCalcSize_LE(smb);
+	clc_len = smbCalcSize(smb);
 
 	if (4 + len != length) {
 		cERROR(1, "Length read does not match RFC1001 length %d",
@@ -519,7 +519,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 			(struct smb_com_transaction_change_notify_rsp *)buf;
 		struct file_notify_information *pnotify;
 		__u32 data_offset = 0;
-		if (get_bcc_le(buf) > sizeof(struct file_notify_information)) {
+		if (get_bcc(buf) > sizeof(struct file_notify_information)) {
 			data_offset = le32_to_cpu(pSMBr->DataOffset);
 
 			pnotify = (struct file_notify_information *)
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 79f641e..79b71c2 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -919,13 +919,6 @@ smbCalcSize(struct smb_hdr *ptr)
 		2 /* size of the bcc field */ + get_bcc(ptr));
 }
 
-unsigned int
-smbCalcSize_LE(struct smb_hdr *ptr)
-{
-	return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
-		2 /* size of the bcc field */ + get_bcc_le(ptr));
-}
-
 /* The following are taken from fs/ntfs/util.c */
 
 #define NTFS_TIME_OFFSET ((u64)(369*365 + 89) * 24 * 3600 * 10000000)
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 6b140e1..8e59263 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -875,7 +875,7 @@ ssetup_ntlmssp_authenticate:
 	smb_buf->smb_buf_length =
 		cpu_to_be32(be32_to_cpu(smb_buf->smb_buf_length) + count);
 
-	put_bcc_le(count, smb_buf);
+	put_bcc(count, smb_buf);
 
 	rc = SendReceive2(xid, ses, iov, 3 /* num_iovecs */, &resp_buf_type,
 			  CIFS_LOG_ERROR);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1b3a9e0..85063de 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -487,7 +487,7 @@ send_nt_cancel(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 	in_buf->smb_buf_length = cpu_to_be32(sizeof(struct smb_hdr) - 4  + 2);
 	in_buf->Command = SMB_COM_NT_CANCEL;
 	in_buf->WordCount = 0;
-	put_bcc_le(0, in_buf);
+	put_bcc(0, in_buf);
 
 	mutex_lock(&server->srv_mutex);
 	rc = cifs_sign_smb(in_buf, server, &mid->sequence_number);
@@ -643,11 +643,6 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		rc = map_smb_to_linux_error(midQ->resp_buf,
 					    flags & CIFS_LOG_ERROR);
 
-		/* convert ByteCount if necessary */
-		if (receive_len >= sizeof(struct smb_hdr) - 4
-		    /* do not count RFC1001 header */  +
-		    (2 * midQ->resp_buf->WordCount) + 2 /* bcc */ )
-			put_bcc(get_bcc_le(midQ->resp_buf), midQ->resp_buf);
 		if ((flags & CIFS_NO_RESP) == 0)
 			midQ->resp_buf = NULL;  /* mark it so buf will
 						   not be freed by
@@ -794,12 +789,6 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 		/* BB special case reconnect tid and uid here? */
 		rc = map_smb_to_linux_error(out_buf, 0 /* no log */ );
-
-		/* convert ByteCount if necessary */
-		if (receive_len >= sizeof(struct smb_hdr) - 4
-		    /* do not count RFC1001 header */  +
-		    (2 * out_buf->WordCount) + 2 /* bcc */ )
-			put_bcc(get_bcc_le(midQ->resp_buf), midQ->resp_buf);
 	} else {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
@@ -1004,12 +993,6 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	/* BB special case reconnect tid and uid here? */
 	rc = map_smb_to_linux_error(out_buf, 0 /* no log */ );
 
-	/* convert ByteCount if necessary */
-	if (receive_len >= sizeof(struct smb_hdr) - 4
-	    /* do not count RFC1001 header */  +
-	    (2 * out_buf->WordCount) + 2 /* bcc */ )
-		put_bcc(get_bcc_le(out_buf), out_buf);
-
 out:
 	delete_mid(midQ);
 	if (rstart && rc == -EACCES)
-- 
1.7.4
