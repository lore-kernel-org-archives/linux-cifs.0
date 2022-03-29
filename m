Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5B5C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Mar 2022 01:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiC2BlN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiC2BlM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Mar 2022 21:41:12 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F8D517F4
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 18:39:24 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m3so27757186lfj.11
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 18:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=yPEmCEL1BuHOzckOq+gtj7Y+nx+5Bkt8fSwA/KSmq6E=;
        b=jRNWC2DeqpBAd+uav26v4fZci+gUhAZNgXn3yqqFpwCvO5Es7iQuZ3eAYHG0qCI4uF
         NyssIUDlZToYE4Unu6mEWffPNtAdUcX1jZNqvANX/HiA3m/N7R8gMMSEImJ8yINii3kK
         wq1SLoxVZ59FhPNdBMERps80P5giJNUXt/F5B01Ow+6VKf963X2gYji7a29avPlLJeOY
         Kjkartba5blyu0o6nWDOb3Z+2OsrerlrvjHke3HyJGu7KQ0p0XENacyBb1QJPJK/Gkxd
         r2s96TuUZYis+phrl2UpdBD0R3aqEgIz6Bbt2VxIPYp9WUOkaj/n2m0YF20t2k8fffPa
         tYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=yPEmCEL1BuHOzckOq+gtj7Y+nx+5Bkt8fSwA/KSmq6E=;
        b=kr293n9/VszvUsEBx4AW9F/dGmTdTtHERZz0bDevPVl/7t3TDYS3L4Xn7iJYIQ4lH7
         FtMt48Iui9w7Awh6U+I7YPd4efYVnrGaKyjLVDDedIRT/yqjU38HCKkyJkhaGNG0utD3
         6WZT5yHPL/Krz+kxPWBYkuV01qhpw/m+TjDzGj7NwVWTj9LE/oDlytAqXliO0ATILDgJ
         31tpf9bhkZvZ2HJ7n/5T62/6qbcmKuEJDJgNbUNNQBXUTD4Ote/BE2QckhGDB3YZ19sz
         f64kEnmNMDQVeCf6mJgHg34m3FbQ9lMxkpNle1lEW6D/6nqilXaqOzE9N/d9WIcs8oLI
         FXPg==
X-Gm-Message-State: AOAM53173GwbqjKpAQvc6OQqKOIHK0xJlpJJD8vu3c066ef3NcskGMvr
        7HeGbW3NPE+15whY1gOkQN/DXvuAVVId4OGxWQShQVw3Sn4=
X-Google-Smtp-Source: ABdhPJxwhcw+wEAs/kIuJ0310845YyhVNGRUyTizaZ1XrLogcgKO06U/uNCNjCWx/HnwJO2Aedds8cs6mnru6oty20I=
X-Received: by 2002:ac2:4645:0:b0:44a:a75c:8854 with SMTP id
 s5-20020ac24645000000b0044aa75c8854mr320947lfo.667.1648517962506; Mon, 28 Mar
 2022 18:39:22 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 28 Mar 2022 20:39:11 -0500
Message-ID: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2:

  Linux 5.17-rc7 (2022-03-06 14:28:31 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.18-ksmbd-server-fixes

for you to fetch changes up to 5d4c2759d83bad3041bf16d0b0e2ff6df11200bb:

  ksmbd: replace usage of found with dedicated list iterator variable
(2022-03-26 12:45:50 -0500)

----------------------------------------------------------------
10 smb3 server fixes
- three cleanup fixes
- shorten module load warning
- two documentation fixes
- four patches relating to dentry race
-----------------------------------------------------------------
Christophe JAILLET (1):
      ksmbd: Remove a redundant zeroing of memory

Jakob Koschel (1):
      ksmbd: replace usage of found with dedicated list iterator variable

Namjae Jeon (6):
      Documentation: ksmbd: update Feature Status table
      ksmbd: remove internal.h include
      ksmbd: remove filename in ksmbd_file
      ksmbd: fix racy issue from using ->d_parent and ->d_name
      ksmbd: increment reference count of parent fp
      MAINTAINERS: ksmbd: switch Sergey to reviewer

Steve French (1):
      ksmbd: shorten experimental warnign on loading the module

Tobias Klauser (1):
      ksmbd: use netif_is_bridge_port

 Documentation/filesystems/cifs/ksmbd.rst |   4 +-
 MAINTAINERS                              |   2 +-
 fs/internal.h                            |   2 -
 fs/ksmbd/misc.c                          |  40 +++++--
 fs/ksmbd/misc.h                          |   3 +-
 fs/ksmbd/oplock.c                        |  30 ------
 fs/ksmbd/oplock.h                        |   2 -
 fs/ksmbd/server.c                        |   2 +-
 fs/ksmbd/smb2pdu.c                       | 147 +++++--------------------
 fs/ksmbd/transport_tcp.c                 |   4 +-
 fs/ksmbd/vfs.c                           | 262
++++++++++++++++++++-------------------------
 fs/ksmbd/vfs.h                           |   7 +-
 fs/ksmbd/vfs_cache.c                     |   7 +-
 fs/ksmbd/vfs_cache.h                     |   1 -
 fs/namei.c                               |  41 +++++--
 include/linux/namei.h                    |   7 ++
 16 files changed, 231 insertions(+), 330 deletions(-)

-- 
Thanks,

Steve
