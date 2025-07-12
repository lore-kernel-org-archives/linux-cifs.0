Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2777E1F1906;
	Sat, 12 Jul 2025 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752336469; cv=none; b=fv8+33UUMsZNK0Qt5GPs93rn3mPgep0zwdM/Won6rycXG5GlDdAL58QvGDzv3QTz7hbqhRqAC9ZactA9FeGaqe7KNQ+ngbRSP4nIbRXHWtRDHmRVopbH8I6p9GkgdRBbnnNONieFmWjmOnxiYwaUVkiL9zb3M4uzp1h2ehUGZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752336469; c=relaxed/simple;
	bh=bKfYo7WYQpIkfjMbVOrGNeyhRMqIl2+EbzZ1ppPgDQI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ZOuyADLVGFumSKyfeFNcSFW9JG+3Gmor1Rw1+RzjIm4xQnZDZ4o/C04BopD0+YObEtYuBVumEON5HxCQfpUOI02GqVIEN3O7nFFNQb9lmT85b8M/hT2fVoe/hzrGD0jhSAtPFf12Id+i8LWTygMxSwozNzCfPDhqWcJgHTIE8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTtDxuYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTtDxuYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839A3C4CEEF;
	Sat, 12 Jul 2025 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752336468;
	bh=bKfYo7WYQpIkfjMbVOrGNeyhRMqIl2+EbzZ1ppPgDQI=;
	h=From:To:Cc:Subject:Date:From;
	b=JTtDxuYpwEo1UB+lnCLuoJrC/OeCL/U7v+s/WwHV/6bUPKi6iMrNzPI9/IraCnBpY
	 txSJbt6/A41Yrs36Wo6jPwQN0vtDKLSWUZoVNfGJvUl7AIbSOQ+Rg5mBKb6zfzus4Q
	 MNF8024U8CiG6pWnfF6Orp5Yzi733nA6Kh6DgrtZO35HNDTzee6OrWeXlYfZE+LwUl
	 2WL/Awj1bYfCkQPG87fSa3L88ooRfo87ec58yRVNCdebfM/M+b6iXaMYsv2aSsCdAq
	 zW0mnqDZA4d3wdour5e148wRCxM59ylqW6v9786U+/WmFUOXelF10eneLHkgRgmlAE
	 q60Dfo8LFUY5g==
Received: by pali.im (Postfix)
	id 66A087E2; Sat, 12 Jul 2025 18:07:46 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Check if server supports EAs before trying to set it for WSL
Date: Sat, 12 Jul 2025 18:07:32 +0200
Message-Id: <20250712160732.17580-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

WSL special files store information into EAs. When EAs are not supported
on the server filesystem then fast fail in mknod_wsl() function.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index faf208bef926..ee4af153e7af 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -665,6 +665,13 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	struct kvec reparse_iov, xattr_iov;
 	int rc;
 
+	/*
+	 * WSL special files store information into EAs. When EAs are not
+	 * supported on the server filesystem then fast fail.
+	 */
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
+		return -EOPNOTSUPP;
+
 	rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse_iov);
 	if (rc)
 		return rc;
-- 
2.20.1

