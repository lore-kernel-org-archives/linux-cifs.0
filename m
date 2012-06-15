From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove extraneous newlines from cERROR and cFYI calls
Date: Fri, 15 Jun 2012 08:53:42 -0400
Message-ID: <1339764822-24528-2-git-send-email-jlayton@redhat.com>
References: <1339764822-24528-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339764822-24528-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Those macros add a newline on their own, so there's not any need to
embed one in the message itself.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cache.c       |    2 +-
 fs/cifs/cifsacl.c     |    6 +++---
 fs/cifs/cifsencrypt.c |   48 ++++++++++++++++++++++++------------------------
 fs/cifs/cifssmb.c     |   10 +++++-----
 fs/cifs/connect.c     |   14 +++++++-------
 fs/cifs/file.c        |    2 +-
 fs/cifs/link.c        |   14 +++++++-------
 fs/cifs/smbencrypt.c  |   14 +++++++-------
 8 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index 545509c..282d6de 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -152,7 +152,7 @@ static uint16_t cifs_super_get_key(const void *cookie_netfs_data, void *buffer,
 
 	sharename = extract_sharename(tcon->treeName);
 	if (IS_ERR(sharename)) {
-		cFYI(1, "%s: couldn't extract sharename\n", __func__);
+		cFYI(1, "%s: couldn't extract sharename", __func__);
 		sharename = NULL;
 		return 0;
 	}
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 3cc1b25..1885da4 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -525,7 +525,7 @@ init_cifs_idmap(void)
 	struct key *keyring;
 	int ret;
 
-	cFYI(1, "Registering the %s key type\n", cifs_idmap_key_type.name);
+	cFYI(1, "Registering the %s key type", cifs_idmap_key_type.name);
 
 	/* create an override credential set with a special thread keyring in
 	 * which requests are cached
@@ -572,7 +572,7 @@ init_cifs_idmap(void)
 	sidgidtree = RB_ROOT;
 	register_shrinker(&cifs_shrinker);
 
-	cFYI(1, "cifs idmap keyring: %d\n", key_serial(keyring));
+	cFYI(1, "cifs idmap keyring: %d", key_serial(keyring));
 	return 0;
 
 failed_put_key:
@@ -589,7 +589,7 @@ exit_cifs_idmap(void)
 	unregister_key_type(&cifs_idmap_key_type);
 	put_cred(root_cred);
 	unregister_shrinker(&cifs_shrinker);
-	cFYI(1, "Unregistered %s key type\n", cifs_idmap_key_type.name);
+	cFYI(1, "Unregistered %s key type", cifs_idmap_key_type.name);
 }
 
 void
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 63c460e..db768cb 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -47,20 +47,20 @@ static int cifs_calc_signature(const struct kvec *iov, int n_vec,
 		return -EINVAL;
 
 	if (!server->secmech.sdescmd5) {
-		cERROR(1, "%s: Can't generate signature\n", __func__);
+		cERROR(1, "%s: Can't generate signature", __func__);
 		return -1;
 	}
 
 	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md5\n", __func__);
+		cERROR(1, "%s: Could not init md5", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
 		server->session_key.response, server->session_key.len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response\n", __func__);
+		cERROR(1, "%s: Could not update with response", __func__);
 		return rc;
 	}
 
@@ -85,7 +85,7 @@ static int cifs_calc_signature(const struct kvec *iov, int n_vec,
 				iov[i].iov_base, iov[i].iov_len);
 		}
 		if (rc) {
-			cERROR(1, "%s: Could not update with payload\n",
+			cERROR(1, "%s: Could not update with payload",
 							__func__);
 			return rc;
 		}
@@ -93,7 +93,7 @@ static int cifs_calc_signature(const struct kvec *iov, int n_vec,
 
 	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
+		cERROR(1, "%s: Could not generate md5 hash", __func__);
 
 	return rc;
 }
@@ -399,7 +399,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	wchar_t *server;
 
 	if (!ses->server->secmech.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash");
 		return -1;
 	}
 
@@ -415,7 +415,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "calc_ntlmv2_hash: could not init hmacmd5\n");
+		cERROR(1, "calc_ntlmv2_hash: could not init hmacmd5");
 		return rc;
 	}
 
@@ -423,7 +423,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
-		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure\n");
+		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure");
 		rc = -ENOMEM;
 		return rc;
 	}
@@ -439,7 +439,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 				(char *)user, 2 * len);
 	kfree(user);
 	if (rc) {
-		cERROR(1, "%s: Could not update with user\n", __func__);
+		cERROR(1, "%s: Could not update with user", __func__);
 		return rc;
 	}
 
@@ -460,7 +460,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 					(char *)domain, 2 * len);
 		kfree(domain);
 		if (rc) {
-			cERROR(1, "%s: Could not update with domain\n",
+			cERROR(1, "%s: Could not update with domain",
 								__func__);
 			return rc;
 		}
@@ -480,7 +480,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 					(char *)server, 2 * len);
 		kfree(server);
 		if (rc) {
-			cERROR(1, "%s: Could not update with server\n",
+			cERROR(1, "%s: Could not update with server",
 								__func__);
 			return rc;
 		}
@@ -489,7 +489,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 					ntlmv2_hash);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
+		cERROR(1, "%s: Could not generate md5 hash", __func__);
 
 	return rc;
 }
@@ -501,7 +501,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
 
 	if (!ses->server->secmech.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash");
 		return -1;
 	}
 
@@ -527,14 +527,14 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + offset, ses->auth_key.len - offset);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response\n", __func__);
+		cERROR(1, "%s: Could not update with response", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
+		cERROR(1, "%s: Could not generate md5 hash", __func__);
 
 	return rc;
 }
@@ -613,7 +613,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init hmacmd5\n", __func__);
+		cERROR(1, "%s: Could not init hmacmd5", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
@@ -621,14 +621,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE,
 		CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response\n", __func__);
+		cERROR(1, "%s: Could not update with response", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
+		cERROR(1, "%s: Could not generate md5 hash", __func__);
 
 setup_ntlmv2_rsp_ret:
 	kfree(tiblob);
@@ -650,7 +650,7 @@ calc_seckey(struct cifs_ses *ses)
 	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm_arc4)) {
 		rc = PTR_ERR(tfm_arc4);
-		cERROR(1, "could not allocate crypto API arc4\n");
+		cERROR(1, "could not allocate crypto API arc4");
 		return rc;
 	}
 
@@ -668,7 +668,7 @@ calc_seckey(struct cifs_ses *ses)
 
 	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPHTXT_SIZE);
 	if (rc) {
-		cERROR(1, "could not encrypt session key rc: %d\n", rc);
+		cERROR(1, "could not encrypt session key rc: %d", rc);
 		crypto_free_blkcipher(tfm_arc4);
 		return rc;
 	}
@@ -705,13 +705,13 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 
 	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
 	if (IS_ERR(server->secmech.hmacmd5)) {
-		cERROR(1, "could not allocate crypto hmacmd5\n");
+		cERROR(1, "could not allocate crypto hmacmd5");
 		return PTR_ERR(server->secmech.hmacmd5);
 	}
 
 	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(server->secmech.md5)) {
-		cERROR(1, "could not allocate crypto md5\n");
+		cERROR(1, "could not allocate crypto md5");
 		rc = PTR_ERR(server->secmech.md5);
 		goto crypto_allocate_md5_fail;
 	}
@@ -720,7 +720,7 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.hmacmd5);
 	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdeschmacmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5");
 		rc = -ENOMEM;
 		goto crypto_allocate_hmacmd5_sdesc_fail;
 	}
@@ -732,7 +732,7 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.md5);
 	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdescmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5\n");
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5");
 		rc = -ENOMEM;
 		goto crypto_allocate_md5_sdesc_fail;
 	}
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5b40073..0170ee8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4109,7 +4109,7 @@ UnixQFileInfoRetry:
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
+			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response. "
 				   "Unix Extensions can be disabled on mount "
 				   "by specifying the nosfu mount option.");
 			rc = -EIO;	/* bad smb */
@@ -4195,7 +4195,7 @@ UnixQPathInfoRetry:
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
+			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response. "
 				   "Unix Extensions can be disabled on mount "
 				   "by specifying the nosfu mount option.");
 			rc = -EIO;	/* bad smb */
