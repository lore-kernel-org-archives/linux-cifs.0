Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E1EEB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 05:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjFZFYz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 01:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjFZFYy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 01:24:54 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3271B180
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:24:53 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b4826ba943so36699821fa.0
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687757091; x=1690349091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqpsy0G5trW5/Jz+doM4dhem17NmuiNHkH0utIMDgNo=;
        b=b87gl9fNeb3YdBO+yFzBllXKwT/LwRb2mHZcVZc2DQGbqB9RhwO7GaBVlolZTw4yFW
         K0IHxnbbtDI3T6NZ4/FJZurMOMl6tx3mFDuXtCBV+bTZE3uPzdn3LSOwAS9oRFjid4oM
         BH4ebsaN2GpGEeWB4+qsvrB0rJq+UBhB6LwcgB6D/q/+Q44PFlT1MSuua8ospgfn8xHM
         v55bqMrSbtmhtg8E9iMN5rjUtSZ/UY4+PhX684IV5kgeELIK8T9bdzMDzzDUq7jHOtVg
         VhHimtUGmvtYRCx6kU/nSQnbC+RSKa/B9qsSnDwaZwQa70ZGCW3xmzajNgztPFnBjFS2
         nT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687757091; x=1690349091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xqpsy0G5trW5/Jz+doM4dhem17NmuiNHkH0utIMDgNo=;
        b=Gy+0YF01i209vgaSBeHs96GzFMTa/LnURl87FYIQ8Q99bVSij5xCQRRCqZVPuKPlDZ
         SsiayPZFupZTwVoTGam1sKhy3anYkoB3By2e4KO2AoQ8L6VYB4uNt2zbxLGGGepYoL4p
         An8cZrU/xT7sqgQ9gme778603N778UzKLZxVBCoHkZQP6BA4yHYQtNJfxtOOwuoo9Gc2
         b5IfwdN2aq0aJ+CvkEsQxscqg5VWrQ0QS46ANvm0aoea0KcBhMwEqLN0gzrLJfwva1h3
         57Xf+LgYRilx80zqjbm/3+OniF4WSRJmRUVJso4t2alN+UPgqMv2sRaPgEQ285aSJqYs
         W+wg==
X-Gm-Message-State: AC+VfDyIdefyNsJHXvOGve3A6TughfJK3ARH6LT1v+NZ3pbOGbMNx+Bq
        CEOHH/MqttjVj5zKSmG6op3gpj0bo9cettie0qM=
X-Google-Smtp-Source: ACHHUZ7DvwmdBw/8+R2Q2Br0SVprwd/Ml+IiFVnPDVwpzl5JER4pWjuaebZwb/JGFcPbTrhT9fyKCwCxwsZK7177xzI=
X-Received: by 2002:a2e:3816:0:b0:2b5:68ad:291f with SMTP id
 f22-20020a2e3816000000b002b568ad291fmr10232770lja.19.1687757091113; Sun, 25
 Jun 2023 22:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-2-wentao@uniontech.com> <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
In-Reply-To: <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Jun 2023 00:24:39 -0500
Message-ID: <CAH2r5mtE8EmEPdxHc+AT256-ekzH1wjmTO+DbODHx+5PEYC9eA@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: fix session state transition to avoid
 use-after-free issue
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Winston Wen <wentao@uniontech.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added Cc: stable and Shyam's RB and merged into cifs-2.6.git for-next

On Mon, Jun 26, 2023 at 12:15=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Mon, Jun 26, 2023 at 9:25=E2=80=AFAM Winston Wen <wentao@uniontech.com=
> wrote:
> >
> > We switch session state to SES_EXITING without cifs_tcp_ses_lock now,
> > it may lead to potential use-after-free issue.
> >
> > Consider the following execution processes:
> >
> > Thread 1:
> > __cifs_put_smb_ses()
> >     spin_lock(&cifs_tcp_ses_lock)
> >     if (--ses->ses_count > 0)
> >         spin_unlock(&cifs_tcp_ses_lock)
> >         return
> >     spin_unlock(&cifs_tcp_ses_lock)
> >         ---> **GAP**
> >     spin_lock(&ses->ses_lock)
> >     if (ses->ses_status =3D=3D SES_GOOD)
> >         ses->ses_status =3D SES_EXITING
> >     spin_unlock(&ses->ses_lock)
> >
> > Thread 2:
> > cifs_find_smb_ses()
> >     spin_lock(&cifs_tcp_ses_lock)
> >     list_for_each_entry(ses, ...)
> >         spin_lock(&ses->ses_lock)
> >         if (ses->ses_status =3D=3D SES_EXITING)
> >             spin_unlock(&ses->ses_lock)
> >             continue
> >         ...
> >         spin_unlock(&ses->ses_lock)
> >     if (ret)
> >         cifs_smb_ses_inc_refcount(ret)
> >     spin_unlock(&cifs_tcp_ses_lock)
> >
> > If thread 1 is preempted in the gap and thread 2 start executing, threa=
d 2
> > will get the session, and soon thread 1 will switch the session state t=
o
> > SES_EXITING and start releasing it, even though thread 1 had increased =
the
> > session's refcount and still uses it.
> >
> > So switch session state under cifs_tcp_ses_lock to eliminate this gap.
> >
> > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > ---
> >  fs/smb/client/connect.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 9d16626e7a66..165ecb222c19 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1963,15 +1963,16 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >                 spin_unlock(&cifs_tcp_ses_lock);
> >                 return;
> >         }
> > +       spin_lock(&ses->ses_lock);
> > +       if (ses->ses_status =3D=3D SES_GOOD)
> > +               ses->ses_status =3D SES_EXITING;
> > +       spin_unlock(&ses->ses_lock);
> >         spin_unlock(&cifs_tcp_ses_lock);
> >
> >         /* ses_count can never go negative */
> >         WARN_ON(ses->ses_count < 0);
> >
> >         spin_lock(&ses->ses_lock);
> > -       if (ses->ses_status =3D=3D SES_GOOD)
> > -               ses->ses_status =3D SES_EXITING;
> > -
> >         if (ses->ses_status =3D=3D SES_EXITING && server->ops->logoff) =
{
> >                 spin_unlock(&ses->ses_lock);
> >                 cifs_free_ipc(ses);
> > --
> > 2.40.1
> >
>
> Good catch.
> Looks good to me.
> @Steve French Please CC stable for this one.
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
