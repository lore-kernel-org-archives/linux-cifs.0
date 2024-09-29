Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEC72C1A2;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727635864; cv=none; b=onGYeNlYQDoQDxO4LUEl+p1kkWUuFv53UQXuJW0E6zqaH8QioKf9DdZqDpYnJlJMgHyvMhUAc8ypuH+/+ZyD4GT7ff3r4ZaGwUJL6l2TKiR6iLYFAnU9LVwSFqwG2jjrTS0pcdXnzlLBgXSm+B/d0ZyxXPp9wmwoeP/3ZpbLuqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727635864; c=relaxed/simple;
	bh=Sgx5ATycMHh6UDLNYypmUE89xviImR+y+zjObqc7AmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bp74dYCiN9xfJ2Ob6Pj1cKIjv+k0wcr5TR8iChajSpDZExCYjNXwH5nC0mJKSzajv63pVs3d0AvfhQbu9drZdwMzSfkR4BValUk9SSaeQ+PazYylxFcs9GX+y1MGMlc+JBXlRMnoLU48ZDWhLpo1/NL/YkGQ8xG1xAK3vYsWBFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrlzMV1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrlzMV1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81C6C4CEC7;
	Sun, 29 Sep 2024 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727635863;
	bh=Sgx5ATycMHh6UDLNYypmUE89xviImR+y+zjObqc7AmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrlzMV1jfHCrGOhketOZnVgaRScBje/HypPk4qyjgUWtoWSQtFE0KSUebmWGI4hyQ
	 iYIymUc6hnIpTr4Llc74ZhC+yuN21B/ABpLrtdLC/4+SfiPayBiyB56Br98B1aJH9y
	 xl4ViaOmVYW0NUK/+wyroo4zYuaCB+rljr21lXIlQYstkSUdh+j8bnV277ExTWsd/Q
	 E2AiKVcpSoiLI4yu7NLrTjUOEHABHTfZJjWsENH/zdmc8iXcRWO6XLE72j2k9cdDCN
	 BA8LEUVTsyEWgUp7YIjPODhMP6uKeYYpSx/jIorZjVpRs/Q9mlzGKR63ap+h+9KODW
	 4lTXSP3HQDn/Q==
Received: by pali.im (Postfix)
	id 52E10B9A; Sun, 29 Sep 2024 20:50:57 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] cifs: Fix creating native symlinks pointing to current or parent directory
Date: Sun, 29 Sep 2024 20:50:49 +0200
Message-Id: <20240929185053.10554-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240929185053.10554-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
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

