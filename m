Return-Path: <SRS0=6FgL=DG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88211C4727C
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2375A207F7
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PLIQE3S3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgI2RqJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgI2RqJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Sep 2020 13:46:09 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DE9C061755
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:46:09 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x8so4229616ybe.12
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6o8exDLzqy3QxVkizQuPaks8jxk7r3Sn0M6HAav+s3M=;
        b=PLIQE3S3WcFVZ5DfYGgHWwTUo0rKfo/BuM1m9C4jwoJykTQSwrasSKzFSxr03ImouB
         FQKL5kKK/MBsz6IEx5Ym//1x0gqT5yB4sTNOQ4DSaAZq8j/kjiRyirRSUzqja6pn8aZL
         DWKkCsHmaeyG7BAvKy1Z179uv4O6aHibeEZ4JdJIeVEA1jUs7ne/alMbFP8/Xm6izSBL
         Ll1HvXQpGUFtXeK7J2ZuQ384TTejpUvt+RFLO3bBjQST0GZT03MtyACLdto2idi9HXv0
         Vnm6Iwxkrl00aU64Rny7+5Gf0PhtfJqz4/O4iL+lPEiEFXNJI5EWhBLXyuBjwEEs04O/
         MvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6o8exDLzqy3QxVkizQuPaks8jxk7r3Sn0M6HAav+s3M=;
        b=JuxUyxi2TfrMPuHbEv2zfGGZ3Z/QZmgNnCeJgf4fCemBWkka6Ja0LrNAoDhFf5A6PZ
         YV973DWI7GpZAhm3UHHXub/NcC1dKggs7MfHkpoHGO0CMkp7iu5DAbjouwUy5oTlbV5V
         NaUHub60Y2II5lBHNxRqWUqjcNcprrvcnwDvjqFmshlQIO2f8r+EHLHPU1RX+4GcCnJi
         mjJL4pwHY6+oreSpbVH8VepzKavGBGbiUw8S0j9kj1rAx7YsMx0Rquu59TBtpJUpLTGw
         KCxab6W0zIHR7mMfOVXcA+9BLe2HoLyYB8uPZ6QQxbFzMJB5VZA3OZAmwh18xrz0A6I5
         NreA==
X-Gm-Message-State: AOAM531n8fSJBuKp5TIpZFSoFwhlTbckNzkv+RyPIdUfTxLg895p2edS
        VQzA8tarfVHJmS6X0maxXmcEgesxsBnlS20rsobP/p1Jn/c3Hg==
X-Google-Smtp-Source: ABdhPJwZN//W8LT7yvBPSgFaloyGossGzc7oD3VsWC0FYjyKBKdwBJ7aVbQ9x4lWTpNgGomm5W2I0e3bE0v0r0nO4K0=
X-Received: by 2002:a25:918b:: with SMTP id w11mr8217655ybl.376.1601401568416;
 Tue, 29 Sep 2020 10:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200924003638.2668-1-pboris@amazon.com> <CAHhKpQ4UFhtfRhByRiAm6KPy=KAzttYzZADLfakbMwpsp5GjpA@mail.gmail.com>
In-Reply-To: <CAHhKpQ4UFhtfRhByRiAm6KPy=KAzttYzZADLfakbMwpsp5GjpA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 29 Sep 2020 12:45:57 -0500
Message-ID: <CAH2r5mvWZSPjtg1g2FhZ+gZNpakdaFnugw=FhFV92Ed83VzAuQ@mail.gmail.com>
Subject: Re: [PATCH] Convert trailing spaces and periods in path components
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged ... running the usual functional tests
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/bui=
lds/399

