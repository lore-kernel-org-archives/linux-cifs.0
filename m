Return-Path: <SRS0=zOxz=T7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BC8C04AB6
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 17:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BEFB26D79
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 17:55:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uwIXtfnd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfEaRzd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 31 May 2019 13:55:33 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:36664 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfEaRzd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 31 May 2019 13:55:33 -0400
Received: by mail-pg1-f170.google.com with SMTP id a3so4450669pgb.3;
        Fri, 31 May 2019 10:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=HxibF4wEOxGDEZRF+k8HwRST1Ib/tNaxCfHf53i+6jw=;
        b=uwIXtfnd+aiBmh/awwYxMoV6oVCSvlOz5evwQiDab2LMKz+zpK7Hpxfx53bt1SDoJ8
         EoG9A3wnnpW9Z2I9St8V+7G1MEF5uQjV5zcsUZCu9qgTQxuwKS1FLDfcT4BO56XEGmHI
         FSCsFT+g9EQpM2HeULvFK5ZRzUYylbYoTHLsRz3zpscIKhOHTkILf9/XxqIvOvYmqtf4
         wdGtZmcxiCBVuei2gBdOycP9h7KIKRacMM+RfIlaUa8A4rK9UPUOTQxB/HfN26aCSM5N
         ZQEpbJHe75bDn2BdTPTdrha3oDjgVXGHGufesalGkzqzfwnpOsuaKFhO80BRWsieM2ee
         40AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=HxibF4wEOxGDEZRF+k8HwRST1Ib/tNaxCfHf53i+6jw=;
        b=N580krsmMuNlnTBxY674+FziWZJFSHG+6o71Vjn7az5tctur5Ehe6didalKYArNZO5
         pyWmUKUcOHEnpG2hWLB0Q52wJKOIcazyC4s+ODcyRF6QRZXivCXxEIqqjNUF4HOT0Y2Z
         WVmSIHxLYPMjDiGgzUMCR2FE43Ji2AqZPgV93vrDoWiMxnF3J7lD1XBRU8PvKLme+awH
         B+1EyW4DcPwC2wL/FeLaPdr6RvBYoC3AAKA1byWJSjVLuR6tQXwD+dq2jVTCINNHReLt
         9P+aPWQEGreYErAtzu/KcrVaIICXTEHrBaTV4FA8okLH308KHklbrwGiuHwPwujZk+Gh
         3g2w==
X-Gm-Message-State: APjAAAVM6fFHpQE6cW2ErYRmepM2MPjg6XY4Jd8HAZ6JlRy+HdTiRY1Z
        9HppNfyNzJZj2KSvmhJTqJAGS3pSPFzSpZX/1z2Erpmk
X-Google-Smtp-Source: APXvYqxGlpGUpt3dDNsUjsYojSaK47xnsF2CGVbiJyPdDAOBhAy029Qd3t/3MoyQCV4zP5kbMCCRpdQoIvYckZQD1eY=
X-Received: by 2002:a17:90a:240c:: with SMTP id h12mr11258789pje.12.1559325332100;
 Fri, 31 May 2019 10:55:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 31 May 2019 12:55:21 -0500
Message-ID: <CAH2r5ms=pUiZQPmX_-AoUceAWgr4Y5RwrkLC0o8dyfcMSKpuCQ@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
cd6c84d8f0cdc911df435bb075ba22ce3c605b07:

  Linux 5.2-rc2 (2019-05-26 16:49:19 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v5.2-rc2-smb3-fixes

for you to fetch changes up to 31fad7d41e73731f05b8053d17078638cf850fa6:

  CIFS: cifs_read_allocate_pages: don't iterate through whole page
array on ENOMEM (2019-05-29 14:02:11 -0500)

----------------------------------------------------------------
4 small smb3 fixes, two for stable

----------------------------------------------------------------
Colin Ian King (1):
      cifs: fix memory leak of pneg_inbuf on -EOPNOTSUPP ioctl case

Gen Zhang (1):
      dfs_cache: fix a wrong use of kfree in flush_cache_ent()

Murphy Zhou (1):
      fs/cifs/smb2pdu.c: fix buffer free in SMB2_ioctl_free

Roberto Bergantinos Corpas (1):
      CIFS: cifs_read_allocate_pages: don't iterate through whole page
array on ENOMEM

 fs/cifs/dfs_cache.c | 4 ++--
 fs/cifs/file.c      | 4 +++-
 fs/cifs/smb2pdu.c   | 9 ++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)


-- 
Thanks,

Steve
