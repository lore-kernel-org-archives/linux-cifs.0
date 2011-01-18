From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] cifs: use get/put_unaligned functions to access ByteCount
Date: Tue, 18 Jan 2011 15:33:15 -0500
Message-ID: <1295382799-7902-2-git-send-email-jlayton@redhat.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible that when we access the ByteCount that the alignment
will be off. Most CPUs deal with that transparently, but there's
usually some performance impact. Some CPUs raise an exception on
unaligned accesses.

Fix this by accessing the byte count using the get_unaligned and
put_unaligned inlined functions. While we're at it, fix the types
of some of the variables that end up getting returns from these
functions.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifspdu.h   |   47 +++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/cifssmb.c   |   14 +++++---------
 fs/cifs/connect.c   |   10 +++++-----
 fs/cifs/netmisc.c   |    4 ++--
 fs/cifs/sess.c      |   13 ++++++-------
 fs/cifs/transport.c |    9 ++++-----
 6 files changed, 65 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index ea205b4..b5c8cc5 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -23,6 +23,7 @@
 #define _CIFSPDU_H
 
 #include <net/sock.h>
+#include <asm/unaligned.h>
 #include "smbfsctl.h"
 
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
@@ -426,11 +427,49 @@ struct smb_hdr {
 	__u16 Mid;
 	__u8 WordCount;
 } __attribute__((packed));
-/* given a pointer to an smb_hdr retrieve the value of byte count */
-#define BCC(smb_var) (*(__u16 *)((char *)(smb_var) + sizeof(struct smb_hdr) + (2 * (smb_var)->WordCount)))
-#define BCC_LE(smb_var) (*(__le16 *)((char *)(smb_var) + sizeof(struct smb_hdr) + (2 * (smb_var)->WordCount)))
+
+/* given a pointer to an smb_hdr retrieve a char pointer to the byte count */
+#define BCC(smb_var) ((unsigned char *)(smb_var) + sizeof(struct smb_hdr) + \
+			 (2 * (smb_var)->WordCount))
+
 /* given a pointer to an smb_hdr retrieve the pointer to the byte area */
-#define pByteArea(smb_var) ((unsigned char *)(smb_var) + sizeof(struct smb_hdr) + (2 * (smb_var)->WordCount) + 2)
+#define pByteArea(smb_var) (BCC(smb_var) + 2)
+
+/* get the converted ByteCount for a SMB packet and return it */
+static inline __u16
+get_bcc(struct smb_hdr *hdr)
+{
+	__u16 *bc_ptr = (__u16 *)BCC(hdr);
+
+	return get_unaligned(bc_ptr);
+}
+
+/* get the unconverted ByteCount for a SMB packet and return it */
+static inline __u16
+get_bcc_le(struct smb_hdr *hdr)
+{
+	__le16 *bc_ptr = (__le16 *)BCC(hdr);
+
+	return get_unaligned_le16(bc_ptr);
+}
+
+/* set the ByteCount for a SMB packet in host-byte order */
+static inline void
+put_bcc(__u16 count, struct smb_hdr *hdr)
+{
+	__u16 *bc_ptr = (__u16 *)BCC(hdr);
+
+	put_unaligned(count, bc_ptr);
+}
+
+/* set the ByteCount for a SMB packet in little-endian */
+static inline void
+put_bcc_le(__u16 count, struct smb_hdr *hdr)
+{
+	__le16 *bc_ptr = (__le16 *)BCC(hdr);
+
+	put_unaligned_le16(count, bc_ptr);
+}
 
 /*
  * Computer Name Length (since Netbios name was length 16 with last byte 0x20)
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c5b2014..3b3072c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -333,7 +333,6 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
 {
 	int rc = -EINVAL;
 	int total_size;
-	char *pBCC;
 
 	/* check for plausible wct, bcc and t2 data and parm sizes */
 	/* check for parm and data offset going beyond end of smb */
@@ -346,13 +345,9 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
 			if (total_size < 512) {
 				total_size +=
 					le16_to_cpu(pSMB->t2_rsp.DataCount);
-				/* BCC le converted in SendReceive */
-				pBCC = (pSMB->hdr.WordCount * 2) +
-					sizeof(struct smb_hdr) +
-					(char *)pSMB;
-				if ((total_size <= (*(u16 *)pBCC)) &&
-				   (total_size <
-					CIFSMaxBufSize+MAX_CIFS_HDR_SIZE)) {
+				if (total_size <= get_bcc(&pSMB->hdr) &&
+				    total_size <
+					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
 					return 0;
 				}
 			}
@@ -362,6 +357,7 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
 		sizeof(struct smb_t2_rsp) + 16);
 	return rc;
 }
+
 int
 CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 {
@@ -5430,7 +5426,7 @@ QAllEAsRetry:
 	}
 
 	/* make sure list_len doesn't go past end of SMB */
