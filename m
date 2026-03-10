Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955ED36166E;
	Tue, 10 Mar 2026 19:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172371; cv=none; b=fOForn80ws4Re3DHyQhkVLFzYKFjcMSq0NEZlPwCidkHKxL0dfpVLElt89tXljxG18iXhTD6hvLB6EHepCzyo/50F33eVDez3RM8m0vZNL55Anz3qyu8Z8FwWZOQIV1Yq15r2Hafrj9p+dxFRfXrf4ob9NmLH8UhO95gfx5tBbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172371; c=relaxed/simple;
	bh=ZljlsaZrVSABj0WGZEN8HZRXYNDW4ztD1TIc/UZ7+Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BqzMk62YnndS5p4Nes3fcxusufnm+2jmsUK7ecsaXs+Bj+r60+YK8wGMIgWdXvvazUrjhnwWxerptyuYxAtE/QMHI2+zSjhfewpedMVWvYs5JH++iVSFb7vmz5zfcQVcIUlDQkN8t0CHoPrsa0a0/+ugBYBevUONKYni+/cQTpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cs6MPMmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cs6MPMmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7C0C19425;
	Tue, 10 Mar 2026 19:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172371;
	bh=ZljlsaZrVSABj0WGZEN8HZRXYNDW4ztD1TIc/UZ7+Kk=;
	h=From:To:Cc:Subject:Date:From;
	b=Cs6MPMmGHMYfD/AiCuUY7uIQLSIDd3Z2gPNs8zfogm2eus4YkCknrocxGIlCVzY0A
	 KZwvvhir7j/VevZm9IJI3okcHQFUzmRwL0NCa1hJQ19Ej4SWIik4iEU2gZBgxQUPe9
	 IY5C4gTEl/pzLueiu4WBGnbBUwvT2oAGfuJeubJfcj1LSr2MBJybXL2PQF6HlAhcFK
	 fShxnCVKqKrtqxljPVxswzOwwRofVCV7LY/eegI5tguQKwpHdML06XgoSiBZ5iOte2
	 fdkdiVHaMVLYrkdZkGpkOcO6D1qxJTHmUWaZ6EqSo7jGKOZhifKeuFUTN94Y1FN3e2
	 yYHUVbpClmbUQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18] ksmbd: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:52:14 -0700
Message-ID: <20260310195214.70843-1-ebiggers@kernel.org>
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
index 098cac98d31e6..6200c71298f66 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -11,10 +11,11 @@ config SMB_SERVER
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_UTILS
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_SHA512
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index b4020bb55a268..f92b2f3dc6de0 100644
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
index bf8c480594367..f82d6c6b94101 100644
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
@@ -8879,11 +8880,11 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 
 	if (ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;
@@ -8967,11 +8968,11 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;

base-commit: 6258e292d7463f96d0f06dff2a39093a54c9d16f
-- 
2.53.0

