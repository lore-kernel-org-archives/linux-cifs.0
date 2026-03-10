Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644901547C0;
	Tue, 10 Mar 2026 19:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172258; cv=none; b=fOuAT6vE4mceKp0dIq4RGlAAd0HgnhXcyxVR2HWQGnCjF9+orNq78voS0/u7ObCqaUTRe7n8nCau28bkCQaR4/CfdMFsAtyH97RJvD0sx8tv0P7yVJYLPRsNzqEIP+HMVGlLnYN9XzjyAq+oqPXDzjibICLw3cHkq+BW6ntnhZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172258; c=relaxed/simple;
	bh=uEmV2RTrQnCjH4X7Ie4Sws6B5LZKfiBkJYJ0NImPwbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rpR9JpoTvq/9ZTvwzUQ891FgDsn/jrH5kZCu4AyV2K/k8PfEogLK8vAzQUYOGqKFmJcWBfkLiuQLWhOezlQR/j91Bkzk3lPrI1XybPjifDyiQ3fd6LE7931Co2LH7JA7qlWqd3vDmi3QgPUh0GxrNFL8mWKlQ/z+84Zxmcf0GcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceDA+lUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceDA+lUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61307C19423;
	Tue, 10 Mar 2026 19:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172258;
	bh=uEmV2RTrQnCjH4X7Ie4Sws6B5LZKfiBkJYJ0NImPwbE=;
	h=From:To:Cc:Subject:Date:From;
	b=ceDA+lUEMAb483pU2XEiFizFoadOdgkyf5WL742+ZqDiqD/eja2oNZy5Dt9V4uYrE
	 0ric0ihtFp8XHD4clN3s/rDO0Npes8O9NlXf7U4p1aY7rd2aREeSC58il2W3VCaMLe
	 ZypPCgR02isNHD2KKtPkJ7IBVVCMp/+1GPI+a+LHtaVVUXMjaokc6VgVhlBpiTAPwT
	 acXaAetFrymMvxAeiwHRb0il0tlNMmK4yVnkXd3GjKUlqu5B5w+WzO3MOyqDufH2k8
	 hzdtsT1LCzBfyc9pZS1ngRKZ2HpJ+24/SsFgXZem4u+2BsmdSINBKyOpw4PxJmSE61
	 iJhF3M3cshRSQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12] smb: client: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:50:49 -0700
Message-ID: <20260310195049.70659-1-ebiggers@kernel.org>
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
 fs/smb/client/cifsencrypt.c   | 3 ++-
 fs/smb/client/smb2transport.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 7c61c1e944c7a..179aaf7674c7f 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -22,10 +22,11 @@
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include <linux/iov_iter.h>
 #include "../common/arc4.h"
 #include <crypto/aead.h>
+#include <crypto/utils.h>
 
 static size_t cifs_shash_step(void *iter_base, size_t progress, size_t len,
 			      void *priv, void *priv2)
 {
 	struct shash_desc *shash = priv;
@@ -255,11 +256,11 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 		return rc;
 
 /*	cifs_dump_mem("what we think it should be: ",
 		      what_we_think_sig_should_be, 16); */
 
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
 		return 0;
 
 }
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 475b36c27f654..87f189894b1e1 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -17,10 +17,11 @@
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
+#include <crypto/utils.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "../common/smb2status.h"
@@ -730,11 +731,12 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
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

base-commit: 39b686f8d57d7506af7789e915fe7fd103b0fe57
-- 
2.53.0

