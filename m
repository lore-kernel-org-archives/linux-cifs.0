Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92304C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FEF64FAB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCJR6Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 12:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbhCJR6D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Mar 2021 12:58:03 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB9CC061760
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 09:58:03 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 16so11093090pfn.5
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 09:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5XVxRbamWlABeMyEcy9gZCElyIrrFbXVxVr1uAduW14=;
        b=KXPBG+2s+Pjtv+WUifoad808OhsAMUBEVrIdwNx46P+yioQuNb6KBZW7Xa1bQrUFOl
         h4k3FTIZlO508sUo/+i/Gn9NHfMZcT+tZ/dAmxrplJ5HEe3epDv0rBjtCJOHj0hWoslk
         oqqMywTVjRbrosKl1NvXoExWbUQJrcBGum2zMIw8o4EceBk/FZ9GGcQ0pfrUXQNcSTR/
         iMVhO2zwYb+VcLwD4b8ff1Kk+X8CJXQLXf6L82N0xZDP7IFwwcHzyxB9ztWL136jHGgr
         MgMhjxnWPomH86aKy8YTi1bQdEKXjwDYCIIFZe17HE2XWwcCO+iJcHJeWZrviG39zec2
         IUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XVxRbamWlABeMyEcy9gZCElyIrrFbXVxVr1uAduW14=;
        b=dL3fyBRQ3OZLY4LyLuzINSx5MKh89nUN5uFpINZdP6g0mUpx9tl1k1X9liXddviJrA
         MIY0wsvPc+z0/XUZLghTrQj/BZ4NNYBB3vsLHiIyB/JSwGzSDn1pgys35I8mo1bMXwWD
         eB62PK28Nk3LhUufOv0t+72OfBcl4ZFy57rDMQzQzqxfrKudrH78paD9hCS6ZrQelEvv
         axP6A1pMY19x/ib26U/EfGTuKtElZzkX2bBHQBa69HdC4rTypBcdN6NsqCI9S2z3FWAw
         AsJ+t6xxVDoBkL+hNUku8glVtMrqKjy9AUPIJooboyI2B3AU8kejgCR+MjfKd+XF4Q5F
         qmjA==
X-Gm-Message-State: AOAM530a5qKpAd0+pxtOdartVXN4ugKC8m7BkIomNmjFkjGD7BfbZJi/
        3ICWcQczoEYzW531NkrlC2q/X54qeP7maIopHjpHeB+gPAGLXg==
X-Google-Smtp-Source: ABdhPJz0lCsqyUR6zf/qWWbALNyHkOSWzgcZdD7WUX+VXxU3tkRudhagwPYTU/Cq2JONXwDKdN1H4emn+9R42t+b2Wo=
X-Received: by 2002:a63:4652:: with SMTP id v18mr3591449pgk.87.1615399083097;
 Wed, 10 Mar 2021 09:58:03 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o0sV5XjLw1D-9L3qnWwy4DV7WF3QOrHJ8hc5gPVjNj5Q@mail.gmail.com>
In-Reply-To: <CANT5p=o0sV5XjLw1D-9L3qnWwy4DV7WF3QOrHJ8hc5gPVjNj5Q@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Wed, 10 Mar 2021 23:27:52 +0530
Message-ID: <CACdtm0Z4Qj1ehiPs7nu+aVDsoLob0GXTe7SGqmrkeTA=WWZhKg@mail.gmail.com>
Subject: Re: [PATCH] cifs: update new ACE pointer after populate_new_aces.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Reviewed-by: Rohith Surabattula <rohiths@microsoft.com>

On Wed, Mar 10, 2021 at 11:14 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Please consider this fix for the failing generic/317 test for cifsacl
> and idsfromsid,modefromsid.
> This is exposed on certain combinations of default ACEs on the file.
>
> --
> Regards,
> Shyam
