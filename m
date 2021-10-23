Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB073C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Oct 2021 15:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C5960FD8
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Oct 2021 15:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhJWPJO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Oct 2021 11:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhJWPJN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Oct 2021 11:09:13 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46551C061714;
        Sat, 23 Oct 2021 08:06:54 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x192so153285lff.12;
        Sat, 23 Oct 2021 08:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UhVKiBkM27S8utl/+Lqsx9ZhjhKwnMJnJoQC1dkuYBw=;
        b=p9qxO81kQYrkKeU6U/rkrAbu4nrgKkDBWB24T9b/7rp9T4sjyNUoZQxE9RmQ4sPVhF
         IBfWQUpEQrCOcUdhMJE3k8bKXkoMgAAUftYKchN85rOYeMkg94a5GCeggJW1Dm8xwxQM
         d0UHyBWi87xG5SCyjhTkIrsvBjc2T8qKlRxnTUJI1CPM/DtCGb7D2BXWCpnaq3roIDCr
         bwOPLOiengkE4t4bF05iF0sapv41dOP71YTAUStkueVF8k9/RTRQl7+3ePsr2dUlEHm9
         NTYVf8pmLkuuce32OGjqT8hyebCSARDg4rXYtGG9g+zr/xIpq+0lNhw66mr23+UQwFR1
         Zj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UhVKiBkM27S8utl/+Lqsx9ZhjhKwnMJnJoQC1dkuYBw=;
        b=A/UTlSD6WpMHuB//S00xCYsXg5l803Y7GWejy7HQ3l7tNwrPU++Pdb63NIjSBfgE+C
         KE2zRJC0C6AbM3iqjr5WWkRRdXf8chE8GfOVKtNl04nIF0SnlNivR89487+YvJXx769x
         po7uzM7mBfntoe9npRb0kOae2h6NDPX1ULORBSqUyJVXi6StEm88A8V9oK6MpaoddrX9
         FsTRXUuApk4lznooJKvASEx896lMEKMZXIrXFZWaNhFz6v+nYNSAgrLw0RSl4fx0Byh0
         A9OF6rwhmfBoEnACdWVagyiYoyA5cHlE4AsKIIAZaNGdU54Vfy673ancF3+9zyqoxD3+
         VTCQ==
X-Gm-Message-State: AOAM530Tcmwe05Q2EUg3rGMo5vIvSaRHTc942w9HI1KbumTcBePo4Ij6
        XuHbWeWrK3WpgtnCpoUUDRgOI9ltWJ6w0mv708A09f2B05w=
X-Google-Smtp-Source: ABdhPJxpIzSSD2q2KmIx/m8nlfIxWVTU/kNkPVGyN4E4uZfkQjX2F9cUxx+Kif31HG2AGNpVfx2NuJFH/dnxOYRY3Y4=
X-Received: by 2002:a05:6512:3763:: with SMTP id z3mr6453033lft.601.1635001612411;
 Sat, 23 Oct 2021 08:06:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 23 Oct 2021 10:06:41 -0500
Message-ID: <CAH2r5mvY5kWAHs=0Lzgst0rjRaej+VW1ZLdFc8kDJ-07QmWQsA@mail.gmail.com>
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
64570fbc14f8d7cb3fe3995f20e26bc25ce4b2cc:

  Linux 5.15-rc5 (2021-10-10 17:01:59 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.15-rc6-ksmbd-fixes

for you to fetch changes up to 0d994cd482ee4e8e851388a70869beee51be1c54:

  ksmbd: add buffer validation in session setup (2021-10-20 00:07:10 -0500)

----------------------------------------------------------------
Ten fixes for the ksmbd kernel server:
- a security improvement to session establishment to reduce the
possibility of dictionary attacks
- fix to ensure that maximum i/o size negotiated in the protocol is
not less than 64K and not more than 8MB to better match expected
behavior
- fix for crediting (flow control) important to properly verify that
sufficient credits are available for the requested operation
- seven additional buffer overflow, buffer validation checks

Regression test results for current linux-next:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/89
----------------------------------------------------------------
Hyunchul Lee (3):
      ksmbd: improve credits management
      ksmbd: add buffer validation for smb direct
      ksmbd: validate OutputBufferLength of QUERY_DIR, QUERY_INFO,
IOCTL requests

Marios Makassikis (1):
      ksmbd: add buffer validation in session setup

Namjae Jeon (5):
      ksmbd: add validation in smb2_ioctl
      ksmbd: fix potencial 32bit overflow from data area check in smb2_write
      ksmbd: validate compound response buffer
      ksmbd: limit read/write/trans buffer size not to exceed 8MB
      ksmbd: throttle session setup failures to avoid dictionary attacks

Ralph Boehme (1):
      ksmbd: validate credit charge after validating SMB2 PDU body size

 fs/ksmbd/auth.c             |  16 +-
 fs/ksmbd/connection.c       |   2 +
 fs/ksmbd/ksmbd_netlink.h    |   2 +
 fs/ksmbd/mgmt/user_config.c |   2 +-
 fs/ksmbd/mgmt/user_config.h |   1 +
 fs/ksmbd/smb2misc.c         |  55 ++++---
 fs/ksmbd/smb2ops.c          |   3 +
 fs/ksmbd/smb2pdu.c          | 346 ++++++++++++++++++++++++++++---------------
 fs/ksmbd/smb2pdu.h          |   2 +
 fs/ksmbd/transport_ipc.c    |   3 +-
 fs/ksmbd/transport_ipc.h    |   2 +-
 fs/ksmbd/transport_rdma.c   |  21 ++-
 fs/ksmbd/vfs.c              |   2 +-
 fs/ksmbd/vfs.h              |   2 +-
 14 files changed, 306 insertions(+), 153 deletions(-)

-- 
Thanks,

Steve
