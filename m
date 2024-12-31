Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54291B0401;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684551; cv=none; b=lO7o32w/v1tuQcr5WJUDa3HYPJfvXfn6lpYb25ZsetQQtnqVRQUNsoAE128fdw4LiIgrM+Iho6sovnBxKmTRMyLfJgNynXBSVJ5qSg4J01u3AV38csg+pNTB/LHW1TJJMD9qo0BqBw9xxrWeuehnk2Ereig2nWT2EJmgNBwbEOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684551; c=relaxed/simple;
	bh=OQK7l6kkrF4aaKofM7nULw1FDL8eDddYk2IX5MvKcV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GoaZxpgdtlT4/9MzPdRD0qkxeh+RnW8VSbyHfcyYXaq4kZkaXsPVOA+eA19rNdQfVwYLK34oV9h6SK42DHqAuCc9bMRR2ZJLviZyG4N5WejDwq0Ua181cqJJzccSTXH7nXOy0JcXM28xYq6exqCqfl/G9T/wUl3Z29hN+ewq28U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsjFUURX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsjFUURX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B1C4CED6;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684551;
	bh=OQK7l6kkrF4aaKofM7nULw1FDL8eDddYk2IX5MvKcV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsjFUURX8oUx4N5l1mhHoFQu5/9tyYrn3krg3qaUfUQ4fE96Y7AE5+DXidmfqKIoQ
	 lWmupNw2Th2n9Mn1TmqKoK9plrpq5VcmXpGr+2LY+a/+TjFeGcePhYI6Y1mdmPcrjw
	 6skJ+VP7rwhtlPP587Z4KviTYaFHhOhjEXz0vclN4Ric6Krcvbaupnvoo5/k9hYPgj
	 t23LyoAtav+gMRg4kAvN8cutTkiLmuZFCuNepLDUyM3VmibJoRUPuadfVCScckXLvi
	 CmvfTr3U/641GbQ5Ut/iA+1Lgd6oULUp/9cqgel4UHDIj5+rN6Yy8mzJENSxMr1BLI
	 qk/Bjjcivj1nw==
Received: by pali.im (Postfix)
	id 186B998C; Tue, 31 Dec 2024 23:35:41 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] cifs: Improve SMB2+ stat() to work also on non-present name surrogate reparse points
Date: Tue, 31 Dec 2024 23:35:12 +0100
Message-Id: <20241231223514.15595-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223514.15595-1-pali@kernel.org>
References: <20241231223514.15595-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SMB server returns STATUS_OBJECT_PATH_NOT_FOUND if the path exists, is the
reparse point of name surrogate type (e.g. mount point) and surrogate
target location does not exist.

So if the server returns STATUS_OBJECT_PATH_NOT_FOUND error then it is
required to send request again with OPEN_REPARSE_POINT flag. This is needed
to distinguish between path does not exist and path exists and points to
non-existent surrogate location.

Before this change, Linux SMB client returned for non-present name
surrogate reparse point -ENOENT error. With this change it correctly
returns that the entry exits, it is of directory type with filled stat
information.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0b8d6d8f724d..b6342b043073 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -958,6 +958,18 @@ int smb2_query_path_info(const unsigned int xid,
 	if (!hdr || out_buftype[0] == CIFS_NO_BUFFER)
 		goto out;
 
+	/*
+	 * SMB server returns STATUS_OBJECT_PATH_NOT_FOUND if the path exists,
+	 * is the reparse point of name surrogate type (e.g. mount point) and
+	 * surrogate target location does not exist.
+	 * So if the server returns STATUS_OBJECT_PATH_NOT_FOUND error then it
+	 * is required to send request again with OPEN_REPARSE_POINT flag.
+	 * Re-opening with OPEN_REPARSE_POINT is done in the case when rc is
+	 * -EOPNOTSUPP.
+	 */
+	if (hdr->Status == STATUS_OBJECT_PATH_NOT_FOUND)
+		rc = -EOPNOTSUPP;
+
 	switch (rc) {
 	case 0:
 		rc = parse_create_response(data, cifs_sb, full_path, &out_iov[0]);
-- 
2.20.1

