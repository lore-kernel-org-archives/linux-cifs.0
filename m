Return-Path: <SRS0=O+hx=3M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADADC33CB6
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 18:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 267A822522
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 18:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2C0pGQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAWSr0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jan 2020 13:47:26 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44657 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgAWSrZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jan 2020 13:47:25 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so4740058ljj.11
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jan 2020 10:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XcdQoaj6dvGwom9nqcUuI6XoafSmvPwycgz+Mpe6+pE=;
        b=b2C0pGQ8c1ctz5NlUQ2Wj96eZhgILjTTJRwC10/VV9mzf2YUiOFPmTyhPjzOjoZnUh
         sigtUP7aliDD2R9t7grXQy7cloclwxa/WQntwrHDJFJV5DrMx5IKZxEIFDQmuXBX/XkM
         83Y5jWcZVRJ1aLMJMgRrHvDe5dI2dFdwFK+f1pzOyrrWLHJpoy5jRBYrgu4BB04X6k/J
         GymlXDBFhS9Hr1XsGcNfbhM4Fl4xlUcGH7zgigL4zs5vfdlKU5KTCyLzuQMEOGXNLDzB
         oHp567OZT4ttD8mv39OaLq6CPwYww7YFe5JGl9k/1W/LwIjCvxFmybWzzwav5ATlkPah
         Kixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XcdQoaj6dvGwom9nqcUuI6XoafSmvPwycgz+Mpe6+pE=;
        b=BP7z5Zhud0m1jhXXWxl1V2pApnrzzNvAIVa7mSGKZajibo8aDGi+QxorpamS3nC+zr
         oWGdZaawA0gJQZeTE/47aCOQZ5KEIprK62xP2epnGjdOpgOYPNS7+XLpPXQkn6jiuEbq
         yB6p0BRwskTuD1dtwXSLLSc/eOuGvE/OiShp0ObS0bVbv9TWc3Z+8I+bOEfv7o22hZVy
         ig88SGeL0wmQSVkOmscvKgRbwcQZ3IaYWL7Xa1L2w6mX1s99IOGyQ46SkNKNKOWHhvwo
         uk2IAuMvFUKukKxdQssbmaO0PAKZmYL0TVir6aZ5G3eJo2oCUDj8eKjzuObEilI0eET1
         9pDw==
X-Gm-Message-State: APjAAAVz2gkTtZ9+7R2+exZqeRv7meFjCWdgYz4idqEiO5eqRyjVrpRh
        1ULfU86xDXtKRbjGC2h/4s1S/T/IDKEAwr4yZQ==
X-Google-Smtp-Source: APXvYqx7qB9+FI1+spPRBI6vu/7zpjHNIdwnRQsAGEhpaMm829xOYZLgKSKYllffwOLiPhuoZGUeHl0e8uroN0abmzU=
X-Received: by 2002:a2e:9118:: with SMTP id m24mr24092827ljg.105.1579805243113;
 Thu, 23 Jan 2020 10:47:23 -0800 (PST)
MIME-Version: 1.0
References: <20200123160906.28498-1-vincent.whitchurch@axis.com>
 <CAH2r5mtGMGSPoOKtGK1+DqRswV=k7B05L6SSm02CUamDw2=0ew@mail.gmail.com> <20200123170136.wnujtew76wwhpbmh@axis.com>
In-Reply-To: <20200123170136.wnujtew76wwhpbmh@axis.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 23 Jan 2020 10:47:11 -0800
Message-ID: <CAKywueSZpBd-VEWLz6WRadEbne-PMsOGYjErRuYsG5gML66mmg@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix task struct use-after-free on reconnect
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>, kernel@axis.com,
        Pavel Shilovskiy <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 23 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 09:02, Vincent Whi=
tchurch <vincent.whitchurch@axis.com>:
>
> On Thu, Jan 23, 2020 at 05:35:16PM +0100, Steve French wrote:
> > On Thu, Jan 23, 2020, 10:17 Vincent Whitchurch <vincent.whitchurch@axis=
.com> wrote:
> > > This can be reliably reproduced by adding the below delay to
> > > cifs_reconnect(), running find(1) on the mount, restarting the samba
> > > server while find is running, and killing find during the delay:
> > >
> > >         spin_unlock(&GlobalMid_Lock);
> > >         mutex_unlock(&server->srv_mutex);
> > >
> > >  +      msleep(10000);
> > >  +
> > >         cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
> > >         list_for_each_safe(tmp, tmp2, &retry_list) {
> > >                 mid_entry =3D list_entry(tmp, struct mid_q_entry, qhe=
ad);
> > >
> > > Fix this by holding a reference to the task struct until the MID is
> > > freed.
> >
> > Cc:stable as well?
>
> Yes, I think this bug has been there for a while.
>
> Note that the test described above usually triggers a different crash on
> kernels earlier than v5.4 because abe57073d08c13b95a46ccf48c ("CIFS: Fix
> retry mid list corruption on reconnects") has not (yet?) been backported
> to those stable kernels.

It has been only backported to 5.3.x - available from version 5.3.10.

The patch in the thread looks good. Good catch, thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
