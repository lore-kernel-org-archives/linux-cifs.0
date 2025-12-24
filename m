Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB134D914;
	Wed, 24 Dec 2025 14:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766586039; cv=none; b=qt/AYN5r6pcwqphUqA/P2tFkQ2aoNPfDcirRV41ArbCrqHYjDZ0avE8eMd8m9eGc9IEKbNGPHefZCowZLMaYgKnkkQzADMZbVs/6lBVnEXHhRBOab5ICd0e8xmiczz+N7Mlu7zmvLbAX8gDEn8ZjHDdKAGledDQnde+QjMOV76o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766586039; c=relaxed/simple;
	bh=t6JydTRdh3ZejSzmxvzlZ9+tQHQAbTb2slGusDLDQZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B+BXs5VDTpCziwXXDRE5ccxwFxA97xhiUqwzVhZWG5qdOPmrvz4FJbUnk2pPLb5Y3ORJgphkRj1V/Thspz22ylnk2GczSkDli8cry6hsiB1HspjIQjHA4kDy+GVXgsGktACtUEhMppr5Ov0+CjSvVELhGLW9xhjpCoa7MqqBNSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=TSZVIPfE; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="TSZVIPfE"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2e6fcae01;
	Wed, 24 Dec 2025 22:20:25 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: linkinjeon@kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] ksmbd: Fix memory leak in get_file_all_info()
Date: Wed, 24 Dec 2025 14:20:16 +0000
Message-Id: <20251224142016.250752-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b50bb7aef03a1kunm72037eb03566
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDH08aVkMdHRlLSxlPSRpNT1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=TSZVIPfEJa6/XyK2/idShVN4jnqltUEpqKJGtf8YNeb8Du8m7r1qdc4qjjCB5WmFnFJ9nNV5wM2Pjd2z+saJ/z7YuyN6w8tOWaLvyJRt6ctHOkVG7q/d2Z3j0oJsh6hy+38OriOip1xnl314og2P5UbEXHDpIyBKniliyzpjMkQ=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=VaZ4rzoSi1+FjLevS2eVmgQmJET0wPEI+fuaCFCVFAU=;
	h=date:mime-version:subject:message-id:from;

In get_file_all_info(), if vfs_getattr() fails, the function returns
immediately without freeing the allocated filename, leading to a memory
leak.

Fix this by freeing the filename before returning in this error case.

Fixes: 5614c8c487f6a ("ksmbd: replace generic_fillattr with vfs_getattr")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8aa483800014..4472638ab11a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4923,8 +4923,10 @@ static int get_file_all_info(struct ksmbd_work *work,
 
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			  AT_STATX_SYNC_AS_STAT);
-	if (ret)
+	if (ret) {
+		kfree(filename);
 		return ret;
+	}
 
 	ksmbd_debug(SMB, "filename = %s\n", filename);
 	delete_pending = ksmbd_inode_pending_delete(fp);
-- 
2.34.1

