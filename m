Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C46F9CB;
	Sun, 29 Sep 2024 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727618637; cv=none; b=gHgvyW7vapkWhfbTGeATMogGDjC71LgK8l4MWF+AjwQEU/I4k1F8BOPq+Ctxl9FUexeDb95Ao1a7AUwB1Ua29UXZde358TdULWj62cEqAZF2PMRd8ELLrEk9piGmFgrofYWh6NhotV13RhVFWqP+9XsBvikcctWapVANEefmcJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727618637; c=relaxed/simple;
	bh=1T3C23ITgq1aQSpNDFxIMUGL29G4p187OUrb/JTMBK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bx2ndwVfeYW9w9IZLmPSRB+aqvbNNVxoJ0Jv8K9mYdzgJghqlPzWnjEPrCv4HTZsOmCVMCKUqmaJcWt7cRHys6URUaq4x2LTaBsYsyLkXfz+WeSo9IABdU9gf663zHFkqz7Ic+IcEL8qMUAxQUbauzSMTwAvg1I4N7mWHxu9JHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/KeJ7gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/KeJ7gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4EEC4CEC5;
	Sun, 29 Sep 2024 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727618636;
	bh=1T3C23ITgq1aQSpNDFxIMUGL29G4p187OUrb/JTMBK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/KeJ7gNJOHNoVYqUC76clW1milBws4OACbDFdjhAOwv9sFYPBv1D8Y8CFtPjWt7A
	 kVolzi3Byu11b3mNwCMwRw45QmUgAgwuJXLCpnZIRQZEHHJsgs+HOhp1JCwG7ga52b
	 HxxAweyTyJJH8f4uk2Jamr1dJiufHWTE2mb7vLyDdrmAmQeCNK80SymDoAvHVOXn0p
	 08UqyRAZgMctr/ga5ZQBTwVzJEak00SKXmM7BJkGklo1CHOZ+vPdqE736UUErauh3h
	 tke7eE0+sKXw2elJsePOF9MAWrJ64VM9Vzs3wLpIXziJOTPhcaNA7XG1ZxoMu476SJ
	 3M4p0EbTlEU7A==
Received: by pali.im (Postfix)
	id 68C2E872; Sun, 29 Sep 2024 16:03:50 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] cifs: Remove intermediate object of failed create reparse call
Date: Sun, 29 Sep 2024 16:03:43 +0200
Message-Id: <20240929140343.9147-1-pali@kernel.org>
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
Changes in v2:
* Increase out_buftype[] and out_iov[] members from 2 to 4 as required by smb2_compound_op
* Call free_rsp_buf() for all members of out_buftype[]/out_iov[]

I would like if you double check this smb2_compound_op() usage if there
is not some other memory issue. As V1 contained both memory leak and
buffer overflow (smb2_compound_op wrote out of those two arrays).

---
 fs/smb/client/smb2inode.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 11a1c53c64e0..6e69a3b98be3 100644
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
@@ -1237,12 +1240,27 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
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
+	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
+		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
+
 	return rc ? ERR_PTR(rc) : new;
 }
 
-- 
2.20.1

