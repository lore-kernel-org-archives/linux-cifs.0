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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AC2C433ED
	for <linux-cifs@archiver.kernel.org>; Wed,  5 May 2021 14:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 640EF61029
	for <linux-cifs@archiver.kernel.org>; Wed,  5 May 2021 14:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhEEOXQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 May 2021 10:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhEEOXP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 May 2021 10:23:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E68C061574;
        Wed,  5 May 2021 07:22:19 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z9so2798154lfu.8;
        Wed, 05 May 2021 07:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XgVsKKoBQDRVgbjHThG6cU9TXkUBKJb924zCStcnUCQ=;
        b=CxbqbQ9iFWSzp5R3V43mnGsPXcoEi+ISSGNggf18T1z0iXNx0V++93mONi/+B2IpwG
         rD7uRpYUCN6pnnba4QPUb64IMOJgf8Oz4hNk6B3u/GRqEEX9G/r33uuEsfIDzce0GNxv
         rhZQzbLn9aSRNTOwC/KM9C8uzI5kG24Rc4LyozoVF0J1rHoyxLpowbL03Tntjg9zLJI9
         9NnOav5Aab2tYDiX7OAf0LIETKWcfY8R03vIS90RZJKj0cd6PG53yCJ09P3PhjQqzBIl
         q9rH1qI0NyBtKijkICjYpv1KM0enJkRr2ySvDjQ7Rq3cjZFE1ELK9gCnXLwaXgGUmwbQ
         HHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XgVsKKoBQDRVgbjHThG6cU9TXkUBKJb924zCStcnUCQ=;
        b=JSRDEtI+9i8E/xT+AWrSdRII/SNT0/44gA1itlAL+hflbSIYvlCdqN5fhU0NZmE6yi
         iCQb4bGugqhsEB3vCN8q4ebaD45NozOzjKCnK/P4aHGWE8xCGZWu4dwiRUi5rwIKWXmy
         iCpuMdfjQFA2dJTMQuzHuCP4W63JAxvHHKXw9JmTsWI/A5hQwWfou9f3rlglR+C/6YBl
         4QWmqfs6NDYQshmbT/e0AMi5okyNATLVZsP63GIx5URqKZ6p9gBKLMvBdMXc2Pe2z6ji
         jueKLdFey/oZqlvFzODDfZvf8wMVKG1H3BNNXTLZFfad78t3b+nI4kOG7ya0/+1q/spr
         p/tQ==
X-Gm-Message-State: AOAM530+eTnTDAC8o+BQVaCwesysFyRh46nDfn+23hzKeA+YYwOD4oOY
        rU3hy7VhqFyVRXFH4/ITBntA/0jPlQrDusfJGCEA3O3x
X-Google-Smtp-Source: ABdhPJyOTwwPplhOanvEhB4tQ3uGxqjxUiEHjr3VIaSK9dLKzx65rb0O05XVwer/VRb1bGyy2KVC/27ipKfq9eAtpfE=
X-Received: by 2002:a19:614e:: with SMTP id m14mr20085393lfk.395.1620224537399;
 Wed, 05 May 2021 07:22:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 May 2021 09:22:06 -0500
Message-ID: <CAH2r5muJhWfmbsz+T1adiAT0n5DSPfsMDVBWFEY=xb22ptzGiQ@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
a8a6082d4ae29d98129440c4a5de8e6ea3de0983:

  cifs: update internal version number (2021-04-25 23:59:27 -0500)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.13-rc-smb3-part2

for you to fetch changes up to bae4c0c1c2d576d32e37925ef972a5d45f34e36d:

  fs/cifs: Fix resource leak (2021-05-04 11:53:15 -0500)

----------------------------------------------------------------
10 CIFS/SMB3 changesets (including two for stable):
- some important multichannel fixes
- support for handle leases (deferred close)
- shutdown support (which is also helpful since it enables multiple xfstests)
- enable negotiating stronger encryption by default (GCM256)
- improve wireshark debugging by allowing more options for root to
dump decryption keys

SambaXP and the SMB3 Plugfest test event are going on now so I am
expecting more patches over the next few days due to extra testing
(including more multichannel fixes).

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/628
----------------------------------------------------------------
Khaled ROMDHANI (1):
      fs/cifs: Fix resource leak

Paulo Alcantara (1):
      cifs: fix regression when mounting shares with prefix paths

Rohith Surabattula (2):
      cifs: Deferred close for files
      Cifs: Fix kernel oops caused by deferred close for files.

Shyam Prasad N (2):
      cifs: detect dead connections only when echoes are enabled.
      cifs: use echo_interval even when connection not ready.

Steve French (4):
      smb3.1.1: enable negotiating stronger encryption by default
      cifs: add shutdown support
      smb3.1.1: allow dumping GCM256 keys to improve debugging of
encrypted shares
      smb3.1.1: allow dumping keys for multiuser mounts

 fs/cifs/cifs_fs_sb.h |   1 +
 fs/cifs/cifs_ioctl.h |  35 ++++++++++++++++++++++++++
 fs/cifs/cifsfs.c     |  25 ++++++++++++-------
 fs/cifs/cifsglob.h   |  17 +++++++++++++
 fs/cifs/cifsproto.h  |  13 ++++++++++
 fs/cifs/connect.c    |  37 ++++++++++++++-------------
 fs/cifs/dir.c        |  10 ++++++++
 fs/cifs/file.c       | 102
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/fs_context.c |   5 ++++
 fs/cifs/inode.c      |  27 ++++++++++++++++++--
 fs/cifs/ioctl.c      | 112
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/link.c       |  13 +++++++++-
 fs/cifs/misc.c       |  79
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/xattr.c      |   4 +++
 14 files changed, 447 insertions(+), 33 deletions(-)


--
Thanks,

Steve
