Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2469736BA3B;
	Mon,  5 May 2025 22:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485804; cv=none; b=cYcA+aEvQcs+KRWO+cFD8+V25UmfjjnqeQ1SmIg4HXnkz3ofYSGTVlGvTegDp+7b2dCiHFQgUN+D4CsxEq87hatTyynb/BsyBcASTTcqgiCmmBs/JeBVLrNkj248NcG4K53D8vr1TlT1/S18CRn6jN182PZ5bwfXQi+smhUSFL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485804; c=relaxed/simple;
	bh=b1Mp+hs/QwvWY4qacbFDHS9ub72oRnFqgeAx9FfSzpw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TU5pDedguhQAnSAQgSFy/vgHTDwCA/JvhfDECt2sMzepJD4g75BYoj68DmCQuUX7+Quc20egzzh00iipSduFy8Iaf172l8MEGI3TB5vIvhVy2fRwIz2r6DMm1k06kHOjrjN1LMHe5ObxCj6b0kDHH7w4biJU3NBYNEmRRuJGqnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMTeH77/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMTeH77/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6276C4CEE4;
	Mon,  5 May 2025 22:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485803;
	bh=b1Mp+hs/QwvWY4qacbFDHS9ub72oRnFqgeAx9FfSzpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMTeH77/MqBJSQ+aqAhdJa74X9vHOwGLDXvcSwBevOfMS7TajMSfXZngezTFrc9JT
	 Fy5vZXYBpjg+eZTAMQlKY0seAimvNK1RRULp/yfreDkhv8k1Vo3jvmT40Sf+ElPh4T
	 Qt8N0lzIlAHUFx+D8Fldvvldxhazqd0Qx1VG3E1NIaDoSNOCuFBAs3O9kpDIHlbwYy
	 a8m+WSdljtwjjtcVROTr6R55fZl8WbCkXa+AdutAa3aiEBbQEB0xrCqT7DMmo55nhq
	 QLdPug1HZYxTwvf7hENMedGuwKgzY/niTrhogMvjc8FbkxQ4kqXVODo21bKZvaNG6C
	 WvicedAAv4IDA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 004/294] cifs: Fix querying and creating MF symlinks over SMB1
Date: Mon,  5 May 2025 18:51:44 -0400
Message-Id: <20250505225634.2688578-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 4236ac9fe5b8b42756070d4abfb76fed718e87c2 ]

Old SMB1 servers without CAP_NT_SMBS do not support CIFS_open() function
and instead SMBLegacyOpen() needs to be used. This logic is already handled
in cifs_open_file() function, which is server->ops->open callback function.

So for querying and creating MF symlinks use open callback function instead
of CIFS_open() function directly.

This change fixes querying and creating new MF symlinks on Windows 98.
Currently cifs_query_mf_symlink() is not able to detect MF symlink and
cifs_create_mf_symlink() is failing with EIO error.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index d86da949a9190..007da0a699cb0 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -257,7 +257,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	FILE_ALL_INFO file_info;
+	struct cifs_open_info_data query_data;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -269,11 +269,11 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, &file_info);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &query_data);
 	if (rc)
 		return rc;
 
-	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (query_data.fi.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		rc = -ENOENT;
 		/* it's not a symlink */
 		goto out;
@@ -312,7 +312,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc)
 		return rc;
 
-- 
2.39.5

