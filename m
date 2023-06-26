Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA88EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 05:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjFZFP3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 01:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjFZFP2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 01:15:28 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ED0113
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:15:23 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f973035d60so3272876e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687756521; x=1690348521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gE79CPGwJ7tV/UDZMyOZXTNfPTO1HxltodpKEoTRoTg=;
        b=GP3qHv299SDNcxTHt7x2XJQT2dPci+jThQHPryVUT0utU9OK96FhiXz9n7X5j8Ef14
         6Do/eoc93qaP+ZGhpkRJv+wXJH6YunNvg1DQvjd5TUoS09moVD3ySi9OIKUVvJruXIeI
         XSO+7TVzwqihYweEUXD40oshOq6ddgdIzPcoii2ffskqghhL+8TxP5X/7GrNTmkeJ/k6
         smDpNDsUZhi4qIoqhokfqjS2cHGkwWJVCQN4AeexjJl+fR9jkP8DF2VebQUW1lSR7+Bc
         x1q64PcUoxDk71QQ28PaqL6sZmleA/EsPlKCVJS5wKJAemtnlx/BlWCKqt+8757Qk8sY
         qppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687756521; x=1690348521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gE79CPGwJ7tV/UDZMyOZXTNfPTO1HxltodpKEoTRoTg=;
        b=JY3BILDiZJrEPVgB0KZtcfVe5vAqxqV7XRxJx6iMgE7tYZr16u9U7Rt6PQexyb18uu
         mrn+siU79iCMBOkxIR5QoLQnetWpORHKZOv0ydXoXNhNCBPDRAOjR2Q+4Bvh1a2Q9pBZ
         tbIUVvLbVjyEewkR8az34t+gdTrQMuhWl5Cnv5j7K7dLXPy1t6QjD5c25jkRqztFfORJ
         rsCTg7cw8eWzpX4ern/23iHux1VlKQtcRXjeKQjPOj/YCuMPPtZztWegEysO6ytvBtSv
         w5S667f0VX7FNf74LZlMLlLTZqZcPgtVZonuamyoIEGjnAHWBJiALa4lmsS/Qiyi/SJ6
         OFWg==
X-Gm-Message-State: AC+VfDwWBV8eh0Y15/m/9YXBhrOlZXGP+y/W0g0LQndjzaF1XvlT3diP
        +ln8m0YehnaTR6SC0xUVwfAtirvtjK0kzrTLUYc=
X-Google-Smtp-Source: ACHHUZ6sivauCGgOx4l1Udb+UnwryayZj7SU+XcbWWHMu4uQTFMtk0BebViUyy4YdsmbZms4crEmm2PH+lA/M5UCo38=
X-Received: by 2002:a19:e343:0:b0:4f4:1959:b729 with SMTP id
 c3-20020a19e343000000b004f41959b729mr14203997lfk.68.1687756521066; Sun, 25
 Jun 2023 22:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com> <20230626034257.2078391-2-wentao@uniontech.com>
In-Reply-To: <20230626034257.2078391-2-wentao@uniontech.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 26 Jun 2023 10:45:09 +0530
Message-ID: <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: fix session state transition to avoid
 use-after-free issue
To:     Winston Wen <wentao@uniontech.com>,
        Steve French <smfrench@gmail.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 26, 2023 at 9:25=E2=80=AFAM Winston Wen <wentao@uniontech.com> =
wrote:
>
> We switch session state to SES_EXITING without cifs_tcp_ses_lock now,
> it may lead to potential use-after-free issue.
>
> Consider the following execution processes:
>
> Thread 1:
> __cifs_put_smb_ses()
>     spin_lock(&cifs_tcp_ses_lock)
>     if (--ses->ses_count > 0)
>         spin_unlock(&cifs_tcp_ses_lock)
>         return
>     spin_unlock(&cifs_tcp_ses_lock)
>         ---> **GAP**
>     spin_lock(&ses->ses_lock)
>     if (ses->ses_status =3D=3D SES_GOOD)
>         ses->ses_status =3D SES_EXITING
>     spin_unlock(&ses->ses_lock)
>
> Thread 2:
> cifs_find_smb_ses()
>     spin_lock(&cifs_tcp_ses_lock)
>     list_for_each_entry(ses, ...)
>         spin_lock(&ses->ses_lock)
>         if (ses->ses_status =3D=3D SES_EXITING)
>             spin_unlock(&ses->ses_lock)
>             continue
>         ...
>         spin_unlock(&ses->ses_lock)
>     if (ret)
>         cifs_smb_ses_inc_refcount(ret)
>     spin_unlock(&cifs_tcp_ses_lock)
>
> If thread 1 is preempted in the gap and thread 2 start executing, thread =
2
> will get the session, and soon thread 1 will switch the session state to
> SES_EXITING and start releasing it, even though thread 1 had increased th=
e
> session's refcount and still uses it.
>
> So switch session state under cifs_tcp_ses_lock to eliminate this gap.
>
> Signed-off-by: Winston Wen <wentao@uniontech.com>
> ---
>  fs/smb/client/connect.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 9d16626e7a66..165ecb222c19 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1963,15 +1963,16 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>                 spin_unlock(&cifs_tcp_ses_lock);
>                 return;
>         }
> +       spin_lock(&ses->ses_lock);
> +       if (ses->ses_status =3D=3D SES_GOOD)
> +               ses->ses_status =3D SES_EXITING;
> +       spin_unlock(&ses->ses_lock);
>         spin_unlock(&cifs_tcp_ses_lock);
>
>         /* ses_count can never go negative */
>         WARN_ON(ses->ses_count < 0);
>
>         spin_lock(&ses->ses_lock);
> -       if (ses->ses_status =3D=3D SES_GOOD)
> -               ses->ses_status =3D SES_EXITING;
> -
>         if (ses->ses_status =3D=3D SES_EXITING && server->ops->logoff) {
>                 spin_unlock(&ses->ses_lock);
>                 cifs_free_ipc(ses);
> --
> 2.40.1
>

Good catch.
Looks good to me.
@Steve French Please CC stable for this one.

--=20
Regards,
Shyam
