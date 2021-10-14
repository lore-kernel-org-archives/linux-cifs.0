Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA6BC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 17:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDBA461166
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 17:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhJNRiI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 13:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbhJNRiH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Oct 2021 13:38:07 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7274DC061570
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 10:36:02 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id r19so29175450lfe.10
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 10:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1q2cwlwdjHHVayhRiCLIE4bMG2HYAMVNN1kvVEMrn4s=;
        b=dKdbWVwV5SAuRlHq95goCijvh7SkwKuP3Spwukflgejj+9BlPzWYLjmGY62qmWtk0s
         pn5UPriUmQ+9gXlRYFq6FzoVhYu+/GXxw/H3tfm4b/4BYpZCumjrAbzXD/SGtUfLR0ZP
         smM7nB7aZknCS1rmeiLiLbpldJe5xzc+KVotX2aWuAzs39dRjlLBdAVURmQ5vosLpl4v
         LFFKpHvTwnSVlTdS/tC/yQegb7Cd6XUOvdUYnH74nuDREss4a/mAw1yP+KITtvdfqmJ2
         2bnJwJDYsicx4reCppFFPtMmJ68RpxzwHOS7DKGRpoNfUCHFZuQXuKdyAzkLAl02icwi
         wJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1q2cwlwdjHHVayhRiCLIE4bMG2HYAMVNN1kvVEMrn4s=;
        b=xYc0qlmZn19WXLMahIzvT2PUrS8KL7Oado/EdkFCIf4xB2pOr/B97AS0l7/wfJih2d
         +oWwtUsk6EIb1/lTMJkYUKMWabdQtu5xM2/+1Sf39mD9Xur9Mzmz3fvuQWm3AdALuVib
         wkH8tm06BD0L1HMbgoJinIsbi2QfLaAmbns+CobenGVgMOFNobfhZcco8p6Fo/GZqQ9M
         EaFErN6lYp+227DNCNBIghXCNyNqrZ7vNCPlg6IvpNjA5N2FgHguEfb6qghMLyCpny21
         /yDpU+Svcjd/Gyf1y/ig6yTGQtrj1r0C4SwIJ9ToQZO8NNEq+eam9rO2y9qBqikjDgPG
         CJ9w==
X-Gm-Message-State: AOAM533do69iAaH0C8pRMzfhtoqy5dqwgj4hzSUiBLDjcIlqHMbPJCRc
        hXPRXliXlRUGGvw7obYdEqx3D2OOk7NR03yMedrkpxdB
X-Google-Smtp-Source: ABdhPJyyf3fcRWZ4FCxxz7H1e7ICTL7XYehoDJoqKb38TIOcOHmplISZunjanj4yEirB2aS/b9dnTa1v5o7K6MMrUf8=
X-Received: by 2002:a05:6512:3408:: with SMTP id i8mr6743771lfr.234.1634232960578;
 Thu, 14 Oct 2021 10:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qBKEj5Nz_5Vwj0WWL7-V_78j6Fry5OjvDXGCrejnsu3Q@mail.gmail.com>
 <CANT5p=ovLNLKwxsnik4pNkCbaznydWKAJz1AbBp6EhBy=nGTiQ@mail.gmail.com>
In-Reply-To: <CANT5p=ovLNLKwxsnik4pNkCbaznydWKAJz1AbBp6EhBy=nGTiQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Oct 2021 12:35:49 -0500
Message-ID: <CAH2r5mvWb4s22yN5adjnw14HGR11Az47WLk+UfKH_axuiB5r8Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: for compound requests, use open handle if possible
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged the two you posted today into for-next pending testing etc.

On Thu, Oct 14, 2021 at 5:41 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> I don't think this patch was taken. Can we take this?
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34c44cf16b97ee71b6d07720199b97ed328e7c97.patch
>
> Regards,
> Shyam
>
> On Fri, Jul 30, 2021 at 10:44 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Hi Steve,
> >
> > Please review the patch.
> > It fixes the issue of some compound requests unnecessarily breaking leases held by the same client.
> >
> > https://github.com/sprasad-microsoft/smb3-kernel-client/pull/2/commits/34bf1885b26db09a60bc276ea1a3f798f4cbb05f.patch
> >
> > We saw this yesterday when testing with generic/013 xfstests with the multichannel fixes.
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
