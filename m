Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1712278772;
	Tue,  5 Aug 2025 13:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399480; cv=none; b=D4PA3T883I8aHSbMTOijYU5Gcbw4Yx3Ml6AcRcqmt1mcBLvAA3lp+XkFMK6JB7kw83N9GznjitTRXmo0fKSdljBlYoVBCzfv0lyUDkORGeGibrux51Hq5XyvE4ma2/4KHi53YdSCRh5Z727BuHmM9UNCRDxPozaAsj+3L8nL/S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399480; c=relaxed/simple;
	bh=OOXfZOYjGmL0PACq4lN8onmqc03Hr4KPLRBy8Ua1kbc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smt4wT6HgWLLI6ReBExpsdFYhyi8/S2rIlqa4UDlQ+WteoTM20cIcfu7MbQyltk93UR15ZALbSCI22ONADc70tXzZdgXVR/NHzup7b6LHVaawuNBFrl2zf2w+0bxrG7CMMxwaUP6By2WHlnBmTHtaZvK+PvOO6u8bv8rTxf33so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/cCmK7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/cCmK7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD195C4CEF4;
	Tue,  5 Aug 2025 13:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399480;
	bh=OOXfZOYjGmL0PACq4lN8onmqc03Hr4KPLRBy8Ua1kbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/cCmK7ed9yz3UWg5y3VxCImD8WfVGRVD4rPpiKPqR4C2Im8l/C+/bKhuespcYtAG
	 3ULCJAXz05tdvKYonKWtPpqUsCvNFPsE07Nr518R7JwVCPKWRScsNoQ1P27q8pZOQD
	 HQcPCVSAtSU6lANKIZKiuaKXVSi2yFlKlMhe7Xk7470eOVWVk8hqGudgByV59v1ljX
	 lcBi+0kx+s4zaPPckBzFzfLgE3Wx7TaMKpw+QDKRWIlZUJB7HvinnaWB3dhWTqgQN6
	 cRsQZOCqzONkWyNdzcgZlYhXtMZMYu1hpZoOz3gshPOgG+IGgPlkWDOjX+VtKJwF94
	 4xS1vi5y9O8LA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.16-6.15] smb: client: fix session setup against servers that require SPN
Date: Tue,  5 Aug 2025 09:09:18 -0400
Message-Id: <20250805130945.471732-43-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Fix Analysis

This commit fixes a **critical authentication failure** that prevents
SMB/CIFS clients from establishing sessions with hardened Windows
servers. The issue is:

1. **Real-world impact**: Windows servers with
   `SmbServerNameHardeningLevel` set to 2 enforce SPN (Service Principal
   Name) requirements in NTLMSSP authentication. Without this fix, Linux
   clients cannot connect to these servers at all.

2. **Clear bug fix**: The commit explicitly fixes a functional
   regression where session setup fails against certain server
   configurations. As stated in the commit message: "Some servers might
   enforce the SPN to be set in the target info blob (AV pairs) when
   sending NTLMSSP_AUTH message."

## Code Change Analysis

The fix is **well-contained and minimal risk**:

### 1. New Function `set_auth_key_response()`
- **Purpose**: Appends SPN (`cifs/<hostname>`) to existing AV pairs
- **Scope**: Self-contained function that doesn't change existing logic
- **Memory safety**: Uses `__free(kfree)` attribute for automatic
  cleanup
- **Error handling**: Proper error paths with cleanup

```c
+static int set_auth_key_response(struct cifs_ses *ses)
+{
+    // Constructs "cifs/<hostname>" SPN
+    spnlen = scnprintf(spn, len, "cifs/%.*s", (int)spnlen,
server->hostname);
+
+    // Preserves existing AV pairs
+    memcpy(rsp + baselen, ses->auth_key.response, tilen);
+
+    // Appends SPN as NTLMSSP_AV_TARGET_NAME
+    av->type = cpu_to_le16(NTLMSSP_AV_TARGET_NAME);
```

### 2. Modified `setup_ntlmv2_rsp()`
The changes are minimal and surgical:
- **Before**: Directly allocated and copied auth_key.response
- **After**: Calls `set_auth_key_response()` to inject SPN while
  preserving all existing data
- **Key change**: Moves `cifs_server_lock()` earlier to protect the new
  operation
- **Random bytes**: Changes from `get_random_bytes()` directly on struct
  field to using intermediate variable `cc`

## Stable Tree Criteria Assessment

✅ **Fixes a real bug**: Authentication failure against hardened servers
✅ **Small and contained**: ~100 lines, single file, clear purpose
✅ **No new features**: Only fixes existing authentication to work
correctly
✅ **No architectural changes**: Works within existing NTLMSSP framework
✅ **Minimal regression risk**: Only adds data, doesn't remove or
fundamentally alter behavior
✅ **Critical subsystem but safe change**: While touching authentication,
the change is additive and preserves backward compatibility

## Additional Indicators

1. **Reported-by tag**: Shows this was a real issue encountered by users
   (Pierguido Lambri)
2. **Maintainer signed-off**: Steve French (CIFS maintainer) signed off
3. **No performance impact**: Only adds small SPN string to
   authentication blob
4. **Backward compatible**: Servers not requiring SPN continue to work
   unchanged

## Conclusion

This is an ideal stable backport candidate - it fixes a specific, user-
impacting bug (inability to authenticate with hardened Windows servers)
with a minimal, well-contained change that adds the required SPN without
disrupting existing functionality. The fix is essential for enterprise
environments using Windows Server with security hardening enabled.

 fs/smb/client/cifsencrypt.c | 79 ++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 35892df7335c..4a0daca32d50 100644
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

