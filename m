Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAAE260566;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=E8h4/DEPBIkCgRO6mDm92iH3Cn9w4LcjlFaHTzLhN/nS52z14RxSsYSjX7lEIDy0xPCffyE1Rmpb5bSh25KLHMZpz0KcgJDMk9glSOuYzjevxmm41I5+dq4kKihLLE1rqdMY2QYzS9Y0oobgA6FHHcv1+4LTQm8y4YmCIhS7SHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=Xq06GFTx1+d7lXTSarZu2S3z+Y49rpz/H7is/9UlQFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdrPzUUro2uHgZz8mB0XZVOCBFGAu7v44I8EJgTbPnKbhEQYNaa+KT1xQ1+5Yzgw3dlIQkHbaKV+9LOCtBUGgt8gGlekC2P3bD/EOMYt3dkNbVlCGNV38GVBN8k4mZKY1lNvEbKCMOqzNzcyEBzNNFEyf6HTu1AViU4eor6ixuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0EVwz/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0EVwz/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95379C4CEF8;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643795;
	bh=Xq06GFTx1+d7lXTSarZu2S3z+Y49rpz/H7is/9UlQFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0EVwz/R2fTzK+KEFX+oSnvS/HQdxa6Y1yCp4oqPW1X3jqAe1Y6XdCoOFh8l9NiEf
	 sSGuCPfXc1fSMfrMJc0UCAyeRipirCW05T1gVbpWawDuXBxbg8ZQxfvMR6xvlBesYa
	 cYmI4c+yKwig8dem/b42G1OqniFcN3wlfXK6AMEUesselbppYrS0JnYfhfEFXh1XbK
	 jkloLh9fqtJxhqbH2WxtQtZDjyGlduo3JumknC23YIgcSRPkn/ZwtoIWjTpGdI3d76
	 pWA8F7dWMwgvVb+A/nuVkopVdDFWK5bwk5DZgVBIDzBVuQ0bfBoQUE80LgdC5u6xfr
	 TNSLasdpAemrA==
Received: by pali.im (Postfix)
	id 41CB0EB3; Sun, 31 Aug 2025 14:36:31 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/35] cifs: Add fallback code path for cifs_mkdir_setinfo()
Date: Sun, 31 Aug 2025 14:35:30 +0200
Message-Id: <20250831123602.14037-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use SMBSetInformation() as a fallback function (when CIFSSMBSetPathInfo()
fails) which can set attribudes on the directory, including changing
read-only attribute.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index cc4feebbdd11..de415b9945ee 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -824,6 +824,11 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 	info.Attributes = cpu_to_le32(dosattrs);
 	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info, cifs_sb->local_nls,
 				cifs_sb);
+	if (rc == -EOPNOTSUPP || rc == -EINVAL)
+		rc = SMBSetInformation(xid, tcon, full_path,
+				       info.Attributes,
+				       0 /* do not change write time */,
+				       cifs_sb->local_nls, cifs_sb);
 	if (rc == 0)
 		cifsInode->cifsAttrs = dosattrs;
 }
-- 
2.20.1

