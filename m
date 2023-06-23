Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CC0EB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 15:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjFWPvZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 11:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjFWPvZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 11:51:25 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61931992
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 08:51:17 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b4790ff688so13962181fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687535476; x=1690127476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jv9TjOtj+mBcq3XMmU/X7HwCyl1fHn06BrFayCnevJg=;
        b=Fg6Bvo8XYQbUTzqyU1csdpxpGiA9WFAunH2Hv7/FbpYNL2hnY2sq20VzkRx0bWsXMs
         cn54dA8C/64ZOIxgydD9FwKxzeqFBpglRAndqKIbCpp33gXvRL5drRE8Hg+6hotKjE1K
         QOrL+rAJ7huPrKCoh9zO8zLajLz4VzXDxqoam+y3RNtb4J4/B28foiS//pgSFPODYnWy
         TaXe1djccjJimH6MVMag5T/l6w1tb0pxFCgQp9UwsA3TBRpLEs3p2ahHjKyB6ut5g1gy
         QWfeMTZDxPWIOST2wJZcHLGAJJaNb6OwGeyR51tv+MGMUxRDAaVSPtMbKtnNKRRe38V4
         sfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687535476; x=1690127476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jv9TjOtj+mBcq3XMmU/X7HwCyl1fHn06BrFayCnevJg=;
        b=L3nfFf86kjSMz5gsIMz5dTdYBfK0aTnevSQM2KJEqHzYXTTRsNmXYqRIMNXOuD7m7c
         OdB87BbFE4nOHBX6dzpBxd6zdOIMih/ci2092iI9fjR0P5jT0TJdGPxOUe82vJWp9vag
         q9TecL0tBlELu6i3wpxBUxRbt18xHQNa0swZYAhncA19vxmsRA6v8ZUFpCkvGJW60TeE
         4MSIrr8tjMP7xZXBrPb9tI8th4r5j7CpoScJmlBCYl9/fsf+sHKyngImlBcj8Ca/hIm+
         e8DxO0w/3D5HjEmjwraVs5WAoSQPep2kw5kV+N5s1knC5RcScV9FD1Pk0xoKm7ZUmcMN
         9DIA==
X-Gm-Message-State: AC+VfDwRkuDnjmaMTOQCyJH9B2nujXQuuxL0qLHLmc5FERtcN8PZKICS
        zta49/bbKGhslIhm16QhEfmFPG2CPBSOghQDZ3k6g14K
X-Google-Smtp-Source: ACHHUZ5CMO03WQKZ25HK9AkJGoXTJugrCXzI/Hrgt1jqbk/23y3sGPzt5lfT0SV13ReEAvNV3KBzzxUAEHAML0iiIiA=
X-Received: by 2002:a2e:a175:0:b0:2b1:fda8:e653 with SMTP id
 u21-20020a2ea175000000b002b1fda8e653mr14473860ljl.27.1687535475747; Fri, 23
 Jun 2023 08:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com> <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
In-Reply-To: <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Jun 2023 10:51:04 -0500
Message-ID: <CAH2r5mvdZ4tsQ-n6=nhyyk=7Eg4_vtu0JtpZOFhoyKovo_e_iA@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        pc@cjr.nz, bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next pending testing

On Thu, Jun 22, 2023 at 11:22=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Mon, Jun 12, 2023 at 8:59=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >
> > On 06/12, Paulo Alcantara wrote:
> > >Shyam Prasad N <nspmangalore@gmail.com> writes:
> > >
> > >> I had to use kernel_getsockname to get socket source details, not
> > >> kernel_getpeername.
> > >
> > >Why can't you use @server->srcaddr directly?
> >
> > That's only filled if explicitly passed through srcaddr=3D mount option
> > (to bind it later in bind_socket()).
> >
> > Otherwise, it stays zeroed through @server's lifetime.
>
> Yes. As Enzo mentioned, srcaddr is only useful if the user gave that
> mount option.
>
> Also, here's an updated version of the patch.
> kernel_getsockname seems to be a blocking function, and we need to
> drop the spinlock before calling it.
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
