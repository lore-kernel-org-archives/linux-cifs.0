Return-Path: <SRS0=KHP/=WR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57046C3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Aug 2019 22:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D4302339E
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Aug 2019 22:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGqT9p9H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731258AbfHUWi0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Aug 2019 18:38:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35967 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731195AbfHUWiV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Aug 2019 18:38:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so2201834pgm.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2019 15:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=57I+tWMp+4ETKqAGg2Whreg0vAk4mpz7a88V7iEchDI=;
        b=WGqT9p9HY9e8snmx9zn/S5zOXqbJzkoukRpVpl8TZSgihyEVdmA+/Qz+Ve/OX1icY0
         jScnsCfhJ3QxP+J3Jdyh7WtgvklSgv+qbMZjDhGyG+BmC7m2zXIg4KbIQ02V69KTUiaH
         x+zanVkJxBaoRoBgPIlR/4+84Xk1rALzIvtmPnPHoXg/kLjQpX4lrAFlPe9x9k+N4Vcg
         WEOtH3Kx00qZ3+nzjhLrQs+G0wGJe64jqZcOl3JVZGnAVw17ap2sHvgkjloEAQ9Uuvvs
         Oi9O6hptgujH7bef2NIMs2KJrzgREHw8T2/LlJProfnAASkjkw3jfezXrUF14ZV+zd5q
         PyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=57I+tWMp+4ETKqAGg2Whreg0vAk4mpz7a88V7iEchDI=;
        b=o9+AAtsINumNQLeZ3luuRMJMxhTLS+bdLBwjeGzfKaG3F+129O12ETdNLyuzePVYVV
         8stD+268zBFSGssvLPnbTpGPmQELUTOX4KDE2RjFonMLkxmAyT9u7AiaveGnaOfITGih
         zSRqfYqf0TtrA2nUqqUIPyELOPMtyH/EVrNkMY9nJCpQFoVZyqF7GK/3Csjv+TbGk+u6
         9f/W/tHaCByHJ2Zi6n2+ST/7nzFEpctjXCDIyJ+rJRqbPQw1t6v8ysNwAz1VI3Ushk7i
         3tmMckCDytZEGXxXZTEr+MPoDiHDGtnCHBzlS9LBUZHQub/Ml1eKDKPdP7AuIb4q3bk2
         ea0Q==
X-Gm-Message-State: APjAAAVVegXnXR3dhhiHt/lycrRgM68y6yk3cH3NW3vqP4glxI5e91jk
        YVPlZLjXslfubBBMMWqvkM/y01Bmgm7dNwAhMII=
X-Google-Smtp-Source: APXvYqwVa2aFTGwLobEUkqYP7y4OnONE8R+Bxp0U1Xi5owyAQ/OAh4v5IN6ez0/S+qftSOZU7vyG7E9QhhO++u+NqnU=
X-Received: by 2002:a62:cec4:: with SMTP id y187mr37740001pfg.84.1566427100888;
 Wed, 21 Aug 2019 15:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190821220950.27992-1-lsahlber@redhat.com>
In-Reply-To: <20190821220950.27992-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Aug 2019 17:38:09 -0500
Message-ID: <CAH2r5mv6WmwgCC=5B3S1=XuLwTjeb00+ARYrwCzqVMQOojM8=g@mail.gmail.com>
Subject: Re: [PATCH] cifs: set domainName when a domain-key is used in multiuser
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next pending testing and any
additional review comments

On Wed, Aug 21, 2019 at 5:10 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1710429
>
> When we use a domain-key to authenticate using multiuser we must also set
> the domainnmame for the new volume as it will be used and passed to the server
> in the NTLMSSP Domain-name.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a15a6e738eb5..6f5c3ef327bd 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2981,6 +2981,7 @@ static int
>  cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
>  {
>         int rc = 0;
> +       int is_domain = 0;
>         const char *delim, *payload;
>         char *desc;
>         ssize_t len;
> @@ -3028,6 +3029,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
>                         rc = PTR_ERR(key);
>                         goto out_err;
>                 }
> +               is_domain = 1;
>         }
>
>         down_read(&key->sem);
> @@ -3085,6 +3087,26 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
>                 goto out_key_put;
>         }
>
> +       /*
> +        * If we have a domain key then we must set the domainName in the
> +        * for the request.
> +        */
> +       if (is_domain && ses->domainName) {
> +               vol->domainname = kstrndup(ses->domainName,
> +                                          strlen(ses->domainName),
> +                                          GFP_KERNEL);
> +               if (!vol->domainname) {
> +                       cifs_dbg(FYI, "Unable to allocate %zd bytes for "
> +                                "domain\n", len);
> +                       rc = -ENOMEM;
> +                       kfree(vol->username);
> +                       vol->username = NULL;
> +                       kfree(vol->password);
> +                       vol->password = NULL;
> +                       goto out_key_put;
> +               }
> +       }
> +
>  out_key_put:
>         up_read(&key->sem);
>         key_put(key);
> --
> 2.13.6
>


-- 
Thanks,

Steve
