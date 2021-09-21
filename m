Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A404CC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 19:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DBA660F23
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 19:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhIUTSu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 15:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhIUTSt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 15:18:49 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFBBC061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 12:17:21 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g41so1869410lfv.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 12:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TM6BndXA2Q+SpI6MhoJ1hbs+Cy2L6Cc1Lchaqkf35h4=;
        b=CRiWRjhTDNWhg0EEXxfHGUNJMmoSa3tCoVHH498AEVBaOnilzCmxpn1OU2J5sD9G5a
         9hN44V83KO5yTHFoPlYuB+PNYcPvffKIEH681wHFGC7823ES/Erhbp36u1kOCmzaTnbO
         IXN68vqjiTyoGyQymt5oRLBkDoDsi9aVlEquUctKtqw9PzyZ6S9hWRyQU3MfQJozeTxk
         m/Wff+DmxpoyjyV01s8u/b299NYlfPw+I6UDxDGaSKhRfPk+2OXcpYUKg2LjS2VUvHLC
         e33sMlFW8lpBF6vv5jLgZxCNBAU2ZJ3MDXffrmZ02Cx+NRgvjGSzyYewB+rFttJroIpb
         mk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TM6BndXA2Q+SpI6MhoJ1hbs+Cy2L6Cc1Lchaqkf35h4=;
        b=hp0OSTG0YP1Ria4wdu6i407jrz2T/3VC3JPedWkLgf21x+x/4nVf3SYm/GlEx9jGPM
         DnUnzVB3YuagZxrENlkfZBEJmCEDSXBzQxUkf9bw8e2LJti7nnUXYBCNNjGWUDzcrE1g
         6hW5mARA9xRjakKtk2GnMokVuJSjzY67cSKBTo6Re1pyazOs9i5T4nffmXrJom9lgwyu
         Qs2/mMhGmBrHA+Xk777N+5w3kibAX4cyw0QDuxtNUC8YLbLwo89cMTzgUnlu7qBObyuF
         dIOTwVW0DBQGbY7rowvMpzYBgpOiWaqOiv5mRHuldMgk8uh4nJiWVZkVU5yEnq6dJgqr
         avYw==
X-Gm-Message-State: AOAM5334fkr834UtzsikRt7ET5DfAbyOwARWjqKLFOOy1vV4WVwhLoUN
        qB8qVfK3R940FnejlpD9wu8Ch/RMx4+V0d4TH2/21HWg
X-Google-Smtp-Source: ABdhPJxIZ+Cvly0Bs7fD2oG/ZzEo2gd/r5L2P9vMnqd0zgNKtoTMGF5QCnUEuG7jo4E/Zfzu9ktyIyg4y/dRnhg9GUE=
X-Received: by 2002:ac2:41c9:: with SMTP id d9mr24236379lfi.667.1632251839320;
 Tue, 21 Sep 2021 12:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210918120239.96627-1-linkinjeon@kernel.org> <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
 <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com>
 <2cf8a2d1-41df-eef4-dfe0-dca076e8db54@talpey.com> <CAKYAXd9VJ52QOEdAaNC3ZVAZk3mBAZFHo=uME_ygK0Axk=yivQ@mail.gmail.com>
 <a8f47375-9672-8761-55fe-d99add3a39b1@talpey.com>
In-Reply-To: <a8f47375-9672-8761-55fe-d99add3a39b1@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 21 Sep 2021 14:17:08 -0500
Message-ID: <CAH2r5mv21VUfgFA4jLsuOa8u-rHhKhMijxrEHn_8FPcSuDt48Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add default data stream name in FILE_STREAM_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 21, 2021 at 1:19 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 9/20/2021 12:34 PM, Namjae Jeon wrote:
> > 2021-09-21 1:08 GMT+09:00, Tom Talpey <tom@talpey.com>:
> <snip>
> >>
> >> My concern here is, what's so special about directories? A special file
> >> or fifo, a symlink or reparse/junction, etc. Is it appropriate to cons
> >> up a ::$DATA for these? What should the size values be, if so?
> > Special files in linux(ksmbd share) is showing as regular file on
> > windows client.
>
> This brings up an interesting second question. Is that a good thing?
>
> It seems risky, and perhaps wrong, that one can open such a special file
> and read or write it over SMB3. I can see allowing read attributes, etc,
> but certainly not full access. To me, at a minimum the read or write
> should be failed by ksmbd, if not the CREATE itself. ksmbd should not be
> representing these as ordinary files.

Symlinks, FIFO, and char and block devices have special reparse points
defined by Windows for these, but they would not typically be read, in
some sense they act more like an empty directory.   The exception
seems to be hard links.


-- 
Thanks,

Steve
