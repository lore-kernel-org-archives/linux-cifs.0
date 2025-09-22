Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C5A1547CC;
	Mon, 22 Sep 2025 19:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570405; cv=none; b=MiMkz8QaF+zP5JGNj3XlX2tOqQjLZZNRhdLlEfNOod5TpGvc0ppB8opVZPwYPbuIQy5M4Vq71GPXz/A/jdMup64yCoo6tbjVy23v7ImnP98MgKKYwuSngxXi3uTox6SE4hQMGKAFYy5hLQEBv6yJe6/oNe3W7aTAg8OfB6D8aw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570405; c=relaxed/simple;
	bh=X+sk1trCUHMuCbxMjOOrXga4TMtY/Di6R+460yKeuuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaPlPDTy+gsPlB5nv9Wb8KS2eDZyRN1ebqPw0nbp511ckT5be86O5B1JA46AOg4vxrYrh5t12tpzRRGwe9eSStt1LG1f47PliM/ohQBFfoipMxebIDhuLtEeEBkX1xK9u6f7Zcc9eXZ90hjUW+/19S3YwaibvBV50oUn2pr23Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RONlRKiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RONlRKiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8967CC4CEF0;
	Mon, 22 Sep 2025 19:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570404;
	bh=X+sk1trCUHMuCbxMjOOrXga4TMtY/Di6R+460yKeuuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RONlRKiqIP5CYUso2oTmbaqUbouWK5c5ukZZxlzTnlvYIoILZAwwhgVbF513UmGsa
	 URXowt4iylF/8JYbBY41hLU/wTRYoqnM0kKJ33QbUsOkoqMyojJFhu1MvJahzhN8lc
	 8FsJAg5TsJHgDkYZQJ7R49L+n4IKbj7UL5DM58kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 136/149] smb: client: fix file open check in __cifs_unlink()
Date: Mon, 22 Sep 2025 21:30:36 +0200
Message-ID: <20250922192416.296757898@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 251090e2c2c1be60607d1c521af2c993f04d4f61 ]

Fix the file open check to decide whether or not silly-rename the file
in SMB2+.

Fixes: c5ea3065586d ("smb: client: fix data loss due to broken rename(2)")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1703f1285d36d..0f0d2dae6283a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2003,8 +2003,21 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 		goto psx_del_no_retry;
 	}
 
-	if (sillyrename || (server->vals->protocol_id > SMB10_PROT_ID &&
-			    d_is_positive(dentry) && d_count(dentry) > 2))
+	/* For SMB2+, if the file is open, we always perform a silly rename.
+	 *
+	 * We check for d_count() right after calling
+	 * cifs_close_deferred_file_under_dentry() to make sure that the
+	 * dentry's refcount gets dropped in case the file had any deferred
+	 * close.
+	 */
+	if (!sillyrename && server->vals->protocol_id > SMB10_PROT_ID) {
+		spin_lock(&dentry->d_lock);
+		if (d_count(dentry) > 1)
+			sillyrename = true;
+		spin_unlock(&dentry->d_lock);
+	}
+
+	if (sillyrename)
 		rc = -EBUSY;
 	else
 		rc = server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry);
-- 
2.51.0



