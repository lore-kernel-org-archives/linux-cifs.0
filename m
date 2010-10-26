From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] [CIFS] NTLM auth and sign - minor error corrections and cleanup
Date: Tue, 26 Oct 2010 18:10:24 -0500
Message-ID: <1288134624-4390-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Minor cleanup - Fix spelling mistake, make meaningful (goto) label

In function setup_ntlmv2_rsp(), do not return 0 and leak memory,
let the tiblob get freed.

For function find_domain_name(), pass already available nls table pointer
instead of loading and unloading the table again in this function.

For ntlmv2, the case sensitive password length is the length of the
response, so subtract session key length (16 bytes) from the .len.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   15 ++++++---------
 fs/cifs/cifsglob.h    |    2 +-
 fs/cifs/connect.c     |    8 ++++----
 fs/cifs/sess.c        |    2 +-
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 9690887..17d603a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -391,7 +391,7 @@ build_avpair_blob(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
  * about target string i.e. for some, just user name might suffice.
  */
 static int
-find_domain_name(struct cifsSesInfo *ses)
+find_domain_name(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 {
 	unsigned int attrsize;
 	unsigned int type;
@@ -420,16 +420,13 @@ find_domain_name(struct cifsSesInfo *ses)
 			if (!attrsize)
 				break;
 			if (!ses->domainName) {
-				struct nls_table *default_nls;
 				ses->domainName =
 					kmalloc(attrsize + 1, GFP_KERNEL);
 				if (!ses->domainName)
 						return -ENOMEM;
-				default_nls = load_nls_default();
 				cifs_from_ucs2(ses->domainName,
 					(__le16 *)blobptr, attrsize, attrsize,
-					default_nls, false);
-				unload_nls(default_nls);
+					nls_cp, false);
 				break;
 			}
 		}
@@ -561,7 +558,7 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 
 	if (ses->server->secType == RawNTLMSSP) {
 		if (!ses->domainName) {
-			rc = find_domain_name(ses);
+			rc = find_domain_name(ses, nls_cp);
 			if (rc) {
 				cERROR(1, "error %d finding domain name", rc);
 				goto setup_ntlmv2_rsp_ret;
@@ -594,12 +591,14 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 
 	memcpy(ses->auth_key.response + baselen, ses->tiblob, ses->tilen);
 
-	/* calculate buf->ntlmv2_hash */
+	/* calculate ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
 	if (rc) {
 		cERROR(1, "could not get v2 hash rc %d", rc);
 		goto setup_ntlmv2_rsp_ret;
 	}
+
+	/* calculate first part of the client response (CR1) */
 	rc = CalcNTLMv2_response(ses);
 	if (rc) {
 		cERROR(1, "Could not calculate CR1  rc: %d", rc);
@@ -623,8 +622,6 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response);
 
-	return 0;
-
 setup_ntlmv2_rsp_ret:
 	kfree(ses->tiblob);
 	ses->tiblob = NULL;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7ca5f6d..67d6a22 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -111,7 +111,7 @@ struct sdesc {
 	char ctx[];
 };
 
-/* crypto hashing related structure/fields, not speicific to a sec mech */
+/* crypto hashing related structure/fields, not specific to a sec mech */
 struct cifs_secmech {
 	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
 	struct crypto_shash *md5; /* md5 hash function */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 04239a7..469c3dd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1631,7 +1631,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->hostname = extract_hostname(volume_info->UNC);
 	if (IS_ERR(tcp_ses->hostname)) {
 		rc = PTR_ERR(tcp_ses->hostname);
-		goto out_err2;
+		goto out_err_crypto_release;
 	}
 
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
@@ -1675,7 +1675,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	}
 	if (rc < 0) {
 		cERROR(1, "Error connecting to socket. Aborting operation");
-		goto out_err2;
+		goto out_err_crypto_release;
 	}
 
 	/*
@@ -1689,7 +1689,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		rc = PTR_ERR(tcp_ses->tsk);
 		cERROR(1, "error %d create cifsd thread", rc);
 		module_put(THIS_MODULE);
-		goto out_err2;
+		goto out_err_crypto_release;
 	}
 
 	/* thread spawned, put it on the list */
@@ -1701,7 +1701,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	return tcp_ses;
 
-out_err2:
+out_err_crypto_release:
 	cifs_crypto_shash_release(tcp_ses);
 
 out_err:
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d998c4f..e0515a6 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -738,7 +738,7 @@ ssetup_ntlmssp_authenticate:
 		 * assigned, tilen is 0 otherwise.
 		 */
 		pSMB->req_no_secext.CaseSensitivePasswordLength =
-			cpu_to_le16(ses->auth_key.len);
+			cpu_to_le16(ses->auth_key.len - CIFS_SESS_KEY_SIZE);
 
 		if (ses->capabilities & CAP_UNICODE) {
 			if (iov[0].iov_len % 2) {
-- 
1.6.0.2
