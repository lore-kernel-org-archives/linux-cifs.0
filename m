Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80769C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 13:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5413F611AE
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 13:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhKFNw1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Nov 2021 09:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhKFNw0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Nov 2021 09:52:26 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76370C061570;
        Sat,  6 Nov 2021 06:49:45 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id g3so19866599ljm.8;
        Sat, 06 Nov 2021 06:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=hllwjT4hNTrSJHeTE4iXbEl+wXeiJPG72ZsFy8OgFs8=;
        b=j/bX+iS3Gw45KdNSlp0LnjcQLupd19hi3uzB904DP6jv8i8dx80jU2wBQCMr3LZEAd
         TXx2OhXaHkr5HDGh3t4StZev0qvqsbH4dBUYOyep7WqYxhfGbKus/x74cGKuJVvttclL
         iRg9kV3HhbWSoK6o/YxK7Mhb7uXif2ZX3gKhoy2MFkObCkzvs2UpIfzjiC+Sf5Sx8cj7
         MalPqo8LENV3JseVC37UuJvIYsqdWYxxrq8D1Rsxmh3GxNb5ayytjdMnJ8uKb25VX9Bq
         4/D9UH/hEr1AjeCkNg6qLYtCHlGJ2tLoTILaFID2bwZjA830pLKWIpWPuJrOwhf9tAx1
         J4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hllwjT4hNTrSJHeTE4iXbEl+wXeiJPG72ZsFy8OgFs8=;
        b=sebC/rVW1bfBb9clkOyTGUkPSJqMmAXaeZwTQbuTYIRoPGc3+SlZcKE3onlmPy65x+
         YJsqHrbrviWbnoRmzIzkna/EZ3pOlMCXEbf8h+I87Dx/7XIxEuoNOz7FymCpJaFh7o64
         BLxP7nxIVPkdEu3Hpkpe6pAb7b9d8qinjmElLeKgIrI6QThbRuFPzNUiwvTg60eyoYQN
         8pypjpRFT9aYW6U/oKdg2rcRB3ppyBQiG1g18Tk0UAms05P0X+05z8jH+cCp3P7AI9lW
         0BcoUYriu2MoA3j/cFZQWJ46kS9qFoxEvJmmO7tdDGVMXy3kVe5rDbxbjnGOBLqRHz2+
         Xp1Q==
X-Gm-Message-State: AOAM5335QFAMD5jfAMVv52CusdJ+jJik9HQptjGlXvNCcc2AnDFwoiyM
        jHE6lF+oaIFMwluyuZg/qVmY08LOBVNUH9dGGui+23l+uMg=
X-Google-Smtp-Source: ABdhPJxwSZ9CWpulDTAqSztmY/n1f6kETA98HrigwzD1Nw/AoGwg5iHK7PszWU95TjjeEV0WrgIy4gbrHjW1JJjHOlU=
X-Received: by 2002:a2e:9119:: with SMTP id m25mr13574819ljg.229.1636206583758;
 Sat, 06 Nov 2021 06:49:43 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 6 Nov 2021 08:49:31 -0500
Message-ID: <CAH2r5mum6Fm=4jybfZ2fcvP9yBioXV4mi6TTjwnTZhasZLnRnQ@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
3906fe9bb7f1a2c8667ae54e967dc8690824f4ea:

  Linux 5.15-rc7 (2021-10-25 11:30:31 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc-part1-smb3-client-fixes

for you to fetch changes up to d7171cd1acf70eb949ece8ccc95be27b3dfcf4da:

  smb3: add dynamic trace points for socket connection (2021-11-05
16:20:24 -0500)

----------------------------------------------------------------
7 cifs/smb3 fixes:
- a reconnect fix for stable
- a minor mount option fix
- a debugging improvement for (TCP) connection issues
- refactoring of common code to help ksmbd

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/826

There is a larger set of fixes (multichannel and DFS related e.g.)
still being tested/reviewed for later in the merge window
----------------------------------------------------------------
Ronnie Sahlberg (4):
      cifs: Create a new shared file holding smb2 pdu definitions
      cifs: move NEGOTIATE_PROTOCOL definitions out into the common area
      cifs: Move more definitions into the shared area
      cifs: Move SMB2_Create definitions to the shared area

Shyam Prasad N (1):
      cifs: To match file servers, make sure the server hostname matches

Steve French (2):
      cifs: add mount parameter tcpnodelay
      smb3: add dynamic trace points for socket connection

 fs/cifs/cifsfs.c          |   1 -
 fs/cifs/cifsglob.h        |   3 +-
 fs/cifs/connect.c         |  26 +-
 fs/cifs/fs_context.c      |  16 ++
 fs/cifs/fs_context.h      |   2 +
 fs/cifs/misc.c            |   2 +-
 fs/cifs/smb2maperror.c    |  16 +-
 fs/cifs/smb2misc.c        |  47 ++--
 fs/cifs/smb2ops.c         |  73 +++---
 fs/cifs/smb2pdu.c         | 187 +++++++-------
 fs/cifs/smb2pdu.h         | 919
++----------------------------------------------------------------
 fs/cifs/smb2proto.h       |   2 +-
 fs/cifs/smb2transport.c   |  36 +--
 fs/cifs/trace.h           |  71 ++++++
 fs/smbfs_common/smb2pdu.h | 989
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 15 files changed, 1299 insertions(+), 1091 deletions(-)
 create mode 100644 fs/smbfs_common/smb2pdu.h


--
Thanks,

Steve
