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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACEDC433E0
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Feb 2021 18:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8A2764E62
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Feb 2021 18:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBFS3Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Feb 2021 13:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhBFS3Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Feb 2021 13:29:24 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9050CC06174A;
        Sat,  6 Feb 2021 10:28:43 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id v15so11284812ljk.13;
        Sat, 06 Feb 2021 10:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=BiidCW4wV5eXIdnRn47SAnhjV05lGSBSg2/37p5Knr0=;
        b=F6jKLPOSRFDOYdd9ZdBTcA2Xzz4rPVfLdR5PV/BcGk4AatlNUWxmr/U8lhBn60oau7
         m0iQkb+cF/mkpUjqesUlfstei5nGXE4EwuKYNwiPLE8mMGNRJSc1A7UpS+7sO7zhi6jp
         GsPcaj6xt3tOSHpBUTMnr6toRFFRZpFrtyLYCQGvcl1XqgYubmSewipo7IkAS1nS8Fg4
         7ODbZ145M9+HxdazJabirIOOCi6OEAJMmHXUoKo95IkETPR/GJNO2R3rRZFGk7jugMCf
         chGUmqXfzodOL0rr8yBUNPfXFCv7HZwlZ4Mi8le0TH3ta/wpYbf2fj2Qx9XV1sf79ses
         tEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=BiidCW4wV5eXIdnRn47SAnhjV05lGSBSg2/37p5Knr0=;
        b=Uxaax5JwLWVL8cccD8OPCR2pRQ1Q8wt1WTm/BVNburZgABRn5fU52cCU4UD4EZ2hnl
         Oa6o9Iivv7c7/6FPtPn5pMwsWBcm/xNR+55ynT6KIuZDwJnzn54xIdjjWRTPy/dPG+WX
         bYudENP+BSuMgAs+GLB3J+sHj3lcYVtTFn9fJ02T+UVHDX//DHnZgIGS8WRcMHf6fams
         FhEgfSSRgtG4uMeLDMS1vog09wHGwRQmamVvKo29c7sBp3D/HtPGk1APE8MUVt97F3iw
         1IpK6qjiLqifoiu/KKeZzNOS7EQO6GCcbf2SMeIwCdzkXU8aFvus3kaII8kpH81gcKQZ
         3DSg==
X-Gm-Message-State: AOAM533nsaNd4isOM8SVyajhg5AkkRf10h+81YCdOb2RvFT2dUEjrXiF
        nJLt4NK41Mlwyi5lvJ4E8KHqBE8kyAnhO/TVHxAsqE3ajUAf3g==
X-Google-Smtp-Source: ABdhPJyHoAF7MXWGPwJnnmKQ9xDlepPowSf2WMQcAm3hhG0dGh6eIhwoyDsxrM65L8+gV2bmGgGsZzHR0KGPJkbqoZM=
X-Received: by 2002:a2e:9d8e:: with SMTP id c14mr6299753ljj.477.1612636121872;
 Sat, 06 Feb 2021 10:28:41 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 6 Feb 2021 12:28:31 -0600
Message-ID: <CAH2r5ms+1ZYrkBJvd9kuN0-tv1PTLzrHUxeGrhVOcEtHXkbqYQ@mail.gmail.com>
Subject: [GIT PULL] cifs fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
1048ba83fb1c00cd24172e23e8263972f6b5d9ac:

  Linux 5.11-rc6 (2021-01-31 13:50:09 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc6-smb3

for you to fetch changes up to 21b200d091826a83aafc95d847139b2b0582f6d1:

  cifs: report error instead of invalid when revalidating a dentry
fails (2021-02-05 13:17:48 -0600)

----------------------------------------------------------------
3 small smb3 bug fixes for stable

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/491
----------------------------------------------------------------
Aurelien Aptel (1):
      cifs: report error instead of invalid when revalidating a dentry fails

Gustavo A. R. Silva (1):
      smb3: Fix out-of-bounds bug in SMB2_negotiate()

Pavel Shilovsky (1):
      smb3: fix crediting for compounding when only one request in flight

 fs/cifs/dir.c       | 22 ++++++++++++++++++++--
 fs/cifs/smb2pdu.h   |  2 +-
 fs/cifs/transport.c | 18 +++++++++++++++---
 3 files changed, 36 insertions(+), 6 deletions(-)

-- 
Thanks,

Steve
