Return-Path: <SRS0=Wa1n=VA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48758C5B578
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 04:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1997120989
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 04:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQ28720d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfGCEyM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jul 2019 00:54:12 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38310 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfGCEyM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jul 2019 00:54:12 -0400
Received: by mail-pg1-f179.google.com with SMTP id z75so535376pgz.5;
        Tue, 02 Jul 2019 21:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DqpD3h2st9Sdn15UZlDrREEMftIMjHnmGShgZxlvVfs=;
        b=bQ28720dvmM5xJOWY4S023DV73NXoU+/sOwuaFhDg125z87fa0D/zkk4/J8yX1BShj
         YKDFgyqPZ2QROm+kmehKMlPOGDCcD7DOZGbwY8wFzCHhR/CkByM/NDIt8WOGhxtH2JfW
         jrw5xSpV4qPT54cfH1eRPqNpMZwxrl9VKHIA8XlxOVuL2xbC4KtPRMDr/YfV0wyK6+kR
         dE5HVcBnFNW9DmW8isvl22SXBmYE7HeSROFLtDRM92l1sx+HzJ5bovN+LlXpIAQWAJXZ
         t3GUS5z/368y2rmC3inOKD9nrOpKB/Rt5wQzEAXwcej3js0IqI5sNgt6r/0BPEZxiy0w
         thtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DqpD3h2st9Sdn15UZlDrREEMftIMjHnmGShgZxlvVfs=;
        b=CZi6QvtJ6mkQR3LoG/cfjZbFW19Bjvd6iHTYOPAUu9VSDaoElM3YgUrO+TJI5V23cB
         MmEHdjA//MRrnxKD4Hws02AvY5OXTPpQVYhGLDai63/jSunGr3vSqdsjxrIf2bDACju0
         ZEBLYcNa9q8jSDPuhgwNoIILkIynWsW0sou7VF263ZnLVgbpaD4ndhnesSBSq73iT4YS
         sJ2O6fIjWpLggIAnO1DTclYc3ydDKaUbOF4ng9TqTMfQwtf0JyEwSynMf7rZIBc/MLLN
         k7fXBwht76AZSRkyWJGW0q4Ce9aR6u4BcxK0BKBVexptgLMttcFNaZmFVkVQppYTJotc
         Z1lg==
X-Gm-Message-State: APjAAAVc+gJDfdmQ1dHym4EzKHpIoNU0nMqKLFUjsHUpFyl2kCU15a+7
        tHWWUq6k+4heLLi9JdbblS3BNMipPxSYBW3lR1sLem8XBnk=
X-Google-Smtp-Source: APXvYqyoD+wJzCMG0fDaJjs7vHqHcagJs4wfOpGBGF5r/35xnNRkw5enBGSRd3llPAJTADWkU3m3KyRasULdyddjIac=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr9817632pjb.138.1562129651474;
 Tue, 02 Jul 2019 21:54:11 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Jul 2019 23:54:00 -0500
Message-ID: <CAH2r5mteWJHa9k9skOn6by1M2CYGAU9LubUE-61TH0_3Nbgm1A@mail.gmail.com>
Subject: [GIT PULL] SMB3 fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
4b972a01a7da614b4796475f933094751a295a2f:

  Linux 5.2-rc6 (2019-06-22 16:01:36 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.2-rc6-smb3-fix

for you to fetch changes up to 5de254dca87ab614b9c058246ee94c58a840e358:

  cifs: fix crash querying symlinks stored as reparse-points
(2019-06-28 00:34:17 -0500)

----------------------------------------------------------------
SMB3 fix (for stable as well) for problem found at recent SMB3
test event - crash mishandling one of the Windows reparse point
symlink types

----------------------------------------------------------------
Ronnie Sahlberg (1):
      cifs: fix crash querying symlinks stored as reparse-points

 fs/cifs/smb2ops.c | 64
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/smb2pdu.h | 14 +++++++++++++-
 2 files changed, 73 insertions(+), 5 deletions(-)


-- 
Thanks,

Steve
