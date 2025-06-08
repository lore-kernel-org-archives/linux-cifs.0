Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAEF188CCA;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749402101; cv=none; b=EzCcBPwFI4xGxf9xu2PhAasjPASlf0QUw+1KXPJrnY79dEjOGLAf4Zf6e6puQgi3IjQD6Yz+adLT5/Uad1NlugLr6czdLCAJEA2YAAujFFSwX9wY7gR3E1aLo9DaDgLXCBeR3sswrWsHU7dtSE7wI3dHMw7iv8NGqQ1Z9mhQ6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749402101; c=relaxed/simple;
	bh=txP9ftk5L5dLudeQxuPDS2ebH/GsVgeUwmT9SsYLnFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHdpMkkQq69CCV3ckeGJ96NrcB8trkVrvsyEKhjyZpfM97yXJBfXCPs6J7ggxF2o2ZLR7sQACZCUYSppYamcFvv6f+cxLifm/FaO5dtv+4ips0lzdVCl7WU27OqLkrFVOwZR4wpbZ8oTVP0tJplD67VAHbEtMndk2nnGL54Td2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcAaoaje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcAaoaje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34499C4CEF1;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749402101;
	bh=txP9ftk5L5dLudeQxuPDS2ebH/GsVgeUwmT9SsYLnFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcAaoajeJHq6Plb2/BGWixVXujx2VQvfNBT0hyojzxlCamSi4tvPwzMK0Ip6PJY9j
	 Rnc7w+CpTpsk7MdzemVjcXlfw4z2mrNmTsJQF2q6+mQ1cVJYilsQBz0AW85LOC1m8g
	 lpGL3l7rigrBD5egPqoDHjSO+x23a/zNjbRXIK4lRZ6OVJtwf1pOxesScUFJ3DRWnV
	 WMeBEUFkgil4CiF4HS0SeVn2fDXRWh2UjfvY2qZUUsOQdG1LwnMKF1pQx7Odwthyoc
	 vtHuAGGZ6SIO8kvFKf26uWZLNyr8bIk3Hc+Of8hIX6zZ2EKqRAgPx/5y+UNnDsGJY2
	 p5SgCdDBV6FMw==
Received: by pali.im (Postfix)
	id 86C05DFA; Sun,  8 Jun 2025 19:01:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] cifs: Fix validation of EAs for WSL reparse points
Date: Sun,  8 Jun 2025 19:01:16 +0200
Message-Id: <20250608170119.6813-3-pali@kernel.org>
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

When wsl_to_fattr() is called from readdir() then we should skip validation
of WSL EAs because readdir FIND_FIRST/NEXT results do not provide EA values
at all. For readdir() reply in this case return DT_UNKNOWN type instead of
DT_REG (which is the result of failed WSL EAs validation).

When validation is skipped and some required EAs are missing then returns
true from wsl_to_fattr() function but do not set fattr->cf_mode. This makes
readdir() to return DT_UNKNOWN type in the same way as it is doing NFS
reparse point function.

This change fixes readdir() result that for some WSL reparse points returns
DT_REG due to missing EAs. After this change it returns DT_UNKNOWN, which
is better than returning wrong type.

Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 5351d3d9d538..8d989e436517 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1117,27 +1117,39 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 u32 tag, struct cifs_fattr *fattr)
 {
 	struct smb2_file_full_ea_info *ea;
+	bool ignore_missing_eas = false;
 	bool have_xattr_dev = false;
+	umode_t reparse_mode_type = 0;
 	u32 next = 0;
 
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
-		fattr->cf_mode |= S_IFLNK;
+		reparse_mode_type = S_IFLNK;
 		break;
 	case IO_REPARSE_TAG_LX_FIFO:
-		fattr->cf_mode |= S_IFIFO;
+		reparse_mode_type = S_IFIFO;
 		break;
 	case IO_REPARSE_TAG_AF_UNIX:
-		fattr->cf_mode |= S_IFSOCK;
+		reparse_mode_type = S_IFSOCK;
 		break;
 	case IO_REPARSE_TAG_LX_CHR:
-		fattr->cf_mode |= S_IFCHR;
+		reparse_mode_type = S_IFCHR;
 		break;
 	case IO_REPARSE_TAG_LX_BLK:
-		fattr->cf_mode |= S_IFBLK;
+		reparse_mode_type = S_IFBLK;
 		break;
+	default:
+		return false;
 	}
 
+	/*
+	 * When reparse buffer is not available then this is from readdir() call
+	 * which does not provide EAs. readdir() can return DT_UNKNOWN type,
+	 * which is signaled by no filling the fattr->cf_mode and returning true.
+	 */
+	if (!data->reparse.buf && !data->wsl.eas_len)
+		ignore_missing_eas = true;
+
 	if (!data->wsl.eas_len)
 		goto out;
 
@@ -1162,7 +1174,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
@@ -1174,8 +1186,9 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 
 	/* Major and minor numbers for char and block devices are mandatory. */
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
-		return false;
+		return ignore_missing_eas;
 
+	fattr->cf_mode |= reparse_mode_type;
 	return true;
 }
 
-- 
2.20.1

