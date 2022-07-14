Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8D8C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jul 2022 03:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiGNDgG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jul 2022 23:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiGNDgF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jul 2022 23:36:05 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38F4113;
        Wed, 13 Jul 2022 20:36:00 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id r25so199012uap.7;
        Wed, 13 Jul 2022 20:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=U+qpFRa1HeRbz8NG9MAR7PLpNnnSy4V5b/F4NqboULk=;
        b=CN+WLXR4xRXoa1LoMBPTg0FPJ9AzYNtzaMnwaQgcoaAqPjyV1MMyXdrPNn8REwYpJQ
         6le/jJu3FKVk1pQFYf2Oqc7bMnqhrL7el6NvF4+C2pVD7IAwZDEikcJpL/1qGJ0rDZ4c
         AUewUKdzYQIV2bxdfpwBGcB9HJmmCaRtEr0KzQStxkkutuetcLCkJ+3tl+xfnr4J8fD5
         b4L4NwXmDYnt1yZCWIaPQM/rlGknt6x0RXxRt1QKTBp1yrFX2rOlq+r/7cuenQFYi1si
         piiTPwRQbZbP7CRLHR5+yVLyh48kCuS6nwsdz75lLqoEYtY43r0NpNtDXankMlsXSUW0
         /u7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=U+qpFRa1HeRbz8NG9MAR7PLpNnnSy4V5b/F4NqboULk=;
        b=HxIOLSGk898Kk2Du2yXVLjMyJcSf0YUg1EcT0XBV01SAEq/i5duYVvi+qK4AhyXFjv
         X3m0/cVBWrOrfoO+VXoWZ4LNDtaBa3wIaBrxXU1mJcaRmCq9hmfe/pG0jlTGnlQHXTpK
         7JaJ7LstSARDkS1/HPRjUFBc9R34ojO/A/Hk6H+TY9n1Yx6Yhnzqude4rCpjbxVIZn/v
         GfeNzSh+EPjem84xSbXhF/qUQaMQbcp+SPzR/ULvRV5/AW0SQ2FxePb5bZWYrla8ZGsf
         SlYH+PnEE9l1KVtZJ3lNDeEknHw+PgGpiAAY5tw0s8CQ71JmQpkIlIiDJh3dR4CmG31F
         oxGQ==
X-Gm-Message-State: AJIora98Xeg4SKcl8jUWugh2FadEPMvEDCbhgSzh5EwLVYGbNnngpotJ
        JDRn1YSUjaiwN6tzSNndScQb798mc6CjgUohRhurHBEpmACrdg==
X-Google-Smtp-Source: AGRyM1vAGp7PunRpLVyZsfckidNMFfFU0xCkj9poKtk9pyRFqjXrxp/R2hGjg+++kP6uwxEdM7YUvDnRA7JgWJc8hTA=
X-Received: by 2002:a05:6130:10b:b0:37f:a52:99fd with SMTP id
 h11-20020a056130010b00b0037f0a5299fdmr2648293uag.96.1657769759736; Wed, 13
 Jul 2022 20:35:59 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Jul 2022 22:35:48 -0500
Message-ID: <CAH2r5mtQwDNtprMOXog3Az8av3hjdFWOCVfk8xmaP4vKJO0tdg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

----------------------------------------------------------------
Three smb3 client fixes:
- 2 related to multichannel, one fixes a potential deadlock freeing a channel,
  and the other fixing race condition on failed creation of new channel
- one fixes a mount failure, working around a server bug in some
  common older Samba servers by avoiding padding at the end of the
  negotiate protocol request

----------------------------------------------------------------
Shyam Prasad N (2):
      cifs: fix race condition with delayed threads
      cifs: remove unnecessary locking of chan_lock while freeing session

Steve French (1):
      smb3: workaround negprot bug in some Samba servers

 fs/cifs/connect.c |  2 --
 fs/cifs/sess.c    | 11 +++++++++--
 fs/cifs/smb2pdu.c | 13 +++++++------
 3 files changed, 16 insertions(+), 10 deletions(-)


-- 
Thanks,

Steve
