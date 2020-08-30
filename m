Return-Path: <SRS0=79/A=CI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A13C433E6
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Aug 2020 15:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BA0208CA
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Aug 2020 15:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1R6aWf4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgH3PYv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Aug 2020 11:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgH3PYr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Aug 2020 11:24:47 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52FBC061573;
        Sun, 30 Aug 2020 08:24:46 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id p6so790677ybk.10;
        Sun, 30 Aug 2020 08:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xPEmvOdyFWFWiXw0OzaZ2AdwbLQ6oITkLsywFrkSA6I=;
        b=A1R6aWf4Q4uUMuI28bQmYpT/5GFz6zhQW4A/XUVGvhDnPffnQSspF2HtchPc3/hoo6
         j45vOm7gwqkxg2iaWntVTLX5YPzzGpEyDvT9FHck4PGagwCAIp4fAldmNDwMQusRytNm
         u8CcPcw3iBlcBrdzrf+e4u77sYVqcGSXkQJknEqbrGdm8hyqWZAUJfJnq6Wkab74QW4i
         ktstaYbt/ciTgg1PJNz8CQzAVz5KPK6ku0+aw8VmKnGg/eQVuZATj0ag7yBve4RsY1zj
         g7cKnUh4h1Jb88e8BihE7V4gKn1o+unPu4o4TrQY+BUP6Zf0o67JGGypuegMRZOimuZM
         PIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xPEmvOdyFWFWiXw0OzaZ2AdwbLQ6oITkLsywFrkSA6I=;
        b=tIme9RugWBxRkao4NW9KqLTp365s4/PwYftQPuXAK+6AcsfAcQh/Xo7BFwd6C2EXAn
         UScP1v7ttQ6SodIHVqPBkAdgEojo9egqzk1xcisdoIg3UmQdaZqtFoiIhKEQvaKjbvNt
         wUnTVsCJXmZztLle97tSkCyjcnNQ8gYxeqys2JD1kaKBuMMOy4DTA8LpRT0YIeh3wzaL
         DEQ+Ia1vBmvcCILRf0RmalxJIOwv8ek7/0/LpyXYr5okLF2VC9h8HAtRkdy8W/Og3RDY
         WvGvLKDDfyC69aUMjo9aQPs7VHWpa06gd/aXAI2s101zypHtp+9Uq+py1gSE3ljmjIzn
         iFMQ==
X-Gm-Message-State: AOAM531ZmCIC49Vx92IcXIS6W9Rq8JyhT7rns7b48TX4edYUfN2uBHbj
        FMh9j5SDBhkC+nlLnszSzjItlVE6yFO+UqVvnJRFbKOJSkDD2Q==
X-Google-Smtp-Source: ABdhPJzIxMknA/9cGWu6XWa2J1gqfETqgv4UKVYpoPJJpNLTnthg0P59Q0GqxUmaBXJ5+qsrK+k21Fda9eEAYCLjY2Y=
X-Received: by 2002:a25:c606:: with SMTP id k6mr8470070ybf.183.1598801084119;
 Sun, 30 Aug 2020 08:24:44 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 30 Aug 2020 10:24:33 -0500
Message-ID: <CAH2r5mvs8Rdy_615XjMea7cCL1YrWthhr=GJW0ffTyDUwjtSrg@mail.gmail.com>
Subject: [GIT PULL] CIFS Fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
d012a7190fc1fd72ed48911e77ca97ba4521bccd:

  Linux 5.9-rc2 (2020-08-23 14:08:43 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc2-smb-fix

for you to fetch changes up to e183785f2529b4135f00a0330a3b08e7c86530c8:

  cifs: fix check of tcon dfs in smb1 (2020-08-28 12:27:33 -0500)

----------------------------------------------------------------
DFS fix for referral problem when using SMB1

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/386
----------------------------------------------------------------
Paulo Alcantara (1):
      cifs: fix check of tcon dfs in smb1

 fs/cifs/cifsglob.h | 15 +++++++++++++++
 fs/cifs/connect.c  |  2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

-- 
Thanks,

Steve
