Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB0FC10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 19:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7333D217FA
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 19:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KX6lhD7k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbfDRTgc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 15:36:32 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36336 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389734AbfDRTgb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 15:36:31 -0400
Received: by mail-lj1-f196.google.com with SMTP id r24so2893410ljg.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2019 12:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i8DgXSOUf7b4p7jvprxigMd3U0n1uRLDqXkdFIVspSY=;
        b=KX6lhD7k+V0CHJYR91RFybDwPDuIib8N5DR/dQKY0l2GRPqqmQa20On1ltlxtnHLZC
         kr5n62a920s/jHkAPcE3gqxLRlZILv7gkZwZ1ZCwc3HknnbM2euOT94ib3WgFkHNNHYM
         MEZj8QgEPoZogjKMlnXHNPQhVzHh+gvl9JPvM2n5NiU/rAL+Bt/58zpRzzhCR/WAga2V
         GM8dxHdfD6+T+MRdOc5glxdnnMtpyPQ5JZO/3jAg/t5MTEEK4bF+k6HI2AxkaVGCqUWt
         mkW8rZ0UwzjN19r9Cq7W87fL0uJtXG7g+zSk1Xns/RaPZHx7wq8zdrkdz1Nfiltk2ZJ8
         rK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i8DgXSOUf7b4p7jvprxigMd3U0n1uRLDqXkdFIVspSY=;
        b=VdSmnKAA2je1UGYZ2Wt0u9hnLw2JEguKlVCOigoRWT8MhHze11kW5v4yGio8fjFgjl
         2TUTibtTyoqaotS5MMC4/qVAsI2HI/D1MCt3ivLJ5XNI+dYta5RdbvpmFnPlZECaGqES
         c9+/4mGiT86So0cyfOxXV5+omJHmgTY2N5GKIcsTawZrQJ1BsZS0Or8EGEvnf3ETg1r0
         1Toi7peEvziIqsl+ZNo2ba+1PB5BD/jCvLXCt5EGwecuTPxNzvDomRW2gwI3IPmnYtS7
         FNhfeYTXYG6F9Ql6gLRlOO98Y3Imv4ZM7ur7sytG3U8Wl5dzl8SAnOesMnvRvAshucUX
         qpYw==
X-Gm-Message-State: APjAAAUOYKInr3WzI5Oo/2IpNJraJWZumudcWl4FRapQw3z3NWYspAkV
        YYLyxenCa8jHSqyLN6zJQ4GbtPWCPZT7WXCBUhrDReU=
X-Google-Smtp-Source: APXvYqxPjfzS0LP/Kqf7LTbmI4UuZ6xAAeatTF2CnC6v1Lf49dG06pIBP0A/7GK4qV8g01zwDPxWqIQgvdNB8rGE8bg=
X-Received: by 2002:a05:651c:10f:: with SMTP id a15mr3423ljb.30.1555616188966;
 Thu, 18 Apr 2019 12:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190417171909.803-1-kdsouza@redhat.com>
