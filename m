Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1A9C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 03:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiCODwZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Mar 2022 23:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiCODwZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Mar 2022 23:52:25 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B01B488B9
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 20:51:12 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id a186so19448098vsc.3
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 20:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9c+DHjfwIT1UIfYoasri1+p+4zYyJSUJ/KPOc7fkS3I=;
        b=l995aN/uo5uJgUv1F0pqZ2I9yenBms9MFsyjf64f9DvWIkQ1qcsZOEYFg/X5dH/JKv
         yowe45SsoDA3uuC/kh2fAGGFmmkd3an4Yfu/v/tAE0jQ0WD3L/z2fiR2jqHmO7Gh/qDi
         78uTfvFJcmXZKSAtHFfu/fBlV46GQyppdoVbSZeZJNxU5JdbsRf9PZi2B9E5jrnXOhkb
         sVEXV9YRwgZauer5DPhhQxZ3BNqArdSbCJLd1ko2o4XHSErTjB7exuHR24CWvdxGpF8T
         ICEQdtWZPlxJ3Qa4X2hZhLPwuhE1BloS1u00JJrojcPf2FxRb5jULv9TC3ooSrhfYBPK
         NiXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9c+DHjfwIT1UIfYoasri1+p+4zYyJSUJ/KPOc7fkS3I=;
        b=Kh5IJufnUlR5aDPivcIfQyzDQ76+3D/sVJ+kx1vszwKxdZw7IzqwfQgf3XmNLyxa78
         R4viJvckxDQa9oHTfsn98Cq9UpzaJYS4ahq0DJvpDk3ZjTLUJwWe4kBgPYZ1YPX2GqFE
         /P+hq4l3flRlTwlX7HMYey0GjH6Y5LIsxuCr92g3sqZd0hCdd6aim2IaIq62oHA/2Mi9
         4sdmVCUoH0Hjcg2Bze7Dx2Fc5p/bOzPPIcvLm6r51paJM5Cts+2e+c8wDkocNOHjrhr/
         tUepcqtRpT9qJPYq1woAU6LujkcavEk5GXPSI+H9gSA6KtA/68IvfT6KUyizqwpap/+T
         3Gjw==
X-Gm-Message-State: AOAM5300uaY/zX5q3OgNGIyxQOfKLIoGckhrQrzftIW4cxL5F6c7E9nv
        so5iH5nu0pL33v2oRPBAyttQfZQnkzTZlnSprfXLNW3Mbxg=
X-Google-Smtp-Source: ABdhPJyZDIcJ6onm2n7oinyBklgRiAJEqr7ruEtZ60vXPvbkQmKl9oXMgOk7QhUQXCaGh9q1oJEugqHXS2baQM4pUhg=
X-Received: by 2002:a67:1a05:0:b0:31a:511d:886a with SMTP id
 a5-20020a671a05000000b0031a511d886amr10244140vsa.72.1647316271127; Mon, 14
 Mar 2022 20:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <2314914.1646986773@warthog.procyon.org.uk> <2315193.1646987135@warthog.procyon.org.uk>
In-Reply-To: <2315193.1646987135@warthog.procyon.org.uk>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Tue, 15 Mar 2022 09:20:59 +0530
Message-ID: <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com>
Subject: Re: cifs conversion to netfslib
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

Below change needs to be applied on top of your branch.

lxsmbadmin@netfsvm:~/latest_14mar/linux-fs$ git diff
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index af7483c246ac..447934ff80b8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2969,6 +2969,12 @@ cifs_write_from_iter(loff_t offset, size_t len,
struct iov_iter *from,

                cur_len =3D min_t(const size_t, len, wsize);

+               if (!cur_len) {
+                       rc =3D -EAGAIN;
+                       add_credits_and_wake_if(server, credits, 0);
+                       break;
+               }
+
                wdata =3D cifs_writedata_alloc(cifs_uncached_writev_complet=
e);
                if (!wdata) {
                        rc =3D -ENOMEM;

lxsmbadmin@netfsvm:~/xfstests-dev$ sudo ./check generic/013
SECTION       -- smb3
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 netfsvm 5.17.0-rc6+ #1 SMP PREEMPT Mon
Mar 14 09:05:47 UTC 2022
MKFS_OPTIONS  -- //127.0.0.1/sambashare_scratch
MOUNT_OPTIONS -- -ousername=3D,password=3D,noperm,vers=3D3.0,actimeo=3D0
//127.0.0.1/sambashare_scratch /mnt/xfstests_scratch

generic/013      149s
Ran: generic/013
Passed all 1 tests

SECTION       -- smb3
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Ran: generic/013
Passed all 1 tests

Regards,
Rohith

On Fri, Mar 11, 2022 at 1:56 PM David Howells <dhowells@redhat.com> wrote:
>
>
> David Howells <dhowells@redhat.com> wrote:
>
> > The other issue is that if I run splice to an empty file, it works; run=
ning
> > another splice to the same file will result in the server giving
> > STATUS_ACCESS_DENIED when cifs_write_begin() tries to read from the fil=
e:
> >
> >     7 0.009485249  192.168.6.2 =E2=86=92 192.168.6.1  SMB2 183 Read Req=
uest Len:65536 Off:0 File: x
> >     8 0.009674245  192.168.6.1 =E2=86=92 192.168.6.2  SMB2 143 Read Res=
ponse, Error: STATUS_ACCESS_DENIED
> >
> > Actually - that might be because the file is only 65536 bytes long beca=
use the
> > first splice finished short.
>
> Actually, it's because I opened the output file O_WRONLY.  If I open it
> O_RDWR, it works.  The test program is attached below.
>
> David
> ---
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <fcntl.h>
>
> int main(int argc, char *argv[])
> {
>         off64_t opos;
>         size_t len;
>         int in, out;
>
>         if (argc !=3D 4) {
>                 printf("Format: %s size in out\n", argv[0]);
>                 exit(2);
>         }
>
>         len =3D atol(argv[1]);
>
>         if (strcmp(argv[2], "-") !=3D 0) {
>                 in =3D open(argv[2], O_RDONLY);
>                 if (in < 0) {
>                         perror(argv[2]);
>                         return 1;
>                 }
>         } else {
>                 in =3D 0;
>         }
>
>         if (strcmp(argv[3], "-") !=3D 0) {
>                 out =3D open(argv[3], O_WRONLY);  // Change to O_RDWR
>                 if (out < 0) {
>                         perror(argv[3]);
>                         return 1;
>                 }
>         } else {
>                 out =3D 1;
>         }
>
>         opos =3D 3;
>         if (splice(in, NULL, out, &opos, len, 0) < 0) {
>                 perror("splice");
>                 return 1;
>         }
>
>         if (close(in) < 0) {
>                 perror("close/in");
>                 return 1;
>         }
>
>         if (close(out) < 0) {
>                 perror("close/out");
>                 return 1;
>         }
>
>         return 0;
> }
>
