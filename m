Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2D23B7B71;
	Mon,  6 Jul 2026 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363729; cv=none; b=nQVAGa3YpwvLPvHR2qnSL34F7IbzteN4XPyBcsXwEFmTLM2zspiGe/tPiTn0ksSe1In4OIra2J0E9Dzsr/A8r7BNRnaifVh+4d3DZyjCOtBQZZ39Jsr8ulDfxx/ABEfPOL56a5G8CzEJ6grAmYEFsQ2RqLcnfOXc7zYwDpFdMYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363729; c=relaxed/simple;
	bh=mzXLoptSKuMgrZzs208pIr5cMpu65o+ObBKr00qLXG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smfQn03uYjfpZShIWrJygtDV6KrjrEfyjtU3CgwKfZABW8nibAET1Gddp7aYKV0W5nKA5RtNETZsB/yXJFze/REJ8b/PmtYUjPr6A5aBmwbuaw/pC7+g6gu+8hLdAAYIlj9fEGLE2fradF7DDItvoxqmTw1It2/tt/CGNmtKBBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=do2tGa7S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="do2tGa7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3C51F00A3D;
	Mon,  6 Jul 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363718;
	bh=BrvYncIIZqGHD6T/XhM5TzkzL2ejEvJGvPT3feKaD64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=do2tGa7SwLnLVbcubk+yrsu5ibgHFE8CRBwlD3q3pFQ07AA/6sBwGmEkjm6BEUQVD
	 FHMZEF00aSJ9SEvVc1WY+atwONy2XGt6jOGEZjHxDL/vAzc1TL2TwXhqgH+DuafASr
	 vVp3P8cTT2+RPmqRP6DJhkrqdVw10CLJxiomOvajKmyxNOYFWL8nCIYkvfgE/bhD/0
	 NF3aCP3a+BFw9F6YC3GcH8Qc60A6L8suY8Iirct6Y+9gcBrTe2L+C/s6ZAKSkmNWXO
	 Fax14TnieRkrpqD+nr4/bJzVtW86DArDc2y7yZbykE1qQmJo7js1s0blbum7oLdpHs
	 QjOD33f3aITDA==
Received: by pali.im (Postfix)
	id D0136E82; Mon,  6 Jul 2026 20:48:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 05/11] cifs: Fix validation of EAs for WSL reparse points
Date: Mon,  6 Jul 2026 20:48:13 +0200
Message-Id: <20260706184819.22124-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260706184819.22124-1-pali@kernel.org>
References: <20260706184819.22124-1-pali@kernel.org>
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
index cd1e1eaee67a..49a6a0cc2b61 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1123,27 +1123,39 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
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
 
@@ -1168,7 +1180,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
@@ -1180,8 +1192,9 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 
 	/* Major and minor numbers for char and block devices are mandatory. */
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
-		return false;
+		return ignore_missing_eas;
 
+	fattr->cf_mode |= reparse_mode_type;
 	return true;
 }
 
-- 
2.20.1

