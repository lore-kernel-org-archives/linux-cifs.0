Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B16C7EE23
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 14:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjEROBi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 10:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjEROBg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 10:01:36 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE8810FE
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 07:01:33 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f3a611b3ddso730771e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 07:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684418491; x=1687010491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5SQWefnNrf2KtUCrQlKCnmWJNx7LDhoRVVgrhwU9Sg=;
        b=RgeqEMG4ZSGPBKcnyt1FVEjfFrlAl85zds0t095apAjgctWWPHIpVy0mguRwxEOku/
         7Nj+KeFJZeatKj2gxQnySUVAZ29S7v8heQOk1ug/MQojU5dLkq6V55xEjekHCBAUzxBy
         eoHKX1GbZZ2xPhFSSXgNaZQw+/uz4rXeLlPO+ClVyMJDL/aML99oWAPf7AuGDbFjr2HY
         V2p3+QB/SnLZBwmUpY9UzaX5WX26Q8QP+1Wj583bI0ErSxiWk/gLlwx1EXd3FZpUw+Uv
         STtrPQKWL+TXdTRQNTs6G/3ntpQ9eD5hjYeYysQDR9uGZHmlqbvY6y4nQWt7yU0Zdfxn
         fBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684418491; x=1687010491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5SQWefnNrf2KtUCrQlKCnmWJNx7LDhoRVVgrhwU9Sg=;
        b=IFMSn3GoGgfLLkWJMfhXLGijYfX8E8zsgGoIP0tkz6d57mqrJZTEJ8o5sTiCM2nyj2
         kkL0xyWqDVm+BR35300O6/byju2EeeVi8KmyV4H8tAVQzFzVVcCgafgONMxKn0eZaXl+
         B2FtNeyk2b7jURvhqKutaO8ZsoYF+HDr/EXtxtWKvfpR252vYQyxceb2GPM7eY00a+N7
         ZGcNQ+1eQZEjJGLVkGNoJC8LbWB0DRxhk7aYAjWkJDr6eLOs67gzlr7E9TpacbxKYDdk
         KBKiOm1cpVh7np/ie/vQfa5Gafi9ahpPePeXfshZHpoIe9POFpr3hMgap0WSNJ8pmlpM
         J8iQ==
X-Gm-Message-State: AC+VfDz+Z2xQnziGWiRadC1ayzTKlCzqmKM7nnvgdpISO5giaMTF4NTl
        CpDJs8Hl+w2/GPgX/pdwHAh3OecLkM4pH2ZTzAk=
X-Google-Smtp-Source: ACHHUZ7rc0orL6GEy9ntLtbfbJAXuiga2taT7U5MmvT9MpX0AUXa8ERJ0RePYzByC0sKNn0uO9rnffHvVbeh+b5pnYo=
X-Received: by 2002:ac2:5df2:0:b0:4f3:78dd:8e0b with SMTP id
 z18-20020ac25df2000000b004f378dd8e0bmr956384lfq.32.1684418491178; Thu, 18 May
 2023 07:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230508190103.601678-1-bharathsm.hsk@gmail.com> <CAGypqWzMe3SiqQSDPUSvNauXzmzATNyVWzOKyOY1pwU49M=exw@mail.gmail.com>
In-Reply-To: <CAGypqWzMe3SiqQSDPUSvNauXzmzATNyVWzOKyOY1pwU49M=exw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 18 May 2023 19:31:17 +0530
Message-ID: <CANT5p=reMtsMtqyQsdTT2TXknHNYWQHzxxwVm4a-DjFAchY=zg@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Close all deferred handles of inode in case of
 handle lease break
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, smfrench@gmail.com,
        Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 16, 2023 at 2:19=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Attached updated patch with expanded commit message.
>
> On Tue, May 9, 2023 at 12:32=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.c=
om> wrote:
> >
> > Oplock break may occur for different file handle than the deferred hand=
le.
> > Check for inode deferred closes list, if it's not empty then close all =
the
> > deferred handles of inode.
> >
> > Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple defer=
red close handles for the same file.")
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/cifs/file.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 791a12575109..260d5ec878e8 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -4886,8 +4886,6 @@ void cifs_oplock_break(struct work_struct *work)
> >         struct TCP_Server_Info *server =3D tcon->ses->server;
> >         int rc =3D 0;
> >         bool purge_cache =3D false;
> > -       struct cifs_deferred_close *dclose;
> > -       bool is_deferred =3D false;
> >
> >         wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
> >                         TASK_UNINTERRUPTIBLE);
> > @@ -4928,14 +4926,9 @@ void cifs_oplock_break(struct work_struct *work)
> >          * file handles but cached, then schedule deferred close immedi=
ately.
> >          * So, new open will not use cached handle.
> >          */
> > -       spin_lock(&CIFS_I(inode)->deferred_lock);
> > -       is_deferred =3D cifs_is_deferred_close(cfile, &dclose);
> > -       spin_unlock(&CIFS_I(inode)->deferred_lock);
> >
> > -       if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
> > -                       cfile->deferred_close_scheduled && delayed_work=
_pending(&cfile->deferred)) {
> > +       if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred=
_closes))
> >                 cifs_close_deferred_file(cinode);
> > -       }
> >
> >         /*
> >          * releasing stale oplock after recent reconnect of smb session=
 using
> > --
> > 2.34.1
> >

Changes look good to me.

--=20
Regards,
Shyam
