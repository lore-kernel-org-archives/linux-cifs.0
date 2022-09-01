Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB23C64991
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 13:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiIANXc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiIANXL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 09:23:11 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18246404
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 06:23:07 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MJMBX0frczKKdt
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 21:21:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP1 (Coremail) with SMTP id cCh0CgCnei41shBjzFjeAA--.29386S5;
        Thu, 01 Sep 2022 21:23:06 +0800 (CST)
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     linux-cifs@vger.kernel.org, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        tom@talpey.com, linkinjeon@kernel.org, hyc.lee@gmail.com
Subject: [PATCH v4 1/5] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
Date:   Thu,  1 Sep 2022 22:24:09 +0800
Message-Id: <20220901142413.3351804-2-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgCnei41shBjzFjeAA--.29386S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW8tr47GF13tryDAw4fKrg_yoW8Gr4xpr
        nagry8GFZ3Xry8Cw1UC3Wkuas5Kwn5WF129r4qkw13J3WFvFn0gF1v93s5W3yrKayFkayj
        qr42va45twn0yaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUmmb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r106r1rM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
        0_Jw0_GFyl42xK82IYc2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC
        6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
        C2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_
        Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr
        0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1U
        YxBIdaVFxhVjvjDU0xZFpf9x07jn5rcUUUUU=
Sender: zhangxiaoxu@huaweicloud.com
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
extend the dialects from 3 to 4, but forget to decrease the extended
length when specific the dialect, then the message length is larger
than expected.

This maybe leak some info through network because not initialize the
message body.

After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
reduced from 28 bytes to 26 bytes.

Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 128e44e57528..37f422eb3876 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1167,9 +1167,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 		pneg_inbuf->Dialects[0] =
 			cpu_to_le16(server->vals->protocol_id);
 		pneg_inbuf->DialectCount = cpu_to_le16(1);
-		/* structure is big enough for 3 dialects, sending only 1 */
+		/* structure is big enough for 4 dialects, sending only 1 */
 		inbuflen = sizeof(*pneg_inbuf) -
-				sizeof(pneg_inbuf->Dialects[0]) * 2;
+				sizeof(pneg_inbuf->Dialects[0]) * 3;
 	}
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
-- 
2.31.1