-	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + BCC(&pSMBr->hdr);
+	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr);
 	if ((char *)ea_response_data + list_len > end_of_smb) {
 		cFYI(1, "EA list appears to go beyond SMB");
 		rc = -EIO;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 32c2f55..9bcdf2b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -318,9 +318,9 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
 	total_in_buf += total_in_buf2;
 	pSMBt->t2_rsp.DataCount = cpu_to_le16(total_in_buf);
-	byte_count = le16_to_cpu(BCC_LE(pTargetSMB));
+	byte_count = get_bcc_le(pTargetSMB);
 	byte_count += total_in_buf2;
-	BCC_LE(pTargetSMB) = cpu_to_le16(byte_count);
+	put_bcc_le(byte_count, pTargetSMB);
 
 	byte_count = pTargetSMB->smb_buf_length;
 	byte_count += total_in_buf2;
@@ -2937,8 +2937,8 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 	TCONX_RSP *pSMBr;
 	unsigned char *bcc_ptr;
 	int rc = 0;
-	int length, bytes_left;
-	__u16 count;
+	int length;
+	__u16 bytes_left, count;
 
 	if (ses == NULL)
 		return -EIO;
@@ -3032,7 +3032,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 		tcon->need_reconnect = false;
 		tcon->tid = smb_buffer_response->Tid;
 		bcc_ptr = pByteArea(smb_buffer_response);
-		bytes_left = BCC(smb_buffer_response);
+		bytes_left = get_bcc(smb_buffer_response);
 		length = strnlen(bcc_ptr, bytes_left - 2);
 		if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
 			is_unicode = true;
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 6783ce6..8d9189f 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -916,14 +916,14 @@ unsigned int
 smbCalcSize(struct smb_hdr *ptr)
 {
 	return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
-		2 /* size of the bcc field */ + BCC(ptr));
+		2 /* size of the bcc field */ + get_bcc(ptr));
 }
 
 unsigned int
 smbCalcSize_LE(struct smb_hdr *ptr)
 {
 	return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
-		2 /* size of the bcc field */ + le16_to_cpu(BCC_LE(ptr)));
+		2 /* size of the bcc field */ + get_bcc_le(ptr));
 }
 
 /* The following are taken from fs/ntfs/util.c */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 1cffd82..1adc962 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -277,7 +277,7 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifsSesInfo *ses,
 }
 
 static void
-decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
+decode_unicode_ssetup(char **pbcc_area, __u16 bleft, struct cifsSesInfo *ses,
 		      const struct nls_table *nls_cp)
 {
 	int len;
@@ -323,7 +323,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
 	return;
 }
 
-static int decode_ascii_ssetup(char **pbcc_area, int bleft,
+static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 			       struct cifsSesInfo *ses,
 			       const struct nls_table *nls_cp)
 {
@@ -575,12 +575,11 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses,
 	char *str_area;
 	SESSION_SETUP_ANDX *pSMB;
 	__u32 capabilities;
-	int count;
+	__u16 count;
 	int resp_buf_type;
 	struct kvec iov[3];
 	enum securityEnum type;
-	__u16 action;
-	int bytes_remaining;
+	__u16 action, bytes_remaining;
 	struct key *spnego_key = NULL;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	u16 blob_len;
@@ -876,7 +875,7 @@ ssetup_ntlmssp_authenticate:
 	count = iov[1].iov_len + iov[2].iov_len;
 	smb_buf->smb_buf_length += count;
 
-	BCC_LE(smb_buf) = cpu_to_le16(count);
+	put_bcc_le(count, smb_buf);
 
 	rc = SendReceive2(xid, ses, iov, 3 /* num_iovecs */, &resp_buf_type,
 			  CIFS_LOG_ERROR);
@@ -910,7 +909,7 @@ ssetup_ntlmssp_authenticate:
 	cFYI(1, "UID = %d ", ses->Suid);
 	/* response can have either 3 or 4 word count - Samba sends 3 */
 	/* and lanman response is 3 */
-	bytes_remaining = BCC(smb_buf);
+	bytes_remaining = get_bcc(smb_buf);
 	bcc_ptr = pByteArea(smb_buf);
 
 	if (smb_buf->WordCount == 4) {
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e2e66f3..fbeaee8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -484,7 +484,7 @@ send_nt_cancel(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 	in_buf->smb_buf_length = sizeof(struct smb_hdr) - 4  + 2;
 	in_buf->Command = SMB_COM_NT_CANCEL;
 	in_buf->WordCount = 0;
-	BCC_LE(in_buf) = 0;
+	put_bcc_le(0, in_buf);
 
 	mutex_lock(&server->srv_mutex);
 	rc = cifs_sign_smb(in_buf, server, &mid->sequence_number);
@@ -648,8 +648,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		if (receive_len >= sizeof(struct smb_hdr) - 4
 		    /* do not count RFC1001 header */  +
 		    (2 * midQ->resp_buf->WordCount) + 2 /* bcc */ )
-			BCC(midQ->resp_buf) =
-				le16_to_cpu(BCC_LE(midQ->resp_buf));
+			put_bcc(get_bcc_le(midQ->resp_buf), midQ->resp_buf);
 		if ((flags & CIFS_NO_RESP) == 0)
 			midQ->resp_buf = NULL;  /* mark it so buf will
 						   not be freed by
@@ -803,7 +802,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		if (receive_len >= sizeof(struct smb_hdr) - 4
 		    /* do not count RFC1001 header */  +
 		    (2 * out_buf->WordCount) + 2 /* bcc */ )
-			BCC(out_buf) = le16_to_cpu(BCC_LE(out_buf));
+			put_bcc(get_bcc_le(midQ->resp_buf), midQ->resp_buf);
 	} else {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
@@ -1015,7 +1014,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	if (receive_len >= sizeof(struct smb_hdr) - 4
 	    /* do not count RFC1001 header */  +
 	    (2 * out_buf->WordCount) + 2 /* bcc */ )
-		BCC(out_buf) = le16_to_cpu(BCC_LE(out_buf));
+		put_bcc(get_bcc_le(out_buf), out_buf);
 
 out:
 	delete_mid(midQ);
-- 
1.7.3.4
