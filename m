Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC7F4AEE2
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 03:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757560257; cv=none; b=i3bFJGGDKkwUsGqIIJGH6j0j86Yt+6yjEGKJI4kN1mkQrZYDwcs1taZ8qd6UOW6F8uY8DAOHmjpk1vDh8b6d7rh07dqOPKT8+df6bT8MOboll3B5P0Cx+4G5ZQV3+4eWSVvOtrlsF0FLfHeozswOyfTf1ABFYOU6UmO981GOfEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757560257; c=relaxed/simple;
	bh=Mpk22/djZ+eW5GSMdjaiBDTuU9H890f0Y751ADBHuUE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BqwWJhKW2FZaek2RxAxr77nLg2fttM8BJyEbbQ8PUyfAAMdDaQBnDf6GXvd+9uWtCx7k4h+DepgdudHln2NYfIjXVOohyh7vGRQb+/vK1QFtFF78mr7rlgWcCF8/mVOFMzp2evfxIic5vmFxjB7XyXQ1032Fkop/VDuYQ5jpABo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cMjHd1LS9zYQvF2
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 11:10:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AAE3C1A199C
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 11:10:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCX4o62PcJoMy9rCA--.9268S4;
	Thu, 11 Sep 2025 11:10:51 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: sfrench@samba.org,
	gregkh@linuxfoundation.org,
	pc@manguebit.com,
	lsahlber@redhat.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	dhowells@redhat.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	stable@kernel.org,
	nspmangalore@gmail.com,
	ematsumiya@suse.de
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH v3] cifs: fix pagecache leak when do writepages
Date: Thu, 11 Sep 2025 11:01:20 +0800
Message-Id: <20250911030120.1076413-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX4o62PcJoMy9rCA--.9268S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCFyxZF4rCFy7JrW5try3twb_yoW5ZF45pF
	WYkrn0vr4Utr17uFnxZa1qv3WUt3y8XrW5XFy3Ww12v3W5A3W2gFWrK34UKFW3Gr95Xa1f
	KFs0yF9Yv3WqvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
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
with this patch.

The problem does not exist in mainline since writepages path for cifs
has changed to netfs(3ee1a1fc3981 ("cifs: Cut over to using netfslib")).
It's had to backport all related change, so try fix this problem with this
single patch.

Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
Cc: stable@kernel.org # v6.6~v6.9
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 fs/smb/client/file.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

v2->v3:

rebase on top 6.6 stable since some new patches has been backported

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 7a2b81fbd9cf..f97478626e9d 100644
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
 
@@ -3041,16 +3045,21 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
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
+		folio_put(folio);
 		folio_unlock(folio);
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

