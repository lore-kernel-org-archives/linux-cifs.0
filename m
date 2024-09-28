Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2B21448E2;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560847; cv=none; b=ahVqBJOvPKBIccmUF6KZ8QnTxAHONd23kJ2RJYAwCDoc4WtapTj451XDD66oUJYcsOXQhqSFoZ9dxZAufWwLwPF9ZACpj+O2Uo5N0VUyPisZRjcx2q3KnR8EnKzsxE+zk/YpjkUrz6pKr2QZe4+eli1suAvgEbyw2k8QuUGpKbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560847; c=relaxed/simple;
	bh=ibU0NV9N4+As9CYwIR1i1p9CSz0pkS/imGG+NsSGISs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tp5gh+M7XcHNaFm+3ibqx3QFVpU0LqWcGZ+U7bjJWJ5i7g0fYs4HvAtjWpA4Y3V1VlN4JNpjddyZwCup93S2pmzdsDRXyPIZjHjxWyc+2PHLI4kEPRosGjHZ9EPjOEewORHJuxHp41lBLpmixV419tUY9tnxtY3p5C8kQnNQ0l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aucaODyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aucaODyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16324C4AF0B;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560847;
	bh=ibU0NV9N4+As9CYwIR1i1p9CSz0pkS/imGG+NsSGISs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aucaODyiw5YiE+714jUSi/JtbTY+9MMtXGxUpmNd99cD6wfXLmWa6QtjhMTu/xCdH
	 Z7L8TfLyZrqcB35EgcLTUhNrPclEFZnScdC9PU5ypTnn/DH9bRJiCF2/L8guUa1pi1
	 GFF478yGrzNRoIdQtpHELR9NwmY3yixdwRFN4OuBBzJoih5jmtEFk8kFEITFvS6Dkm
	 bKTX9OFLqeEOE5OULKCNlm7+qIOD75IJGTEUmsyeSFQhuRIQAiMww4DmuLJedkND5I
	 yBS9C41UkCbf3NpsQnvhhy2o/LHgmbrf+BzOzJYlz0myYIfoNzjOe2UN7fQGSMfqwE
	 ppYsbMlavpeXg==
Received: by pali.im (Postfix)
	id 9E3A6A4E; Sun, 29 Sep 2024 00:00:40 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] cifs: Remove intermediate object of failed create reparse call
Date: Sat, 28 Sep 2024 23:59:42 +0200
Message-Id: <20240928215948.4494-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-1-pali@kernel.org>
References: <20240928215948.4494-1-pali@kernel.org>
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
 fs/smb/client/smb2inode.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 11a1c53c64e0..af42f44bdcf4 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1205,6 +1205,8 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsFileInfo *cfile;
 	struct inode *new = NULL;
+	int out_buftype[2] = {};
+	struct kvec out_iov[2];
 	struct kvec in_iov[2];
 	int cmds[2];
 	int rc;
@@ -1228,7 +1230,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
-				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
+				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
 			rc = smb311_posix_get_inode_info(&new, full_path,
 							 data, sb, xid);
@@ -1237,12 +1239,27 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
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
+	if (rc) {
+		/*
+		 * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
+		 * remove the intermediate object created by CREATE. Otherwise
+		 * empty object stay on the server when reparse call failed.
+		 */
+		if (((struct smb2_hdr *)out_iov[0].iov_base)->Status == STATUS_SUCCESS &&
+		    ((struct smb2_hdr *)out_iov[1].iov_base)->Status != STATUS_SUCCESS)
+			smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
+	}
+
+	free_rsp_buf(out_buftype[0], out_iov[0].iov_base);
+	free_rsp_buf(out_buftype[1], out_iov[1].iov_base);
+
 	return rc ? ERR_PTR(rc) : new;
 }
 
-- 
2.20.1

