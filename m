Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EC0C004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 22:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF4620C01
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 22:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sdvADJu0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfEGWyv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 18:54:51 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37565 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGWyv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 May 2019 18:54:51 -0400
Received: by mail-lf1-f67.google.com with SMTP id h126so1897055lfh.4
        for <linux-cifs@vger.kernel.org>; Tue, 07 May 2019 15:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=efiUNYgU8LiMcquL9R3poi5KfURc7BO4tH+H/w7okYw=;
        b=sdvADJu0fXfr/Yszzz7lY3rUF3LD+ChoOB/Gd/WhwQQEl+VUQXjfKdvZNTq6ZlL3Te
         OzXEKHkeD+e2/6HNo8Oq8ex3W+hrpB1tkbtizw6xCGnkx0Bl8sAOWhrHmKUuz2cdHEeo
         ivoyR2yqR/Bw+tOhq5lpHj/Qsyt/dlKQQEXHPBIj8lsH76X+Bh0YXzjSdrWYVSaz1fbm
         TsQlbMf0RaVBBdJQhr2oTAHu2vL4Eo468QI5ECxHerHqQg+YBqVJd2c0iXjbY5dUCgK3
         s3R2MSIbHVB1HGz4SsHNRmeosh0MPzZ69B/gGriSpIhh/EARh69Yb7cyZnQ8A+TVOhrd
         Z6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=efiUNYgU8LiMcquL9R3poi5KfURc7BO4tH+H/w7okYw=;
        b=OIY7u2K5ejL9v014nVfnszkrHLCsrR/lXMJ/57/GJxI+vyH53DJ+PvZtsT8HSR7xMB
         KCxN4x2mUWabLtQY7dNBtlBqvmYaN/5qj8pR1duQk35TNutMHY7H+dIP12Rbd16JrGW0
         084nMOjahccfiknChlf4vNVYxAxlgsBzHAlorePgOREYu1Vf7+DjGjWIJLzecMnspzrT
         F1sTWFgtbSA8Yqdun+Frh7t+MouAABWHWYmvrsnpGFGpKEoHhlwjSd+i/+dqQy2Sqi1Q
         2PYBab/tI708gh2mRQkUMZZmJep4hAMExOTJbK6oUUTF8//k+VJYoy+uMDn90+Mfd9zH
         g+MA==
X-Gm-Message-State: APjAAAUHtf5IFeRJbcdJVPUEtoMBvq7oIAU7YG5Hp070Ilmfdu2p0DKc
        sm43fdzZ+73cRWFM+cLWprrMA1OXQk2F5w8z1dCuuBk=
X-Google-Smtp-Source: APXvYqyeVQ5tlJ6Aj1no+8/b394y/AAo3LxoVUrsnn+ExeAnfi6IV4roKZdgUra1pq2QnCfXwbbwutY9x3fXF/BON0E=
X-Received: by 2002:a19:655a:: with SMTP id c26mr14576309lfj.97.1557269688776;
 Tue, 07 May 2019 15:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190422055341.27727-1-kdsouza@redhat.com>
