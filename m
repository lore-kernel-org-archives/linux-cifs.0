Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AB3C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 23:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC841218AC
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 23:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jnrIjdh3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfCOXje (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 19:39:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42473 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfCOXje (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Mar 2019 19:39:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id r15so4604933pfn.9;
        Fri, 15 Mar 2019 16:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ieiWMsHRfGRpU22N8QrO5nSbBviY91mvVJqNPmZ+hH4=;
        b=jnrIjdh3RPF4jQXt5KlgDiVsS/fJuonLz7nvw203otB6LyzXrE8hkpsO0FXdS+b4F3
         aDUqOPewqPAWEswFf00zZPpwv+elvcj25vdib+73qbtQ7vA+j+dw78A0156nAqvnpx+M
         cmcljjkMcKpapaiFtsAV0XnZGsKYa1Abh2N3Vo8luRfDH6x/1tBOanAcngodlmKQdvoO
         rr1r+z6Uwb3Y/avGTvTRKoM8PiknZwMEeE7bKVJGmvXd6K+Y2kRQb7WOGGnv2mEsNL+9
         5iGcEFei5gtRApSSafB3+lFweQVCK3UaUrt6jH4D9Pr3K0DMHZVi1Ubr7j1zkM9ODYV+
         G+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ieiWMsHRfGRpU22N8QrO5nSbBviY91mvVJqNPmZ+hH4=;
        b=PgsOgWhwvcsla/jZV96FmJoIeuZpGeSc91R/nWYXukN8BuGXdmR8TpZM33NAmD9Y1q
         pGBBDAawcgPySHytzDhNZKM2V3Gsu7wM721B5kwypTAILF82jQ6ZWorWkQ2SY3ypEhwz
         gP2VK24s7gNVEfXbAPXqhlryHQxekwewyQZ0gnCfMKIol9c9iaEUld97q6ab2wz3J8Ds
         0+zFcz+QERdzBM61lmoTganWKT0wOX0G5Ck/0ZFryhXrEOmnmCqfj7nA4qdRTAV/h56R
         wmUQcFxjSmYtFkyN5MsS3XyhQ9J7DtPEAx/t1zvtpw0PMxtrNBPTWX9sEGuTXGEuvatl
         rTZw==
X-Gm-Message-State: APjAAAUI0TRlIF3wS1jVmqx6iLVianYjEbmkhlkV5b4I/bS07nPDFdOg
        qZStwwXVQBnvH+jrOLLUHm9YyWCIdE0Nompa1E+SavNx
X-Google-Smtp-Source: APXvYqy5lhcfE8A+eviAGyGMSxeX3CsHfum8ufqS0RLrPFy7N5baxhFXYYNvmN59qsTXdIYPinMAzbdIPuRtjJGShMA=
X-Received: by 2002:aa7:8d42:: with SMTP id s2mr6749881pfe.116.1552693172864;
 Fri, 15 Mar 2019 16:39:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 15 Mar 2019 18:39:21 -0500
Message-ID: <CAH2r5mvDGcGD=GP+-5984DJ9U_cYLWvkMsJORX4LZ7_1sVKpgw@mail.gmail.com>
Subject: [GIT] SMB3 Fixes and debugging improvements
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
f261c4e529dac5608a604d3dd3ae1cd2adf23c89:

  Merge branch 'akpm' (patches from Andrew) (2019-03-14 15:10:10 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc-smb3

for you to fetch changes up to bc31d0cdcfbadb6258b45db97e93b1c83822ba33:

  CIFS: fix POSIX lock leak and invalid ptr deref (2019-03-14 19:32:36 -0500)

----------------------------------------------------------------
- Various additional dynamic tracing tracepoints
- Debugging improvements (including ability to query the server via
SMB3 fsctl from userspace tools which can help with stats and
debugging)
- One minor performance improvement (root directory inode caching)
- Crediting (SMB3 flow control) fixes
- Some cleanup (docs and to mknod)
- Important fixes: one to smb3 implementation of fallocate zero range
(which fixes three xfstests) and a POSIX lock fix
----------------------------------------------------------------
Aurelien Aptel (2):
      CIFS: make mknod() an smb_version_op
      CIFS: fix POSIX lock leak and invalid ptr deref

Ronnie Sahlberg (11):
      cifs: change wait_for_free_request() to take flags as argument
      cifs: pass flags down into wait_for_free_credits()
      cifs: wait_for_free_credits() make it possible to wait for >=1 credits
      cifs: prevent starvation in wait_for_free_credits for
multi-credit requests
      cifs: add a timeout argument to wait_for_free_credits
      cifs: simplify how we handle credits in compound_send_recv()
      cifs: cache FILE_ALL_INFO for the shared root handle
      cifs: add SMB2_ioctl_init/free helpers to be used with compounding
      cifs: fix smb3_zero_range so it can expand the file-size when required
      cifs: fix incorrect handling of smb2_set_sparse() return in
smb3_simple_falloc
      SMB3: Allow SMB3 FSCTL queries to be sent to server from tools

Steve French (9):
      smb3: display security information in /proc/fs/cifs/DebugData
more accurately
      smb3: add dynamic tracepoint for timeout waiting for credits
      smb3: display volume serial number for shares in /proc/fs/cifs/DebugData
      smb3: Add dynamic trace points for various compounded smb3 ops
      smb3: add dynamic tracepoints for simple fallocate and zero range
      SMB3: passthru query info doesn't check for SMB3 FSCTL passthru
      cifs: remove unused value pointed out by Coverity
      cifs: minor documentation updates
      smb2: fix typo in definition of a few error flags


-- 
Thanks,

Steve
