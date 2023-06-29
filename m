Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D578EB64D9
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jun 2023 16:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjF2QUe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Jun 2023 12:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjF2QUd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Jun 2023 12:20:33 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CA4CF
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jun 2023 09:20:31 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b5c231f842so13365791fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jun 2023 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688055630; x=1690647630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4cJKeFmFIlBfybDNKHucuRGkMEOvDUs6CvuRLBAtMM=;
        b=MZixZaIelxY33/87pfqP9xndIYWlOGAvCyhPZZ/4s1OeqsNmS1uYuJwWAjQkHr/WBU
         rW3SkR3Th+E5MudeD0yn2Ye1CGuXkcqCTKd3DGDOjhL6EylHiZQPoTmBcGPPf/v6O160
         ipw/sMC9ac2xQUjXrxDPXBCPSxXSn5knBuG75oFffawuoIm7p+DXoqbyFByEmtD7v4C4
         EIaMSYkndN86NduEdjMgUjha7cMwmLLPuaXVelrgLiIjaXDyNR8UtU0JD7IzpWBWfXBS
         6ucEtQ9xdMTG1R9Ol1Xi6lD6bdN9gcwMx0pa5xk0lTirtFjuf8kS/35p0B3gvnefAm+q
         OY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688055630; x=1690647630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v4cJKeFmFIlBfybDNKHucuRGkMEOvDUs6CvuRLBAtMM=;
        b=ldS60b/LngeIuPbAF8DYQ9bI/eIUNEbNeqDuc+BbtF+/RqhRJW5q/8mbfBloPYeDZ2
         twfFvYDSzQLwnsHLsgeYhmWij6PFqxvJaBuHGsmOQ7G6vhY25kYykwv7NCeOuuOnDiXg
         4XfhmpRN/oTRlJCMEkKdGvDrfbixsC3Q1ByyoXrXJZ2+Swbqyo/UDXCLrkKyaLbeJ1Ub
         d3QYEYZlqQtRB69R+ngBzqgwG7NIYnlqS/Xh3D1jDZCzABMExfoZw7ARjOdHi08e7tPu
         Z+7j76yrAp1x+4Ku2YrX2TvvafjHretxdwFKolQ98q4wWCDZsqrBjE1tlF9CUx06ZNcM
         q/dA==
X-Gm-Message-State: ABy/qLY5S09mzYqOoGoSCUQLVZe4MeB2m7xfFfKXv4n0iVTieeBfCr8b
        4TsFQMryEvGc6UbNm5Kl0Crrj8ChmWmtZLAZ/WG/FD4pel3QGQ==
X-Google-Smtp-Source: APBJJlFxs8L703T7qQL0hXLEN5JOf1SugDSCI7ZChxkEBeeUro1jMpAjKpKh/5bXHSa9MQNsJSY3KC6FrunaYvwhk2o=
X-Received: by 2002:a2e:97cc:0:b0:2b5:7fd2:ec36 with SMTP id
 m12-20020a2e97cc000000b002b57fd2ec36mr210309ljj.21.1688055629814; Thu, 29 Jun
 2023 09:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-2-wentao@uniontech.com> <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
 <CAH2r5mtE8EmEPdxHc+AT256-ekzH1wjmTO+DbODHx+5PEYC9eA@mail.gmail.com>
 <CANT5p=oETR0vg29rGohLXoeqw0Lrrt8GsLbhjV6snLth7od=Nw@mail.gmail.com>
 <5C32A54005DEE4A2+20230626163909.1bd13a8a@winn-pc> <CANT5p=otyXgTf+UO1e2TQFUFbrhEwoV=xe861tJUWNiErUBG_g@mail.gmail.com>
 <6DE3D09EA3AEE6B1+20230627153429.7c34759f@winn-pc> <CANT5p=pVwUUL2s_cOfxyw50bukT_iwpiCGvXHENqgYhkaD5oBg@mail.gmail.com>
 <20230628084333.7c9b8469@winn-pc> <4D492F4BF381CB0F+20230628095449.13f5ca57@winn-pc>
 <CAH2r5mtd4CXV1zoY0HYzLRUwTojOorvmdxQSaQ2h_HjbYZuHpw@mail.gmail.com> <B6042EB8D02BB921+20230629091443.26de9ea1@winn-pc>
In-Reply-To: <B6042EB8D02BB921+20230629091443.26de9ea1@winn-pc>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 29 Jun 2023 21:50:18 +0530
Message-ID: <CANT5p=qiPz+Mv-1b_Hk24zsi5FCFj033HCvKf9ptR++RfDZnzg@mail.gmail.com>
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

