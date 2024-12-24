Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1111BC20;
	Tue, 24 Dec 2024 13:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735046376; cv=none; b=IB+urYXM5Khvjnpcc7dbpUNtPrh5BNBCiHx9/tXEI3+njC8DZcWZUVtf9kBaiOd8QvmmnpyvzQYpOlTUIiBSWSLZGu6+Ufy7lTpVgB4YvS6sXg5wjCRuCgTUq4oMl4Ph0XEMkFPRvW0fdPQTDz1T9UH6EduRQ3Ls67mxxFDM/AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735046376; c=relaxed/simple;
	bh=V4I94Tz0kDy0ddqBKcT7fW2KnTaG2u5ww3vXh4Ky8xk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=jBy/yb2ofLpLy77mGyC5wdXsfd8BdWstRmmyp0PVmtoOjqffk+YWFgDkZQJYrhT9CtGWa869cI1yT+7injm5kiNeOM3vZ+NJMtpFfw9yTEzcLI7zpvVLToVhgNYqCw8gAqRCB3UOUjAuM2Cyj5byK9RoYgyJ7v5A7/yms4tXUSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EmnNG0W9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmnNG0W9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776EC4CED0;
	Tue, 24 Dec 2024 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735046375;
	bh=V4I94Tz0kDy0ddqBKcT7fW2KnTaG2u5ww3vXh4Ky8xk=;
	h=From:To:Cc:Subject:Date:From;
	b=EmnNG0W9VeMWMhUOAHhBKAVe0fqQnsxW+KsVksRVyB7zrnIl104qOX56uhIM6IVnf
	 Ijr8k/JLf6hwYEfNC+XfX0vsNnwXdEKhlR4CwUzSh0axYO/gIOk5k1CzMPcayfK7pr
	 79bTCobZopX7QfA769adwNNMZO9Ps43HzzIm+O6y2FuxOka2Yz/FwfrSbPavCoTsFp
	 BM4wOWCp/PSRES3UHw1kp629mA1Xg7qY40bCuFuR6b3I3PLLSmwn1m+hRkv3GHwMeg
	 GUOj8VFOu7jVm46JCFv4RtMmSVctCNg56KyeAlNg2EgN5PWZCCgIm97316kdXqz2Qw
	 9StePBPQexfCQ==
Received: by pali.im (Postfix)
	id 312A9988; Tue, 24 Dec 2024 14:19:25 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] cifs: Fix getting reparse points from servers without EAs support
Date: Tue, 24 Dec 2024 14:18:59 +0100
Message-Id: <20241224131859.3457-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If SMB server does not support EAs then for SMB2_OP_QUERY_WSL_EA request it
returns STATUS_EAS_NOT_SUPPORTED. Function smb2_compound_op() translates
STATUS_EAS_NOT_SUPPORTED to -EOPNOTSUPP which cause failure during calling
lstat() syscall from userspace on any reparse point, including Native SMB
symlink (which does not use any EAs).

If SMB server does not support to attach both EAs and Reparse Point to path
at the same time then same error STATUS_EAS_NOT_SUPPORTED is returned. This
is the case for Windows 8 / Windows Server 2012. It is known limitation of
NTFS driver in those older Windows versions.

Since commit ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
Linux SMB client always ask for EAs on detected reparse point paths due to
support of WSL EAs. But this commit broke reparse point support for all
older Windows SMB servers which do not have support for WSL and WSL EAs.

Avoid this problem by retrying the request without SMB2_OP_QUERY_WSL_EA
when it fails on -EOPNOTSUPP error.

This should fix broken support for all special files (symlink, fifo,
socket, block and char) for SMB server which do not support EAs at all and
for SMB server which do not allow to attach both EAs and Reparse Point at
the same time.

Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index e8bb3f8b53f1..58276434e47b 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -875,6 +875,7 @@ int smb2_query_path_info(const unsigned int xid,
 	bool islink;
 	int i, num_cmds = 0;
 	int rc, rc2;
+	bool skip_wsl_ea;
 
 	data->adjust_tz = false;
 	data->reparse_point = false;
@@ -943,7 +944,13 @@ int smb2_query_path_info(const unsigned int xid,
 		if (rc || !data->reparse_point)
 			goto out;
 
-		if (!tcon->posix_extensions)
+		skip_wsl_ea = false;
+retry_cmd:
+		/*
+		 * Skip SMB2_OP_QUERY_WSL_EA if using POSIX extensions or
+		 * retrying request with explicitly skipping for WSL EAs.
+		 */
+		if (!tcon->posix_extensions && !skip_wsl_ea)
 			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
 		/*
 		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
@@ -961,6 +968,35 @@ int smb2_query_path_info(const unsigned int xid,
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      &oparms, in_iov, cmds, num_cmds,
 				      cfile, NULL, NULL, NULL);
+		if (rc == -EOPNOTSUPP && !tcon->posix_extensions && !skip_wsl_ea) {
+			/*
+			 * Older Windows versions do not allow to set both EAs
+			 * and Reparse Point as the same time. This is known
+			 * limitation of older NTFS driver and it was fixed in
+			 * Windows 10. Trying to query EAs on file which has
+			 * Reparse Point set ends with STATUS_EAS_NOT_SUPPORTED
+			 * error, even when server filesystem supports EAs.
+			 * This error is translated to errno -EOPNOTSUPP.
+			 * So in this case retry the request again without EAs.
+			 */
+			skip_wsl_ea = true;
+			num_cmds = 1;
+			goto retry_cmd;
+		}
+		if (rc == 0 && skip_wsl_ea &&
+		    (data->reparse.tag == IO_REPARSE_TAG_LX_CHR ||
+		     data->reparse.tag == IO_REPARSE_TAG_LX_BLK)) {
+			/*
+			 * WSL CHR and BLK reparse points store major and minor
+			 * device numbers in EAs (instead of reparse point buffer,
+			 * like it is for WSL symlink or NFS reparse point types).
+			 * Therefore with skipped EAs it is not possible to finish
+			 * query of these files. So change error back to the
+			 * original -EOPNOTSUPP.
+			 */
+			rc = -EOPNOTSUPP;
+		}
+
 		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
 			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
 			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
-- 
2.20.1

