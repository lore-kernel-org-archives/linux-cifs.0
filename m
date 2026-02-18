Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C69A233149;
	Wed, 18 Feb 2026 04:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771388996; cv=none; b=DkOzXsbutksVfO0uGcDgAlZx1iW55vUGHP0y3OMxg/hYg3XGBmXxDcMILfn9Y0N5np0AlscG7FZBokTpi3pDW1BN5XojxdX4paUpg3rgr3zyXfXhUmmKyf/Hm7ATL7lBCcy4dY24J0X6jvoareHopkwy5cyl8CPBMUr0F2TUkFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771388996; c=relaxed/simple;
	bh=uAx+hOlkoBJGLkJ1SWzIs4mFiP9tMrKIbYXpv9PSS+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AXDTp1P7ocdb6q43duARbyDAJ6Juv8Kqmz6OTfrj//MMBGCDIBzAKjgEoL74F2R1ehGfHHaWfvwagGAllQHnYG4Md73JfALJuC3LemKrbWqzCpir1QfTtK47QKLqSGP9yGZ6Smtr11O+Z7GM2Kqo+wQcKNY6fQ8tOEc4mMZEGuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pDZLxOCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pDZLxOCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AFFC19422;
	Wed, 18 Feb 2026 04:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771388996;
	bh=uAx+hOlkoBJGLkJ1SWzIs4mFiP9tMrKIbYXpv9PSS+g=;
	h=From:To:Cc:Subject:Date:From;
	b=pDZLxOCk53AWV2bBEp7FB9mJByDu+jnaZNLKRuBicSom3LP3HjSNh8pjrMRdMsNDx
	 ApsBJBUj9g5HJ6PXnMhv/0JK6ClRsICoXyI7ZSPRxccW/6UbD4pdBUsivN+nOHEcO6
	 vObAO2xnZcKax9+hBf/HRUR7GngzgGRhk0qbnq6qqmaX6c0cKjOGT16OKu0ymP5WZS
	 YGMmOIomdnMkW5deno0vUk/h9xqbZoSSKeQJwa+KI8qxmaXS8VA1nOrkvjfQf1W5OO
	 fvYwcsu7MVhzYR87r6MC+7MfmYm6w85f2z3R7QW+wbFSOvwnX6FmT7w8etwKi/fdmC
	 SS5JmDn/T3Hog==
From: Eric Biggers <ebiggers@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: Compare MACs in constant time
Date: Tue, 17 Feb 2026 20:28:29 -0800
Message-ID: <20260218042829.68334-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent timing attacks, MAC comparisons need to be constant-time.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/server/Kconfig   | 1 +
 fs/smb/server/auth.c    | 4 +++-
 fs/smb/server/smb2pdu.c | 5 +++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 2775162c535c..12594879cb64 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -11,10 +11,11 @@ config SMB_SERVER
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
+	select CRYPTO_LIB_UTILS
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select ASN1
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 09af55b71153..a69e8694605a 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -13,10 +13,11 @@
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
 #include <crypto/md5.h>
 #include <crypto/sha2.h>
+#include <crypto/utils.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
 #include "auth.h"
 #include "glob.h"
@@ -163,11 +164,12 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	/* Generate the session key */
 	hmac_md5_usingrawkey(ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
 			     ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE,
 			     sess->sess_key);
 
-	if (memcmp(ntlmv2->ntlmv2_hash, ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE) != 0)
+	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
+			  CIFS_HMAC_MD5_HASH_SIZE))
 		return -EINVAL;
 	return 0;
 }
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cbb31efdbaa2..7a88cf3bd29e 100644
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
@@ -8878,11 +8879,11 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 			    signature);
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;
@@ -8966,11 +8967,11 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;

base-commit: 2961f841b025fb234860bac26dfb7fa7cb0fb122
-- 
2.53.0

