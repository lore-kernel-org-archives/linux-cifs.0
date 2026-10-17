Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A9335F162
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199086; cv=none; b=NU3eQfCWMZk/SP1KKqVoT6JLzD/Zndc8YtZyFS3P1tSTLTKPK8mqhPsHVVBpqy3L0SIaWi0EEkiGlIDAqCDXiZyLM+mqu6rcoRfYo365SZH4ydLxVouDwrFo81lDMBMdr206y4HMr2GqhZjqWgBeaf0u1CPtPgMo/BEPN7DlHwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199086; c=relaxed/simple;
	bh=3bbGQlP5rD6U0NHIO2mxuVAVr74O3g8nYy/xWM1qaDg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X2paohVz9zuzGHPdcl6aGTaCvM4vjS4RHICHgP34htqW98IKrmmJ8fuYsFY2e/hzmpYvpBar+5WY02MRqgzmjn7S3Yjlh1pXj0ktfruV3QJNAJeiv9dN6jQsNJEH4DIb95Gz10EvXlh4ROPuNEbPDmhLRzOjasjV/Mg4I3CnjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYUR/P2r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYUR/P2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5891F000C5;
	Sat, 17 Oct 2026 01:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199085;
	bh=5C63hYgDhz4K15OQuJQunbKHuAUUibpORT9xa29zR+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYUR/P2r0AHyDYMcs5bDMNZOk+UZyX8EEuHGq+yiyVUYyzRgGvhjmsgAannjOAUDF
	 YCnZnmyVTsv8ShGdR0jZYODB5OZm+u+9HUbLP6bMmmQZo70jWi6IbalfPj6YHxBgeU
	 LQ+9GZD5zlchXYktdvvfZrK4eRyPfIM2AdqS+c2YxXDTQK060Wx38hAWthzaN44gCJ
	 Sic9B+ywkYcL+zpdfogjXHoY4H8bbQIpGCs+ymGNk+Ta9XHX6XDMMfV+CJAmCpwl2z
	 rBpnWaseEP42VPbdvyazJn0y7VMwCAXoKxBOnOs+WfPVrVHd9Qa1IBALN9kF8B4oEh
	 XrocC8Qn1wnJQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 20/22] ksmbd: require POSIX opens for file and directory queries
Date: Sat, 17 Oct 2026 10:03:42 +0900
Message-Id: <20261017010344.11478-20-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

POSIX file information queries only check the tree's extension flag,
while directory queries do not verify that the directory was opened with
a POSIX create context.

Require SMB3.1.1, negotiated POSIX tree extensions and a POSIX open for
both file and directory POSIX information requests. Return
STATUS_INVALID_INFO_CLASS when these conditions are not met.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6fd8ec6be222..b3683e85cb31 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6470,6 +6470,12 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rc = -EBADF;
 		goto err_out2;
 	}
+	if (req->FileInformationClass == SMB_FIND_FILE_POSIX_INFO &&
+	    (conn->dialect != SMB311_PROT_ID ||
+	     !work->tcon->posix_extensions || !dir_fp->is_posix_ctxt)) {
+		rc = -EFAULT;
+		goto err_out2;
+	}
 
 	if (!(dir_fp->daccess & FILE_LIST_DIRECTORY_LE) ||
 	    inode_permission(file_mnt_idmap(dir_fp->filp),
@@ -7692,8 +7698,9 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		rc = get_file_attribute_tag_info(rsp, fp, work->response_buf);
 		break;
 	case SMB_FIND_FILE_POSIX_INFO:
-		if (!work->tcon->posix_extensions) {
-			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
+		if (work->conn->dialect != SMB311_PROT_ID ||
+		    !work->tcon->posix_extensions || !fp->is_posix_ctxt) {
+			rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
 			rc = -EOPNOTSUPP;
 		} else {
 			rc = find_file_posix_info(work, req, rsp, fp);
-- 
2.25.1

