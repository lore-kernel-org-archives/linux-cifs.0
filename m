Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47D5199E94;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749402101; cv=none; b=RRMeNxgXNRdpeSXW8UjjEDFo1h0R8vGX+cCWOALzBZHwsgwjcH78SvXvHYvNmt2tQQaRidINslu2iBBiPy6WN+D1h82Gwyz4u9vEqCvFSVP25ziU5dqP0Hjgjf+0WAf8ghlKMGVYM+1vM4UFzQuxEJqhMpOUIUmEsEbrrs/XOAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749402101; c=relaxed/simple;
	bh=b2gazy0Tgi+B9/Hsv9XFo1kh8OrtVCt9SXx0lJMHJek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WRqylj7KcagEjoJS9bRcJC/2mfCTYPWtwOHsR5EGOlkICwpbKVYau0vB/ufFzDYldNT2dNvAUDmnZGCqU3Qby9yjK9yqqksCZn7QOEj0af20aWiiNfDpS9yw89XtbPNG6GjpN/xAxPmqFJHeDhwkikgm1llOA3h5IIC5uTvsEZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSOc1ut7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSOc1ut7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F034C4CEF4;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749402101;
	bh=b2gazy0Tgi+B9/Hsv9XFo1kh8OrtVCt9SXx0lJMHJek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSOc1ut7/UuDjVB3bQcvHGY3c4udK+4sXBv4W3UWvIZhxS/3Y/FKWZWWRB8+VPSVv
	 SkyNapUKJCZJqFPv9neh7TNbm8pQhH/+uOtMDJjCdMek2Zi8TVogKVdfSzYp3axIDs
	 JsP4IyvKaWs4G48CqXvZMA0AhWjvtpxTcZSBMyKucAl2SSe0JKcZ1ytLZ0ldh7eXA7
	 AVRli4H0W7xDoe4WfHZtJkGRcY+fHISnl/gdQQRZjwjiaPGp82RGlrtZN1F6+GgvHf
	 R1OVQZUAzTyIgNAwiLK1p11hoAMjT9SfSP78mmvW9LmwR8sx840W2TowYHJ72r/6Yq
	 rA6Z7cpIsWu1g==
Received: by pali.im (Postfix)
	id 4BE3CD70; Sun,  8 Jun 2025 19:01:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] cifs: Remove duplicate fattr->cf_dtype assignment from wsl_to_fattr() function
Date: Sun,  8 Jun 2025 19:01:15 +0200
Message-Id: <20250608170119.6813-2-pali@kernel.org>
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

Commit 8bd25b61c5a5 ("smb: client: set correct d_type for reparse DFS/DFSR
and mount point") deduplicated assignment of fattr->cf_dtype member from
all places to end of the function cifs_reparse_point_to_fattr(). The only
one missing place which was not deduplicated is wsl_to_fattr(). Fix it.

Fixes: 8bd25b61c5a5 ("smb: client: set correct d_type for reparse DFS/DFSR and mount point")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index d1d25f5f72ca..5351d3d9d538 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1176,7 +1176,6 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
 		return false;
 
-	fattr->cf_dtype = S_DT(fattr->cf_mode);
 	return true;
 }
 
-- 
2.20.1

