Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F7A3542CF;
	Tue, 10 Mar 2026 19:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172274; cv=none; b=ABzPcGDAEqkNB9YxrexzijWAKl5O1LfIFslj3eEqYmmWYJ4FPkJ8WBxmmUFFmZMxmbgiPgaV+rFXUKm5aB5sCUoT4K/799/MDtTlBc83hC+ysVA2qPTGsMUgnUDSmU7ysd9ZkSErqyl7vj2TDoTm8Wf6MUooUIix5r7zl2+AqkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172274; c=relaxed/simple;
	bh=zGYPk/RqlZK1wgfeeNYdI/m2ny73g5XclWvfdejoJQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WjTfRoW1Y6qt6FbG5RVq62hVjpGMI0Ybkx6Y3oybIslVOmtbiSTuHAEmNGPeiFPKUfsRbd8E4VCINsxQ0GxF1YCQSgNeoYAfAI/92EA6yf8i7ve/UJ/KXQUcOArzkN0bGCgnfZ6GZLpoZcvGJDJMtUPxHewVq5jk3S6gIwCgJ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nh+XdXek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nh+XdXek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AE0C19423;
	Tue, 10 Mar 2026 19:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172273;
	bh=zGYPk/RqlZK1wgfeeNYdI/m2ny73g5XclWvfdejoJQo=;
	h=From:To:Cc:Subject:Date:From;
	b=Nh+XdXekqKQhhHx1Y68dypXxYw5h09LZWqJW4Iz4DafJmeqP7MCHaZfJZfoF8NMTq
	 gAy341vUEi2zvYr1VztgmuwZb+qiYwu0OL82r6lv7ge0auab312OXbPxjIUQFABCrf
	 NJrB+LRzHXEWW350Wr6SvowJF3sXgZmDE8segrc46MlyT/urgphCk+tuGuRHWPne7f
	 RDZx2art1QBGf4M7MVla7HhmKsLq7QnO7bxOMtTV1Md9chupl88JckSQ2RFuiIqJ7g
	 OA8ssBxWo7+eFYUO92eHdODpiHc6eFIJhDA4jwvNYrhCs68R7D0Nkn6gJKR8OSVHbt
	 9a7Gz3WRQwl6g==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10] smb: client: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:51:10 -0700
Message-ID: <20260310195110.70753-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 26bc83b88bbbf054f0980a4a42047a8d1e210e4c upstream.

To prevent timing attacks, MAC comparisons need to be constant-time.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsencrypt.c   | 3 ++-
 fs/cifs/smb2transport.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 9daa256f69d41..96cbfebbb6483 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -34,10 +34,11 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include <crypto/arc4.h>
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct TCP_Server_Info *server, char *signature,
 			struct shash_desc *shash)
 {
@@ -253,11 +254,11 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 		return rc;
 
 /*	cifs_dump_mem("what we think it should be: ",
 		      what_we_think_sig_should_be, 16); */
 
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
 		return 0;
 
 }
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index adb324234b444..c02e57d8e228b 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -29,10 +29,11 @@
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
+#include <crypto/algapi.h>
 #include <crypto/aead.h>
 #include "smb2pdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
@@ -685,11 +686,12 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = server->ops->calc_signature(rqst, server, true);
 
 	if (rc)
 		return rc;
 
-	if (memcmp(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(server_response_sig, shdr->Signature,
+			  SMB2_SIGNATURE_SIZE)) {
 		cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx\n",
 			shdr->Command, shdr->MessageId);
 		return -EACCES;
 	} else
 		return 0;

base-commit: aed5c3b77cd53ba74f66767b03bfb9177662af4b
-- 
2.53.0

