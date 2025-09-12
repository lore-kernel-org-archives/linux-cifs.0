Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D8C1B043A
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 02:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757643065; cv=none; b=tutNf7HEjvEm3TUPFyjvLYF+6ZMmxAL6a2UEm8Gr40jMKT3/CfA8wIu/rG+E3Bswaeqxk2KpWwxN1uUHcCbJapg4YUzb0tpK8zeUObOdSZ9hD3gGhyX5c/b9VNkPjWr8fMxu3U6Uf0EqMCX4DptQh09oNNNtwVjhwukNzI94pzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757643065; c=relaxed/simple;
	bh=sCOcGj0x9DgQOMDdjTkuzhJUdEC/+77OB22E5+IYdI0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EYcfxqnJR3T+N2qrEEpJdXxM6be/aVqd2i/wWOYnLUXuap9TaWrRJ33ZM1wjlkXyMF078/8coi+fI/MFH7blYdf7Xs3v5rvfyTf/6nHQjUBCv+yGFGTscul5XF44opvf06G3TpoqEvGcYJXCgd5uonBAVSzlPdorSyvkVg4dKJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cNHTX5ZCGzKHMWT
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 09:51:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 23C241A17DC
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 09:51:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnz2eYfMNozBaxCA--.61037S4;
	Fri, 12 Sep 2025 09:51:26 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: sfrench@samba.org,
	gregkh@linuxfoundation.org,
	willy@infradead.org,
	pc@manguebit.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	dhowells@redhat.com,
	linux-cifs@vger.kernel.org,
	stable@kernel.org,
	nspmangalore@gmail.com,
	ematsumiya@suse.de
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH v4] cifs: fix pagecache leak when do writepages
Date: Fri, 12 Sep 2025 09:41:50 +0800
Message-Id: <20250912014150.3057545-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnz2eYfMNozBaxCA--.61037S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCFyxZF4rCFy7JrW5Xw43KFg_yoWrXF4rpF
	W5Krn8Zr4Dtry7WFn7Xan0v3WUK3yUX3y3XFy3Gw17Z3Z8A3WagFW0gw1UKFW3GrZ3XF40
	gF4qyFyvva1qvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0II8E6IAqYI8I648v4I1l
	FIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr4
	1l42xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUr3ku
	UUUUU
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
with this patch. All issue does not occur in the mainline because the
writepages path for CIFS was changed to netfs (commit 3ee1a1fc3981,
titled "cifs: Cut over to using netfslib") as part of a major refactor.
After discussing with the CIFS maintainer, we believe that this single
patch is safer for the stable branch [1].

Steve said:
"""
David and I discussed this today and this patch is MUCH safer than
backporting the later (6.10) netfs changes which would be much larger
and riskier to include (and presumably could affect code outside
cifs.ko as well where this patch is narrowly targeted).

I am fine with this patch.from Yang for 6.6 stable
"""

David said:
"""
Backporting the massive amount of changes to netfslib, fscache, cifs,
afs, 9p, ceph and nfs would kind of diminish the notion that this is a
stable kernel;-).
"""

Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
Cc: stable@kernel.org # v6.6~v6.9
Link: https://lore.kernel.org/all/20250911030120.1076413-1-yangerkun@huawei.com/ [1]
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 fs/smb/client/file.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

v3->v4:
1. delay folio_put after folio_unlock
2. document the reason why we choose this single patch instead of
backport

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 7a2b81fbd9cf..1058066913dd 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2884,17 +2884,21 @@ static ssize_t cifs_write_back_from_locked_folio(struct address_space *mapping,
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
 
@@ -3041,17 +3045,22 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
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
 
@@ -3081,6 +3090,7 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
 out:
 	if (ret > 0)
 		*_start = start + ret;
+	folio_put(folio);
 	return ret;
 }
 
-- 
2.39.2

