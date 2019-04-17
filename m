Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9145AC282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 19:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A35520651
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 19:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TeUNVa81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733244AbfDQTki (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:40:38 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40854 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732958AbfDQTki (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Apr 2019 15:40:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so12501049plr.7
        for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2019 12:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FPc9o1VZ1fz2fL5ntZYjeZh+D0FODwyTyUnJ3vl+M+c=;
        b=TeUNVa81g0hkpLb2zCNZnw+sIyytWdOb4fpa5TCF/80/HCkXl1yknwhF0haGBwIAck
         SWCd2enTfGFPXO8Q/K8ZmGylVtIoonVGMqCQQd3HThDU8CYb35qZc/J1eN6cIlOgi7dV
         /2H8D597Nh136jTHaktzSZz9//K+QPmxP52eyNCA5VZiiVqjeKbjIUlTCvDx2Dbecnmd
         yyr7u+uaIr88aDU4ick5ZrypWd2mhU2CuXyPzjhLHpKDgr4rCNHkkLwcuiPIKI4DXguc
         kfNjR3F8Cx9drsO7BB/h5iWId2Vn1L0bam/hvsMNslx/hqXaMNYmecbQvEcGDnVqablv
         lmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FPc9o1VZ1fz2fL5ntZYjeZh+D0FODwyTyUnJ3vl+M+c=;
        b=l0uCf4WuKNzhiDMJ8+kP+Q8di/pDquMWux2lGKtN8jxH//Q8JAOCCECzJK5fFPROec
         YXTZT5CiFz7X/LeFQhX+GPUmguVjFKqd9ZQQ2VeMyO5SRzqIIdqw0unJ6r8BKeTFbZk7
         SG/bhE5/40VUwoXqZWwTvlDyQGsNrt+C5/FxkNIvds47XpEsy4puCLM6dqgyHAeM3iJX
         fHF+l8cEvg5eY93zW3fN90JTm4AAg/ldRq21oJ3363E/K7R2RjPnG1DGDTJ8yhIlu4eK
         tV290lMLT4VEPFovpN13BJ6ZpW1hw7+oOT0WkZHuxpnxYl1B1O9qlHHmybz7xkd9p/Fr
         8swg==
X-Gm-Message-State: APjAAAWCaDIMxlHg/hzUscesA0Jd+Pk9viSrxUS5SZoZJNBXqLT92mFr
        2VG4Qk2QrAIu8tOwNPsoPhv1fGtO6up/j8kxago=
X-Google-Smtp-Source: APXvYqzy0Fjd2PtpNFCGyOArjhOhhroqmroD4X2a9YHreTTfy6a2Dd+5Dfff86Blh3eZNw5/PXFSQXlpKQA51YjVRGE=
X-Received: by 2002:a17:902:2ae6:: with SMTP id j93mr73856346plb.18.1555530037703;
 Wed, 17 Apr 2019 12:40:37 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 Apr 2019 14:40:26 -0500
Message-ID: <CAH2r5mtuPCiGMV+oFMxDXzP_ior8iYm_ZQHQvS1+CyNN4dkRRw@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
618d919cae2fcaadc752f27ddac8b939da8b441a:

  Merge tag 'libnvdimm-fixes-5.1-rc6' of
git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
(2019-04-15 16:48:51 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc5-smb3-fixes

for you to fetch changes up to b98749cac4a695f084a5ff076f4510b23e353ecd:

  CIFS: keep FileInfo handle live during oplock break (2019-04-16
09:38:38 -0500)

----------------------------------------------------------------
Five small SMB3 fixes, all also for stable: an important fix for an
oplock (lease) bug, a handle leak fix, and fixes for 3 bugs spotted by
KASAN

----------------------------------------------------------------
Aurelien Aptel (1):
      CIFS: keep FileInfo handle live during oplock break

Ronnie Sahlberg (1):
      cifs: fix handle leak in smb2_query_symlink()

ZhangXiaoxu (3):
      cifs: Fix use-after-free in SMB2_write
      cifs: Fix use-after-free in SMB2_read
      cifs: Fix lease buffer length error

 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/file.c     | 30 +++++++++++++++++++++++++-----
 fs/cifs/misc.c     | 25 +++++++++++++++++++++++--
 fs/cifs/smb2misc.c |  6 +++---
 fs/cifs/smb2ops.c  |  2 ++
 fs/cifs/smb2pdu.c  | 11 +++++++----
 6 files changed, 62 insertions(+), 14 deletions(-)


-- 
Thanks,

Steve
