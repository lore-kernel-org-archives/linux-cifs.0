Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FEACA0FF6
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 22:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjIAWUx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 18:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjIAWUx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 18:20:53 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A1E2D56
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 15:20:50 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2bcc14ea414so42647611fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 Sep 2023 15:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693606848; x=1694211648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L2ucxaFNciyrvxTEa402j4nZLmbnVfPRtI0CbjoHkxw=;
        b=qR+OlvFYDKhlOF2qlQys6+ejZUbw8UdrIErIF7FftRGl003geekgxovBAv2DPLIkUE
         F6SJJ3m6kQL3YJY/N+6WLGrj3WiL8jMohxpowJI6bFAlzHapLA82t0U+KunG7sE3mXZA
         cVyY4/MQUFdzV4K4lJzTY62Jy2yxRmHjqECdMhntVNMwypGmYtFxSTo5R7xMvjg4pLAr
         7Lxlgy0Ji/2cAIn1MCdhyJrApp9aFTwXi2GN8hMvXudBSnh4IL4ev5wKOwyuz3+4501T
         NXfIddYUQq25wiPOcPDrm2cx62t2+LAZREDd6Z9VokOQuNfqTqbKBk/Hxph+FnEUhlGw
         +nnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693606848; x=1694211648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L2ucxaFNciyrvxTEa402j4nZLmbnVfPRtI0CbjoHkxw=;
        b=kkv5vJFmebuP/FMLpG9ijyzBBDDwCweghn78BTj4VC2kg2K9hMAFAmNnBm/PZ5KnPp
         /fG9uDZEiZ5bwELqNjVeTGWERjTjn9+32zAqSr7KbTizjyuqylKegGxN187wArgaBZ02
         M4X5960/+aEnZiryxnvUgS4Vr89OCowAEKknqloL2yFCSTdA5UmdSI6xdtpkTdMjSwaf
         o7p81DTh7Fs6fiRHgVkv1I2aeXarKvK7/QuQGkjZh4UmOPMiGwLI4QBdDNpLaRPI98Uh
         xIhCAs+6y8wy4ls6dLjrB1WT7XauzLEmjixPf7jHCXf5Zc2eXBbGSeeZ2XSdEIkhoKBG
         MPVQ==
X-Gm-Message-State: AOJu0YwiNYTXXczB72S7tWwA7Cv5vYhiBNPDP96UgoPU3CPU3UG5R4JL
        9Ww3bDb2e45eQ3nZX/2lP5lSyBCqQ7RqazCbMno=
X-Google-Smtp-Source: AGHT+IHsqGobCAOxQAN7CLvLvG00vOCxtt1ULO9zf9U9/cXe8fh9C1Uh68JEq06QwyyPrQXFserYobPmYX+WVeUUDtQ=
X-Received: by 2002:a2e:8707:0:b0:2b9:c4f6:fdd with SMTP id
 m7-20020a2e8707000000b002b9c4f60fddmr2511838lji.14.1693606848311; Fri, 01 Sep
 2023 15:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
 <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org> <CAH2r5msreVdsetQ1DQYY0orfh=N+zkxLnsWvuecYJWzN3Xev+A@mail.gmail.com>
 <CAN05THR=bR7Wr5qP_evmBEWuxFVtX-z2+o_KavZ5r_zbTD3W8g@mail.gmail.com>
In-Reply-To: <CAN05THR=bR7Wr5qP_evmBEWuxFVtX-z2+o_KavZ5r_zbTD3W8g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Sep 2023 17:20:37 -0500
Message-ID: <CAH2r5mvf+kqp_YdZear29kpEhbzHNa7z5nnXCTmn74ShMVTZYg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Sep 1, 2023 at 11:31=E2=80=AFAM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Maybe just re-set the timestamp every time the cached directory is reopen=
ed,
> that way a hot directory will remain in cache indefinitely but one
> that is cold will
> quickly time out and make space for something else to be chaced.


Makes sense


--=20
Thanks,

Steve
