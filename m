Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05752C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 17:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F8D64E79
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 17:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhBKRPO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Feb 2021 12:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhBKRNe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Feb 2021 12:13:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EA3C061788
        for <linux-cifs@vger.kernel.org>; Thu, 11 Feb 2021 09:12:49 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so7695901eds.12
        for <linux-cifs@vger.kernel.org>; Thu, 11 Feb 2021 09:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5JJR69fBZ9MoP28n4BYlJpjps3WbHVn29xsiNPQWa5A=;
        b=fF1e5T1x1Q1SQe2D0wc+Akz9duOJaNEP0T0nnGB3Fo4euB5HWt17PCw0aXUbO53b7+
         WJ7EXmS9E+piI2cU87lR/6/bpBt3H2Or3K8veQMeIoNK1XA7YNiUJweds5z0omlkFV/U
         40z3+4GT3Y/paCNYBeQG8Dr9UnbHuiHM2pe8JsOMTrtzZScAhQhB/YPrLMz0QEEn0C0A
         2lFl8pkAOct9uRavm6MzY5LIMZSWy+fYhRaWesNIWkwff5Q3n8BPqiYLPux9rKx91xLX
         hVhJTZ/xxF4T+kC3jdsUTAIkmrD77/a9Ws9TVYMgOvTNhqitDRqdnyNUWHW0m2XIuAZR
         wxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5JJR69fBZ9MoP28n4BYlJpjps3WbHVn29xsiNPQWa5A=;
        b=FfT6g8zEFuLCtiAj27r6D5TlOsO1Md2yDWILgZwh53j/m5b05HRDEO7f5niQWOOUZx
         KMvXEPnIB6auwmGbguWsMcNYBNP3DWP3lDuCSqlqB7mip7bgHGigbKT0IMhGAGSuupEF
         kM1RRTUHJP/+8fB/+Xajel/A5RQPate47jw70IBhdlSN+Kp7XlxrAFZWpzwi5xxwKHH2
         2LQzE2RQkFy/yOncOS8449gvL1CqB0YHhFR0HDYezlSfK0nT2VE4DJ3wuggpAB9CmwxY
         vs7zdp8uYegAKS1SI+z4OuIl8mMN0MRI9nRTqMtc3bWHaWyJ2hF6ecV9qT4tWUZEcE/O
         Y2rw==
X-Gm-Message-State: AOAM531GW7B4fV5YpxJmB5/ed5ByXMS7LQLK+QA9vFFvL1f6d2XHA4j+
        nGfpsJbHRyX4IhttxWzh8IgomSIHeezVypcVgg==
X-Google-Smtp-Source: ABdhPJyfosIVOr0r0htqTU1WCe1StmBSGpHFmCQbmKLjpwwyVMmQX4h9BFvlB4h6q9lLW0du63pTyCOmX3WovP4pY3c=
X-Received: by 2002:aa7:d6c2:: with SMTP id x2mr9244218edr.225.1613063568312;
 Thu, 11 Feb 2021 09:12:48 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com> <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com> <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com> <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
 <875z2yn0lx.fsf@suse.com>
In-Reply-To: <875z2yn0lx.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 11 Feb 2021 09:12:36 -0800
Message-ID: <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by conn_id.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

The output looks very informative! I have one comment:

Servers:
1) ConnectionId: 0x1
Number of credits: 326 Dialect 0x311
TCP status: 1 Instance: 1
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
In Send: 0 In MaxReq Wait: 0

Sessions:
1) Name: 10.229.158.38 Uses: 1 Capability: 0x300077 Session Status: 1
                     ^^^^
Isn't this name (or hostname) a property of the connection? I would
expect an IP or a hostname to be printed in the connection settings
above.

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 11 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 06:24, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > I noticed that the output looks rather odd when used with multichannel.
> > Attaching a revised patch with the changes.
> >
> > Also attached a sample of new output.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
