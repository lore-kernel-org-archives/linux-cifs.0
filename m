Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355CAC282DD
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 18:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB21020643
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 18:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oLPx8VA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391084AbfDRS3m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:29:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34208 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390851AbfDRS3i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 14:29:38 -0400
Received: by mail-lf1-f65.google.com with SMTP id h5so2360725lfm.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2019 11:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5x8ecmOQ+nMekaBL2L/49wFQUG5KPhFJyxjn6HRs67g=;
        b=oLPx8VA6i/rXLK3KAwUuu2+UxV8+C4nnnFhPq9JrKUJ4ZEAjJy2N0MuDhGkk2dzZTY
         s6zLqsnzsMmKatIQs8JiQbuKTSbJiMuP2bhwNBPJXz8K2SM7w9JeCHmZagPtBWqnEuOH
         gtt/X6fXtExMf0Imf9pTvXmUr/jjfhZUBy8o6r4XVJIrRGf3D9fLz/PBSOG+BWaMt6w2
         /TjuLb2zXOAgLvI2zwFjWYq65rJ3yGEXyM4z5aT25SPBXq6TXL7hS6gnouD2cozYbtUy
         h6UIk8ssgbnabeHezsLUqNHQm2C4gaEP4tT6QixwF4NSHnQt14ytfJXzl/gHPbm2Xggj
         aJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5x8ecmOQ+nMekaBL2L/49wFQUG5KPhFJyxjn6HRs67g=;
        b=kgMjv4fliEWCbZPrnSIZ+/+6n0GceVh/BL5sGO+soVJiNxkXsEUhl1MikGlKBgz4sw
         2F4bC0UPcDY9xdbeO71wyMpKJBiq/tXwmEwlWMEK3SgdlrFbNeiHQnFFMAfL1oC0iAKq
         0aSHZBGOG+UUY4MvOEcZSjhV08D9C4g0fu1gOYB3es0JeFCOO0Q70vnZ9sakHELzJWAs
         eJzqozI4Ior8MI6wgoxm9itbwiVELybBUKTYXlELQtsvDEt5ppnTzaI2lsucuxgT7TPF
         Ugn24ln/UjBBwIWatl75KH5Br78l7DT8CUWL6aV5cjFpJ3V4LyFNRq7exLK9fL/2VKAS
         9JjQ==
X-Gm-Message-State: APjAAAV6vDXqn3GIMupjSJ2XXRY73MOZm3l7dyI9IOTXM2pzlAqFyTyl
        yJqLUnlM+Q8lBUZnaMhNwkhEiVhZfuVa8+wTng==
X-Google-Smtp-Source: APXvYqz0xXjfvr6HE5q8T+GCYX8ifRryjeZtno0+gbpnz3wq/RqtITJthj5DiqlEXpS1vHx5cHq4+b3OCK8ppzFsQT0=
X-Received: by 2002:a19:7911:: with SMTP id u17mr19740115lfc.90.1555612176399;
 Thu, 18 Apr 2019 11:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190417100646.14547-1-kdsouza@redhat.com>
In-Reply-To: <20190417100646.14547-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 18 Apr 2019 11:29:25 -0700
Message-ID: <CAKywueT418L7kUzGHRkSOpv4cS_X2ZXdag_A2BEm5uaTTnA3UA@mail.gmail.com>
Subject: Re: [PATCH] smbinfo: Improve help usage and add -h option.
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 17 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 03:06, Kenneth D's=
ouza <kdsouza@redhat.com>:
>
> Call usage only for -h case. This avoids cluttering the screen with long
> help output.
> As we are adding more options to the utility, the end error is just hidde=
n.
> Call short_usage wherever necessary.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  smbinfo.c   | 27 ++++++++++++++++++++++-----
>  smbinfo.rst |  5 ++++-
>  2 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/smbinfo.c b/smbinfo.c
> index 4bc503a..8c8f43f 100644
> --- a/smbinfo.c
> +++ b/smbinfo.c
> @@ -64,6 +64,8 @@ usage(char *name)
>  {
>         fprintf(stderr, "Usage: %s [-V] <command> <file>\n"
>                 "-V for verbose output\n"
> +               "-h display this help text\n"
> +               "-v print smbinfo version\n"
>                 "Commands are\n"
>                 "  fileaccessinfo:\n"
>                 "      Prints FileAccessInfo for a cifs file.\n"
> @@ -97,6 +99,14 @@ usage(char *name)
>         exit(1);
>  }
>
> +static void
> +short_usage(char *name)
> +{
> +       fprintf(stderr, "Usage: %s [-v] [-V] <command> <file>\n"
> +               "Try 'smbinfo -h' for more information.\n", name);
> +                exit(1);
> +}
> +
>  static void
>  win_to_timeval(uint64_t smb2_time, struct timeval *tv)
>  {
> @@ -1075,7 +1085,11 @@ int main(int argc, char *argv[])
>         int c;
>         int f;
>
> -       while ((c =3D getopt_long(argc, argv, "vV", NULL, NULL)) !=3D -1)=
 {
> +       if (argc < 2) {
> +               short_usage(argv[0]);
> +       }
> +
> +       while ((c =3D getopt_long(argc, argv, "vVh", NULL, NULL)) !=3D -1=
) {
>                 switch (c) {
>                 case 'v':
>                         printf("smbinfo version %s\n", VERSION);
> @@ -1083,15 +1097,18 @@ int main(int argc, char *argv[])
>                 case 'V':
>                         verbose =3D 1;
>                         break;
> -               default:
> +               case 'h':
>                         usage(argv[0]);
> +                       break;
> +               default:
> +                       short_usage(argv[0]);
>                 }
>         }
>
> -       if (optind >=3D argc - 1)
> -               usage(argv[0]);
> +       if (optind >=3D argc -1)
> +               short_usage(argv[0]);
>
> -       if ((f =3D open(argv[optind + 1], O_RDONLY)) < 0) {
> +       if ((f =3D open(argv[optind + 1 ], O_RDONLY)) < 0) {
>                 fprintf(stderr, "Failed to open %s\n", argv[optind + 1]);
>                 exit(1);
>         }
> diff --git a/smbinfo.rst b/smbinfo.rst
> index 0c96050..be4c829 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -11,7 +11,7 @@ Userspace helper to display SMB-specific file informati=
on for the Linux SMB clie
>  SYNOPSIS
>  ********
>
> -  smbinfo [-v] [-V] {command} {file system object}
> +  smbinfo [-v] [-h] [-V] {command} {file system object}
>
>  ***********
>  DESCRIPTION
> @@ -38,6 +38,9 @@ OPTIONS
>  -V
>    Verbose output.
>
> +-h
> +  Print help explaining the command line options.
> +
>  *******
>  COMMAND
>  *******
> --
> 2.20.1
>

Merged, thanks.
--
Best regards,
Pavel Shilovsky
