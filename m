Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2617190482;
	Mon, 30 Sep 2024 20:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727946; cv=none; b=klMbZr3LHiswYpOFw37gy2CBf/zFhWiq9BbI7iSfzhhS8pXd5K5uGzVDIck7H7EtXCJzOMThpFIzpXaLnIPrq8TrfyZnQuWePZOMT0Pi2DoSdjyKLdIdwAF/OuTrtJ8fu2ildKNuGI/kZPw2JII0fy2CjVUs7GNu3aql8CUv1ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727946; c=relaxed/simple;
	bh=ztF0FR8WhBBsGvAW7xRLwt2kXYq4vB7Zl9qwuHTHOrA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOrlvsPFa7gZCAOx1C5vnUYn6J7VvSXkr9hwZXuD1RuaFUu/0rx6SO4HkmA6hqWYSpjH4cIQlwDXVR8CtUdZ3CO2M1hVa6h1XyYX9G4FluGqoSBnCe1wDFw8msEcR29Ll+CKwLAkPJFoc0R0ODjDbEb6+sKUu5bqW1l+FPEr4VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwmMc4uL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwmMc4uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D44C4CEC7;
	Mon, 30 Sep 2024 20:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727727945;
	bh=ztF0FR8WhBBsGvAW7xRLwt2kXYq4vB7Zl9qwuHTHOrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwmMc4uL3zkAC/F4JcqEmCzFOxTjCVKF2zJMDlgOaR1IMi4uP7v9s/ZPkMCvrncx6
	 xsaKF3kamyCOXLgjnemuBhq5NzT6W2OFsbJlckpwkrnpN0VIQIkrQB/pO6xFFWxcIP
	 IVyrolTkkYiLQhg0JOvYb1NZANG6UUod/bQcyTtDYwefGxSKHBSENG6bN2bhb2SKkv
	 hKNytPEOgzVsrJz+J/5u01AIfqSGroYPfoW5dEBnk1Ag+gr4cKbD2R1qsaNJjCt33R
	 lgAO/1dSb4CPqyHKUtzoUGp6gBY5SldI+hKndHKmY8JqgmN697QOaS5JyIzTnSUqjp
	 UGiMbaegnYoZA==
Received: by pali.im (Postfix)
	id 96B3C7D0; Mon, 30 Sep 2024 22:25:39 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] cifs: Remove intermediate object of failed create reparse call
Date: Mon, 30 Sep 2024 22:25:10 +0200
Message-Id: <20240930202510.23187-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-3-pali@kernel.org>
References: <20240928215948.4494-3-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
intermediate object created by CREATE. Otherwise empty object stay on the
server when reparse call failed.

This ensures that if the creating of special files is unsupported by the
server then no empty file stay on the server as a result of unsupported
operation.

Fixes: 102466f303ff ("smb: client: allow creating special files via reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
Changes in v3:
* Check if iov_base and out_buftype are valid before derefrencing iov_base
Changes in v2:
* Increase out_buftype[] and out_iov[] members from 2 to 4 as required by smb2_compound_op
* Call free_rsp_buf() for all members of out_buftype[]/out_iov[]
---
 fs/smb/client/smb2inode.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 11a1c53c64e0..a6dab60e2c01 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1205,9 +1205,12 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsFileInfo *cfile;
 	struct inode *new = NULL;
+	int out_buftype[4] = {};
+	struct kvec out_iov[4] = {};
 	struct kvec in_iov[2];
 	int cmds[2];
 	int rc;
+	int i;
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     SYNCHRONIZE | DELETE |
@@ -1228,7 +1231,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
-				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
+				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
 			rc = smb311_posix_get_inode_info(&new, full_path,
 							 data, sb, xid);
@@ -1237,12 +1240,29 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 		cmds[1] = SMB2_OP_QUERY_INFO;
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
-				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
+				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
 			rc = cifs_get_inode_info(&new, full_path,
 						 data, sb, xid, NULL);
 		}
 	}
+
+
+	/*
+	 * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
+	 * remove the intermediate object created by CREATE. Otherwise
+	 * empty object stay on the server when reparse call failed.
+	 */
+	if (rc &&
+	    out_iov[0].iov_base != NULL && out_buftype[0] != CIFS_NO_BUFFER &&
+	    ((struct smb2_hdr *)out_iov[0].iov_base)->Status == STATUS_SUCCESS &&
+	    (out_iov[1].iov_base == NULL || out_buftype[1] == CIFS_NO_BUFFER ||
+	     ((struct smb2_hdr *)out_iov[1].iov_base)->Status != STATUS_SUCCESS))
+		smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
+		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
+
 	return rc ? ERR_PTR(rc) : new;
 }
 
-- 
2.20.1

