Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB06C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jan 2022 14:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiACOul (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jan 2022 09:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiACOul (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jan 2022 09:50:41 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01B0C061761
        for <linux-cifs@vger.kernel.org>; Mon,  3 Jan 2022 06:50:40 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l4so21553303wmq.3
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jan 2022 06:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=re67WGqWcG/HXr1cYssMtIWoyahh9zUkXGzeD4T8vyo=;
        b=HByRcjvB1fNXdy8FsnFigwcbjfoqq4/8BiI9wi9GHn9dwFOpW1ixFtvGKL/bM4PynW
         xTQKFs/IKcUQ/IJO01WMG0JUmwYPwxhgtTF6CGjisF/HJbgfTCYwXKLr9sIs7LzmXV0A
         thJjA5/rVZNOiTgyesmu1r/ZiiwgCr3hCFVwkdPO7dANDicQCyqG1Z0wndbWEbeWpEme
         ZeD4psZWYkdWGG+e0nrfjdlqYaEJsdNAmkEnE4m5RCvvznc+kEfvkxWuDV1Ljztf1HEP
         5joY+geaLVYSpSxslgSaTtP6t1jp5G55BjTGE8ceC/7o535uWX5HMMZEfeG4x4MYPNF6
         bpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=re67WGqWcG/HXr1cYssMtIWoyahh9zUkXGzeD4T8vyo=;
        b=66nrQ8NmSeZDGjR02jl+6oamMmSbNIU0Wq8mDZ0qISE/8FW1YC0S11KlubzHUbHzLE
         FvaT3ZYZY1ZF0FFuN/D6Ex9asI+3yTfVzldA9OJtlTFESQmZwQgUFInRvqGrC7dkUiTJ
         pgT1HldtRMOv20Fx4bnX8wAlS2R++xWbqXbnpTfbWBQgjNooq1bIhzFr4f4VN3Zi7Zsa
         fh8ofq2vJmZQZWeWXUAFKa4jGQEVr0z6yilLt5rVA9OJLj0hijAd8WJ5KPDI0ifkg7O+
         YdFPa5r26LSUObddU/ot1KAHnV+grE1FND6M5BjvA31dKNGCEN7Q2c2YjIsB58eR3xkR
         RgnA==
X-Gm-Message-State: AOAM533Qwm5MXAm+6mGFXD7VG2JT1XffFUG9pZCjRiw7zgchDyDm0Gt/
        8fS1DIX9wFPnP/x+I0QMki5/CK5P7QA=
X-Google-Smtp-Source: ABdhPJyNTsnV82RtboxGSY3V+cP1PPdpDd2YI3hrZdtBdSGgEhj55429D0408/U8+XA3YeQQqsILPg==
X-Received: by 2002:a7b:cd82:: with SMTP id y2mr11095691wmj.99.1641221439212;
        Mon, 03 Jan 2022 06:50:39 -0800 (PST)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id i15sm25787423wrf.6.2022.01.03.06.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 06:50:38 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Steve French <smfrench@gmail.com>,
        Boris Protopopov <pboris@amazon.com>
Cc:     Pavel Shilovsky <pshilovsky@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: fix set of group SID via NTSD xattrs
Date:   Mon,  3 Jan 2022 16:50:25 +0200
Message-Id: <20220103145025.3867146-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

'setcifsacl -g <SID>' silently fails to set the group SID on server.

Actually, the bug existed since commit 438471b67963 ("CIFS: Add support
for setting owner info, dos attributes, and create time"), but this fix
will not apply cleanly to kernel versions <= v5.10.

Fixes: a9352ee926eb ("SMB3: Add support for getting and setting SACLs")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Boris,

I am a little confused from the comments in the code an emails.
In this thread [1] you wrote that you tested "setting/getting the owner,
DACL, and SACL...".

Does it mean that you did not test setting group SID?

It is also confusing that comments in the code says /* owner plus DACL */
and /* owner/DACL/SACL */.
Does it mean that setting group SID is not supposed to be supported?
Or was this just an oversight?

Anyway, with this patch, setcifsacl -g <SID> works as expected,
at least when the server is samba.

Thanks,
Amir.


[1] https://lore.kernel.org/linux-cifs/CAHhKpQ7PwgDysS3nUAA0ALLdMZqnzG6q6wL1tmn3aqOPwZbyyg@mail.gmail.com/

 fs/cifs/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 7d8b72d67c80..9d486fbbfbbd 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -175,11 +175,13 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 				switch (handler->flags) {
 				case XATTR_CIFS_NTSD_FULL:
 					aclflags = (CIFS_ACL_OWNER |
+						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL |
 						    CIFS_ACL_SACL);
 					break;
 				case XATTR_CIFS_NTSD:
 					aclflags = (CIFS_ACL_OWNER |
+						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL);
 					break;
 				case XATTR_CIFS_ACL:
-- 
2.25.1

