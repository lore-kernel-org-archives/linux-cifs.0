Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080A036C9E3;
	Sat, 28 Feb 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302302; cv=none; b=Zt7Vb+qW2m4jy1fFkA1H0v/WREsKfRYX3pRGdtYu4zOL3iUQUMDjaS7QNDq2Ax/pMBIseq+IdX/telDd/HXLqh2xsndaZa9GYIwjFEUvsvKCz5IP+FtxcbzuAYYxDdskHJ/6qDWlisefO8rQ0YuUC9Y/3Db8SC6+lMWHTmPkgRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302302; c=relaxed/simple;
	bh=zznhd6DL/qGbxjlCL45kekXNq+70fznZPjXWcEVWt4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOyaIez/FRes2fV4K638F9ZbGTYL6atKDAfmsS5XW+HkmeDvVu+ghx6BTjqHjGZJzu9eSYOA8uWK3JvufPNiYLuUU9NDBsyH9tlDBAZT4/G8jiq+UGmCOTNLJTZpMNXlCS3Yv3jxG8kdXKXVKLn8uk3YrL6/89C+CsOX5R83YpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3YxNU30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3YxNU30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A60C19425;
	Sat, 28 Feb 2026 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302301;
	bh=zznhd6DL/qGbxjlCL45kekXNq+70fznZPjXWcEVWt4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3YxNU30a6urJWBpti1Uh+aane0vfFjaYr3eleYmn+UoOeulgC6qSNS8l/XMnnR/F
	 ZA72EubhamvROe7cWXky+WlxzmCqeM3gb6hrAnl5zFBgtb7wH4Xtf/vjWhQng5Zghg
	 b5t6hSsMX4VvOvg5dysty2IqyxAZoreydAfNd1DxQvPSskjH/nwwNkr9Qzn7/cSdxt
	 WsNoQ9WvST0ygDaofuasAo6Bq2jzBVX7KausI3IyyLHiBFuDVB8/FiFv8TDTYOSOH2
	 1vgJ6i8RnORqU/+sDZzffv/r4nXwTxZRjtcqPqav7Ydgg1PHrV2mbh+n81TObl0UTv
	 lt2RWx2ClMV4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/232] smb: client: fix potential UAF and double free in smb2_open_file()
Date: Sat, 28 Feb 2026 13:07:49 -0500
Message-ID: <20260228181127.1592657-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit ebbbc4bfad4cb355d17c671223d0814ee3ef4eda ]

Zero out @err_iov and @err_buftype before retrying SMB2_open() to
prevent an UAF bug if @data != NULL, otherwise a double free.

Fixes: e3a43633023e ("smb/client: fix memory leak in smb2_open_file()")
Reported-by: David Howells <dhowells@redhat.com>
Closes: https://lore.kernel.org/r/2892312.1770306653@warthog.procyon.org.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 7fc7fcabce80c..fe016144f3405 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -124,6 +124,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
 		free_rsp_buf(err_buftype, err_iov.iov_base);
+		memset(&err_iov, 0, sizeof(err_iov));
+		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 			       &err_buftype);
-- 
2.51.0

