Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A26C32771
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 03:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiI1D1V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 23:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiI1D1S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 23:27:18 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EC8AA36A
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 20:27:08 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Mchgx46PszKH86
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 11:25:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP2 (Coremail) with SMTP id Syh0CgDXKXMFvzNjkW4JBg--.8336S4;
        Wed, 28 Sep 2022 11:27:06 +0800 (CST)
From:   Luo Meng <luomeng@huaweicloud.com>
To:     sfrench@samba.org, stable@kernel.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        lsahlber@redhat.com, luomeng12@huawei.com, luomeng@huaweicloud.com
Subject: [PATCH 4.19] Revert "cifs: fix double free race when mount fails in cifs_get_root()"
Date:   Wed, 28 Sep 2022 11:49:07 +0800
Message-Id: <20220928034907.3194114-1-luomeng@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgDXKXMFvzNjkW4JBg--.8336S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZry8uFy5XFyDJF1DtFyxXwb_yoWfXwb_ua
        97Xr9rur4Iyr40y3WjyrWYqry0qF1IkFWfCr43Cr1ayry3Grs5G39F93s3Ja9xXws8CrW8
        uF1kXr1Uur1rCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbz8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

This reverts commit 2fe0e281f7ad0a62259649764228227dd6b2561d.

Commit 2fe0e281f7ad (cifs: fix double free race when mount fails
in cifs_get_root()) fixes a double. However there is no such
issue on 4.19 because it will return after cifs_cleanup_volume_info().

Since merge this patch, cifs_cleanup_volume_info() is skipped, leading
to a memory leak.

Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 fs/cifs/cifsfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 52b1524b40cd..7dce6d1fa50b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -779,7 +779,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 out_super:
 	deactivate_locked_super(sb);
-	return root;
 out:
 	cifs_cleanup_volume_info(volume_info);
 	return root;
-- 
2.31.1

