Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DDC3BB131
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 08:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168387; cv=none; b=AVzQkHl7jqklli7wE9bBUy+kV+nahL4y4oecm2Op5DSkLrDGOJt62uEvoA0sqstjpCzvHJvo0F9eUuHd1aUvMrNAQlDRS0dtLvzXubfRuu1+XuCRSgUx4q/q4c+HWHDNC2wbkewOle6TLDlQ1SXY59gwUAq/xfMWtdAO+wpmWdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168387; c=relaxed/simple;
	bh=fYdmm2AuLzekLyTTRBDSoDxAM9gGs0gsYxrx/avLmLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KR0Dccp1uxvpA6K95EGAxhbTMa2TI2Tck6ykPGes0ujeW2Y9qxlqcbW9VGW1C24JUjO8OzVuhPbN9sqtXIShQcNLmiuyYnfCY6tHvg4Y9nlaeRANL10Pv+jyV6q8t+LX2IcQpJAdOBYKQWwseBd3iy+Y+BLuRcLz2iw4US4KXH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=pzPsyDac; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="pzPsyDac"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781168379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MxEUkuacp5HtBPF2z+0Ha/eJ8GPG5W9458F8EDflpAY=;
	b=pzPsyDac+lrVqBrOw878+Sikd/CX/SE+Ys3+MWL8zZDHRrfXULuJpapLUXWNyPuXxxxADb
	9Q8NbqLYYsnO2kPdiIjT4DAMGQ57X/MXcvmhTw+4X8Y9gQEmzApHuA5RcMDDs4w44eEhKO
	f6R5Xd53wMqoscigfE2Myw8fjk8EMsHmTYbXB1sm/ua7hNkWOod/wI9Z6FK46zcYGvPdV6
	ibw60dpe5dXzNd8s+rgFJ7PIAGwHvrphunRWt2Zeie1ejamqtiCRvyX4Ya7oc+J1xzVeej
	14yvsNkOizTIVjYl+lLmFdNik7M4UvRp6Wg9uOY5tftJu+UxVN0o7Y68UPyqTw==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: check destination is open when renaming
Date: Thu, 11 Jun 2026 08:58:47 +0000
Message-ID: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount -t cifs //${server_ip}/export /mnt
  3. client: touch /mnt/file1 /mnt/file2
  4. client: C program: int fd = open("/mnt/file2", O_RDONLY);
  5. client: C program: rename("/mnt/file1", "/mnt/file2");
  6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
                        stbuf.st_nlink is 1, should be 0

Before this patch, packets captured by tcpdump were as follows:

  - SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:file2
  - SetInfo Response

If the destination file of a rename operation is already open,
ksmbd should return STATUS_ACCESS_DENIED to client.

After this patch, packets captured by tcpdump are as follows:

  - SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:file2
  - SetInfo Response, Error: STATUS_ACCESS_DENIED
  - ...
  - Create Request, File: .__smbfile_silly1d; \
    GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO; \
    Close Request
  - Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND; \
    GetInfo Response, Error: STATUS_FILE_CLOSED; \
    Close Response, Error: STATUS_INVALID_PARAMETER
  - Create Request, File: file2; \
    SetInfo Request FILE_INFO/SMB2_FILE_BASIC_INFO; \
    SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:.__smbfile_silly1d; \
    SetInfo Request FILE_INFO/SMB2_FILE_DISPOSITION_INFO; \
    Close Request
  - Create Response, File: file2; \
    SetInfo Response; \
    SetInfo Response; \
    SetInfo Response; \
    Close Response
  - SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:file2
  - SetInfo Response

This patch fixes xfstests generic/035.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 00033c4a5eb5..251dd6bfb06a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -718,6 +718,16 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out3;
 	}
 
+	if (d_really_is_positive(rd.new_dentry)) {
+		struct ksmbd_file *target_fp;
+		target_fp = ksmbd_lookup_fd_inode(rd.new_dentry);
+		if (target_fp) {
+			ksmbd_fd_put(work, target_fp);
+			err = -EACCES;
+			goto out3;
+		}
+	}
+
 	err = vfs_rename(&rd);
 	if (err)
 		ksmbd_debug(VFS, "vfs_rename failed err %d\n", err);
-- 
2.54.0

