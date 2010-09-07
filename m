From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] define, declare, and use crypto sync hash structures
Date: Mon,  6 Sep 2010 22:34:27 -0500
Message-ID: <1283830467-25062-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsglob.h    |    2 +
 fs/cifs/cifsproto.h   |    2 +
 fs/cifs/connect.c     |   16 +++++++++--
 4 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 4f85651..fe1e4c9 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -369,3 +369,74 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
 	hmac_md5_final(v2_session_response, &context);
 /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
 }
+
+void
+cifs_crypto_shash_release(struct TCP_Server_Info *server)
+{
+	if (server->ntlmssp.md5)
+		crypto_free_shash(server->ntlmssp.md5);
+
+	if (server->ntlmssp.hmacmd5)
+		crypto_free_shash(server->ntlmssp.hmacmd5);
+
+	kfree(server->ntlmssp.sdeschmacmd5);
+
+	kfree(server->ntlmssp.sdescmd5);
+}
+
+int
+cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
+{
+	int rc;
+	unsigned int size;
+
+	server->ntlmssp.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
+	if (!server->ntlmssp.hmacmd5 ||
+			IS_ERR(server->ntlmssp.hmacmd5)) {
+		cERROR(1, "could not allocate crypto hmacmd5\n");
+		return 1;
+	}
+
+	server->ntlmssp.md5 = crypto_alloc_shash("md5", 0, 0);
+	if (!server->ntlmssp.md5 || IS_ERR(server->ntlmssp.md5)) {
+		cERROR(1, "could not allocate crypto md5\n");
+		rc = 1;
+		goto cifs_crypto_shash_allocate_ret1;
+	}
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->ntlmssp.hmacmd5);
+	server->ntlmssp.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
+		rc = -ENOMEM;
+		goto cifs_crypto_shash_allocate_ret2;
+	}
+	server->ntlmssp.sdeschmacmd5->shash.tfm = server->ntlmssp.hmacmd5;
+	server->ntlmssp.sdeschmacmd5->shash.flags = 0x0;
+
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->ntlmssp.md5);
+	server->ntlmssp.sdescmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->ntlmssp.sdescmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5\n");
+		rc = -ENOMEM;
+		goto cifs_crypto_shash_allocate_ret3;
+	}
+	server->ntlmssp.sdescmd5->shash.tfm = server->ntlmssp.md5;
+	server->ntlmssp.sdescmd5->shash.flags = 0x0;
+
+	return 0;
+
+cifs_crypto_shash_allocate_ret3:
+	kfree(server->ntlmssp.sdeschmacmd5);
+
+cifs_crypto_shash_allocate_ret2:
+	crypto_free_shash(server->ntlmssp.md5);
+
+cifs_crypto_shash_allocate_ret1:
+	crypto_free_shash(server->ntlmssp.hmacmd5);
+
+	return rc;
+}
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6e35655..6b7249e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -135,6 +135,8 @@ struct ntlmssp_auth {
 	unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to server */
 	struct crypto_shash *hmacmd5; /* to generate ntlmv2 hash, CR1 etc. */
 	struct crypto_shash *md5; /* to generate cifs/smb signature */
+	struct sdesc *sdeschmacmd5;
+	struct sdesc *sdescmd5;
 };
 
 /*
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8d63406..f3ffa69 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -370,6 +370,8 @@ extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
 extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
 extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
 			     const struct nls_table *);
+extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
+extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern void calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0ea52e9..f5369e7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1520,6 +1520,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
 
+	cifs_crypto_shash_release(server);
 	cifs_fscache_release_client_cookie(server);
 
 	task = xchg(&server->tsk, NULL);
@@ -1574,10 +1575,16 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err;
 	}
 
+	rc = cifs_crypto_shash_allocate(tcp_ses);
+	if (rc) {
+		cERROR(1, "could not setup hash structures rc %d", rc);
+		goto out_err;
+	}
+
 	tcp_ses->hostname = extract_hostname(volume_info->UNC);
 	if (IS_ERR(tcp_ses->hostname)) {
 		rc = PTR_ERR(tcp_ses->hostname);
-		goto out_err;
+		goto out_err2;
 	}
 
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
@@ -1618,7 +1625,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	}
 	if (rc < 0) {
 		cERROR(1, "Error connecting to socket. Aborting operation");
-		goto out_err;
+		goto out_err2;
 	}
 
 	/*
@@ -1632,7 +1639,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		rc = PTR_ERR(tcp_ses->tsk);
 		cERROR(1, "error %d create cifsd thread", rc);
 		module_put(THIS_MODULE);
-		goto out_err;
+		goto out_err2;
 	}
 
 	/* thread spawned, put it on the list */
@@ -1644,6 +1651,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	return tcp_ses;
 
+out_err2:
+	cifs_crypto_shash_release(tcp_ses);
+
 out_err:
 	if (tcp_ses) {
 		if (!IS_ERR(tcp_ses->hostname))
-- 
1.6.0.2
