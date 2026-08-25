Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E943F3537E8;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699200; cv=none; b=kgjTt8TfSvxGvKGNfs+xD9pCctnH3go4OLvKZ+cIKagCw8ZMTpnV49Oa8rWMPc8Zna/7RxHLDQj63zwLGUEkQMJ6/im5DjLUGa1hc2XSPLZPKRn6N5tGMgT/oe9rpXLrwXBgnovxPApZs7c3rVk9RPgvYbYdYbamnTsIMkG0AN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699200; c=relaxed/simple;
	bh=GWsv3jOj5PgnZcHsP+q22FRAkF3pR+epOTcSSgg+DT0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eed3PTFGVObiK9/oEGLEcxF4HVUwjWxIPx6RR2QbJKUDpSyXUV1KEtCwvlzUg00pOAPlSnq/oJeD+t+c0Zr0KEApwqPDEAU2IjFRlsJocnKyVNI3vTusTJX3+89E7NVGTRidNykWCoNXcBSzF4QwxqVgabX/Yh6eAsEwCYb1T5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4mJXEH6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4mJXEH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B71E1F00A3E;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699198;
	bh=neQF4B6OBFlvD3OKwkgOO4uxQY+f5mHZZ0FJmjmke2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4mJXEH6OaS1XkJqy8IBmZ/WbfPTHsD8MAhR3c1Qd8WYRbBmd0fRZ+mbPDKwvYwB+
	 aJ/2MLlNcBoOz+KfHfkQaV0GJe8oxRy/e86/04Rn6/ngGzL7Mwp7hTlLw5O2y4Rb4w
	 onQ8PrZsz8MSfhOyYsWqKdRx1V8Z14dpxckY9awVlw169+qOtkRC66L+K3LQJeuyV7
	 FNP3S3tvjlB8uaiUUa0SMhCaJqwkYoeRvFzLwn9Mxj7u4X6lmxBQx5Pmh+j85eGxZR
	 rMZKi8puEh5whPICCKGnR3wN02qJekxHnO2YLseQm9ngijxzh+6Z2znMK0JmnIqwpe
	 Yqw8W1Yoo/hQA==
Received: by pali.im (Postfix)
	id 699CB110A; Wed, 26 Aug 2026 01:06:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] cifs: Fix validation of EAs for WSL reparse points
Date: Wed, 26 Aug 2026 01:06:16 +0200
Message-Id: <20260825230622.24617-4-pali@kernel.org>
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
index 5cc5b0410d48..d4052f6c6e6c 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1138,27 +1138,39 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
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
 
@@ -1183,7 +1195,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
@@ -1195,8 +1207,9 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 
 	/* Major and minor numbers for char and block devices are mandatory. */
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
-		return false;
+		return ignore_missing_eas;
 
+	fattr->cf_mode |= reparse_mode_type;
 	return true;
 }
 
-- 
2.20.1

