Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9745D524B0;
	Fri, 27 Sep 2024 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727461255; cv=none; b=lv/8ZWgkiucFqwOxBzJQidTzQwSnyjV4N48qVAPfsaElO6I6pG0lgoSpqmsSxnwrWeyQLouhGBHoGCiKyMH7MxSom1V0dX6GW23/mYcQOXZaUFwg0+Ji21OUiVKKy+i8IIp2iIPdHHIAicCxZCxG2EhuzPawbn4YCiFwivEnM7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727461255; c=relaxed/simple;
	bh=L5RdLxarLTrz7yGRyAe3FrDHSbhsVNMTuzIViLOU370=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EFTVdpBTotvQzvPk5O2ZXVRYjfvodmyox8WHtRMAB+E16I8sgfseTpbIGQB0oU96cEQxJKS+CI6+YQc46J3ddYJ+idcP11r/ItsGXy+o9zGYuW6Pu4V9L5/8tkr1qfvSv88xwBGXWRn7Xz7cgQ5NCdZzj7sVENziDJuNknD+uiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEn0PJr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEn0PJr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB38DC4CEC4;
	Fri, 27 Sep 2024 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727461255;
	bh=L5RdLxarLTrz7yGRyAe3FrDHSbhsVNMTuzIViLOU370=;
	h=From:To:Cc:Subject:Date:From;
	b=lEn0PJr+qXgM9YYV4Aw/k/5YEaAU00rPp0xz/mQ1PQVCATraLIXg5a6tNy8aUdVqW
	 1orjc/0WtpAkAIFBmJS2zjeNLJbzRUuYeL1kHIVXC5xp2BQ8DL69Oz8CrPZjyiI69g
	 jaB439XCe9f3E7mEBiKp/OKx+n0oHX67vO1Ij31wEizp0Vk7AMfUVU2S1Ve1+NHoPM
	 +mtl7aFkaCVr3lwx1X5qOP+oVmt0Rpy1iN1+Al8hkbtWm6qdih1nl0jNPNIl9cb2mF
	 Oc02sPSqS3LDH0acsmQyychCsQHqUoIqxFv4HD4XzerP8C/zexx12tVWEi2O0bhngI
	 zlIZOeAPvMeKg==
Received: by pali.im (Postfix)
	id DD7379ED; Fri, 27 Sep 2024 20:20:48 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Check for UTF-16 null codepoint in SFU symlink target location
Date: Fri, 27 Sep 2024 20:20:39 +0200
Message-Id: <20240927182039.18739-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Check that read buffer of SFU symlink target location does not contain
UTF-16 null codepoint (via UniStrnlen() call) because Linux cannot process
symlink with null byte, it truncates everything in buffer after null byte.

Fixes: cf2ce67345d6 ("cifs: Add support for reading SFU symlink location")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 88c4c3d0d607..0c23634438e5 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -625,10 +625,16 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 									       &symlink_len_utf16,
 									       &symlink_buf_utf16,
 									       &buf_type);
+					/*
+					 * Check that read buffer has valid length and does not
+					 * contain UTF-16 null codepoint (via UniStrnlen() call)
+					 * because Linux cannot process symlink with null byte.
+					 */
 					if ((rc == 0) &&
 					    (symlink_len_utf16 > 0) &&
 					    (symlink_len_utf16 < fattr->cf_eof-8 + 1) &&
-					    (symlink_len_utf16 % 2 == 0)) {
+					    (symlink_len_utf16 % 2 == 0) &&
+					    (UniStrnlen((wchar_t *)symlink_buf_utf16, symlink_len_utf16/2) == symlink_len_utf16/2)) {
 						fattr->cf_symlink_target =
 							cifs_strndup_from_utf16(symlink_buf_utf16,
 										symlink_len_utf16,
-- 
2.20.1

