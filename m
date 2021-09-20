Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BE8C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 04:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B0C060F51
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 04:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhITELD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 00:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhITELC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 00:11:02 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03769C061574
        for <linux-cifs@vger.kernel.org>; Sun, 19 Sep 2021 21:09:35 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i4so62232946lfv.4
        for <linux-cifs@vger.kernel.org>; Sun, 19 Sep 2021 21:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=p532/adSxRHAL6ZzEggGyPO/esryERHEY0XYdMTS7eY=;
        b=gEolQdyoesTBdADjpwn9Q6nV0df80m9ra9d3G5YApa494H8yAjM/rP+4Ck9vy12qD4
         FVHlLl3kO1lXWi67jwaadLM6HFgrCzr8gXO4fFhzPg0gyquLXc7OVd5jhOKO9FLSyNhB
         CH9O6nGuu7pb+pUTmQPJ7dYkm2ZqnCsbszsTo1kKrwFLsTdZy1csYLiGkGryJrUtrsy2
         damLbBPaOTny5yODVMs9p8jyem3pgHSqDwxGmJrLxiiijOFm0fHnaQN/IA0iUG6SmrWW
         tm3vBWhx5CbC78HbXcGI2OM2aI1LSuuL0gBD1nK8hm3SfJ3dAKA7BAAQBTBLqzUh4IrO
         ZtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=p532/adSxRHAL6ZzEggGyPO/esryERHEY0XYdMTS7eY=;
        b=d0YAwdr8jCkhOZl4JV9x+he5vm1vbRFLNxVc2wK6NHRZlKgHuiJvTNFJzCltLeCO2/
         n4Pyz2kgNbDGXKf89cZE3VyraPtdgz9Wdr8m3HH+9oSmJ68PJB5HiDkbITltpmmm5dYP
         PNJiBxHm7EUSX1MZyZEMihx2KMQyXMxvyRui0eVJaz04WINfZsUF2+Syo0/PqQFtgfhA
         TdjyaVB8Wy0riKtkt2ncLapDTfUqTntdGsrKVgimxBHm6q8H+VYb4c2Mh6qCGCPuNkmZ
         VaHA9HI9Iwf1avSlbnFOCy/dCFB2C5WuM8gz/uSK9TujLG/qtbdeJRFflDVYkz0c74x2
         rlag==
X-Gm-Message-State: AOAM5302r+i7RvZSplLSPQytQxacrxAvXGuMCVA3q051F6PmXNmieljk
        ZInR6UtZKpNs25fxJRj07iCJsSZO2y3xeiiYpaMwNVJXras=
X-Google-Smtp-Source: ABdhPJzmcknlB6r1hUvF4J8/f5nG5+WoQT7orEGKdXBMdx+2P8UYQ31krauiVBciPB9ipkuaCDK0aWay6kGsgFJvAB8=
X-Received: by 2002:a2e:4619:: with SMTP id t25mr14193067lja.398.1632110973241;
 Sun, 19 Sep 2021 21:09:33 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 19 Sep 2021 23:09:22 -0500
Message-ID: <CAH2r5mtxB9ZmaZggfr871Et76A_CQQkS3dREF_aHQYLgafbrPg@mail.gmail.com>
Subject: ksmbd regression tests pass with all 6 security fixes
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With current linux-next for ksmbd (7 patches, including the 6
security/buffer-overflow/symlink/path-parsing ones), regression tests
pass including the 4 recently added (additional testing and review are
welcome)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/68

24f0f4fc5f76 (HEAD -> cifsd-for-next, origin/ksmbd-for-next,
origin/cifsd-for-next) ksmbd: use LOOKUP_NO_SYMLINKS flags for default
lookup
1ec1e6928354 ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
e2cd5c814442 ksmbd: add validation in smb2_ioctl
1adbd33fbf42 ksmbd: add request buffer validation in smb2_set_info
6d56262c3d22 (tag: 5.15-rc1-ksmbd, tag: 5.15-rc1-ksmb3,
origin/smbd-for-next) ksmbd: add validation for
FILE_FULL_EA_INFORMATION of smb2_get_info
f58eae6c5fa8 ksmbd: prevent out of share access
a9b3043de47b ksmbd: transport_rdma: Don't include rwlock.h directly

-- 
Thanks,

Steve
