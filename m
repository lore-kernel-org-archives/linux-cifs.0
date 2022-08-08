Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F91C00140
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 20:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiHHUBL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 16:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiHHUBK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 16:01:10 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA853C61
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 13:01:09 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id r4so4929317vkf.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 13:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=71PuA6jDhNE+lD3WTQjWUyC7Vw1h5/nkYqjkXqze6nY=;
        b=MAJQd8666xlCEle9wa5HH2CIV8K06/kCbWNUKfjkUlzBuDxgkVwP+25sdde+9kL0XZ
         OlS8s0NH9bd0q9Y4GLZAuzS6my7OniQ4fbELDki2mXnnXOtPCgsBoC7SbZwwstLNGUJg
         3GfRyjeWP8vIrW59qD+IF4df4dMsOkaOk1mBb6w4e11WefvOC42z3fQUKghSLtfEcU74
         /8UZGzuWUNBE8HU0PQ+jjEkCaA/stERl+DXcJwr+EN/g6SsElIz1MnYYlcCTO/iw/vMb
         J8Ubn4P5i4DSffvj5geXUQIBJ0CgXswJQYnp8BITwlY1com32F5gC2s+1njlV3cl+Fo4
         8e6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=71PuA6jDhNE+lD3WTQjWUyC7Vw1h5/nkYqjkXqze6nY=;
        b=hLp3b5iSjiytN17bC1uppAxQ3JQKR1UYunZqUnU309/E743z72EimIJ3DHhy3ixM3F
         K2SeDIoGK9AVjpzSXz4Li6eQf+mb6GCw/j5EumlS7KTNPvpVa/Y/KSiq++bgj9tMmEoB
         dZfMJdmXszgjcips7q1tDfqFv06kCplSX1uAgB4ruibnzXr4A9WjW3TkAHnOpj5ORfc3
         +FUdRkTGlKys6Of/9LbATsgPHaCsBf/J80oLxDZvJRzcH9ejwSKaEJ1G5WmcB+JeDmS9
         8bUzqK3EPRMUia37quqwRfP2ywuNhx1m6x+ZmLz4rllGP9BPZZXn60ijQdp4u3sH0NrX
         JE9w==
X-Gm-Message-State: ACgBeo2aKUBUDQ5lKbmVuh+bKaSRHGNuj5nboLf53RT7nkXJ5/hGOyNQ
        FuP4iloJZ/Fsg3Y1FVvKAWLSjetYE2VjYC1jZQ6kTjLL2fsruQ==
X-Google-Smtp-Source: AA6agR7mD5tx3EN93ae2ot3MStNbYdgTlFlzILYrxzRZlWRnzua8581bNidO9UYkeVj0iobCTSGXhJrULwo1Ab+CU+A=
X-Received: by 2002:a1f:9407:0:b0:377:668e:c2a0 with SMTP id
 w7-20020a1f9407000000b00377668ec2a0mr8167405vkd.38.1659988868760; Mon, 08 Aug
 2022 13:01:08 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Aug 2022 15:00:58 -0500
Message-ID: <CAH2r5ms0RwBabutvhVrMWYrepeYuH=8_Fv5jHqLCtgCGj9vehg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
ff6992735ade75aae3e35d16b17da1008d753d28:

  Linux 5.19-rc7 (2022-07-17 13:30:22 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.20-rc-ksmbd-server-fixes

for you to fetch changes up to 8f0541186e9ad1b62accc9519cc2b7a7240272a7:

  ksmbd: fix heap-based overflow in set_ntacl_dacl() (2022-08-04 09:51:38 -0500)

----------------------------------------------------------------
12 ksmbd server fixes
- six fixes for memory access bugs (out of bounds access, oops, leak)
- two multichannel fixes
- session disconnect performance improvement, and session register improvement
- cleanup
----------------------------------------------------------------
Hyunchul Lee (2):
      ksmbd: prevent out of bound read for SMB2_WRITE
      ksmbd: prevent out of bound read for SMB2_TREE_CONNNECT

Namjae Jeon (10):
      ksmbd: remove unused ksmbd_share_configs_cleanup function
      MAINTAINERS: ksmbd: add entry for documentation
      ksmbd: replace sessions list in connection with xarray
      ksmbd: add channel rwlock
      ksmbd: fix kernel oops from idr_remove()
      ksmbd: use wait_event instead of schedule_timeout()
      ksmbd: fix racy issue while destroying session on multichannel
      ksmbd: fix memory leak in smb2_handle_negotiate
      ksmbd: fix use-after-free bug in smb2_tree_disconect
      ksmbd: fix heap-based overflow in set_ntacl_dacl()

 MAINTAINERS                  |   1 +
 fs/ksmbd/auth.c              |  56 ++++++++++---------
 fs/ksmbd/auth.h              |  11 ++--
 fs/ksmbd/connection.c        |   9 +--
 fs/ksmbd/connection.h        |  10 +---
 fs/ksmbd/mgmt/share_config.c |  14 -----
 fs/ksmbd/mgmt/share_config.h |   2 -
 fs/ksmbd/mgmt/tree_connect.c |   5 +-
 fs/ksmbd/mgmt/tree_connect.h |   4 +-
 fs/ksmbd/mgmt/user_session.c |  95 +++++++++++++++++--------------
 fs/ksmbd/mgmt/user_session.h |  13 ++---
 fs/ksmbd/oplock.c            |  46 +++++++++------
 fs/ksmbd/server.c            |   8 ++-
 fs/ksmbd/smb2misc.c          |  12 ++--
 fs/ksmbd/smb2pdu.c           | 112 ++++++++++++++++++++++++-------------
 fs/ksmbd/smb_common.h        |   2 +-
 fs/ksmbd/smbacl.c            | 130 +++++++++++++++++++++++++++++--------------
 fs/ksmbd/smbacl.h            |   2 +-
 fs/ksmbd/vfs.c               |   8 ++-
 fs/ksmbd/vfs_cache.c         |   2 +-
 20 files changed, 322 insertions(+), 220 deletions(-)

-- 
Thanks,

Steve
