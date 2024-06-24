Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDFAC8FF;
	Mon, 24 Jun 2024 04:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719203375; cv=none; b=tjzp73mEJeml6VNH9/IyR6XDvTojl8BoiWkbN/L4QRVXpmMrCwWS/S9t/DkTVndPmnP5Cz2E0wYFEFcrTsbcxiF9LSB6TLBmHm/SWhdz3qOjca8thJDy7vJzf8FPr3TsaFtTbmwCIPvjfFD2HVEHve3ZqeMJJAlost4IZ5Q6sv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719203375; c=relaxed/simple;
	bh=TxfqNasjA0T1bjyTc3f87NCLf1eN+E6zofRo71B+ijA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YaVACULdDq+LVerRBLYLLzo8ROArMYPLHchrEjKdKjdIFZ0Ozy6gg30sPCp9NSXsZyQzdnIkjdNjxq3wl0vAj2fEN5rkCP64wLNEdcEY2KfyKd/3yf9I0dKNOvfyhqzFAb+GnKJj8fDgt+5gLt42EwIde7C8UChgTZ3ZQcw3s9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W6w355wk0z4f3jMC;
	Mon, 24 Jun 2024 12:29:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D06651A0568;
	Mon, 24 Jun 2024 12:29:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP2 (Coremail) with SMTP id Syh0CgAn3oMi9nhm19q2AA--.39098S4;
	Mon, 24 Jun 2024 12:29:28 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org,
	stable-commits@vger.kernel.org
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH 6.6~6.9] cifs: fix pagecache leak when do writepages
Date: Mon, 24 Jun 2024 12:28:15 +0800
Message-Id: <20240624042815.2242201-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAn3oMi9nhm19q2AA--.39098S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCFyxZF4rCFy7JrW5try3twb_yoW5GFWkpr
	Wakrn8Ar4jyr9ruFnxZayqv3WUt3y8XrW3XFy3Gw17Z3Z8Z3WagFW8K34UKFWfGr9xXFWx
	KFs0yFWku3WqqaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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
xfstests over cifs).

Besides, the exist path seem never handle this folio correctly, fix it too
with this patch.

The problem does not exist in mainline since writepages path for cifs
has changed to netfs. It's had to backport all related change, so try fix
this problem with this single patch.

Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 fs/smb/client/file.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9be37d0fe724..0a48d80b3871 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2860,17 +2860,21 @@ static ssize_t cifs_write_back_from_locked_folio(struct address_space *mapping,
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
 
@@ -3017,17 +3021,22 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
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
 
@@ -3057,6 +3066,7 @@ static ssize_t cifs_writepages_begin(struct address_space *mapping,
 out:
 	if (ret > 0)
 		*_start = start + ret;
+	folio_put(folio);
 	return ret;
 }
 
-- 
2.39.2

