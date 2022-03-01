Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539DFC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 23:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbiCAXMG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 18:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbiCAXMD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 18:12:03 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A0C939ED
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 15:11:21 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id c36so45570uae.13
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 15:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NJ5UGDdgfSeZeXdzldLHr0WjMt1+FouMSsx7V4Z3Fds=;
        b=M3P9qzfmpgTXCyzyqllfFo1HAJ7yQlcNpCF1Pw5OyuroHSjqdsYwWOzkckyXuYCsge
         4pVuGqWcg/sgGR5dhMJUlH8qaIFK8wZgm7Pa6wFrXW3Sjy/913xbSAz+LEX2o330HC3Y
         LGex/0nLffz4ExvVeMhmRgTT2/xF6VT6dQXca3KHP2M3f+CB7umsHEl7JxBgyhEzuLQV
         n3LZSmQEkNiYy8f9RzLog/ouymSEpUFq0sFpHhirN/Uf1o6wAWJtx5MEAK/xBZq1PzqL
         w2N2JdHG4ngWpzC/5laLuNDudkqXy806duDhTPkRckyhK+eY+WX33VCyaPo4DSjU40+u
         +gFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NJ5UGDdgfSeZeXdzldLHr0WjMt1+FouMSsx7V4Z3Fds=;
        b=aA5D2+rOc5KIm/GCtfBS5Ud/1KpEaEuW67GT7c3WBNi4zlilP0PwfORwc68QeX2J7N
         U0pwY5W67VwzAA45YggRGvrhiPnMK0ue70ZiAdoWFBSzjA615dwGKJYmx7fpCPHSvpeP
         IyTvdK5kax8TVEhSy+EfGrjzCkOBWpnRfR4rc5ufqPvz2YFlxPFbcCRrKphLpOC2P1TH
         GIqWWf5WOknwOebs0XXPYY4yfmKJUxJs5gCegYqLJWrPvNR/eiYkyj6B26d5v4Dm9dm9
         HMab8Fq1HrJ9LeFJurzcgHKl1b3rfF/NKEUmmBr5lQsLfmVLt+iHLkZ4xqgqmY7jthPS
         3EIA==
X-Gm-Message-State: AOAM530w4y3Cg/FGQIXM4ZaNBtGBy0pSBZ38wwe6twiih+ADkw41/gYm
        jLrm3q2taACl07M0aOtFgTcNjWgQCYjcbAcpAtSb3HgH
X-Google-Smtp-Source: ABdhPJzFY0P7znOYB4EHyS9foM/7tCoE1+wuiI+/nlJW748ZFR/vltXu4KvuoaI0txiJAr/a/BfJj7ECs9vi9Q6TTzk=
X-Received: by 2002:a9f:37ef:0:b0:33c:b32a:8361 with SMTP id
 q102-20020a9f37ef000000b0033cb32a8361mr11025894uaq.34.1646176280372; Tue, 01
 Mar 2022 15:11:20 -0800 (PST)
MIME-Version: 1.0
References: <20220301110006.4033351-1-mmakassikis@freebox.fr> <20220301110006.4033351-2-mmakassikis@freebox.fr>
In-Reply-To: <20220301110006.4033351-2-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 2 Mar 2022 08:11:09 +0900
Message-ID: <CANFS6bbsTQ9fBhGhdr=BZYc5iGtNgZWwK2gV9Rf9JhMCu_q1rA@mail.gmail.com>
Subject: Re: [PATCH 2/4] ksmbd-tools: Fix memory leak in lsarpc_lookup_names3_invoke
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

2022=EB=85=84 3=EC=9B=94 1=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 10:58, M=
arios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> If usm_lookup_user() fails, the "ni" struct is leaked.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  mountd/rpc_lsarpc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mountd/rpc_lsarpc.c b/mountd/rpc_lsarpc.c
> index cc99a147b239..b9088950c46e 100644
> --- a/mountd/rpc_lsarpc.c
> +++ b/mountd/rpc_lsarpc.c
> @@ -357,8 +357,10 @@ static int lsarpc_lookup_names3_invoke(struct ksmbd_=
rpc_pipe *pipe)
>                 }
>
>                 ni->user =3D usm_lookup_user(name);
> -               if (!ni->user)
> +               if (!ni->user) {
> +                       free(ni);
>                         break;
> +               }
>                 pipe->entries =3D g_array_append_val(pipe->entries, ni);
>                 pipe->num_entries++;
>                 smb_init_domain_sid(&ni->sid);
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
