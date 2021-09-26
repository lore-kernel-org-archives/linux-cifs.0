Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0818FC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 12:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02F960F0F
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 12:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhIZMPn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 08:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhIZMPm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Sep 2021 08:15:42 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2DBC061570;
        Sun, 26 Sep 2021 05:14:06 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id u8so62379760lff.9;
        Sun, 26 Sep 2021 05:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=aQFF7GpJjgpTZIGLB6wnrouO52iU2WbiUygOC1gWxac=;
        b=X5FGCgMN75181qZvAGYAsok0AG03K9/dZejszCm59FHSSBZn7py46+Yk/EuFHt1Yl1
         Cu7g47/CD7YzI8SCFtjtDefItLkGkMqUCxBmlu4xYGly9sjHIAkzHpngwRGd5hxG2KJw
         9oTZs8j4+Z2GhwDoEGCi8UV+oRT1mHmI2S9hSLDHN7pfU6d8zUXjk9nn8WvmT6r5fdUm
         3X2bz/JSE6xFB0GKMxpuVXjGFdyvoYjyYpbk5e27ujp+RAG0t7x8Jtj46ph5fwKMxt49
         oOQNqahAvEQvXZR/wsRAGYVZU3mIzicnVhOABzUAMpCVSPtMLFE3jfN6eZIkCdZBwUTj
         huCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=aQFF7GpJjgpTZIGLB6wnrouO52iU2WbiUygOC1gWxac=;
        b=3bwIEmW8POTj/6gEGd/Y6vL4JXFeBg+NjWDXfuBYXsb7qZ4YOuu6ssn5l+mmGikWO/
         iFO8lmy4NT66JFul2F6zswdb/yBHmpRz3f0udH4mUM3DoLqlQXnsBXk4kerZJxzvLyDX
         4mjMjIQ41wBfQmXo/KgyEgyKwx5EWAWiOV/tRB2xuNj8LhMhGX/BRcKLbsvFoI/GVr4Y
         nx5xCRNqrlMQNSobLyCq5QrH3ZeaNGkZPasHTTji1qAqds+VCoZ7DHDwNn/AmgF4wG3y
         TiDfGkAthW+WOgL/wQYA5OexuTg8djUXrKnEVCYlIt1DlCkvu1WFKNGT0HWweVqpHaIM
         u8xw==
X-Gm-Message-State: AOAM531TT9OF25CuzAPK5R4uu+ujBJNcT3b/DOMZNALmGjkjNcluJrxZ
        QN6uUFapkw3Q43tM+QGZcTty+QfDBWeqWwo2LM5uNRXl
X-Google-Smtp-Source: ABdhPJwcbjOzkCSNchGwTCrzPLVzHjVcR3xw/B71teJDyztlYuelZd3drq1slvAUFVlTNcaApw0+Td+Xc6P3yWhbyws=
X-Received: by 2002:a2e:4619:: with SMTP id t25mr22253666lja.398.1632658444629;
 Sun, 26 Sep 2021 05:14:04 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 26 Sep 2021 07:13:53 -0500
Message-ID: <CAH2r5mv2fC4ugsUzB5T1ozvPnxeatwMsPrukiPF53WOREFxJXA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
707a63e9a9dd55432d47bf40457d4a3413888dcc:

  Merge tag '5.15-rc1-ksmbd' of git://git.samba.org/ksmbd (2021-09-20
15:35:17 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.15-rc2-ksmbd-fixes

for you to fetch changes up to 265fd1991c1db85fbabaad4946ca0e63e2ae688d:

  ksmbd: use LOOKUP_BENEATH to prevent the out of share access
(2021-09-24 21:25:23 -0500)

----------------------------------------------------------------
Five fixes for the ksmbd kernel server, including three security fixes:
- removing follow symlinks support
- converting to use LOOKUP_BENEATH to prevent out of share access
- SMB3 compounding security fix
-fix for returning the default streams correctly, fixing a bug when
writing ppt or doc files from some clients
- logging more clearly that ksmbd is experimental (at module load time)

Functional testing passed (e.g.
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/73).
Additional patches are being reviewed, addressing the remaining
potential overflows found in the security reviews.
----------------------------------------------------------------
Hyunchul Lee (1):
      ksmbd: use LOOKUP_BENEATH to prevent the out of share access

Namjae Jeon (3):
      ksmbd: add default data stream name in FILE_STREAM_INFORMATION
      ksmbd: check protocol id in ksmbd_verify_smb_message()
      ksmbd: remove follow symlinks support

Steve French (1):
      ksmbd: log that server is experimental at module load

 fs/ksmbd/misc.c       | 100 ++++++++---------------------------------
 fs/ksmbd/misc.h       |   7 +--
 fs/ksmbd/server.c     |   3 ++
 fs/ksmbd/smb2pdu.c    | 119 ++++++++++++++++--------------------------------
 fs/ksmbd/smb_common.c |  13 ++++--
 fs/ksmbd/smb_common.h |   1 +
 fs/ksmbd/vfs.c        | 172
++++++++++++++++++++++++++++++++++------------------------------------
 fs/ksmbd/vfs.h        |   9 +++-
 8 files changed, 164 insertions(+), 260 deletions(-)


--
Thanks,

Steve
