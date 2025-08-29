Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21245225D6;
	Fri, 29 Aug 2025 01:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756429724; cv=none; b=lXA11vAqZ4LM+/4lNqZ2ux8vxrOB+50LN85wHpQ3idm4G9HZMfmgWUEITqREDfaFrtr5XhEnr2hxj6QY34vQKo+WBx/xDFaG5CCoWlvcyt7gMeOVC0pEqIfTCMIZfhHSO5skaFFj3dqRfFcLM1ktBVFohhCnw1uYqRu/RmeLNlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756429724; c=relaxed/simple;
	bh=t1N+cGXK8TxUmeMit36rVyZW5i9iQ5u2XIRwWlnSd6k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cU7mcpFgmR/Ki5xVgtUeky/KKic9ai6cuLaA7yWySHQm21PhbmWXp/IRX4HhUd8MvqQkHpzS4m8QqvCcsiTMTohZjmIen0DTQojkvSFVC5FBZXMlC9y8OcD9uSrhEC7U/JG7FGSO2NMgss4ubnG5EM/1iWoGDUYsx1FaZp5hkbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cCgBc0vsDzKHMhr;
	Fri, 29 Aug 2025 09:08:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CDF101A0D6B;
	Fri, 29 Aug 2025 09:08:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncY2V_bBoCBiUAg--.37780S4;
	Fri, 29 Aug 2025 09:08:39 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] smb: client: Fix NULL pointer dereference in cifs_debug_dirs_proc_show()
Date: Fri, 29 Aug 2025 08:59:59 +0800
Message-Id: <20250829005959.2205950-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncY2V_bBoCBiUAg--.37780S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw17KrWfAF4xJryruF1kGrg_yoW8Xw4rpa
	15Cry7Kr1rJw47Zw4DtayDuw1ruFWqqa1j9r9xCa1fJw47A3yIgFn7K34agr1fuFWrt3WY
	yF4DtrWjyFWDAwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

Reading /proc/fs/cifs/open_dirs may hit a NULL dereference when
tcon->cfids is NULL.

Add NULL check before accessing cfids to prevent the crash.

Reproduction:
- Mount CIFS share
- cat /proc/fs/cifs/open_dirs

Fixes: 844e5c0eb176 ("smb3 client: add way to show directory leases for improved debugging")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/cifs_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index beb4f18f05ef..edb2e7f7fc23 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -302,10 +302,12 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 		list_for_each(tmp, &server->smb_ses_list) {
 			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
 			list_for_each(tmp1, &ses->tcon_list) {
 				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 				cfids = tcon->cfids;
+				if (!cfids)
+					continue;
 				spin_lock(&cfids->cfid_list_lock); /* check lock ordering */
 				seq_printf(m, "Num entries: %d\n", cfids->num_entries);
 				list_for_each_entry(cfid, &cfids->entries, entry) {
 					seq_printf(m, "0x%x 0x%llx 0x%llx     %s",
 						tcon->tid,
@@ -317,12 +319,10 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 					if (cfid->dirents.is_valid)
 						seq_printf(m, ", valid dirents");
 					seq_printf(m, "\n");
 				}
 				spin_unlock(&cfids->cfid_list_lock);
-
-
 			}
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 	seq_putc(m, '\n');
-- 
2.39.2

