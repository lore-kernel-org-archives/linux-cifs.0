Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8861885B0;
	Mon, 14 Oct 2024 03:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728878312; cv=none; b=fHpcbXDAIqSD1HlapZ+FFcDcC7Ks8BGKAQw6yEsOHtaZtXc47x6Ybvpl+WDxPXBITG+w00okdsTl6UUwys4KMSW0PSqzfUopjXJB3paSGs7oA5CKxcosobrpX+/qBjO+NApg3KWBniN6yCF/a1r9EspnDRI28z3Kf8mt9LOKrEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728878312; c=relaxed/simple;
	bh=Ie+1DLJ05/DyAFDwgGExnGmZl13T2cQQCB3mmbQAOwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8EFTNzvzGR5HJvuUf6oMqJbB2OXAYC1mEf4bJweqzAxKO7r/O7CPgkJhu9HWRujz9b+VBi3IYSQFAIlkEHdK6nKxTpYXJm06ePzzT/ueMWDIlTPEfhYperDeucECg4VkkQ+TR00dRFj0D+MM3jCXqsDir78gijUSudU0QUQrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAqSgpmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAqSgpmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7E6C4CECF;
	Mon, 14 Oct 2024 03:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728878312;
	bh=Ie+1DLJ05/DyAFDwgGExnGmZl13T2cQQCB3mmbQAOwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAqSgpmSDcKQdhiDSodg5dKTqyH15hDDhP+0J17ipkkmHnRlWoHf2D7TnPdyFTY0f
	 09eC1hXiWuJcKq/5PakmdsbdUcAgpSl3LkPGRBVjDsjZt0jpQbUrKY1kVUvY7SKs/a
	 RKitNLQVfpDkKM4W55rhDAFwm9UPOuTN5d5MrsCBYrko0jC54sbmTwFfjajvmEBQX1
	 CYkFyHeqhZ4P5Jakvef9K/UdUygb4M0faebfZFSg/QgPyDAdpibXtD+sxyUXo5dKMW
	 OXq+fCp1YCoErlP2ztsEUKqqyuYu4CayBFT3CLTH7LyI0jaaiPlzwJfq5vhw+sBpA3
	 5wTV7dG7lQhYw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 12/17] cifs: Fix creating native symlinks pointing to current or parent directory
Date: Sun, 13 Oct 2024 23:58:02 -0400
Message-ID: <20241014035815.2247153-12-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014035815.2247153-1-sashal@kernel.org>
References: <20241014035815.2247153-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.56
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

