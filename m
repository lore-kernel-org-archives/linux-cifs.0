Return-Path: <SRS0=PSEl=75=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6765C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jun 2020 19:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CD22208B8
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jun 2020 19:36:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaZNJMpl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgFPTgG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Jun 2020 15:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbgFPTgG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Jun 2020 15:36:06 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9E6C061573;
        Tue, 16 Jun 2020 12:36:05 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id k18so11364629ybm.13;
        Tue, 16 Jun 2020 12:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cwin4rM90xx7A90ILpx9q05b/HkXQADpjPRgjfWeDlU=;
        b=XaZNJMpllLj9SgsmtZ+lqJUHo0KXy6kSs0NyKpsgQhW+hObxXQQUda1CGW+ukeBVGk
         pIaSQEz9nrZ9vqpJDHOEwB5alQ0foiAVpjoqjYt0eubQ7Kr2hH6HxHEpnlgr3o+lAFl3
         gQt0ZrAjAccGGrwhv51mg7bi2B8a8HdyqI8zl4V7FxNcZWy79rErOatULjQHFLChSbN7
         wJ7eFFY3DJPYE8knqr39kovYupgdSF5nBjWbM4AXC8LrH7pzhG3Lj5QXkfnYQ2dD2GQr
         Gp2MsNkNABLpCD3a6kCe+gO4TzoONLKukdJlCkWzsI+Mw0cih3CvpOyI3C2Ye04aTGef
         h4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cwin4rM90xx7A90ILpx9q05b/HkXQADpjPRgjfWeDlU=;
        b=d0fiSBHPewzAlcwCaLcbDnRwgT1cYu8LmIJzzJsyoNaLSSR0+8KEPqfP1eZjHdeH6k
         b68zXH9fYMLELbZ9e5NGA+A9SC6DpyrzviAImeIP96S2cIqMVHcxMcTMMIg/k+HlZ9pE
         arVLg8VfGDGiNpBVLAl6EUFDHPtQuWwtiuCY9VV2bLNLtv60kdEmowL+UQWAIaVP+UC4
         dFjQ1o8xA99KvGeAsJdDvV+2eWBgF+ysoTcB/6FMNi45KowbvgYLhWBE5GA/8ERNUesx
         2yNB5Bh4s9jnx1bt+DbAQYXKPNWMObTdJBkDg4mEgq3toXjT81ArRgi+rMaoKEH3l0Ty
         h4AA==
X-Gm-Message-State: AOAM533AoaZ01ZbQSny7zCbjIC26PjvGlpI2KWo8+3rhp8H4LsRt1zA1
        x4W59avg/nlZMF6togGqO0k17SRWVaRe5Hf10uE=
X-Google-Smtp-Source: ABdhPJzy8V0OHeGIv8WGHsfj6rOnMpwaHYCmQPuFrMNmYNU7wJrsNguRNRgcXkXB0pGgipkGkrGWa/W/Ab0RhmC9Cb0=
X-Received: by 2002:a25:bc81:: with SMTP id e1mr6573459ybk.375.1592336165086;
 Tue, 16 Jun 2020 12:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200615224112.GA12307@embeddedor> <875zbri7k8.fsf@suse.com>
In-Reply-To: <875zbri7k8.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Jun 2020 14:35:54 -0500
Message-ID: <CAH2r5mt-SYkFcq=73ES8eNi0LYKNctPFPe28x0SmBdf3gEwt5A@mail.gmail.com>
Subject: Re: [PATCH] cifs: misc: Use array_size() in if-statement controlling expression
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added the two reviewed-bys and merged into cifs-2.6.git for-next

On Tue, Jun 16, 2020 at 6:17 AM Aur=C3=A9lien Aptel via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
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