@@ -4647,7 +4647,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 
 	if (*num_of_nodes < 1) {
 		cERROR(1, "num_referrals: must be at least > 0,"
-			"but we get num_referrals = %d\n", *num_of_nodes);
+			"but we get num_referrals = %d", *num_of_nodes);
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
@@ -4664,14 +4664,14 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	data_end = (char *)(&(pSMBr->PathConsumed)) +
 				le16_to_cpu(pSMBr->t2.DataCount);
 
-	cFYI(1, "num_referrals: %d dfs flags: 0x%x ...\n",
+	cFYI(1, "num_referrals: %d dfs flags: 0x%x ...",
 			*num_of_nodes,
 			le32_to_cpu(pSMBr->DFSFlags));
 
 	*target_nodes = kzalloc(sizeof(struct dfs_info3_param) *
 			*num_of_nodes, GFP_KERNEL);
 	if (*target_nodes == NULL) {
-		cERROR(1, "Failed to allocate buffer for target_nodes\n");
+		cERROR(1, "Failed to allocate buffer for target_nodes");
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 78db68a..de281d0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2410,7 +2410,7 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 	int xid;
 	struct TCP_Server_Info *server = ses->server;
 
-	cFYI(1, "%s: ses_count=%d\n", __func__, ses->ses_count);
+	cFYI(1, "%s: ses_count=%d", __func__, ses->ses_count);
 	spin_lock(&cifs_tcp_ses_lock);
 	if (--ses->ses_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -2698,7 +2698,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	int xid;
 	struct cifs_ses *ses = tcon->ses;
 
-	cFYI(1, "%s: tc_count=%d\n", __func__, tcon->tc_count);
+	cFYI(1, "%s: tc_count=%d", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
 	if (--tcon->tc_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -3007,11 +3007,11 @@ bind_socket(struct TCP_Server_Info *server)
 			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
 			if (saddr6->sin6_family == AF_INET6)
 				cERROR(1, "cifs: "
-				       "Failed to bind to: %pI6c, error: %d\n",
+				       "Failed to bind to: %pI6c, error: %d",
 				       &saddr6->sin6_addr, rc);
 			else
 				cERROR(1, "cifs: "
-				       "Failed to bind to: %pI4, error: %d\n",
+				       "Failed to bind to: %pI4, error: %d",
 				       &saddr4->sin_addr.s_addr, rc);
 		}
 	}
@@ -3302,9 +3302,9 @@ void reset_cifs_unix_caps(int xid, struct cifs_tcon *tcon,
 				cFYI(1, "resetting capabilities failed");
 			} else
 				cERROR(1, "Negotiating Unix capabilities "
-					   "with the server failed.  Consider "
-					   "mounting with the Unix Extensions\n"
-					   "disabled, if problems are found, "
+					   "with the server failed. Consider "
+					   "mounting with the Unix Extensions "
+					   "disabled if problems are found "
 					   "by specifying the nounix mount "
 					   "option.");
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 513adbc..dd28caa 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3169,7 +3169,7 @@ static int cifs_readpage(struct file *file, struct page *page)
 		return rc;
 	}
 
-	cFYI(1, "readpage %p at offset %d 0x%x\n",
+	cFYI(1, "readpage %p at offset %d 0x%x",
 		 page, (int)offset, (int)offset);
 
 	rc = cifs_readpage_worker(file, page, &offset);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 6b0e064..90d8add 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -56,14 +56,14 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 	md5 = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(md5)) {
 		rc = PTR_ERR(md5);
-		cERROR(1, "%s: Crypto md5 allocation error %d\n", __func__, rc);
+		cERROR(1, "%s: Crypto md5 allocation error %d", __func__, rc);
 		return rc;
 	}
 	size = sizeof(struct shash_desc) + crypto_shash_descsize(md5);
 	sdescmd5 = kmalloc(size, GFP_KERNEL);
 	if (!sdescmd5) {
 		rc = -ENOMEM;
-		cERROR(1, "%s: Memory allocation failure\n", __func__);
+		cERROR(1, "%s: Memory allocation failure", __func__);
 		goto symlink_hash_err;
 	}
 	sdescmd5->shash.tfm = md5;
@@ -71,17 +71,17 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 
 	rc = crypto_shash_init(&sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md5 shash\n", __func__);
+		cERROR(1, "%s: Could not init md5 shash", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_update(&sdescmd5->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update iwth link_str\n", __func__);
+		cERROR(1, "%s: Could not update iwth link_str", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
+		cERROR(1, "%s: Could not generate md5 hash", __func__);
 
 symlink_hash_err:
 	crypto_free_shash(md5);
@@ -115,7 +115,7 @@ CIFSParseMFSymlink(const u8 *buf,
 
 	rc = symlink_hash(link_len, link_str, md5_hash);
 	if (rc) {
-		cFYI(1, "%s: MD5 hash failure: %d\n", __func__, rc);
+		cFYI(1, "%s: MD5 hash failure: %d", __func__, rc);
 		return rc;
 	}
 
@@ -154,7 +154,7 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
 
 	rc = symlink_hash(link_len, link_str, md5_hash);
 	if (rc) {
-		cFYI(1, "%s: MD5 hash failure: %d\n", __func__, rc);
+		cFYI(1, "%s: MD5 hash failure: %d", __func__, rc);
 		return rc;
 	}
 
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index d5cd9aa..a0a58fb 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -78,7 +78,7 @@ smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 	tfm_des = crypto_alloc_blkcipher("ecb(des)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm_des)) {
 		rc = PTR_ERR(tfm_des);
-		cERROR(1, "could not allocate des crypto API\n");
+		cERROR(1, "could not allocate des crypto API");
 		goto smbhash_err;
 	}
 
@@ -91,7 +91,7 @@ smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 
 	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, 8);
 	if (rc)
-		cERROR(1, "could not encrypt crypt key rc: %d\n", rc);
+		cERROR(1, "could not encrypt crypt key rc: %d", rc);
 
 	crypto_free_blkcipher(tfm_des);
 smbhash_err:
@@ -139,14 +139,14 @@ mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 	md4 = crypto_alloc_shash("md4", 0, 0);
 	if (IS_ERR(md4)) {
 		rc = PTR_ERR(md4);
-		cERROR(1, "%s: Crypto md4 allocation error %d\n", __func__, rc);
+		cERROR(1, "%s: Crypto md4 allocation error %d", __func__, rc);
 		return rc;
 	}
 	size = sizeof(struct shash_desc) + crypto_shash_descsize(md4);
 	sdescmd4 = kmalloc(size, GFP_KERNEL);
 	if (!sdescmd4) {
 		rc = -ENOMEM;
-		cERROR(1, "%s: Memory allocation failure\n", __func__);
+		cERROR(1, "%s: Memory allocation failure", __func__);
 		goto mdfour_err;
 	}
 	sdescmd4->shash.tfm = md4;
@@ -154,17 +154,17 @@ mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 
 	rc = crypto_shash_init(&sdescmd4->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md4 shash\n", __func__);
+		cERROR(1, "%s: Could not init md4 shash", __func__);
 		goto mdfour_err;
 	}
 	rc = crypto_shash_update(&sdescmd4->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with link_str\n", __func__);
+		cERROR(1, "%s: Could not update with link_str", __func__);
 		goto mdfour_err;
 	}
 	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
 	if (rc)
-		cERROR(1, "%s: Could not genereate md4 hash\n", __func__);
+		cERROR(1, "%s: Could not genereate md4 hash", __func__);
 
 mdfour_err:
 	crypto_free_shash(md4);
-- 
1.7.7.6
