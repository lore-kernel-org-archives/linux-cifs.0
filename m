Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FE21804E;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137029; cv=none; b=Q4bVVJTX0XHy6c0z0FOlXDbl+WmF4xXpZkrFlC6LUl800s09Jz0bUiBLNzGbX/A45pL9Ds0Zo3qFkkWBfV2XlDiBF7uidKLdCiaBVTv1OisEpauR6yTywFmU9J+iLL/hcPB3oUV043G98JyrwpAUxkLsgzxAfI7EQRUHveJRdyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137029; c=relaxed/simple;
	bh=hDQvcu8Vv8Wg91smOeEWxvTb4XmEDvotaoUWgxTSX/w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Djbs8Qms/MEkfWkpcZfgSW519hPI4t3Yi4wRhbO3Hlg2wbu1dADlFsKC1Jo82CrY6WSsEPpMZCXNHvAKz3oLlBNfnphSPmRkDUftiFl++qs2KTr+Tc4Gptdw0ovBoeM61KCWFzVyrhtFpTZBvYQgvZaHS/qs4Ix6dR3/gsAfQGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBlJgYFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBlJgYFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB39C4CECD;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137029;
	bh=hDQvcu8Vv8Wg91smOeEWxvTb4XmEDvotaoUWgxTSX/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBlJgYFpEbOIGLtmHDB/defiNklHrvvwThnhUMa9ZToetGA+MESt6BRF/8P0sqXRT
	 1C8ayD4yOEFpx1JCimbF9er21qiprU7c4QByfSTTbZxVQLiZS77bz1JDGrzQXXM50P
	 x+cjS2iNkvuwN09SVwWJUHMotfGWeWitsb27HoiVSBkIN6QloJt00gMas0037IhdZF
	 1YR3yHPPBuI6Ipo/rC7NJdkCjPaY3z+RAakZIA9Nem6di+TMzO//ujaRmznM+VkVLX
	 emop2Uy4/9+4ns8PUWoO/3Crx0DkyUHo4jvDrPUI/kPxhfV2q3RrpP9CVX26HBZNgB
	 Jd455QMzCdOig==
Received: by pali.im (Postfix)
	id D135A9F7; Sat,  5 Oct 2024 16:03:42 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] cifs: Fix creating native symlinks pointing to current or parent directory
Date: Sat,  5 Oct 2024 16:02:56 +0200
Message-Id: <20241005140300.19416-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005140300.19416-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
 <20241005140300.19416-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Calling 'ln -s . symlink' or 'ln -s .. symlink' creates symlink pointing to
some object name which ends with U+F029 unicode codepoint. This is because
trailing dot in the object name is replaced by non-ASCII unicode codepoint.

So Linux SMB client currently is not able to create native symlink pointing
to current or parent directory on Windows SMB server which can be read by
either on local Windows server or by any other SMB client which does not
implement compatible-reverse character replacement.

Fix this problem in cifsConvertToUTF16() function which is doing that
character replacement. Function comment already says that it does not need
to handle special cases '.' and '..', but after introduction of native
symlinks in reparse point form, this handling is needed.

Note that this change depends on the previous change
"cifs: Improve creating native symlinks pointing to directory".

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifs_unicode.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 79d99a913944..4cc6e0896fad 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -484,10 +484,21 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 			/**
 			 * Remap spaces and periods found at the end of every
 			 * component of the path. The special cases of '.' and
-			 * '..' do not need to be dealt with explicitly because
-			 * they are addressed in namei.c:link_path_walk().
+			 * '..' are need to be handled because of symlinks.
+			 * They are treated as non-end-of-string to avoid
+			 * remapping and breaking symlinks pointing to . or ..
 			 **/
-			if ((i == srclen - 1) || (source[i+1] == '\\'))
+			if ((i == 0 || source[i-1] == '\\') &&
+			    source[i] == '.' &&
+			    (i == srclen-1 || source[i+1] == '\\'))
+				end_of_string = false; /* "." case */
+			else if (i >= 1 &&
+				 (i == 1 || source[i-2] == '\\') &&
+				 source[i-1] == '.' &&
+				 source[i] == '.' &&
+				 (i == srclen-1 || source[i+1] == '\\'))
+				end_of_string = false; /* ".." case */
+			else if ((i == srclen - 1) || (source[i+1] == '\\'))
 				end_of_string = true;
 			else
 				end_of_string = false;
-- 
2.20.1

