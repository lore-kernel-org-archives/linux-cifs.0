Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AD614F132;
	Mon, 14 Oct 2024 03:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728878271; cv=none; b=DwV5thgZTvBDyxjzxM6gUZMEMR/g+c2TR3Gpe99kLbd7KauBYUTMuhFc8f1A13VLkKlbSFacx9023bArHOgDdZO/VU3AnHo8ZEcDY7QL8eJ10IgiOQDmieflF+G8SiQ0eNeWrC0JGl9ST2GADeQceMcL/LaTaYdVFXUgs9QQHEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728878271; c=relaxed/simple;
	bh=Ie+1DLJ05/DyAFDwgGExnGmZl13T2cQQCB3mmbQAOwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MoxoBgev4MaogI3YRWsUUvj8I6q6YTWZ3/IWrZ7PW2wDZnLShWpym9DWWcnsxglQGVh/dZQi4b/CZ30y1U+tmQd+/p02PI+lJgbauIai//2ktypEJ05cRoZGXmeSUjbiLlU8y1rMeGF+fTgV253sqMyK8OpwgEOyJ1xAU98of/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Go6E/+iV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Go6E/+iV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3823DC4CECE;
	Mon, 14 Oct 2024 03:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728878271;
	bh=Ie+1DLJ05/DyAFDwgGExnGmZl13T2cQQCB3mmbQAOwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Go6E/+iVyI8eLDNeo8vukHei2xz/auV69KCyIhEbWbO3wtJg8h+Z5KnkKYTDJ4j3+
	 drex6cVjZuAHnbEn0TtsTh/dE1qJjg+IwNcpwhkDFpeHuYMmiafFGPoP6+15879maB
	 hLMA95F45Vk88TrArRm7MNuyDPkiy//mn9QHmeX3k9MBcV9quDDa0HkAGtryZwPgcP
	 Vwt9CLeOG4xLGKRcFHP/lIUev+CzjNjXASSIYmDnepzlWR3E5HQgShmpoq1RYy9Lc6
	 rL7DxGTRHtUKNBXeBggOqTtkhnHeBSrNes8UkTTrxNyKIujq8pYrxADoXtJSET1UMe
	 9enX1Ach+5eZw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.11 13/20] cifs: Fix creating native symlinks pointing to current or parent directory
Date: Sun, 13 Oct 2024 23:57:15 -0400
Message-ID: <20241014035731.2246632-13-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014035731.2246632-1-sashal@kernel.org>
References: <20241014035731.2246632-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.3
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 63271b7d569fbe924bccc7dadc17d3d07a4e5f7a ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_unicode.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 79d99a9139441..4cc6e0896fad3 100644
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
2.43.0