On Thu, Jun 29, 2023 at 6:45=E2=80=AFAM Winston Wen <wentao@uniontech.com> =
wrote:
>
> Hi Steve,
>
> On Wed, 28 Jun 2023 12:16:09 -0500
> Steve French <smfrench@gmail.com> wrote:
>
> > this didn't apply (merge conflict with Shyam's updated patch) - can
> > you update it based on for-next and resend
> >
> > Also let me know if you see other patches missing.
>
> With Shyam's updated patch, It is expected that no
> existing session would be found in the list, so the check of session
> state is no longer strictly necessary now, but don't hurt.
>
> So we have 2 choices in scanning the list:
> - do the check. (patch 2/3, merged)
> - remove the check and add a warning. (this new patch)
>
> If you find the latter to be better, you have the option to replace the
> original two patches with this new one.
>
> Alternatively, you can simply disregard the new patch and take no
> action, as the patch 2/3 has already been merged into the for-next
> branch. (This may be a better choice for now, but I don't have a strong
> opinion on this, both are okay to me.)
>
> Really sorry for my poor English and the lack of clarity in my
> explanation.
>
> >
> > On Tue, Jun 27, 2023 at 8:55=E2=80=AFPM Winston Wen <wentao@uniontech.c=
om>
> > wrote:
> > >
> > > On Wed, 28 Jun 2023 08:43:33 +0800
> > > Winston Wen <wentao@uniontech.com> wrote:
> > >
> > > > On Tue, 27 Jun 2023 17:43:25 +0530
> > > > Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > >
> > > > > On Tue, Jun 27, 2023 at 1:04=E2=80=AFPM Winston Wen
> > > > > <wentao@uniontech.com> wrote:
> > > > > >
> > > > > > On Tue, 27 Jun 2023 12:24:04 +0530
> > > > > > Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > > > >
> > > > > > > On Mon, Jun 26, 2023 at 2:09=E2=80=AFPM Winston Wen
> > > > > > > <wentao@uniontech.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, 26 Jun 2023 12:24:35 +0530
> > > > > > > > Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > > > > > >
> > > > > > > > > On Mon, Jun 26, 2023 at 10:54=E2=80=AFAM Steve French
> > > > > > > > > <smfrench@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Added Cc: stable and Shyam's RB and merged into
> > > > > > > > > > cifs-2.6.git for-next
> > > > > > > > > >
> > > > > > > > > > On Mon, Jun 26, 2023 at 12:15=E2=80=AFAM Shyam Prasad N
> > > > > > > > > > <nspmangalore@gmail.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Mon, Jun 26, 2023 at 9:25=E2=80=AFAM Winston Wen
> > > > > > > > > > > <wentao@uniontech.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > We switch session state to SES_EXITING without
> > > > > > > > > > > > cifs_tcp_ses_lock now, it may lead to potential
> > > > > > > > > > > > use-after-free issue.
> > > > > > > > > > > >
> > > > > > > > > > > > Consider the following execution processes:
> > > > > > > > > > > >
> > > > > > > > > > > > Thread 1:
> > > > > > > > > > > > __cifs_put_smb_ses()
> > > > > > > > > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > > > > > > > > >     if (--ses->ses_count > 0)
> > > > > > > > > > > >         spin_unlock(&cifs_tcp_ses_lock)
> > > > > > > > > > > >         return
> > > > > > > > > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > > > > > > > > >         ---> **GAP**
> > > > > > > > > > > >     spin_lock(&ses->ses_lock)
> > > > > > > > > > > >     if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > > > > > >         ses->ses_status =3D SES_EXITING
> > > > > > > > > > > >     spin_unlock(&ses->ses_lock)
> > > > > > > > > > > >
> > > > > > > > > > > > Thread 2:
> > > > > > > > > > > > cifs_find_smb_ses()
> > > > > > > > > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > > > > > > > > >     list_for_each_entry(ses, ...)
> > > > > > > > > > > >         spin_lock(&ses->ses_lock)
> > > > > > > > > > > >         if (ses->ses_status =3D=3D SES_EXITING)
> > > > > > > > > > > >             spin_unlock(&ses->ses_lock)
> > > > > > > > > > > >             continue
> > > > > > > > > > > >         ...
> > > > > > > > > > > >         spin_unlock(&ses->ses_lock)
> > > > > > > > > > > >     if (ret)
> > > > > > > > > > > >         cifs_smb_ses_inc_refcount(ret)
> > > > > > > > > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > > > > > > > > >
> > > > > > > > > > > > If thread 1 is preempted in the gap and thread 2
> > > > > > > > > > > > start executing, thread 2 will get the session,
> > > > > > > > > > > > and soon thread 1 will switch the session state
> > > > > > > > > > > > to SES_EXITING and start releasing it, even
> > > > > > > > > > > > though thread 1 had increased the session's
> > > > > > > > > > > > refcount and still uses it.
> > > > > > > > > > > >
> > > > > > > > > > > > So switch session state under cifs_tcp_ses_lock to
> > > > > > > > > > > > eliminate this gap.
> > > > > > > > > > > >
> > > > > > > > > > > > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >  fs/smb/client/connect.c | 7 ++++---
> > > > > > > > > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git a/fs/smb/client/connect.c
> > > > > > > > > > > > b/fs/smb/client/connect.c index
> > > > > > > > > > > > 9d16626e7a66..165ecb222c19 100644 ---
> > > > > > > > > > > > a/fs/smb/client/connect.c +++
> > > > > > > > > > > > b/fs/smb/client/connect.c @@ -1963,15 +1963,16 @@
> > > > > > > > > > > > void __cifs_put_smb_ses(struct cifs_ses *ses)
> > > > > > > > > > > > spin_unlock(&cifs_tcp_ses_lock); return;
> > > > > > > > > > > >         }
> > > > > > > > > > > > +       spin_lock(&ses->ses_lock);
> > > > > > > > > > > > +       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > > > > > > +               ses->ses_status =3D SES_EXITING;
> > > > > > > > > > > > +       spin_unlock(&ses->ses_lock);
> > > > > > > > > > > >         spin_unlock(&cifs_tcp_ses_lock);
> > > > > > > > > > > >
> > > > > > > > > > > >         /* ses_count can never go negative */
> > > > > > > > > > > >         WARN_ON(ses->ses_count < 0);
> > > > > > > > > > > >
> > > > > > > > > > > >         spin_lock(&ses->ses_lock);
> > > > > > > > > > > > -       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > > > > > > -               ses->ses_status =3D SES_EXITING;
> > > > > > > > > > > > -
> > > > > > > > > > > >         if (ses->ses_status =3D=3D SES_EXITING &&
> > > > > > > > > > > > server->ops->logoff) {
> > > > > > > > > > > > spin_unlock(&ses->ses_lock); cifs_free_ipc(ses);
> > > > > > > > > > > > --
> > > > > > > > > > > > 2.40.1
> > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Good catch.
> > > > > > > > > > > Looks good to me.
> > > > > > > > > > > @Steve French Please CC stable for this one.
> > > > > > > > > > >
> > > > > > > > > > > --
> > > > > > > > > > > Regards,
> > > > > > > > > > > Shyam
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > --
> > > > > > > > > > Thanks,
> > > > > > > > > >
> > > > > > > > > > Steve
> > > > > > > > >
> > > > > > > > > @Winston Wen I think the following change should be
> > > > > > > > > sufficient to fix this issue:
> > > > > > > > > diff --git a/fs/smb/client/connect.c
> > > > > > > > > b/fs/smb/client/connect.c index
> > > > > > > > > 9d16626e7a66..78874eb2537d 100644 ---
> > > > > > > > > a/fs/smb/client/connect.c +++ b/fs/smb/client/connect.c
> > > > > > > > > @@ -1963,10 +1963,11 @@ void __cifs_put_smb_ses(struct
> > > > > > > > > cifs_ses *ses) spin_unlock(&cifs_tcp_ses_lock);
> > > > > > > > >                 return;
> > > > > > > > >         }
> > > > > > > > > -       spin_unlock(&cifs_tcp_ses_lock);
> > > > > > > > >
> > > > > > > > >         /* ses_count can never go negative */
> > > > > > > > >         WARN_ON(ses->ses_count < 0);
> > > > > > > > > +       list_del_init(&ses->smb_ses_list);
> > > > > > > > > +       spin_unlock(&cifs_tcp_ses_lock);
> > > > > > > > >
> > > > > > > > >         spin_lock(&ses->ses_lock);
> > > > > > > > >         if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > > > @@ -1986,9 +1987,6 @@ void __cifs_put_smb_ses(struct
> > > > > > > > > cifs_ses *ses) cifs_free_ipc(ses);
> > > > > > > > >         }
> > > > > > > > >
> > > > > > > > > -       spin_lock(&cifs_tcp_ses_lock);
> > > > > > > > > -       list_del_init(&ses->smb_ses_list);
> > > > > > > > > -       spin_unlock(&cifs_tcp_ses_lock);
> > > > > > > > >
> > > > > > > > >         chan_count =3D ses->chan_count;
> > > > > > > > >
> > > > > > > > > The bug was that the ses was kept in the smb ses list,
> > > > > > > > > even after the ref count had reached 0.
> > > > > > > > > With the above change, that should be fixed, and no one
> > > > > > > > > should be able to get to the ses from that point.
> > > > > > > > >
> > > > > > > > > Please let me know if you see a problem with this.
> > > > > > > > >
> > > > > > > >
> > > > > > > > Hi Shyam,
> > > > > > > >
> > > > > > > > Thanks for the comments! And sorry for my late reply...
> > > > > > > >
> > > > > > > > It make sense to me that maybe we should remove the
> > > > > > > > session from the list once its refcount is reduced to 0
> > > > > > > > to avoid any futher access. In fact, I did try to do this
> > > > > > > > from the beginning. But I was not sure if we need to
> > > > > > > > access the session from the list in the free process,
> > > > > > > > such as the following:
> > > > > > > >
> > > > > > > > smb2_check_receive()
> > > > > > > >   smb2_verify_signature()
> > > > > > > >     server->ops->calc_signature()
> > > > > > > >       smb2_calc_signature()
> > > > > > > >         smb2_find_smb_ses()
> > > > > > > >           /* scan the list and find the session */
> > > > > > > >
> > > > > > > > Perhaps we need some refactoring here.
> > > > > > >
> > > > > > > Yes. The above ses finding is expected to fail during a
> > > > > > > reconnect.
> > > > > >
> > > > > > Agreed.
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > So I gave up on this approach and did a small fix to make
> > > > > > > > it work, but maybe I missed something elsewhere...
> > > > > > > >
> > > > > > > >
> > > > > > > > --
> > > > > > > > Thanks,
> > > > > > > > Winston
> > > > > > >
> > > > > > > Attaching the above change as a patch.
> > > > > > > It replaces this particular patch in the series.
> > > > > >
> > > > > > I think this is a better way to fix the problem, the session
> > > > > > really should not stay in the list and be found after it has
> > > > > > been marked EXITING.
> > > > > >
> > > > > > >
> > > > > > > The other two patches are not strictly necessary with this
> > > > > > > change, but don't hurt.
> > > > > > >
> > > > > >
> > > > > > Yes. Feel free to drop them if they are not necessary. And if
> > > > > > that's the case, perhaps we should do some cleaning work on
> > > > > > other paths to ensure consistency.
> > > > >
> > > > > I don't really have a strong opinion about this. Even if they
> > > > > stay, I'm okay. But curious to know what you mean by the
> > > > > cleaning work on other paths here. Do you still think there's
> > > > > more cleanup needed around this?
> > > >
> > > > IIRC there are other paths that scan the list and do the
> > > > check, like cifs_find_smb_ses(). So I think if they become
> > > > unnecessary now after this fix patch, maybe we can also remove
> > > > them at the same time to avoid make others confused.
> > > >
> > > > But I also don't have a strong opinion about this. I think we
> > > > have the following options and all are okay to me. Which one do
> > > > you prefer?
> > > >
> > > > - keep/add the check
> > > > - remove all checks
> > > > - remove all checks and add a WARNING
> > > >
> > > > (I think we shouldn't find a exiting session in the list now.)
> > > >
> > > > >
> > > > > >
> > > > > > Thanks for your review and comments!
> > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Regards,
> > > > > > > Shyam
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > > Winston
> > > > >
> > > > >
> > > > >
> > > >
> > > >
> > > >
> > >
> > > Attaching the patch (remove all checks and add a warning)
> > >
> > > --
> > > Thanks,
> > > Winston
> >
> >
> >
>
>
>
> --
> Thanks,
> Winston

Hi Winston/Steve,

It turns out that my patch above has a problem.
For logoff to work, we need the session in the smb_ses_list.
So I think Winston's patch series here make sense.

@Winston Wen We may need similar checks for SES_EXITING in other
places where we iterate smb_ses_list.
Can you see if all the places are covered and send additional patches if ne=
eded?
If you do not get to it in a few days, I can do it myself.

Thanks for these patches. Keep them coming. :)

--=20
Regards,
Shyam
