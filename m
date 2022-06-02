Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0E3C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 05:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiFBF7Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 01:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiFBF7W (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 01:59:22 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B0C65D1F
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 22:59:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id h62-20020a1c2141000000b0039aa4d054e2so4213741wmh.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 22:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O47u74l+onffU3McKz9Pb/nIJOYhc1jTdhRd/JpZJZc=;
        b=c5JdjWA3Xs9Mqf7s2VrkzKZQOdnxnLjR3nDFCVdc0iu23uVQb1LTfo1ltpHnOCyhWP
         6miwiq40QHXdb7gooB1QzMrHRhl5UrQqwr12Nmy/b6Wv4e8iYKnKT6L72pPpgCRvQQ8Q
         sAhoM2uak7vleXax54QQdlh0yfT+0JdCdZ2DY3GyF+rhLgGNsN5rFUpiFdx++6qmoNB1
         5OF0/LiL8R5tocIr+12300lDGFAQFy5NgWi4rPFwTyJnZPVuPSH84pyhJT42jU0HkRN0
         lPUR6Cj5tZla3IFHyRBG7gk/OTrDqZxl3h3lbQAeg5f7TuXi6LiOwIJ1geNJnQd+XYxB
         yBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O47u74l+onffU3McKz9Pb/nIJOYhc1jTdhRd/JpZJZc=;
        b=aT26AHMvqOCo9bwMhkzwDAlZ1QST0gdyRqHviTTswpCNtqbkrHffCVBfrkTKIoDqfo
         qnlpf2P6luB38+imy0i+gyOG0kSyWVnmhnZoLAUGR4+wJsDpGjTqyY99K0VlYwdDRPhI
         s1V1nYPHqUNUmYzqQU8RaMq4K7XIHRgDQWhAwQjq8JHYHpzyWDbYhZbII9AED9dZez0W
         ra21Q8BjdEy6rACzDDOS1EZzoFWQmjXB3UOR0oHilunKZjIq02lR+2QuhdjsW1hql6JO
         VIiNUMZ30w1yakO7+aB65vx+j+Vm1EAU7/WdtwFSCcaFwtv94AMtYiDJWiAXwTC+hUxm
         XhTQ==
X-Gm-Message-State: AOAM531qnV6Da860doG3JZF1n1urPAVcgeM50h4Full3p7WW0noHC3uu
        30f3mHI8OrSTxlLbLIQSoAoxo/yl84MUjsoXrZg=
X-Google-Smtp-Source: ABdhPJy8GHqJ/VVpV0vxmkZNQV0dv4qhqVpY4e9F+M0jRxWV3ACOxttyK7H3b1AInKkR7ESWk+4z5V6HoNysOSQyHfg=
X-Received: by 2002:a1c:5418:0:b0:39c:3552:c85e with SMTP id
 i24-20020a1c5418000000b0039c3552c85emr87516wmb.68.1654149559867; Wed, 01 Jun
 2022 22:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220602051852.75949-1-linkinjeon@kernel.org>
In-Reply-To: <20220602051852.75949-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 2 Jun 2022 14:59:08 +0900
Message-ID: <CANFS6bZAUA4_CWxoaLORT=5bYZfHo5a-v2jNrzNoECavGXLQSg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd-tools: add missing long option in adduser/addshare/control
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

2022=EB=85=84 6=EC=9B=94 2=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 2:19, Na=
mjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Add missing long option in adduser/addshare/control.
>
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

>  v2:
>    - add NULL element in opts[].
>
>  addshare/addshare.c | 12 +++++++++++-
>  adduser/adduser.c   | 13 ++++++++++++-
>  control/control.c   | 10 +++++++++-
>  3 files changed, 32 insertions(+), 3 deletions(-)
>
> diff --git a/addshare/addshare.c b/addshare/addshare.c
> index 4d25047..af36e4b 100644
> --- a/addshare/addshare.c
> +++ b/addshare/addshare.c
> @@ -54,6 +54,16 @@ static void usage(void)
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
> +       {NULL,                  0,                      NULL,    0  }
> +};
> +
>  static void show_version(void)
>  {
>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
> @@ -102,7 +112,7 @@ int main(int argc, char *argv[])
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
> index 88b12db..9e736ee 100644
> --- a/adduser/adduser.c
> +++ b/adduser/adduser.c
> @@ -50,6 +50,17 @@ static void usage(void)
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
> +       {NULL,                  0,                      NULL,    0  }
> +};
> +
>  static void show_version(void)
>  {
>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
> @@ -102,7 +113,7 @@ int main(int argc, char *argv[])
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
> index 780a48a..94fec33 100644
> --- a/control/control.c
> +++ b/control/control.c
> @@ -23,6 +23,14 @@ static void usage(void)
>         exit(EXIT_FAILURE);
>  }
>
> +static const struct option opts[] =3D {
> +       {"shutdown",            no_argument,            NULL,   's' },
> +       {"debug",               required_argument,      NULL,   'd' },
> +       {"ksmbd-version",       no_argument,            NULL,   'c' },
> +       {"version",             no_argument,            NULL,   'V' },
> +       {NULL,                  0,                      NULL,    0  }
> +};
> +
>  static void show_version(void)
>  {
>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
> @@ -101,7 +109,7 @@ int main(int argc, char *argv[])
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
