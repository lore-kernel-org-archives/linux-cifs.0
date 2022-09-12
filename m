Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D7AECAAA1
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 05:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiILFdI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 01:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiILFdH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 01:33:07 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2947E0A8
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 22:33:06 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id o123so7839600vsc.3
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 22:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date;
        bh=TX1+TD1A3cpP2dANAboxS7RYaUQFEi51AIVqYmjuYF0=;
        b=nfBZtG3RfMKUZyODhwOJIapBC4mEGXcaJCZ25rczA1K14YZ9toDfw/ZlgrK0wpTTDE
         IUH8m/dvWlQFtsRA9gfNvnnDmQbgHne9ZpjKtbJT9zXT6fJenPr5w51gZd38NPUBW3vu
         yUbAfF48TgMRYDum0sph7RfPRIEvlY0z5yuuyC+LT48LXxrrveQwWAiH/ab79auFr2J5
         1AYgg+UkoMoLNXjH1gy05tH0C0eTeB5W/8gfYZEKHlJGyeFwyw+srGKUmUijDWIoRxpu
         Q0DXIHZn/S79Z+p6psnRbhLQmVsaTyvNdpISwSZ3pIR3RzwWFRk2278+opbtqiVboWIn
         fpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TX1+TD1A3cpP2dANAboxS7RYaUQFEi51AIVqYmjuYF0=;
        b=eqKHjAKwCDoNDfw7Lba1DV0icwsWpb3SIW8OJD06owKYBabPeXWRCv1Mmy0kzrBT3q
         SqKi9/e1254v4CZenxSpUIyMZhuQLtGzdOTeNyrfw17mtz+Pah4Y9XskfbX98EDAmQS0
         piSGUVOi8YMcUPJCaZtWqE5XVTKlVXlNt4Qtt2e99NF4fhjFlCTWxF35UaW/axb65LtP
         P8SLTKjQUhlfqfZh1LMiEb4jH8VmRQTps7Whth9xk3Aa66uUgVhwRVZNly+YG/4Q6L2G
         3Cd1VimFg4oMHjQ8biI2st4Q6Dxcugy7lI3AhjOu3/DQM9n2Oas/PPIsReDxD/3/dkQc
         vP3Q==
X-Gm-Message-State: ACgBeo2Hkkf6S/8PTVSa00qxQs5TfnCnfOAT2qe+UgQ7U4tsSdec3vqr
        Pj4r5P3NqKgzWWXY0GNY/aMzTVrBYERfQRhI3vUY7qtR
X-Google-Smtp-Source: AA6agR45gnDi604WpTMjqBvGf2lZCIyz9nFwBA28dW4pQrn+XszYIbkpBsonPYHdvj2pmRL0BrKfQ9vg1gqUILYGDZw=
X-Received: by 2002:a67:702:0:b0:397:1b01:422b with SMTP id
 2-20020a670702000000b003971b01422bmr7234092vsh.61.1662960785651; Sun, 11 Sep
 2022 22:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220912030446.173296-1-lsahlber@redhat.com> <20220912030446.173296-2-lsahlber@redhat.com>
 <CAH2r5mvh5_XbVxu0idZgt5A=zEr=4k7DF8Omf4VZOdrgCNkOfA@mail.gmail.com>
In-Reply-To: <CAH2r5mvh5_XbVxu0idZgt5A=zEr=4k7DF8Omf4VZOdrgCNkOfA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 12 Sep 2022 00:32:54 -0500
Message-ID: <CAH2r5mvnZ+6T840kZ5y6bY_SdvWT1DAbQaDUVdtrkPPu-rCMTw@mail.gmail.com>
Subject: Fwd: [PATCH] cifs: revalidate mapping when doing direct writes
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Mon, Sep 12, 2022 at 12:30 AM
Subject: Re: [PATCH] cifs: revalidate mapping when doing direct writes
To: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: linux-cifs <linux-cifs@vger.kernel.org>, Ronnie Sahlberg
<lsahlber@redhat.com>


added cc:stable and tentatively merged into cifs-2.6.git for-next
pending testing

Also let me know if you think this could address any long standing
xfstest failures

On Sun, Sep 11, 2022 at 10:05 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Kernel bugzilla: 216301
>
> When doing direct writes we need to also invalidate the mapping in case
> we have a cached copy of the affected page(s) in memory or else
> subsequent reads of the data might return the old/stale content
> before we wrote an update to the server.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/file.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index fa738adc031f..6f38b134a346 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3575,6 +3575,9 @@ static ssize_t __cifs_writev(
>
>  ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
>  {
> +       struct file *file = iocb->ki_filp;
> +
> +       cifs_revalidate_mapping(file->f_inode);
>         return __cifs_writev(iocb, from, true);
>  }
>
> --
> 2.35.3
>


-- 
Thanks,

Steve


-- 
Thanks,

Steve
