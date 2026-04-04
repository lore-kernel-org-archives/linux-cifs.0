Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344F1137923;
	Sat,  4 Apr 2026 19:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775331864; cv=none; b=u6u1W4xQklI6z2lGDg560VkNIyUm2yPefjZqX9KPWG0+Sju2P/tYG24NorJcsZu91QA1+oPpIts8aghkTE8UDqFIpsKtqON2WQc3brs+fZXl/91LLGcawHLdg4bLDq2dSdNOBP088QrKzm6BByaVHCuoqDtUcaN/zqq0w2x9qdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775331864; c=relaxed/simple;
	bh=m2A5Yy4h38l28Ps/ZrrBwv9IT49CQmsgL2an3SFnHTk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f1K/fX1vC50rmc3mfF/fK79jbCcbY/GtychOcj47LOD9ZY4YpCQ2YZ9cYSHOCAAhFnRJaDxegR4/NDuAlGDEs9uDHO/CHuJ6Ht1+fjew0+WB+ZTJDxmL6GYDiEAQOvQxinmdgmRdpgz3IXo9T/1q7tb03vdNnPvrG6taQEiA5uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIQdg8um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIQdg8um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670C6C19421;
	Sat,  4 Apr 2026 19:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775331863;
	bh=m2A5Yy4h38l28Ps/ZrrBwv9IT49CQmsgL2an3SFnHTk=;
	h=From:To:Cc:Subject:Date:From;
	b=JIQdg8umcnQlwISS4DvXHi/wH6tuHU7aivaPznHQWFzjz8Fimf0r2dOo/kh1H3Prd
	 DNXN8quF1e6CDBQ2LF5KHK84ecVwisgPnVIjcapCUZzgk4r8OfQB2WMusFu94VvPpQ
	 eKRvUM0HEOBky+baMDkCrp4b0hXaJtT1hSINDE5mdyqsbo3QuM1isLh4pQTbFnBU+e
	 oyZEE6tgsbSURPDWs1+Zezb/FwAb7c2osbEm4WT00MeqLuK2W8eFBBKI7+fIEFFQvG
	 cJudpplgGtWBmjF92NK2VKaLh1qnhBbT1PXTotyVI7zJ7q0/T1tEz/3P6S/24w5fjL
	 yja+nyP2ZSEbg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] smb: client: Remove unnecessary selection of CRYPTO_ECB
Date: Sat,  4 Apr 2026 12:42:10 -0700
Message-ID: <20260404194210.20876-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the SMB client never uses any ecb(...) algorithm from the
crypto_skcipher API, selecting CRYPTO_ECB is unnecessary.

Specifically, it has been unnecessary since commit 06deeec77a5a ("cifs:
Fix smbencrypt() to stop pointing a scatterlist at the stack") in 2016.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting the smb client tree.

 fs/smb/client/Kconfig  | 1 -
 fs/smb/client/cifsfs.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 6d7e178e202db..63831242fddfb 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -7,11 +7,10 @@ config CIFS
 	select CRYPTO
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
-	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 0541706c36c52..2025739f070ac 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2156,11 +2156,10 @@ MODULE_AUTHOR("Steve French");
 MODULE_LICENSE("GPL");	/* combination of LGPL + GPL source behaves as GPL */
 MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
-MODULE_SOFTDEP("ecb");
 MODULE_SOFTDEP("nls");
 MODULE_SOFTDEP("aes");
 MODULE_SOFTDEP("cmac");
 MODULE_SOFTDEP("aead2");
 MODULE_SOFTDEP("ccm");

base-commit: 2febe6e6ee6e34c7754eff3c4d81aa7b0dcb7979
-- 
2.53.0

