Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331B5C0502C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 13:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiIANXa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbiIANXL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 09:23:11 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC575F64
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 06:23:08 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MJMBX3t33zKLGk
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 21:21:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP1 (Coremail) with SMTP id cCh0CgCnei41shBjzFjeAA--.29386S6;
        Thu, 01 Sep 2022 21:23:06 +0800 (CST)
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     linux-cifs@vger.kernel.org, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        tom@talpey.com, linkinjeon@kernel.org, hyc.lee@gmail.com
Subject: [PATCH v4 2/5] ksmbd: Remove the wrong message length check of FSCTL_VALIDATE_NEGOTIATE_INFO
Date:   Thu,  1 Sep 2022 22:24:10 +0800
Message-Id: <20220901142413.3351804-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgCnei41shBjzFjeAA--.29386S6
X-Coremail-Antispam: 1UD129KBjvdXoW7XrW3WF4DGF4xZrWrtryftFb_yoWfuFb_ZF
        yFyrs3W34UJF4fJw4Dta1IvFn8Jw4rGr18WFWIyFWjya4DtryfZw10q393GFy7uwsxWr48
        uwn8ZF1j9rW8ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb9kYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_JrI_JrWl1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
        8IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
        021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
        4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxV
        WUtVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28IcwCFx2IqxVCFs4IE
        7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
        8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8
        JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJV
        WUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUv
        cSsGvfC2KfnxnUUI43ZEXa7IU1rHUDUUUUU==
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

