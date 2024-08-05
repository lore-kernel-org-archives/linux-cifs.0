Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC65170A32;
	Mon,  5 Aug 2024 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880631; cv=none; b=V9PtBCqWNCXYXFD4TVikuKGB3Jtt8sw69Sq+36rJygbZdSx/1VErviywuywcdmcjCBjj/Gk62g5kB2SiA5DNLFqp0Ygn9sMZhA7VG1Vbx7ue0m+8bi5yr8m0J2U3vX6IQ60L4tnkPeGHDGVuEdj9XSuWKt79X2G2wE3MBWZp/9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880631; c=relaxed/simple;
	bh=w/jx80tZ1sEHuS88DDR4MnzexGPt8gX+7VH6MO2y/Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyT7cSWIsbDoyi5c5VGwvRDMjSgV4ai6fsxjJLo1qT7xJq5C7na32xKMPBF7xB7I9qIeNqvpbRsJIuc09l8iMbxmWGE5gmoszsJetO/omlobm0yOl9FORCqZp4BJs4rfboZava37McNijPmdPnPeUp4kq0jHYLvLFT+Y2VUNBcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XodVjAn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XodVjAn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4C7C32782;
	Mon,  5 Aug 2024 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880631;
	bh=w/jx80tZ1sEHuS88DDR4MnzexGPt8gX+7VH6MO2y/Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XodVjAn014gStI2wM3b5DUohHwNQrpyStjvMePwQO+6c+6y7q6Qf3IJKAINvC0FjL
	 y0gVr1NfQE14apKhpdyC6BkWlrGA8Ix+H1bCXC+pzn6mzAh3zCa5FH2JjAJxiodfUe
	 Ikkxcs2QAoSwO87Y6O5U9Z2q3uuBUFPjafQsX6PkvJcrSqqazre2drBnnaKQYftQ/O
	 tSfj2F4WlHXG8yzc1O4qPp39g02z15sRJAGlEi62BXY7Ehw4QseHzz4WGZJ8ggCeej
	 1rVnUHLPV5nBuIBleFHJA26Y58cMaTeZJxzA2kouL4o9BGrwST9qlUdNdtzFVltxj2
	 lF8EXVIhIQOSg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.10 16/16] smb: client: fix FSCTL_GET_REPARSE_POINT against NetApp
Date: Mon,  5 Aug 2024 13:55:48 -0400
Message-ID: <20240805175618.3249561-16-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240805175618.3249561-1-sashal@kernel.org>
References: <20240805175618.3249561-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.3
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit ddecea00f87f0c46e9c8339a7c89fb2ff891521a ]

NetApp server requires the file to be open with FILE_READ_EA access in
order to support FSCTL_GET_REPARSE_POINT, otherwise it will return
STATUS_INVALID_DEVICE_REQUEST.  It doesn't make any sense because
there's no requirement for FILE_READ_EA bit to be set nor
STATUS_INVALID_DEVICE_REQUEST being used for something other than
"unsupported reparse points" in MS-FSA.

To fix it and improve compatibility, set FILE_READ_EA & SYNCHRONIZE
bits to match what Windows client currently does.

Tested-by: Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 5c02a12251c84..f80bffafb878f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -948,7 +948,8 @@ int smb2_query_path_info(const unsigned int xid,
 			cmds[num_cmds++] = SMB2_OP_GET_REPARSE;
 
 		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
-				     FILE_READ_ATTRIBUTES | FILE_READ_EA,
+				     FILE_READ_ATTRIBUTES |
+				     FILE_READ_EA | SYNCHRONIZE,
 				     FILE_OPEN, create_options |
 				     OPEN_REPARSE_POINT, ACL_NO_MODE);
 		cifs_get_readable_path(tcon, full_path, &cfile);
@@ -1256,7 +1257,8 @@ int smb2_query_reparse_point(const unsigned int xid,
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
-	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_ATTRIBUTES,
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+			     FILE_READ_ATTRIBUTES | FILE_READ_EA | SYNCHRONIZE,
 			     FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
 	rc = smb2_compound_op(xid, tcon, cifs_sb,
 			      full_path, &oparms, &in_iov,
-- 
2.43.0

