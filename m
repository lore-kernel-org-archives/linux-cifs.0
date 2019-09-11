Return-Path: <SRS0=GFFJ=XG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F91DC49ED6
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 17:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131822089F
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 17:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jmntzmam"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbfIKRI0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Sep 2019 13:08:26 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:33238 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729137AbfIKRI0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Sep 2019 13:08:26 -0400
Received: by mail-lj1-f174.google.com with SMTP id a22so20763345ljd.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Sep 2019 10:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tna07XpIzMxnh+reULV6RuhjEeBoHMJURdlssbfwTV0=;
        b=JmntzmamN+t+iBpMF6d+eBHqqze69ECMBq6uGpIexqaT3D3a4GI2/tXnF04McvPvMy
         Nn4UcRvAD+6p9Ghc0Kp+5vj1xhu06geDd8ZfQw7l1pRhONL0WEdoMVKzLbQQ0Y5hxSw4
         9fuABINtc2IG7NgdN29chQ7VOx0eCaAnWbp2PFTNTTdcrfkytfp0VvEVpbuzelJCFMDl
         W1Vo+GxD787D8dXwhu4WpcTmaBm13TqFChKUS1D3DRlBBVRKYez2tlB/8IEPRIiWdJQs
         vIs6ipdTPN+gwSO+j2MwHDuHQQqnM7UHifHTe5fFywo3d0dH98LI5dAUGxboUyw/e1/c
         qUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tna07XpIzMxnh+reULV6RuhjEeBoHMJURdlssbfwTV0=;
        b=aGICXxxrZ6z+/tuo+eDw2Q+rkCjqTo2ATVMaH8gGp9VvhVHwMsQ9hGFw/tT/ubtglU
         OVLmpZZey1O6dGe/SNIvR1QkvAvppYQY6XHdespQuH4jNm3Av0WXL8o1E1R6ps/XxsC3
         4+LMJskKvEuZJeDyXgkMcGuVf5aEDLoKPaPKZ4YPQOy2ePzuVmHdsnDmB7QPGEQw7h05
         P+fIHbYhJ3wEEdFrZt/NOo4Bnwzl8CZc49WDc4TbP677Df1lhXc+3Kgj7cgv1iH3jrGJ
         FRtIeeVj4bAJWZaLMj3iTVhqyQqxl2TMGOYpD+TAfOS8AQODL2fWwO3JHx1Z9kLBSnF6
         RxvA==
X-Gm-Message-State: APjAAAU0kG7iNJS++uFzVDSKJ5uouaxvH/gfA2Z4Qxpzs86VkPlQ24HF
        5NcWxS/+/Yr2JPhi8atAjmygrqoWyVCZWgytmAsG
X-Google-Smtp-Source: APXvYqztFRo6QkS3b48p6DhOmP7HcRdjeWRiv13eqmSFI1qfFfItApTpcfHiFZOufFEOC3oVxjmcPvlUNxvKWzWHPws=
X-Received: by 2002:a2e:9012:: with SMTP id h18mr24248653ljg.45.1568221704018;
 Wed, 11 Sep 2019 10:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtFA5c5XxL6ohwyGqj=zPc0mUR1_VNvcMyhrZZJuwcBPA@mail.gmail.com>
 <CAN05THSjpqqgXgfvDndFyZS2TwyvKDCNMSfxxgMApQVECk=cSA@mail.gmail.com>
In-Reply-To: <CAN05THSjpqqgXgfvDndFyZS2TwyvKDCNMSfxxgMApQVECk=cSA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 11 Sep 2019 10:08:12 -0700
Message-ID: <CAKywueR6Z1QbkbA3RxXrBEZOvHxECnAGV1ko+DnLgTusv2tEhA@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Fix share deleted and share recreated cases
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

can this error code be returned on any operation?
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 10 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 22:26, ronni=
e sahlberg <ronniesahlberg@gmail.com>:
>
> Looks good.
>
>
> We also need to handle the case where the share is deleted but is
> never added back.
>
> On Wed, Sep 11, 2019 at 3:15 PM Steve French <smfrench@gmail.com> wrote:
> >
> > When a share is deleted, returning EIO is confusing and no useful
> > information is logged.  Improve the handling of this case by
> > at least logging a better error for this (and also mapping the error
> > differently to EREMCHG).  See e.g. the new messages that would be logge=
d:
> >
> > [55243.639530] server share \\192.168.1.219\scratch deleted
> > [55243.642568] CIFS VFS: \\192.168.1.219\scratch BAD_NETWORK_NAME:
> > \\192.168.1.219\scratch
> >
> > In addition for the case where a share is deleted and then recreated
> > with the same name, have now fixed that so it works. This is sometimes
> > done for example, because the admin had to move a share to a different,
> > bigger local drive when a share is running low on space.
> >
> > --
> > Thanks,
> >
> > Steve
