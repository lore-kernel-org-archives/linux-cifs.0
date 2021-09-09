Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F61C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 21:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E251C6103E
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhIIWAd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 18:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbhIIWAd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Sep 2021 18:00:33 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C9DC061574;
        Thu,  9 Sep 2021 14:59:23 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f18so6537879lfk.12;
        Thu, 09 Sep 2021 14:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ytn08IVw9vUcm1cHNUL7Zrfn0a9kpANuzaGcQ9Gn9lo=;
        b=jUDD7lQFxAk7z+GKSpknL6jQTV5qMjVKNDGkTPY6TaOsUkHize2SOCMyfFSCxD3BAH
         yhqgkIlIHuHAClS054a5CSosOZvNy3G3ov5O6uReyC71sS9/Mqwo68UdBtLLKhy/4TbF
         Gw3PWy2D0RNxfu1E2DtRLU7s/z7r26r7fDHcBhGjNtLDEYryS8qbK9Bxsh768leMP1NF
         w9LbUUXAjwJMOu0/8hP6iiW1KJngcr+Ta0vDevPvfCbS7eRPrT4NUvNmmc4n6OcDy/Q8
         E73/4mHFHyVjixQnfShHPBimudLSXKkmvnETR9dDZUlX91gKNHaG9InD6MMFZ5sDTGZF
         IVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ytn08IVw9vUcm1cHNUL7Zrfn0a9kpANuzaGcQ9Gn9lo=;
        b=HFSVivUXEIw5iZRyppNOCE8KQ0cNLSAtLY5Nm2rk0A1EWSmACdKKpjNnMR8q4o8ckn
         PrxMX+ofNMaxHDc9bd2q5TZCZoqeP/apDDdLeUBk1bAZbMEUPqs2M8qetsp7Lqm8dipy
         DS0Pi4pshES29PqdbgN0C1BXEq4ZwuDzHh7UERz1QuqLF0PX1IcqMwRLNJY6T2OR+Gbe
         LIikGFlVIIoggk5h7F3u8J6FqeyHNvF2+J/KcZELEPZrvwhVE9EYlns9X1UvKAigAZja
         cn38KLV15FQ1L4OqcaPn0btlsEP0HVZFlezcXUCX2x4h4/hqzrNCE4V3eDKIRUdAhcIL
         wxtg==
X-Gm-Message-State: AOAM531iwAHKN+Vd1F0PZ8pgKLiE6NWq+DhN+dtn79JQicY/6NaMc7i2
        WObqywLMwWy5tqlt4Kb4MA+STIFOSrTn8NuDlzc0Ap/AKco=
X-Google-Smtp-Source: ABdhPJyLy8HcVyzPBCa6GYMLQQVZ4V+sUNjR4BO2bDUYsawSLIkAjdH36ZFS6ZIhh5xteKZ6Wchept5k7gFAH7IdSh4=
X-Received: by 2002:a19:3818:: with SMTP id f24mr1408620lfa.601.1631224761427;
 Thu, 09 Sep 2021 14:59:21 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Sep 2021 16:59:10 -0500
Message-ID: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
Subject: [GIT PULL] ksmbd fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
9c849ce86e0fa93a218614eac562ace44053d7ce:

  Merge tag '5.15-rc-smb3-fixes-part1' of
git://git.samba.org/sfrench/cifs-2.6 (2021-08-31 09:22:37 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.15-rc-ksmbd-part2

for you to fetch changes up to 4cf0ccd033d9cedef870eb8598a55851e680a173:

  ksmbd: fix control flow issues in sid_to_id() (2021-09-08 17:16:13 -0500)

----------------------------------------------------------------
18 ksmbd fixes including:
- various fixes pointed out by coverity, and a minor cleanup patch
- id mapping and ownership fixes
- an smbdirect fix

----------------------------------------------------------------
Christian Brauner (11):
      ksmbd: fix lookup on idmapped mounts
      ksmbd: fix translation in smb2_populate_readdir_entry()
      ksmbd: fix translation in create_posix_rsp_buf()
      ksmbd: fix translation in ksmbd_acls_fattr()
      ksmbd: fix translation in acl entries
      ksmbd: fix subauth 0 handling in sid_to_id()
      ksmbd: fix translation in sid_to_id()
      ndr: fix translation in ndr_encode_posix_acl()
      ksmbd: ensure error is surfaced in set_file_basic_info()
      ksmbd: remove setattr preparations in set_file_basic_info()
      ksmbd: defer notify_change() call

Colin Ian King (1):
      ksmbd: add missing assignments to ret on ndr_read_int64 read calls

Hyunchul Lee (1):
      ksmbd: smbd: fix dma mapping error in smb_direct_post_send_data

Namjae Jeon (4):
      ksmbd: remove unused ksmbd_file_table_flush function
      ksmbd: add validation for ndr read/write functions
      ksmbd: fix read of uninitialized variable ret in set_file_basic_info
      ksmbd: fix control flow issues in sid_to_id()

Per Forlin (1):
      ksmbd: Reduce error log 'speed is unknown' to debug

 fs/ksmbd/ndr.c            | 383
++++++++++++++++++++++++++++++++++++--------------
 fs/ksmbd/oplock.c         |   6 +-
 fs/ksmbd/smb2pdu.c        |  69 +++++----
 fs/ksmbd/smb_common.c     |   4 +-
 fs/ksmbd/smb_common.h     |   1 -
 fs/ksmbd/smbacl.c         |  79 +++++++----
 fs/ksmbd/smbacl.h         |  25 ++++
 fs/ksmbd/transport_rdma.c |   2 +-
 fs/ksmbd/vfs.c            |  47 ++++---
 fs/ksmbd/vfs.h            |   3 +-
 fs/ksmbd/vfs_cache.c      |  16 ---
 fs/ksmbd/vfs_cache.h      |   1 -
 12 files changed, 413 insertions(+), 223 deletions(-)

-- 
Thanks,

Steve
