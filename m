Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A6DC3DA6B
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 06:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiHaGvy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 02:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiHaGvw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 02:51:52 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB913BFC56
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 23:51:49 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MHZYV4YhkzKFRp
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 14:50:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id Syh0CgAnenP+BA9jfDauAA--.16581S6;
        Wed, 31 Aug 2022 14:51:47 +0800 (CST)
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     linux-cifs@vger.kernel.org, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com
Subject: [PATCH v2 2/3] ksmbd: Remove the wrong message length check of FSCTL_VALIDATE_NEGOTIATE_INFO
Date:   Wed, 31 Aug 2022 15:52:54 +0800
Message-Id: <20220831075255.2667077-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220831075255.2667077-1-zhangxiaoxu5@huawei.com>
References: <20220831075255.2667077-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgAnenP+BA9jfDauAA--.16581S6
X-Coremail-Antispam: 1UD129KBjvdXoW7XrW3WF4DGF4xZrWrtryftFb_yoWfuFb_ZF
        yFyrs3W34UJF4fJw4Dta1IvFn8Jw4rGr18WFWIyFWjya4DtryfZw10q393GFy7uwsxWr48
        uwn8ZF1j9rW8ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfxYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_JrI_JrWl1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
        8IrcIa0xkI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
        021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
        4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij2
        8IcwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j0LvNUUUUU=
Sender: zhangxiaoxu@huaweicloud.com
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The struct validate_negotiate_info_req change from variable-length array
to reguler array, but the message length check is unchanged.

The fsctl_validate_negotiate_info() already check the message length, so
remove it from smb2_ioctl().

Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and move its struct to smbfs_common")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c49f65146ab3..c9f400bbb814 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7640,9 +7640,6 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
-			return -EINVAL;
-
 		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
 			return -EINVAL;
 
-- 
2.31.1

