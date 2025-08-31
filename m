Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7F526F462;
	Sun, 31 Aug 2025 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643800; cv=none; b=EPW4zV3Ec42n54Ul2mPohdO+P+E1IeGd33TnN6BgoPTnRcMmHgMbf8QDyzISTBBBkUUCYmr+0J4JMHdGSA4bwUgnEolaXwpXkV3R9PQ9EtvOKYojQEHSQL48FNQ8JI2dVBVjblsOdflZMo2UIzO60pcqLIYD59mop5LbjVDvP9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643800; c=relaxed/simple;
	bh=UJXNLpnVpXaGQJ6zhTJTdyv91uluTCE+NBjb7TBcAcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rl3EzX8LADnjrzvAg6msRottzci361e82ifKMDdpY5l7l5Sko9SU7yyh+0Q+oxsHHYFtqJBtOEpXBKXiONkg9VS0zr+li0uewV7IFxjcYhLMmErQEY0heoaD1SyPxcwRJmj/QAWAN6Uea7Y8Mvr4bL4XKg58oqx/3CKZNgXkiXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHsiVXXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHsiVXXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128BAC4CEF8;
	Sun, 31 Aug 2025 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643800;
	bh=UJXNLpnVpXaGQJ6zhTJTdyv91uluTCE+NBjb7TBcAcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHsiVXXINRKNTbpuvedxPPYy3k8d6xI1iseS9FtDnVQ3TKXa1cr467rRK3b/O34R1
	 COMATIhRjG+zpT4tICv94QA/YSdJ3TqkHj2bkLIFkEJ68nig2ocVu+o1hSQk3Lc+XC
	 wGWsT62xF3NxP+I3ec1Ywc39gNQYor6gxSfcG6Dh/Hth9YDfniRh7KdK0Oh/dCPv2F
	 jSVXSaKxZ+7DP2uEwdZA0TqBY1p2Ezmp0VShyB6/h7UGL9h2aN25hj53yrSoBNyQm8
	 8UC9qfUQVtcCrgVCxL8ui5XneKn42NQH2zHLWzcvQtSZJJHB3dJ8HHSEbjAZaNjE8/
	 UyofhXJZ8M/Xg==
Received: by pali.im (Postfix)
	id A056B14A3; Sun, 31 Aug 2025 14:36:37 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 34/35] cifs: Use CREATE_OPTION_EXCLUSIVE when opening file/dir for SMB2+ non-POSIX unlink/rmdir
Date: Sun, 31 Aug 2025 14:36:01 +0200
Message-Id: <20250831123602.14037-35-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Using of CREATE_OPTION_EXCLUSIVE against non-POSIX SMB2+ server ensures
that the smb2_remove() function either success and removes the directory
entry or it returns an error that file or directory is in use by other SMB
client and silly rename is required to use.

POSIX-based SMB2+ servers do not have this problems as they should unlink
the directory entry immediately and not transition them into delete pending
state.

This allows the cifs_unlink() and cifs_rmdir() functions against non-POSIX
servers to detect these failures via -EBUSY error from smb2_unlink() and
smb2_rmdir() calls and fallbacks to cifs_rename_pending_delete() which
implements silly rename.

This is the final change which enables the silly rename functionality for
the unlink and rmdir calls in SMB2+ dialects on mounted exports from
Windows servers.

With this change Linux unlink() and rmdir() syscalls called on SMB2+ mounts
from Windows servers cause that on success the path would not exist anymore
and new file or directory with that path can be created.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0dd4a77dfb64..727349ed76b9 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1351,6 +1351,23 @@ smb2_remove(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 		op = SMB2_OP_DELETE;
 		op_flags = CREATE_NOT_DIR;
 	}
+
+	/*
+	 * CREATE_OPTION_EXCLUSIVE ensures exclusive access to the path.
+	 * If some other client has that path opened then our open fails.
+	 * So together with remove operation it cause that either the path
+	 * is immediately unlinked or the command fails with -EBUSY.
+	 * It should not let the path in the delete pending state.
+	 *
+	 * When using POSIX extensions then we do not need any exclusive
+	 * access to the file or directory.
+	 * In this case the path is unlinked immediately even if it is opened
+	 * by other client. Unlink fails only in case path is directory and
+	 * that directory is not empty.
+	 */
+	if (!tcon->posix_extensions)
+		op_flags |= CREATE_OPTION_EXCLUSIVE;
+
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name,
 			     DELETE, FILE_OPEN,
 			     OPEN_REPARSE_POINT | op_flags,
-- 
2.20.1

