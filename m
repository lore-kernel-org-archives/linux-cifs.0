Return-Path: <SRS0=YkwU=54=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC21C2BA19
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Apr 2020 02:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AF5F20708
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Apr 2020 02:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZB00UFdE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgDLC0P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 11 Apr 2020 22:26:15 -0400
Received: from mail-yb1-f177.google.com ([209.85.219.177]:45275 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgDLC0O (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 11 Apr 2020 22:26:14 -0400
Received: by mail-yb1-f177.google.com with SMTP id g6so3333971ybh.12;
        Sat, 11 Apr 2020 19:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Im3Zo9a3ywNa9900rrlLtq4o6wPWZNFpB2TZ5aSwRXc=;
        b=ZB00UFdE8pBRNldGtjaeZpPsIv2jWKSAPJ33Ljs3fmewi3WNdytZi9ghWL+qp+5VVh
         F1yx9nZ3edHYFRixj4Q+dX44hMpbgxLQSnZJYTCGixYSp7EM1fF0BEA6HSyT9MGw2Szk
         4RRmua8kHgKvdoVe9/1JcH43rFPt1zGkCmCOf6uE0tcKYjjX5AtmKfyL/fMZ4LOsiPxl
         XizAD5w2RSuymrdpTQHaWlQETzP0XU0eIB7xSxZ4jF/vPkW+tRert7R7k11ogcE+MUr+
         MFuNEQ3P8v24RZinvNd7EZiUw0pxcnc187CP1zOGIsxiqHu8nZoU5NvWvoy8af/LCodA
         tAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Im3Zo9a3ywNa9900rrlLtq4o6wPWZNFpB2TZ5aSwRXc=;
        b=CRXPMz0tDupR0ETiKf7IIexqMHCXXEEirA4edgKKUVPKDBJPAIMccbTdLMst0OVTAK
         XJhlXrToP57BiWXlSF2x0efGLjuk59m7Al4+fhi702JDK21CqapV4czxM0Qd9NXsK2f1
         UdG3z+CFk2pr/jbndZ1HsO8MWP6tRj2DBrtYdjyVKj0oo+v0DAbb0p65TJ86bdFSA7DF
         QR72U4hAW0awE80Tjr+k6TPr8pqyOoUP4/kY/EXYYze8Pg+hV3yFiQ9HQlEBPNAwPNCt
         iyQmdPqfA9+xIVHf1xlg8eH410wzi3cvMUFNZWtPpvdWFkpRr4nvIcV4XU4ykeWGYw84
         u7Fw==
X-Gm-Message-State: AGi0PuZcBKwBYfeRM330YZoELXdKl5UcXTJUwBNSQlJRYZD83EvVl59x
        JBMInaAdEq1NU+jq9XwLb24YCAJjpjnz1lrUpXQiC5TmwSM=
X-Google-Smtp-Source: APiQypIySMu4+E10x287DrvNOMkbsA6R6k+vfoQm29hEg/57UQkOarQwRPCOxAsAGEkzTk1CZbCIqZuXg93Glrku9tM=
X-Received: by 2002:a25:b78b:: with SMTP id n11mr19558994ybh.376.1586658372285;
 Sat, 11 Apr 2020 19:26:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 11 Apr 2020 21:26:01 -0500
Message-ID: <CAH2r5mu1iahVN8nRxPs1Pxu0m+XuMo+ePaKQph-xsbKuTfgbZQ@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
645c248d6fc4350562766fefd8ba1d7defe4b5e7:

  Merge tag '5.7-rc-smb3-fixes-part1' of
git://git.samba.org/sfrench/cifs-2.6 (2020-03-31 14:30:10 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc-smb3-fixes-part2

for you to fetch changes up to 4e8aea30f7751ce7c4b158aa0c04e7744d281cc3:

  smb3: enable swap on SMB3 mounts (2020-04-10 13:32:32 -0500)

----------------------------------------------------------------
10 cifs/smb3 fixes
  - five RDMA (smbdirect) related
  - add experimental support for swap over SMB3 mounts
  - also adds fix which improves performance of signed connections

Regression testing results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/343
----------------------------------------------------------------
Aurelien Aptel (1):
      cifs: ignore cached share root handle closing errors

Long Li (6):
      cifs: smbd: Merge code to track pending packets
      cifs: smbd: Check send queue size before posting a send
      cifs: smbd: Update receive credits before sending and deal with
credits roll back on failure before sending
      cifs: Allocate crypto structures on the fly for calculating
signatures of incoming packets
      cifs: smbd: Properly process errors on ib_post_send
      cifs: smbd: Do not schedule work to send immediate packet on every receive

Steve French (3):
      smb3: smbdirect support can be configured by default
      smb3: change noisy error message to FYI
      smb3: enable swap on SMB3 mounts

 fs/cifs/Kconfig         |   2 +-
 fs/cifs/cifs_debug.c    |   6 +-
 fs/cifs/cifsfs.c        |   4 +
 fs/cifs/cifsglob.h      |   4 +-
 fs/cifs/file.c          |  61 ++++++++++
 fs/cifs/inode.c         |   4 +
 fs/cifs/readdir.c       |   2 +-
 fs/cifs/smb2misc.c      |  14 +++
 fs/cifs/smb2proto.h     |   6 +-
 fs/cifs/smb2transport.c |  87 +++++++++-----
 fs/cifs/smbdirect.c     | 313 +++++++++++++++++++-----------------------------
 fs/cifs/smbdirect.h     |   7 +-
 12 files changed, 272 insertions(+), 238 deletions(-)

-- 
Thanks,

Steve
