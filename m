Return-Path: <SRS0=Uns9=TS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43915C46470
	for <linux-cifs@archiver.kernel.org>; Sat, 18 May 2019 03:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1586B21734
	for <linux-cifs@archiver.kernel.org>; Sat, 18 May 2019 03:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O28aqnJC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfERDhp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 May 2019 23:37:45 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44669 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfERDhp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 May 2019 23:37:45 -0400
Received: by mail-pg1-f170.google.com with SMTP id z16so4160879pgv.11;
        Fri, 17 May 2019 20:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=OM8pwcWcC1FGoW4dfmsYMsxUg+FgS1R/aDdR26qmmWY=;
        b=O28aqnJC3u+6XwLnAZZREUdByMbtkEhXPjqFit3ma36c76z1tnAIqmLPGje2CtuYQq
         jU2qI++x2kB+ulwqGHUeOuxXqwGkTaCLs2hv00qjDf4uMAuQRWCeT6a83ZSc98B3UzE5
         4IjRScEqG9xkXj+2ILNZW0sAfIF4VDM2WsSa11J0XogWpjl/QLNbA20sZcgaRGWxwbTo
         77HmlL42mlnDIoMc9x/kZ5iuStOc4TWjKeNODBOYGhOj64XNXTSkVkwfb7IvB0vRYeIJ
         iN2xgVPNUThuxzvs1Ds9F0GfRTMVqq2QhRXEIA4u0mJ9cpPkFTah86s8Uq2m3r2i+3yi
         0khQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=OM8pwcWcC1FGoW4dfmsYMsxUg+FgS1R/aDdR26qmmWY=;
        b=pmPVsr5+MRW0yKN+X7R4uCUkQ01Bv0zDQgv50lzexAyYVxBe1ogX82AwDBDjUovjsU
         lk+0jDcgTUauVOAmwsa2Rz9EMyfKMrAmg6j9SNQHDkIfCuHT2hYmm6pSfEIv0TmAVMb3
         IcLBnBgHjZVRkhwUJ8ABZCGP1rd84POpigfhRcwIFDDMDf+UG9KIcwJVayksYpraCcWB
         Ne9B8xmLu8dnubE01xt2CZtZDedoovNptD1D73eflf6yYHW2xBYSNnNMM0q3tPYwuHUK
         CLUOxiRUAZnsftY11hErucuTpGF/qOLNzpozg9ovUqSdGufMXcvNh34CRflwgcOcyN54
         1Bmw==
X-Gm-Message-State: APjAAAVWoUnz21Tm9q61iDbRgLwuJ38AQAwuf/NIvO9UwuXzGDzB+rPy
        Sdc7Wb/bADARC2wZZ5PyyDeeVjG9Z1uxm7Gdbvk4kA==
X-Google-Smtp-Source: APXvYqyUL2at8g6loPqY4hWfss78cxwdU0/jxRHyW1AUncUSQM/2bOOswHJOfKVJE+kMgx+PymPR8N6iJ+B+kzBB9lo=
X-Received: by 2002:a62:2b82:: with SMTP id r124mr56423074pfr.235.1558150664230;
 Fri, 17 May 2019 20:37:44 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 May 2019 22:37:33 -0500
Message-ID: <CAH2r5msEB_bvDTOPLwtoH0Ty6ttXhb3RP+18d47xNjN7q0apYA@mail.gmail.com>
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
78d9affbb0e79d48fd82b34ef9cd673a7c86d6f2:

  Merge tag '5.2-smb3' of git://git.samba.org/sfrench/cifs-2.6
(2019-05-08 13:06:18 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.2-rc-smb3-fixes

for you to fetch changes up to dece44e381ab4a9fd1021db45ba4472e8c85becb:

  cifs: add support for SEEK_DATA and SEEK_HOLE (2019-05-15 22:27:53 -0500)

----------------------------------------------------------------
Minor cleanup and SMB3 fixes, one for stable, 4 RDMA (smbdirect)
related. Also adds SEEK_HOLE support
----------------------------------------------------------------
Christoph Probst (1):
      cifs: cleanup smb2ops.c and normalize strings

Kovtunenko Oleksandr (1):
      Fixed https://bugzilla.kernel.org/show_bug.cgi?id=202935 allow
write on the same file

Long Li (4):
      cifs:smbd When reconnecting to server, call smbd_destroy() after
all MIDs have been called
      cifs:smbd Use the correct DMA direction when sending data
      cifs: Don't match port on SMBDirect transport
      cifs: Allocate memory for all iovs in smb2_ioctl

Ronnie Sahlberg (2):
      cifs: use the right include for signal_pending()
      cifs: add support for SEEK_DATA and SEEK_HOLE

Steve French (2):
      smb3: display session id in debug data
      smb3: trivial cleanup to smb2ops.c

 fs/cifs/cifs_debug.c |   2 ++
 fs/cifs/cifsfs.c     |  14 +++++++----
 fs/cifs/cifsglob.h   |   2 ++
 fs/cifs/connect.c    |  41 ++++++++++++++++++-------------
 fs/cifs/smb2ops.c    | 134
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 fs/cifs/smb2pdu.c    |  21 ++++++++++++++--
 fs/cifs/smbdirect.c  |   8 +++---
 fs/cifs/transport.c  |   2 +-
 8 files changed, 173 insertions(+), 51 deletions(-)


--
Thanks,

Steve
