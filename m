From: Peter Seiderer <ps.report-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v1] cifs: use server timestamp for ntlmv2 authentication
Date: Thu, 17 Sep 2015 21:40:12 +0200
Message-ID: <1442518812-30494-1-git-send-email-ps.report@gmx.net>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Linux cifs mount with ntlmssp against an Mac OS X (Yosemite
10.10.5) share fails in case the clocks differ more than +/-2h:

digest-service: digest-request: od failed with 2 proto=ntlmv2
digest-service: digest-request: kdc failed with -1561745592 proto=ntlmv2

Fix this by (re-)using the given server timestamp for the
ntlmv2 authentication (as Windows 7 does).

Signed-off-by: Peter Seiderer <ps.report-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/cifs/cifsencrypt.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index aa0dc25..e6bfa92 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -444,6 +444,48 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	return 0;
 }
 
+/* Server has provided av pairs/target info in the type 2 challenge
+ * packet and we have plucked it and stored within smb session.
+ * We parse that blob here to find the server given timestamp
+ * as part of ntlmv2 authentication (or local current time as
+ * default in case of failure)
+ */
+static u64
+find_timestamp(struct cifs_ses *ses)
+{
+	unsigned int attrsize;
+	unsigned int type;
+	unsigned int onesize = sizeof(struct ntlmssp2_name);
+	unsigned char *blobptr;
+	unsigned char *blobend;
+	struct ntlmssp2_name *attrptr;
+
+	if (!ses->auth_key.len || !ses->auth_key.response)
+		return 0;
+
+	blobptr = ses->auth_key.response;
+	blobend = blobptr + ses->auth_key.len;
+
+	while (blobptr + onesize < blobend) {
+		attrptr = (struct ntlmssp2_name *) blobptr;
+		type = le16_to_cpu(attrptr->type);
+		if (type == NTLMSSP_AV_EOL)
+			break;
+		blobptr += 2; /* advance attr type */
+		attrsize = le16_to_cpu(attrptr->length);
+		blobptr += 2; /* advance attr size */
+		if (blobptr + attrsize > blobend)
+			break;
+		if (type == NTLMSSP_AV_TIMESTAMP) {
+			if (attrsize == sizeof(u64))
+				return *((u64 *)blobptr);
+		}
+		blobptr += attrsize; /* advance attr value */
+	}
+
+	return cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
+}
+
 static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 			    const struct nls_table *nls_cp)
 {
@@ -641,6 +683,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	struct ntlmv2_resp *ntlmv2;
 	char ntlmv2_hash[16];
 	unsigned char *tiblob = NULL; /* target info blob */
+	u64 rsp_timestamp;
 
 	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED) {
 		if (!ses->domainName) {
@@ -659,6 +702,12 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		}
 	}
 
+	/* Must be within 5 minutes of the server (or in range +/-2h
+	 * in case of Mac OS X), so simply carry over server timestamp
+	 * (as Windows 7 does)
+	 */
+	rsp_timestamp = find_timestamp(ses);
+
 	baselen = CIFS_SESS_KEY_SIZE + sizeof(struct ntlmv2_resp);
 	tilen = ses->auth_key.len;
 	tiblob = ses->auth_key.response;
@@ -675,8 +724,8 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 			(ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 	ntlmv2->blob_signature = cpu_to_le32(0x00000101);
 	ntlmv2->reserved = 0;
-	/* Must be within 5 minutes of the server */
-	ntlmv2->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
+	ntlmv2->time = rsp_timestamp;
+
 	get_random_bytes(&ntlmv2->client_chal, sizeof(ntlmv2->client_chal));
 	ntlmv2->reserved2 = 0;
 
-- 
2.1.4
