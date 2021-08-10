Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA053C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 11:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9462B60EBB
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 11:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbhHJLrB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 07:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhHJLrB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 07:47:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669BFC0613D3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 04:46:39 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id bo19so10454558edb.9
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 04:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mcNqVm4/eumaXJjBSz1H6sCX/n9KRkIwyfLxxDJPOSE=;
        b=izm2RMCPVz6k910JYh3bnErAhhHZRG1+FSN1Uq+zQAzFaWdtVP3rkfA/6ehujw6C5n
         jlqqEMW9q78IfEoNq4PhNQWzA/DjFs/Xuz8wjyYK82oJUAbDD8qHDH88PwoJ5tW+s1wr
         J5Ww3STEBs/Idc3uWuuFDbodekD7WGlaaNdxcSWtoAPVYcIakGnMaShqFn+qh5zvxvBV
         RgU8bXJBxw6pkm7jjPpzK8ZZqJFaLIdNUbW+JfizWXy+/zL2ind5Pv1clT3TcKo2FQ2S
         NMwRKZ19mAFUHq/mOXzFhyUTCgvalNroHMvFHAY96VcV5djmfsBu2UzZinCYMiE+pMOS
         Xzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mcNqVm4/eumaXJjBSz1H6sCX/n9KRkIwyfLxxDJPOSE=;
        b=JTMNWWjD5Pqp6rb8dNSn7ssSONhnw7pC4ik73kPiVXIgw759VXxbHqP8ElwEMKUMSF
         KIDVvED1X6zQdSJrLNeVbM918jm45U2rIOiRGqhobCWmJ8YxGlzw6uVkJ9/MMwkzOnwN
         96JHTw9XSHCAAvv59P9JBmoBxjec0GaugwZWbe2+k49A5Tx+DiEV6I+5lVORYBDsag9a
         nMvaoV6MxPsFIhmheMkG5wF2hxmXgns8nMtuhZMJEVe3AKLvy8cn6fWr5S/OB/9i8/MR
         OA/J0lyU/hddX+HjTLIOxJ6Hnzdu0DXKsp9ESiVlq/2aJwatMg26HbP1myA0AR42xcVy
         8GWg==
X-Gm-Message-State: AOAM530/bwLudYaEyMbQDBM40S1QW5D4Rbc7j727CZt2QqIPWXti9z/A
        IhRlDQXrAJqzBX0R40rEgasegNhwAqsp7ziKd5o=
X-Google-Smtp-Source: ABdhPJyEdcgen0tvqR3814AYcztCjuRBGffbldJ3ALuTLsEMqwoT4p3TjbSTF8rfQzSEFbaAF0uS0BwzvoXda5HI/WA=
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr4406106edd.47.1628595997979;
 Tue, 10 Aug 2021 04:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms3XvZSLbAOb7irrZpS0aFsDUW59qRDdN19H8ZaR_YX+w@mail.gmail.com>
 <CACdtm0YKX0AK6axj+QnpG9cd1ee-3D9jreo567vK+Raf8B0MQw@mail.gmail.com>
In-Reply-To: <CACdtm0YKX0AK6axj+QnpG9cd1ee-3D9jreo567vK+Raf8B0MQw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 10 Aug 2021 17:16:26 +0530
Message-ID: <CANT5p=rkhwZgNL_v81rMLJXZPh_bojzH6eAwkEPn4LizK2vozQ@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Handle race conditions during rename
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I see a memory leak of dclose in cifs_close. I hope that's the one you
were referring to earlier?
Also, we'll need to avoid cifs_close_all_deferred_files in the future.
Maybe not for this patch.

Other than that, looks good to me.
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

On Mon, Aug 9, 2021 at 3:54 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi Steve, All,
>
> Have updated the patch slightly with null check to avoid kernel oops.
>
> Regards,
> Rohith
>
> On Wed, Aug 4, 2021 at 11:13 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Lightly updated version of Rohith's newer version of his deferred close fix (fixed minor checkpatch issue and added cc:stable #5.13
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Regards,
Shyam
