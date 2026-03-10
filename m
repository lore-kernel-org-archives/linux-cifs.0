Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9804A3B8959;
	Tue, 10 Mar 2026 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172381; cv=none; b=qqM8ODf1w9l+blLmFi8x8Rphj6j31A6DrEmwul0aoa7uaSyHx9xx3NbVo7fDjaazWKjXXmpaSoX9dncfvmj8UwyZEenckjhqJLp7rkYWgVDTIfmlsVQrLb69zs4TxgekYDWXlzKIvdvccMLHXR1VYiis0/h8Noma+7onUv/eNKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172381; c=relaxed/simple;
	bh=kN/Vk85gyOzB9l+V19qIFjeAt0h9A4wogUE0W0Vedxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IzAP2BA/edMJsYdn7E4cc8lfJRCHHHUIqsTuwzHyfXStZAjeWVMsaVvznJ0N1EhjC0wctADAu8D2TdcD5ClTpti4gihRa/f3dl3VnWsuKn23dwnszwlmUtPXtz0ftdMZGPW7NyExlMFI6S8jWncj47L834Dx3mEDtQTP8jr0NoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcLHkQXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcLHkQXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3485C2BC87;
	Tue, 10 Mar 2026 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172381;
	bh=kN/Vk85gyOzB9l+V19qIFjeAt0h9A4wogUE0W0Vedxo=;
	h=From:To:Cc:Subject:Date:From;
	b=EcLHkQXGN1Q7dVL+q+zJJ2xH9UCjawRXffJNQ6GZ4CHtIOczRKbmmL2TwPr5Eh+zs
	 2Q/vPcrIVhT3ASSIGI55BC8jsY9g5UNizxG0zNV+14Sx056k5RMV3LIwXC6EuO6Mu2
	 UuvlKjxpjCUxPtaQRbts5a7bOMt+aOJ/ZfPHlS2RTRDTk90KeG0Qf6BWM5OuHLXHGo
	 UWmumdGquktlMqvBaR4tkawYd/Mz1E1rsWEgXWnG0CY5aM5dXcmZX5QT92CPPq3YXW
	 hT3XZUHcYFnfditYPl1IC/+5Tg41SkGrGauKyDOO/R/QRc7STBsx295Jhf0S+pcQsx
	 jk0y6dDwlzG2Q==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15] ksmbd: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:52:59 -0700
Message-ID: <20260310195259.70949-1-ebiggers@kernel.org>
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
 fs/ksmbd/auth.c    | 4 +++-
 fs/ksmbd/smb2pdu.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 647692ca78a28..7a06139274172 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -11,10 +11,11 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
 #include "auth.h"
 #include "glob.h"
@@ -279,11 +280,12 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
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
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b5ff4c855f9cb..829329abca664 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2,10 +2,11 @@
 /*
  *   Copyright (C) 2016 Namjae Jeon <linkinjeon@kernel.org>
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <crypto/algapi.h>
 #include <linux/inetdevice.h>
 #include <net/addrconf.h>
 #include <linux/syscalls.h>
 #include <linux/namei.h>
 #include <linux/statfs.h>
@@ -8396,11 +8397,11 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 
 	if (ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;
@@ -8484,11 +8485,11 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;

base-commit: 91d48252ad4b17577cf8cc8d3e1353402e4da8f1
-- 
2.53.0

