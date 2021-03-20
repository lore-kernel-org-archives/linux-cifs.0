Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194A1C433C1
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Mar 2021 16:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC45761966
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Mar 2021 16:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCTQTh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Mar 2021 12:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhCTQTH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 Mar 2021 12:19:07 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923CEC061574;
        Sat, 20 Mar 2021 09:19:06 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id w37so14680255lfu.13;
        Sat, 20 Mar 2021 09:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MjE8p8N6AtPJDpjXiZiJj0taGnUvpDrOn3GR8Bz5Jq0=;
        b=u1NyQ7Cmn7Tfs82lnywUoJl0+A2zZEu/2Vq91OTFAPUqRKEdNno8NWxL4/Q+WC/RBe
         WU2M6ZRNH2DWmZ/xTdXQ4ctgWEArxxeDWFdar7a6t2mlMLOIELEg1wl5EJc/Ujful5Gs
         DrLl88GWgklDtQF8vdDhH+WJQd8DuzSCbPCrE6pjVdZ4jx1e53Stjn9oMp/zTR+6J5aW
         wBAwX5yssZ9RLUyrmkXSiya3xjhThPh0txiBKcYaNUFLSmf0ILsWacIoRBqHTZFKNe03
         mK6tdz2CZKw+Jzoe0g2Ls7iWQyzwk7QnzQ8RmRaoYz/Hgv34hH9ZGKZwJwB4WkwzV6MX
         TFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MjE8p8N6AtPJDpjXiZiJj0taGnUvpDrOn3GR8Bz5Jq0=;
        b=SB+SJR6vMycwO1dt8ssuL1Ksqd3boJKihqszyFk8nFkuFc5N/27iqJK7CYvgsw94Vr
         sSIAP9ytm6Nc07xR7btRulEXsvYjpVbbZea6yL7h3WUnowXqp4MHM44SIh14iSCnwiUy
         8qf707ESq1ciF/WlKs3Kaxc7oPDb+5R2LVRv/UN6Q2w3QZAZKmbCV8iGgnBFb4J8Z4lR
         ouQ320Wj7/PJ/X9CAuZ0X3Eq0GaCxTJw0Z8ajbdEfM/6fweHkpX9LlYMfsuNkvS2a5Hn
         09gztp8p9dt94TiqfpfkTRlQEDi1sAb/U0H5cFmonclruyIAbEgjWrtERQJcm7Q6HHPj
         YzaQ==
X-Gm-Message-State: AOAM531TLeS0CyJqrLU1X0jqQ2DB9S4CScTODRdaYHzQT7r1iGJZRSnw
        h0Crh7kc8BODkkVfCHaWsH6HfRJWhvr9l9KndbPmVFyseeoOag==
X-Google-Smtp-Source: ABdhPJzGQ/YWgxTWu88BG3nv9Jt7ijtIGKqbyLH7RWT8xTb1tIlPTEcbfTsqhMwkEuoGEIhL6X5F6/N10/iwgVjPWko=
X-Received: by 2002:a19:7515:: with SMTP id y21mr4114216lfe.282.1616257144963;
 Sat, 20 Mar 2021 09:19:04 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 20 Mar 2021 11:18:54 -0500
Message-ID: <CAH2r5mt9Mj-gE4fhj4=bH9CyXuTa4er4T2OC5E+VgpacmR4zvA@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
1e28eed17697bcf343c6743f0028cc3b5dd88bf0:

  Linux 5.12-rc3 (2021-03-14 14:41:02 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc3-smb3

for you to fetch changes up to 65af8f0166f4d15e61c63db498ec7981acdd897f:

  cifs: fix allocation size on newly created files (2021-03-19 11:51:31 -0500)

----------------------------------------------------------------
5 cifs/smb3 fixes, 3 for stable, including an important ACL fix and
security signature fix

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/530
----------------------------------------------------------------
Aurelien Aptel (1):
      cifs: warn and fail if trying to use rootfs without the config option

Liu xuzhi (1):
      fs/cifs/: fix misspellings using codespell tool

Shyam Prasad N (1):
      cifs: update new ACE pointer after populate_new_aces.

Steve French (1):
      cifs: fix allocation size on newly created files

Vincent Whitchurch (1):
      cifs: Fix preauth hash corruption

 fs/cifs/cifs_swn.c   |  2 +-
 fs/cifs/cifsacl.c    |  9 ++++++---
 fs/cifs/fs_context.c |  6 ++++--
 fs/cifs/inode.c      | 10 +++++++++-
 fs/cifs/transport.c  |  7 ++++++-
 5 files changed, 26 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
