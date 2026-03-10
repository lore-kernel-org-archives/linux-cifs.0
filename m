Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0348B3542CF;
	Tue, 10 Mar 2026 19:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172250; cv=none; b=JJCBvHzbzeGinLdWmdkcV3AL/Czf2tesxZUJvOUi4avj6zxm/cKoSGdHwqpxPDGahgLylHcRDij6WkLhjwiOMkYkjbUBiWpeUznOjItdzCvXMvtCzNcKCCUxGe5X5sNr66bsN58As4Q4+Ksn1sfNbQy6EUiVoLIdRkDcv9em9NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172250; c=relaxed/simple;
	bh=PCOJvXRyehdSsPBQEbgMJpMj5VEEmWoMZZz0U79UBJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gfJ7CSPxJeNGZDyq8r7PJ9vXEyHVyz57MHVLAaLhB2jYo8iOIlB6/l7sn+LXEQD3Po9ANqaFQ1vbG6oujQK4GodsQ5QK/mnM/o+ilCx2DI4F9BhWZcF3/f7Pj+SRJkD5MEnjg0ygqCIhTCZlst7KhMfXy7+ztlxm84Yz+1hiO2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyLJhpaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyLJhpaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F30C19423;
	Tue, 10 Mar 2026 19:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172249;
	bh=PCOJvXRyehdSsPBQEbgMJpMj5VEEmWoMZZz0U79UBJk=;
	h=From:To:Cc:Subject:Date:From;
	b=OyLJhpaRGVKb13VdyxASRWShSf/xp9Grx+rTyDW9lru4g9pbzhGIVKWrM4+Mud2Ae
	 Y5e3dfeYrJJXBKdPx6KxOY/pmkIiWLDGWRK36B5U/Q8zD3VPx1KcjS6Sl0o+vV2r8X
	 1fYlUVY0mMKpeb9ILaH633u4X2uJta44kjUkWYSwLYygBxZNPVAVdKc7N1ypsWxo9X
	 pPTQ3T8spL+La9KlFUUepEBDlsnJGbzFmjM9/R74xLUcGDgF7/rl677/+7RJ3h5T1q
	 0fsb4xy7gQZGq95c/1T9M9JlfXBxjQAYKE/AEOkbpBLZd6j4m1osVELifJyaw/f4Ur
	 NoN4F39t28eDA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18] smb: client: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:50:20 -0700
Message-ID: <20260310195020.70563-1-ebiggers@kernel.org>
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
index 801824825ecf2..b9e20bcaa8b5c 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -24,10 +24,11 @@
 #include <linux/iov_iter.h>
 #include <crypto/aead.h>
 #include <crypto/arc4.h>
 #include <crypto/md5.h>
 #include <crypto/sha2.h>
+#include <crypto/utils.h>
 
 static int cifs_sig_update(struct cifs_calc_sig_ctx *ctx,
 			   const u8 *data, size_t len)
 {
 	if (ctx->md5) {
@@ -275,11 +276,11 @@ int cifs_verify_signature(struct smb_rqst *rqst,
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
index 6a9b80385b86b..211305d43f8d4 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -18,10 +18,11 @@
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
 #include <crypto/sha2.h>
+#include <crypto/utils.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "../common/smb2status.h"
@@ -615,11 +616,12 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = smb3_calc_signature(rqst, server, true);
 
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

base-commit: 6258e292d7463f96d0f06dff2a39093a54c9d16f
-- 
2.53.0

