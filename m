Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F19E288C8A;
	Mon, 14 Apr 2025 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637242; cv=none; b=Pk+EQijuUd0zIriAzCgzf0zeQpwsedbGxqnWepLBWQFVrWRVZHCcjE1uqIeWLeDJk/pyW4XZHYULdOcFU0gl74Mm7aalnKDAmGBkf8vbaYLpE62XRDkvGLNT+bCA1oZMl5IF3U1Ic6k4eDfhgBU6QsKNRrt0nEjDzzZEm1iWZy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637242; c=relaxed/simple;
	bh=TkPcYpnTUJ0AD0bSL3uf90lbtHZ+XxKlBbkZ54lsFLA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h4EBkn1h7Hzg7oHGbDc0J1RbhnSU156qSTIQIIpYDYGMuixL5Gia1TQUKV0dL/crT5B6KLGzcIJAW+/0lEP7VLclwyWcnBnY12JWXjf6nEYBSZreFtXcp+SwgJINnUpGLmnGjPeugy8OvPMd3VQghdxpacEKXFVadCc22ItA0D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qYqo7w1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qYqo7w1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF62C4CEE9;
	Mon, 14 Apr 2025 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637242;
	bh=TkPcYpnTUJ0AD0bSL3uf90lbtHZ+XxKlBbkZ54lsFLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYqo7w1JjDo+SgAp7N5B0hcypZyPBE1wTzyOglS8241JoluM5wDO2tDo/bTmfgQJe
	 2WYNQBK534aBKaE9bR7WDJWxXMCtfmcwu6523V+fCyPD4+tx7hI6OIEdjzQ6PMLfId
	 OETbkUsDQYsKZnbFOm4JRNdXKy3Diy0Rqlxk9H9lCqSqHn6kxAD01cKc/3S5csQ/30
	 OkD9yIgCF3OgILPxHoVRvGkuOjDRMzQykqfqiGf9OmPM/KOkjgIy9PW9o9Nm5KL3qv
	 Rv8lambf6XTOWrduXa59vyOdag+vCNFSsBki8+C437TNSLAEACB0/hsrfowcj6LdsW
	 QlsUCrP6B6U+A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 31/34] cifs: Fix querying of WSL CHR and BLK reparse points over SMB1
Date: Mon, 14 Apr 2025 09:26:07 -0400
Message-Id: <20250414132610.677644-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250414132610.677644-1-sashal@kernel.org>
References: <20250414132610.677644-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.2
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit ef86ab131d9127dfbfa8f06e12441d05fdfb090b ]

When reparse point in SMB1 query_path_info() callback was detected then
query also for EA $LXDEV. In this EA are stored device major and minor
numbers used by WSL CHR and BLK reparse points. Without major and minor
numbers, stat() syscall does not work for char and block devices.

Similar code is already in SMB2+ query_path_info() callback function.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb1ops.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index d6e2fb669c401..808970e4a7142 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -573,6 +573,42 @@ static int cifs_query_path_info(const unsigned int xid,
 		data->reparse_point = le32_to_cpu(fi.Attributes) & ATTR_REPARSE;
 	}
 
+#ifdef CONFIG_CIFS_XATTR
+	/*
+	 * For WSL CHR and BLK reparse points it is required to fetch
+	 * EA $LXDEV which contains major and minor device numbers.
+	 */
+	if (!rc && data->reparse_point) {
+		struct smb2_file_full_ea_info *ea;
+
+		ea = (struct smb2_file_full_ea_info *)data->wsl.eas;
+		rc = CIFSSMBQAllEAs(xid, tcon, full_path, SMB2_WSL_XATTR_DEV,
+				    &ea->ea_data[SMB2_WSL_XATTR_NAME_LEN + 1],
+				    SMB2_WSL_XATTR_DEV_SIZE, cifs_sb);
+		if (rc == SMB2_WSL_XATTR_DEV_SIZE) {
+			ea->next_entry_offset = cpu_to_le32(0);
+			ea->flags = 0;
+			ea->ea_name_length = SMB2_WSL_XATTR_NAME_LEN;
+			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
+			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
+			data->wsl.eas_len = sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
+					    SMB2_WSL_XATTR_DEV_SIZE;
+			rc = 0;
+		} else if (rc >= 0) {
+			/* It is an error if EA $LXDEV has wrong size. */
+			rc = -EINVAL;
+		} else {
+			/*
+			 * In all other cases ignore error if fetching
+			 * of EA $LXDEV failed. It is needed only for
+			 * WSL CHR and BLK reparse points and wsl_to_fattr()
+			 * handle the case when EA is missing.
+			 */
+			rc = 0;
+		}
+	}
+#endif
+
 	return rc;
 }
 
-- 
2.39.5

