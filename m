From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 05/15] CIFS: Separate SMB2 sync header processing
Date: Mon, 30 Jan 2017 13:39:34 -0800
Message-ID: <1485812384-28870-6-git-send-email-pshilov@microsoft.com>
References: <1485812384-28870-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485812384-28870-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Do not process RFC1001 length in smb2_hdr_assemble() because
it is not a part of SMB2 header. This allows to cleanup the code
and adds a possibility combine several SMB2 packets into one
for compounding.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 50 ++++++++++++++++++++++++++++++--------------------
 fs/cifs/smb2pdu.h |  5 +++++
 2 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 438c4b1..f6ba2c0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -79,25 +79,9 @@ static const int smb2_req_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 
 
 static void
-smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
+smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
 		  const struct cifs_tcon *tcon)
 {
-	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
-	struct smb2_sync_hdr *shdr = get_sync_hdr(hdr);
-	char *temp = (char *)hdr;
-	/* lookup word count ie StructureSize from table */
-	__u16 parmsize = smb2_req_struct_sizes[le16_to_cpu(smb2_cmd)];
-
-	/*
-	 * smaller than SMALL_BUFFER_SIZE but bigger than fixed area of
-	 * largest operations (Create)
-	 */
-	memset(temp, 0, 256);
-
-	/* Note this is only network field converted to big endian */
-	hdr->smb2_buf_length =
-			cpu_to_be32(parmsize + sizeof(struct smb2_sync_hdr));
-
 	shdr->ProtocolId = SMB2_PROTO_NUMBER;
 	shdr->StructureSize = cpu_to_le16(64);
 	shdr->Command = smb2_cmd;
@@ -149,7 +133,6 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	if (tcon->ses && tcon->ses->server && tcon->ses->server->sign)
 		shdr->Flags |= SMB2_FLAGS_SIGNED;
 out:
-	pdu->StructureSize2 = cpu_to_le16(parmsize);
 	return;
 }
 
@@ -290,6 +273,26 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	return rc;
 }
 
+static void
+fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon, void *buf,
+	       unsigned int *total_len)
+{
+	struct smb2_sync_pdu *spdu = (struct smb2_sync_pdu *)buf;
+	/* lookup word count ie StructureSize from table */
+	__u16 parmsize = smb2_req_struct_sizes[le16_to_cpu(smb2_command)];
+
+	/*
+	 * smaller than SMALL_BUFFER_SIZE but bigger than fixed area of
+	 * largest operations (Create)
+	 */
+	memset(buf, 0, 256);
+
+	smb2_hdr_assemble(&spdu->sync_hdr, smb2_command, tcon);
+	spdu->StructureSize2 = cpu_to_le16(parmsize);
+
+	*total_len = parmsize + sizeof(struct smb2_sync_hdr);
+}
+
 /*
  * Allocate and return pointer to an SMB request hdr, and set basic
  * SMB information in the SMB header. If the return code is zero, this
@@ -299,7 +302,9 @@ static int
 small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
 		void **request_buf)
 {
-	int rc = 0;
+	int rc;
+	unsigned int total_len;
+	struct smb2_pdu *pdu;
 
 	rc = smb2_reconnect(smb2_command, tcon);
 	if (rc)
@@ -312,7 +317,12 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
 		return -ENOMEM;
 	}
 
-	smb2_hdr_assemble((struct smb2_hdr *) *request_buf, smb2_command, tcon);
+	pdu = (struct smb2_pdu *)(*request_buf);
+
+	fill_small_buf(smb2_command, tcon, get_sync_hdr(pdu), &total_len);
+
+	/* Note this is only network field converted to big endian */
+	pdu->hdr.smb2_buf_length = cpu_to_be32(total_len);
 
 	if (tcon != NULL) {
 #ifdef CONFIG_CIFS_STATS2
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 8dd24b7..052342d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -117,6 +117,11 @@ struct smb2_sync_hdr {
 	__u8   Signature[16];
 } __packed;
 
+struct smb2_sync_pdu {
+	struct smb2_sync_hdr sync_hdr;
+	__le16 StructureSize2; /* size of wct area (varies, request specific) */
+} __packed;
+
 struct smb2_hdr {
 	__be32 smb2_buf_length;	/* big endian on wire */
 				/* length is only two or three bytes - with */
-- 
2.7.4
