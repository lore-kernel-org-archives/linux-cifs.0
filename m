Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2C723C39A;
	Sat,  4 Apr 2026 19:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775331923; cv=none; b=LnT/fc1uOs+4FU2vaRiJfw/5TnvKbudTPLLtAuBLXtmgPkteilODw1bToDu8lWlmym6qId19s5cM7cFPUahsoAFx8BFlPGu+RZMCUrWS+rSjfPH6r8Xh0nOp/Vca3kNzfSkQHlmsruwNg4tN7Av2f4vKjl/mHtmhqu8sHnRQUSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775331923; c=relaxed/simple;
	bh=7JSG5D3JGF+7GTzodGjPk3bDws1pIPBcqi4HIsjesSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FPichcIuXQdfL2KJjr7/YRfKlKC+gK1Ka9d9gpIGsmcMI94tue46PgxXADpWQQCOahCjfWTN5cmyL7kfhRgHaBhWGfc/8GvZZwu2w53aC2lpnswFY9j9f8VF+VzMYfAcMh9bXGITkd8Bk7D6sFNRSS6xrL9AM1cUpJ1X1FevxKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eF+YrLnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eF+YrLnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F91C19421;
	Sat,  4 Apr 2026 19:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775331923;
	bh=7JSG5D3JGF+7GTzodGjPk3bDws1pIPBcqi4HIsjesSY=;
	h=From:To:Cc:Subject:Date:From;
	b=eF+YrLnj1+a0diqXTUPtLiR429KJqMbhfSTKTOAvlEa+dCmqw0KKEsk5AtydU3swI
	 B2C4bU2pQtnOtqezNUD1ML7A4sWJxuLLPKpnfnao7lmO+4YXdO061d81OJMpcPV0re
	 166xMJsSExkMLj/47bUWxu4uhNhmnIAWqoAYoQHipvbHl+J8LnN5/8FiuxpgVDsRIH
	 Q/GsRMYZobgDoCd7Agsrqw4tjITnAWsUPaMJ90gcvM0iBmz67+e6lRzK5e11H0jNUE
	 hiP3Vw62ax9+s1eoiiH59wyb10H3qGkVJank3GG64qr9khXYXTp8arpaIrCt/pmJEz
	 9lvbpR7sMR1Qw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] ksmbd: Remove unnecessary selection of CRYPTO_ECB
Date: Sat,  4 Apr 2026 12:43:38 -0700
Message-ID: <20260404194338.21168-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the SMB server never uses any ecb(...) algorithm from the
crypto_skcipher API, selecting CRYPTO_ECB is unnecessary.

Remove it along with the unused CRYPTO_BLK_* constants.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting the ksmbd tree.

 fs/smb/server/Kconfig      | 1 -
 fs/smb/server/crypto_ctx.h | 5 -----
 fs/smb/server/server.c     | 1 -
 3 files changed, 7 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 5c77c5552ed8a..37387410e5bb3 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -5,11 +5,10 @@ config SMB_SERVER
 	depends on FILE_LOCKING
 	select NLS
 	select NLS_UTF8
 	select NLS_UCS2_UTILS
 	select CRYPTO
-	select CRYPTO_ECB
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
diff --git a/fs/smb/server/crypto_ctx.h b/fs/smb/server/crypto_ctx.h
index b9476ed520ae4..27fd553d10aab 100644
--- a/fs/smb/server/crypto_ctx.h
+++ b/fs/smb/server/crypto_ctx.h
@@ -18,15 +18,10 @@ enum {
 	CRYPTO_AEAD_AES_GCM = 16,
 	CRYPTO_AEAD_AES_CCM,
 	CRYPTO_AEAD_MAX,
 };
 
-enum {
-	CRYPTO_BLK_ECBDES	= 32,
-	CRYPTO_BLK_MAX,
-};
-
 struct ksmbd_crypto_ctx {
 	struct list_head		list;
 
 	struct shash_desc		*desc[CRYPTO_SHASH_MAX];
 	struct crypto_aead		*ccmaes[CRYPTO_AEAD_MAX];
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 422d9d9782859..d8893079abdb5 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -627,11 +627,10 @@ static void __exit ksmbd_server_exit(void)
 }
 
 MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
 MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
 MODULE_SOFTDEP("pre: cmac");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");

base-commit: 2febe6e6ee6e34c7754eff3c4d81aa7b0dcb7979
-- 
2.53.0

