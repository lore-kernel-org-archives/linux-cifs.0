Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1684EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 06:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjFZG1o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjFZG1f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 02:27:35 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC1CE3
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 23:27:29 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4fb73ba3b5dso893040e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 23:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687760848; x=1690352848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YVF5JTE8qa560kW2LFtDzwcv2yFfiCHWS9S/HfoSHs=;
        b=lqkMhbcHW+0hGEOSYQTtrG5/TLiGFda5P7sb1iMpTTKMLmt3w64UWTCh1l+i7dQ5nR
         Yeula4s7K6KU5FtFocAr7X9XBbif4K/SNtJ+kVcQjHX7HHsrshKYfcG/pg9YUQdVfVtP
         wkm+iRKDtXCNXR+nAGBFVs/dRANXEjVcquPZbumu9STN/pL97AgsjQNBm/xUeU7P6hrD
         EY0DAb4xEs9iow11wGOs24l4YKKnw60dMVG+8+G8u2EsFTIPdi53LX1rmF5L8VHAJgCL
         ZMn5UMNWXZxHpPgYME0apMaVSNPfdBu28j9robuQw/pnleKPIudY4ptdeeXSFvvYdR6k
         1g9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687760848; x=1690352848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+YVF5JTE8qa560kW2LFtDzwcv2yFfiCHWS9S/HfoSHs=;
        b=bq3yrxeyOgulrusOx7YMHMN6ddUX4RsqG5nPjvJYjiviL+/43Yab7wytJMfH9EizcR
         cHCknooVvpaqMyP//oNjRCKSKjHktU2l0+WH8dGktdQvOaodvNaxmNuxAR+iyOItKuN3
         ApRD0+T77VOP+33yzAd4HlMNo8HjvWtCLfR/KqCYcUxDet4TvIceKhlT8fBF0tITRzLC
         tOFD59bPSStc8LTv41JG91tvltm2KEpugAkA6Bz7hi2ySyufjz5gRtpC3JJi0WTKbHLg
         NUhp3KbtUU79Vq6c8ZCyyRW2vT5TfV30CO/vzRMb4sa7C3wKOt7y8DGkePgVkQMa024v
         tTTg==
X-Gm-Message-State: AC+VfDz41T4yqoCTJIdXNs1ntaoHNytTrG6oRDICo54x1fe8zT+LVz4D
        cgmkYS3F6T8E6QIqkN29M4G44QG7PQ4+G3snwBI=
X-Google-Smtp-Source: ACHHUZ6QViYoSqrUgfGoZsOBve9snXSpvg/lbG1NgVf3z4y7J9r/nR+lLfKE2Y2L2q6GVRP8UrLxp5/alb7/Gfi3l9w=
X-Received: by 2002:ac2:5b46:0:b0:4f7:55e4:4665 with SMTP id
 i6-20020ac25b46000000b004f755e44665mr16034380lfp.56.1687760847793; Sun, 25
 Jun 2023 23:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-3-wentao@uniontech.com> <CANT5p=rv1hF7vX4G=HienkLFnyBdQh1_Qdbd1oeHum_-2fE6-g@mail.gmail.com>
 <CEBB79D98CAA7E20+20230626135741.02657e91@winn-pc>
In-Reply-To: <CEBB79D98CAA7E20+20230626135741.02657e91@winn-pc>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 26 Jun 2023 11:57:16 +0530
Message-ID: <CANT5p=o9jo-C2eNZJVwsnjiy=Ls0t_5e3g_4srXx+9a-Vad7mw@mail.gmail.com>
Subject: Re: [PATCH 2/3] cifs: fix session state check in reconnect to avoid
 use-after-free issue
To:     Winston Wen <wentao@uniontech.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 26, 2023 at 11:28=E2=80=AFAM Winston Wen <wentao@uniontech.com>=
 wrote:
>
> On Mon, 26 Jun 2023 10:57:32 +0530
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > On Mon, Jun 26, 2023 at 9:24=E2=80=AFAM Winston Wen <wentao@uniontech.c=
om>
> > wrote:
> > >
> > > Don't collect exiting session in smb2_reconnect_server(), because it
> > > will be released soon.
> > >
> > > Note that the exiting session will stay in server->smb_ses_list
> > > until it complete the cifs_free_ipc() and logoff() and then delete
> > > itself from the list.
> > >
> > > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > > ---
> > >  fs/smb/client/smb2pdu.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > > index 17fe212ab895..e04766fe6f80 100644
> > > --- a/fs/smb/client/smb2pdu.c
> > > +++ b/fs/smb/client/smb2pdu.c
> > > @@ -3797,6 +3797,12 @@ void smb2_reconnect_server(struct
> > > work_struct *work)
> > >
> > >         spin_lock(&cifs_tcp_ses_lock);
> > >         list_for_each_entry(ses, &pserver->smb_ses_list,
> > > smb_ses_list) {
> > > +               spin_lock(&ses->ses_lock);
> > > +               if (ses->ses_status =3D=3D SES_EXITING) {
> > > +                       spin_unlock(&ses->ses_lock);
> > > +                       continue;
> > > +               }
> > > +               spin_unlock(&ses->ses_lock);
> > >
> > >                 tcon_selected =3D false;
> > >
> > > --
> > > 2.40.1
> > >
> >
> > Hi Winston,
> >
> > We already have this check in smb2_reconnect, which gets called from
> > smb2_reconnect_server.
> > But one additional check here will not hurt.
> >
> > Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> >
>
> Hi Shyam,
>
> Thanks for the review! And sorry for my mistake that when I replied a
> minute ago I forgot to cc others...
>
> I think the check in smb2_reconnect is not enough for this situation,
> but maybe I missed something...
>
> Consider the following process:
>
> smb2_reconnect_server():
>     spin_lock(&cifs_tcp_ses_lock)
>     list_for_each_entry(ses, ...)
>         ...
>         if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect)
>             cifs_smb_ses_inc_refcount(ses)
>     spin_unlock(&cifs_tcp_ses_lock)
>
>     /* -> session may have been released before smb2_reconnect */
>     list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist)
>         smb2_reconnect()
>         list_del_init(&tcon->rlist)
>         if (tcon->ipc)
>             cifs_put_smb_ses(tcon->ses)
>         else
>             cifs_put_tcon(tcon)
>
> When we do smb2_reconnect(), the session may have been released, and all
> the access to its field in smb2_reconnect(), such as ses->status or
> ses->ses_lock, is illegal. And when we call the cifs_put_smb_ses() on it
> again, it will crash...

I see what you mean.

I think __cifs_put_smb_ses is at fault here.
Once the ses_count reaches 0, it should do all the following before it
drops cifs_tcp_ses_lock:
1. Mark as SES_EXITING
2. Remove the session from it's list.

That way, smb2_reconnect_server should not even be able to find the
session in the list.

--=20
Regards,
Shyam
