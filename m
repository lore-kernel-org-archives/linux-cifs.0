Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FB2396D15;
	Mon,  6 Jul 2026 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363730; cv=none; b=XhiVb3GZlgtzOAkbbKPnuFlaEWGa8/NkRBYMUxTc9sKl9St+rSYHFdcA6e7fcJUwtYxsib5ZxcK2NBX5r/L97nFK2AuAYek8+ICPRkMGBrIg7RDF/bFmFj/43j07svz36vSqrJVduKo8VEf8c1IfDoPakpsRhmnJioYvRo8doUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363730; c=relaxed/simple;
	bh=0i5Vxb32xcABOgmRlySyWNBj9lOQ5srzhHxRvdEu1Rc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSdjjbHiXLy9LO6DUI5Q7xvCbfzE+9zclrl4bDGBf26/e9Zb6kXkQLxnW5Ybbxop75pl53kMGOS42PhDx9/E0Xjctt8TvQP2F0saPl03UBMCOP2VJKEjm2gaAgWWD+RHXfwtcLvblUD+QK6ZF/oCtf6mJNbdd3SotDWu9HK/ZyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2MWy25A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2MWy25A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583051F00AC4;
	Mon,  6 Jul 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363718;
	bh=Z5IF3grIB1SG6b2s7YxJvLslA9s7945esPAEIVWoFbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2MWy25Aw2e8j3+CUKbTJeFooe+2ASKc78lh/R3qS4UGbLoDixIwrSB1O7ia027+l
	 DpweGF9J4EFFJHSZrzaHoUFYVWKuPGlGmODfaRgP4v/ZVSETF/3Z4tMN27yG8jszWi
	 VJwgFrmgQ62NLUMTq/LN49coo/PLmpMmMauV58tTWmcVOtnnxUykkOu0DVZ8u9A/nn
	 tTdgPJyY/FMfdJ5Tp/1rEmGnaUvtxt4bKMY4OOB54quFHKnNyd0/hfr69sfjhm/Pr3
	 UYXnR6SnHmFz7RgBeeX8z/tRbrSNpMdXabwqZVv2uigHt2DLS6ePIH1gXd93yauYiA
	 VT2ojxnjvBxJA==
Received: by pali.im (Postfix)
	id 0931BF5B; Mon,  6 Jul 2026 20:48:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 06/11] cifs: Validate presence of EA $LXMOD for WSL reparse points
Date: Mon,  6 Jul 2026 20:48:14 +0200
Message-Id: <20260706184819.22124-7-pali@kernel.org>
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

S_DT part of xattr $LXMOD is mandatory for all WSL reparse points except the
WSL symlink and Win32 socket. Microsoft WSL subsystem does not recognize
them without xattr $LXMOD too, and treat such inodes as regular files.

Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 49a6a0cc2b61..99e93b56374f 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1124,6 +1124,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 {
 	struct smb2_file_full_ea_info *ea;
 	bool ignore_missing_eas = false;
+	bool have_xattr_mode = false;
 	bool have_xattr_dev = false;
 	umode_t reparse_mode_type = 0;
 	u32 next = 0;
@@ -1183,6 +1184,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			have_xattr_mode = true;
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
@@ -1194,6 +1196,16 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
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

