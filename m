Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D710FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 20:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8B7610F7
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 20:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhKMUU7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Nov 2021 15:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbhKMUU6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Nov 2021 15:20:58 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4612C061766;
        Sat, 13 Nov 2021 12:18:05 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id k2so18339190lji.4;
        Sat, 13 Nov 2021 12:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ItFCirRn3T8waY/fyyukZFQbnLVtvNhCT/YKsr2/SBc=;
        b=AXD/2Z8zS81I90dhhsnw3LISpIyyjWyHVuhFGW3a+KeIO+TZ+JSiYZZpygBs2eCbvr
         ntU5DGacdXh9d8CCsiqiTyorrYd3zx1AXrKot3V99bIvGtIipOp3k0IjOSW8wROKtqh4
         1mpqGR86ISPT10IsMT6nMuYQGinIbz7vNDa+Sn7dCghgEwViWDT9YanARDdtHz7BbPhe
         Z4Ykn6M9rW1YJNkSXYOjQlZ2571EZ4k+T3j4a3Sam9QxHslr666zGv44c5AQNvZYJWDm
         hrpqXV4t4fP/Q9dV6drTlTlKe+XosIpxJTPjLF/M63sIBPeHLzzWIk2Mr4FQY2BnbsFx
         MPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ItFCirRn3T8waY/fyyukZFQbnLVtvNhCT/YKsr2/SBc=;
        b=txG3ipV7hhJUmgXBaBscqsC5noF2CS0HaPM+w4gjmrX7zfjZ+oFCSR6m3Nu9qVaoxn
         CeUzHyVb5zBOFqkQD2Ra1iL1ZQ09LToSxdZ3g9RyF0wYClhX3LgXap9BO9Qmjf9Xxhrq
         3ngSz/luBDFovEWG867f825OTS6nmtxL5zyWulw4DR2b4KP64MEFUV0Lu2qxSRUdcb2Q
         r7d9NWNATANheDxfT1+wEZf4NFifjVtO9EP9OB0W5rooHPgI9UVuarhTGnlf0V+UBWl3
         UP5Z+qDCVzNWkUbGFQBrN/SMDFlW02NYa/k26vCiQw8538hA6FJeV4foHHeCaUwTndRv
         9Ctg==
X-Gm-Message-State: AOAM531UA8FQUQM6JZyp2e+N9OakGK+I94r8Z57gl/vXF1pq3suM/H8p
        7uVi0+SDfQJCUEx25hQyBQCtjIoIRAoY3e1c5uIoJyluXtA=
X-Google-Smtp-Source: ABdhPJyKsAfrNpeniAbumBSjyLoApYagYQCNmtPmz3rjynf2N1SlfQqq/rhG2KUoB8Oh3Y0+X7rrsr7x7RqmMAYfNk8=
X-Received: by 2002:a2e:a588:: with SMTP id m8mr26120420ljp.23.1636834684171;
 Sat, 13 Nov 2021 12:18:04 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 13 Nov 2021 14:17:53 -0600
Message-ID: <CAH2r5msPS_afwd3goRMC5vrmtKg0qSYcvX6qe0rs+f80M7OD0w@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
b5013d084e03e82ceeab4db8ae8ceeaebe76b0eb:

  Merge tag '5.16-rc-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2021-11-06 16:47:53 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc-part2-smb3-client-fixes

for you to fetch changes up to 46bb1b9484aeaf701da50c9ee063f3e93ce2a37b:

  cifs: do not duplicate fscache cookie for secondary channels
(2021-11-12 23:29:08 -0600)

----------------------------------------------------------------
23 cifs/smb3 fixes, including:
- improvements to reconnect and multichannel
- a performance improvement (additional use of SMB3 compounding)
- DFS code cleanup and improvements
- various trivial Coverity fixes
- two fscache fixes
- an fsync fix

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/836
----------------------------------------------------------------
Paulo Alcantara (8):
      cifs: fix print of hdr_flags in dfscache_proc_show()
      cifs: introduce new helper for cifs_reconnect()
      cifs: convert list_for_each to entry variant
      cifs: split out dfs code from cifs_reconnect()
      cifs: set a minimum of 120s for next dns resolution
      cifs: support nested dfs links over reconnect
      cifs: fix memory leak of smb3_fs_context_dup::server_hostname
      cifs: fix potential use-after-free bugs

Shyam Prasad N (7):
      cifs: nosharesock should not share socket with future sessions
      cifs: send workstation name during ntlmssp session setup
      cifs: for compound requests, use open handle if possible
      cifs: do not negotiate session if session already exists
      cifs: protect session channel fields with chan_lock
      cifs: connect individual channel servers to primary channel server
      cifs: do not duplicate fscache cookie for secondary channels

Steve French (8):
      smb3: do not error on fsync when readonly
      smb3: remove trivial dfs compile warning
      smb3: add additional null check in SMB2_ioctl
      smb3: add additional null check in SMB2_open
      smb3: add additional null check in SMB2_tcon
      cifs: release lock earlier in dequeue_mid error case
      smb3: add additional null check in SMB311_posix_mkdir
      smb3: do not setup the fscache_super_cookie until fsinfo initialized

 fs/cifs/cifs_debug.c   |    7 +-
 fs/cifs/cifs_dfs_ref.c |   59 +--
 fs/cifs/cifs_fs_sb.h   |    5 -
 fs/cifs/cifsglob.h     |   47 +-
 fs/cifs/cifsproto.h    |   10 +-
 fs/cifs/connect.c      | 1468
+++++++++++++++++++++++++++++++++-----------------------------
 fs/cifs/dfs_cache.c    |   46 +-
 fs/cifs/file.c         |   35 +-
 fs/cifs/fs_context.c   |   36 +-
 fs/cifs/fs_context.h   |    1 +
 fs/cifs/fscache.c      |    8 +
 fs/cifs/misc.c         |   64 +--
 fs/cifs/ntlmssp.h      |    4 +-
 fs/cifs/sess.c         |  240 ++++++----
 fs/cifs/smb2inode.c    |   22 +-
 fs/cifs/smb2ops.c      |   10 +-
 fs/cifs/smb2pdu.c      |   52 ++-
 fs/cifs/transport.c    |    3 +
 18 files changed, 1184 insertions(+), 933 deletions(-)

--
Thanks,

Steve
