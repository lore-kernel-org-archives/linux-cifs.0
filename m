Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFCCECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 06:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiHaGvx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 02:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHaGvw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 02:51:52 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EA3BFC5A
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 23:51:50 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MHZYW020dzKLc5
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 14:50:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id Syh0CgAnenP+BA9jfDauAA--.16581S7;
        Wed, 31 Aug 2022 14:51:47 +0800 (CST)
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     linux-cifs@vger.kernel.org, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com
Subject: [PATCH v2 3/3] ksmbd: Fix wrong return value in smb2_ioctl() when wrong out_buf_len
Date:   Wed, 31 Aug 2022 15:52:55 +0800
Message-Id: <20220831075255.2667077-4-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220831075255.2667077-1-zhangxiaoxu5@huawei.com>
References: <20220831075255.2667077-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgAnenP+BA9jfDauAA--.16581S7
X-Coremail-Antispam: 1UD129KBjvdXoW7XrW3ZryDGryUtr4xWFWxWFg_yoWfuFX_Xa
        9Yvrs5W34UJF4rJw4Dt3W0vF95Jw4rJw1xWayxtFW5Ja9rJrnavw1kXa93WFyUuw45WrWk
        Cwn8u3W7ZrW2gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfxYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_JrI_JrWl1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM2
        8IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
        021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
        4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij2
        8IcwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UGtC7UUUUU=
Sender: zhangxiaoxu@huaweicloud.com
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When the out_buf_len is less than the size of struct
validate_negotiate_info_rsp, should goto out to initialize the
status in the response header.

Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ksmbd/smb2pdu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c9f400bbb814..7da0ec466887 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7640,8 +7640,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
-			return -EINVAL;
+		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		ret = fsctl_validate_negotiate_info(conn,
 			(struct validate_negotiate_info_req *)&req->Buffer[0],
-- 
2.31.1

