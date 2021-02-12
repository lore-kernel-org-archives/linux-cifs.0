Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9FCC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 20:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E215264D9F
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 20:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBLUkC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 15:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBLUkA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 15:40:00 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AB6C061574;
        Fri, 12 Feb 2021 12:39:20 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id g11so574138ljj.7;
        Fri, 12 Feb 2021 12:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQ1O8bncsueslh26Dm2w+TWZRzofaFWT1yqYHNMD4cE=;
        b=L2YMJbAVwCKp9eh2IdDtFd8wqkCnGcewCJ/by/085tPkPIfjp4/qCWOj/dEy5EnRyJ
         p7zkf9EY/OzEyxnE4g6qTK0ngpJzAqK3QNOxxyCYh+I7oG6v9ToTfZk2jhbAVtg0CC3l
         RBCF6bpP42RAM/ePRz8xdBoSJgYlO2Q9S7GdWid2jsmkcJFNPtJNEyDfdHLyAO+glHEx
         B2xULei10dLvKCEYNz7Hcv4pRW7ughpn7ccxrtw4j/7Hs24gK8whCcjSpllMgSmty5Rt
         LydwUwBoIzeTevFPaN/GVgIQoBF9N8xZ6ZFgUXPGMtFMR4Ew8Awiw148LtXibJCGwxA9
         MzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQ1O8bncsueslh26Dm2w+TWZRzofaFWT1yqYHNMD4cE=;
        b=bHPNk+xIrIIvp43CxSqjgHCo8v5Pl8U9Nem+RmAzIfNn4H64xJvt8WTPlF4opB2YZ/
         EZfE/XbNjC5A0n30ZiTap0dJW2R0YlIBLg7uwu0XOzuAbcurldsBPo38/zaJOeikIiah
         KkrRbfYeJwDy7pU6lXMnzTaZr0YEQY41C+F+l6lGIFtmDICpHQFxo3W7b9NQyiVvbA/6
         H/Gb5YJYgUOCoZ+bRJQD24cJtVOLsIAZZ9NdfrDS+c2AnbTOBl9XK3kq0xR0+OtZx/WD
         2j+Tx/1pvLaUcjK6ziFlTeXywPP0O8MBfpcATBPUBZbGCYyQBNTysFqTHYlTu04BCUHU
         t3CA==
X-Gm-Message-State: AOAM533n0XGLA9vT6cpLQ58V2nZdy/MBDMgiHx3P5SIyuTxgsJAIUjxr
        V+UzXSf6pYbf9Sql607pCiyd7W56/NwlH9sEuddYZHfFV/U=
X-Google-Smtp-Source: ABdhPJy+6Y/9rSv1SocMi1oC8r7d5lBU0tCCa4M9Y3OOk9z1nF2vFLVCbWXkCyg2XpmVuYywmT33o7i5+xdBiutppPs=
X-Received: by 2002:a05:651c:3cb:: with SMTP id f11mr2668505ljp.272.1613162358638;
 Fri, 12 Feb 2021 12:39:18 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
 <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
In-Reply-To: <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Feb 2021 14:39:05 -0600
Message-ID: <CAH2r5mtj+-xGDy-YN0JwSJAsgvB+HpQFCBi-zdTNXTRBY_Mteg@mail.gmail.com>
Subject: Re: [GIT PULL] cifs fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        =?UTF-8?B?QmrDtnJuIEpBQ0tF?= <bjacke@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Metze/Bjorn,
Linus is right - samba.org is down for me (I also verified with JRA).
Any ETA on when it gets back up?

On Fri, Feb 12, 2021 at 2:05 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Feb 12, 2021 at 10:16 AM Steve French <smfrench@gmail.com> wrote:
> >
> >   git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc7-smb3
>
> It looks like git.samba.org is feeling very sick and is not answering.
> Not git, not ping (but maybe icmp ping is blocked).
>
> Please give it a kick, or provide some other hosting mirror?
>
>            Linus



-- 
Thanks,

Steve
