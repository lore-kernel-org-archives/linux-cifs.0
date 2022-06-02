Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE42C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 05:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiFBFIJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 01:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiFBFII (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 01:08:08 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917D724F3B
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 22:08:03 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e2so4934541wrc.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 22:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q1HQZOugaldMp9fQDNgSZFPNImBRrAqBRu5S7QzPiig=;
        b=eeB3aXTtdWnk3aAQYDTY6NFOJyUBNp7vGm+Yk7c/G53wuPPq1IM04LlvFSVVuE5i0S
         kXFNkTLhar8m3DEgUqQtgoeZdYHPBk/AAUcvQTKBPaZ2T6suYWfldhy9BzZ2iUk54tgQ
         z/U1TsfOSwQ/wQS2cafWrT7CmALEQOZyUWI5PWsowRuus7IUeFjQfdtXwzdTqey0JDgq
         1UN7FAtvXO+FWgKrPU6+ilNTyDe6pJluTOzkUzzyX8BosX9g3vfmJLdIg/7rfPYYwT5C
         MYw1naBcqRxTAWgf17KYpQ/XGd8YFXp2VX3bXwpZcGstKC3h/QZZ79tSrNJr2INKzFBy
         A8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q1HQZOugaldMp9fQDNgSZFPNImBRrAqBRu5S7QzPiig=;
        b=j1a4mag7H5HcNBh3sW6mNY2lMscyj8qird8Idg86P5pgGLKdN6QCbVbbs+P/9BheZv
         m4jW3r/QlsDi8BthJTxPOR2PWixPsbcSvCBJwE3oSK2c3e8G5kSL2VUG0wW79sQp1bpI
         k/foI/432cvNQw/KQ0gat4VT5POogVMm54h6Ix9LXS4dLC381OCKoUbuYxKe9sZG3X3C
         pzwl8q9MHz7oyOb3ytM31SYRxnVnj0EhB5wohED2UFFiLVEhgBnzvdXQzu4+ztgIrDC4
         muoHsPXhHoSqxogaV1jVSZs+YdHM5awYz7eRxNAqRrVpojbgzeDrHqHkSki4zy0cI6SY
         OzWw==
X-Gm-Message-State: AOAM531kFCQsI8daRPGsyrwsmDgZGY/q+sTJJHSNQx5aUMFO+iQBr6vG
        VEK0InqP5V7LsURLqGKvYs/yooMTFcSmXAJxNmc=
X-Google-Smtp-Source: ABdhPJz7LAUvgW+rohExsxiblcs1BHRv2PoCnihB8atrH/fPtzyI5NqEd+tYy/xR/j+gkBSi/+qKlSNkIxEbWgABeVM=
X-Received: by 2002:adf:ea87:0:b0:211:68d:7c93 with SMTP id
 s7-20020adfea87000000b00211068d7c93mr2024603wrm.412.1654146482140; Wed, 01
 Jun 2022 22:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220602011410.56202-1-linkinjeon@kernel.org>
In-Reply-To: <20220602011410.56202-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 2 Jun 2022 14:07:50 +0900
Message-ID: <CANFS6bYwq2kjsCXABSVeSU=AMEau1Cd=A_bS7=A-_PRLz=YfqQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: add missing long option in adduser/addshare/control
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Namjae,

2022=EB=85=84 6=EC=9B=94 2=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 10:14, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Add missing long option in adduser/addshare/control.
>
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  addshare/addshare.c | 11 ++++++++++-
>  adduser/adduser.c   | 12 +++++++++++-
>  control/control.c   |  9 ++++++++-
>  3 files changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/addshare/addshare.c b/addshare/addshare.c
> index 4d25047..a8ba71a 100644
> --- a/addshare/addshare.c
> +++ b/addshare/addshare.c
> @@ -54,6 +54,15 @@ static void usage(void)
>         exit(EXIT_FAILURE);
>  }
>
> +static const struct option opts[] =3D {
> +       {"add-share",           required_argument,      NULL,   'a' },
> +       {"del-share",           required_argument,      NULL,   'd' },
> +       {"update-share",        required_argument,      NULL,   'u' },
> +       {"options",             required_argument,      NULL,   'o' },
> +       {"version",             no_argument,            NULL,   'V' },
> +       {"verbose",             no_argument,            NULL,   'v' },
> +};

We have to add the last element, {NULL, 0, NULL, 0} to avoid
Segment Fault. otherwise Looks good to me.

> +
>  static void show_version(void)
>  {
>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
> @@ -102,7 +111,7 @@ int main(int argc, char *argv[])
>         set_logger_app_name("ksmbd.addshare");
>
>         opterr =3D 0;
> -       while ((c =3D getopt(argc, argv, "c:a:d:u:p:o:Vvh")) !=3D EOF)
> +       while ((c =3D getopt_long(argc, argv, "c:a:d:u:p:o:Vvh", opts, NU=
LL)) !=3D EOF)
>                 switch (c) {
>                 case 'a':
>                         arg_name =3D g_ascii_strdown(optarg, strlen(optar=
g));
> diff --git a/adduser/adduser.c b/adduser/adduser.c
> index 88b12db..60a059d 100644
> --- a/adduser/adduser.c
> +++ b/adduser/adduser.c
> @@ -50,6 +50,16 @@ static void usage(void)
>         exit(EXIT_FAILURE);
>  }
>
> +static const struct option opts[] =3D {
> +       {"add-user",            required_argument,      NULL,   'a' },
> +       {"del-user",            required_argument,      NULL,   'd' },
> +       {"update-user",         required_argument,      NULL,   'u' },
> +       {"password",            required_argument,      NULL,   'p' },
> +       {"import-users",        required_argument,      NULL,   'i' },
> +       {"version",             no_argument,            NULL,   'V' },
> +       {"verbose",             no_argument,            NULL,   'v' },
> +};
> +
>  static void show_version(void)
>  {
>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
> @@ -102,7 +112,7 @@ int main(int argc, char *argv[])
>         set_logger_app_name("ksmbd.adduser");
>
>         opterr =3D 0;
> -       while ((c =3D getopt(argc, argv, "c:i:a:d:u:p:Vvh")) !=3D EOF)
> +       while ((c =3D getopt_long(argc, argv, "c:i:a:d:u:p:Vvh", opts, NU=
LL)) !=3D EOF)
>                 switch (c) {
>                 case 'a':
>                         arg_account =3D g_strdup(optarg);
> diff --git a/control/control.c b/control/control.c
> index 780a48a..3dc8c7e 100644
> --- a/control/control.c
> +++ b/control/control.c
> @@ -23,6 +23,13 @@ static void usage(void)
>         exit(EXIT_FAILURE);
>  }
>
> +static const struct option opts[] =3D {
> +       {"shutdown",            no_argument,            NULL,   's' },
> +       {"debug",               required_argument,      NULL,   'd' },
> +       {"ksmbd-version",       no_argument,            NULL,   'c' },
> +       {"version",             no_argument,            NULL,   'V' },
> +};
> +
>  static void show_version(void)
>  {
>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
> @@ -101,7 +108,7 @@ int main(int argc, char *argv[])
>         }
>
>         opterr =3D 0;
> -       while ((c =3D getopt(argc, argv, "sd:cVh")) !=3D EOF)
> +       while ((c =3D getopt_long(argc, argv, "sd:cVh", opts, NULL)) !=3D=
 EOF)
>                 switch (c) {
>                 case 's':
>                         ret =3D ksmbd_control_shutdown();
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
