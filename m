From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH -v2 1/6] functions to either extract or create av_ pair/ti_info blob
Date: Mon, 14 Feb 2011 23:19:07 -0600
Message-ID: <1297747147-18066-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Attribue Value (AV) pairs or Target Info (TI) pairs are part of
ntlmv2 authentication.
Structure ntlmv2_resp had only definition for two av pairs.
So removed it, and now allocation of av pairs is dynamic.
For servers like Windows 7/2008, av pairs sent by server in
challege packet (type 2 in the ntlmssp exchange/negotiation) can
vary.

Server sends them during ntlmssp negotiation. So when ntlmssp is used
as an authentication mechanism, type 2 challenge packet from server
has this information.  Pluck it and use the entire blob for
authenticaiton purpose.  If user has not specified, extract
(netbios) domain name from the av pairs which is used to calculate
ntlmv2 hash.  Servers like Windows 7 are particular about the AV pair
blob.

Servers like Windows 2003, are not very strict about the contents
of av pair blob used during ntlmv2 authentication.
So when security mechanism such as ntlmv2 is used (not ntlmv2 in ntlmssp),
there is no negotiation and so genereate a minimal blob that gets
used in ntlmv2 authentication as well as gets sent.

Fields tilen and tilbob are session specific.  AV pair values are defined.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/cifsglob.h    |    2 +
 fs/cifs/cifspdu.h     |    1 -
 fs/cifs/connect.c     |    2 +
 fs/cifs/ntlmssp.h     |   15 +++++++++
 fs/cifs/sess.c        |   15 +++++++++
 6 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 35042d8..a547d24 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -27,6 +27,7 @@
 #include "md5.h"
 #include "cifs_unicode.h"
 #include "cifsproto.h"
+#include "ntlmssp.h"
 #include <linux/ctype.h>
 #include <linux/random.h>
 
@@ -262,6 +263,79 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 }
 #endif /* CIFS_WEAK_PW_HASH */
 
+/* This is just a filler for ntlmv2 type of security mechanisms.
+ * Older servers are not very particular about the contents of av pairs
+ * in the blob and for sec mechs like ntlmv2, there is no negotiation
+ * as in ntlmssp, so unless domain and server  netbios and dns names
+ * are specified, there is no way to obtain name.  In case of ntlmssp,
+ * server provides that info in type 2 challenge packet
+ */
+static int
+build_avpair_blob(struct cifsSesInfo *ses)
+{
+	struct ntlmssp2_name *attrptr;
+
+	ses->tilen = 2 * sizeof(struct ntlmssp2_name);
+	ses->tiblob = kzalloc(ses->tilen, GFP_KERNEL);
+	if (!ses->tiblob) {
+		ses->tilen = 0;
+		cERROR(1, "Challenge target info allocation failure");
+		return -ENOMEM;
+	}
+	attrptr = (struct ntlmssp2_name *) ses->tiblob;
+	attrptr->type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
+
+	return 0;
+}
+
+/* Server has provided av pairs/target info in the type 2 challenge
+ * packet and we have plucked it and stored within smb session.
+ * We parse that blob here to find netbios domain name to be used
+ * as part of ntlmv2 authentication (in Target String), if not already
+ * specified on the command line.
+ */
+static int
+find_domain_name(struct cifsSesInfo *ses)
+{
+	int rc = 0;
+	unsigned int attrsize;
+	unsigned int type;
+	unsigned char *blobptr;
+	unsigned char *blobend;
+	struct ntlmssp2_name *attrptr;
+
+	if (ses->tiblob) {
+		blobend = ses->tiblob + ses->tilen;
+		blobptr = ses->tiblob;
+		attrptr = (struct ntlmssp2_name *) blobptr;
+
+		while (blobptr <= blobend &&
+				(type = attrptr->type) != NTLMSSP_AV_EOL) {
+			blobptr += 2; /* advance attr type */
+			attrsize = attrptr->length;
+			blobptr += 2; /* advance attr size */
+			if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
+				if (!ses->domainName) {
+					ses->domainName =
+						kmalloc(attrptr->length + 1,
+								GFP_KERNEL);
+					if (!ses->domainName)
+							return -ENOMEM;
+					cifs_from_ucs2(ses->domainName,
+						(__le16 *)blobptr,
+						attrptr->length,
+						attrptr->length,
+						load_nls_default(), false);
+				}
+			}
+			blobptr += attrsize; /* advance attr  value */
+			attrptr = (struct ntlmssp2_name *) blobptr;
+		}
+	}
+
+	return rc;
+}
+
 static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 			    const struct nls_table *nls_cp)
 {
@@ -333,10 +407,6 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
 	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
 	buf->reserved2 = 0;
-	buf->names[0].type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
-	buf->names[0].length = 0;
-	buf->names[1].type = 0;
-	buf->names[1].length = 0;
 
 	/* calculate buf->ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0cdfb8c..2bfe682 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -222,6 +222,8 @@ struct cifsSesInfo {
 	char userName[MAX_USERNAME_SIZE + 1];
 	char *domainName;
 	char *password;
+	unsigned int tilen; /* length of the target info blob */
+	unsigned char *tiblob; /* target info blob in challenge response */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 };
 /* no more than one of the following three session flags may be set */
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 14d036d..b0f4b56 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -663,7 +663,6 @@ struct ntlmv2_resp {
 	__le64  time;
 	__u64  client_chal; /* random */
 	__u32  reserved2;
-	struct ntlmssp2_name names[2];
 	/* array of name entries could follow ending in minimum 4 byte struct */
 } __attribute__((packed));
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 67dad54..f8891a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1740,6 +1740,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	if (ses == NULL)
 		goto get_ses_fail;
 
