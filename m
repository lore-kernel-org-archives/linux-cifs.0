Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7531B78F3
	for <linux-cifs@vger.kernel.org>; Sun,  8 Jun 2025 18:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749409169; cv=none; b=nyKwWsIzJ7tDpsbssLdQHFRBH1BWHxhs1EAg3fEboX79wmahft3MhsMbXrDNGvYhsrLwvMTLX6vAZ/uBi6dEXqZcLEjFJwtzwpoJ+DsSCMSeQ0nTXpVh1ML1464y9REUpk/77SIOJB7Cfiz7V15mlFJiOjRLVkAkcS68zqcU1/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749409169; c=relaxed/simple;
	bh=uWGR2gO0KIDV5+ZztU4lRWEStbbHLxNZ5238W0A/EL8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TYNzeR4SjuBZkZG7m9NsCqtHCi/dhsYSlYSVuVmGuxEXG4H8CbRTGYXLkJxibOUl3/elNJ7LyXM8Ne8x+pURfZ6CHttby5vMoKX6WVHglWIYxsglyrxEPOQbS2GqgA97heF7aV7p0DQ5n8bFd/0+oDjGWI4iYvBEO9EsHl8JAeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=bfT0VYU8; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="bfT0VYU8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1749409159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gQs/B2CZZt2/jVY/NZsNvyBss+k2o0CL73Cpnxr/SoE=;
	b=bfT0VYU8awDXK2AtDm4g7QUGotOBvK31KbXXelMBm0K3BGesqmSDZnCidywvsiN1YSebfz
	dc4XdajbD5v9eylbkTtr9iEdxx+srJC5/isfaLSM9sU1A/kfWAKQraT3OYve0xdlbDziRa
	mSyB6w3SgDJ9a60hi4+bSWI40aM5wDteg74sJmDKgeDrSgBsqy1vLOrQX9Qtd7cPPvsOV5
	h4rS/YJIT8WRbgxIpY50i5d79TJBN3RnEv+4spfXAUDioVKBG+bk+RSTZU3duaXAhhh0qb
	iA9Il00fix3wS8HeDGKEr3Z78HKrcaGQgCsH8QxAzsqPPWE/oHSIcLKGrYfs+w==
From: Philipp Kerling <pkerling@casix.org>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	Philipp Kerling <pkerling@casix.org>
Subject: [PATCH] smb: client: disable path remapping with POSIX extensions
Date: Sun,  8 Jun 2025 20:59:00 +0200
Message-Id: <20250608185900.439023-1-pkerling@rx2.rx-server.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If SMB 3.1.1 POSIX Extensions are available and negotiated, the client
should be able to use all characters and not remap anything. Currently, the
user has to explicitly request this behavior by specifying the "nomapposix"
mount option.

Link: https://lore.kernel.org/4195bb677b33d680e77549890a4f4dd3b474ceaf.camel@rx2.rx-server.de
Signed-off-by: Philipp Kerling <pkerling@casix.org>
---
 Documentation/admin-guide/cifs/usage.rst |  2 ++
 fs/smb/client/connect.c                  | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cifs/usage.rst b/Documentation/admin-guide/cifs/usage.rst
index c09674a75a9e..d989ae5778ba 100644
--- a/Documentation/admin-guide/cifs/usage.rst
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -270,6 +270,8 @@ configured for Unix Extensions (and the client has not disabled
 illegal Windows/NTFS/SMB characters to a remap range (this mount parameter
 is the default for SMB3). This remap (``mapposix``) range is also
 compatible with Mac (and "Services for Mac" on some older Windows).
+When POSIX Extensions for SMB 3.1.1 are negotiated, remapping is automatically
+disabled.
 
 CIFS VFS Mount Options
 ======================
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 024817d40c5f..4e60ceb7455d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3722,9 +3722,15 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 		goto out;
 	}
 
-	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
-	if (tcon->posix_extensions)
+	/*
+	 * if new SMB3.11 POSIX extensions are supported, do not change anything in the
+	 * path (i.e., do not remap / and \ and do not map any special characters)
+	 */
+	if (tcon->posix_extensions) {
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
+		cifs_sb->mnt_cifs_flags &= ~(CIFS_MOUNT_MAP_SFM_CHR |
+					     CIFS_MOUNT_MAP_SPECIAL_CHR);
+	}
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	/* tell server which Unix caps we support */
-- 
2.49.0

