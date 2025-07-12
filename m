Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871132BAF4;
	Sat, 12 Jul 2025 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752336999; cv=none; b=lSIBtexhhlr3xILuGpa34cOlwwE6jn6QJvx2Eu++QIJ8XASda+fR9GsHsrPiiYZTDfWSh40uykiUStn4NpTwhBy0TerbniUIjKG6MqO7C5nRaJHVuVKtRo2d7u9g/oXaG8+ULk7KMQqHTDnJk+uALolP6s+eVWNZlBU6RAfZbyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752336999; c=relaxed/simple;
	bh=0omuPUBa1UGeK6I/wXJrTJEeUYsvwJsz87QztiJGpd4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=gk7TRRG/JvzPjZCeHryvxSmJoohH865NHMBb+VD/UaNOyWGdZRWdE0ivgaDQThcyTn6aYVGpzt7X8eKBwuR/AxFS5LvU99f4eDduui7VoivQjcE8U/ty8k7hn3aktwbCWj29rmbuHa/Bqy44pOmtP8h7reHHHfB/R6MTVY6mjhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fr8DumOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fr8DumOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A29C4CEEF;
	Sat, 12 Jul 2025 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752336999;
	bh=0omuPUBa1UGeK6I/wXJrTJEeUYsvwJsz87QztiJGpd4=;
	h=From:To:Cc:Subject:Date:From;
	b=fr8DumOtwMxzkQy01eEo4MMZ/6N/er1daZ7baalZb5I4Ywjwu4oYX7V9zrS9lWXWz
	 anKHu14bwIT/pwoampcz7dKMiWBf9ivD8QzoLufGCQmIF2oTJeFMioBaF9mKRMRIKU
	 xauk7KDRCHxBhlOIlx+RReYYfuHsSfscTR0hRxPXv8maiDoxOeLZwxJrUc5RvyM5Hu
	 bXWdUD9lvOKCUtVqYZMbEzQEqF+//XKCnl1wQi6iG2XaxXin2tIkSa75wCJ6X08C3i
	 7tUYkr9zj8L93fY1GZ6eJtAgs7JfKiHq4+EhSRbjCWJqc++YCILHm1ThK+ZM2jf/q1
	 /gdyOrd4Pn8Xw==
Received: by pali.im (Postfix)
	id 4CD047E2; Sat, 12 Jul 2025 18:16:37 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Do not query WSL EAs for native SMB symlink
Date: Sat, 12 Jul 2025 18:16:30 +0200
Message-Id: <20250712161630.17758-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

WSL EAs are not required for native SMB symlinks, so do not query them from server.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 61f9209817a1..3ff8e7eb12c6 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1058,10 +1058,11 @@ int smb2_query_path_info(const unsigned int xid,
 		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
 		 * response.
 		 */
-		if (data->reparse.tag != IO_REPARSE_TAG_SYMLINK)
+		if (data->reparse.tag != IO_REPARSE_TAG_SYMLINK) {
 			cmds[num_cmds++] = SMB2_OP_GET_REPARSE;
-		if (!tcon->posix_extensions)
-			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
+			if (!tcon->posix_extensions)
+				cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
+		}
 
 		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 				     FILE_READ_ATTRIBUTES |
-- 
2.20.1

