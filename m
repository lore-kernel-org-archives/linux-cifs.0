Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27183542CF;
	Tue, 10 Mar 2026 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172264; cv=none; b=W4Cdz9q0IdlikkmXQ9iWpRa3QfQRpqiBCscmpBDHyDbPgvaDMr01oFgF04iNPdByHdvxGhrzVGWXl+SSdVxrveY7zvBqRhy60DyD3ryMrveysGrT3/jEGs8a+EX4A+vYFN7np8BOqlS68t/alBDxfiRpyFccEY7hPTPSNLVQ5LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172264; c=relaxed/simple;
	bh=Ad47JaXsywSU6JBLYbdP676mE2ZoM/HobzD5EQN8XWc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pfx76IuO8vjyvpdd1hI+wHkkpvDLK8Ym29dY+T14UEVkW6PC0C1sO0M6/z6VGOJyS//63xKE256AjBdT25t3rKnUwyJezx9OuRjXLOiJ/nWMNA0Ef1JeX1a5O6bO/Qh2FN4296VcOHu2QRCsMWiP1poaB8XonO0+NCTlDt204wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rhBhcIny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rhBhcIny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2EEC19423;
	Tue, 10 Mar 2026 19:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172263;
	bh=Ad47JaXsywSU6JBLYbdP676mE2ZoM/HobzD5EQN8XWc=;
	h=From:To:Cc:Subject:Date:From;
	b=rhBhcIny72YQS4nwBDnRFNpkRyNRkrynLzNBNd1XZ1w5DvPDFsZwc0RAMonGjfXaI
	 a7RrOEL+HF6GJdLrdnJdyOey8+XZJUTtC7+43VneVLLIyQbXp5vWJFPN30iTW+uf8c
	 1wkUL6fdTAKysXUe3B8vSXn1bkPYSWb7pUFlSiEsNY3c9gC0J73Dv0HYeocRvQz1eO
	 YquToz2UTm50h3em5n1oOSnB5fcSdgDS6JZPcpX8NGL1czE8NjxUqFTIqKB9vzhsVC
	 rxr65WcDZ+YvtyZpSJJiKyzh8ns0vLcnVoRtyzvq1mMBbMw9qm6/+7xY5YMFoUuWtY
	 YWlrYi/HizebQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6] smb: client: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:50:58 -0700
Message-ID: <20260310195058.70682-1-ebiggers@kernel.org>
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
index da3d003cb43db..3d6b663212335 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -21,10 +21,11 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include "../common/arc4.h"
 #include <crypto/aead.h>
+#include <crypto/utils.h>
 
 /*
  * Hash data from a BVEC-type iterator.
  */
 static int cifs_shash_bvec(const struct iov_iter *iter, ssize_t maxsize,
@@ -369,11 +370,11 @@ int cifs_verify_signature(struct smb_rqst *rqst,
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
index 99081e9d6283a..daf8ba2cd8a10 100644
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
 #include "smb2status.h"
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

base-commit: 4fc00fe35d46b4fc8dac2eb543a0e3d44bb15f47
-- 
2.53.0

