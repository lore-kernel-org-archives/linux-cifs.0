From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] Revert "missing changes during ntlmv2/ntlmssp auth and sign"
Date: Wed,  1 Sep 2010 21:37:34 -0400
Message-ID: <1283391455-6848-6-git-send-email-jlayton@redhat.com>
References: <1283391455-6848-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283391455-6848-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This reverts commit 3ec6bbcdb4e85403f2c5958876ca9492afdf4031.
---
 fs/cifs/cifsencrypt.c |    2 --
 fs/cifs/sess.c        |   13 +++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index eef78c2..051d000 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -553,8 +553,6 @@ calc_seckey(struct TCP_Server_Info *server)
 		return 1;
 	}
 
-	desc.tfm = tfm_arc4;
-
 	crypto_blkcipher_setkey(tfm_arc4,
 		server->session_key.data.ntlmv2.key, CIFS_CPHTXT_SIZE);
 	sg_init_one(&sgin, sec_key, CIFS_CPHTXT_SIZE);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 4788e16..41fc532 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -408,8 +408,6 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
 		we must set the MIC field of the AUTHENTICATE_MESSAGE */
 
-	ses->server->ntlmssp.server_flags = le32_to_cpu(pblob->NegotiateFlags);
-
 	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
 	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
 	ses->server->tilen = tilen;
@@ -442,13 +440,12 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	/* BB is NTLMV2 session security format easier to use here? */
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NTLM;
+		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->secMode &
-	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
-		flags |= NTLMSSP_NEGOTIATE_SIGN |
-			NTLMSSP_NEGOTIATE_KEY_XCH |
-			NTLMSSP_NEGOTIATE_EXTENDED_SEC;
-	}
+	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+		flags |= NTLMSSP_NEGOTIATE_SIGN;
+	if (ses->server->secMode & SECMODE_SIGN_REQUIRED)
+		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
 
 	sec_blob->NegotiateFlags |= cpu_to_le32(flags);
 
-- 
1.7.2.2
