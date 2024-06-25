Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF1213791C
	for <linux-cifs@vger.kernel.org>; Tue, 25 Jun 2024 03:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287094; cv=none; b=HZ6bK3VO0Qp2IaCtgDOzN0oKDGc1TTyKARwxuQ1ki+GhtqIAK5zT2xh1SFTG77TWNDnjxEe2kL1a2IN7TZjaqFEyXL8ZSjo97nzMsNsrLE2sQbKFgmisE4RFQP9OMGED5HIuaANxFvD4s98RNWTrkvIdyF/ZNcoklenAPR4Q5aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287094; c=relaxed/simple;
	bh=d0JjcCh9SkXDkJiL7vHRU2Ty7/y5ZkslV4tP8PUXPcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mqwgHamopyPkanHABLy1Myu/EjuqfCFcE4N8iEHffnoflGQTyWjw5H8LWZXFf2rP5c1KbxDzxPVApRIkYR6aYgr4+RTehS1/HuxI/YCeaspnXuYQNiTiYkT3icd80NnXO8lzSPLC1wIY7ht95uvlcYtU0m48B1hmrEH8EvOBVaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4W7W116xpYz4f3jRG
	for <linux-cifs@vger.kernel.org>; Tue, 25 Jun 2024 11:44:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id B1ADD1A058E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Jun 2024 11:44:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP2 (Coremail) with SMTP id Syh0CgB34YYqPXpmjiAVAQ--.60179S4;
	Tue, 25 Jun 2024 11:44:48 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	linux-cifs@vger.kernel.org
Cc: stable@kernel.org,
	yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH v2] cifs: fix pagecache leak when do writepages
Date: Tue, 25 Jun 2024 11:43:32 +0800
Message-Id: <20240625034332.750312-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB34YYqPXpmjiAVAQ--.60179S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCFyxZF4rCFy7JrW5try3twb_yoW5Cw1xpF
	W5Krn8Zr4Utr17uFnxXa1qv3WUt3y8XrW3XFy3Gw1av3W5A3WagFW8K34UKFZxGr95XF4x
	KF4qyFZYv3WqvaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0II8E6IAqYI8I648v4I1l
	FIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l42xK82IY64kExVAvwVAq07
	x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAnYwUUUUU=
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

After commit f3dc1bdb6b0b("cifs: Fix writeback data corruption"), the
writepages for cifs will find all folio needed writepage with two phase.
The first folio will be found in cifs_writepages_begin, and the latter
various folios will be found in cifs_extend_writeback.

All those will first get folio, and for normal case, once we set page
writeback and after do really write, we should put the reference, folio
found in cifs_extend_writeback do this with folio_batch_release. But the
folio found in cifs_writepages_begin never get the chance do it. And
every writepages call, we will leak a folio(found this problem while do
xfstests over cifs, the latter show that we will leak about 600M+ every
we run generic/074).

echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
Active(file):      34092 kB
Inactive(file):   176192 kB
./check generic/074 (smb v1)
...
generic/074 50s ...  53s
Ran: generic/074
Passed all 1 tests

echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
Active(file):      35036 kB
Inactive(file):   854708 kB

Besides, the exist path seem never handle this folio correctly, fix it too
with this patch.

The problem does not exist in mainline since writepages path for cifs
has changed to netfs(3ee1a1fc3981 ("cifs: Cut over to using netfslib")).
It's had to backport all related change, so try fix this problem with this
single patch.

Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
Cc: stable@kernel.org # v6.6+
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 fs/smb/client/file.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 7ea8c3cf70f6..058c2be86e97 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2856,17 +2856,21 @@ static ssize_t cifs_write_back_from_locked_folio(struct address_space *mapping,
 	rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile);
 	if (rc) {
 		cifs_dbg(VFS, "No writable handle in writepages rc=%d\n", rc);
+		folio_unlock(folio);
 		goto err_xid;
 	}
 
 	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->wsize,
 					   &wsize, credits);
-	if (rc != 0)
+	if (rc != 0) {
+		folio_unlock(folio);
 		goto err_close;
+	}
 
 	wdata = cifs_writedata_alloc(cifs_writev_complete);
 	if (!wdata) {
 		rc = -ENOMEM;
+		folio_unlock(folio);
 		goto err_uncredit;
 	}
 
@@ -3013,17 +3017,22 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
 lock_again:
 	if (wbc->sync_mode != WB_SYNC_NONE) {
 		ret = folio_lock_killable(folio);
-		if (ret < 0)
+		if (ret < 0) {
+			folio_put(folio);
 			return ret;
+		}
 	} else {
-		if (!folio_trylock(folio))
+		if (!folio_trylock(folio)) {
+			folio_put(folio);
 			goto search_again;
+		}
 	}
 
 	if (folio->mapping != mapping ||
 	    !folio_test_dirty(folio)) {
 		start += folio_size(folio);
 		folio_unlock(folio);
+		folio_put(folio);
 		goto search_again;
 	}
 
@@ -3053,6 +3062,7 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
 out:
 	if (ret > 0)
 		*_start = start + ret;
+	folio_put(folio);
 	return ret;
 }
 
-- 
2.39.2

