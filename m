Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F831E4BE
	for <linux-cifs@vger.kernel.org>; Fri, 25 Jul 2025 03:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753413440; cv=none; b=lcNRVqWntYoJEhkQaM/WPCDlRbP8MJKEImo3QGoe3GvDaf0YBHgBNysWuZuWLNYtU4LOpgVYr5+7xNwrDcO0vrV2rn9Owit+zdca7ZlzZFaM5sIJzOjOqXSv8zUv11dZIVa0kx4LZFIHuyDcfcITT6uowTwP6eAq3cUiaKtl1Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753413440; c=relaxed/simple;
	bh=lpQM7U7tVI9UYBKX33+1qXrghOVzojAGnup+VqhwW8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8+o91qvQE+GEf8+3deUuXmvIBTFwnZfc8wJnNbHop/iA7CRHlh4BHJ5M5+QEDUQNPPoajS2/u20pcWC+0/MxqMOQ18uzVsMwWdU7Qwn4ZNHJSnLyo4IrXV42ck/SrmbhjcmLcYR9nSoqCZp/nR8SmdYXXCUMVjwCzcRGS+ts7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=rCDyuK80; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="rCDyuK80"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=3gUUDdvpYnUcCVbZmsVeJHxAUaJv4ezkw8u1FPvgv9Q=; b=rCDyuK80IVwmY5TJ90ehlLU5ew
	9ONyRSMtkS9MKBL4DEZfsl0PJUxdV82glVtMbAKYHvWwrFIGZV3lOkJI2m7UQVDhUJwsLEs904SMH
	/DvvHkCTxFHFbAkFBiuN9b/H+eiT9/8LZ964jijjhnb3m8tI9nRrBM9G+gJLwT5JIw+JqCB3QmiYv
	2/sIu8CTwOC277pBTvJBF9hxDY1jF0o7XHB3xnjonJcGeBZgIgK/qTKV1BKYpc+aVEQLRXryWCm5I
	RU0kWtVBogNK5+dK5FYhSnbQvxw0rJjrx7/Cmd97YdqplHoeSPCnVhIRz7CVx+7FPhpQ3Di8hHDcF
	Q5Os4ClQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uf8k0-00000000Mlw-1OhH;
	Fri, 25 Jul 2025 00:05:00 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH 2/2] smb: client: fix session setup against servers that require SPN
Date: Fri, 25 Jul 2025 00:04:44 -0300
Message-ID: <20250725030444.1851761-2-pc@manguebit.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725030444.1851761-1-pc@manguebit.org>
References: <20250725030444.1851761-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some servers might enforce the SPN to be set in the target info
blob (AV pairs) when sending NTLMSSP_AUTH message.  In Windows Server,
this could be enforced with SmbServerNameHardeningLevel set to 2.

Fix this by always appending SPN (cifs/<hostname>) to the existing
list of target infos when setting up NTLMv2 response blob.

Cc: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Reported-by: Pierguido Lambri <plambri@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/cifsencrypt.c | 79 ++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 6be850d2a346..3cc686246908 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -532,17 +532,67 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash, struct shash_
 	return rc;
 }
 
+/*
+ * Set up NTLMv2 response blob with SPN (cifs/<hostname>) appended to the
+ * existing list of AV pairs.
+ */
+static int set_auth_key_response(struct cifs_ses *ses)
+{
+	size_t baselen = CIFS_SESS_KEY_SIZE + sizeof(struct ntlmv2_resp);
+	size_t len, spnlen, tilen = 0, num_avs = 2 /* SPN + EOL */;
+	struct TCP_Server_Info *server = ses->server;
+	char *spn __free(kfree) = NULL;
+	struct ntlmssp2_name *av;
+	char *rsp = NULL;
+	int rc;
+
+	spnlen = strlen(server->hostname);
+	len = sizeof("cifs/") + spnlen;
+	spn = kmalloc(len, GFP_KERNEL);
+	if (!spn) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	spnlen = scnprintf(spn, len, "cifs/%.*s",
+			   (int)spnlen, server->hostname);
+
+	av_for_each_entry(ses, av)
+		tilen += sizeof(*av) + AV_LEN(av);
+
+	len = baselen + tilen + spnlen * sizeof(__le16) + num_avs * sizeof(*av);
+	rsp = kmalloc(len, GFP_KERNEL);
+	if (!rsp) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(rsp + baselen, ses->auth_key.response, tilen);
+	av = (void *)(rsp + baselen + tilen);
+	av->type = cpu_to_le16(NTLMSSP_AV_TARGET_NAME);
+	av->length = cpu_to_le16(spnlen * sizeof(__le16));
+	cifs_strtoUTF16((__le16 *)av->data, spn, spnlen, ses->local_nls);
+	av = (void *)((__u8 *)av + sizeof(*av) + AV_LEN(av));
+	av->type = cpu_to_le16(NTLMSSP_AV_EOL);
+	av->length = 0;
+
+	rc = 0;
+	ses->auth_key.len = len;
+out:
+	ses->auth_key.response = rsp;
+	return rc;
+}
+
 int
 setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 {
 	struct shash_desc *hmacmd5 = NULL;
-	int rc;
-	int baselen;
-	unsigned int tilen;
+	unsigned char *tiblob = NULL; /* target info blob */
 	struct ntlmv2_resp *ntlmv2;
 	char ntlmv2_hash[16];
-	unsigned char *tiblob = NULL; /* target info blob */
 	__le64 rsp_timestamp;
+	__u64 cc;
+	int rc;
 
 	if (nls_cp == NULL) {
 		cifs_dbg(VFS, "%s called with nls_cp==NULL\n", __func__);
@@ -588,32 +638,25 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	 * (as Windows 7 does)
 	 */
 	rsp_timestamp = find_timestamp(ses);
+	get_random_bytes(&cc, sizeof(cc));
+
+	cifs_server_lock(ses->server);
 
-	baselen = CIFS_SESS_KEY_SIZE + sizeof(struct ntlmv2_resp);
-	tilen = ses->auth_key.len;
 	tiblob = ses->auth_key.response;
-
-	ses->auth_key.response = kmalloc(baselen + tilen, GFP_KERNEL);
-	if (!ses->auth_key.response) {
-		rc = -ENOMEM;
+	rc = set_auth_key_response(ses);
+	if (rc) {
 		ses->auth_key.len = 0;
-		goto setup_ntlmv2_rsp_ret;
+		goto unlock;
 	}
-	ses->auth_key.len += baselen;
 
 	ntlmv2 = (struct ntlmv2_resp *)
 			(ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 	ntlmv2->blob_signature = cpu_to_le32(0x00000101);
 	ntlmv2->reserved = 0;
 	ntlmv2->time = rsp_timestamp;
-
-	get_random_bytes(&ntlmv2->client_chal, sizeof(ntlmv2->client_chal));
+	ntlmv2->client_chal = cc;
 	ntlmv2->reserved2 = 0;
 
-	memcpy(ses->auth_key.response + baselen, tiblob, tilen);
-
-	cifs_server_lock(ses->server);
-
 	rc = cifs_alloc_hash("hmac(md5)", &hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "Could not allocate HMAC-MD5, rc=%d\n", rc);
-- 
2.50.1

