Return-Path: <SRS0=pVcL=6Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F15DC47255
	for <linux-cifs@archiver.kernel.org>; Mon, 11 May 2020 15:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07D18206CC
	for <linux-cifs@archiver.kernel.org>; Mon, 11 May 2020 15:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfga7ADO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgEKPxs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 May 2020 11:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729956AbgEKPxs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 11 May 2020 11:53:48 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAB4C061A0C
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2020 08:53:48 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id d1so238805qvl.6
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2020 08:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0cb/Qc3LtwJycA72mNCGKZZ8oO8lhLW57nsNKTNNQc=;
        b=jfga7ADO5VcYbEmeoLfADkpUluyMw13sQNtj42V3cuyKXA0APNVWkAkV+CM1SbshOi
         nAfFYOVtHgYhuphxyiDOk8mT0LBd5a17FDQDQsX3mGnY0WHNyrvGGJSZNZbR+XJirfi+
         qDnVV0WqqqA9sQvMk5GAJC/IbjzXs4zXOlh5gd/vdEEDM9u0XY7pn/JquEol1Iev7Foz
         xjyN1rLa/5MnlSBH0dSSK2icx5NkRl2jcTAGnWutmgl55urCr8TmVTDz80h04bjzHgkQ
         ffDArVlr3IGO+giIFs3euuQHdDqU+L3UPkpsmHZCL3epOm0vuz0fmCOzhqSPf1Y7Yd93
         lAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0cb/Qc3LtwJycA72mNCGKZZ8oO8lhLW57nsNKTNNQc=;
        b=N+grpCsbA14K4QKzv/vj35g1kMh2bP+TSZkKgq6CnQ94pEi4UmMJTqsLjFQhI6Ul3u
         OaJDBGnwzl1WpfCKpkKrK79QuDH5SxepNoo9SrzEhTKYZzLEH/i4v/RSzrhB0fs9Rg0+
         yNwJAgcb7W6HqEjtm1CqjECG3rmk9F4vqpTn2QX4nXKfn8UQZXSLpDSc0bTrm1B+ThLE
         gCrqnpGOJzhbrn7VStOVQHTB3PJCHDwacBsZnSvBL5TJxCRdVYOyGYwCrx5KD0l/a4Gz
         H9yfn1zFMMa63J/ANmvEgE7yaTHpX/5L8nyp0jq3chlH+yn+OMxeDxmvBKKlvEgtqrxn
         M/PQ==
X-Gm-Message-State: AOAM531XFoSGnanWcglLX1U58e6SHVOfQ/SNRUps1ciZHK9PRpEYu/Lf
        1zsM95SkyyjpHmlT3rk8T8uuh5b0T5tq8/V3yE5X4KQRJmo=
X-Google-Smtp-Source: ABdhPJxv66sJwksKhDsvzoLbENiBqNd0s0bImeXQXoJd7mogVVS9dj/dM7x/Vh47PS5HUV004b4O0NUjCMMLiUe3+/o=
X-Received: by 2002:a0c:e904:: with SMTP id a4mr3347689qvo.94.1589212427152;
 Mon, 11 May 2020 08:53:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200428032647.2420-1-ryanbarnett3@gmail.com> <CAKywueSWxHNKqZMhTGg_vHhCbfy46TnaQPb+Dwy6AEc5hyj4xQ@mail.gmail.com>
In-Reply-To: <CAKywueSWxHNKqZMhTGg_vHhCbfy46TnaQPb+Dwy6AEc5hyj4xQ@mail.gmail.com>
From:   Ryan Barnett <ryanbarnett3@gmail.com>
Date:   Mon, 11 May 2020 10:53:35 -0500
Message-ID: <CALq67GC7d+unOd6WMarCTxwytC5g3HFSMZHOvDAm6HGRSKG30A@mail.gmail.com>
Subject: Re: [PATCH] Use DESTDIR when installing mount.smb3 and optionally
 install man page
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

On Mon, May 11, 2020 at 10:42 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> Hi Ryan,
>
> Thanks for the patches.
>
> I think they are duplicates of ones posted in January which I haven't
> merged yet:
>
> https://lists.samba.org/archive/samba-technical/2020-January/134770.html
> https://lists.samba.org/archive/samba-technical/2020-January/134771.html
>
> Please let me know if you would still like any additional changes on
> top of the two patches above.

Yes these two patches accomplish what this patch does. Sorry I missed
this while trying to submit.

Thanks,
-Ryan
