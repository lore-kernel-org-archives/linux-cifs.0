Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC817C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Dec 2021 02:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbhLACxX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 21:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241467AbhLACxP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Nov 2021 21:53:15 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABA6C061746
        for <linux-cifs@vger.kernel.org>; Tue, 30 Nov 2021 18:49:55 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o20so94690501eds.10
        for <linux-cifs@vger.kernel.org>; Tue, 30 Nov 2021 18:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iw8F/XtHawtUT8M2EQd6aY7L7/OuvAsRr6sTRuZIGfA=;
        b=nzmgRLhWljO4UsyZQFAt6lgXw3ZjvpBg9x145MjB33lViL1QtOgsoMNZfNBDYUrhBz
         zmB8/J42Pq7C86QuqGGVwexrrjIk4gLA861b3JYjvIiZHoiC90v8njsPyOuxLV6BFohu
         Oi/KgDGJ6CTyPrWb7xqYRwzoGXce75J+k3sMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iw8F/XtHawtUT8M2EQd6aY7L7/OuvAsRr6sTRuZIGfA=;
        b=GEkyMdAze02cmUVWFKmXKmRAgfi2AF1cv8FGq0CpNK66sQ9/q5IksBcghwuIVb4Joi
         dsCMNvxJiVQ0U3SpGbfyaxya8zwbmi7W76GVAPaqxonHvQVNfmSFTHq02/9mvfNgiyRB
         ABPWQm6D4MIAMq8xzEGmEnw0s4PFCe1rpAX5QM/9iMEaKWgaAQoOm5p1iZ86mtNmwGex
         oNQmIvnKnwTdueeOjTMJccWGbQsUQdi35iZfm36153jSHmAXrUDsfXatEzBfixnKHfzk
         WIuBExF2n2/tVp0+6goX2g6dDSoUlOyuwOLV4M+IbzCSVr54hew0ZntvX/MpLS1hVW+I
         9Fgw==
X-Gm-Message-State: AOAM531yMeyagaRZC56vjV9RgZym03N247ZFagjCD2XsNKuAnPe+j/HM
        +AF6IL6SRsMmM/hBzHhwvqUP/aVcn5WGo8pg00DZEQ==
X-Google-Smtp-Source: ABdhPJwfjXV2BDGXmhKtc8XLhWq4uXtziTnREWUbjhR9oE3KHJoqW4xvfXLNbtPUDk6Ee7clmDbt8kQ2E8dxOob/bIc=
X-Received: by 2002:a17:906:4fc5:: with SMTP id i5mr3636982ejw.475.1638326994405;
 Tue, 30 Nov 2021 18:49:54 -0800 (PST)
MIME-Version: 1.0
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia> <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
In-Reply-To: <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
Date:   Wed, 1 Dec 2021 11:49:43 +0900
Message-ID: <CA+_sParqF63m24NjL4o42agyk3mU_Cq1A-kpKFBpZaGmhdWYqg@mail.gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Dec 1, 2021 at 11:17 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> > I've been working on the unification of all ksmbd-tools programs into a
> > single 'ksmbdctl' binary, and I would like to invite everyone to test
> > and/or provide me feedback on the implementation.

Why?
