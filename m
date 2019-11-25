Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8B0C432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 21:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E01822071E
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 21:07:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHHO70iZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfKYVHC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 16:07:02 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35375 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKYVHC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Nov 2019 16:07:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id j6so8573880lja.2
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2019 13:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=19ViBa4qAmj1Cg7ZiXWVGxTSGap+zt/B8Tz/+KDJ00c=;
        b=VHHO70iZAoDjoC+aFZEtj9nN088HeQhqXkBIV4P+/jlR/fKLBPH+Fs3Ya+pbju3BM2
         JIirFazM5ElrWgPywFfO1/YOmg/u8hL9fQVpUls7aVZEfmcgR7FDUv9CYDXZLISLPBou
         EvrJuRZCTcUkG+1WAfQe4Bel2uYehwR6J+k2C0+LAWwurqZcQ+Fr0nL+lRNGPO0eXW8u
         pRJQfk+yYmahAgd2nL2CYaaJUQJ7fdevSWVh9s8TCUvvYphPmOAvoScCMGyNEwbrvqV4
         zcZ8PzrD1QlMUnw+LWelJYT2f7tc1DbqpjuxrGk2LL7xTi8rlnGcEPqAKAiBvhjjmLaR
         aYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=19ViBa4qAmj1Cg7ZiXWVGxTSGap+zt/B8Tz/+KDJ00c=;
        b=kyCFRMUGb1EJ6EAiZup79vGrbp8p6JDVlicIGVIWfXni0MAuWyp5trtQIor/SFZ/pl
         N/Beh/VQm5yOhbyOqLTeuH+mY4F7x5gpnZbuisS1ySJ8obfzgEe9dGGv4EZwGI8MUz3d
         mmJePT7lJhTBGTzH62RNCYiOof91APWgiHFGTl+2qbQGvLnarhpIbtsEq/M3yozcDkRs
         1wK9UVamLfEqU0dZERdKFUND///RvpQlPqA+cctLEWuSn1PET465rOlgaGHUlvcCHnp/
         GQCRLqQQ0zshYQ0jB6JMVNPr5RL8rgt6wd324NkLtjL/vKAtQZH7ebT6YsdMYX2H1idz
         C7ig==
X-Gm-Message-State: APjAAAVHZQztRnBmg5gPetDBpYigVjw5QT/swHvtzByKEzi7A7vquMpf
        sjxc6QbbOaKVzDzvPQJib2LZXvUx9itHzq4ybA==
X-Google-Smtp-Source: APXvYqwlXd0OW8/vPnL/ambcKtRvUxojWkX+AmiF4l5mm/gOD4Dev84VXiWCq1XAHF2OH4d4z3+Cxjxyf4Z2xcUBT3s=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr24479822lju.51.1574716018758;
 Mon, 25 Nov 2019 13:06:58 -0800 (PST)
MIME-Version: 1.0
References: <20191125165758.3793-1-pc@cjr.nz> <20191125165758.3793-5-pc@cjr.nz>
In-Reply-To: <20191125165758.3793-5-pc@cjr.nz>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 25 Nov 2019 13:06:47 -0800
Message-ID: <CAKywueTb_RNZKgykwrfqYaPGirzOOjfKWEqkCK7ebGd=KRipAA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] cifs: Clean up DFS referral cache
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 25 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 09:00, Paulo=
 Alcantara (SUSE) <pc@cjr.nz>:
>
> This patch does a couple of things:
>
>   - Do some renaming in static code (cosmetic)
>   - Use rwlock for cache list
>   - Use spinlock for volume list
>   - Avoid lock contention in some places

Could you separate the changes into several (ideally 4) patches?  This
patch is huge which may be a problem when viewing the changes and or
bisecting for potential regression in future.

--
Best regards,
Pavel Shilovsky
