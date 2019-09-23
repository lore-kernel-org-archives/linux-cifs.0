Return-Path: <SRS0=Y4Lp=XS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAB1C3A5A6
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 05:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A16B820820
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 05:07:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IuVVnnYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfIWFHx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Sep 2019 01:07:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46450 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbfIWFHw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Sep 2019 01:07:52 -0400
Received: by mail-io1-f65.google.com with SMTP id c6so17151954ioo.13
        for <linux-cifs@vger.kernel.org>; Sun, 22 Sep 2019 22:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iXScaD30YG/p3+MNQfrVQdEgoY7wDSzGtNpqAitrXE8=;
        b=IuVVnnYzFeggfnukp/CYuFDR15dUIOMl1UvIu0SviANcXIbmDmDq0cxtB0heZ0Eqno
         ENHKjsqHGs4AFRWiLXuIT4fRMFQwONeEx5nbeSJDTTtYwRGroKreuNXnMjqOj1jSd1yD
         BEowuqnS+MAcsfLL/P+PcI+hULpowXHsAQAWKd2f9haoqqZ3DG7Tqk/ZhTcXCJfp9DUB
         GNQVntt8UgUHL2mi/L76k792+3EIaEPGe1DiOpmAMt1EAHuFqreWyjXeOhxOPk9QX2lA
         iZ8VHhq85nsIBxQZ/9tkxDbWvl89MKyLV2BblpGrRkz/O8oieTYifsb0iXs+Llazf5fg
         TC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iXScaD30YG/p3+MNQfrVQdEgoY7wDSzGtNpqAitrXE8=;
        b=GfDYz7m619tIGQFC18UiKyAq78g6KZbszTiVqka8gmU7feElVI00nzzO5iN5zy6DV4
         gCABb8rl3Pu/7/D3uRGsgIroixnJtKJZqaTx1gLUXAobJk2zNtpCjHuYqf8TrMLLDBT4
         VIHMVSuCiGn996r+aSIaUgYLqQUSTiDB9fN/uz67gyzgROnOZFP7Jg4++yiE0jkSAbOB
         /MywJpZyV+WlLrW5t4HJ43C19BrAPVUgBWAqAPr96M8/vTDV2FAoUVMCfCZLjnbOr/WT
         0B8bwTTcYLASQv6ZJ1rXdJQ95HbHgXJokAVNVSOaknGm5H8JVtfmR18Th65OAAm+QgE/
         e8kg==
X-Gm-Message-State: APjAAAVt+v69WzTeLWkfsjimXVqCNWZhdo59aMZ3JY4FAG8Q62BM4EWQ
        KPSZvBhlYf8ARK/6t8K1Htbm1jUxg1IRh4A7NyM=
X-Google-Smtp-Source: APXvYqwdg0zCCOyAGPAmPiNsrgqd+F3Faf4q4SiPkk4W6psxcPw+DimDLu6BZqWgiT+1C8eC/z3Pq8wrsevjMQXbe68=
X-Received: by 2002:a5d:9812:: with SMTP id a18mr13029141iol.168.1569215271795;
 Sun, 22 Sep 2019 22:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <1569046966-118677-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1569046966-118677-1-git-send-email-zhengbin13@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 Sep 2019 00:07:39 -0500
Message-ID: <CAH2r5mu+ytpDOcq4Au2AZe7M00p3XJnBVD2wO949G7Ud5bp=dQ@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/smb2transport.c: Make some functions static
To:     zhengbin <zhengbin13@huawei.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks - merged into cifs-2.6.git for-next

Aur=C3=A9lien -
FYI - it makes minor update to code you changed to remove the warning.


On Sun, Sep 22, 2019 at 2:13 PM zhengbin <zhengbin13@huawei.com> wrote:
>
> Fix sparse warnings:
>
> fs/cifs/smb2transport.c:52:1: warning: symbol 'smb3_crypto_shash_allocate=
' was not declared. Should it be static?
> fs/cifs/smb2transport.c:101:4: warning: symbol 'smb2_find_chan_signkey' w=
as not declared. Should it be static?
> fs/cifs/smb2transport.c:121:17: warning: symbol 'smb2_find_global_smb_ses=
' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  fs/cifs/smb2transport.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 12988df..7cc8641 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info *serv=
er)
>                                &server->secmech.sdeschmacsha256);
>  }
>
> -int
> +static int
>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
>  {
>         struct cifs_secmech *p =3D &server->secmech;
> @@ -98,7 +98,8 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *se=
rver)
>         return rc;
>  }
>
> -u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info =
*server)
> +static u8 *
> +smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *ser=
ver)
>  {
>         int i;
>         struct cifs_chan *chan;
> @@ -118,7 +119,7 @@ u8 *smb2_find_chan_signkey(struct cifs_ses *ses, stru=
ct TCP_Server_Info *server)
>         return NULL;
>  }
>
> -struct cifs_ses *
> +static struct cifs_ses *
>  smb2_find_global_smb_ses(__u64 ses_id)
>  {
>         struct TCP_Server_Info *server;
> --
> 2.7.4
>


--=20
Thanks,

Steve
