Return-Path: <SRS0=5yhP=XV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C59C4360C
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Sep 2019 18:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B318222C3
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Sep 2019 18:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERrTAUs1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfIZS6a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Sep 2019 14:58:30 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45239 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZS6a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Sep 2019 14:58:30 -0400
Received: by mail-lf1-f68.google.com with SMTP id r134so2483959lff.12
        for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2019 11:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IOdARELbeQgn/BVJGtpQ08IlR4eqA9+NesNiRx7hmsw=;
        b=ERrTAUs1ZgxlbwH5OQnp62fzebGYagyjljMLzIHnI8vZLg0VRVgTt8fxCxiBj6Jbcy
         uYHOohMWaha7+zceIxsb6EN5naY7lv0QKmIH/m+CpbwsWlN3SSfw//O8pBy8PZv94W3q
         4EjSBRoHoV/YUt54e0g1Q4tjGjaoyT9rQq3XpbjMCk2+wU87sL6y075/kwahxhg9rVph
         psKr54SaADVDDF6Tjz//CeCS7Sv3szYLFlWHTknahml9OzufHxjBsDbaiADs0sIh/hWM
         bEnhReo+XjsxUY36m5OMzQvMwBewNgEP3lxqDVQCg3HMEEaNKzus9G6UsQiuJ/hvEzq+
         4fiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IOdARELbeQgn/BVJGtpQ08IlR4eqA9+NesNiRx7hmsw=;
        b=MuNJBkcX/Lx3JTItn0i5Rv+svfrP4bA1Efn9Vp0zsxRHNv9p4c2Q6qYUyZf4dDh0V0
         7tdzprqPAAbUQ795n+33Nj6aM1wCYMRfG/tcbH4qvnzfrTBa7mm+pSCMLXdvD5Yt4U3t
         w8noH9fcDk4UKoUO8AldBUnTU025y6BBVkQXyOJ7C15x7SJVcG6pXSdAUcNFDhoySSvo
         8d7Lu0yW9Evx/wm9Bbh/sCLJ0EICs3LmTHit4hrd6ZrQrfQgH2EgxV54lTC2U5J+uXr6
         rfU+iRK3PB8M24zrAkXJk13qV3iATOZZFCdZWWq1GwxbtfAwhIrvlCVmJitywomf2yIB
         roDw==
X-Gm-Message-State: APjAAAXA0unN1Q8ky6kVHhQiM70+8MU3XL3EY1zkD+1Y3bJ/fq/2+Gtq
        ZeomX0lRXANAKuSpkHeXCbN/K3K8HRsnVkoSP0GxDX8=
X-Google-Smtp-Source: APXvYqwBMdVWkjwsYoYgqzPCtg+HfVaS5/rLm9YQ3s5HKiGoBoTi0qz1c5ZgsdZ3DV049GtK4fpqIHoAdyL5C5xop1k=
X-Received: by 2002:ac2:4196:: with SMTP id z22mr57154lfh.54.1569524308109;
 Thu, 26 Sep 2019 11:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee> <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
 <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
 <CAKywueQUuwRK7hbbJhdquVVPre2+8GBCvnrG76L-KodoMm9m6g@mail.gmail.com>
 <b7b7a790feac88d59fe00c9ca2f5960d@moritzmueller.ee> <CAKywueQ7g9VYe=d7WU4AzL2Hv+pPznUgQBD7-RVi0ygBkhtGRw@mail.gmail.com>
 <bdf21b8770373c9ea4c37c27a12344d8@moritzmueller.ee>
In-Reply-To: <bdf21b8770373c9ea4c37c27a12344d8@moritzmueller.ee>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 26 Sep 2019 11:58:16 -0700
Message-ID: <CAKywueQ8woeupNRqspAuOqL8rG1hNpWN_hwLCjFUpkk4mXeCvQ@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     Moritz M <mailinglist@moritzmueller.ee>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 26 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 03:58, Morit=
z M <mailinglist@moritzmueller.ee>:
>
> > Please update the thread once you verify the patch with the other
> > software you mentioned.
>
> It works as expected. Issue is gone. Thanks a lot.

Thanks for validating the patch, I will proceed with creating a formal
patch then.

>
> > If it works fine, I will prepare a formal
> > patch for the mainline and active stable kernels.
>
> As I'm not familiar with the kernel development cycle: how long will
> it usually take for a patch to be included in the kernel?
>
> Which are the active stable kernels?

Since this is a fix not a new functionality it can be merged in the
mainline pretty quickly. It will be tagged for Stable kernels, so, it
will be automatically picked up for the stable kernels. Right now the
active stable kernels are: v4.19.x, v5.2.x and v5.3.x. The v5.1.x that
you are using doesn't receive updates any more, so, I would recommend
you to update you kernel to one of those.

--
Best regards,
Pavel Shilovsky
