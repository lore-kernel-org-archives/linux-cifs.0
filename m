From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/7 cifs] ntlm authentication and signing - Build a proper av/ti pair blob for ntlmv2 without extended security authentication
Date: Mon,  4 Oct 2010 20:19:59 -0500
Message-ID: <1286241599-30895-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Build a av pair blob as part of ntlmv2 (without extended security) auth
request.  Include netbios and dns names for domain and server and
a timestamp in the blob.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   89 +++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 730038a..6dcbff3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -263,27 +263,94 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 }
 #endif /* CIFS_WEAK_PW_HASH */
 
-/* This is just a filler for ntlmv2 type of security mechanisms.
- * Older servers are not very particular about the contents of av pairs
- * in the blob and for sec mechs like ntlmv2, there is no negotiation
- * as in ntlmssp, so unless domain and server  netbios and dns names
- * are specified, there is no way to obtain name.  In case of ntlmssp,
- * server provides that info in type 2 challenge packet
+/* Build a proper attribute value/target info pairs blob.
+ * Fill in netbios and dns domain name and workstation name
+ * and client time (total five av pairs and + one end of fields indicator.
+ * Allocate domain name which gets freed when session struct is deallocated.
  */
 static int
-build_avpair_blob(struct cifsSesInfo *ses)
+build_avpair_blob(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 {
+	unsigned int dlen;
+	unsigned int wlen;
+	unsigned int size = 6 * sizeof(struct ntlmssp2_name);
+	__le64  curtime;
+	char *defdmname = "WORKGROUP";
+	unsigned char *blobptr;
 	struct ntlmssp2_name *attrptr;
 
-	ses->tilen = 2 * sizeof(struct ntlmssp2_name);
+	if (ses->domainName)
+		dlen = strlen(ses->domainName);
+	else  {
+		dlen = strlen(defdmname);
+		ses->domainName = kmalloc(dlen + 1, GFP_KERNEL);
+		if (!ses->domainName)
+			return -ENOMEM;
+		strcpy(ses->domainName, defdmname);
+	}
+
+	wlen = strlen(ses->server->hostname);
+
+	/* The length of this blob is a size which is
+	 * six times the size of a structure which holds name/size +
+	 * two times the unicode length of a domain name +
+	 * two times the unicode length of a server name +
+	 * size of a timestamp (which is 8 bytes).
+	 */
+	ses->tilen = size + 2 * (2 * dlen) + 2 * (2 * wlen) + 8;
 	ses->tiblob = kzalloc(ses->tilen, GFP_KERNEL);
 	if (!ses->tiblob) {
 		ses->tilen = 0;
 		cERROR(1, "Challenge target info allocation failure");
 		return -ENOMEM;
 	}
-	attrptr = (struct ntlmssp2_name *) ses->tiblob;
-	attrptr->type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
+
+	blobptr = ses->tiblob;
+	attrptr = (struct ntlmssp2_name *) blobptr;
+
+	attrptr->type = cpu_to_le16(NTLMSSP_AV_NB_DOMAIN_NAME);
+	attrptr->length = cpu_to_le16(2 * dlen);
+	blobptr = (unsigned char *)attrptr + sizeof(struct ntlmssp2_name);
+	if (ses->domainName)
+		cifs_strtoUCS((__le16 *)blobptr, ses->domainName, dlen, nls_cp);
+	else
+		cifs_strtoUCS((__le16 *)blobptr, defdmname, dlen, nls_cp);
+
+	blobptr += 2 * dlen;
+	attrptr = (struct ntlmssp2_name *) blobptr;
+
+	attrptr->type = cpu_to_le16(NTLMSSP_AV_NB_COMPUTER_NAME);
+	attrptr->length = cpu_to_le16(2 * wlen);
+	blobptr = (unsigned char *)attrptr + sizeof(struct ntlmssp2_name);
+	cifs_strtoUCS((__le16 *)blobptr, ses->server->hostname, wlen, nls_cp);
+
+	blobptr += 2 * wlen;
+	attrptr = (struct ntlmssp2_name *) blobptr;
+
+	attrptr->type = cpu_to_le16(NTLMSSP_AV_DNS_DOMAIN_NAME);
+	attrptr->length = cpu_to_le16(2 * dlen);
+	blobptr = (unsigned char *)attrptr + sizeof(struct ntlmssp2_name);
+	if (ses->domainName)
+		cifs_strtoUCS((__le16 *)blobptr, ses->domainName, dlen, nls_cp);
+	else
+		cifs_strtoUCS((__le16 *)blobptr, defdmname, dlen, nls_cp);
+
+	blobptr += 2 * dlen;
+	attrptr = (struct ntlmssp2_name *) blobptr;
+
+	attrptr->type = cpu_to_le16(NTLMSSP_AV_DNS_COMPUTER_NAME);
+	attrptr->length = cpu_to_le16(2 * wlen);
+	blobptr = (unsigned char *)attrptr + sizeof(struct ntlmssp2_name);
+	cifs_strtoUCS((__le16 *)blobptr, ses->server->hostname, wlen, nls_cp);
+
+	blobptr += 2 * wlen;
+	attrptr = (struct ntlmssp2_name *) blobptr;
+
+	attrptr->type = cpu_to_le16(NTLMSSP_AV_TIMESTAMP);
+	attrptr->length = cpu_to_le16(sizeof(__le64));
+	blobptr = (unsigned char *)attrptr + sizeof(struct ntlmssp2_name);
+	curtime = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
+	memcpy(blobptr, &curtime, sizeof(__le64));
 
 	return 0;
 }
@@ -426,7 +493,7 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 			}
 		}
 	} else {
-		rc = build_avpair_blob(ses);
+		rc = build_avpair_blob(ses, nls_cp);
 		if (rc) {
 			cERROR(1, "error %d building av pair blob", rc);
 			return rc;
-- 
1.6.0.2