On Tue, Sep 29, 2020 at 12:08 PM Boris Protopopov
<boris.v.protopopov@gmail.com> wrote:
>
> Testing:
>
> Prior to the patch:
>
> % mount -v
> =E2=80=A6
> //host/share/home on /tmp/diry type cifs (rw,relatime,vers=3Ddefault,...
> % ls -l /tmp/diry/tmp
> total 0
> % mkdir /tmp/diry/tmp/DirWithTrailingDot.
> % ls -l  /tmp/diry/tmp/DirWithTrailingDot.
> total 0
> % touch  /tmp/diry/tmp/DirWithTrailingDot./file
> touch: cannot touch =E2=80=98/tmp/diry/tmp/DirWithTrailingDot./file=E2=80=
=99: No such
> file or directory
> % mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
> mkdir: cannot create directory
> =E2=80=98/tmp/diry/tmp/DirWithTrailingDot./dir=E2=80=99: No such file or =
directory
> % find  /tmp/diry/tmp/DirWithTrailingDot.
> /tmp/diry/tmp/DirWithTrailingDot.
> % find  /tmp/diry/tmp/DirWithTrailingSpace\
> find: `/tmp/diry/tmp/DirWithTrailingSpace ': No such file or directory
> % mkdir  /tmp/diry/tmp/DirWithTrailingSpace\
> % ls -l  /tmp/diry/tmp/DirWithTrailingSpace\
> total 0
> % touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
> touch: cannot touch =E2=80=98/tmp/diry/tmp/DirWithTrailingSpace /file=E2=
=80=99: No
> such file or directory
> % mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
> mkdir: cannot create directory =E2=80=98/tmp/diry/tmp/DirWithTrailingSpac=
e
> /dir=E2=80=99: No such file or directory
>
> After the patch:
>
> % umount /tmp/diry
> % modprobe -r cifs
> # load the fix
> % modprobe cifs
> % mount -t cifs -o...  //host/share/home /tmp/diry
> ...
> % mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
> % touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
> % mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
> % touch  /tmp/diry/tmp/DirWithTrailingDot./file
> % find  /tmp/diry/tmp/
> /tmp/diry/tmp/
> /tmp/diry/tmp/DirWithTrailingDot.
> /tmp/diry/tmp/DirWithTrailingDot./dir
> /tmp/diry/tmp/DirWithTrailingDot./file
> /tmp/diry/tmp/DirWithTrailingSpace
> /tmp/diry/tmp/DirWithTrailingSpace /dir
> /tmp/diry/tmp/DirWithTrailingSpace /file
> % rm -rf /tmp/diry/tmp/*
> % find  /tmp/diry/tmp/
> /tmp/diry/tmp/
>
> ---------- Forwarded message ---------
> From: Boris Protopopov <pboris@amazon.com>
> Date: Wed, Sep 23, 2020 at 8:39 PM
> Subject: [PATCH] Convert trailing spaces and periods in path components
> To:
> Cc: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
> Boris Protopopov <pboris@amazon.com>
>
>
> When converting trailing spaces and periods in paths, do so
> for every component of the path, not just the last component.
> If the conversion is not done for every path component, then
> subsequent operations in directories with trailing spaces or
> periods (e.g. create(), mkdir()) will fail with ENOENT. This
> is because on the server, the directory will have a special
> symbol in its name, and the client needs to provide the same.
>
> Signed-off-by: Boris Protopopov <pboris@amazon.com>
> ---
>  fs/cifs/cifs_unicode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 498777d859eb..9bd03a231032 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const char
> *source, int srclen,
>                 else if (map_chars =3D=3D SFM_MAP_UNI_RSVD) {
>                         bool end_of_string;
>
> -                       if (i =3D=3D srclen - 1)
> +                       /**
> +                        * Remap spaces and periods found at the end of e=
very
> +                        * component of the path. The special cases of '.=
' and
> +                        * '..' do not need to be dealt with explicitly b=
ecause
> +                        * they are addressed in namei.c:link_path_walk()=
.
> +                        **/
> +                       if ((i =3D=3D srclen - 1) || (source[i+1] =3D=3D =
'\\'))
>                                 end_of_string =3D true;
>                         else
>                                 end_of_string =3D false;
> --
> 2.18.4



--=20
Thanks,

Steve
