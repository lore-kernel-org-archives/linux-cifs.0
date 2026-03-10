Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BCC397E78;
	Tue, 10 Mar 2026 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172374; cv=none; b=BUROKu426H8mlU0YhBvRjFbm8oRQalW/oc6jyfmqCwRB1THzDv9/ddt2GvXCO8c35D3zfm+hyb5CYjouHxOd7MmklPQboz41DIiZDsYc+F+bYQKcr+Rmx1BeLliETgBAJMQLFcFpKKG9m3CsH09bJweKtwL1BETh2BRd3o/zvxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172374; c=relaxed/simple;
	bh=gEcQt7kI3jCVHAVlGSZt7rwDr5bcYt2UEfYoFXsMnIg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZollNjTEBLF1vwAVDLcLQ3pF/ZyWJh9eVcSDL0dN1XChcb+9qeDMNNgMHwUypq4LiVmOIOhs16y9LeuKryab0itlUBc7uqDnJuD8O5JbmOQsJfoSzT2tGYb9B6RLsYp7ReD2H6lA5wSNqBC3Esq7gZ8tBUDfDeOVoumLxvwIbAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwx+09U5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwx+09U5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330C1C19423;
	Tue, 10 Mar 2026 19:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172373;
	bh=gEcQt7kI3jCVHAVlGSZt7rwDr5bcYt2UEfYoFXsMnIg=;
	h=From:To:Cc:Subject:Date:From;
	b=pwx+09U5efNS/F8ix3h9GweHfuIxPcQMBNX78h4nGwtwDRpIJdsQ7/5k47kt9yySD
	 AtqAAd7jYe2rSXxyS4PX2kZ8PvYN9qPTwItwLJQ5LZL4q5D534VzUvoGDnMB8jvkaK
	 7AnGh4ixSEediXOP7SZtJbODG9fWfCD3OYGjw2FE0o/SU50TfRhX4cACCTCtsYa7wk
	 KJCq/99ofGDK0Kx/P/1rOJFP38ZnmHreqPf7d7AwN16hP9dd7GZrdgmh5tcEgVn6jA
	 cjeWUqDvf8AAXKYjzCclH9XFz9R7dpyhABlqdB6FiHwRon29bWMt/n1zeuY7KXGgBx
	 DuUOwBhQNfKdQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12] ksmbd: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:52:51 -0700
Message-ID: <20260310195251.70880-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit c5794709bc9105935dbedef8b9cf9c06f2b559fa upstream.

To prevent timing attacks, MAC comparisons need to be constant-time.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/Kconfig   | 1 +
 fs/smb/server/auth.c    | 4 +++-
 fs/smb/server/smb2pdu.c | 5 +++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index cabe6a843c6a0..da0187e76cf1c 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -9,10 +9,11 @@ config SMB_SERVER
 	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
 	select CRYPTO_LIB_DES
+	select CRYPTO_LIB_UTILS
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_SHA512
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index b3d121052408c..5d5a8166d3cc9 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -11,10 +11,11 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/utils.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
 #include "auth.h"
 #include "glob.h"
@@ -281,11 +282,12 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	if (rc) {
 		ksmbd_debug(AUTH, "Could not generate sess key\n");
 		goto out;
 	}
 
-	if (memcmp(ntlmv2->ntlmv2_hash, ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE) != 0)
+	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
+			  CIFS_HMAC_MD5_HASH_SIZE))
 		rc = -EINVAL;
 out:
 	if (ctx)
 		ksmbd_release_crypto_ctx(ctx);
 	kfree(construct);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ac8248479cba2..44ccf1a0e1212 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2,10 +2,11 @@
 /*
  *   Copyright (C) 2016 Namjae Jeon <linkinjeon@kernel.org>
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <crypto/utils.h>
 #include <linux/inetdevice.h>
 #include <net/addrconf.h>
 #include <linux/syscalls.h>
 #include <linux/namei.h>
 #include <linux/statfs.h>
@@ -8808,11 +8809,11 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 
 	if (ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;
@@ -8896,11 +8897,11 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;

base-commit: 39b686f8d57d7506af7789e915fe7fd103b0fe57
-- 
2.53.0

