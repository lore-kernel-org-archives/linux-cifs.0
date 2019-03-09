Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A56C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7FE4206DF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="urOHCSGZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfCIAht (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:37:49 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33987 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfCIAht (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:37:49 -0500
Received: by mail-lf1-f68.google.com with SMTP id y18so2575113lfe.1
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xnk3efLkwnZbjZg6AjwHHWHS0TI7sojnfmVqmE+P/0o=;
        b=urOHCSGZDWjMAyaZm5PgCr/nxuv+wd/0NLGmNNKj92NrGjN3OqDOpVyHtmuZ4WdS35
         tY+4jiYaapG169lIcxKoLvdlUST5ZtEinWqjNqfBFRGwjNs5iedHlBSQxMDKSzDm/ElI
         zqRftzdLDASgnsxeqY3yDG+3CPl2g1RYvRrNiM/1kqk5no2dP5dqd/OhiyYy4fdThxcx
         y+NvDLKsjSCZ6RTfr8KicAZ34rniBqh//c+imcj31vTKSuBHD+Mhrk1gi4kbow9jDfDP
         leqFao4Vur3aSjSndb6lPCBSYYQ/0LMK0rIRC7LbnkNW7pkscbmaHz0V9jcdF09okLCc
         r/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xnk3efLkwnZbjZg6AjwHHWHS0TI7sojnfmVqmE+P/0o=;
        b=euJyyp2AhlqCYllJ6E9zPsPYxtkxBhxU8U5VoDViv1RsEJOrFcw+ttB1eAAJf3uour
         mX/5AVdVEvjZlq64oZ/qFiZUQJn/n+p87NSbeZt4hAITDnOob6DujdCuqbvWpG6Z49zj
         JohDGt/4SRZ+gd+yhuBKuhI9AZwRYJfDM1qwFeV+oCBs3GU1O6yQSJpqd1VCJeIy5LSm
         GPto2O5ZaQd0FVh/7faikYPuwFYunQW81NH8F0acUWIsEU3Y0wNwGgGC14LSQd7iwdYg
         3RuOKbDczQ87CxHtZc6dCz2kcxo6VJS20Frp3tgOXJB0m5M5/zBHEdYjatGIl9edKh54
         tx1w==
X-Gm-Message-State: APjAAAVbpI7IvTeVq07+ce+7nGI3W5UQ8t32hBwt08QxYitjrmpWNxNE
        kYUldnTCdUHLKDaKYhCnpNh/NtVeuVSGoYeewA==
X-Google-Smtp-Source: APXvYqwixHg1VTVhSmZ4R9mVzrqNtcTqLjfOorSCCCguBwVHoJWibmMkhR76GWrHIqxpHwNaYAhpJcNugzxE6CzNWQQ=
X-Received: by 2002:a19:2d44:: with SMTP id t4mr11211892lft.90.1552091867242;
 Fri, 08 Mar 2019 16:37:47 -0800 (PST)
MIME-Version: 1.0
References: <20190221050925.17643-1-kdsouza@redhat.com>
In-Reply-To: <20190221050925.17643-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:37:35 -0800
Message-ID: <CAKywueTVMGC89Bc1v5V1WjA7Ys3CGzTcLxMvnsW-=CU=T3i-4w@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl: Improve help usage and add -h option.
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 20 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 21:09, Kenne=
th D'souza <kdsouza@redhat.com>:
>
> Call getcifsacl_usage only for -h and default case.
> For others error out with appropriate message.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  getcifsacl.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/getcifsacl.c b/getcifsacl.c
> index 7f6e673..850a252 100644
> --- a/getcifsacl.c
> +++ b/getcifsacl.c
> @@ -40,6 +40,7 @@
>
>  static void *plugin_handle;
>  static bool plugin_loaded;
> +static char *execname;
>
>  static void
>  print_each_ace_mask(uint32_t mask)
> @@ -331,6 +332,8 @@ getcifsacl_usage(const char *prog)
>                 prog);
>         fprintf(stderr, "Usage: %s [option] <file_name>\n", prog);
>         fprintf(stderr, "Valid options:\n");
> +       fprintf(stderr, "\t-h   Display this help text\n");
> +       fprintf(stderr, "\n");
>         fprintf(stderr, "\t-v   Version of the program\n");
>         fprintf(stderr, "\n");
>         fprintf(stderr, "\t-r   Display raw values of the ACE fields\n");
> @@ -345,8 +348,15 @@ main(const int argc, char *const argv[])
>         ssize_t attrlen;
>         size_t bufsize =3D BUFSIZE;
>         char *filename, *attrval;
> +       execname =3D basename(argv[0]);
> +
> +        if (argc < 2) {
> +                fprintf(stderr, "%s: you must specify a filename.\n", ex=
ecname);
> +                printf("Try `getcifsacl -h' for more information.\n");
> +                goto out;
> +        }
>
> -       while ((c =3D getopt_long(argc, argv, "r:v", NULL, NULL)) !=3D -1=
) {
> +       while ((c =3D getopt_long(argc, argv, "rhv", NULL, NULL)) !=3D -1=
) {
>                 switch (c) {
>                 case 'v':
>                         printf("Version: %s\n", VERSION);
> @@ -355,18 +365,18 @@ main(const int argc, char *const argv[])
>                         raw =3D true;
>                         break;
>                 default:
> -                       break;
> +                       getcifsacl_usage(execname);
> +                        goto out;
> +
>                 }
>         }
>
> -       if (raw && argc =3D=3D 3)
> -               filename =3D argv[2];
> -       else if (argc =3D=3D 2)
> -               filename =3D argv[1];
> -       else {
> -               getcifsacl_usage(basename(argv[0]));
> -               goto out;
> -       }
> +        if (optind >=3D argc) {
> +               printf("you must specify a filename after options.\n");
> +               printf("Usage: getcifsacl [option] <file_name>\n");
> +                goto out;
> +        } else
> +              filename=3D argv[optind];
>
>         if (!raw && !plugin_loaded) {
>                 ret =3D init_plugin(&plugin_handle);
> --
> 2.20.1
>

fixed code style and merged, thanks.

--
Best regards,
Pavel Shilovsky
