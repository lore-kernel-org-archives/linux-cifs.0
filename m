Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675FDC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 03:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjJaDYR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 23:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjJaDYR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 23:24:17 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FF2AB
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:24:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-507b96095abso7477594e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698722653; x=1699327453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4RI360b/FQaIHELAs4fHGJG7MktVGNXhbYsfTDTxe+M=;
        b=gz35nvhy9vTXLc0lx52txNviFAQH5kP66e7QJpPvb1yZJImKjiaTYQHjS+ZVZiDuVn
         Ni73VmxN0pY/1ntkOUlooKKYlyktARdJBLRZkoNSCCF5iHqQ2JFFNOAH9yNWJN5c+8za
         TgLfCmfNmkfPN9oH7ivbBxPRntFwhNoaix56d83ilzo3Tpvno8eA9njsYo8aKwPtHeIS
         RIoKZBQvSykZuushteZQn+hIFRgWd7Wjs8DqS0/awBV648Q/7uNlwUulOyUd//c/OcEe
         Q1AJthhoUKLqg1Xkq6TVG3Z6A9kh5wDM3zzNafyqH6tH/GLpv+lFxAbDL/sIDoucuj4r
         mmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698722653; x=1699327453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4RI360b/FQaIHELAs4fHGJG7MktVGNXhbYsfTDTxe+M=;
        b=RruOCQo8oBR2evYp/OkEWWN/85ad0ekLHOgUrgfSm96AVwcAIVNIOzUiqZ+U2In/nE
         XiV32Lf9QS4ZvlZzqGZrMhBeww8o/KVGuWHfEyioIg7Gm6wuSbwoIjthYAkxiVxb3dUt
         h1VnkmBtoJJNLfmfugfkEiVJkVjXZb+Aulcg7VPNBAmO9TK7I14SywOUeS+NgjTsVak1
         EPMRxYqBrkhxoacB5xJE6KFmB+Hb+A70YrOa87hmcsQGjcW7ofkToZ5THsG9Gl4ZLT6V
         tCjMiVbQfH2GXia89g/z1uWSSTfLwVRl80kA483xttLanEET1qjcB/A89Azkwt8aF9UH
         84+g==
X-Gm-Message-State: AOJu0Yx3sOJAs9OsjnGPvmLGtiGFL/Eq146ov5838upmdv+M5/03E4NH
        pfzBPe2zlY3vJaigwKf4dQLi492R45/qbBXJTKsIZVdvnLs=
X-Google-Smtp-Source: AGHT+IHnNHrFodMeixx2jd47gCKjUI8VM7kenasFZh3EYDcTKhJY38DcxuH4eBEZ4M4GNO8IiYI5A6fM4D0fL8sZIo0=
X-Received: by 2002:a19:f613:0:b0:503:3700:7ec3 with SMTP id
 x19-20020a19f613000000b0050337007ec3mr8281638lfe.39.1698722652401; Mon, 30
 Oct 2023 20:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20231030201956.2660-1-pc@manguebit.com>
In-Reply-To: <20231030201956.2660-1-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Oct 2023 22:24:00 -0500
Message-ID: <CAH2r5msgiaECqxROb04g9FHGxe5ZWawZRbmUzmPqJW4DcKGSmA@mail.gmail.com>
Subject: Re: [PATCH 1/4] smb: client: remove extra @chan_count check in __cifs_put_smb_ses()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending review/testing

On Mon, Oct 30, 2023 at 3:20=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> If @ses->chan_count <=3D 1, then for-loop body will not be executed so
> no need to check it twice.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/connect.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 7b923e36501b..a017ee552256 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1969,9 +1969,10 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, =
struct smb3_fs_context *ctx)
>
>  void __cifs_put_smb_ses(struct cifs_ses *ses)
>  {
> -       unsigned int rc, xid;
> -       unsigned int chan_count;
>         struct TCP_Server_Info *server =3D ses->server;
> +       unsigned int xid;
> +       size_t i;
> +       int rc;
>
>         spin_lock(&ses->ses_lock);
>         if (ses->ses_status =3D=3D SES_EXITING) {
> @@ -2017,20 +2018,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>         list_del_init(&ses->smb_ses_list);
>         spin_unlock(&cifs_tcp_ses_lock);
>
> -       chan_count =3D ses->chan_count;
> -
>         /* close any extra channels */
> -       if (chan_count > 1) {
> -               int i;
> -
> -               for (i =3D 1; i < chan_count; i++) {
> -                       if (ses->chans[i].iface) {
> -                               kref_put(&ses->chans[i].iface->refcount, =
release_iface);
> -                               ses->chans[i].iface =3D NULL;
> -                       }
> -                       cifs_put_tcp_session(ses->chans[i].server, 0);
> -                       ses->chans[i].server =3D NULL;
> +       for (i =3D 1; i < ses->chan_count; i++) {
> +               if (ses->chans[i].iface) {
> +                       kref_put(&ses->chans[i].iface->refcount, release_=
iface);
> +                       ses->chans[i].iface =3D NULL;
>                 }
> +               cifs_put_tcp_session(ses->chans[i].server, 0);
> +               ses->chans[i].server =3D NULL;
>         }
>
>         sesInfoFree(ses);
> --
> 2.42.0
>


--=20
Thanks,

Steve
