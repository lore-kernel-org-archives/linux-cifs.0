Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E444DEB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 12:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjF0MNl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 08:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjF0MNk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 08:13:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2328C198D
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 05:13:39 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f954d7309fso5480918e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 05:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687868017; x=1690460017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAXajbY9H8JDnfWHAcshAUnhIb2L7Pi/chMSBT/azoo=;
        b=qB6D6mTZYuBb4R/7xfRQXSTPF6wxr7G5N8LDDlfrIHEN1uinTPblubuoi1RoGckhTr
         cyS+zlOkK64p4HTsJMuXjQhPSyksItQzcsEV6qXwSaZzYTq/pqtI7F7rOISttmOsnx0v
         ddlPWe4jJhsTvpK2YJB2jVWZpL5Ov6vM++nqYlhZkQP5qtWmC8OWbhmB2X3Jr2nIG2S5
         ZCa2+8M/YBfOTG5XPCBdFOjURe1Rf9rdlIaDbf1HchEhrwKCQBwvChQwSisHNTo9fYOn
         topFV6+9Br75GAIx97WvGzEGNQ7N8jbUrdjiGoD8cgDBRE8xYoxX37uW22PpjaeGAOA9
         HbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687868017; x=1690460017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fAXajbY9H8JDnfWHAcshAUnhIb2L7Pi/chMSBT/azoo=;
        b=kOYEB2orCPuY5pocZCsRSrfAF4eFMzgmRS4V8DmC6q+NOLf3UgR9Fg8al2MvmPvkGX
         HDtNaqqX6adrXaMyMw3XKSb2lMLgYxRwQxW877HYWfr7PC8148QbA34nxJWwBO9rUt2T
         mAy85hanuPQzyMq1Tsq1wdyThKB+De/AjWd6dnP3ZvLUtEvjXbJ8m+F0Xrlzo65Vxytz
         yAoESmsH8nXYiN3nnNBcPkX1/Hze7R5UsyTnKI+B+X0pxx73viD4Yp2MBZYJbXPr42zh
         NLbgFhl0cwsdDr7UTwc0ODXMav4Vr/dx3pmQEQpunaRSdHaY8W0LrqidXq1h/AE1SYhq
         bKJA==
X-Gm-Message-State: AC+VfDxExXpU/rNmc6r/1xygaI210sWgN7L9+76FMPaprlm4piabQIZf
        NYrHyk+c77k9HDxH9yG0VMGoaW8+O2FbmMTC+i4=
X-Google-Smtp-Source: ACHHUZ5CD5pALD17wGQwM2h/dHs9SJoqdbwNt7dLk41mGsXe+Gq6EiVw5jbrkbBUICchqZK+EuA1Kp5BN2nz0/Oja6U=
X-Received: by 2002:ac2:5e99:0:b0:4f7:6462:e036 with SMTP id
 b25-20020ac25e99000000b004f76462e036mr10925678lfq.11.1687868016902; Tue, 27
 Jun 2023 05:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-2-wentao@uniontech.com> <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
 <CAH2r5mtE8EmEPdxHc+AT256-ekzH1wjmTO+DbODHx+5PEYC9eA@mail.gmail.com>
 <CANT5p=oETR0vg29rGohLXoeqw0Lrrt8GsLbhjV6snLth7od=Nw@mail.gmail.com>
 <5C32A54005DEE4A2+20230626163909.1bd13a8a@winn-pc> <CANT5p=otyXgTf+UO1e2TQFUFbrhEwoV=xe861tJUWNiErUBG_g@mail.gmail.com>
 <6DE3D09EA3AEE6B1+20230627153429.7c34759f@winn-pc>
In-Reply-To: <6DE3D09EA3AEE6B1+20230627153429.7c34759f@winn-pc>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 27 Jun 2023 17:43:25 +0530
Message-ID: <CANT5p=pVwUUL2s_cOfxyw50bukT_iwpiCGvXHENqgYhkaD5oBg@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: fix session state transition to avoid
 use-after-free issue
