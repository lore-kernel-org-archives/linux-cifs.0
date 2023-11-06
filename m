Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EC5C4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Nov 2023 16:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjKFQMz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjKFQMy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Nov 2023 11:12:54 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1675D1BF
        for <linux-cifs@vger.kernel.org>; Mon,  6 Nov 2023 08:12:51 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-507a3b8b113so5909630e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Nov 2023 08:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699287169; x=1699891969; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynOKT299MozdeJPo7dX15MGSDUAykgN3Kvn7tqO6Xyc=;
        b=afoI7+hoTwmeAADZeUYHL0jVZUW166wnZxVg5248Y0Nj594IqB6d1+esohf8JI8jfW
         9LKfkGUKj6a+k4KY5BHq7izgPlHmJXJWOWIZsT5UAXU2KX8551iyJ8dXkXrjETj52LUS
         lQVRvnHe9VY1Z5zw/Qk3ADY64pWLQ0SMgLxfGyuoXvMtvDCHniK9XUJnyCYZ7bzMAlT1
         C7Ej0tU/UioM60Q6XjQBZjwXVDYLKUaxkJafHhJi0G0YojN21CrSBy4w38o7UIEykelR
         30b6Sk0/qv0UcS18FRBCMhMW5sTNwM/RwAuUSE+m8Rd3GYckEnibXtRbG359lt6swY3S
         TBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699287169; x=1699891969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynOKT299MozdeJPo7dX15MGSDUAykgN3Kvn7tqO6Xyc=;
        b=OgoxLmt5yWrZj/XNYMQFQSj18RYTqCvL8FNsJdkHCbiLRqKkg+hsxtvSRhXDuVmlWa
         XOn8guUTgOK2GiXrgY6+QMX9IFlir+Pwa7AEJDQ2GL7+wEmNxog/DRNMa5efvMl6g+4/
         zOIPQpDsfvKMyBOhDo/4AYfNlwV52Ss6z6Q/w9JP7ZUcofd3GYpW8Gkfd78EGOMVR+KN
         VSwm93NyvZ0n+M97SUqW+JhuMCFYzlmHTsynVcjrgoyLID0sqPhCjeDPJH32Dvtv32eV
         BkiJ/zPkw84MlQqJxovg/LsVW7mdRLDMqdZaLiO/iZbTBfEfkexd4DWlAg/ZzfT+xESY
         RJMQ==
X-Gm-Message-State: AOJu0Yxqgj8CTxLBjb8sZjxNXUtmcDRQ1NpCwghaQw0SBcVa4pulf2nW
        1AZHQKPcz73ErEQEqm3Hw2geFg0pwMytuZcASf8=
X-Google-Smtp-Source: AGHT+IHv9+RJFgcV7aca7IoZqX5nQmRHMbr7fUOWMyIOSpn0/wSHwruSrLZ8asuCyIOW6JsJvPHDojBb5/jGlKwfIpE=
X-Received: by 2002:a05:6512:3282:b0:503:28cb:c087 with SMTP id
 p2-20020a056512328200b0050328cbc087mr21125948lfe.29.1699287169031; Mon, 06
 Nov 2023 08:12:49 -0800 (PST)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-9-sprasad@microsoft.com>
 <ffa541bac7417c9dea79c73e22de1eda.pc@manguebit.com>
In-Reply-To: <ffa541bac7417c9dea79c73e22de1eda.pc@manguebit.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 6 Nov 2023 21:42:37 +0530
Message-ID: <CANT5p=ph84SkoXf-2q7oa1nQdfjw4q7jzzWOtU-mWMtg2=TxnA@mail.gmail.com>
Subject: Re: [PATCH 09/14] cifs: add a back pointer to cifs_sb from tcon
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Nov 4, 2023 at 2:33=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> nspmangalore@gmail.com writes:
>
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today, we have no way to access the cifs_sb when we
> > just have pointers to struct tcon. This is very
> > limiting as many functions deal with cifs_sb, and
> > these calls do not directly originate from VFS.
> >
> > This change introduces a new cifs_sb field in cifs_tcon
> > that points to the cifs_sb for the tcon. The assumption
> > here is that a tcon will always map to this cifs_sb and
> > will never change.
> >
> > Also, refcounting should not be necessary, since cifs_sb
> > will never be freed before tcon.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsglob.h | 1 +
> >  fs/smb/client/connect.c  | 2 ++
> >  2 files changed, 3 insertions(+)
>
> This is wrong as a single tcon may be shared among different
> superblocks.  You can, however, map those superblocks to a tcon by using
> the cifs_sb_master_tcon() helper.
>
> If you do something like this
>
>         mount.cifs //srv/share /mnt/1 -o ...
>         mount.cifs //srv/share /mnt/1 -o ... -> -EBUSY
>
> tcon->cifs_sb will end up with the already freed superblock pointer that
> was compared to the existing one.  So, you'll get an use-after-free when
> you dereference tcon->cifs_sb as in patch 11/14.

Hi Steve,
I discussed this one with Paulo separately. You can drop this patch.
I'll have another patch in place of this one. And then send you an
updated patch for the patch which depends on it.

--=20
Regards,
Shyam
