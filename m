Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B79FC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 16:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E638760EE2
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 16:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhKLQWK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Nov 2021 11:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhKLQWJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Nov 2021 11:22:09 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FD1C061767;
        Fri, 12 Nov 2021 08:19:18 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id z8so19501853ljz.9;
        Fri, 12 Nov 2021 08:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=nw3DmsyVi78VBxFxXKV3pNgx1Lmaugz8lN9SDA39wYQ=;
        b=YYUgTDcKtclCmeRRFu5RuSj35rhfPBNHFV1VwUXq4XMs1G4PK91lda7/CPbRc6SQFk
         WDAFvPouNDWVh0sdJJzlD/J9/ixMsSkgG4Jq9UZvypv9pWXdo46ZNGGdE7S0sYIaFKHo
         MAfnBx7yB2k/XxJvLBXYCebZPgeqGfUHukjTipOKc3IjfobYkec2sT/J8yzIlztyLjuY
         C4Ae5obK2VPSsPqNsfVS+Fsz3llN+/aCiahfFf1b4M3fpXcluXLXY42MZpQlEfed2k86
         ftnJWmPucvc8kszkwj98Jv5U8QpPPrJ3UNochTwLHPadtEBvTw1YxBKvDRAflC0fNy7k
         H3xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nw3DmsyVi78VBxFxXKV3pNgx1Lmaugz8lN9SDA39wYQ=;
        b=rE6XFigUQffj0b4DdWHsJ8y2EFLEkI15376SfFoLfAHkqYoKNqAUDWHFfajPhvtLCH
         dWKxRp/Tdmo4eb1KAYs5wIsQCYJd5idtbwdeDMugzlWvds67bIT44fxkTTPbYq2aLqga
         JEmgPFTU67XIGLVePR54zSCyINcWwRMiGqQUR98Z9PxPbXdYExCgSQE8HxsffMK0c6z+
         ldUFPZ8rMOvwLT8ZZbkg0SSAaX5rX9+nM7nYpcGSaEGflnet3SKuYfL53pCtwXt96BNO
         +FwL++PLCeKGFE5Um9nNUJf0ooeYAJpRXMcibM+qXiIafBweTN4RxAwkGgq+Vfgfo8k6
         ib9w==
X-Gm-Message-State: AOAM532mlTC6J2zMmJoOwY6DYSp0U6Hzi77MZnNyebxYJe1/cJN1GcF6
        uYJnamfiBRboBgLdNs/BWQnyhNcbdle/D9/mAUo=
X-Google-Smtp-Source: ABdhPJxwZHW9w8Kh52hjz6X1pFeMitVzKSnRKhBzgj8SS8/gh1G7Og4fiIWZrl1n+ejpOs+HJDgImbCRhgXreDazN2g=
X-Received: by 2002:a2e:9e88:: with SMTP id f8mr16503900ljk.460.1636733956632;
 Fri, 12 Nov 2021 08:19:16 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Nov 2021 10:19:05 -0600
Message-ID: <CAH2r5ms0=2rMt4+jGi1nQC+EPrjozYezRjSiyt9DCxbkTwqgNw@mail.gmail.com>
Subject: [GIT PULL] ksmbd fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
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

  git://git.samba.org/ksmbd.git tags/5.16-rc-ksmbd-fixes

for you to fetch changes up to 26a2787d45c5af8ffe0f986c01c36bc9111aa9be:

  ksmbd: Use the SMB3_Create definitions from the shared (2021-11-11
19:22:58 -0600)

----------------------------------------------------------------
15 smb server fixes: 3 for stable
- important fix for validate negotiate
- fix alignment check in packet validation
- cleanup of dead code (like MD4)
- refactoring some protocol headers to use common code in smbfs_common

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/93
----------------------------------------------------------------
Christophe JAILLET (1):
      ksmbd: Remove redundant 'flush_workqueue()' calls

Marios Makassikis (1):
      ksmbd: Fix buffer length check in fsctl_validate_negotiate_info()

Namjae Jeon (6):
      ksmbd: don't need 8byte alignment for request length in
ksmbd_check_message
      ksmbd: set unique value to volume serial field in FS_VOLUME_INFORMATION
      ksmbd: remove md4 leftovers
      ksmbd: remove smb2_buf_length in smb2_hdr
      ksmbd: remove smb2_buf_length in smb2_transform_hdr
      ksmbd: change LeaseKey data type to u8 array

Ralph Boehme (3):
      ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
      ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
      ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()

Ronnie Sahlberg (4):
      ksmbd: switch to use shared definitions where available
      ksmbd: use the common definitions for NEGOTIATE_PROTOCOL
      ksmbd: Move more definitions into the shared area
      ksmbd: Use the SMB3_Create definitions from the shared

 fs/ksmbd/Kconfig          |   2 +-
 fs/ksmbd/auth.c           |  11 +-
 fs/ksmbd/connection.c     |  11 +-
 fs/ksmbd/ksmbd_work.c     |   1 -
 fs/ksmbd/ksmbd_work.h     |   4 +-
 fs/ksmbd/oplock.c         |  48 ++--
 fs/ksmbd/oplock.h         |   2 -
 fs/ksmbd/server.c         |   2 +-
 fs/ksmbd/smb2misc.c       |  16 +-
 fs/ksmbd/smb2ops.c        |   9 +-
 fs/ksmbd/smb2pdu.c        | 591 +++++++++++++++++++-------------------
 fs/ksmbd/smb2pdu.h        | 696 ++-------------------------------------------
 fs/ksmbd/smb_common.c     |  13 +-
 fs/ksmbd/smb_common.h     |  55 +---
 fs/ksmbd/transport_rdma.c |   3 +-
 fs/ksmbd/vfs.c            |   8 +-
 fs/ksmbd/vfs.h            |  39 ---
 17 files changed, 372 insertions(+), 1139 deletions(-)

-- 
Thanks,

Steve
