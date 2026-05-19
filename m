Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0772E3F65E5;
	Tue, 19 May 2026 09:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779182594; cv=none; b=cGBM8LKXqCW7YK7WoaVEYtc/mkcPugMnVkOwLJCXmmlUKeOIW8QCWca7K1If1o2rsD6bbrxxTkLuNHwZWpfT4ceVgJpc/b2CddJ4BqS9WEKAPebUizxVEK95yrX+7VsrFRIpVkhf+fFm/Hlgoh1zFIvzphBA/wm77rqiAHHYgSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779182594; c=relaxed/simple;
	bh=ak4KSyBgASEWsay7P8T2fd0WG/KqGX9nrURn4e0SbDQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oZS8qw7jbloplLUV1oZWMexCh2edpx3FEJJmnprZL3ZV0+b9L86uBX/KR4+IAvMypOyFB49hE4IE0JGBsnac9e0CCrh46kdxOqBXSg0ZXH3EB+pXJuarUlsiCBVGw4UYUpU+q6rrkip2ixg95QV9QBCF2tSvdHB7ZWXEcdI8zPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=TXwVue/Y; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="TXwVue/Y"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kgNcLKaphyuxZHt3JeSiaeyiurdATm/ZpPjF3s/vFjU=;
	b=TXwVue/YOxPtBF3JYF7PbeVnFRfMG2dQhBuzWXDLaFlZHiqELhutU0dovIoOE9YRXNzpRNPk/
	P5nMKyNVvyRw5C0vJz95rYxL15Iudu1qAxqtRUPzvL32xImFxlXnlUviEsFl+sFOgoeqqceIvGN
	rhs7GHXpBpKL982SleQXYqI=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gKTXy6VWczcZyP;
	Tue, 19 May 2026 17:15:30 +0800 (CST)
Received: from kwepemk500005.china.huawei.com (unknown [7.202.194.90])
	by mail.maildlp.com (Postfix) with ESMTPS id 20A9A40537;
	Tue, 19 May 2026 17:23:03 +0800 (CST)
Received: from huawei.com (10.50.85.155) by kwepemk500005.china.huawei.com
 (7.202.194.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 May
 2026 17:23:02 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <sfrench@samba.org>, <sprasad@microsoft.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <wozizhi@huawei.com>
Subject: [PATCH] cifs: Fix busy dentry used after unmounting
Date: Tue, 19 May 2026 17:18:05 +0800
Message-ID: <20260519091805.220902-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk500005.china.huawei.com (7.202.194.90)

Since commit 340cea84f691c ("cifs: open files should not hold ref on
superblock"), cifs file only holds the dentry ref_cnt, the cifs file
close work(cfile->deferred) could be executed after unmounting, which
will trigger a warning in generic_shutdown_super:
 BUG: Dentry 00000000a14a6845{i=c,n=file}  still in use (1) [unmount of
 cifs cifs]

The detailed processs is:
   process A           process B           kworker
 fd = open(PATH)
  vfs_open
   file->__f_path = *path // dentry->d_lockref.count = 1
   cifs_open
    cifs_new_fileinfo
     cfile->dentry = dget(dentry) // dentry->d_lockref.count = 2
 close(fd)
  __fput
  cifs_close
   queue_delayed_work(deferredclose_wq, cfile->deferred)
  dput(dentry) // dentry->d_lockref.count = 1
			                 smb2_deferred_work_close
					  _cifsFileInfo_put
					   list_del(&cifs_file->flist)
                    umount
		     cleanup_mnt
		      deactivate_super
		       cifs_kill_sb
		        cifs_close_all_deferred_files_sb
			 cifs_close_all_deferred_files
			  // cannot find cfile, skip _cifsFileInfo_put
			kill_anon_super
			 generic_shutdown_super
			  shrink_dcache_for_umount
			   umount_check
			    WARN ! // dentry->d_lockref.count = 1
					   cifsFileInfo_put_final
					    dput(cifs_file->dentry)
		                            // dentry->d_lockref.count = 0

Fix it by flushing 'deferredclose_wq' before calling kill_anon_super.

Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=221548.

Fixes: 340cea84f691c ("cifs: open files should not hold ref on superblock")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 fs/smb/client/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index f557eb7875c7..ce23924f01b3 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -306,6 +306,8 @@ static void cifs_kill_sb(struct super_block *sb)
 
 		/* Wait for all pending oplock breaks to complete */
 		flush_workqueue(cifsoplockd_wq);
+		/* Wait for all opened files to release */
+		flush_workqueue(deferredclose_wq);
 
 		/* finally release root dentry */
 		dput(cifs_sb->root);
-- 
2.52.0

