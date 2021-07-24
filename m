Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0135C4338F
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Jul 2021 22:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2BED60E77
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Jul 2021 22:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhGXVkN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 24 Jul 2021 17:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGXVkN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 24 Jul 2021 17:40:13 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57031C061575
        for <linux-cifs@vger.kernel.org>; Sat, 24 Jul 2021 15:20:43 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h11so6369355ljo.12
        for <linux-cifs@vger.kernel.org>; Sat, 24 Jul 2021 15:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=H4v++YduS8gJqiMebiwgJ3AmJHjUrroyJ/ncZ81sqpk=;
        b=pqj3o4qij23vCtFhkqDTgBoZxOUZneYHm69TWyVGl0/h6pY0Y/eCi+qxZiuSk9WE9m
         Mb3UUQeySEG6VWtlT5Ui1jHT6JevKCJh+Oup+ah836tupstYEE3SybdwKwec/meKZxJY
         9+sygGKbo+CGWXF2LUJw67zJwpqdfQHS/RZxGx/cEqcaLmMvm9y5geIoYg5QZgSNx9lR
         uYIxZPGofQgqaJkYF1xv4z5wPTmXJO74edoWSn49yG4vnisM1Evra4niFPG6GzOd8AKy
         ehXwPFeLTIdNmYhUD3ACBzQAV9pY06p07jC8zBnYG03NLolw31euZyM9dGyMQ8wyHIAY
         brQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=H4v++YduS8gJqiMebiwgJ3AmJHjUrroyJ/ncZ81sqpk=;
        b=L72eNq3DSstFVGG1jBhyHOcxflaD8QqLkRLnxY8zpOYBDd0CcZJxm/y3WlIxacvDcl
         lTDMFTDNHPrtVRYA4I0ovvmVJu+nhQAYl+y6XwcvxTGu+lwF7qLPefIcVpKFYuIhiHm3
         IiYxqH20bNVdw0Z5zdL0M996NfTFMlUBSQoxTtOnuxwfArp3Arn305gVgT5dd+kcO/sE
         CJBIqpj04KzipoS+jgQkyohqV5yetEHY8YAGCLreCqTni70FLG3SiJUhx5GAPuT0afth
         chgJ2U3ak0AeseW0mdZX5V2j972RIVsuTJ07lIQlklq0Z8L3C+ZRcPOuJzyasXDlHxuD
         fQrw==
X-Gm-Message-State: AOAM533EeUqAeC31+ZxniED0GwNetmZcF+/DEGQ6SMDnpWuA2cWPKmTJ
        huu5PFz1xeCcAEfeRpzA+V+4+U0R0+dubKhXz2AAeo52F00GIQ==
X-Google-Smtp-Source: ABdhPJxnXlE9CdWAfLo+f5wWAHqOVsj/s8xUwAI32zy8LlQCqf9GJrnTTklELPA3q8T1s1+VGNeYitXLv2tEb6LY92Y=
X-Received: by 2002:a2e:8813:: with SMTP id x19mr7505927ljh.272.1627165241139;
 Sat, 24 Jul 2021 15:20:41 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 24 Jul 2021 17:20:30 -0500
Message-ID: <CAH2r5mtnAgJo_C_=NRVU_Z6hZByLyv5EKedhr7NY7AcT7-KBXA@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
2734d6c1b1a089fb593ef6a23d4b70903526fe0c:

  Linux 5.14-rc2 (2021-07-18 14:13:49 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.14-rc2-smb3-fixes

for you to fetch changes up to 488968a8945c119859d91bb6a8dc13bf50002f15:

  cifs: fix fallocate when trying to allocate a hole. (2021-07-22
21:24:22 -0500)

----------------------------------------------------------------
5 cifs/smb3 fixes, including a DFS failover fix, 2 fallocate fixes,
and 2 trivial Coverity cleanups

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/734
----------------------------------------------------------------
Paulo Alcantara (1):
      cifs: support share failover when remounting

Ronnie Sahlberg (2):
      cifs: only write 64kb at a time when fallocating a small region of a file
      cifs: fix fallocate when trying to allocate a hole.

Steve French (2):
      CIFS: Clarify SMB1 code for POSIX Create
      CIFS: Clarify SMB1 code for POSIX delete file

 fs/cifs/cifssmb.c    |  10 ++-
 fs/cifs/connect.c    |   4 +-
 fs/cifs/dfs_cache.c  | 229 ++++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/dfs_cache.h  |   3 +
 fs/cifs/fs_context.c |   7 ++
 fs/cifs/smb2ops.c    |  49 ++++++++---
 6 files changed, 247 insertions(+), 55 deletions(-)

-- 
Thanks,

Steve
