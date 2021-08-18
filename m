Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC097C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 16:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA584610CB
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 16:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhHRQ2d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhHRQ2c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Aug 2021 12:28:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88963C061764
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 09:27:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id z20so6230137ejf.5
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 09:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z80Zd/gcSBuEJU8VgaNn2TIZQx1th4KMYyB+YUjxLJM=;
        b=g+vKtasUY9Dirx+14jGWh0PBxXL2sGGo0B0rJE9sFE12R9ahdv5ah2kr0dAUh9Yqru
         ybQZkZbpR8J3pErzEt+rAcsYM3z68tQ0cw9Y+h5X7f0fbm3mp89vwGPbsaEyEeDUNTdk
         pri8mEJwk13OUhocFrK/KmnX12qzVE2D/P+j0HXPZLDPZ1qhzuYOV2tA4EhJStsumXsS
         MIwGNnGw9ansDmJS9te5Wc53ioONRHntp6m3ouwsy8JwaHYOVHCsQBPJ12q+Bpyb0i9d
         YhTTVUakd+eXINdLjX8fRiHzRfarm9UIMdNvoGC4Z1IP7Wi6prsiFZpGqztND6Z9Xrh3
         XN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z80Zd/gcSBuEJU8VgaNn2TIZQx1th4KMYyB+YUjxLJM=;
        b=nSK88RzzwvN/c7yVXlI4yvJVSwbqWwO9W/A22UCasODh+jyVMSuPy/V2Gl24+AP23n
         9/QLA192/2gJiFithXRh/LMsHFLpwf73PugDjwsH+F3kijcJNo7f+o607U2jfICD2+GZ
         LZUgdRxhu4wj1WgSt413YxZUuM3Q0Dn9G40DiaBihDHkU1Vq1Kyaa2D0507zCeDBid2i
         CyFt40C6/oU6ybbWq9TNXOYpZ57tv/3DmJpb3A2S/j0+6SCi3T3Eu+O3FtVDSZW2DqDs
         6VIvdc7NEA0RP5hH5cTmcSgo3XrSdrfdghfrAErBo5/UzcN9IhWZWSDO9PVBAwT48CsP
         hNkw==
X-Gm-Message-State: AOAM533yJdO4rDYnphncOXb62DLITM2yKuRWtpsl1DCI0A8C39ZVhzVJ
        K/XE32GObmTsn7x/MTbtMC+6D+tWQ9ZvNfAu3z0=
X-Google-Smtp-Source: ABdhPJxDlWCvk8qXCibpmlWj3SE5a1Va8VhuQlGNg7oG905cCZMuUVN/53D2pd5DMCcTQHUpXojs9GIQdO/IndnBGoo=
X-Received: by 2002:a17:906:c2ca:: with SMTP id ch10mr10609779ejb.203.1629304076115;
 Wed, 18 Aug 2021 09:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210818041021.1210797-1-lsahlber@redhat.com> <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
In-Reply-To: <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 19 Aug 2021 02:27:44 +1000
Message-ID: <CAN05THRuM19+JKNPvXgtOBurQe0641agG6rPQKAB12Sd25T+pw@mail.gmail.com>
Subject: Re: Disable key exchange if ARC4 is not available
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 18, 2021 at 11:18 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 8/18/2021 12:10 AM, Ronnie Sahlberg wrote:
> > Steve,
> >
> > We depend on ARC4 for generating the encrypted session key in key exchange.
> > This patch disables the key exchange/encrypted session key for ntlmssp
> > IF the kernel does not have any ARC4 support.
> >
> > This allows to build the cifs module even if ARC4 has been removed
> > though with a weaker type of NTLMSSP support.
>
> It's a good goal but it seems wrong to downgrade the security
> so silently. Wouldn't it be a better approach to select ARC4,
> and thereby force the build to succeed or fail? Alternatively,
> change the #ifndef ARC4 to a positive option named (for example)
> DOWNGRADED_NTLMSSP or something equally foreboding?
>
> Tom.
