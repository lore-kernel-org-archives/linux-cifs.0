Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5725E3B38A1;
	Tue, 10 Mar 2026 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172379; cv=none; b=Egwqt2EBF3aN9p+aKfwa4VQlTgECWeKmkDX+mZlj9YYWZ+G3IOzuckVx+EkQnaLWV351UsIpMsjtuMlBLWLO4+gc+QN1CPLq8Qk+pNvkurtZbpkWTFd83RGku/tLXtgbH2J3/DSV7R/Cbp/9yWbllH7zXYee7C2BurRXEtIlcFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172379; c=relaxed/simple;
	bh=4qdRfUtne0l7LP0Cb7GPiynsQvcOqzkMXf3BODgdwPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wo2kkRdNppyj3U2lOeJX8HQKAKm6MjxzK59EdK3n+37mBphx1CxeRceyq2uOuxzx+359i+agvTIEUiQt5X+CKCfG1cgzVldtLphqZK3NGj6cmX13ibm9pno27oA4Vx5fILw6r+fWOnGzzrsw6uo09wuUD2mRmWeNpXsTDFUnwAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXRgF9eD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXRgF9eD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3BC19423;
	Tue, 10 Mar 2026 19:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172378;
	bh=4qdRfUtne0l7LP0Cb7GPiynsQvcOqzkMXf3BODgdwPU=;
	h=From:To:Cc:Subject:Date:From;
	b=sXRgF9eDoiGMkhOhzFmZ42eSO2X8XvDNgAvpWVt7OuDPxoVp6uGpzTf3V5FboMmms
	 P2uSett33hTgomOZPVvXgO1joKDP7tNPHFxOz+qU/02X//aPLUuGAk6lhYWeQFAEwa
	 bKbirlPD6nsNg1DVJE7nFxBofpAORtt4rXlCjfB0bLaNzJ9JksrCgTH4M8R+Vg2hH6
	 HKzfyEPzeZL6hVwTLoJLtlOgRGV4Kzsdl0FRlRf6q8nS4/usgjL6E+ua0y/nXJgb2U
	 mAq/Sobjv0awnTfJmB9NYRmLjm1ebfQe7ueiQ+TQoxky/SxSAzRaC8nv6Gp7334vI5
	 BVXQer6VB/XSg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1] ksmbd: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:52:56 -0700
Message-ID: <20260310195256.70926-1-ebiggers@kernel.org>
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
 fs/smb/server/auth.c    | 4 +++-
 fs/smb/server/smb2pdu.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index f8a192cc82f24..4c3384bbbb492 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
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
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2b16bd4882499..641618a9e6e8b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
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
@@ -8428,11 +8429,11 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 
 	if (ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;
@@ -8516,11 +8517,11 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
 
 	return 1;

base-commit: f2ddafa93a259310ca47507153b7811ec54ab7fd
-- 
2.53.0

