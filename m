X-Greylist: delayed 1025 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Dec 2023 06:17:16 PST
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F3BAC;
	Tue, 12 Dec 2023 06:17:16 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4SqKxc45G4z1vnkB;
	Tue, 12 Dec 2023 22:00:04 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 274F91A0190;
	Tue, 12 Dec 2023 22:00:08 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Dec 2023 22:00:07 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <sfrench@samba.org>, <lsahlber@redhat.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH -next] fs: cifs: Fix atime update check
Date: Tue, 12 Dec 2023 21:58:40 +0800
Message-ID: <20231212135840.1462711-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Commit 9b9c5bea0b96 ("cifs: do not return atime less than mtime") indicates
that in cifs, if atime is less than mtime, some apps will break.
Therefore, it introduce a function to compare this two variables in two
places where atime is updated. If atime is less than mtime, update it to
mtime.

However, the patch was handled incorrectly, resulting in atime and mtime
being exactly equal. A previous commit 69738cfdfa70 ("fs: cifs: Fix atime
update check vs mtime") fixed one place and forgot to fix another. Fix it.

Fixes: 9b9c5bea0b96 ("cifs: do not return atime less than mtime")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/smb/client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index cf17e3dd703e..32a8525415d9 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -4671,7 +4671,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	/* we do not want atime to be less than mtime, it broke some apps */
 	atime = inode_set_atime_to_ts(inode, current_time(inode));
 	mtime = inode_get_mtime(inode);
-	if (timespec64_compare(&atime, &mtime))
+	if (timespec64_compare(&atime, &mtime) < 0)
 		inode_set_atime_to_ts(inode, inode_get_mtime(inode));
 
 	if (PAGE_SIZE > rc)
-- 
2.39.2