+	ses->tilen = 0;
+	ses->tiblob = NULL;
 	/* new SMB session uses our server ref */
 	ses->server = server;
 	if (server->addr.sockAddr6.sin6_family == AF_INET6)
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 49c9a4e..5d52e4a 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -61,6 +61,21 @@
 #define NTLMSSP_NEGOTIATE_KEY_XCH   0x40000000
 #define NTLMSSP_NEGOTIATE_56        0x80000000
 
+/* Define AV Pair Field IDs */
+enum av_field_type {
+	NTLMSSP_AV_EOL = 0,
+	NTLMSSP_AV_NB_COMPUTER_NAME,
+	NTLMSSP_AV_NB_DOMAIN_NAME,
+	NTLMSSP_AV_DNS_COMPUTER_NAME,
+	NTLMSSP_AV_DNS_DOMAIN_NAME,
+	NTLMSSP_AV_DNS_TREE_NAME,
+	NTLMSSP_AV_FLAGS,
+	NTLMSSP_AV_TIMESTAMP,
+	NTLMSSP_AV_RESTRICTION,
+	NTLMSSP_AV_TARGET_NAME,
+	NTLMSSP_AV_CHANNEL_BINDINGS
+};
+
 /* Although typedefs are not commonly used for structure definitions */
 /* in the Linux kernel, in this particular case they are useful      */
 /* to more closely match the standards document for NTLMSSP from     */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0a57cb7..2de5f08 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
 static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 				    struct cifsSesInfo *ses)
 {
+	unsigned int tioffset; /* challenge message target info area */
+	unsigned int tilen; /* challenge message target info area length  */
+
 	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
 
 	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
@@ -405,6 +408,18 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
 		we must set the MIC field of the AUTHENTICATE_MESSAGE */
 
+	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
+	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
+	ses->tilen = tilen;
+	if (ses->tilen) {
+		ses->tiblob = kmalloc(tilen, GFP_KERNEL);
+		if (!ses->tiblob) {
+			cERROR(1, "Challenge target info allocation failure");
+			return -ENOMEM;
+		}
+		memcpy(ses->tiblob,  bcc_ptr + tioffset, ses->tilen);
+	}
+
 	return 0;
 }
 
-- 
1.6.0.2
