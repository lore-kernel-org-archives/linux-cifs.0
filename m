Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C66BA2E;
	Fri, 13 Sep 2024 20:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726257750; cv=none; b=PDtmNS0taHp//UrW10rNJATwhYJpJZ+GsxwGg3kzbPq6Bqypho4f1CEcdFwCVzHATO0//3VtpHidNPYin15THCuzmfZY0iBh3ktbaPV5AO1GdOobgsha+sJUPrOOFK7oT96jn4fgonKRmS14H/RPkEDRk2NNKOxEQlxdXovJJC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726257750; c=relaxed/simple;
	bh=5flasasZsrWmkgANQHciB5h06m62LHkwQDKXdAAaIHA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Mjw7fygZJ82EUVKYpaV6y3vxkJ36a2XtZ3r68harE91LbcZ8jzYD1bAum0KPc+SyzIiHbiQGaqrjAhbV+UlkLlqoXtB26j8xsPH8S3INLeJoiLilLp174n6QEAgRvJ4C1tt8YnptnNVZjcIw+yvadz1Aslyc7Ryvy/MkeGROrMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqIGi+KX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqIGi+KX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7284C4CEC7;
	Fri, 13 Sep 2024 20:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726257749;
	bh=5flasasZsrWmkgANQHciB5h06m62LHkwQDKXdAAaIHA=;
	h=From:To:Cc:Subject:Date:From;
	b=RqIGi+KXszch00lfCYeio+uuUwD64mcV2vil6Jll8BqiFc4cAfqg1a7ITzafRdAzL
	 0Q1egL+zqFHswinmJPqNw0eDI7Z30lOnjVsysmD95nziUYB1isQQ/EVuUbNX0RpPJJ
	 rirdGNtVTM9HLRa77WYDCcpfNkImcWeUGOd+K3XQaklB1y8xia1hIa96jPqy/9j0/2
	 lrEgefMDlU14QYBA7/FqpGnsCIARzHBuMXMMD68FpXMMeXQ8x08v6nK4oD1MUm9JW8
	 gPgKHKmEubxqALU9SyzupptEM/ydKnJdjIk+lhpsfMYSyB7h5mVBhUyrM+eev1E5qa
	 V2GCmeIZV8bjw==
Received: by pali.im (Postfix)
	id 8E608725; Fri, 13 Sep 2024 22:02:24 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix getting reparse points from server without WSL support
Date: Fri, 13 Sep 2024 22:02:04 +0200
Message-Id: <20240913200204.10660-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If SMB server does not support WSL EAs then for SMB2_OP_QUERY_WSL_EA
request it returns STATUS_EAS_NOT_SUPPORTED. Function smb2_compound_op()
translates STATUS_EAS_NOT_SUPPORTED to -EOPNOTSUPP which cause failure
during calling lstat() syscall from userspace on any reparse point,
including Native SMB symlink (which does not use any EAs). This issue
happen for example when trying to resolve Native NTFS symlink from SMB
server on Windows 8.

Avoid this problem by calling SMB2_OP_QUERY_WSL_EA only when detected
reparse point is of WSL type. Note that this is not solve this problem
fully as WSL reparse points can be created also on other SMB server
which do not support Extended Attributes at all.

Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 11a1c53c64e0..d65471aa55e6 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -941,7 +941,20 @@ int smb2_query_path_info(const unsigned int xid,
 		if (rc || !data->reparse_point)
 			goto out;
 
-		cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
+		/*
+		 * Skip SMB2_OP_QUERY_WSL_EA if reparse point is not WSL.
+		 * The server file system does not have to support Extended
+		 * Attributes and in this case returns STATUS_EAS_NOT_SUPPORTED
+		 * which smb2_compound_op() translate to -EOPNOTSUPP. This will
+		 * present failure during reading of non-WSL special files.
+		 */
+		if (data->reparse.tag == IO_REPARSE_TAG_LX_SYMLINK ||
+		    data->reparse.tag == IO_REPARSE_TAG_AF_UNIX ||
+		    data->reparse.tag == IO_REPARSE_TAG_LX_FIFO ||
+		    data->reparse.tag == IO_REPARSE_TAG_LX_CHR ||
+		    data->reparse.tag == IO_REPARSE_TAG_LX_BLK)
+			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
+
 		/*
 		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
 		 * response.
-- 
2.20.1

