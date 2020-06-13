Return-Path: <SRS0=TBB8=72=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4793C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 12:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F522078A
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 12:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fudan.edu.cn header.i=@fudan.edu.cn header.b="huyz4bTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgFMMgB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Jun 2020 08:36:01 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:36236 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbgFMMgB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 13 Jun 2020 08:36:01 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2020 08:35:59 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=yYKEFGQVrzH801SxfuGZN+l0zsAnE+ezwtbbFK7MRMM=; b=h
        uyz4bTpwJgl7Ofp9qbz6jPA4RodOOWcrUs+ZaojGv8a4mzdcUAqs2dmo3kge9PW2
        vcOBH9c3E/IZNeNGr0hYo7y+vBQZhBxw0tMwUfoj248CfzNXwzdDQhZFv+71e4L6
        x23TPQXfgO9yv8RxIJO1C4IuzXRdaIi31TRzTx+FMw=
Received: from localhost.localdomain (unknown [120.229.255.202])
        by app1 (Coremail) with SMTP id XAUFCgD3VhA+xuRe4KUYAA--.20537S3;
        Sat, 13 Jun 2020 20:27:44 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] cifs: Fix cached_fid refcnt leak in open_shroot
Date:   Sat, 13 Jun 2020 20:27:09 +0800
Message-Id: <1592051229-93898-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgD3VhA+xuRe4KUYAA--.20537S3
X-Coremail-Antispam: 1UD129KBjvJXoW7JF4kur1UJF17GF4DGw4fuFg_yoW8JF4rpF
        sxKr47KFZYga4kt34vy39Ygw1FkayDJw1YqF1qqa4UJr43X39YqrsagryDX3y3GFWvyF4Y
        qrsF93s0yF4DCFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUOlksUU
        UUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

open_shroot() invokes kref_get(), which increases the refcount of the
"tcon->crfid" object. When open_shroot() returns not zero, it means the
open operation failed and close_shroot() will not be called to decrement
the refcount of the "tcon->crfid".

The reference counting issue happens in one normal path of
open_shroot(). When the cached root have been opened successfully in a
concurrent process, the function increases the refcount and jump to
"oshr_free" to return. However the current return value "rc" may not
equal to 0, thus the increased refcount will not be balanced outside the
function, causing a refcnt leak.

Fix this issue by setting the value of "rc" to 0 before jumping to
"oshr_free" label.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 fs/cifs/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 736d86b8a910..28553d45604e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -763,6 +763,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 			/* close extra handle outside of crit sec */
 			SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 		}
+		rc = 0;
 		goto oshr_free;
 	}
 
-- 
2.7.4

