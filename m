Return-Path: <SRS0=8vOf=5E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452D8C4332D
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Mar 2020 04:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A4B4206D7
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Mar 2020 04:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1tKqnND"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgCSEvZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Mar 2020 00:51:25 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:42612 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCSEvZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Mar 2020 00:51:25 -0400
Received: by mail-qk1-f182.google.com with SMTP id e11so1256185qkg.9;
        Wed, 18 Mar 2020 21:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7fk/+QxBD56VKIEKurBU0QH83djSBt83PbELLkY6Dfc=;
        b=Y1tKqnNDn4aL/eiK9aD+2TTxYePBWdmg3ntC/AMPJ8JkjEG8EJF+CrN9zCLxXb7LkF
         uOMu8vLb81XiUS5XWshmrbY/XpUOeIOuvCyNSKNwE+VAcBYdbcLV5yABDcU4wiWto2y6
         5IylnHgjOBAqYn+mutYDLgjO3WdHozeRxJxFVZZdnNZYtxXrG25ZsRpCsIe6wOpysOGz
         /xYLi2dyU20PEcErVIgENvYvJaC9GLW5WC5mBXFQtwrEhPO6FaaZJPKkbClIqI93Xbet
         1zAyJPCHjw5RDNh+dT5jgNqQVqhzGKcqcD2Xcq6IqHqrhT20UFWXQN1vId/FZBZzAgo3
         vNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7fk/+QxBD56VKIEKurBU0QH83djSBt83PbELLkY6Dfc=;
        b=i8baEDyjKVy2Xi4KZqFMdbQt9ABWx12b5ckgjDryboP9xWpGqLbI1nHV5LsuAsRQqX
         xQlT1LreTSynR5bu8msIHJ9fsj5m7dUXS5RryX/Aa5+N3bPVNHjVb/MVZUqgrT9cC1d8
         pPZK+TIaQ3NouBiqX7/wJ/2KZBFCKNzsglHKZup6dlhHOhhgItaxUz7pnE9yC7aXndJG
         RBW7ZqyQvFtywyp5lTRNTNvEXP0pxu9y3NrNqz37GmZ/au9bYt0wxNc/R0aARfn95YWh
         J47tkCqrGMsJiwF9Vas4NY4VZNUc2Yd0IT22Q0zLonbn5nuUGPlh6CZcYSSkEZEFQjfH
         zCCA==
X-Gm-Message-State: ANhLgQ2/EYBBMLBJyv/u2B2Vopcf6yAyg7ztS3qeZMh5WD6h5qgqFREN
        tTy5OchS5Ix7TystLpX/HGrZuqpSfgn6xxRvjouk+dO4MW8=
X-Google-Smtp-Source: ADFU+vti6fNwCLQfSx4hYjXE02FphrC9q0B4cBPWlOsP5udPYUAUr3OaT91ApbbU8IemLFFupkupWhUaHeiZSfjeScI=
X-Received: by 2002:a25:e805:: with SMTP id k5mr1924778ybd.14.1584593483734;
 Wed, 18 Mar 2020 21:51:23 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 18 Mar 2020 23:51:13 -0500
Message-ID: <CAH2r5msOYEYH_YrSwGn6KYW83U0kyNS9U04xLgVFMx4xr32J1Q@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
fb33c6510d5595144d585aa194d377cf74d31911:

  Linux 5.6-rc6 (2020-03-15 15:01:23 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git 5.6-rc6-smb3-fixes

for you to fetch changes up to 979a2665eb6c603ddce0ab374041ab101827b2e7:

  CIFS: fiemap: do not return EINVAL if get nothing (2020-03-17 13:27:06 -0500)

----------------------------------------------------------------
Three small cifs/smb3 fixes, 2 for stable

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/323
----------------------------------------------------------------
Dan Carpenter (1):
      cifs: potential unintitliazed error code in cifs_getattr()

Murphy Zhou (1):
      CIFS: fiemap: do not return EINVAL if get nothing

Shyam Prasad N (1):
      CIFS: Increment num_remote_opens stats counter even in case of
smb2_query_dir_first

 fs/cifs/inode.c   | 2 +-
 fs/cifs/smb2ops.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
