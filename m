Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8387EC433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 18 May 2021 21:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5638661261
	for <linux-cifs@archiver.kernel.org>; Tue, 18 May 2021 21:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352643AbhERV4G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 May 2021 17:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhERV4F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 May 2021 17:56:05 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2561FC061573
        for <linux-cifs@vger.kernel.org>; Tue, 18 May 2021 14:54:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id y14so9728208wrm.13
        for <linux-cifs@vger.kernel.org>; Tue, 18 May 2021 14:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=XbCErt4LctkYW/9Iw7BeEUePx1m8qbNkcWQBr6yBn0k=;
        b=VGy58Mu1zRVzlBnRsS3qo9YtqAYk40+w4TUO+5Ve1DsmTN77hjaxqM/fYICT7KVdZT
         Bc7JORB7X9pnSNipsAU5jDx3OXze1SJNXwcWg9BtZPDYUOiwBcQMytVDj5CJaB/MrKp1
         u03gidCYF8PBm48mHeivnIvNmWXlFjyxEXupbyPTin/TpvTxhWJy0Tyu7Bwto6/aTxva
         ORgW5QWvN+jOeJMDQfTnuhNohz8SYDI1Y9KmYv6y+IruOcDNCLztX/VhSYWOIbczKCVN
         IuXTEuwsNr0inwREa4Vo4wiCSHSEkbzWkCbSJEaZLjB8hYGo6LLL6vjGVFnmjNN2gIfi
         VsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XbCErt4LctkYW/9Iw7BeEUePx1m8qbNkcWQBr6yBn0k=;
        b=XYGs0I44MmtLH8L+CcUQ62mwHazV1V4OhyOO2UGu1t2Bikc7WHOcEyRuD0zUmNYbAJ
         PbkvrrFnfU1pGyn4Q+ZUJ1qu2lptUKRx/urr4TXNj6BwCaOz8K8R9nYXsOeYErzD9UiA
         k9pFoVBH4G2vP3l0GigSMpHtU/WKDDYJXE2QcPP06mUKswlvtLd2SoLn3pvV+gX84tOD
         dnbiVNyVVoP9JJeu/aOQ83x446cc+sTh8TD/7MChjDY00lW5zYJUntLIq6xWQVB4Twd2
         HFvAnNKA0h3/ZG6ZZsYq0GrhZrq92Sj+lP0v9OGp/t6hQVtROJ5ovDpiClr7ehoq14qP
         U7Pg==
X-Gm-Message-State: AOAM531pYRF731cvMqnEpJmLr8Nf+1CabKShfMm71S71kk3sKqsdqbOp
        eaEbfm7b5KJSbdqupsz2DXK7kF4eJmjnPFM0vsQMU18eAMZE8w==
X-Google-Smtp-Source: ABdhPJwZjrsdmprf9/lD/jYwLloPf5paiwrJZVHJnendA0xutw7x7AVsYnr7CzYU13h5XS4Zv4OWVxMQWLfn//Wjp98=
X-Received: by 2002:a5d:50c7:: with SMTP id f7mr9986263wrt.189.1621374885517;
 Tue, 18 May 2021 14:54:45 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 18 May 2021 16:54:34 -0500
Message-ID: <CAH2r5mvKvWyKdJNOuiykJKm4mS0iHpNF+n=CnmuG3H9KFq8tyA@mail.gmail.com>
Subject: duplicated or invalid inode number issue with ksmbd?
To:     CIFS <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Anyone see this warning (e.g. in this case running xfstest generic/013
from 5.13-rc1 to current ksmbd cifsd-for-next branch)?

[  527.169926] run fstests generic/013 at 2021-05-18 16:50:08
[  591.432386] CIFS: Attempting to mount \\localhost\test
[  591.552999] CIFS: VFS: Autodisabling the use of server inode
numbers on \\localhost\test
[  591.553017] CIFS: VFS: The server doesn't seem to support them
properly or the files might be on different servers (DFS)
[  591.553018] CIFS: VFS: Hardlinks will not be recognized on this
mount. Consider mounting with the "noserverino" option to silence this
message.

-- 
Thanks,

Steve
