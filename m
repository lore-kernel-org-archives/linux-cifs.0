Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294792E62DC;
	Mon, 14 Apr 2025 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637391; cv=none; b=Wax93FSusjyf1sv2MqAsJ/z03SN4gtUIFZQO40zNJ0qPhzzIQ61EdV3Gp2OQkvmXoctLqwUk5cJU/s0ajmuiPzdcWC7sQYoAfX417k5XBZP1aH+i5g3SeCMKizq10U2kDHA1+KAyp8Wohwn5IQn3zb+otFzCdRW6UYOZJAkZocM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637391; c=relaxed/simple;
	bh=dByaXTsfwiBh8dWHjGZAuH4OEsIXcsEUBHnNOKSQ440=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qg8UXRD4V+CbPBp6GtQ5710RXnjuXMvNpD/uAi22IPA4AzAciGt2iO44y7hMLcAQ7A32A4timenCxZpje6NUN9DO0Nxv7lSQVKUy/E00w4fI75LQ+aPHn4Pl9vb47Qn87VRJkIJc1q//AiVjJAIqGRITAS3PzGXFFa5N1C9WpeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEZA7+0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEZA7+0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7174AC4CEE9;
	Mon, 14 Apr 2025 13:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637390;
	bh=dByaXTsfwiBh8dWHjGZAuH4OEsIXcsEUBHnNOKSQ440=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEZA7+0R16cZMmzkYxqt2x01pf7wMujY2DHdhlPq16cBcZBiWVW9EMBMjghAB7laM
	 4TH/mBTyChkjEQk4eoPdvi8B+Br8x8Z0cThGvnkW85zu7dxCsS1iHfFPQvEljBtGxp
	 xGdwi5TdP2Ajf7WijzcyTPuxk/47+7j2z8SeYP4qweq+4u1rJcafRMydr1lBMrCpjT
	 PhRVvD/3rlj4mc7enBlEUI0WRx6W9TVXtKnAmDigRbTp11OccIgamreqtniYF/96NR
	 xp3xkbIHzzlaNwQxhMSjKsVY3Cm404k9pKWhYRIO935fFeJ3yLVyC6sVMi1avoqWgq
	 VUsMVJsbDPOiQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 27/30] cifs: Fix querying of WSL CHR and BLK reparse points over SMB1
Date: Mon, 14 Apr 2025 09:28:44 -0400
Message-Id: <20250414132848.679855-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250414132848.679855-1-sashal@kernel.org>
References: <20250414132848.679855-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.23
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

