Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70606C2BB9A
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 22:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D732342C
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 22:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgLPWma (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbgLPWma (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 17:42:30 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00B3C061794
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 14:41:49 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id q22so17361364eja.2
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 14:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/roba0oaCn8lBSdxjK38UauGgCbvn7c7Anak2m4UNNc=;
        b=d+BSUIkw8njvAoPHDsgjd8zZxRZYAUgIMG4JZhPwTn2K1ksltf4Fiq3LzBe1DTtIhL
         fp52dAfz5qTXnehgwyZDfNyOo0nmMb+G9hkyj8MD4zV+WbafCEP1w7/F6BWCcjR69NAy
         Yye15mtHh1Fi2A2dNd3iOJWzmAMYe+Gso8P/GexYotoqQBbYEny68Q5M3pWYMxcHuGFV
         NqKn9exenm10BKH/YoALXvHR6wG2tMNm21hOt3IGnEcGl5buYhC611Q38mZHBs2HITpx
         3eLznixTOPKwagaDxTlQUdnYng4SMyjsC26IG+wt3sJVvbkco0pMSrhpJreEZpeHTShI
         sejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/roba0oaCn8lBSdxjK38UauGgCbvn7c7Anak2m4UNNc=;
        b=iBxD7IaOTdHcWGre/a4+Q4CehNFMuYOemuz0tHdvDQeCZ7WH6/0vlTT1jvudTHqaFf
         Rkleb7wrOO1FC9W8nqRAJOjWgE8ubNrFIoipqxqePiciR644g2qHpqsHIxH74mgQTgCx
         EjmgDXO5WJU/mWYlEBm/CtV5HeW23p4316CGo6c2A8Ay23S6lXQ74taXdKgxRTWVFgPe
         /5hA7MOf0NfDw6B8luoTu4jiLWxjruArHDiezA6m2pe3BigYgw/Iy8fywfXh8UOgUwkB
         xVGtugS9RbcbdoeqsFgAU5lBOzPRFQ+94b8aA79IwcqFjXWjI3lpevocID+7xR9n+M5q
         mpxw==
X-Gm-Message-State: AOAM531LS7MT6Yukmh9WH/2eq9Ty52Tu+b67v1HKW5tn6t/Azil3SyPe
        0GL9OggpAxC8rL7ziTwW0BeWi1rriQoxOIvUMA==
X-Google-Smtp-Source: ABdhPJy4Iv55I+n87wG4OcNYTQxUB3515Jyq+BV5mXwhsFgnosvhSYGPfy1RasGI5MAk6jSN6SOB3l844lIt3RPM89k=
X-Received: by 2002:a17:906:4146:: with SMTP id l6mr13237999ejk.341.1608158508626;
 Wed, 16 Dec 2020 14:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20201216214455.41251-1-diabonas@archlinux.org>
In-Reply-To: <20201216214455.41251-1-diabonas@archlinux.org>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 16 Dec 2020 14:41:37 -0800
Message-ID: <CAKywueRpm7Y2NYr89AK7iVxTitAS9VOFT7cpfJnRnFwiZSdG-Q@mail.gmail.com>
Subject: Re: [PATCH] cifs.upcall: drop bounding capabilities only if
 CAP_SETPCAP is given
To:     Jonas Witschel <diabonas@archlinux.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Alexander Koch <mail@alexanderkoch.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. Thanks!

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 16 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 13:47, Jonas Witsc=
hel <diabonas@archlinux.org>:
>
> From: Alexander Koch <mail@alexanderkoch.net>
>
> Make drop_call_capabilities() in cifs.upcall update the bounding capabili=
ties
> only if CAP_SETCAP is present.
>
> This is an addendum to the patch recently provided in [1]. Without this
> additional change, cifs.upcall can still fail while trying to mount a CIF=
S
> network share with krb5:
>
>   kernel: CIFS: Attempting to mount //server.domain.lan/myshare
>   cifs.upcall[39484]: key description: cifs.spnego;0;0;39010000;ver=3D0x2=
;host=3Dserver.domain.lan>
>   cifs.upcall[39484]: ver=3D2
>   cifs.upcall[39484]: host=3Dserver.domain.lan
>   cifs.upcall[39484]: ip=3D172.22.3.14
>   cifs.upcall[39484]: sec=3D1
>   cifs.upcall[39484]: uid=3D1000
>   cifs.upcall[39484]: creduid=3D1000
>   cifs.upcall[39484]: user=3Dusername
>   cifs.upcall[39484]: pid=3D39481
>   cifs.upcall[39484]: get_cachename_from_process_env: pathname=3D/proc/39=
481/environ
>   cifs.upcall[39484]: get_cachename_from_process_env: cachename =3D FILE:=
/tmp/.krb5cc_1000
>   cifs.upcall[39484]: drop_all_capabilities: Unable to apply capability s=
et: Success
>   cifs.upcall[39484]: Exit status 1
>
> [1] https://marc.info/?l=3Dlinux-cifs&m=3D160595758021261
>
> Signed-off-by: Alexander Koch <mail@alexanderkoch.net>
> Signed-off-by: Jonas Witschel <diabonas@archlinux.org>
> ---
>  cifs.upcall.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 1559434..b62ab50 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -115,8 +115,13 @@ trim_capabilities(bool need_environ)
>  static int
>  drop_all_capabilities(void)
>  {
> +       capng_select_t set =3D CAPNG_SELECT_CAPS;
> +
>         capng_clear(CAPNG_SELECT_BOTH);
> -       if (capng_apply(CAPNG_SELECT_BOTH)) {
> +       if (capng_have_capability(CAPNG_EFFECTIVE, CAP_SETPCAP)) {
> +               set =3D CAPNG_SELECT_BOTH;
> +       }
> +       if (capng_apply(set)) {
>                 syslog(LOG_ERR, "%s: Unable to apply capability set: %m\n=
", __func__);
>                 return 1;
>         }
> --
> 2.29.2
>
