Return-Path: <SRS0=9NYC=VO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C57C7618F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 01:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC3A20818
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 01:06:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IC8hvAs6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfGQBGH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Jul 2019 21:06:07 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:38924 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbfGQBGG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Jul 2019 21:06:06 -0400
Received: by mail-lj1-f175.google.com with SMTP id v18so21825588ljh.6;
        Tue, 16 Jul 2019 18:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TSLU7EI1xtPHWL9KS+LXmQXiP51HDd0zRoymweNi7yQ=;
        b=IC8hvAs6Vv7q8KAN+pYhSWf5WGxCm8YYauIkTkuPj6FfWV9KesOv59OOprC+bJO0k8
         MbygdOLxTTQycdXDEHTkOfsQxwoK+aSGU8R865Uaif6fYOTBDDF/Twd4AraUX58iKFjC
         qmWBje80GAMmwXtqvmDyPTPJ7aXg3EG2N6QuaseC8LH5eGQ4I1ME030GPsrZn4uiD4rs
         mN58l1AAquPT1jKNwJzIrb5QPMV1VV+1/unTd77pZoER1beUGAZ6j3rJip5Q10jRgyqQ
         MJMquk650SwuVKSK6iypAb9X8+/l/CDphw4IzvrbwezfJnEnJ6Th2U9CClyqW9JfkYuv
         6xjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TSLU7EI1xtPHWL9KS+LXmQXiP51HDd0zRoymweNi7yQ=;
        b=JOmI/nbLlKYLnEag8tH7w1YhQuGmIQJjAVZ6tfeFL9NnooE7C7TkKvPgFtMHnq2a14
         qy6ZOXWTlR3s6HDYJlwvIOjUDzdXhzAR3KHJmULaXdHAYzjKZNKwPb6S4Bw4YxRzfigk
         7iB+4waUSCiYqqIg8purE1jwczktT1vI1kL9WFTa5RjqpSdbGRMWnR6kuzyS7NUfFSIX
         bhMniwqi2tWG2yyB90U3nimwbrtdn8nPzOfTfviw56EzFsYPQEUAr8LuWik6H9JkH/Zo
         JWFmTT+tICMvVxNfeH6MzcRsF3jcjDBGwvCimOID4oXd/gNRu4XUL+qak284qZEZs2b7
         uO+g==
X-Gm-Message-State: APjAAAVh9RW941dt6Q61RevzzgR+2E4BWbYXFbBVke5RiuKdMZ/pcxXv
        kn29YizwMDVCeFrLskQ3MisB54A/+34wuKLagw==
X-Google-Smtp-Source: APXvYqyZT8jVJKmlQE61Al+JXIF4OK6uTzPaGF3bYXu7dQy9UOUnIDi0BKj+edChChg9HjaQ7rwleNosKuJdHCQdXLI=
X-Received: by 2002:a2e:8744:: with SMTP id q4mr18801028ljj.77.1563325564539;
 Tue, 16 Jul 2019 18:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtXjyUP6_h86o5GmKxZ2syubbnc2-L95ctf96=TvBnbyA@mail.gmail.com>
 <CAH2r5mtQ2QNn+fbdQ_HFSJQ-zv2m4-b02RYVGum0Fy+=yHgftA@mail.gmail.com> <CAN05THS4iCZdEruuLQRwvrMhdKrEL18-gN4CndtRPwxkuczz_Q@mail.gmail.com>
In-Reply-To: <CAN05THS4iCZdEruuLQRwvrMhdKrEL18-gN4CndtRPwxkuczz_Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 16 Jul 2019 18:05:53 -0700
Message-ID: <CAKywueR-5osR4kGZ9irxhOs-UP6RhvzZd9qHNw7P5RdLU5qnYg@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Add flock support
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
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

=D0=B2=D1=82, 16 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 18:02, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> Nice.
>
> Reviewed-by me
>
> On Wed, Jul 17, 2019 at 10:51 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Pavel spotted the problem - fixed and reattached updated patch
> >
> >
> > On Tue, Jul 16, 2019 at 7:02 PM Steve French <smfrench@gmail.com> wrote=
:
> > >
> > > The attached patch adds support for flock support similar to AFS, NFS=
 etc.
> > >
> > > Although the patch did seem to work in my experiments with flock, I d=
id notice
> > > that xfstest generic/504 fails because /proc/locks is not updated by =
cifs.ko
> > > after a successful lock.  Any idea which helper function does that?
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
