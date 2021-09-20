Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30F4C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 04:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F73561056
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 04:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhITEz1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 00:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhITEz1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 00:55:27 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D69C061574
        for <linux-cifs@vger.kernel.org>; Sun, 19 Sep 2021 21:54:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i25so62785193lfg.6
        for <linux-cifs@vger.kernel.org>; Sun, 19 Sep 2021 21:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fH3fxn9UObRcCFDjac2kLzUpWgRN3G5LjILpuJzzNDw=;
        b=RFYTIzK2UY/e5DZl+tci+OSkuI+NOC2RiCbzI1pUfiLvris/4Ep3kAJSU3Sv6HgI9E
         I4u3eeBpcVPrc3fj4NULaN0k0tbSQUp5phkk8HZm3XWSI2tGELGwnXfYNCV7tRX0uY1j
         9VPejELHvgJemOL3NABJDQaAGcLylLPAawf8N+4yAwNmHC9WJnrJDfBfGZwVPyJIj946
         2k+9OuZidnAmCfXH1rxV9AdwQOWG3oJyrx6p82QHHdV/eK7ymm5cxjKGmkWpTwY6f7tA
         xve7KsaoznWCbcVlTZlMOnN1R0QaMH4IOKqrj1NjpjaARaXXNUWh3fw4GdpOEJfZSyuL
         fUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fH3fxn9UObRcCFDjac2kLzUpWgRN3G5LjILpuJzzNDw=;
        b=ynhX159R3Phn3Bu/lnsXXB9G/vGI5tWyVpxy2FEAJH7oFvw4U0C+N6B9DHM4GlrKLZ
         wOSllmmEoiR1q5Hr7xFHonFNaDPpEUf6GGSNF1l6OwQNx/RGeHmPh1MwWqnDVpNv9T2q
         xUanHcWJmZ7kCaRj3rrDM1SPvOAyOSKUxaa4JlpFL6EkWV0zTTr+KsgzTwKEAWh49Ar7
         c965oqT+09Bppt/WLnTXrCAyCf0fP05cWpNQobV4/5CAVGCYKgdAIyQoRuG8+LNQMMiv
         XxeIyjNaJHc4DplBfSaE3JLcWs+2F0UttYx9TeC/7w8IFxZKFnPxJ37pi784NQdW+FaH
         EXhA==
X-Gm-Message-State: AOAM530Gjj698JJo2yZVFAijBgvgvJRhgGlcEvEpG886FwQdH6CKk0kl
        D0NGgixMvvrLE6SwXBh5mxza4gEqe2agG6aeVOI=
X-Google-Smtp-Source: ABdhPJyY6287Ym4iIfdVNklcfba5b0vjH9D0YixpxUcDq+Hhd8kZehlS/ss/qlosLGBMdqS7CSw/eA1clEHYiaNkUNU=
X-Received: by 2002:a2e:a78d:: with SMTP id c13mr20801916ljf.314.1632113639196;
 Sun, 19 Sep 2021 21:53:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210918120239.96627-1-linkinjeon@kernel.org> <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
 <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com>
In-Reply-To: <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 19 Sep 2021 23:53:48 -0500
Message-ID: <CAH2r5mtf443CyrFgDR+S51ZfG8qPSGWn+pS7O9oZo=ey8i4v8g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add default data stream name in FILE_STREAM_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Patch looks correct - tentatively merged pending testing (and additional review)

On Sun, Sep 19, 2021 at 11:47 PM Steve French <smfrench@gmail.com> wrote:
>
> On Sat, Sep 18, 2021 at 9:06 PM Tom Talpey <tom@talpey.com> wrote:
> >
> > This doesn't appear to be what's documented in MS-FSA section 2.1.5.11.29.
> > There, it appears to call for returning an empty stream list,
> > and STATUS_SUCCESS, when no streams are present.
>
> I tried a quick test to Windows and it does appear to return $DATA
> stream by default:
>
> # ./smbinfo filestreaminfo /mnt/junk
> Name: ::$DATA
> Size: 179765 bytes
> Allocation size: 196608 bytes
>
> when I tried the same thing to a directory on a share mounted to Windows 10
> (NTFS), I get no streams returned.
>
> So it does look like default stream ($DATA) is only returned for files
>
> > Also, why does the code special-case directories? The conditionals
> > on StreamSize and StreamAllocation size are entirely redundant,
> > after the top-level if (!S_ISDIR...), btw.
> >
> > I'd suggest asking Microsoft dochelp for clarification before
> > implementing this.
> >
> > Tom.
> >
> > On 9/18/2021 8:02 AM, Namjae Jeon wrote:
> > > Windows client expect to get default stream name(::DATA) in
> > > FILE_STREAM_INFORMATION response even if there is no stream data in file.
> > > This patch fix update failure when writing ppt or doc files.
>
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
