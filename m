Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC72C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Dec 2020 18:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A35E229EF
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Dec 2020 18:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgL1SJA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Dec 2020 13:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbgL1SJA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Dec 2020 13:09:00 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62B0C0613D6
        for <linux-cifs@vger.kernel.org>; Mon, 28 Dec 2020 10:08:19 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw4so15158004ejb.12
        for <linux-cifs@vger.kernel.org>; Mon, 28 Dec 2020 10:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XdjCWsVqKTptkSYnh95GnXpWGsLEAU7BneOLOcIK1qY=;
        b=hNzueuh5XWVqGUJH25OR2mBMKMuFPCC0iiSPkB/j1tyXp1xOm4ww7qIvoPg+7zS69R
         uJRHrDjIUoC3y0wYwPV3YZ9AQlCTd0D1QrMncnSzS6rVIiwe2RPjC14nKOurwC4HrtE4
         pgxbEyAYPJISM3V7SASfn4U8JZs63ui5DDTJn1Wrm4llH78YcYfVJLf0RTrHqFi765kn
         U3mWPebjsLx+lxFn4NcbUl1asVe/LDV35tZ4fmHmkYDa6zAvJ/FdFU3Whd40Mms1VEsr
         LHAYOi9itMtFdLpNqpJWTbWcqU/NQbFJZqrMbSNUWpzZsRwkglm2/EPE+aWxjUOoH/Zl
         +hTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XdjCWsVqKTptkSYnh95GnXpWGsLEAU7BneOLOcIK1qY=;
        b=c+cCon4llwOCRUL2GS9UryD2vap/KPawvXtqNo8i3LhKlimpJzMM8B2IX6QUZBqAM0
         7pkTAvfNYGizwQKCtAY6qaE7AQPxZxXSnYLOPdax2aQ3NS+jqm5IOEznWLkrLihIh3QT
         HVnj02J1uI3wxf/eP1qQzwEieNeCYneUi4QtU+AxbSKTECU+tLoVptGKssGTNtQQegHm
         OFHMMrgquOgAto4hRRBghts/GrF+jlofrPlcKelHzXavdVGC68xsQCzL/1HQs0d1BHCa
         OQhYnxzCHt3ljkOy8H2WRcHfaX89zFaNjkjAoxK7Vz6yYyzVdizMXdw61EvbeMhuQ7Z/
         phQQ==
X-Gm-Message-State: AOAM531wfS9kmor8X1kY/FkOT220+YDecveA9sDB2ZRPzK3uBjx/3bhi
        qhZ3JtXPvn+yWCmNpuIVxm0VvmTU6R8D7/9wxJMoELQEvZKy
X-Google-Smtp-Source: ABdhPJyGTXEoup+YwzvoPMaUmGhpzl9bKNVgK+0Cs22cIu0OrTsCEh+rod9FV2Zn+i+WF7caklOv8gFb8OesOqyuLHs=
X-Received: by 2002:a17:906:4146:: with SMTP id l6mr43089771ejk.341.1609178898482;
 Mon, 28 Dec 2020 10:08:18 -0800 (PST)
MIME-Version: 1.0
References: <20200609180044.500230-1-sergio.durigan@canonical.com>
 <CAKywueTDHV112-y125ROPK2aa+w6A1Fd_4x82YVEU6LauaAS9g@mail.gmail.com> <875z4ug4ax.fsf@canonical.com>
In-Reply-To: <875z4ug4ax.fsf@canonical.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 28 Dec 2020 10:08:07 -0800
Message-ID: <CAKywueR6hUyUt+RWbQi6rBDLWYun08aXgPa3VyXD+V5u-w5ZkA@mail.gmail.com>
Subject: Re: [PATCH] Separate binary names using comma in mount.cifs.rst
To:     Sergio Durigan Junior <sergio.durigan@canonical.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Sergio,

The recent release included only a security fix -- see details below:

https://lists.samba.org/archive/samba-technical/2020-September/135747.html

I am planning to make another release soon which will contain all
patches merged into next branch:

https://github.com/piastry/cifs-utils/commits/next

Your patch is already there, so it will be included into 6.12.

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 21 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 14:52, Sergio Duri=
gan Junior
<sergio.durigan@canonical.com>:
>
> On Friday, August 28 2020, Pavel Shilovsky wrote:
>
> > Merged. Thanks!
>
> Thanks for the reply, Pavel!
>
> I'm writing because I don't see my patch merged in the git repository.
> I noticed that there was a cifs-utils release recently, and
> unfortunately the patch wasn't included.  Can you double-check this,
> please?
>
> Thanks!
>
> --
> Sergio
> GPG key ID: E92F D0B3 6B14 F1F4 D8E0  EB2F 106D A1C8 C3CB BF14
