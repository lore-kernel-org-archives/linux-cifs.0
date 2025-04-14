Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D2E2949F4;
	Mon, 14 Apr 2025 13:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637321; cv=none; b=KX3YVdCvqXS/vWQL86UmYCxnD+wTJcP5Ev0nfgkaQOiWUfJNaMXAvf2yJqsjbnnu1Z+ohLJ99OJtdLHfCpAEs/r8XvK23Cm9OSzatlfmw6wtFmEn6X+lNiT9qcUOfsRx7V+pa37+wand5RkgkDAjPjBrww1g8gqiXkTWCyfvCCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637321; c=relaxed/simple;
	bh=dByaXTsfwiBh8dWHjGZAuH4OEsIXcsEUBHnNOKSQ440=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HavDxkU+pZinP7DKr3JgQvR4hZoAeSLBsr14yZ4pMriwNUY/C13Jm8Ua4TwFVyE1hYBdvH1OCC/K4BxjoNiGEAr9CD3tsTvTXf2HR8UHqUL408ENmixFANkLfGbhuVQHgHHWDjAPVbMxHu1+dwQqEbBG8/3IuR55aJeg+TtKxgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cy7kizvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cy7kizvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E37C4CEE2;
	Mon, 14 Apr 2025 13:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637321;
	bh=dByaXTsfwiBh8dWHjGZAuH4OEsIXcsEUBHnNOKSQ440=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cy7kizvByqb3D/8PLcr7UISkMnHEazDGOUIyzfOlz4ebymcZG0fqPFOjW083Sm2J3
	 HxGFaIYK1OXYVmZ/O6LUAmaW0sdFVwXWomRTKWn4Ifayn6DM/0mio+mNpG+xBtsFSR
	 dOEKnPQxVhcz/UrJjpwfBFRXYzwTZ4P7dl8Z/PsMbGugQV8kyGMH8gQqdSebCpmAqO
	 CzJ9onDfGxRcen5bTEKfM9nyhBlqUyQz0EdOhyawaZxKF9hUgg+vonf7lAvEnTKxrT
	 GUQnjmZQBn0l3vUQ4qLSRdbkYuiUvLzVyPstdX3bD7Pw1MpQb4KmOORP2yaxje0jfD
	 RTyqnsSzpPsEw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.13 31/34] cifs: Fix querying of WSL CHR and BLK reparse points over SMB1
Date: Mon, 14 Apr 2025 09:27:25 -0400
Message-Id: <20250414132729.679254-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250414132729.679254-1-sashal@kernel.org>
References: <20250414132729.679254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.11
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
index bd791aa54681f..55cceb8229323 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -597,6 +597,42 @@ static int cifs_query_path_info(const unsigned int xid,
 			CIFSSMBClose(xid, tcon, fid.netfid);
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

