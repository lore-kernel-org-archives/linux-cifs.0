Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42F8C32792
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99C362133F
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:23:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EazOEHZ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbfJDAXV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 20:23:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34472 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730969AbfJDAXU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 20:23:20 -0400
Received: by mail-lf1-f65.google.com with SMTP id r22so3194005lfm.1
        for <linux-cifs@vger.kernel.org>; Thu, 03 Oct 2019 17:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7vMc6KDlBcnghGB9c43lv1XQLrLse3+j0pr6CseKS/c=;
        b=EazOEHZ392ZrKlo3aqbBugnP+8Mh7YknVLEzRrYoLM2seLAkQ+82InqtT9lgsyTuSa
         JvYEXrDupxxrxGuPCxk3YxpnM55TXqMkyTExLDXnJ0GQikRpyykphxR8wMHsfpDoBJuo
         SdvlnMs0zPHglHE1QL0E14Dd1wWoZvizR5kzUQW1s21dwIayp+Xn34iZJeTboGRaLnPo
         s9SRtpJMSnhTfuDdOIweteMV6QjmHjVYQhFjUPzRXJmondg8RzSN5KuTCXVQBiffdTh5
         wd2zKONC/FcXxS7BzKaJPsvd7+icIxZLGAlLl1VnlBdEermDEn8pm29Be2oZ69FSSTTE
         Z5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7vMc6KDlBcnghGB9c43lv1XQLrLse3+j0pr6CseKS/c=;
        b=ug7qC4/pKlrbRrrOBvUn5JYRBceuMzOTAcW1A9bZpDcDJZel9yGA+0hZBJGZd+k57s
         2ljHcA5mOTjU+gBGWJfSwTBZ18cjcNkTsVA6dy0mthhRnzXC4h4zD9AuLuI240Pkv5Mj
         ktbqxu4HMl8luCoL8tJT0YMSI2Wvhg6muofN8k8TRQcOD8fuwYUhxjL7mCP8YeN0lydt
         vAsMx4cIDjBeep34Qt2A06LHvqkenVWcrxRzMlsrzfLJkBalGKoHC0bv1adelswEiINw
         wI4QMZAy1nXA0jHZ1uUn1OtzyIH7iHyS94ylmpvb/7dkm/hWQSulpCyvs/9Py9eyeWbV
         4QKQ==
X-Gm-Message-State: APjAAAWxXC/bp5YhIKKHPZSSj1LScA4hDMAX5/3aEMpWYvgmom6kMQMj
        h31OXMn4abWBW9bLN9A+fLJQqAs5KWR0DvyAIpSh3Pk=
X-Google-Smtp-Source: APXvYqwOGw9nZ/A5ERBBn8vCm6/MAZzsFlCyTjV4eiEu/gGx676lSBKnhvnMXZZ8KCrnkBkL1byYt8UO1BIicye8qu8=
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr7493883lfp.15.1570148598838;
 Thu, 03 Oct 2019 17:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190919121226.8756-1-pc@cjr.nz> <4451b38f-abb2-8437-62f6-e499a3497737@suse.com>
In-Reply-To: <4451b38f-abb2-8437-62f6-e499a3497737@suse.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Thu, 3 Oct 2019 17:23:07 -0700
Message-ID: <CAKywueSaA8gavuVWhVGcEjdTt_u_GiPSW0bkCc_jLqpL2t_P9g@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs: Fix invalid free
To:     David Mulder <dmulder@suse.com>
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 2 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 13:04, David Mulder=
 via samba-technical
<samba-technical@lists.samba.org>:
>
> Reviewed-by: David Mulder <dmulder@suse.com><mailto:dmulder@suse.com>
>
> On 9/19/19 6:12 AM, Paulo Alcantara (SUSE) wrote:
>
> When attemping to chdir into non-existing directories, mount.cifs
> crashes.
>
> This patch fixes the following ASAN report:
>
> $ ./mount.cifs //localhost/foo /mnt/invalid-dir -o ...
> /mnt/bar -o username=3Dfoo,password=3Dfoo,vers=3D1.0
> Couldn't chdir to /mnt/bar: No such file or directory
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D11846=3D=3DERROR: AddressSanitizer: attempting free on address whic=
h was
> not malloc()-ed: 0x7ffd86332e97 in thread T0
>     #0 0x7f0860ca01e7 in
>     __interceptor_free (/usr/lib64/libasan.so.5+0x10a1e7)
>     #1 0x557edece9ccb in
>     acquire_mountpoint (/home/paulo/src/cifs-utils/mount.cifs+0xeccb)
>     #2 0x557edecea63d in
>     main (/home/paulo/src/cifs-utils/mount.cifs+0xf63d)
>     #3 0x7f08609f0bca in __libc_start_main (/lib64/libc.so.6+0x26bca)
>     #4 0x557edece27d9 in
>     _start (/home/paulo/src/cifs-utils/mount.cifs+0x77d9)
>
> Address 0x7ffd86332e97 is located in stack of thread T0 at offset 8951
> in frame
>     #0 0x557edece9ce0 in
>     main (/home/paulo/src/cifs-utils/mount.cifs+0xece0)
>
>   This frame has 2 object(s):
>     [48, 52) 'rc' (line 1959)
>     [64, 72) 'mountpoint' (line 1955) <=3D=3D Memory access at offset 895=
1
>     overflows this variable
> HINT: this may be a false positive if your program uses some custom
> stack unwind mechanism, swapcontext or vfork
>       (longjmp and C++ exceptions *are* supported)
> SUMMARY: AddressSanitizer: bad-free (/usr/lib64/libasan.so.5+0x10a1e7)
> in __interceptor_free
> =3D=3D11846=3D=3DABORTING
>
> Fixes: bf7f48f4c7dc ("mount.cifs.c: fix memory leaks in main func")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz><mailto:pc@cjr.nz>
> ---
>  mount.cifs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 7748d54aa814..0c38adcd99b1 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1893,7 +1893,7 @@ acquire_mountpoint(char **mountpointp)
>         int rc, dacrc;
>         uid_t realuid, oldfsuid;
>         gid_t oldfsgid;
> -       char *mountpoint;
> +       char *mountpoint =3D NULL;
>
>         /*
>          * Acquire the necessary privileges to chdir to the mountpoint. I=
f
> @@ -1942,9 +1942,9 @@ restore_privs:
>                 gid_t __attribute__((unused)) gignore =3D setfsgid(oldfsg=
id);
>         }
>
> -       if (rc) {
> -               free(*mountpointp);
> -       }
> +       if (rc)
> +               free(mountpoint);
> +
>         return rc;
>  }
>
Merged, thanks.
--
Best regards,
Pavel Shilovsky
