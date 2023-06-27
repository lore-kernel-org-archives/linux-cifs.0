Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26B9EB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 04:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjF0E3h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 00:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjF0E3g (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 00:29:36 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88185DC
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 21:29:34 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f957a45b10so5322518e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 21:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687840173; x=1690432173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+QydbhvUzSfB+GyWlFD2zcHwU5Ngevv/JXFxv4fPuo=;
        b=Pz0K63GL3DVITHju08Ohao7yfT2jO5SMfAUtDoBCGANSbb/rwGYJzX2aO04HTy/5j7
         kfmBCn5QQG8Cjt0GE/XJ3VOgfuec9s8Nd4S0s3KvKmd4yZaP5u0zcp5hEyAiVrD9rdpZ
         OCCxglhh+n73WXKmY0khzcxmdpN6gmBr6mmiqOj0Sm7l79FROg2J41VWE1zeXGtx87e8
         eMhCPZh+jbrV7KgQGzc6UCWyhdbIQ9TUwLLcgoxdwU7lztQgFl5UTW8hyCtYNOIjK6JZ
         faNjEg5/gt5KC8CNkPcZAm14sr4EmvtqfGJm6NdarokUymmHErCS5QNICGxxlgCd+z+T
         a/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687840173; x=1690432173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+QydbhvUzSfB+GyWlFD2zcHwU5Ngevv/JXFxv4fPuo=;
        b=TtzistWwNfgfc/3f+VTLtZPQG/fDm0//6hQ98drbytDGJpoLJ8qL5yox74cH5q6xCw
         LyOOAr8jJji7rjQkxAU3/2no5wy9etvAcO1cEL/2LgkpHbcbvPaXAq3XTsXvxF8tdcVL
         7VhTQ/8VFXe5LF/vDmwclny9AWgHQgIv+2PDKu8u3MCO6yvoFsadtyOtyU1YOhIzkI47
         zzsgX/ftvUE49B/6oHSI/wYNbgvK9oQQN0Ab65yaYY0W0H2U6+gM76Ge4H7l2EvPM4kO
         loff6p1DrUvbFFZDBLZyU7auU9bJbLuzerXriE/THwsbkVskMclF/aUJIGRuCmWD9l+T
         HdQg==
X-Gm-Message-State: AC+VfDyhrD7MRYXe0LWp/e1SaFpbkLwXf2WeDcIcOLqQaZ8N5iOkAqwb
        WldKexz8rvWDsv6o+x0HFLlRSLXwD3Gu+h5iKd9v6lSj
X-Google-Smtp-Source: ACHHUZ5XzsAfBEET4XprR7/E/rNnu6+Ry7gRpHkZVzEkK+rVZFvTMxuwfBN98ObxUR0C87P7rCOdQ3e9o/1di+IZG/I=
X-Received: by 2002:a05:6512:3994:b0:4fb:87ca:f9e4 with SMTP id
 j20-20020a056512399400b004fb87caf9e4mr48452lfu.21.1687840172430; Mon, 26 Jun
 2023 21:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-4-wentao@uniontech.com> <CANT5p=q_-yHy5Z0fcQ7KrRrJ4OLCJ8otqNfC1Ee0ZTUMMsw_gA@mail.gmail.com>
In-Reply-To: <CANT5p=q_-yHy5Z0fcQ7KrRrJ4OLCJ8otqNfC1Ee0ZTUMMsw_gA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Jun 2023 23:29:21 -0500
Message-ID: <CAH2r5ms9cyJqSXRUwSnvK7RPRVHSxvNEqtdD8-xB9qH1CxnW5w@mail.gmail.com>
Subject: Re: [PATCH 3/3] cifs: fix session state check in smb2_find_smb_ses
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Winston Wen <wentao@uniontech.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next, added cc: stable and RB

On Mon, Jun 26, 2023 at 12:34=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Mon, Jun 26, 2023 at 9:24=E2=80=AFAM Winston Wen <wentao@uniontech.com=
> wrote:
> >
> > Chech the session state and skip it if it's exiting.
> >
> > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > ---
> >  fs/smb/client/smb2transport.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transpor=
t.c
> > index 790acf65a092..22954a9c7a6c 100644
> > --- a/fs/smb/client/smb2transport.c
> > +++ b/fs/smb/client/smb2transport.c
> > @@ -153,7 +153,14 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info =
*server, __u64 ses_id)
> >         list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) =
{
> >                 if (ses->Suid !=3D ses_id)
> >                         continue;
> > +
> > +               spin_lock(&ses->ses_lock);
> > +               if (ses->ses_status =3D=3D SES_EXITING) {
> > +                       spin_unlock(&ses->ses_lock);
> > +                       continue;
> > +               }
> >                 ++ses->ses_count;
> > +               spin_unlock(&ses->ses_lock);
> >                 return ses;
> >         }
> >
> > --
> > 2.40.1
> >
>
> Thanks for the change.
> Looks good to me.
> CC stable for this one too.
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
