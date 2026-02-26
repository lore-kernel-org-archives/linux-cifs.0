Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B68E2F28FF
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 22:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772144206; cv=none; b=phfRBimylmFGtBVkp28PgFG+bd9CB0g0i+qHVigrtMlHf0gGsAMLqZUVBqO77Uc2HTzpXCLmDpKd2RcfnNjzIRZdDYBQypw5usKz8fbpuB57rxb4imwPHyYjqSsOKXpdpNYjUfOirzc2hZHTAwOkQtyEkiuAEYtwk29YJ1S4soE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772144206; c=relaxed/simple;
	bh=iL0X6SxJTGs5/y4dfrQqYApOfhtKgY8qI1wbVHj0Tdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mKDVeJZiLtFuzZmIk1Mt5rmIWXyG8Z9RD3bUJWwacF3JJjFQ2flq+zNhz6e2qsWHIXW+uQcZjan4UTtRprSB/HDsQXM0EyXsg3vHpwvmMEK/fDZDhuN04MnxXztC1aGH8ajHO00hCC/jQjC9EzNod/D18+phUkZIMi24052L+Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Mi+x6QWj; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Mi+x6QWj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772144203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ugPSjWS5dBR0Sc3U44fSFhQ5fFsnbuzL31EZNXnco3A=;
	b=Mi+x6QWjACwpTjpntj1oNxu3T9jueuxuSY9+WTnjvRMybMcqyAlUGyXFD/H8/03i4rvkYt
	rF3t42OUU4+zXTz9DpoGZIwl21+4vsVN+z/MwA0MmsCAWU+ZpNU0dHKuMmTl2nAQN1GRoq
	moFf4k3CtJY22qBX5bBaeleUWsmYmuQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: Use snprintf in cifs_set_cifscreds
Date: Thu, 26 Feb 2026 23:15:22 +0100
Message-ID: <20260226221522.796394-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace unbounded sprintf() calls with the safer snprintf(). Avoid using
magic numbers and use strlen() to calculate the key descriptor buffer
size. Save the size in a local variable and reuse it for the bounded
snprintf() calls. Remove CIFSCREDS_DESC_SIZE.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/client/connect.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 33dfe116ca52..a055496c4835 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2167,9 +2167,6 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 
 #ifdef CONFIG_KEYS
 
-/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
-#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
-
 /* Populate username and pw fields from keyring if possible */
 static int
 cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
@@ -2177,6 +2174,7 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	int rc = 0;
 	int is_domain = 0;
 	const char *delim, *payload;
+	size_t desc_sz;
 	char *desc;
 	ssize_t len;
 	struct key *key;
@@ -2185,7 +2183,9 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	struct sockaddr_in6 *sa6;
 	const struct user_key_payload *upayload;
 
-	desc = kmalloc(CIFSCREDS_DESC_SIZE, GFP_KERNEL);
+	/* "cifs:a:" and "cifs:d:" are the same length; +1 for NUL terminator */
+	desc_sz = strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1;
+	desc = kmalloc(desc_sz, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 
@@ -2193,11 +2193,11 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	switch (server->dstaddr.ss_family) {
 	case AF_INET:
 		sa = (struct sockaddr_in *)&server->dstaddr;
-		sprintf(desc, "cifs:a:%pI4", &sa->sin_addr.s_addr);
+		snprintf(desc, desc_sz, "cifs:a:%pI4", &sa->sin_addr.s_addr);
 		break;
 	case AF_INET6:
 		sa6 = (struct sockaddr_in6 *)&server->dstaddr;
-		sprintf(desc, "cifs:a:%pI6c", &sa6->sin6_addr.s6_addr);
+		snprintf(desc, desc_sz, "cifs:a:%pI6c", &sa6->sin6_addr.s6_addr);
 		break;
 	default:
 		cifs_dbg(FYI, "Bad ss_family (%hu)\n",
@@ -2216,7 +2216,7 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 		}
 
 		/* didn't work, try to find a domain key */
-		sprintf(desc, "cifs:d:%s", ses->domainName);
+		snprintf(desc, desc_sz, "cifs:d:%s", ses->domainName);
 		cifs_dbg(FYI, "%s: desc=%s\n", __func__, desc);
 		key = request_key(&key_type_logon, desc, "");
 		if (IS_ERR(key)) {
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

