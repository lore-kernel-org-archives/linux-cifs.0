Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758CEC432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 03:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F1FC206C2
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 03:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EntG0qKv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408868AbfIXDrm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Sep 2019 23:47:42 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:38702 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389841AbfIXDrm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Sep 2019 23:47:42 -0400
Received: by mail-io1-f44.google.com with SMTP id u8so965158iom.5
        for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2019 20:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SaNxviayXEFKyWSyGzuTNLWg//LBXEPOjgaXs2+N2mA=;
        b=EntG0qKvj0smvSAVXMt5pMPJTkR/2r9AKDEkfeuP+lnCjjxitd6VRFrEWA4vGVAbId
         YCFNgpAsDgHnZ8qv75lOIGMk2d2o2SqgMQYw4vi3FDuzWiTN6SwIfCTym/FRAL27fccM
         c19WDzNELttqQ8w7/7XyizK42UeLKsD0I3fYbZIi4/iMWsyMv4xUZDY46dFTR/6QXpB3
         jr3qe6ijl0wH9Rd7espSIgvUVAE6jsjm5VGkkj2bL3ByiBcD3i9+gZpdj9V6Tbuw5dzN
         v2bwtQ4XF0FrHIyQjmgrPSDJEYiwl33mvXdR/nWTus2CkalCRSLwxvdw096GvMqJEfcN
         Jeyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SaNxviayXEFKyWSyGzuTNLWg//LBXEPOjgaXs2+N2mA=;
        b=cTsMTisNfHiQVhqhD4Ua/vS6VGR+lWphZUFe2B0FDNf2XOO3jNvt8aDLuAM8pHeWZW
         WVjE+RhMAxJVrGWBrGxPVmSVAC22WZpUZJbx7ZUDEM7jPJMoyUnW1uAMj9q6djaTIBbP
         wc/BZrVOsj74iKZXsd1vfot9SKkBXKmNyrb05oQ8roFbTksLUeSupwoeUIh+km9Bvl8b
         4a8xyXWMxMGnhBOhmG0rIYI91q6Nmw86o2E3LVcd3/bNBziOvXIR1n0HVBk3uDPS0LFd
         QUbpXBdMxbZyLTN3wml6YOktA60abOO2oN8QSMJEnsLpxsy2mrbumJ4rRLwYhemP82Sb
         tIfQ==
X-Gm-Message-State: APjAAAUhxwtIm+r1GC1/Az+VJanPv1ZUuy9kXjk34iarDOZ9h2As8vvm
        ZJtKCkVnhMDgMz8cS1yCU4IkJDWY/FbqJDcHxZI=
X-Google-Smtp-Source: APXvYqzMyf9HoCgO6wVkY+JgXnZKzu8a/6Eaz/7qjp+Fz+84raYif6Mc5iYaLYky+25wEt3x7Paq3N+U3ZCMS544utI=
X-Received: by 2002:a6b:c38f:: with SMTP id t137mr1162215iof.137.1569296860246;
 Mon, 23 Sep 2019 20:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv6x_aJQJ_N9f+9zYFgFN7FkmpR1=sNzCR8Ln5m=kGL-Q@mail.gmail.com>
 <CAKywueSQGT13QQZtWz9t8vQPpukZ8cydXnT43kRyWv9scHOivw@mail.gmail.com>
In-Reply-To: <CAKywueSQGT13QQZtWz9t8vQPpukZ8cydXnT43kRyWv9scHOivw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 Sep 2019 22:47:29 -0500
Message-ID: <CAH2r5mtGoieAYa9rX7B5isu7NL0cD2a+imdaXFvhcu-C-0NX=A@mail.gmail.com>
Subject: Re: Fix for "requests in flight" showing negative
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

aaah - the typos -- thank you for noticing the obvious!

Fixed and repushed.

On Mon, Sep 23, 2019 at 12:26 PM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> I guess it should be "open files" instead of "requests in flight" in
> the title and the description of the patch.
>
> Other than that looks good:
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=81=D0=B1, 21 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 22:58, Ste=
ve French <smfrench@gmail.com>:
>
> >
> > Requests in flight could display as negative when should be zero
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
