Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1DBEB64DC
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 08:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjFZIjW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 04:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjFZIjV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 04:39:21 -0400
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DD3E7A
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 01:39:17 -0700 (PDT)
X-QQ-mid: bizesmtp89t1687768750tv0j5cik
Received: from winn-pc ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 26 Jun 2023 16:39:09 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: 7jw2iSiCazpzzAkMQ5Ni3jHjxJYVnAaeTS57D/1UTKNcVYEso17jfpHdLQ+TA
        ljvr98hvSc9OrTQHc8TYVkpBzFXZiDy4WjzDt9SAe6OV/Dg7qxrVXJkhoyOysF3qrX6CcJi
        r5G7kdLeqxxxONV0dZ6P+A6svW9CoGeC4WWlIQDaHUuFxLYAOmdNVAli7tnxNuphqSd+wnX
        Vp2KF3Kp/Vo4+mzBOjimlkh0Tmj+6wEs3IKqO7sYxtGu9Hl/aQn79YWVb5A+6HnFNRlhBiR
        4wMdlaYy1tsGO9Wu8pJv0j69P27eAxYfYMaazNZDQAwq8iF2376cXYfg6CWxbrdBbG90hGN
        Me9sk2e9eFp+Fi+mGIrm6RJvHl0e3/7/HQdy/6P9RfZP+jvXOKdxKrxFCo26tVQ6m01HBXO
        qoEuTrHlRCCVQnyK+Avg+g==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3757514373026325362
Date:   Mon, 26 Jun 2023 16:39:09 +0800
From:   Winston Wen <wentao@uniontech.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com
Subject: Re: [PATCH 1/3] cifs: fix session state transition to avoid
 use-after-free issue
Message-ID: <5C32A54005DEE4A2+20230626163909.1bd13a8a@winn-pc>
In-Reply-To: <CANT5p=oETR0vg29rGohLXoeqw0Lrrt8GsLbhjV6snLth7od=Nw@mail.gmail.com>
References: <20230626034257.2078391-1-wentao@uniontech.com>
        <20230626034257.2078391-2-wentao@uniontech.com>
        <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
        <CAH2r5mtE8EmEPdxHc+AT256-ekzH1wjmTO+DbODHx+5PEYC9eA@mail.gmail.com>
        <CANT5p=oETR0vg29rGohLXoeqw0Lrrt8GsLbhjV6snLth7od=Nw@mail.gmail.com>
Organization: Uniontech
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 26 Jun 2023 12:24:35 +0530
Shyam Prasad N <nspmangalore@gmail.com> wrote:

