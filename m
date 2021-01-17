Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D5FC433DB
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Jan 2021 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD05020770
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Jan 2021 21:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbhAQV7S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbhAQV7R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Jan 2021 16:59:17 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869DEC061573;
        Sun, 17 Jan 2021 13:58:36 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id m10so16267023lji.1;
        Sun, 17 Jan 2021 13:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z4HhEek/Tw4oVixmxh9pmK2rVtkzaVm9nEVNhWaLiyw=;
        b=jDmj8Lh2X7IY7EvLIy/ippLSvG+u36PR8Mf4KjMpj6sEGJkVJWqrIV/dJgdtpHChPt
         x5dfS7+Gf3Clr0jy4FS6yY2j27zVS6+WI0JFwy9B8QXwfS6Kq1R4X7QuGbGfQWwyez2t
         7k6k7gt0cn2wPjkg5wMKMKZqie8lQL7auL2I5u09vbokUqRB/FOSU3a7lDKC9Z/U3YY6
         u51JXUm6vBmOOaAdzNbHiBwREMPhDErI1geeDdtyg6LERBhlG/w0vZwDtW4426RcAv4/
         eJXUKn0oOlOyug7Xg7ir1mYhcr+MxAfJCvf+qBfYXQ7QzfMqIIyIIc5HhAt2k2WOlyE7
         7RHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z4HhEek/Tw4oVixmxh9pmK2rVtkzaVm9nEVNhWaLiyw=;
        b=ZVL/jK/CW8p2hHsYw+8cL2iMD40QQ8Jf30+ns0IHbBmZMRrks8hREfqQwQVGvwbUgm
         6oqm1c4ZZvpESqER7LgDCG+aSv2VqNRHeo4bUbxb7jRp46uCCoQfDoakuF7PwvCqyRhB
         CNCxAohRkzYJzd+tjWgTuf+Wy0i6WZfOO1MldVBylI3u65sgd83UqHyWAzqqaI1sA7Hq
         ISZ3mMoncRpPSrbS8zOHm4mR3Si4rEXhiTuLxCh9NYl2gFz6e3DZmNxnHIni5apEBuGg
         ZnwNgX6j9Q6UBEFaoaRWe2NhftEt9omuHo1c3hX58FeeNM+UKpAaLVVbzdX6PzFPeWiQ
         zYAQ==
X-Gm-Message-State: AOAM533OKpSmbvpsS7tqrS0ZfgrMZLRyooyqMYho7YmsI1LAEH2WCFS7
        EyGIY9eDjsry9fqCIuwYTpiKYeh8L6r3xzhwZOEW3fjDV6zFpw==
X-Google-Smtp-Source: ABdhPJwokbA6/W6R0raE8C9n2bMjc3KswnhdTLzWgy9AEQ+TqpOAELHUGy8q111zgCEdK7WbqrhT3M/2TzPzNcYcDGk=
X-Received: by 2002:a2e:9250:: with SMTP id v16mr9459481ljg.256.1610920714945;
 Sun, 17 Jan 2021 13:58:34 -0800 (PST)
MIME-Version: 1.0
References: <1610615171-68296-1-git-send-email-abaci-bugfix@linux.alibaba.com> <87czy7lvjy.fsf@suse.com>
In-Reply-To: <87czy7lvjy.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 17 Jan 2021 15:58:23 -0600
Message-ID: <CAH2r5mvjDAgB6-kE=AOAwrETVk+R79z6Gd8gMnOTWqG-6Mnybw@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: Replace one-element array with flexible-array member.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jiapeng,
Aurelien is correct, you should respin this patch and correct for
where it breaks the sizeof calculation.  For example your change:

struct smb2_lock_rsp {
@@ -1434,7 +1434,7 @@ struct smb2_query_directory_req {
        __le16 FileNameOffset;
        __le16 FileNameLength;
        __le32 OutputBufferLength;
-       __u8   Buffer[1];
+       __u8   Buffer[];
 } __packed;

would have the side effect of making the file name off by one:

smb2pdu.c-4654- req->FileNameOffset =3D
smb2pdu.c:4655:         cpu_to_le16(sizeof(struct
smb2_query_directory_req) - 1);

On Thu, Jan 14, 2021 at 3:26 AM Aur=C3=A9lien Aptel via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Hi Jiapeng,
>
> This will change the size returned by sizeof(). Have you checked that
> this doesn't introduce off-by-one errors in all the sizeof() usage?
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
>


--=20
Thanks,

Steve
