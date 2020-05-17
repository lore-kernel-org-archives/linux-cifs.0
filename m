Return-Path: <SRS0=C+hr=67=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CE8C433E0
	for <linux-cifs@archiver.kernel.org>; Sun, 17 May 2020 02:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBB66206D5
	for <linux-cifs@archiver.kernel.org>; Sun, 17 May 2020 02:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORsaqp0/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgEQCqK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 May 2020 22:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgEQCqK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 May 2020 22:46:10 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5348C061A0C
        for <linux-cifs@vger.kernel.org>; Sat, 16 May 2020 19:46:09 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id x15so3341057ybr.10
        for <linux-cifs@vger.kernel.org>; Sat, 16 May 2020 19:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=M2uEvE5h9pbJzBgl8QgYK8mz1lNvTFs+wgziCEgILJU=;
        b=ORsaqp0/BsiDhuCA+yg2liTo/8Zu/QgTn7ZwkNuMOFos3+ImZbl7oUVxy5SXXnjuIC
         Tf3qYXDbnDBA1ydpY9jenbHgS4cBZPWz0OC+KMRUeguto8QrqXCYDCcLnaZ//8mEoEGi
         RlCpTTc11BaSpMSzYH7FfWgJ12iEVUzqWq9GhyXczJApBuYfjZb9dIC7nt33YyDcuWvN
         HezjAjDNTDViFlP3un+llNKIzyDpAep+h88SZ0v+1leRF1G60T/qaEac1UlMpivwluYd
         2tVGuyBsgqUYGRrdhl7X2obr+KyVefkiAuEdvbDWfyx+L8Boy+jFNNURzkPW7PQpNdZw
         aMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=M2uEvE5h9pbJzBgl8QgYK8mz1lNvTFs+wgziCEgILJU=;
        b=oIheU+uX9MOoCsSUdxSurPTVTzPYdw94242O5beltAcY941djsqUKh0WhJq5QBV8b8
         RWlUAz/Bc57MxenOgqvgj0EFOM2Ys5apWC6gt3DZblR5ZzTqbp5Eu1xEU/+/wBGhmrP2
         E8LeEafYnhj0gKFpXR1Fq1tHOFEy1ToY7PRaa8JCt2svOAr0sIGFqDRyTmkGBjvaHdlm
         cxa4T2ZSAU6fqOGaHzFQJlk3YnRCWu1RRsHhShUx+M1RY8kjWutD1DGW72RTzunqpm3F
         43D727IdkbmlYItTOnUbValGyA5cFKT1ak2qB+hOJRoue7A6/lmUa3lhGkFLqqY78/sT
         GUtQ==
X-Gm-Message-State: AOAM530sJ7YD/oc1d0gWJ/pDW6sWS8A4DqFn9Zjrx/VlSglsCwP+gf5+
        LfrcC1M5Ov7zBogFYqych1aeOUiPJRGecJsC6AGoH7nDVtY=
X-Google-Smtp-Source: ABdhPJy+8uUcd/BIbgBUAx2+1Y55WYTE0hpas9onfltyx1NvJrAphlxT7WL883AVIAo/cW/Qhfld6kTnftzaBp87MNg=
X-Received: by 2002:a25:cfc4:: with SMTP id f187mr15515951ybg.167.1589683568183;
 Sat, 16 May 2020 19:46:08 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 May 2020 21:45:57 -0500
Message-ID: <CAH2r5mtJLcARTXSEjNjWnDacyr4MEcJk6TxZCu2mFy-_38uQng@mail.gmail.com>
Subject: [GIT PULL] CIFS Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
dc56c5acd8505e1e7f776d62650f3850ad2ce8e7:

  Merge tag 'platform-drivers-x86-v5.7-2' of
git://git.infradead.org/linux-platform-drivers-x86 (2020-05-05
16:29:03 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc5-smb3-fixes

for you to fetch changes up to a48137996063d22ffba77e077425f49873856ca5:

  cifs: fix leaked reference on requeued write (2020-05-14 17:47:01 -0500)

----------------------------------------------------------------
three small cifs/smb3 fixes, two trivial fixes and one open refcount
leak fix marked for stable

Regression Test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/347
----------------------------------------------------------------
Adam McCoy (1):
      cifs: fix leaked reference on requeued write

Geert Uytterhoeven (1):
      CIFS: Spelling s/EACCESS/EACCES/

Steve French (1):
      cifs: Fix null pointer check in cifs_read

 fs/cifs/cifssmb.c | 2 +-
 fs/cifs/file.c    | 2 +-
 fs/cifs/inode.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


-- 
Thanks,

Steve
