Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4E1AA1E7
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731944137; cv=fail; b=lvv7KwIHmEncy7lydQ7qrROT5vJ/5ES9fFnI8bus/fItEjqxXBbd9LPC4W5gDWdGY42ZLoUcn7sJmrFtzJynNgwlaCpC5RRYyBwRl9LtGmt9SLnbJ0XVXTIhUDq8l1Lvv2xFeJaPRq6v2euYkZLDohRMEhOeh8zxW+4jTGMqcTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731944137; c=relaxed/simple;
	bh=/cvGHfH+cXkkL4flPpiqhwVaQLZ4ZD8N9U0fCwaIrwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z+sMUwh4irgTlJVo2x8HfNoZujt7Fk0wR/2u3qnnRX7DVu9muIn+exLcFUN93Gdcs8+V1E1XnTidoDtnXwyTBwNemJdsc4ayfx8dNocr0K8K17ZVo7DRG2B7nOQkegZk3/ixkN/mt0aw8toSJx01puHvOUvONNRqi+AzH2oDphA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=p26/wKXH; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="p26/wKXH"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731944126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hgEWU/l9kTKR00Wg5h+h9LaaAzkqYSZi84Dy671GQfE=;
	b=p26/wKXHOvPzO5x1Phg+YvCsA4xNAZzz7zL8qF3CV1kVssx2aZ33uKPD7BEzrapiw2PrFO
	XBzkKRKF8f+os4A+QfPgJzDgNKieMdugGaD+UuzfApt1hR9bJrlp0L5FAbRBNHuLQj80rb
	tkSITLlPJ5VHvGdl+MyN/a7DqvMF6y6ZtReiWO4mSFttZ3z0IgTtXsU5YwKGC5RAd9b3f5
	P9qIR147WmuMFTKRRwIQ0wbJHeVKDjGX84QFgb9hYUQ2DTR5j0O836jQh/HWcc4jg6gtUN
	nb2/a5P6HjpfQptZj8OBcJOsIB/btS8x9znVRHVqgm04HUjd/Bp0EUHHcAXagg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731944126; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=hgEWU/l9kTKR00Wg5h+h9LaaAzkqYSZi84Dy671GQfE=;
	b=khFtSvkGNXtdnN6TAXL8chSBAEByBl5PnMMLIlZAcnvtYAftip0EehfdTGH+cr3iEk0m1p
	vPntjh7UW7WvfWgYtBxnuaBZ+0rdjvGBDQFZpk9ZRsTYG4F98UJ96Ld+iWmlV9pWHGtnmr
	ZWppSARZALw0zMnZYpu3U3POJGfpjsqP4TtIoIj1q66c5e/IOdIkTpK2JWkPwc7G0N5wkt
	CwghsSw2N0bg+256ETYQHsp8qUYDU5r9AX7YRAlNCeefOOVm819+TtP7HDRZYVyfSn6yY2
	c5hR1tBZuHKDaBmVq9YUhPciS914/c+FpBM6c3SYKhrH+3aIXfyJuSesz9/+4Q==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731944126; a=rsa-sha256;
	cv=none;
	b=AFqpZ4l+iPEAFNjoFaT95lGh9o46Yn3YmCCuszhuBNdkt0GJm9SK7PjPr4nxfd5GHwiGay
	7oG3RkT+fB+cqv62Ou1aGoxEJ3a5enbJixy9ZLpfHabhmsLAdUdqH97mXA71QlOt7CX1Ym
	juTwX0/EuGJrPi2yXjwoWs4WhgIYe5d64aA4F1x6aD2fhAaA9rGWUmhkqM18TgyK8G+35X
	NbgyBSzge5UyOg30wIPjLxoHQDVXJacSiCxi1hYB2zOgK0icsryvmolWtDyWmZ9Ya6Wrun
	q7NzV4UWtHI1hgaM70MGyhMvC4yR91GE4zCP7MYFGX5RrsVBbHc+lm57n6QrJQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] smb: client: improve compound padding in encryption
