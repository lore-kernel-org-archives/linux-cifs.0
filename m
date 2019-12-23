Return-Path: <SRS0=pEcy=2N=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333D5C2D0C0
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Dec 2019 20:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE10D2073A
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Dec 2019 20:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s09mEzd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfLWUlP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Dec 2019 15:41:15 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46030 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfLWUlP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Dec 2019 15:41:15 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so13508578lfa.12
        for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2019 12:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bUoXm7Xs8HXjPNvU6ZHRNYwLnk0MDkwNkXf9wKZnH2g=;
        b=s09mEzd818x9m3aeXbDk2w99UfUpSu5jeHCeS447tzfJJREH9gEH8J51t6JPJTZkem
         FjY4eN4kJJIJUGQViws6WLkD3N/BKjNPODHEXelwTF8qcx71/K/5oiaXhCegZxTQChV7
         1OqaGHDTTDhgi+G2yvzWa4GFXqO0h1BEbAiZlPaGuieAkTROzNEUS/LWGDMG4JcKzJn2
         kpAXhDf4DYHWCrsg8nvaE7lAYf1lPwaHgf8OoWJZfkSWo/YwD6jYlOMD4TcOGUQNaVhD
         2jR0ZrfZ4IH4BuVW5eCVch5DKVSu3AiiO2a5oLEWzPfGi9lVbHIsDZYspOXhzR+0A+Iu
         NJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bUoXm7Xs8HXjPNvU6ZHRNYwLnk0MDkwNkXf9wKZnH2g=;
        b=CsXLGnrNjvlkssLpzye79Nk1nlNW/ovqEoJw1QcRRQZxqX5Ohbuh9cfxvt9H5w+gFE
         Hy2Z8tU4QZjOKKt2/KnmPe8dGw6+5WO8RIoQGVbOjoR1I5HNmpskM7g3r/SO4fkHBI/N
         vdpaCJ86JGFYucuPb9SPfCvyb9gsC0p9zbz2wpcUwezzosgHxWhaQ+TZthwUDQkfdm3U
         4d2GpMxBRfOyjInAFvquZFw7UH1FU2+6dwxARJziAwE5ms710I1EZMyHNOjt4MRJw5xS
         v+6xh5475s6pxxBiI0GwUbz1eg+GUFhNUv7BA6mr+kD0XuPf3NX+9NU0drqj/BQe7pXy
         kRfA==
X-Gm-Message-State: APjAAAWeYRHk7gfQlkqSL2mnNmjUGBzJuY1rljDFjs4OwFfo8KxEhQ0s
        lyJ/R+OCv3qRxguWwWWWdbOMrPoA528i9qY4wNQy
X-Google-Smtp-Source: APXvYqxLX700xDJGbp1WuHrVNOsrS35IdIQ5sEd8RmcUyiUjV+dCV+NKrsRD8iE+96+UrtoR3wt2lG8Qa6tU0nF5fHY=
X-Received: by 2002:a05:6512:488:: with SMTP id v8mr17638735lfq.173.1577133673116;
 Mon, 23 Dec 2019 12:41:13 -0800 (PST)
MIME-Version: 1.0
References: <20191220005848.22327-1-lsahlber@redhat.com>
In-Reply-To: <20191220005848.22327-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 23 Dec 2019 12:41:01 -0800
Message-ID: <CAKywueSfAUkdn2gssdT0LUUc77KwAZuqEyq2vj8+hDw9TMuhXQ@mail.gmail.com>
Subject: Re: [PATCH] smbinfo: remove invalid arguments to ioctl method
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. Thanks!
--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 19 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 16:59, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  smbinfo | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/smbinfo b/smbinfo
> index 1be82c7..ee774d3 100755
> --- a/smbinfo
> +++ b/smbinfo
> @@ -443,7 +443,7 @@ def cmd_filefsfullsizeinfo(args):
>      qi =3D QueryInfoStruct(info_type=3D0x2, file_info_class=3D7, input_b=
uffer_length=3D32)
>      try:
>          fd =3D os.open(args.file, os.O_RDONLY)
> -        total, caller_avail, actual_avail, sec_per_unit, byte_per_sec =
=3D qi.ioctl(fd, CIFS_QUERY_INFO, '<QQQII')
> +        total, caller_avail, actual_avail, sec_per_unit, byte_per_sec =
=3D qi.ioctl(fd, '<QQQII')
>      except Exception as e:
>          print("syscall failed: %s"%e)
>          return False
> @@ -540,7 +540,7 @@ def cmd_getcompression(args):
>      qi =3D QueryInfoStruct(info_type=3D0x9003c, flags=3DPASSTHRU_FSCTL, =
input_buffer_length=3D2)
>      try:
>          fd =3D os.open(args.file, os.O_RDONLY)
> -        ctype =3D qi.ioctl(fd, CIFS_QUERY_INFO, '<H')[0]
> +        ctype =3D qi.ioctl(fd, '<H')[0]
>      except Exception as e:
>          print("syscall failed: %s"%e)
>          return False
> --
> 2.13.6
>
