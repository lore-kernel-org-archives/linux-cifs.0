Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBCFC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 06:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D01E02075B
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 06:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSlxXxex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfCEG5B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 01:57:01 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33340 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfCEG5B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 01:57:01 -0500
Received: by mail-qt1-f193.google.com with SMTP id z39so7969234qtz.0
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 22:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IzjhAwUgk9eL3MLEsra7w5ilPM3WNz51CbG8Vc+xZWk=;
        b=GSlxXxexxCch467/Uo5MbActfioRGFrQQGAoijpT6o6xCh2z9QT1aYar96NJLNIU21
         SPYKDwXbmldX1wn8Qd5Z9fqEwqbJmSCHJvCkxKQ6xfcHG8UzpLwlt61vo6MW1J/l6K9v
         CbOpSpTJrr5SKk75OgavpyOvh0A8YavuZM/okzfiZMQHMdDeVYAG6HSFuXAcVFnNKy5W
         HMRTZ4IfnOdV9u5VNhHWynkrolwqzMfVDqfazIB4qpRyGH0GNTAueIr7pEesdkolx6C6
         A+OFuNQg2Yg5CjeQJdtn9mq24XO0AuvRVUuvrVI7xVbgo9NLSk1/pcRHINWCIJeNy435
         rOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IzjhAwUgk9eL3MLEsra7w5ilPM3WNz51CbG8Vc+xZWk=;
        b=sWQ/VqIiWY6/2mL4RSHvVcs0O331UUqbnouwVf2jCqLLnd6I0HkiRuJSauLhrRmE3M
         JyqiugT4h/ET+/fj8XK4q36TwVLOhzn1ik6bgZOHmQL1mOGTuDdLrp1MDUuSGQ5ZwZxN
         mWzj2vGDw+QOgn63UYNqYoZK2mR7rJ1rIofj9OxpXhhqxASrz5pIHAvAum5IyvH6nKrN
         4LUTVjYF5i5xXObD/XOFqgT61p2fkZvCEj1vtcfuRi9aBl+geCSNFx8xHvtqFM4NGkTc
         MLnXCKEnBpyHbbvjgr79mH3qBLKiIfJjLDDYC86StInuC7WnhUFgBLbZrw7LM6aBcT6e
         Tp9A==
X-Gm-Message-State: APjAAAV/Rx9QS9UH1P4r5OCTe5hOOa9D13gJnlwiV+iRByzi/Ch+ImE4
        TdXrLjUHRl288tGhkbwRjV54BsaLFC85OZT4LnoR5g==
X-Google-Smtp-Source: APXvYqzhrL5HxJXFku3oUSItH2GtYD7AcCSqfMzios5/p5X+v9hXWSaREXEbGM3RkHsV57zeelwBmsdAuZ7kxhDQFXk=
X-Received: by 2002:a0c:93ab:: with SMTP id f40mr950795qvf.59.1551769020412;
 Mon, 04 Mar 2019 22:57:00 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com>
In-Reply-To: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 5 Mar 2019 16:56:48 +1000
Message-ID: <CAN05THSogb2yjwTN4GaofNaCNHN_A7-xj90gpQZio5tNY1x41g@mail.gmail.com>
Subject: Re: [PATCH] CIFS: fix FSCTL_SET_REPARSE_POINT SMB2_ioctl() call
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Tue, Mar 5, 2019 at 4:16 PM Steve French <smfrench@gmail.com> wrote:
>
> merged Aurelien's small patch (attached) into cifs-2.6.git for-next
>
> --
> Thanks,
>
> Steve