Date: Mon, 18 Nov 2024 12:35:14 -0300
Message-ID: <20241118153516.48676-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit f7f291e14dde ("cifs: fix oops during encryption"), the
encryption layer can handle vmalloc'd buffers as well as kmalloc'd
buffers, so there is no need to inefficiently squash request iovs
into a single one to handle padding in compound requests.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  |  4 ++--
 fs/smb/client/smb2ops.c   | 37 +++---------------------------------
 fs/smb/client/transport.c | 40 +++++++++++++--------------------------
 3 files changed, 18 insertions(+), 63 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 63d194ebbd7d..fc33dfe7e925 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2230,7 +2230,7 @@ static inline int cifs_get_num_sgs(const struct smb_rqst *rqst,
 			struct kvec *iov = &rqst[i].rq_iov[j];
 
 			addr = (unsigned long)iov->iov_base + skip;
-			if (unlikely(is_vmalloc_addr((void *)addr))) {
+			if (is_vmalloc_or_module_addr((void *)addr)) {
 				len = iov->iov_len - skip;
 				nents += DIV_ROUND_UP(offset_in_page(addr) + len,
 						      PAGE_SIZE);
@@ -2257,7 +2257,7 @@ static inline void cifs_sg_set_buf(struct sg_table *sgtable,
 	unsigned int off = offset_in_page(addr);
 
 	addr &= PAGE_MASK;
-	if (unlikely(is_vmalloc_addr((void *)addr))) {
+	if (is_vmalloc_or_module_addr((void *)addr)) {
 		do {
 			unsigned int len = min_t(unsigned int, buflen, PAGE_SIZE - off);
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 24a2aa04a108..6c4a7335a8a2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2606,7 +2606,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = ses->server;
 	unsigned long len = smb_rqst_len(server, rqst);
-	int i, num_padding;
+	int num_padding;
 
 	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
 	if (shdr == NULL) {
@@ -2615,44 +2615,13 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 	}
 
 	/* SMB headers in a compound are 8 byte aligned. */
-
-	/* No padding needed */
-	if (!(len & 7))
-		goto finished;
-
-	num_padding = 8 - (len & 7);
-	if (!smb3_encryption_required(tcon)) {
-		/*
-		 * If we do not have encryption then we can just add an extra
-		 * iov for the padding.
-		 */
+	if (!IS_ALIGNED(len, 8)) {
+		num_padding = 8 - (len & 7);
 		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
 		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
 		rqst->rq_nvec++;
 		len += num_padding;
-	} else {
-		/*
-		 * We can not add a small padding iov for the encryption case
-		 * because the encryption framework can not handle the padding
-		 * iovs.
-		 * We have to flatten this into a single buffer and add
-		 * the padding to it.
-		 */
-		for (i = 1; i < rqst->rq_nvec; i++) {
-			memcpy(rqst->rq_iov[0].iov_base +
-			       rqst->rq_iov[0].iov_len,
-			       rqst->rq_iov[i].iov_base,
-			       rqst->rq_iov[i].iov_len);
-			rqst->rq_iov[0].iov_len += rqst->rq_iov[i].iov_len;
-		}
-		memset(rqst->rq_iov[0].iov_base + rqst->rq_iov[0].iov_len,
-		       0, num_padding);
-		rqst->rq_iov[0].iov_len += num_padding;
-		len += num_padding;
-		rqst->rq_nvec = 1;
 	}
-
- finished:
 	shdr->NextCommand = cpu_to_le32(len);
 }
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 91812150186c..0dc80959ce48 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -418,19 +418,16 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
-struct send_req_vars {
-	struct smb2_transform_hdr tr_hdr;
-	struct smb_rqst rqst[MAX_COMPOUND];
-	struct kvec iov;
-};
-
 static int
 smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	      struct smb_rqst *rqst, int flags)
 {
-	struct send_req_vars *vars;
-	struct smb_rqst *cur_rqst;
-	struct kvec *iov;
+	struct smb2_transform_hdr tr_hdr;
+	struct smb_rqst new_rqst[MAX_COMPOUND] = {};
+	struct kvec iov = {
+		.iov_base = &tr_hdr,
+		.iov_len = sizeof(tr_hdr),
+	};
 	int rc;
 
 	if (flags & CIFS_COMPRESS_REQ)
@@ -447,26 +444,15 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		return -EIO;
 	}
 
-	vars = kzalloc(sizeof(*vars), GFP_NOFS);
-	if (!vars)
-		return -ENOMEM;
-	cur_rqst = vars->rqst;
-	iov = &vars->iov;
-
-	iov->iov_base = &vars->tr_hdr;
-	iov->iov_len = sizeof(vars->tr_hdr);
-	cur_rqst[0].rq_iov = iov;
-	cur_rqst[0].rq_nvec = 1;
+	new_rqst[0].rq_iov = &iov;
+	new_rqst[0].rq_nvec = 1;
 
 	rc = server->ops->init_transform_rq(server, num_rqst + 1,
-					    &cur_rqst[0], rqst);
-	if (rc)
-		goto out;
-
-	rc = __smb_send_rqst(server, num_rqst + 1, &cur_rqst[0]);
-	smb3_free_compound_rqst(num_rqst, &cur_rqst[1]);
-out:
-	kfree(vars);
+					    new_rqst, rqst);
+	if (!rc) {
+		rc = __smb_send_rqst(server, num_rqst + 1, new_rqst);
+		smb3_free_compound_rqst(num_rqst, &new_rqst[1]);
+	}
 	return rc;
 }
 
-- 
2.47.0

