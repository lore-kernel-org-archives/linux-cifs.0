Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4844EB64DC
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 04:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjF0EXZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 00:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF0EXW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 00:23:22 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E8BDC
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 21:23:20 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f9fdb0ef35so3580400e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 21:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687839799; x=1690431799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uimwvwI9cVW2r2tdjfmpzzus8PhR/1vYZwDShovZXpg=;
        b=nf8GxJeHe4S9GiItD3NPUCYKk+n45Q8/tdyaKyG4EYfVJL6nwDkEIKbB0z457iOBBP
         ecEz81ho8hiJCpb5/Xku/FHohEYnB9YdlW4Mok7lDKWbHjXL8NJmwTT5YMeAri3CKBFk
         s3R7uZbPozpxuagguwoK4W5VqFMCTXKnfO7I62mUMHB5DFBu1oE3Y5fLjO6J/gkTzAc6
         bz82gBUBSfPA968qmGEIgzkpzl3Q3ecFG34Gs9Nn4xhgg7U/YMfmAmhdT2qiM6SLfX0c
         JxSnOZwJveAKoh1hvBH1vnADp4Xjl19qm0fAJueaccIJ3cRX0MwAneW+V/5s+jOMsC9X
         Te8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687839799; x=1690431799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uimwvwI9cVW2r2tdjfmpzzus8PhR/1vYZwDShovZXpg=;
        b=R+wfUo/LLtRioEiNnwZXK/zjpyxc8YiBjh03Xw/zOzkntQhZ9jx9ZRMXwxWZMk/99n
         1od9bKgg2OJDlXtyeomkCn3L++dgT8LAyH7XUOaAEe1U4X744i+haFMambLe3COgLjNN
         GwvnCFWPjd4MpLpZ1a2sHvrqLqZmXPJ1lgh1jk27Tm4pdRrfDlBW0DhgKeI/l3kIsVr4
         bFKfNH9GrYfDJhHYz6hK0mCsneXFF4UDdKEQTffGdxZbpRezOnFfKCgo4ynS8m4+y7X5
         +w+cO1hE7ezs6l86vXV4ts1lOZKlqWCUnxPg0GrXG4uGt3kGeGDTwFmE8tA1/PtDqwxQ
         3Cmg==
X-Gm-Message-State: AC+VfDzTqZwvHGoGvYTQ4X5x3s6RVP7Gran9aekd/2AR1Jb5zmg4z+E/
        0rmQW1HmBtN5OewMp+zFIu+8TY6h/D3Lq8sWj5U=
X-Google-Smtp-Source: ACHHUZ5nllqibEpasGqBvgEpYBL6GVGU3D+6P/p+23o5wu6TMdnS/yVLdDO9Qpe9xgQ+EV/x6iTH6zoAwGDmiRKsZFg=
X-Received: by 2002:a05:6512:20cf:b0:4fb:774f:9a84 with SMTP id
 u15-20020a05651220cf00b004fb774f9a84mr2111543lfr.13.1687839798786; Mon, 26
 Jun 2023 21:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-4-wentao@uniontech.com> <CANT5p=q_-yHy5Z0fcQ7KrRrJ4OLCJ8otqNfC1Ee0ZTUMMsw_gA@mail.gmail.com>
In-Reply-To: <CANT5p=q_-yHy5Z0fcQ7KrRrJ4OLCJ8otqNfC1Ee0ZTUMMsw_gA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Jun 2023 23:23:07 -0500
Message-ID: <CAH2r5mvrefUdxkXFBn6yzohozoL1LXYZuXW4Rjz=dG8opn8zDQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] cifs: fix session state check in smb2_find_smb_ses
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Winston Wen <wentao@uniontech.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added RB and merged into cifs-2.6.git for-next

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
