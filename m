Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6966931B11A;
	Mon, 18 Aug 2025 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525769; cv=none; b=YsHoCgkdNfq1BC0km+bcdhu1votTLUiZlOmUgqlpP9OWA+0g8gbsIqU/DICXC101uwgCBwBYpksFJ0xBguWD6pYlvmfmd8Wjy/JSDCNJ69Lo0Y11Qjw7fEs21lxV9a7MT0Ui42xKmffejGD/J7/mHn71gL/zYZx1wGZh8x4c0ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525769; c=relaxed/simple;
	bh=puUNJUWtaMS8nlTCfzaD6pXcCM3R5WFslJLiAWGYbos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbCUG/iKTidL+v+ikx0CqXAQ02iU9QZ2mg8yuOPEbDCVN/3Axa8LZTa+Zsa0uvkJU8daLDoA7n+JoRQ1gFRsMKRKWO6CeGvqRAPRzSVSGWZgn7+VG+JdKmfkXbcIT1tuxito6cZe+YhOPrSPu8P4uuUfdBy62Z7LFt3fFlt66tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8YhSBUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8YhSBUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC51EC4CEEB;
	Mon, 18 Aug 2025 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525769;
	bh=puUNJUWtaMS8nlTCfzaD6pXcCM3R5WFslJLiAWGYbos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8YhSBUfu8839JnZZtNFVOXdERzbAIVuxsZULN69Mk/PCrnH/UeWRBObcxVxEdJ6L
	 EzuuMzO/jWNObtvG+Ndb1m5/0Mi6wN/fk7TeyKX9T9tTcC2lm5LrNUCgm5NbATMfYR
	 toorcvltQbArTHvgaRdopH57uDKEv4nBDGCH8BzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 361/570] smb: client: fix session setup against servers that require SPN
Date: Mon, 18 Aug 2025 14:45:48 +0200
Message-ID: <20250818124519.762572033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 33cfdd726381828b9907a61c038a9f48b6690a31 ]

Some servers might enforce the SPN to be set in the target info
blob (AV pairs) when sending NTLMSSP_AUTH message.  In Windows Server,
this could be enforced with SmbServerNameHardeningLevel set to 2.

Fix this by always appending SPN (cifs/<hostname>) to the existing
list of target infos when setting up NTLMv2 response blob.

Cc: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Reported-by: Pierguido Lambri <plambri@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 
-	baselen = CIFS_SESS_KEY_SIZE + sizeof(struct ntlmv2_resp);
-	tilen = ses->auth_key.len;
-	tiblob = ses->auth_key.response;
+	cifs_server_lock(ses->server);
 
-	ses->auth_key.response = kmalloc(baselen + tilen, GFP_KERNEL);
-	if (!ses->auth_key.response) {
-		rc = -ENOMEM;
+	tiblob = ses->auth_key.response;
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
2.39.5



