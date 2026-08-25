Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6148F840;
	Tue, 25 Aug 2026 23:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699201; cv=none; b=uNR5jcG4XMu6leALr4nvIe34FNKuM2WT3xfEAva+xJ9xeY6ikK/JRdYkws0N+zK0888bdH+oQUX99gZPV1UXWTKmkPCY++Eg8Q/yGTjKOh4oUvkR9CUrORf6uvMoBHUFNW2Bh8OXuQs/clFbT0hdzMaDSZ2ietqL7V6+27KwzCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699201; c=relaxed/simple;
	bh=q2Ei41Y11MFF2/b53uWHu8ayeIPSqaktV1miV0qAvI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g06aWqOhnkIdanlI8/sXp+eNQO/0+THQK9OqRwg9dEBnsrpDxZb14vRBZVGNfLXuLV3xbTXBm7HWfqItB10U0wptlPuizJO+VY3dtg0PU3xqRgHHCXQuZBaVo0Rjv5MhttedE+O2zb/501KVx+7dgqLP3CnkdPxMsYJFTkZ5JNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVLWZtat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVLWZtat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E65C1F00AC4;
	Tue, 25 Aug 2026 23:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699199;
	bh=FiJW31P5b4O0YSIeFro0cKeuQPEuh4lHSwZF2XN4elM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVLWZtatFJBqdsOwFXPvVYuRYxkwNASZ51M06Ry3giclJhrKQ0iugMgqZZxn+HmV4
	 DQNw/mRNmXKIAsPdZSnpOwpHexnYOzyIfxHLl+6PbPk6AO2tWf6NkXXFtXNkO0zCGo
	 LCG5gOWfvCrCXJgriwumPaumd1HP55sPnyFH6T/j/7dQjAwUZF3CxrBWeSQE+C8UQZ
	 XFj2E8e2lJgIpEN75fOHZE/SJGT7wGoYzmsRPiHzJ306QR/leJ6RL/tmwfFsclxPuH
	 j3afwVTvzFDOCDWlyexR5suR3Eqa6Q+qEab6IkZMyCSCXqHlSfG4FRID1eKln1O5j4
	 8LhnMpsL5bgAQ==
Received: by pali.im (Postfix)
	id B1D1311E3; Wed, 26 Aug 2026 01:06:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] cifs: Check if server supports EAs before trying to set it for WSL
Date: Wed, 26 Aug 2026 01:06:18 +0200
Message-Id: <20260825230622.24617-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825230622.24617-1-pali@kernel.org>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
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
index 233a445ba811..0829f5373a38 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -683,6 +683,13 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
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

