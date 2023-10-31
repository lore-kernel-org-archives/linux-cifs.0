Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116BBC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 03:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjJaDRT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 23:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjJaDRS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 23:17:18 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6BD98
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:17:16 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-507c5249d55so7519632e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698722234; x=1699327034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57m6/dbmLymKHomZNqHi6wHa6vn78cKTScZ2Mpxvk+4=;
        b=RpFwDHffAnnPs1Ttpbnow6Zhx7x0hf/z4oNjNX1NH0YVCXVNyhL8hfZHaVzMt/7U3k
         BKJQrzpHWnn4eJXqRGB6Kjw/LZaPTOpNuwsI9efapqROgFMBOQ/nrZVVUF5DEgPjYtoM
         U0t41mo1SaMjF4NbPnZvImAJwo/XDGLW4G5K9G/nIPqL96DJejK7bynpLFpPb+g4D2wq
         fwH2Nm3HVx9BWPo4Iyd7a07dEOhxJsdY27YaQlADoLwy2c5CQx3DZMME/pwbjLP0EmR4
         Eg4FAlu6ppTNqxP2j1fox4PtY//Oup5wbO89oMvaCGy4miVuKxCmqYbWW0KKKfsT4jjT
         dgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698722234; x=1699327034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=57m6/dbmLymKHomZNqHi6wHa6vn78cKTScZ2Mpxvk+4=;
        b=QCjJ1dU+mcSC7VIIXw3OU/m9pwEDFlQWdlHABBT6pc4DILq3n2PJ+qzX058OvUzoar
         /pQwGBoohS5BAYeKkQb2DxytXG7ahBdTyzWnZ+EgdAkn9+PtVMACSJYMOzMHM3YAoejr
         /M6/IZ2pHpzytosyA5IJg9chuTXF5C2GAQSfplV9u7yNbMBmKGWD+tkOqFdTWckRG8EP
         +yvX8t8CUTO+XCAo2a1F20BQqY1W27w3ilsWKujxSMLVwkT2AkfmdN/IuOASGEl1BF3p
         CMqipWzhl51GPChGVfzNe/Cc+/cJ6PrYpCC3TdB29l+8Vffu08Jjad0LITRh6OGyYSXj
         2ahQ==
X-Gm-Message-State: AOJu0Ywtj6TS2HZHR4YpFAUh6c/kVt4hcmImfOWzNtdN2h4f3rvG5E5L
        kmtAqbnZXSk2s5foFSBi3o2kBqm4nXUked+AiHvR7CEdFM0=
X-Google-Smtp-Source: AGHT+IHeDEzamuEC0ok5bif1r9jE3pdo5FECMrcOjaz1KIPMTsg70is5aOXqoMbMAZY7umk5PphKNzar5wcNE/9k5ko=
X-Received: by 2002:a05:6512:96e:b0:507:9a66:3577 with SMTP id
 v14-20020a056512096e00b005079a663577mr7173708lft.5.1698722234253; Mon, 30 Oct
 2023 20:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20231030201956.2660-1-pc@manguebit.com> <20231030201956.2660-2-pc@manguebit.com>
In-Reply-To: <20231030201956.2660-2-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Oct 2023 22:17:02 -0500
Message-ID: <CAH2r5mswxKuFzcXNrf6SHOAgfneZb0oKW_tfyqgTY2o_Wj0NGA@mail.gmail.com>
Subject: Re: [PATCH 2/4] smb: client: fix use-after-free bug in cifs_debug_data_proc_show()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fix was already in cifs-2.6.git for-next

Added Cc: stable to it though

Let me know if you see something missing (or if patch changed from the
previous one eg)

On Mon, Oct 30, 2023 at 3:20=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Skip SMB sessions that are being teared down
> (e.g. @ses->ses_status =3D=3D SES_EXITING) in cifs_debug_data_proc_show()
> to avoid use-after-free in @ses.
>
> This fixes the following GPF when reading from /proc/fs/cifs/DebugData
> while mounting and umounting
>
>   [ 816.251274] general protection fault, probably for non-canonical
>   address 0x6b6b6b6b6b6b6d81: 0000 [#1] PREEMPT SMP NOPTI
>   ...
>   [  816.260138] Call Trace:
>   [  816.260329]  <TASK>
>   [  816.260499]  ? die_addr+0x36/0x90
>   [  816.260762]  ? exc_general_protection+0x1b3/0x410
>   [  816.261126]  ? asm_exc_general_protection+0x26/0x30
>   [  816.261502]  ? cifs_debug_tcon+0xbd/0x240 [cifs]
>   [  816.261878]  ? cifs_debug_tcon+0xab/0x240 [cifs]
>   [  816.262249]  cifs_debug_data_proc_show+0x516/0xdb0 [cifs]
>   [  816.262689]  ? seq_read_iter+0x379/0x470
>   [  816.262995]  seq_read_iter+0x118/0x470
>   [  816.263291]  proc_reg_read_iter+0x53/0x90
>   [  816.263596]  ? srso_alias_return_thunk+0x5/0x7f
>   [  816.263945]  vfs_read+0x201/0x350
>   [  816.264211]  ksys_read+0x75/0x100
>   [  816.264472]  do_syscall_64+0x3f/0x90
>   [  816.264750]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>   [  816.265135] RIP: 0033:0x7fd5e669d381
>
> Cc: Frank Sorenson <sorenson@redhat.com>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/cifs_debug.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 76922fcc4bc6..9a0ccd87468e 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -452,6 +452,11 @@ static int cifs_debug_data_proc_show(struct seq_file=
 *m, void *v)
>                 seq_printf(m, "\n\n\tSessions: ");
>                 i =3D 0;
>                 list_for_each_entry(ses, &server->smb_ses_list, smb_ses_l=
ist) {
> +                       spin_lock(&ses->ses_lock);
> +                       if (ses->ses_status =3D=3D SES_EXITING) {
> +                               spin_unlock(&ses->ses_lock);
> +                               continue;
> +                       }
>                         i++;
>                         if ((ses->serverDomain =3D=3D NULL) ||
>                                 (ses->serverOS =3D=3D NULL) ||
> @@ -472,6 +477,7 @@ static int cifs_debug_data_proc_show(struct seq_file =
*m, void *v)
>                                 ses->ses_count, ses->serverOS, ses->serve=
rNOS,
>                                 ses->capabilities, ses->ses_status);
>                         }
> +                       spin_unlock(&ses->ses_lock);
>
>                         seq_printf(m, "\n\tSecurity type: %s ",
>                                 get_security_type_str(server->ops->select=
_sectype(server, ses->sectype)));
> --
> 2.42.0
>


--=20
Thanks,

Steve
