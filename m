Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93B93C060A;
	Tue, 10 Mar 2026 19:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172376; cv=none; b=OAx8jn5aCDa+GAoTCEHPYa+PgJVISofeN56FWBAQuBLpg7sUpJRQp//9B63sNMi4xZbyy24CS2KXCNUy591CVpwgf65yh/sHt9Cio2eEb6hH0dRqmflUqyavQYjqpmsuO7DkGOJDPEzuCV3vzBI3S+npRMP+fa/fbVhCYQnruvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172376; c=relaxed/simple;
	bh=khME16d+H0DEAV2zpYTok5ib8wH/YwlxS/FiTIEAWD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ESETRYNE+u3jp8fCusTc3zB7cK24QRPfWvDV+RJrpTBUrzucbkFLHKKCsKHG+2q4F9mEXxzy/pCqCG+8mTtomr28JnccowjA6bVSI8zqw1W6mwZ9/BXFW+3Bwu3mZRBo4pTyf8yJviYHBprrUHK9xbOXgAatfoJIiFmrqSjQo6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0QFzv0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0QFzv0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41ADC2BC87;
	Tue, 10 Mar 2026 19:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172376;
	bh=khME16d+H0DEAV2zpYTok5ib8wH/YwlxS/FiTIEAWD4=;
	h=From:To:Cc:Subject:Date:From;
	b=l0QFzv0vuKpEcGmP2WR5dfqTMnhuMkwa7B7ix5D47tY1eQ7YekU1ZzCZTaImIGbD8
	 xWLENRKOt+LZ0xx4tX5Wv9WI4/gJLIxOkFh1HQG3CIVRbpaRyKy0rxpA+iBaRR2vXl
	 L8g8rnQ71n94AYeH+fYjJ+0QLxgZ0LSlhDVYR/Looco8PF26uNhZUoQeZyJBhJ8LaZ
	 QO1Jqcz1aZf/QKIh1+BOE5sn/Uu98KZPUV+7Jlz9k7vYJaGE0igaiLZMSmr/WKGR8L
	 8mzNp5TMayDRosyeNfYfYVN7esFnRM/gadqU16kJzqWpsuWjnmlyuFl3axxX+Varbm
	 ZkhM5wv6ldHkw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6] ksmbd: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:52:53 -0700
Message-ID: <20260310195253.70903-1-ebiggers@kernel.org>
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
index f4b20b80af062..a2dfb981ce666 100644
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
index da4d914c87ad2..6a128a3be61e7 100644
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
@@ -8802,11 +8803,11 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 
 	if (ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;
@@ -8890,11 +8891,11 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;

base-commit: 4fc00fe35d46b4fc8dac2eb543a0e3d44bb15f47
-- 
2.53.0

