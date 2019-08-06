Return-Path: <SRS0=QbqR=WC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41907C31E40
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 16:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EB9420C01
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 16:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="meYdkyqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732612AbfHFQt1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Aug 2019 12:49:27 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38834 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbfHFQt1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Aug 2019 12:49:27 -0400
Received: by mail-lf1-f66.google.com with SMTP id h28so61670328lfj.5
        for <linux-cifs@vger.kernel.org>; Tue, 06 Aug 2019 09:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hlyXrj48pzxZ4SpIK4ThoBxgtUsLBHLxuYhC+6TnYyA=;
        b=meYdkyqh7gbuOisz7BJFCsI51dPX5KnXNrBpWoYOHEPoqsc1Nla7KDGtkS8DG+v7u1
         RBaDmI51ZEd54s7rvcAf/7mKtvVOFFrCgmh+R9waCyMi5in3OiTrC0I2aAOxwhqy4B+9
         eae/DxtwghsHQimXoMmYcvuisj0gePKsKcHU5/HC+YFR/FlNZiwyDXE6upuAFKYUp7pg
         XWb8w8M91+loGLpOwHOsscocwEwvKYSAJcpQbr483zlZXuGhETA73gfVyfXABj0c3j88
         vGcfYYr53bHsXVrt+x7hZRI6uLUjcxvZdy7Cb3F4j5uFz6LPh0ypjx4soADkYytfrJbv
         gw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hlyXrj48pzxZ4SpIK4ThoBxgtUsLBHLxuYhC+6TnYyA=;
        b=VLlp9GoaR1TO8xa7ZafjpYIQdLl/58anotm1ebgvF2lZBAziieVyrTg6jp+h7FUVxO
         sAMAFIhdDq20B98/6RZM0PBLpfd9S911yQhT9cn0TWK4zW8v4GJdDxBzgYCJK2xuOJtx
         DAh7WevvB9XC77EEmMfD3AWjttzwCFhzoWTM83Wzk+v+c0HZBjjfwDFC0/JFxH8zl7nc
         jj7SwD/fd29DBibKc7ZlCsgxpyI9pcQ89QnBzXC97wNhIWVth0vYD7zNRUVi/3b3FcEJ
         P7VWVimyQd+f77nAegESFbWPRuN+h1z92rtK2AdHDUDH3Iy9428PFnoCP3rtruNbFQx3
         eDyQ==
X-Gm-Message-State: APjAAAXun1UTnOHGrVSgoWAc704B3oJEQLxoQKcDeJeP/N29izUxnIJS
        5HXL8QR0pWzX1DW+OoDf3WpCDlarVN2Zd0EFbMwmNt8=
X-Google-Smtp-Source: APXvYqydhDkSUG4aLFGYCPUEiI/e2o8YCSVrFvOBWsDkoSXOId+MSSUwvp0KezUv6O8L6fwafYPNBcfZGDF18OwaDLA=
X-Received: by 2002:ac2:549b:: with SMTP id t27mr3081748lfk.25.1565110165586;
 Tue, 06 Aug 2019 09:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <0f780b18-0b1c-e2ff-31b1-1d697becd142@huawei.com>
In-Reply-To: <0f780b18-0b1c-e2ff-31b1-1d697becd142@huawei.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 6 Aug 2019 09:49:13 -0700
Message-ID: <CAKywueT6C=O-1tosijf5vm5pg0YozMeEiKP56=unv370L=zzRQ@mail.gmail.com>
Subject: Re: [PATCH cifs-utils v2] mount.cifs.c: fix memory leaks in main func
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        liujiawen10@huawei.com, Steve French <smfrench@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Alexander Bokovoy <ab@samba.org>,
        Paulo Alcantara <palcantara@suse.de>, dujin1@huawei.com,
        Mingfangsen <mingfangsen@huawei.com>,
        zhangsaisai <zhangsaisai@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 5 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 19:36, Zhiqiang Liu=
 <liuzhiqiang26@huawei.com>:
>
> From: Jiawen Liu <liujiawen10@huawei.com>
>
> In mount.cifs module, orgoptions and mountpoint in the main func
> point to the memory allocated by func realpath and strndup respectively.
> However, they are not freed before the main func returns so that the
> memory leaks occurred.
>
> The memory leak problem is reported by LeakSanitizer tool.
> LeakSanitizer url: "https://github.com/google/sanitizers"
>
> Here I free the pointers orgoptions and mountpoint before main
> func returns.
>
> Fixes=EF=BC=9A7549ad5e7126 ("memory leaks: caused by func realpath and st=
rndup")
> Signed-off-by: Jiawen Liu <liujiawen10@huawei.com>
> Reported-by: Jin Du <dujin1@huawei.com>
> Reviewed-by: Saisai Zhang <zhangsaisai@huawei.com>
> Reviewed-by: Aur=C3=A9lien Aptel <aaptel@suse.com>
> ---
> v1->v2:
> - free orgoptions in main func as suggested by Aur=C3=A9lien Aptel
> - free mountpoint in acquire_mountpoint func as suggested by Aur=C3=A9lie=
n Aptel
>
>  mount.cifs.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index ae7a899..656d353 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1891,7 +1891,10 @@ restore_privs:
>                 uid_t __attribute__((unused)) uignore =3D setfsuid(oldfsu=
id);
>                 gid_t __attribute__((unused)) gignore =3D setfsgid(oldfsg=
id);
>         }
> -
> +
> +       if (rc) {
> +               free(*mountpointp);
> +       }
>         return rc;
>  }
>
> @@ -1994,8 +1997,10 @@ int main(int argc, char **argv)
>
>         /* chdir into mountpoint as soon as possible */
>         rc =3D acquire_mountpoint(&mountpoint);
> -       if (rc)
> +       if (rc) {
> +               free(orgoptions);
>                 return rc;
> +       }
>
>         /*
>          * mount.cifs does privilege separation. Most of the code to hand=
le
> @@ -2014,6 +2019,8 @@ int main(int argc, char **argv)
>                 /* child */
>                 rc =3D assemble_mountinfo(parsed_info, thisprogram, mount=
point,
>                                         orig_dev, orgoptions);
> +               free(orgoptions);
> +               free(mountpoint);
>                 return rc;
>         } else {
>                 /* parent */
> @@ -2149,5 +2156,6 @@ mount_exit:
>         }
>         free(options);
>         free(orgoptions);
> +       free(mountpoint);
>         return rc;
>  }
> --
> 2.7.4
>

Thanks for the patch! I will apply it to my github tree shortly.

--
Best regards,
Pavel Shilovsky
