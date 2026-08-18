Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E723AD520;
	Tue, 18 Aug 2026 03:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787022786; cv=none; b=Dc9ek5SkGBcKHkqjDek6ffuhMM21tbQIWKdzrDLmEnycm0QiI8strwOyft04ZO+bRPJKhz3ccmjSE/Ag5ySMS2EJYVG2IfwNmwMJGoH59PAD72JOwDRNc1P2Voo55qmi+XTPQGW9uIWikkap+4vCRLHU0NqvF1rCuI57eibvffo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787022786; c=relaxed/simple;
	bh=kSrm3jnjwHQeH5FK5MioTwvyMxg4g6K8+vSMBxmkFUY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iss0Gms+by0kRUIRoXaOPfchoVqPPEzjFWh2XP/qoJ0tOzBj67yyr//qJRwyN8Sc4cpILYGjN2U+vASWpb1MhDQ0n1RLPpyUoULQ63YkceRHL1VQqS96uq7D0NXXSxvnS5HQS3+nR5/e/Hm0xgn5ovLWgNtyDYakK4Y5tBecAXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hPFB43nBWzYQtxD;
	Tue, 18 Aug 2026 11:12:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 2EE0040EE9;
	Tue, 18 Aug 2026 11:12:43 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCnlkWpzYNqvQTjCg--.1760S4;
	Tue, 18 Aug 2026 11:12:42 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangzhaolong@fygo.io,
	mszjaas@qq.com,
	wozizhi@huawei.com
Subject: [PATCH] Revert "cifs: remove all cifs files before kill super"
Date: Tue, 18 Aug 2026 11:06:34 +0800
Message-ID: <20260818030635.3007590-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnlkWpzYNqvQTjCg--.1760S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWrZw4fWF1kGry3GF47XFb_yoW8uw1fpr
	4YkryrWFs5GryUKws8AF1UZa4Svr4qvasxXryfWFn7Gay5ArWIgrZ2kF1UWry3Xws5Zw1F
	grZFga92va48X3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU17KsUUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

This reverts commit 6d9a4aaaa8b2612b5ef9d581e2f286a458b71ee1.

First, directly flushing fileinfo_put_wq in that commit cannot guarantee
that all in-flight I/O has run its cleanup_work on system_dfl_wq and
subsequently called queue_work(fileinfo_put_wq, ...). Flushing only the
latter workqueue may therefore miss puts that have not yet been queued, so
the fix is not reliable in the first place. Moreover, this fix flushes
inside cifs_umount(), which means the busy-dentry warning can still be
triggered when umount_check() is called inside kill_anon_super(), because
kill_anon_super() is executed before cifs_umount().

Second, commit 75f5c412fa86 ("smb: client: fix busy dentry warning on
unmount after DIO") already drains both serverclose_wq and fileinfo_put_wq
in cifs_kill_sb(), before kill_anon_super(). By adding a per-superblock
outstanding-rreq counter, it guarantees that all cleanup_work for this sb
have run, and thus all relevant cfile puts are queued on fileinfo_put_wq
or serverclose_wq.

Third, no path between those drains and cifs_umount() can queue new work
onto either workqueue. In the "cifs_sb->root == NULL" path there are no
file-related workers either, so that case is safe as well.

Therefore the busy-dentry and null-ptr-deref problems cannot arise, and
the flush added by commit 6d9a4aaaa8b2 ("cifs: remove all cifs files before
kill super") is redundant and can be removed.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/smb/client/connect.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ba749ec25a59..f9764f65430e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4001,13 +4001,10 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 		cifs_put_tlink(tlink);
 		spin_lock(&cifs_sb->tlink_tree_lock);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
-	flush_workqueue(serverclose_wq);
-	flush_workqueue(fileinfo_put_wq);
-
 	kfree(cifs_sb->prepath);
 	call_rcu(&cifs_sb->rcu, delayed_free);
 }
 
 int
-- 
2.52.0

