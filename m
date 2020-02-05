Return-Path: <SRS0=DFiv=3Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDAEC35247
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Feb 2020 23:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1885214AF
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Feb 2020 23:37:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dc80SYpq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBEXhD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:37:03 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46124 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbgBEXhD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Feb 2020 18:37:03 -0500
Received: by mail-lf1-f65.google.com with SMTP id z26so2730464lfg.13
        for <linux-cifs@vger.kernel.org>; Wed, 05 Feb 2020 15:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bH5PUwanF+bIorqgR8NjDivNjo+yO2Lilg1okziHifk=;
        b=dc80SYpqruROPNJ03bQ/WVySUUnmH4RmLYrUfam8f64JefxvLRaMGb1UY0pzCeVFVU
         qWfCcdm8GTatN099yVezd+s3Dq6MuhQvddWAJv98Fla8wXFgPfl7AIrQnoIMXlLDhdIb
         brw+nIvuQwv70F/LOPqA5Rq59TLUbwWvSATMbnlSmKLwh6+iJZb4bp+fOJJaeQtmrS2o
         7lbizZAvSs8YQFeemD/0dnuZMvcLOAK7hZOkFC03sAp/ScUdP+/GH0wnZty/9VEXgMZw
         nXAAZfp/Xm5CbGWIpDBNnc9fM/GHNrfjsydklfmQh+rddVBs92f9trEr5AOZvvl1ytnf
         ox9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bH5PUwanF+bIorqgR8NjDivNjo+yO2Lilg1okziHifk=;
        b=ln5VlvBiatBogbzpz4YFN/BSf3QS4eRhL1fuejzxliUe6jqnlBFBtdubUA65LLf2Fw
         GAauLuONQxV9tfwKMC/+KjuURlAh6uAm+gnqvkR70sniyOdUfxr30J3lN3yFicVl3d2I
         yrQSiNwP9qs7+xtCfqTanBXjj5wNdvRtioBhWkO4lfRm7TkDD/qeYKLqXvhoH6hRrKVN
         4I+mpY6Kx9yzJwjXIeiCRHp9o4zRmYqiT5vjm4qII1MXMmMMnxPBmIoQVAlZFioOKTS2
         f9gtlGnhZR5bIX8JgxvaUjopCaRgRLmvck3Nw5w3R94+vmyKOfjjHn0FoaArdSvqpUM7
         pkGQ==
X-Gm-Message-State: APjAAAUw3GeD3rS2hWiolBnHIIa98OBvPj6OvfBcbcZosgneUlUHAjYS
        vH0TyKYSKOwQ0IaPf39SW8YPr/uojd0A8XHDPMoc
X-Google-Smtp-Source: APXvYqxegO6rTrVlE460adga0wR12gTJirD6sELpKzD0QSwjwLqiyMe14cRf8WxUoZLKY43QWGOwHLIQGlAHmSiqzJ4=
X-Received: by 2002:ac2:4214:: with SMTP id y20mr127565lfh.212.1580945821161;
 Wed, 05 Feb 2020 15:37:01 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtPHXf4jy+TFxtRmHGfBBe6nza9=5aCWkm2h3wDLp850w@mail.gmail.com>
In-Reply-To: <CAH2r5mtPHXf4jy+TFxtRmHGfBBe6nza9=5aCWkm2h3wDLp850w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 5 Feb 2020 15:36:50 -0800
Message-ID: <CAKywueQCRMqm1ZKtqomhYzBhuiLCSO6f3rS08-hZDm5wSxT+Yg@mail.gmail.com>
Subject: Re: [CIFS][PATCH] log warning once if out of disk space error on write
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 5 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 15:09, Steve =
French <smfrench@gmail.com>:
>
> Had a confusing problem reported - turned out to be out of disk space
> due to a write with large offset on a non-sparse file.  Having a
> warning message logged once would have helped.
>
>
>
> --
> Thanks,
>
> Steve
