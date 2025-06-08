Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CB71CF7AF;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749402103; cv=none; b=b49lea55eKnbni0CBTVwXxOX/RNM1TtZ8z+JSVy8/7NFivKOLlmZcm404laq6osZax4ho2bKqV3NschNccZT58bO4EywqflML61RFMDw2dbtfzr3eiw+pryoWT8U7iise3ryqRAretDcSW9+OjkDeROsjtqSR7PBALcfl6H2Vo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749402103; c=relaxed/simple;
	bh=4fz3mfBElZAWsePM46+AzQNt4ktJShwT/EJVGIOHJTc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QsT2mDUZcy617vsLOnVlC+tY5w6WBsQzcvRow4tjjL2/ytLLaaopqBOWo06SFeiv1kqMqYdAB68F5hYr43cDlHOkYVX0hTqhUKPB8y8hR/qUL2AbsRx6DdGDFX7aCAWTTFW6/tcugPyeyItPdh/9l7MgLMdtAe0B97MYn9faOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2ruSaKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2ruSaKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6F3C4CEF5;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749402101;
	bh=4fz3mfBElZAWsePM46+AzQNt4ktJShwT/EJVGIOHJTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2ruSaKHKmKBvwgickWxb51S8LUpxx35RkpF3eKLEBJkKU/oLRhXJBvtU0EmKgoR3
	 hlby20y/YGJ8rZe+1hP7HAGmz8I0J4ofeoZmd9NtqaLNcEYVxujjvkasjBbVaXecZ/
	 W0gGViii+TibcCTrXMI0noX0k3WFj7bGhIJ+TeGNEtyEAPQgOeHRFcly9tGeO1QQou
	 yU22i034qq5tFMK3QFBdS1z7RAZFKU0UWIxpr5dAu1qLwWm4LJu19j9AtdV/6emWwf
	 sANksGEl51vxi7ey0aznEnjN741HW/1/VyX2jhClI/DDB3lUa7e+DPjEM++CASYnMi
	 NKcYkt4/xLWTQ==
Received: by pali.im (Postfix)
	id DD5B310AE; Sun,  8 Jun 2025 19:01:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] cifs: Query EA $LXMOD in cifs_query_path_info() for WSL reparse points
Date: Sun,  8 Jun 2025 19:01:18 +0200
Message-Id: <20250608170119.6813-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250608170119.6813-1-pali@kernel.org>
References: <20250608170119.6813-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

EA $LXMOD is required for WSL non-symlink reparse points.

Fixes: ef86ab131d91 ("cifs: Fix querying of WSL CHR and BLK reparse points over SMB1")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 62 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index df955cecdd4c..1f9166143ab1 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -659,14 +659,72 @@ static int cifs_query_path_info(const unsigned int xid,
 	}
 
 #ifdef CONFIG_CIFS_XATTR
+	/*
+	 * For non-symlink WSL reparse points it is required to fetch
+	 * EA $LXMOD which contains in its S_DT part the mandatory file type.
+	 */
+	if (!rc && data->reparse_point) {
+		struct smb2_file_full_ea_info *ea;
+		u32 next = 0;
+
+		ea = (struct smb2_file_full_ea_info *)data->wsl.eas;
+		do {
+			ea = (void *)((u8 *)ea + next);
+			next = le32_to_cpu(ea->next_entry_offset);
+		} while (next);
+		if (le16_to_cpu(ea->ea_value_length)) {
+			ea->next_entry_offset = cpu_to_le32(ALIGN(sizeof(*ea) +
+						ea->ea_name_length + 1 +
+						le16_to_cpu(ea->ea_value_length), 4));
+			ea = (void *)((u8 *)ea + le32_to_cpu(ea->next_entry_offset));
+		}
+
+		rc = CIFSSMBQAllEAs(xid, tcon, full_path, SMB2_WSL_XATTR_MODE,
+				    &ea->ea_data[SMB2_WSL_XATTR_NAME_LEN + 1],
+				    SMB2_WSL_XATTR_MODE_SIZE, cifs_sb);
+		if (rc == SMB2_WSL_XATTR_MODE_SIZE) {
+			ea->next_entry_offset = cpu_to_le32(0);
+			ea->flags = 0;
+			ea->ea_name_length = SMB2_WSL_XATTR_NAME_LEN;
+			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_MODE_SIZE);
+			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_MODE, SMB2_WSL_XATTR_NAME_LEN + 1);
+			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
+						   SMB2_WSL_XATTR_MODE_SIZE, 4);
+			rc = 0;
+		} else if (rc >= 0) {
+			/* It is an error if EA $LXMOD has wrong size. */
+			rc = -EINVAL;
+		} else {
+			/*
+			 * In all other cases ignore error if fetching
+			 * of EA $LXMOD failed. It is needed only for
+			 * non-symlink WSL reparse points and wsl_to_fattr()
+			 * handle the case when EA is missing.
+			 */
+			rc = 0;
+		}
+	}
+
 	/*
 	 * For WSL CHR and BLK reparse points it is required to fetch
 	 * EA $LXDEV which contains major and minor device numbers.
 	 */
 	if (!rc && data->reparse_point) {
 		struct smb2_file_full_ea_info *ea;
+		u32 next = 0;
 
 		ea = (struct smb2_file_full_ea_info *)data->wsl.eas;
+		do {
+			ea = (void *)((u8 *)ea + next);
+			next = le32_to_cpu(ea->next_entry_offset);
+		} while (next);
+		if (le16_to_cpu(ea->ea_value_length)) {
+			ea->next_entry_offset = cpu_to_le32(ALIGN(sizeof(*ea) +
+						ea->ea_name_length + 1 +
+						le16_to_cpu(ea->ea_value_length), 4));
+			ea = (void *)((u8 *)ea + le32_to_cpu(ea->next_entry_offset));
+		}
+
 		rc = CIFSSMBQAllEAs(xid, tcon, full_path, SMB2_WSL_XATTR_DEV,
 				    &ea->ea_data[SMB2_WSL_XATTR_NAME_LEN + 1],
 				    SMB2_WSL_XATTR_DEV_SIZE, cifs_sb);
@@ -676,8 +734,8 @@ static int cifs_query_path_info(const unsigned int xid,
 			ea->ea_name_length = SMB2_WSL_XATTR_NAME_LEN;
 			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
 			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
-			data->wsl.eas_len = sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
-					    SMB2_WSL_XATTR_DEV_SIZE;
+			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
+						   SMB2_WSL_XATTR_MODE_SIZE, 4);
 			rc = 0;
 		} else if (rc >= 0) {
 			/* It is an error if EA $LXDEV has wrong size. */
-- 
2.20.1

