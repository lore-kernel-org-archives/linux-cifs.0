Return-Path: <SRS0=hgbo=Z6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B27DC43603
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Dec 2019 05:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AFA2206F4
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Dec 2019 05:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjJOMnNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfLHFlS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Dec 2019 00:41:18 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:41710 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfLHFlS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Dec 2019 00:41:18 -0500
Received: by mail-il1-f178.google.com with SMTP id z90so9844818ilc.8;
        Sat, 07 Dec 2019 21:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zfMdFOoakf8Wg9qg01DxbmCM0vduPEB2PzzRtbTRZFA=;
        b=FjJOMnNXPP5YU6mOAjCI/idcOdYEu5BeqdkCwzXCIHPV1ivqKYigNOPi2/0haX4JMZ
         ft0TGLkI1/2ly90rMXydaaNXqM3OOGvoJ2V9ULcoEXGMtrTG6jAPMJPEQ/0onzJa26Dq
         WrgXkIzUIIwaCre6UUPnmAY1gOzHTOyzJOw+Bwq/2NoaPdAPFPaLZpyT/GhuKNamx2sE
         gK2itPMIMXgRiWnfoLbE6YEsXg9VCQo5QPcgvfjqTz6YsxpBY0i+8B1FJ/BFpQACAvHB
         LMPqwm5fBtGlwICScdGJgoYeqkjJSummYaiO7m0E6GgPZY1BDcDzuxFQrrYzcnVvSyeR
         DBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zfMdFOoakf8Wg9qg01DxbmCM0vduPEB2PzzRtbTRZFA=;
        b=ITAwGp6cwfhl0rVIV6Jpn5SI0iuO0JF1Ab8HErsl5pRfmy5wSz+VVGKv4Ps49Ppr8E
         IaCdaGvN9dNs2aBWR0YU0R6Tx2a/lmaS2Gi1KSltObvO7+vzCgQKEUpdBlSRw/QDe6j0
         40og8EGAxNnH3PVW48kP+G8rmls7fghhVXMUk9b1Cx+keGExnr2jeU4kT454c+p/K2+6
         BTiUPqfRxL0zu3tsXamFKNOnaykqcpxljB2HMjfbqHlO215M7cTphNyBHkFg5I55pqLr
         XuwzW/MWwZQpxOYLOOwseIR+DF9jA5xwRjX2sFN7Pi43xhSt3U7XVbKx8i0AMsxw3PUM
         +oVQ==
X-Gm-Message-State: APjAAAX2cSO/q+SD6dy/uwho8GB/gKHPzUYDOfd2UmSB7U39wMl2RCk/
        vRNO5VdMoZRZxhmHlOlyKhSMwjuQQOOvSFn6b83ncw==
X-Google-Smtp-Source: APXvYqxTT4JgxTIaDSPkefc1oUQdvE27nRxy8yvnTKO6Z2i+HMDktu+ZsDkQ33V6tSLYygOW6Y/QD3H7A+Vsm51bX8Y=
X-Received: by 2002:a92:4883:: with SMTP id j3mr4476364ilg.272.1575783677400;
 Sat, 07 Dec 2019 21:41:17 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 7 Dec 2019 23:41:06 -0600
Message-ID: <CAH2r5mvexWusg28E6jn7C-=_TFnnZC-MJB1JUh6zFqyapkPv8Q@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
21b26d2679584c6a60e861aa3e5ca09a6bab0633:

  Merge tag '5.5-rc-smb3-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2019-11-30 11:10:39 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.5-rc-smb3-fixes-part2

for you to fetch changes up to 231e2a0ba56733c95cb77d8920e76502b2134e72:

  smb3: improve check for when we send the security descriptor context
on create (2019-12-07 17:38:22 -0600)

----------------------------------------------------------------
9 cifs/smb3 fixes:
      - one fix for stable (oops during oplock break)
      - two timestamp fixes including important one for updating mtime at close
           to avoid stale metadata caching issue on dirty files (also
improves perf
           by using SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB over the wire)
      - two fixes for "modefromsid" mount option for file create
            (now allows mode bits to be set more atomically and
accurately on create
            by adding "sd_context" on create when modefromsid
specified on mount)
       - two fixes for multichannel found in testing this week against
different servers
       - two small cleanup patches
----------------------------------------------------------------
Aurelien Aptel (1):
      cifs: fix possible uninitialized access and race on iface_list

Colin Ian King (1):
      cifs: remove redundant assignment to pointer pneg_ctxt

Deepa Dinamani (1):
      fs: cifs: Fix atime update check vs mtime

Paulo Alcantara (SUSE) (1):
      cifs: Fix lookup of SMB connections on multichannel

Pavel Shilovsky (1):
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks

Steve French (4):
      smb3: remove unused flag passed into close functions
      smb3: query attributes on file close
      smb3: fix mode passed in on create for modetosid mount option
      smb3: improve check for when we send the security descriptor
context on create

 fs/cifs/cifsacl.c   |  42 ++++++++++++++++----------
 fs/cifs/cifsacl.h   |  32 ++++++++++----------
 fs/cifs/cifsglob.h  |   4 +++
 fs/cifs/cifsproto.h |   1 +
 fs/cifs/connect.c   |   6 +++-
 fs/cifs/file.c      |  11 ++++---
 fs/cifs/inode.c     |   2 +-
 fs/cifs/sess.c      |  32 ++++++++++++++++++--
 fs/cifs/smb2inode.c |   2 +-
 fs/cifs/smb2ops.c   |  49 +++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.c   | 128
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 fs/cifs/smb2pdu.h   |  21 +++++++++++++
 fs/cifs/smb2proto.h |   7 +++--
 13 files changed, 265 insertions(+), 72 deletions(-)


--
Thanks,

Steve
