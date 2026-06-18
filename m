Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B6B2609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792292; cv=none; b=Q/dm+19bZTZwOpcUNQ0JhO5dwON+uKOuNDLuZlHyqsq0gLHMJCholePwRqm7RGI/r9q/JOnZMfmtTVyu14pu1Y8E6nm+97133Pk5MPRia3ln3CCdhQEZKQNqe4T07pnadqH7QXHfjPkdFKKmQCJQyHPPrsKzRgVJZW5R3s2Ef0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792292; c=relaxed/simple;
	bh=QGkoshxyufZgN85m5IlPvV2VSRgH0odbQ1U+cofR0kA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mQPCt1bKq7nJh3IFk/+klGK5ljZyfarwuYfN2/cvyysvsaxL55wIUpyNXNyVZKMBivjUEX4PLePiPbmwkUCHtvOgBFdmzQEvYL8Sud8K0Uwc4dMJbLyxYDiY4AD7Ul4WNQVYimm96b8HfVGGqGiwSehasxQNAbbWcy2z91hkeMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjbPC/iE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjbPC/iE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DB91F000E9;
	Thu, 18 Jun 2026 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792291;
	bh=1dO+cm3NsqvPGP8rEUM8+hvgPUIS7tydwWt725UqPo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjbPC/iErRhPqwJPSLINRSGWXgpisUlInQgx5ZPrk/NCcwVwcyqatyawp+nRN379N
	 xE3LlJwtaj/jV3A/+jCnRPH1UCwF9HGxuduNBkojBr47/mTda7LkRy8+amM5FByMXv
	 c4+vTCTUq+5GXAPZpBemX0ZMkDI57q1UYzQm91fIIQyTKYCRHzl+lXSuKUT664HQt7
	 xuysRsX41SoJWLM/6yj3ChXVc35yqscARQ7gSDr39SXUirt1hV/zvyvD38ws9LGXqm
	 6twFyydk9AK0rdnb1WXvydBuPkUafYYEfDrBBcfau1hph7p7rrvxxLRFo7lW95Du+k
	 0a+8c/gyv++0g==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 12/14] ksmbd: break RH leases before delete-on-close
Date: Thu, 18 Jun 2026 23:17:37 +0900
Message-Id: <20260618141739.9029-12-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260618141739.9029-1-linkinjeon@kernel.org>
References: <20260618141739.9029-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The delete paths only marked the opened file delete pending or
delete-on-close.  When another client still held a read/handle lease, no
lease break was sent before the delete state changed.

smb2.lease.unlink uses a create request with FILE_DELETE_ON_CLOSE and
expects the second client's unlink to break the first client's RH lease to
R with ACK_REQUIRED set.  SetInfo(FileDispositionInformation) has the same
lease-breaking requirement.

Break level-II/read-handle leases before setting delete pending or
delete-on-close so clients are notified before the file is removed.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ef5f7c056b4d..03dc879d2d8b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3653,8 +3653,10 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 	}
 
-	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)
+	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_fd_set_delete_on_close(fp, file_info);
+	}
 
 	if (need_truncate) {
 		rc = smb2_create_truncate(&fp->filp->f_path);
@@ -6584,7 +6586,8 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	return smb2_rename(work, fp, rename_info, work->conn->local_nls);
 }
 
-static int set_file_disposition_info(struct ksmbd_file *fp,
+static int set_file_disposition_info(struct ksmbd_work *work,
+				     struct ksmbd_file *fp,
 				     struct smb2_file_disposition_info *file_info)
 {
 	struct inode *inode;
@@ -6599,6 +6602,7 @@ static int set_file_disposition_info(struct ksmbd_file *fp,
 		if (S_ISDIR(inode->i_mode) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_set_inode_pending_delete(fp);
 	} else {
 		ksmbd_clear_inode_pending_delete(fp);
@@ -6725,7 +6729,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
 			return -EMSGSIZE;
 
-		return set_file_disposition_info(fp,
+		return set_file_disposition_info(work, fp,
 						 (struct smb2_file_disposition_info *)buffer);
 	}
 	case FILE_FULL_EA_INFORMATION:
-- 
2.25.1

