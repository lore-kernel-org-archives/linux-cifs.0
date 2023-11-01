Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AFEC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Nov 2023 03:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjKADOq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjKADOp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 23:14:45 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C43A4
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:14:43 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-507d7b73b74so8662330e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698808481; x=1699413281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WD9CCz2w2BJxavVMsiWxRTfjo/DA5qmyHMhCIutfnMw=;
        b=fQqEiWJkZN+7UoUx+WpjgBOdYv5T9cSM9DEN/E0IEh7KmUAyJidj/t9QwsRsQBZcJa
         bYRz79qoTQzpUy2F5UlXeFaERJIBDs0lEU7W+4DeOIUlvWK8Fe/taydOy2ccN4cfR9DH
         W2HzBpEWPrhmNDhUYl3zSgBJPii+lY5Ptc38l9NaS6r9YZ+huTI0uSdDuIfiIMQ6B+wq
         ki0bhBH0FsF53kAF55G1eEYp04Dm+QCyU0357+/4jyQCvJ/UllEpoj/d+jSz6dEmb75i
         2QPpUwrZDBY9o2lG4OGswmmI/CBnNeYSXzdSgLpl5Xqpkp7vNc2GPPHX8aVnMx8B6bF3
         C5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698808481; x=1699413281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WD9CCz2w2BJxavVMsiWxRTfjo/DA5qmyHMhCIutfnMw=;
        b=BsK1a3ynBRMu5cJz0zQrvDLYAQytuCIh01rOP4AtKDO+Nh+TckGdAFXNOKjqx3otaa
         sH1ynNG6wwHi4codiTVBSaPk4py8rboyiVPAXo+KeNIGccMGhL1YCc6vUx17loqYKXpN
         Cn4WPZCpIjy16k21bqUj8kcK5VgWx7dp6Xp+DovQC9A6fsWS+6LjP3gpWUpGjPqdSHDY
         v6xpG4ASxJB5WI3Vqa6ZxKz4G0nEOg2s6om7jT7YlZ1IEpKG91qi79g1mu6agqeD/KmZ
         R1oQjaOywbrzm2UT6I+3XUILTUI5tPJR15Z98AR+enUwziJQ0i4IOfvSyVy+cditZX72
         szeg==
X-Gm-Message-State: AOJu0YymWmy1eZqzMu8e1U6EZSqEYe6p+EjF6e8kLdJxpqTwYUQ3DAWj
        12qUlKPc7ivIzm7vkFXy8uT1Ose8asiIy31UBjY=
X-Google-Smtp-Source: AGHT+IGABJALALnmrOw4V1pEf5dICBKXYtEkyzWB2Y1QFGHJo9GTeP8wMYThxnN7HKwLxSzoAzpdm3VxZhpmc7tgO0k=
X-Received: by 2002:ac2:4c82:0:b0:507:9a33:f105 with SMTP id
 d2-20020ac24c82000000b005079a33f105mr9389358lfl.69.1698808481017; Tue, 31 Oct
 2023 20:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-5-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-5-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 22:14:29 -0500
Message-ID: <CAH2r5muuT6TCqxsa9_v-DAX+D31JWTQi7DM4Dzwf8qhSB27oww@mail.gmail.com>
Subject: Re: [PATCH 05/14] cifs: force interface update before a fresh session setup
To:     nspmangalore@gmail.com
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

And added cc:stable

On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> During a session reconnect, it is possible that the
> server moved to another physical server (happens in case
> of Azure files). So at this time, force a query of server
> interfaces again (in case of multichannel session), such
> that the secondary channels connect to the right
> IP addresses (possibly updated now).
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/connect.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index c993c7a3415a..97c9a32cff36 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3854,8 +3854,12 @@ cifs_setup_session(const unsigned int xid, struct =
cifs_ses *ses,
>         is_binding =3D !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
>         spin_unlock(&ses->chan_lock);
>
> -       if (!is_binding)
> +       if (!is_binding) {
>                 ses->ses_status =3D SES_IN_SETUP;
> +
> +               /* force iface_list refresh */
> +               ses->iface_last_update =3D 0;
> +       }
>         spin_unlock(&ses->ses_lock);
>
>         /* update ses ip_addr only for primary chan */
> --
> 2.34.1
>


--=20
Thanks,

Steve
