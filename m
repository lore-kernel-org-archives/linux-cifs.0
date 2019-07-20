Return-Path: <SRS0=Caby=VR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15D6C76186
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Jul 2019 23:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E6720823
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Jul 2019 23:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z93NoTb5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfGTXs5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Jul 2019 19:48:57 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:38472 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGTXs5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 Jul 2019 19:48:57 -0400
Received: by mail-pl1-f174.google.com with SMTP id az7so17352600plb.5;
        Sat, 20 Jul 2019 16:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4txvy5oDnjZXMBKDfkXdUhEBojkEGKCp/Hb3burilUM=;
        b=Z93NoTb55QnNE7TCl76DnA9HcbsQIV3no0rkznVHeOBeSJSmWPr2S+gOPlbogYBd74
         koRQ8ynWJiXDr9kbUenbrmHS3QyV5j+4ZT9TpZbWyaLrmwKYGj7IK4srNZcKUtIE0kEA
         vHZy6eBUvuDnonr+9hU46ywH+soQXbs8RqjiU60P8Y36x2uLua+i6OnbnBBpxRJcIFwg
         1Hza34WHuaiLHFrBjzvKYq8f9HNXsLO8NaR2U1G4GiISfn819SkNzmc/YOvG8brsck2r
         Bci5Nr0fvQU5s4+7fjfy3ZpeZdZha4Wq7KE08mO+YXo3lHMySRfK09bbOK3lHYL8tVhT
         b2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4txvy5oDnjZXMBKDfkXdUhEBojkEGKCp/Hb3burilUM=;
        b=ZYIQK88FN2dyZv9NOguIzFsRqh2X7AQZjVCZpJFaMFTt93jKanBhTJfVMg475KURNx
         aaVlC8vJVCrTqjojGSZd8LLuj55LIszW2z/1o7KuM2MSC6AcU6+0URjT2x9lPbjOj0S4
         U0RwKh//0KOJCZf8Jt+O84+Y24QC9orzIPaVo0sD28SdiQyYwXsn7pUlyEblrOSFIE9S
         4e+PEXvdALwaw+uMdjlZywRKIqg2c8KgDyaxeyCg5Y4XI38fRltSbTMyW1Lbl81cGtNI
         a22vVEZ8QH/FMvv6G+qGpuTvjAVzYriStFHqnYJwif+1oVMAlap7ynq8UtI8VxZBxNt7
         CWLg==
X-Gm-Message-State: APjAAAXce5w3T0TIbywufnMv9QQIk1n0UrVlfFhidSOsaoEIRV32ufGK
        hk2Pk58+8dGy68Phf95G+QnwAes/e0iccloldm7mTLHK
X-Google-Smtp-Source: APXvYqwCahxSGL0smQOraYyUVi+aiOBx4dGWbfjjp/FFnUcaoZIAMuUvfztXX/HwEAEU6WbhKQC47NIAFwbxuUtH2n8=
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr67141326plb.167.1563666536657;
 Sat, 20 Jul 2019 16:48:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 20 Jul 2019 18:48:45 -0500
Message-ID: <CAH2r5muOA_2qm+Ah4TDDUA7zUAzYLxpwX-+XLuY95kmRMiPB0w@mail.gmail.com>
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
ae9b728c8dc0a9939d89f84e8603258ca2a0df22:

  Merge tag '4.3-rc-smb3-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2019-07-18 11:11:51 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.3-smb3-fixes

for you to fetch changes up to 2a957ace44d4cf0f6194a4209d4fa67ee5461d8f:

  cifs: update internal module number (2019-07-18 18:14:47 -0500)

----------------------------------------------------------------
SMB3 fixes: two fixes for stable, one fix (copy_file_range related)
that had dependency on earlier patch in this merge window and can now
go in, and a perf improvement in SMB3 open

----------------------------------------------------------------
Amir Goldstein (1):
      cifs: copy_file_range needs to strip setuid bits and update timestamps

Aurelien Aptel (1):
      CIFS: fix deadlock in cached root handling

Ronnie Sahlberg (1):
      cifs: flush before set-info if we have writeable handles

Steve French (2):
      smb3: optimize open to not send query file internal info
      cifs: update internal module number

 fs/cifs/cifsfs.c    | 11 ++++++++---
 fs/cifs/cifsfs.h    |  2 +-
 fs/cifs/inode.c     | 16 ++++++++++++++++
 fs/cifs/smb2file.c  | 18 ++++++++++++------
 fs/cifs/smb2ops.c   | 53 +++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/smb2pdu.c   | 46 +++++++++++++++++++++++++++++++++-------------
 fs/cifs/smb2pdu.h   |  4 +++-
 fs/cifs/smb2proto.h |  7 ++++---
 8 files changed, 126 insertions(+), 31 deletions(-)


--
Thanks,

Steve