To:     Winston Wen <wentao@uniontech.com>
Cc:     Steve French <smfrench@gmail.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 27, 2023 at 1:04=E2=80=AFPM Winston Wen <wentao@uniontech.com> =
wrote:
>
> On Tue, 27 Jun 2023 12:24:04 +0530
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > On Mon, Jun 26, 2023 at 2:09=E2=80=AFPM Winston Wen <wentao@uniontech.c=
om>
> > wrote:
> > >
> > > On Mon, 26 Jun 2023 12:24:35 +0530
> > > Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > > On Mon, Jun 26, 2023 at 10:54=E2=80=AFAM Steve French <smfrench@gma=
il.com>
> > > > wrote:
> > > > >
> > > > > Added Cc: stable and Shyam's RB and merged into cifs-2.6.git
> > > > > for-next
> > > > >
> > > > > On Mon, Jun 26, 2023 at 12:15=E2=80=AFAM Shyam Prasad N
> > > > > <nspmangalore@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jun 26, 2023 at 9:25=E2=80=AFAM Winston Wen
> > > > > > <wentao@uniontech.com> wrote:
> > > > > > >
> > > > > > > We switch session state to SES_EXITING without
> > > > > > > cifs_tcp_ses_lock now, it may lead to potential
> > > > > > > use-after-free issue.
> > > > > > >
> > > > > > > Consider the following execution processes:
> > > > > > >
> > > > > > > Thread 1:
> > > > > > > __cifs_put_smb_ses()
> > > > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > > > >     if (--ses->ses_count > 0)
> > > > > > >         spin_unlock(&cifs_tcp_ses_lock)
> > > > > > >         return
> > > > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > > > >         ---> **GAP**
> > > > > > >     spin_lock(&ses->ses_lock)
> > > > > > >     if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > >         ses->ses_status =3D SES_EXITING
> > > > > > >     spin_unlock(&ses->ses_lock)
> > > > > > >
> > > > > > > Thread 2:
> > > > > > > cifs_find_smb_ses()
> > > > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > > > >     list_for_each_entry(ses, ...)
> > > > > > >         spin_lock(&ses->ses_lock)
> > > > > > >         if (ses->ses_status =3D=3D SES_EXITING)
> > > > > > >             spin_unlock(&ses->ses_lock)
> > > > > > >             continue
> > > > > > >         ...
> > > > > > >         spin_unlock(&ses->ses_lock)
> > > > > > >     if (ret)
> > > > > > >         cifs_smb_ses_inc_refcount(ret)
> > > > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > > > >
> > > > > > > If thread 1 is preempted in the gap and thread 2 start
> > > > > > > executing, thread 2 will get the session, and soon thread 1
> > > > > > > will switch the session state to SES_EXITING and start
> > > > > > > releasing it, even though thread 1 had increased the
> > > > > > > session's refcount and still uses it.
> > > > > > >
> > > > > > > So switch session state under cifs_tcp_ses_lock to eliminate
> > > > > > > this gap.
> > > > > > >
> > > > > > > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > > > > > > ---
> > > > > > >  fs/smb/client/connect.c | 7 ++++---
> > > > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/fs/smb/client/connect.c
> > > > > > > b/fs/smb/client/connect.c index 9d16626e7a66..165ecb222c19
> > > > > > > 100644 --- a/fs/smb/client/connect.c
> > > > > > > +++ b/fs/smb/client/connect.c
> > > > > > > @@ -1963,15 +1963,16 @@ void __cifs_put_smb_ses(struct
> > > > > > > cifs_ses *ses) spin_unlock(&cifs_tcp_ses_lock);
> > > > > > >                 return;
> > > > > > >         }
> > > > > > > +       spin_lock(&ses->ses_lock);
> > > > > > > +       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > +               ses->ses_status =3D SES_EXITING;
> > > > > > > +       spin_unlock(&ses->ses_lock);
> > > > > > >         spin_unlock(&cifs_tcp_ses_lock);
> > > > > > >
> > > > > > >         /* ses_count can never go negative */
> > > > > > >         WARN_ON(ses->ses_count < 0);
> > > > > > >
> > > > > > >         spin_lock(&ses->ses_lock);
> > > > > > > -       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > -               ses->ses_status =3D SES_EXITING;
> > > > > > > -
> > > > > > >         if (ses->ses_status =3D=3D SES_EXITING &&
> > > > > > > server->ops->logoff) { spin_unlock(&ses->ses_lock);
> > > > > > >                 cifs_free_ipc(ses);
> > > > > > > --
> > > > > > > 2.40.1
> > > > > > >
> > > > > >
> > > > > > Good catch.
> > > > > > Looks good to me.
> > > > > > @Steve French Please CC stable for this one.
> > > > > >
> > > > > > --
> > > > > > Regards,
> > > > > > Shyam
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > > >
> > > > @Winston Wen I think the following change should be sufficient to
> > > > fix this issue:
> > > > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > > > index 9d16626e7a66..78874eb2537d 100644
> > > > --- a/fs/smb/client/connect.c
> > > > +++ b/fs/smb/client/connect.c
> > > > @@ -1963,10 +1963,11 @@ void __cifs_put_smb_ses(struct cifs_ses
> > > > *ses) spin_unlock(&cifs_tcp_ses_lock);
> > > >                 return;
> > > >         }
> > > > -       spin_unlock(&cifs_tcp_ses_lock);
> > > >
> > > >         /* ses_count can never go negative */
> > > >         WARN_ON(ses->ses_count < 0);
> > > > +       list_del_init(&ses->smb_ses_list);
> > > > +       spin_unlock(&cifs_tcp_ses_lock);
> > > >
> > > >         spin_lock(&ses->ses_lock);
> > > >         if (ses->ses_status =3D=3D SES_GOOD)
> > > > @@ -1986,9 +1987,6 @@ void __cifs_put_smb_ses(struct cifs_ses
> > > > *ses) cifs_free_ipc(ses);
> > > >         }
> > > >
> > > > -       spin_lock(&cifs_tcp_ses_lock);
> > > > -       list_del_init(&ses->smb_ses_list);
> > > > -       spin_unlock(&cifs_tcp_ses_lock);
> > > >
> > > >         chan_count =3D ses->chan_count;
> > > >
> > > > The bug was that the ses was kept in the smb ses list, even after
> > > > the ref count had reached 0.
> > > > With the above change, that should be fixed, and no one should be
> > > > able to get to the ses from that point.
> > > >
> > > > Please let me know if you see a problem with this.
> > > >
> > >
> > > Hi Shyam,
> > >
> > > Thanks for the comments! And sorry for my late reply...
> > >
> > > It make sense to me that maybe we should remove the session from the
> > > list once its refcount is reduced to 0 to avoid any futher access.
> > > In fact, I did try to do this from the beginning. But I was not
> > > sure if we need to access the session from the list in the free
> > > process, such as the following:
> > >
> > > smb2_check_receive()
> > >   smb2_verify_signature()
> > >     server->ops->calc_signature()
> > >       smb2_calc_signature()
> > >         smb2_find_smb_ses()
> > >           /* scan the list and find the session */
> > >
> > > Perhaps we need some refactoring here.
> >
> > Yes. The above ses finding is expected to fail during a reconnect.
>
> Agreed.
>
> >
> > >
> > > So I gave up on this approach and did a small fix to make it work,
> > > but maybe I missed something elsewhere...
> > >
> > >
> > > --
> > > Thanks,
> > > Winston
> >
> > Attaching the above change as a patch.
> > It replaces this particular patch in the series.
>
> I think this is a better way to fix the problem, the session really
> should not stay in the list and be found after it has been marked
> EXITING.
>
> >
> > The other two patches are not strictly necessary with this change, but
> > don't hurt.
> >
>
> Yes. Feel free to drop them if they are not necessary. And if that's
> the case, perhaps we should do some cleaning work on other paths to
> ensure consistency.

I don't really have a strong opinion about this. Even if they stay, I'm oka=
y.
But curious to know what you mean by the cleaning work on other paths here.
Do you still think there's more cleanup needed around this?

>
> Thanks for your review and comments!
>
> >
> > --
> > Regards,
> > Shyam
>
>
> --
> Thanks,
> Winston



--=20
Regards,
Shyam
