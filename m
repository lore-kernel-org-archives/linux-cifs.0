Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3CEC433B4
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Apr 2021 00:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87AE76141C
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Apr 2021 00:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhDXA3d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Apr 2021 20:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhDXA27 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Apr 2021 20:28:59 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F28C061574
        for <linux-cifs@vger.kernel.org>; Fri, 23 Apr 2021 17:27:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r12so76252560ejr.5
        for <linux-cifs@vger.kernel.org>; Fri, 23 Apr 2021 17:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uqpfYk4Kd5JgjCc1EPbhwZGovE2OQjP0aX9gFMuik0=;
        b=Y0Pszrjt0MURgo2LDF7/7E8kOTLsd8oQOJ0PXNP4E9eCtfa8NoD/+xneAjdTvifIF0
         sOKrf1Y6vlfiYeolpH9e3v0UAc2aKdlAd1QzdE+8Y2jcpQc6VUY0il+vsWtaFoBfx9Gu
         GfNkQtDqBGRTkze82SDdOMR/DwKdAfxvWBGtigqhXV7soBdnEyXRl2ei7vGns09gXzfZ
         DsUwqXtL3kYPwcg7PrHgMUpdzRkjYx3gkpS2vAynTgtYzzfyfRCZOu9NZKfGLzaNSIUn
         JoWjX0bLs94q3ipwnEuQ256nCb9HyOfpEJfPDoQGqXYt3RMo+NV0/kB/IpVr3agFS3Oz
         ob7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8uqpfYk4Kd5JgjCc1EPbhwZGovE2OQjP0aX9gFMuik0=;
        b=RXqpcA0zKzuBs00uWubeJEQa2hcl/0l/U1eKmgfjTYDLZVs8QJuuX2QsXuMcXd8W79
         LOomTdPH9N5QkLO9eiRYhAsgNBhUAJgigHpsgi4Lr3Mi+A03W2jhVlHKrhalMNT3qAvg
         3sWEYsu4b2xEAK52UzqJGzoExnhtwcmVnCb+u2JQjhwvw9SLBgpe1Zner7tiWTMomn9r
         fHjRsBphMAum7HQKIv2kT1In1/voFsqUOBqgg2z8/qq5DUc7JiH6xgWVH+iZu/klurth
         ksSbcYk5KXCbXAW4Lob2PqrrunICqh+5zB3V0PbWF61ccziuBJVjN+FobisjPgXUJ0if
         9TKw==
X-Gm-Message-State: AOAM532TXIkrFC+A6FEePT1/f2lgdGyXT/wpW2TqDnIRqRcl54N8VJBA
        ql+/QH0LSBzGNrL2N7Ivv3enyNGYDD35roU56DdLIrgT
X-Google-Smtp-Source: ABdhPJxXSQjPBUzcZp1vpWKmk+GD9dgzda3P3tdz0coKSHUxrjcfhQpTmcdx/to4/10ngJhQUVVzmp1E2Ps0poNTSPA=
X-Received: by 2002:a17:907:16a9:: with SMTP id hc41mr7036580ejc.84.1619224075466;
 Fri, 23 Apr 2021 17:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muv6Dds-rwBqr0go+snow_nZxVML7unENyvt3XNndA6Rg@mail.gmail.com>
In-Reply-To: <CAH2r5muv6Dds-rwBqr0go+snow_nZxVML7unENyvt3XNndA6Rg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 24 Apr 2021 10:27:44 +1000
Message-ID: <CAN05THT+9+9QYMNrDKEYqg+KJYSnQ56cFHF9aKvG0Oz_2S45Pw@mail.gmail.com>
Subject: Re: mount context "got_ ..." variables
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think they were planned to be used for deciding if we should print
the argument in the mount output or not

On Sat, Apr 24, 2021 at 10:17 AM Steve French <smfrench@gmail.com> wrote:
>
> Do you know why we set "got_rsize" and "got_bsize"?  I don't see
> checks for these?
>
> case Opt_rsize:
> ctx->rsize = result.uint_32;
> ctx->got_rsize = true;
> break;
>
> --
> Thanks,
>
> Steve
