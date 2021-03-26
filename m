Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DE3C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 15:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC6F61A42
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 15:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhCZPyt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 11:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhCZPyq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Mar 2021 11:54:46 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E223C0613AA
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 08:54:45 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id y1so7904916ljm.10
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 08:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ggs9YANgKxNs87mrowNXKyHYq+DoLYsVM0aWEqF092o=;
        b=MW8sPjJxtkBO5HvPWudAvd9WOSGEGONNO4kfFIqUGIb+WbXZ2iLI8BzpkjF8Wn6+hB
         59Sr6UVqANmuxcUVM7Ar+fDgONoa3xLBTY//pIrF1Ikrdo68J3qcJ3yoo/wLwiSqkS0f
         Gnw1BnS7CamE7vEYJEPZ8WjkDWq7xTaR0MGClS7+YjaHWxJyctVgRWp5PhYpgFqpYbnG
         uVP+dCqfxcNwHUxYye0e5DywX+EncofFHMHrm+h2MiAxq4Vxi+0407zdl6nyHohjKZMG
         ZS7R+EN3zYAmk32vOLLSs13InHNHA4sfyZ7BpRu42yPYD4k8uf/dOL4E6e6mEIx6WXcT
         ck3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ggs9YANgKxNs87mrowNXKyHYq+DoLYsVM0aWEqF092o=;
        b=Nz0n5cs/CXDYMrjdS520jXWJaS0CKlQ3tiDG/qcBbQ/OhD4TAN0crewIZSH6gO1pbW
         ePO0AIqCxyJNOHZvTDVkwCXaJB7BS4X/lDu1RtjYW2kb6xVN6R64s3ujBdH+V2eWX4y0
         yEkN3BpvHEERvTtGrEpChqhYb8J8KzfYF+QeHN3RtGL+W2vnEB3iEW2macy75amddfgg
         bl2kuZClBy6VsNnBS6nwO/jtQY5OtLuNfeSdA0w3LtYjA9TYZkcwu6eucudhyJYdUXjY
         lZ7gVTBlrMLheLE3VCvnrlUvcF4tIyaQ1JC6JfYgyflo6bKHH+U52APdBQwkOxamZu6T
         Vlaw==
X-Gm-Message-State: AOAM533Nf9yq5zg1mhbXvvUf1RB0N+PTlyHmHCJmv6yZ66FRHCnN2riD
        Xn/xO0920683znMu2+lyieI61a2CrbV9k8PT1+Q=
X-Google-Smtp-Source: ABdhPJwDU0Khwa0KDTCBv032c5rLCMC4aOFkNgUQWF9y5khLZIXgTPzRpaJmBKlTAIjNJ2/jnZGGxM1tv+agVkb0eYM=
X-Received: by 2002:a2e:98c5:: with SMTP id s5mr9148829ljj.218.1616774083931;
 Fri, 26 Mar 2021 08:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rr-rDZ1Jo_rzM0_63-pHOKPcRSnML0ucOVkSBVWrSc4A@mail.gmail.com>
 <87a6qprk06.fsf@suse.com>
In-Reply-To: <87a6qprk06.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 26 Mar 2021 10:54:32 -0500
Message-ID: <CAH2r5mtk7_e-DOb3E6jYQywFRN97mCfYfKrqTmA_PEzGSZQpXQ@mail.gmail.com>
Subject: Re: cifs: Fix chmod with modefromsid when an older ACE already exists.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Presumably:

commit 5171317dfd9afcf729799d31fffdbb9e71e45402
Author: Shyam Prasad N <sprasad@microsoft.com>
Date:   Wed Mar 10 10:22:27 2021 +0000

    cifs: update new ACE pointer after populate_new_aces.

On Fri, Mar 26, 2021 at 10:51 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Found a regression in modefromsid with my last fix in cifsacl.
> > Tested against mode check tests for both cifsacl and modefromsid this t=
ime.
>
> Can you put a Fixes tag?
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
