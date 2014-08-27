From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2] cifs: set client time as MsvAvTimestamp from
 CHALLENGE_MESSAGE.TargetInfo
Date: Wed, 27 Aug 2014 09:02:22 +0900
Message-ID: <002501cfc18a$2d020b30$87062190$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Windows machine has extended security feature which refuse to allow
authentication when there is time difference between server time and
client time when ntlmv2 negotiation is used. This problem is prevalent
in embedded enviornment where system time is set to default 1970.

Modern servers send the server timestamp in the TargetInfo Av_Pair
structure in the challenge message [see MS-NLMP 2.2.2.1]
In [MS-NLMP 3.1.5.1.2] it is explicitly mentioned that the client must
use the server provided timestamp if present OR current time if it is
not

This behavior is so far only observed for windows server and does not
effect samba server.

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    6 ++++--
 fs/cifs/cifsglob.h    |    2 ++
 fs/cifs/sess.c        |   19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 4934347..3ec44f8 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -671,8 +671,10 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 			(ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 	ntlmv2->blob_signature = cpu_to_le32(0x00000101);
 	ntlmv2->reserved = 0;
-	/* Must be within 5 minutes of the server */
-	ntlmv2->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
+	if (ses->serverTime)
+		ntlmv2->time = ses->serverTime;
+	else
+		ntlmv2->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
 	get_random_bytes(&ntlmv2->client_chal, sizeof(ntlmv2->client_chal));
 	ntlmv2->reserved2 = 0;
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ce24c1f..1102822 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -796,6 +796,8 @@ struct cifs_ses {
 	enum securityEnum sectype; /* what security flavor was specified? */
 	bool sign;		/* is signing required? */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
+	__u64   serverTime;	/* Keeps a track of server time sent by server
+				   during NTLM challenge in little endian */
 #ifdef CONFIG_CIFS_SMB2
 	__u16 session_flags;
 	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 07fe97a..944750c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -277,6 +277,24 @@ static void decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	cifs_dbg(FYI, "ascii: bytes left %d\n", bleft);
 }
 
+static void
+get_ntlmv2_server_time(struct cifs_ses *ses)
+{
+	char *payload = ses->auth_key.response;
+	u16 AvId, AvLen;
+
+	do {
+		AvId = le16_to_cpu(*payload);
+		AvLen = le16_to_cpu(*(payload + sizeof(u16)));
+		payload += AvLen + (2 * sizeof(u16));
+	} while (AvId != NTLMSSP_AV_TIMESTAMP && AvId != NTLMSSP_AV_EOL);
+
+	if (AvId == NTLMSSP_AV_TIMESTAMP)
+		memcpy(&(ses->serverTime), (payload - AvLen), sizeof(__u64));
+	else
+		ses->serverTime = 0;
+}
+
 int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 				    struct cifs_ses *ses)
 {
@@ -322,6 +340,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 			return -ENOMEM;
 		}
 		ses->auth_key.len = tilen;
+		get_ntlmv2_server_time(ses);
 	}
 
 	return 0;
-- 
1.7.7
