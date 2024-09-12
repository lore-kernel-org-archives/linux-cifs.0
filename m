Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA221A0BFF;
	Thu, 12 Sep 2024 12:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142761; cv=none; b=tFeDrWpdCdw2GrypYG6q5xFoqyfW1XuS9S5gO7N9/VaSn7EqCTXiLAAEDfGED7ybLM1gBVCXtgw0tYt234WY/YkzojuvWF5Uop9XxFeoLZznF+K4lUMS0dkoCsDu02XOiNnL7LzBqtGafrOP3kfNZbu4z7Dow+EaZXEhWcNOGX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142761; c=relaxed/simple;
	bh=cQz+jNq/ftZXX/k+WOGLdN1FFcKYmae9h3VM8SsnEvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lH9veEuwL9FnnTWGshqYqVxkwNiN7iY7bu5pIbKqjtXJabjsB5Krwb4lF1KoPotfD2CIiS9BxjcV4somSC0Y1BWWuuwi5/pY4smsb9aaR3chdLFarHbxJzOZOhn4TsQmf5R7jtOOJosRClrI9OLowQBDgSsPoxLdnhaSkoNx+Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZ6fDvyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZ6fDvyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EB6C4CED0;
	Thu, 12 Sep 2024 12:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726142761;
	bh=cQz+jNq/ftZXX/k+WOGLdN1FFcKYmae9h3VM8SsnEvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZ6fDvyI6Mu7SwMjIFKh0gosTj02P4h5vvQClFPvFuBVNTxIxWiStVKGIxP0T52gU
	 TjtW4sltZcmAsBMmZ8s2UVt/D7lbj+HkQMO3rssHLV273G7P/KYb8W9Tln1q/5iq42
	 v02t+ex1mYHENrqaaRdoAufnGH3jZLKlrTy0yvW1KcFK19wUpdK3Rf4h82WrBse+nq
	 70kHOk59iXaEzSauFVLHt8gZ6xN1o5z6a0fD7ywkcfmUBR6eO6ByzxSAPIZCMrxYEo
	 Fygh5AkWmFxgd+9ScLm8NmghrsVFeZujBug3y6bAWojiD5I1q8+e68IElmUpLsQ/RA
	 XoGzUugXfNzMg==
Received: by pali.im (Postfix)
	id 5C15EB9A; Thu, 12 Sep 2024 14:05:55 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] cifs: Put explicit zero byte into SFU block/char types
Date: Thu, 12 Sep 2024 14:05:44 +0200
Message-Id: <20240912120548.15877-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912120548.15877-1-pali@kernel.org>
References: <20240912120548.15877-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU types IntxCHR and IntxBLK are 8 bytes with zero as last byte. Make it
explicit in memcpy and memset calls, so the zero byte is visible in the
code (and not hidden as string trailing nul byte).

It is important for reader to show the last byte for block and char types
because it differs from the last byte of symlink type (which has it 0x01).

Also it is important to show that the type is not nul-term string, but
rather 8 bytes (with some printable bytes).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c   | 4 ++--
 fs/smb/client/smb2ops.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index e8567ed63f22..d8c39989840e 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -586,7 +586,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 	rc = tcon->ses->server->ops->sync_read(xid, &fid, &io_parms,
 					&bytes_read, &pbuf, &buf_type);
 	if ((rc == 0) && (bytes_read >= 8)) {
-		if (memcmp("IntxBLK", pbuf, 8) == 0) {
+		if (memcmp("IntxBLK\0", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "Block device\n");
 			fattr->cf_mode |= S_IFBLK;
 			fattr->cf_dtype = DT_BLK;
@@ -598,7 +598,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
 				fattr->cf_rdev = MKDEV(mjr, mnr);
 			}
-		} else if (memcmp("IntxCHR", pbuf, 8) == 0) {
+		} else if (memcmp("IntxCHR\0", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "Char device\n");
 			fattr->cf_mode |= S_IFCHR;
 			fattr->cf_dtype = DT_CHR;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e6540072ffb0..9c2d065d3cc4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5072,12 +5072,12 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 
 	switch (mode & S_IFMT) {
 	case S_IFCHR:
-		strscpy(pdev.type, "IntxCHR");
+		memcpy(pdev.type, "IntxCHR\0", 8);
 		pdev.major = cpu_to_le64(MAJOR(dev));
 		pdev.minor = cpu_to_le64(MINOR(dev));
 		break;
 	case S_IFBLK:
-		strscpy(pdev.type, "IntxBLK");
+		memcpy(pdev.type, "IntxBLK\0", 8);
 		pdev.major = cpu_to_le64(MAJOR(dev));
 		pdev.minor = cpu_to_le64(MINOR(dev));
 		break;
-- 
2.20.1

