Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FEBEB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 04:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjF0EVL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 00:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF0EVK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 00:21:10 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED06BCC
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 21:21:07 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b6a1245542so27617031fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 21:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687839666; x=1690431666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKEuBuCv0aF0CW8k00rBj4feZ3JOi4yeNvKo9NwcJOU=;
        b=inS4mA+reezENbwY+3id/e0NLkjJjpqJMSMVLgWhxKP2yMtBBHk+HWek3aMUEvnXsB
         dWujbpSu93mVvQjUtEtwkcfXmBgbHqRTGRRSUJESeBtX5cRHWgdeFLpkaT2dxrealYkL
         zCeJtXaj1m18sSgSpjqaG559pUofcUr8y4W7gDiIx8kv+cgQb8/xPzDfhpkY3ZzgbWkP
         ZSBV3n/kjjbq4cKoUSYiAnyVijy1fIXh6VdS8EUQg9VZcjnaunN48zoHGiVR10tzqQ8V
         sX3HCSHmCeMjQSc4tqbJdCvOvjL0fbgdFYIA77JHWfemvcMyDFRU/ECQseSMfOwKBZLG
         pM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687839666; x=1690431666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CKEuBuCv0aF0CW8k00rBj4feZ3JOi4yeNvKo9NwcJOU=;
        b=WGdgGbeMF0SJO0bSje/lGjsOfDcFRXbLJjxV45A61EhAdqr/0GGE1gWtwsc/A/BEN8
         k5QUuXS8wZf/xQOHmDAv8MKe+4/JcHvXWevVK6k8T7v9TIBqJKUoVv2LZDnk3OGVAaIz
         f3VLqEId/1BXLc3itoOByn7y45wTPtQEVNTWfoGVG1+hWgx2gyV9sxlVhxGYQemUHN1x
         lVsQE6EP00YH6xQswKaEK63S461rErigNOtz5lWKb1PzmXAuUMD/EJo5BWMctEYRfW0T
         9yJN0CrjrtkSPxd7GE5qkjNbVkdsbfFvzFg4NownBbBNw6dk5TSYBHGrJ2FM4RWqXMBr
         Z6KA==
X-Gm-Message-State: AC+VfDy8jFf9mBOO031dHTLrHd8WNpTTmpkq4G8YMAxT7e7Prv6f6+ht
        Y1KkFZfweSXN18EdlZwieaNhEusC7an7bAuZ7Z8=
X-Google-Smtp-Source: ACHHUZ53fPr0MCWzdDdgxQB0MbYmYlKVfrbAf0wu5OGYvf2AWtOvRgyGw0SJmVjGtFjoBZSCVsuEL5PT0yfgtoA1bao=
X-Received: by 2002:a05:6512:224f:b0:4fb:7b4c:d38c with SMTP id
 i15-20020a056512224f00b004fb7b4cd38cmr2373441lfu.60.1687839665940; Mon, 26
 Jun 2023 21:21:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-3-wentao@uniontech.com> <CANT5p=rv1hF7vX4G=HienkLFnyBdQh1_Qdbd1oeHum_-2fE6-g@mail.gmail.com>
In-Reply-To: <CANT5p=rv1hF7vX4G=HienkLFnyBdQh1_Qdbd1oeHum_-2fE6-g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Jun 2023 23:20:54 -0500
Message-ID: <CAH2r5muWE=A+T6-s=LygNDYTKgzCf9YM+xd6EO7cGfKy_FGQgg@mail.gmail.com>
Subject: Re: [PATCH 2/3] cifs: fix session state check in reconnect to avoid
 use-after-free issue
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Winston Wen <wentao@uniontech.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added RB and merged into cifs-2.6.git for-next

On Mon, Jun 26, 2023 at 12:33=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Mon, Jun 26, 2023 at 9:24=E2=80=AFAM Winston Wen <wentao@uniontech.com=
> wrote:
> >
> > Don't collect exiting session in smb2_reconnect_server(), because it
> > will be released soon.
> >
> > Note that the exiting session will stay in server->smb_ses_list until
> > it complete the cifs_free_ipc() and logoff() and then delete itself
> > from the list.
> >
> > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > ---
> >  fs/smb/client/smb2pdu.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 17fe212ab895..e04766fe6f80 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -3797,6 +3797,12 @@ void smb2_reconnect_server(struct work_struct *w=
ork)
> >
> >         spin_lock(&cifs_tcp_ses_lock);
> >         list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) =
{
> > +               spin_lock(&ses->ses_lock);
> > +               if (ses->ses_status =3D=3D SES_EXITING) {
> > +                       spin_unlock(&ses->ses_lock);
> > +                       continue;
> > +               }
> > +               spin_unlock(&ses->ses_lock);
> >
> >                 tcon_selected =3D false;
> >
> > --
> > 2.40.1
> >
>
> Hi Winston,
>
> We already have this check in smb2_reconnect, which gets called from
> smb2_reconnect_server.
> But one additional check here will not hurt.
>
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
