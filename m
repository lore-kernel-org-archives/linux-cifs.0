Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F95C433E7
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 18:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C1E20760
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 18:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSHUWrxK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732889AbgJOSR0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgJOSR0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 14:17:26 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B786C061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 11:17:25 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id x7so4947937eje.8
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 11:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hBtp0DyG8eFF/S0AqGIqg6ssVhlEsEHSnWa7/gUQAYs=;
        b=VSHUWrxKdir/ay3gZ4bx5yVI7TX5Iv+YjS9m7DQWym5TJNijSgu0tX0e2tRwTXt54r
         XvMR6Ky6CjhXfU7mVa9elMReaM0//HctvkJ75d1KS9iVdgXnLcWNhq/6R/iDexYtiJ6Z
         /pNIsz/urmcZYMKCe0EhQ9PkqF7OI+V86oagUXdp35pxuylxQBs/xiQTadQqgBlcgCVl
         fOM59HiHs3lYtr8vksOhwEb1A+6jtHhbbfzC1dbz9X437elEKwKUeTBt9tqrPuxAAgTy
         BM0uJyD5pFbgNVwDrTgS2PFtBXoIQygwfS2CiC85O8TFX7DseigGODJq2uctrGHzFM0H
         1JUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hBtp0DyG8eFF/S0AqGIqg6ssVhlEsEHSnWa7/gUQAYs=;
        b=bPt86JDmjDdOECIOTTv8Lug+9PxGmS+xRb2hVad+1Nj6gaGrbCUYaqN9Siyb/hTDrj
         q51ThIHJ3VflzwfYjnP3gbNeQ133uU6vAF8pWymnyIcVajXkq1nLFVKIpk9yiXtFTDF0
         qSqqzCAaNUH2bi8vEMtmB6ytHE7E+gIHyv77x6RAwc1bCWlbXKxi93x0K3OC1iXivhiK
         q8FXdYXDhOELED6sJy4R4m+M7x78aK8oayF4YrnVgS+4piES89Vgg+RWnIga9J4HFrDd
         eGA5MSN5hsGfuAP3tFR63c546yWX7bjKC5XelufMSUT8FTT475TR8oBiXO6qsOvAX2wK
         xFiw==
X-Gm-Message-State: AOAM5300rH9okfc/Qm97LeLcpUvVHUlJZTrEgLT6kmNLS/IqHMRHZQBJ
        8SwLJBwgqMDVdAE17iGK+4nR78/uHJJh0u3Pcw==
X-Google-Smtp-Source: ABdhPJxwDC4W/BR9tgWbGzLMSIDVp0tPVKi1EJd3XjJgqQZJE81qjVvxByGiYLWfmTMxGe0klf8K5WWrBSaJCqpgeYY=
X-Received: by 2002:a17:906:2e0e:: with SMTP id n14mr5707056eji.120.1602785843812;
 Thu, 15 Oct 2020 11:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
In-Reply-To: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 15 Oct 2020 11:17:12 -0700
Message-ID: <CAKywueQuxKPiGs2GDTL3h_Kn2Y0pjuZc=b-g1RV-xgmZo=VAXA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the error from crypt_message when enc/dec
 key not found.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 15 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 10:56, Shyam Prasa=
d N <nspmangalore@gmail.com>:
>
> Fixes bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D209669
>
> Please review.
>
> --
> -Shyam
