Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393EB6FB0
	for <linux-cifs@vger.kernel.org>; Mon, 26 Aug 2024 03:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724642889; cv=none; b=BumszSfooa8tZyBRE1PZ3vyNu51VeuNZayjVKup4IcfXpi9r4fsWJPZcRUGEOQX5jWPO5e6ZRjL0SFdHdRTNOBgJ1z7Du6/q0wR4YTOuLdZbh8HbbUhWD7u01sNkVKr4CORb/UEulN5ylApabG8GXb+fVuaguLlSpTDBrFTWf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724642889; c=relaxed/simple;
	bh=Ki96ZVKQEHMVYrNSbn3lRJ2LxIez6euUXz+NGjcwLpE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kEyVp7w6OLPvq0LkOZeAolQuZ5x5uHIIW3j4v2CjjE2aIC7XcfcbKY6NkC8mJPFISHdV3bKl64kTFfxDZy59HrRzX6mpamkduOvftvJVlcbwnckOGI1KxydEUdFVE9rGIwKOau7ehCOT3IArrZUVMWjr3HOMoMKx85le9oNj/vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WsbgP6Jz1zpSwh;
	Mon, 26 Aug 2024 11:26:25 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id 621551402E1;
	Mon, 26 Aug 2024 11:28:04 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 26 Aug 2024 11:28:03 +0800
From: Gaosheng Cui <cuigaosheng1@huawei.com>
To: <sfrench@samba.org>, <pc@manguebit.com>, <ronniesahlberg@gmail.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <bharathsm@microsoft.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
Subject: [PATCH -next] cifs: Remove obsoleted declaration for cifs_dir_open
Date: Mon, 26 Aug 2024 11:28:03 +0800
Message-ID: <20240826032803.4017216-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200011.china.huawei.com (7.221.188.251)

The cifs_dir_open() have been removed since
commit 737b758c965a ("[PATCH] cifs: character mapping of special
characters (part 3 of 3)"), and now it is useless, so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 fs/smb/client/cifsfs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index ca2bd204bcc5..61ded59b858f 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -106,7 +106,6 @@ extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file *file, struct vm_area_struct *vma);
 extern int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma);
 extern const struct file_operations cifs_dir_ops;
-extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, struct dir_context *ctx);
 
 /* Functions related to dir entries */
-- 
2.25.1

