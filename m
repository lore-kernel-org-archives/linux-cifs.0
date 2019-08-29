Return-Path: <SRS0=gUrR=WZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BAEC3A59F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 22:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A64AE2166E
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 22:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9Y1eL+g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfH2Wyu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:54:50 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:39087 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbfH2Wyu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Aug 2019 18:54:50 -0400
Received: by mail-io1-f50.google.com with SMTP id d25so7755036iob.6
        for <linux-cifs@vger.kernel.org>; Thu, 29 Aug 2019 15:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hM5Dyei9w+qcZV8oLsIWBpAfkPKzBdQhWefXXjDWtEc=;
        b=I9Y1eL+gQyuqIeD9HtMpnTM/cQw9IUjYruTe2dwP5Na57weoPDskEr3PJPM1P4Y9Oh
         v7tMgh/O1d4pCRkGjhdqbGfYKwDYRoSkVUWCtsHmPL+Cg5trsNHzsVU7f1YpVGU1G4Z0
         SpzSutMNE25kImeXEL9Dk8IGcyrZe7vmdZAfm3S3wGPyJk+LnIgUGtbL6luyQN7s4ODw
         O3/sD+r1b7M8u7Z2MZtbO4lE63JVaTRs0xopxwvVQKv/pb+KYvOJJKaELyADndlxM3qT
         U1MEjd6sm+N/92hqWZBbjaZUHsbkAOay+HT+K6ihqKqhlweWNPaqXVE+ZS28sHMC8SN/
         whoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hM5Dyei9w+qcZV8oLsIWBpAfkPKzBdQhWefXXjDWtEc=;
        b=F3dTVbEI/QEVJqz2OqRKRbm21IcI1iQiSHsrb2q+yf7yIGfU75FxaDeYRa4sJxnrrO
         617EZFiX1xaJ90UBL3CcJS1oOODL3qRnmCh35vJT3GMZCcbqebbojzgzzjug9WgizBlC
         SB9QPGzx2s6Y9e31C13UF9+bk1+HSo/4TFhc59ANtY7FoB0snQeJpV+z3PQLaXdm+5J3
         c6BDYMKFPhloI063i5RKe5YJ2ekFRvDshdzI21X1ZhpebWrcNuSqy53FBqe4kTwXu+/X
         77PnFK96UUdnbARZPc2b/83xmGV/niNJfmSv/fLVWbTOlRtB5Qi0KNKbOEJMxGX7PWFZ
         Kcww==
X-Gm-Message-State: APjAAAWZF58s/VFN184Rix2a7DhJNCNeFL7wLeQetxBf9bcQE+qzSuq0
        tioNlZAEVYTIPJ3iXaeYfBAYSADBY9eIn2lAUAUrJxgbVro=
X-Google-Smtp-Source: APXvYqzdKdjakp3zuCqFlzdFAjxk3pZmms+4g6onx8IQkW2KCNUa2bybpJFcoZNGowa/nSgdWWE7qHMBeFQMJaLTvYs=
X-Received: by 2002:a05:6602:2510:: with SMTP id i16mr1471019ioe.173.1567119289383;
 Thu, 29 Aug 2019 15:54:49 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Aug 2019 17:54:38 -0500
Message-ID: <CAH2r5msAQiYEoNCSqQYv8vHO09hgNjt0ExS+e0tE4eNj6e9ALQ@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
a55aa89aab90fae7c815b0551b07be37db359d76:

  Linux 5.3-rc6 (2019-08-25 12:01:23 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.3-rc6-smb3-fixes

for you to fetch changes up to 36e337744c0d9ea23a64a8b62bddec6173e93975:

  cifs: update internal module number (2019-08-27 17:29:56 -0500)

----------------------------------------------------------------
a few small SMB3 fixes, and a larger one to fix the problem you
noticed for older cifs string handling.

When the next merge window opens up, we will send a followon patch for
the other, UTF-16, string handling issue you noticed.
----------------------------------------------------------------
Dan Carpenter (1):
      cifs: Use kzfree() to zero out the password

Ronnie Sahlberg (2):
      cifs: set domainName when a domain-key is used in multiuser
      cifs: replace various strncpy with strscpy and similar

Steve French (1):
      cifs: update internal module number

 fs/cifs/cifsfs.h    |   2 +-
 fs/cifs/cifsproto.h |   1 +
 fs/cifs/cifssmb.c   | 197
++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
 fs/cifs/connect.c   |  29 ++++++++++++++--
 fs/cifs/dir.c       |   5 ++-
 fs/cifs/misc.c      |  22 ++++++++++++
 fs/cifs/sess.c      |  26 +++++++++-----
 7 files changed, 135 insertions(+), 147 deletions(-)

-- 
Thanks,

Steve
