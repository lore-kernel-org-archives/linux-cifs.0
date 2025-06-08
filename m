Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9C419ADBA;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749402102; cv=none; b=Znq7D09rZMFPejZ9Bz4QFXpJYDxJdtxsaewZW1kYKPyaf3sc/SYc4zPm145//00TtsTxKKRibmJjz1tM1DLeuE7ElHlKF1+yxTw+0pxIkuEpHE4oXlTJZe6/gUQb7xpmkcq1RMI/JOtVzRQKPwAQR++FBjUCSxf57M6cLry4jPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749402102; c=relaxed/simple;
	bh=x1z4UyxTCtVi8S4w/KToWuSTzpJrpetpz98Zlw0Ewhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YbAVq5wUr68NacoDvM55FAHH7ijvjym6ZmwhPiG8horQChKaGpww2teasbtWUq24WFg0bnx4wCSgPVA2U1vlIl+4ISQ2P0u03czzS2a/Usrw+dcItPLQg7MuU4OHIdYyxgq6652I51+YGiVtpdDqa+Ockmx8tTiiHROiB2VYgfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tA1gI075; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tA1gI075"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2C3C4CEF6;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749402101;
	bh=x1z4UyxTCtVi8S4w/KToWuSTzpJrpetpz98Zlw0Ewhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tA1gI075IIeFWFRj7/qf6+iXfGXlmPYxxCZCKXkOw24TOjBmB2dxx9nqNIXtxRNKs
	 S5bCv9m3dYvnHscTg1pNA3HN+1hZvYSvhR4Dh/lQfhUUqtoh+LB87HUk0eaPoZzUuF
	 uqTnNPlKcHIc1fPTf2e/SHOnZcLIsVqku7+DEjvmUyC0MW+Gk75SfTdZ2mzilxQBNe
	 L+ArvrGQL5pRkGA5GX0FY4P4w2Lvn4DYuO8AJ+W6IZpU9nNCBCzq3NvHDPhTHe9uGU
	 SwlU66I1vkA7BXVD1ncwViVnNBRsnpRh0yqCgz2YnsQgNjoj25z7xYGHBo307tYyJZ
	 nwvw0C4nGhN6w==
Received: by pali.im (Postfix)
	id 2172C12DA; Sun,  8 Jun 2025 19:01:39 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] cifs: Validate presence of EA $LXMOD for WSL reparse points
Date: Sun,  8 Jun 2025 19:01:19 +0200
Message-Id: <20250608170119.6813-6-pali@kernel.org>
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

S_DT part of EA $LXMOD is mandatory for all WSL reparse points except the
WSL symlink and Win32 socket. Microsoft WSL subsystem does not recognize
them without EA $LXMOD too, and treat such inodes as regular files.

Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 8d989e436517..3dffd5f0dc07 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1118,6 +1118,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 {
 	struct smb2_file_full_ea_info *ea;
 	bool ignore_missing_eas = false;
+	bool have_xattr_mode = false;
 	bool have_xattr_dev = false;
 	umode_t reparse_mode_type = 0;
 	u32 next = 0;
@@ -1177,6 +1178,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			have_xattr_mode = true;
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
@@ -1188,6 +1190,16 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
 		return ignore_missing_eas;
 
+	/*
+	 * S_DT part of xattr MODE is mandatory for all WSL reparse points except the WSL symlink.
+	 * Microsoft WSL does not recognize them without xattr MODE too (except the WSL symlink).
+	 * IO_REPARSE_TAG_AF_UNIX is here an exception because this reparse point is used by both
+	 * WSL subsystem and native NT/WinAPI subsystems. And NT/WinAPI creates AF UNIX socket
+	 * without the xattr MODE and recognize it also without the xattr MODE.
+	 */
+	if (!have_xattr_mode && (tag != IO_REPARSE_TAG_AF_UNIX && tag != IO_REPARSE_TAG_LX_SYMLINK))
+		return ignore_missing_eas;
+
 	fattr->cf_mode |= reparse_mode_type;
 	return true;
 }
-- 
2.20.1