In-Reply-To: <20190417171909.803-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 18 Apr 2019 12:36:17 -0700
Message-ID: <CAKywueSwd=XSB5jmMW6O9xsYiQVTYHnuAA4T-=NdCHL=FMJ-FA@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl: Add support to accept more paths
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 17 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 10:19, Kenneth D's=
ouza <kdsouza@redhat.com>:
>
> Accept more than one path on the getcifsacl command line.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  getcifsacl.c | 82 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 46 insertions(+), 36 deletions(-)
>
> diff --git a/getcifsacl.c b/getcifsacl.c
> index fc78881..df3099d 100644
> --- a/getcifsacl.c
> +++ b/getcifsacl.c
> @@ -340,14 +340,54 @@ getcifsacl_usage(const char *prog)
>         fprintf(stderr, "\nRefer to getcifsacl(1) manpage for details\n")=
;
>  }
>
> +static void
> +getcifsacl(const char *filename , bool raw)
> +{
> +       ssize_t attrlen;
> +       size_t bufsize =3D BUFSIZE;
> +        char *attrval;
> +        int failed =3D 0;
> +cifsacl:
> +       if (bufsize >=3D XATTR_SIZE_MAX) {
> +               printf("buffer to allocate exceeds max size of %d\n",
> +                               XATTR_SIZE_MAX);
> +               exit(1);
> +       }
> +
> +       attrval =3D malloc(bufsize * sizeof(char));
> +       if (!attrval) {
> +               printf("error allocating memory for attribute value buffe=
r\n");
> +               exit(1);
> +       }
> +
> +       attrlen =3D getxattr(filename, ATTRNAME, attrval, bufsize);
> +       if (attrlen =3D=3D -1) {
> +               if (errno =3D=3D ERANGE) {
> +                       free(attrval);
> +                       bufsize +=3D BUFSIZE;
> +                       goto cifsacl;
> +                } else
> +                {
> +                  fprintf(stderr, "Failed to getxattr %s: %s\n", filenam=
e, strerror(errno) );
> +                    failed =3D -1;
> +                }
> +        }
> +
> +        if (failed =3D=3D 0)
> +        {
> +        printf("# filename: %s\n", filename);
> +        parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
> +       printf("\n");
> +        }
> +        free(attrval);
> +
> +}
> +
>  int
>  main(const int argc, char *const argv[])
>  {
>         int c, ret =3D 0;
>         bool raw =3D false;
> -       ssize_t attrlen;
> -       size_t bufsize =3D BUFSIZE;
> -       char *filename, *attrval;
>         execname =3D basename(argv[0]);
>
>         if (argc < 2) {
> @@ -374,8 +414,7 @@ main(const int argc, char *const argv[])
>                 printf("you must specify a filename after options.\n");
>                 printf("Usage: getcifsacl [option] <file_name>\n");
>                 goto out;
> -       } else
> -               filename =3D argv[optind];
> +       }
>
>         if (!raw && !plugin_loaded) {
>                 ret =3D init_plugin(&plugin_handle);
> @@ -386,38 +425,9 @@ main(const int argc, char *const argv[])
>                         plugin_loaded =3D true;
>         }
>
> -cifsacl:
> -       if (bufsize >=3D XATTR_SIZE_MAX) {
> -               printf("buffer to allocate exceeds max size of %d\n",
> -                               XATTR_SIZE_MAX);
> -               ret =3D -1;
> -               goto out;
> -       }
> -
> -       attrval =3D malloc(bufsize * sizeof(char));
> -       if (!attrval) {
> -               printf("error allocating memory for attribute value buffe=
r\n");
> -               ret =3D -1;
> -               goto out;
> -       }
> -
> -       attrlen =3D getxattr(filename, ATTRNAME, attrval, bufsize);
> -       if (attrlen =3D=3D -1) {
> -               if (errno =3D=3D ERANGE) {
> -                       free(attrval);
> -                       bufsize +=3D BUFSIZE;
> -                       goto cifsacl;
> -               } else {
> -                       fprintf(stderr, "getxattr failed on %s: %s\n", fi=
lename, strerror(errno) );
> -                       free(attrval);
> -                       ret =3D -1;
> -                       goto out;
> -               }
> -       }
> -
> -       parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
> +       for(; optind < argc; optind++)
> +               getcifsacl(argv[optind], raw);
>
> -       free(attrval);
>  out:
>         if (plugin_loaded)
>                 exit_plugin(plugin_handle);
> --
> 2.20.1
>

Fixed the code style and merged:
https://github.com/piastry/cifs-utils/commit/9beaa8c3c895ca8460d81fb54a6a0d=
e2bb21a277

Also fixed the usage message separately:
https://github.com/piastry/cifs-utils/commit/f2955af017f604003e3c8c3efe0fb0=
fb85584cea

--
Best regards,
Pavel Shilovsky
