Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E947EC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 20:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E26164DD2
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 20:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhA0Uoi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 15:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbhA0Uoh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 15:44:37 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D32C061574
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 12:43:56 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id f19so3733723ljn.5
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 12:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=adamharvey.name; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6out6vYGGOdx9t+7TnvnFPBVYJtwZxCm2/KE8CNmFbQ=;
        b=14eIyyvjidlOsGCfJfAMRuxr3y3NswM62o/ATp5WtqPJye+270e25yQjI6y6yPHoHd
         8hHbg0e2wYN/Q+Iy8ANjaa7JNR1zGwAmu9cv9PY8UGamTYv10dkjlBXURLu8uONd5ahh
         Zuv3JjSw3Q6Q0lod/6qPvs2z8brCfqJrcRfaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6out6vYGGOdx9t+7TnvnFPBVYJtwZxCm2/KE8CNmFbQ=;
        b=HX+GN0K6+YZTOaLlZw5/CO3wYTZb5o5TZEhNNQYKpgDqU0+0XfmSUTWzFzhGlG2Nss
         KLA/0bnliZS5r9WLTAEBs4Gnwhrc26HEeW5rSp+4Wmsst24Oy4PIvuJ3klFcdbjOUpbG
         mjGgWTN3kDczrVyO0bL0WLl/fLYX/YpNegnddZ060lPEr/MtMWzNF9wu1XrvwD2i1Fpr
         Z5rFuMzrOIHuRNopcdeQPXV3F2Hwoy076Arp1AqMdlOobF9MGU4GDZ5jpF95JUzrRD1x
         Xy9pMcgyMEipY8ktHqQ+/p8VDVOsXm4yvpfqUsPCjE/QGCt74fdTwhh+Af5OJp9FhHRg
         5r6g==
X-Gm-Message-State: AOAM532kG07nNVAVgqvnbWTutIUVB0IsgDCHFXOfbCqjm52fo5aKBtFN
        VSkgV+knI63+7SawSyxmfOuh1BUBFQbYXbVlEk0vUnLlsDkrK1dZ
X-Google-Smtp-Source: ABdhPJwOCXeNfkBKPRjO0OB6Jze01g/22L8XOQyWfu6QKFuY8q5Edm7TqgKadp3R6usCzwLeUvewl6asZQjATADzUXU=
X-Received: by 2002:a2e:9819:: with SMTP id a25mr2229815ljj.502.1611780235070;
 Wed, 27 Jan 2021 12:43:55 -0800 (PST)
MIME-Version: 1.0
References: <20210127071020.18052-1-adam@adamharvey.name> <87lfceabsg.fsf@suse.com>
 <CAH2r5mtWa8JyWXHvnWKB5N-8qfGO+G_mmu5m3+QfuhxgWX14sg@mail.gmail.com>
In-Reply-To: <CAH2r5mtWa8JyWXHvnWKB5N-8qfGO+G_mmu5m3+QfuhxgWX14sg@mail.gmail.com>
From:   Adam Harvey <adam@adamharvey.name>
Date:   Wed, 27 Jan 2021 12:43:43 -0800
Message-ID: <CADajX4AvodXYD7H7Vn4+MO52UdEBYxMaFrcO6u6-Abotme2D8A@mail.gmail.com>
Subject: Re: [PATCH] cifs: ignore the noauto option if it is provided
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 27 Jan 2021 at 12:06, Steve French <smfrench@gmail.com> wrote:
> I didn't see anything logged in dmesg (when I tried it on 5.11-rc today) indicating it was a problem (it still tried the mount).Maybe it is stripped out by user space?

I did get a dmesg message when I tried it on 5.11.0-rc5. Here's my setup:

In /etc/fstab:

//10.42.84.1/shared /external cifs
noauto,user,rw,guest,uid=1000,gid=1000,vers=1.0 0 0

When I /mount external (with cifs-utils 6.11 installed, should that
matter), I get this in dmesg:

Jan 26 21:11:17 nosecam kernel: cifs: Unknown parameter 'noauto'

And the mount fails.

Adam