In-Reply-To: <20190422055341.27727-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 7 May 2019 15:54:37 -0700
Message-ID: <CAKywueTM36PS4iJk0nDFBY7BpYEzWfS-FYUQ2uLxeEo5jm3Hqw@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl: Add support for -R(recursive) option.
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=81, 21 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 22:53, Kenneth D's=
ouza <kdsouza@redhat.com>:
>
> Add support for -R option so we can list the ACLs of all files and
> directories recursively.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  getcifsacl.c      | 32 +++++++++++++++++++++++++++-----
>  getcifsacl.rst.in |  3 +++
>  2 files changed, 30 insertions(+), 5 deletions(-)
>
> diff --git a/getcifsacl.c b/getcifsacl.c
> index bea81ee..74f38a3 100644
> --- a/getcifsacl.c
> +++ b/getcifsacl.c
> @@ -37,10 +37,12 @@
>  #include <sys/xattr.h>
>  #include "cifsacl.h"
>  #include "idmap_plugin.h"
> +#include <ftw.h>
>
>  static void *plugin_handle;
>  static bool plugin_loaded;
>  static char *execname;
> +static bool raw =3D false;
>
>  static void
>  print_each_ace_mask(uint32_t mask)
> @@ -336,12 +338,14 @@ getcifsacl_usage(const char *prog)
>         fprintf(stderr, "\n");
>         fprintf(stderr, "\t-v   Version of the program\n");
>         fprintf(stderr, "\n");
> +       fprintf(stderr, "\t-R   recurse into subdirectories\n");
> +       fprintf(stderr, "\n");
>         fprintf(stderr, "\t-r   Display raw values of the ACE fields\n");
>         fprintf(stderr, "\nRefer to getcifsacl(1) manpage for details\n")=
;
>  }
>
>  static void
> -getcifsacl(const char *filename, bool raw)
> +getcifsacl(const char *filename)
>  {
>         ssize_t attrlen;
>         size_t bufsize =3D BUFSIZE;
> @@ -381,12 +385,21 @@ cifsacl:
>         free(attrval);
>  }
>
> +static int recursive(const char *filename, const struct stat *sb, int tf=
lag, struct FTW *ftwbuf)
> +{
> +       (void)sb;
> +       (void)tflag;
> +       (void)ftwbuf;
> +        getcifsacl(filename);
> +        return 0;
> +}
> +
>  int
>  main(const int argc, char *const argv[])
>  {
>         int c, ret =3D 0;
> -       bool raw =3D false;
>         execname =3D basename(argv[0]);
> +       int do_recursive =3D 0;
>
>         if (argc < 2) {
>                 fprintf(stderr, "%s: you must specify a filename.\n", exe=
cname);
> @@ -394,7 +407,7 @@ main(const int argc, char *const argv[])
>                 goto out;
>         }
>
> -       while ((c =3D getopt_long(argc, argv, "rhv", NULL, NULL)) !=3D -1=
) {
> +       while ((c =3D getopt_long(argc, argv, "Rrhv", NULL, NULL)) !=3D -=
1) {
>                 switch (c) {
>                 case 'v':
>                         printf("Version: %s\n", VERSION);
> @@ -402,6 +415,9 @@ main(const int argc, char *const argv[])
>                 case 'r':
>                         raw =3D true;
>                         break;
> +               case 'R':
> +                       do_recursive =3D 1;
> +                        break;
>                 default:
>                         getcifsacl_usage(execname);
>                         goto out;
> @@ -423,8 +439,14 @@ main(const int argc, char *const argv[])
>                         plugin_loaded =3D true;
>         }
>
> -       for(; optind < argc; optind++)
> -               getcifsacl(argv[optind], raw);
> +       for(; optind < argc; optind++) {
> +               if(do_recursive) {
> +                       if (nftw(argv[optind], recursive, 20, 0) =3D=3D -=
1)
> +                               fprintf(stderr, "Invalid filename %s: %s\=
n", argv[optind], strerror(errno));
> +               }
> +               else
> +                       getcifsacl(argv[optind]);
> +       }
>
>  out:
>         if (plugin_loaded)
> diff --git a/getcifsacl.rst.in b/getcifsacl.rst.in
> index 21a10cd..ffde968 100644
> --- a/getcifsacl.rst.in
> +++ b/getcifsacl.rst.in
> @@ -43,6 +43,9 @@ OPTIONS
>    flags are displayed in hexadecimal format, a SID is not mapped to a
>    name.
>
> +-R
> +  List the ACLs of all files and directories recursively.
> +
>  *****
>  NOTES
>  *****
> --
> 2.20.1
>

Merged into "next" branch. Thanks.

--
Best regards,
Pavel Shilovsky
