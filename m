Return-Path: <SRS0=3VLN=AW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93525C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jul 2020 00:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E08E2076A
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jul 2020 00:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pCl4GdBC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGKAxm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Jul 2020 20:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgGKAxl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Jul 2020 20:53:41 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB26C08C5DC;
        Fri, 10 Jul 2020 17:53:41 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id y13so3488045ybj.10;
        Fri, 10 Jul 2020 17:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8piC8eyWkOL4tSqhN4DCNafK9zjiUyujtEU/DF7mbTs=;
        b=pCl4GdBCfP2RiUnHVj35H9f4FDBAwQzvdUXXFYFivrfp0vpvEyDh+2wlwVsm/iymIf
         FMY9S+DEcPerZ9nLkEikt1LoWxWTatFCE2ccIVD54U4AYN+7Y0zypyrhoIgV+Q2KNsZd
         W+zLQf1XHndAhWz9P+xDCS4+bqYAxBu7lZCmvPtlQ6HFk+yhx2iRFZYrbnvN/RpxmZDP
         LAbD9MQhgC+EYyLBXXRbCBC1Karr993BBetNEdHRwI6aiOMUQknRgw508Q7IJBTbXlIp
         4nvH7fpplQIzEFH240pJMsWB0HxY/EO2tKzK+GxYEExKPpYAuFHfVTPZgy4QfXhT91Nu
         vHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8piC8eyWkOL4tSqhN4DCNafK9zjiUyujtEU/DF7mbTs=;
        b=PJIKOv9+N3vLnEo96WEkZ7qC3gczautoUDQMoi/F3h+Gd86Hh0vuI3m+GQXOosx2jw
         38YLbdb4Zdthk4+Dkc/+/JgKoJind4wqm5R9Z9TuRpHV5NadoLNkZjsa1HaGS6cX+jwh
         9xAGLVkrc2SU2p1oMf0Zeif1qI7CYZrb0SLdr7NOEyRkiqlL1ogSpRCnpvgYLtABR+rC
         4qrtjYi7cauWfV1wBWDih7eXeQaEOH9iHqLt4t/OllvnptAthLsF1Wl7a+LpO0oqQJ/0
         JcO1yGgni/t/G7tFGjptLHHj5YrWkAG4coXZ9ddZTt6ZEjCb3/Q4FwT8W6d8+5hWoX7R
         paNg==
X-Gm-Message-State: AOAM5304QGHxl1uI6zHrIEpKRHAvcmb2LF01MifDf032LUpckHAN41yL
        3707l3RzT1vo/zqh/G1h66JPWpDXJwdKjDcLM6bN7nnH
X-Google-Smtp-Source: ABdhPJxIcZ6E5g4edXcDQA6TvUE0tBhjDPw9AR3J7Z9omst+GfasyAsfFtBIMzPe6HxKMFoVCWwACaDzayYq4vqjW+g=
X-Received: by 2002:a25:880e:: with SMTP id c14mr122297056ybl.376.1594428820878;
 Fri, 10 Jul 2020 17:53:40 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 10 Jul 2020 19:53:30 -0500
Message-ID: <CAH2r5ms400MbvDKxUg+Z8MsyVPwiL6ZEjZDUgXNwuQGR+yMYbA@mail.gmail.com>
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
dcb7fd82c75ee2d6e6f9d8cc71c52519ed52e258:

  Linux 5.8-rc4 (2020-07-05 16:20:22 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc4-smb3-fixes

for you to fetch changes up to a8dab63ea623610bb258d93649e30330dd1b7c8b:

  cifs: update internal module version number (2020-07-09 10:07:09 -0500)

----------------------------------------------------------------
4 cifs/smb3 fixes: the three for stable fix problems found recently
with change notification including a reference count leak

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/367
----------------------------------------------------------------
Ronnie Sahlberg (1):
      cifs: fix reference leak for tlink

Steve French (3):
      smb3: fix access denied on change notify request to some servers
      smb3: fix unneeded error message on change notify
      cifs: update internal module version number

yangerkun (1):
      cifs: remove the retry in cifs_poxis_lock_set

 fs/cifs/cifsfs.h   |  2 +-
 fs/cifs/file.c     | 19 ++++++-------------
 fs/cifs/ioctl.c    |  9 ++++++++-
 fs/cifs/smb2misc.c |  8 ++++++--
 fs/cifs/smb2ops.c  |  2 +-
 5 files changed, 22 insertions(+), 18 deletions(-)

--
Thanks,

Steve
