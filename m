Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1596C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Aug 2021 13:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA326604D7
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Aug 2021 13:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbhHLNWq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Aug 2021 09:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237671AbhHLNVf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Aug 2021 09:21:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3025C00EA84
        for <linux-cifs@vger.kernel.org>; Thu, 12 Aug 2021 06:21:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f5so8241097wrm.13
        for <linux-cifs@vger.kernel.org>; Thu, 12 Aug 2021 06:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=M2hDm2bbAZjHUXfscohHcV4TKuF84LkWtN+JrhEJdyE=;
        b=WFR6c9ttGixhIOn3Ioil3tZKcmr1KFYeLzLazmmbKO8C/um8p3QAj35Uky7hOUj2N+
         BepcQ1tx7TRfOy2v1bYnLM3assVLFs6cjF1k4xxVDGxXKvSkjqKijOsMwh9ahVwMSNB6
         0KQoYzo2zV6giE+wIBlCb2eRI4j3d5YCuE5udTXQis2udu9a/1WGpm0x2dQhcUo7uvFW
         FO5nvBOA7Do1Ml6OnvvoIZAoOqqokjL2RfdnERHaowtl6SfL36qWSAqRbhcZ7mtxEEP+
         0iT6kGpFuX999mASgwzN08ux2sAHa+BVioolfUy9OPu7d3QpsqdCnOWoBgO7FCn/SfvZ
         Ti9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=M2hDm2bbAZjHUXfscohHcV4TKuF84LkWtN+JrhEJdyE=;
        b=ZuhF+sXgMN5+EiSFRElcmgyYpEd0nMp9ZmOpfKroFhZfNjf2xUAreLkHDUX2J0WrRE
         yfhDdL2j87/wXiTxEw4z/1Am2oxNVDsJeVx6U2Ir2Z3ZAbTf7qN1EVKYXZ0oD0/yRLTR
         sJbIMs8nNhuDLCi9gEi+cVrLsZ5heYRky14HATE//zBiP0+H59kh3772o1mh/nji+fGi
         UBR6AYOgnXC4KxPd8uw1uJphGDcXLeKT+TeEEk4TEcPSsBjpFs0fq+T+5tVQszsEZOoB
         FRKAmVu9RwqiJ7vXAhixpX8HCfFcfaeEs20y/hSEqx9NKkEBqL6l+CA9FSD9lQve5KYV
         k8UA==
X-Gm-Message-State: AOAM530Ho1ZoYzszF4Jqu7fWZ8Cq9uy07+UxMIHmpDsBWL7pn9A3SyZt
        SsvCQyUCHJlQIZ30lDayCgcV/7dspXgKeIPoEtqKTxE1XN0MNQ==
X-Google-Smtp-Source: ABdhPJxuHQsJ/8CycQj30W5hWxHtSx2D1d4kXEQGLtsHSiibkyK/CvbSRMmJr9F4sn29YhDjfsLBjOmKqczrtJr82jU=
X-Received: by 2002:a5d:50cd:: with SMTP id f13mr2906376wrt.68.1628774461981;
 Thu, 12 Aug 2021 06:21:01 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 12 Aug 2021 08:20:51 -0500
Message-ID: <CAH2r5muan8hTn6Wn2NGgPM3NP5MQ_nd4HU6D7ofLgJk9vsb6ag@mail.gmail.com>
Subject: [PATCH v2][CIFS] avoid signed integer overflow in calculating blocks
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding fix for one more place where the same error can occur

xfstest generic/525 can generate the following warning:

 UBSAN: signed-integer-overflow in fs/cifs/file.c:2644:31
 9223372036854775807 + 511 cannot be represented in type 'long long int'

 Call Trace:
  dump_stack+0x8d/0xb5
  ubsan_epilogue+0x5/0x50
  handle_overflow+0xa3/0xb0
  cifs_write_end+0x424/0x440 [cifs]
  generic_perform_write+0xef/0x190

due to overflowing loff_t (a signed 64 bit) when it is rounded up
to calculate number of 512 byte blocks in a file in two places.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/file.c  | 3 ++-
 fs/cifs/inode.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0166f39f1888..3cc17871471a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2641,7 +2641,8 @@ static int cifs_write_end(struct file *file,
struct address_space *mapping,
  spin_lock(&inode->i_lock);
  if (pos > inode->i_size) {
  i_size_write(inode, pos);
- inode->i_blocks = (512 - 1 + pos) >> 9;
+ /* round up to block boundary, avoid overflow loff_t */
+ inode->i_blocks = ((__u64)pos + (512 - 1)) >> 9;
  }
  spin_unlock(&inode->i_lock);
  }
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 65f8a70cece3..f1dbcbc79abb 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2631,7 +2631,7 @@ cifs_set_file_size(struct inode *inode, struct
iattr *attrs,
  * this is best estimate we have for blocks allocated for a file
  * Number of blocks must be rounded up so size 1 is not 0 blocks
  */
- inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
+ inode->i_blocks = ((__u64)attrs->ia_size + (512 - 1)) >> 9;

  /*
  * The man page of truncate says if the size changed,
-- 
Thanks,

Steve