> On Mon, Jun 26, 2023 at 10:54 AM Steve French <smfrench@gmail.com>
> wrote:
> >
> > Added Cc: stable and Shyam's RB and merged into cifs-2.6.git
> > for-next
> >
> > On Mon, Jun 26, 2023 at 12:15 AM Shyam Prasad N
> > <nspmangalore@gmail.com> wrote:
> > >
> > > On Mon, Jun 26, 2023 at 9:25 AM Winston Wen
> > > <wentao@uniontech.com> wrote:
> > > >
> > > > We switch session state to SES_EXITING without
> > > > cifs_tcp_ses_lock now, it may lead to potential use-after-free
> > > > issue.
> > > >
> > > > Consider the following execution processes:
> > > >
> > > > Thread 1:
> > > > __cifs_put_smb_ses()
> > > >     spin_lock(&cifs_tcp_ses_lock)
> > > >     if (--ses->ses_count > 0)
> > > >         spin_unlock(&cifs_tcp_ses_lock)
> > > >         return
> > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > >         ---> **GAP**
> > > >     spin_lock(&ses->ses_lock)
> > > >     if (ses->ses_status == SES_GOOD)
> > > >         ses->ses_status = SES_EXITING
> > > >     spin_unlock(&ses->ses_lock)
> > > >
> > > > Thread 2:
> > > > cifs_find_smb_ses()
> > > >     spin_lock(&cifs_tcp_ses_lock)
> > > >     list_for_each_entry(ses, ...)
> > > >         spin_lock(&ses->ses_lock)
> > > >         if (ses->ses_status == SES_EXITING)
> > > >             spin_unlock(&ses->ses_lock)
> > > >             continue
> > > >         ...
> > > >         spin_unlock(&ses->ses_lock)
> > > >     if (ret)
> > > >         cifs_smb_ses_inc_refcount(ret)
> > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > >
> > > > If thread 1 is preempted in the gap and thread 2 start
> > > > executing, thread 2 will get the session, and soon thread 1
> > > > will switch the session state to SES_EXITING and start
> > > > releasing it, even though thread 1 had increased the session's
> > > > refcount and still uses it.
> > > >
> > > > So switch session state under cifs_tcp_ses_lock to eliminate
> > > > this gap.
> > > >
> > > > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > > > ---
> > > >  fs/smb/client/connect.c | 7 ++++---
> > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > > > index 9d16626e7a66..165ecb222c19 100644
> > > > --- a/fs/smb/client/connect.c
> > > > +++ b/fs/smb/client/connect.c
> > > > @@ -1963,15 +1963,16 @@ void __cifs_put_smb_ses(struct cifs_ses
> > > > *ses) spin_unlock(&cifs_tcp_ses_lock);
> > > >                 return;
> > > >         }
> > > > +       spin_lock(&ses->ses_lock);
> > > > +       if (ses->ses_status == SES_GOOD)
> > > > +               ses->ses_status = SES_EXITING;
> > > > +       spin_unlock(&ses->ses_lock);
> > > >         spin_unlock(&cifs_tcp_ses_lock);
> > > >
> > > >         /* ses_count can never go negative */
> > > >         WARN_ON(ses->ses_count < 0);
> > > >
> > > >         spin_lock(&ses->ses_lock);
> > > > -       if (ses->ses_status == SES_GOOD)
> > > > -               ses->ses_status = SES_EXITING;
> > > > -
> > > >         if (ses->ses_status == SES_EXITING &&
> > > > server->ops->logoff) { spin_unlock(&ses->ses_lock);
> > > >                 cifs_free_ipc(ses);
> > > > --
> > > > 2.40.1
> > > >
> > >
> > > Good catch.
> > > Looks good to me.
> > > @Steve French Please CC stable for this one.
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> 
> @Winston Wen I think the following change should be sufficient to fix
> this issue:
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 9d16626e7a66..78874eb2537d 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1963,10 +1963,11 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>                 spin_unlock(&cifs_tcp_ses_lock);
>                 return;
>         }
> -       spin_unlock(&cifs_tcp_ses_lock);
> 
>         /* ses_count can never go negative */
>         WARN_ON(ses->ses_count < 0);
> +       list_del_init(&ses->smb_ses_list);
> +       spin_unlock(&cifs_tcp_ses_lock);
> 
>         spin_lock(&ses->ses_lock);
>         if (ses->ses_status == SES_GOOD)
> @@ -1986,9 +1987,6 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>                 cifs_free_ipc(ses);
>         }
> 
> -       spin_lock(&cifs_tcp_ses_lock);
> -       list_del_init(&ses->smb_ses_list);
> -       spin_unlock(&cifs_tcp_ses_lock);
> 
>         chan_count = ses->chan_count;
> 
> The bug was that the ses was kept in the smb ses list, even after the
> ref count had reached 0.
> With the above change, that should be fixed, and no one should be able
> to get to the ses from that point.
> 
> Please let me know if you see a problem with this.
> 

Hi Shyam,

Thanks for the comments! And sorry for my late reply...

It make sense to me that maybe we should remove the session from the
list once its refcount is reduced to 0 to avoid any futher access. In
fact, I did try to do this from the beginning. But I was not sure if we
need to access the session from the list in the free process, such
as the following:

smb2_check_receive()
  smb2_verify_signature()
    server->ops->calc_signature()
      smb2_calc_signature()
        smb2_find_smb_ses()
          /* scan the list and find the session */

Perhaps we need some refactoring here.

So I gave up on this approach and did a small fix to make it work, but
maybe I missed something elsewhere...


-- 
Thanks,
Winston
