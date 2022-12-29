Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0715C3DA79
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 22:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiL2WZW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 17:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiL2WZV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 17:25:21 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC28411454
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 14:25:19 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ay40so14086988wmb.2
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 14:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/BUywNuRuKtaBiuDVwlap88g7N9dmh2nIb3O/GpH7o=;
        b=SFv4z1aA8h6CJDgbCZqRnaN3afGrV8ybQOE2klIxpbMqRwLC0wLROzBATKcxX9jHgw
         ttvRgiCndXZMF2Ni7MbaMKCh7zFaqyOoaopeBtQ9gN8TG4L5Pr517FRSVWLI2o0oTRC0
         T2oHxDyV7tfPwP1lWEBIuoeXre2l+Vc1xrvxBYl+fyF+c3uDXTvAcTFwqQQFBosR9/rX
         /MmdL+34x9M6msp9U4Ozg/id7FtPrRX06qqJBrPGM0UwMICiYDmka8BuL1Ale1ij6tb9
         jhob0SPFWYKryUy3iQ3vW9/W6GLa4IZG89zp8+XnzjBTOdUNcDMFK92hfyv7FFX56NxT
         QgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/BUywNuRuKtaBiuDVwlap88g7N9dmh2nIb3O/GpH7o=;
        b=L4X3w7gDWeT9A0xA32QU6lmkHk6TirXfoEw8BePvf2dogIsMMhGQO31JMcVsypQWPw
         CMQ6KMkS7IX6Xyat0K1JeYUcwu35nL5P7xipBNJF+AYxe4cVivDQleZsShjWy2ee8N6q
         W5TA4otU4K14ErxwdbauMWwO+fLhqrxXdsmFa7Ki69eN7yCAsTchhKGJZ3Vh0K+sMKKY
         qUTZujDDnaJEoAKoE99cy1AyOdK0EH2tAuaeRyu7EsjVeB3QiUth8YDvTpHX0F8mll7C
         u5FMsR3lBvqf/jxTXE8u5uzFShTsNF8Pq6Dp8WMA9km4tEtchIoDsvj4vje8ewFLaXWE
         f9UA==
X-Gm-Message-State: AFqh2krisTDG6Xp397/GvMYZqtqwWbmo/4F1oQT3Ou0P4kpA45sKiHXs
        U8HOTfNGQqskKrNcUtIv/Pw=
X-Google-Smtp-Source: AMrXdXu75YraP4kOgH12DhrUvjRrzCJcHTDDVcV287ddrsBx/wvRi2YLZqpf9vWxzt46AiR/WuTJMw==
X-Received: by 2002:a05:600c:3592:b0:3d1:ebdf:d58b with SMTP id p18-20020a05600c359200b003d1ebdfd58bmr21309560wmq.5.1672352718188;
        Thu, 29 Dec 2022 14:25:18 -0800 (PST)
Received: from suse.localnet (host-79-56-217-20.retail.telecomitalia.it. [79.56.217.20])
        by smtp.gmail.com with ESMTPSA id m28-20020a05600c3b1c00b003d1e3b1624dsm33520668wms.2.2022.12.29.14.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 14:25:17 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Ira Weiny <ira.weiny@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH] cifs: Fix kmap_local_page() unmapping
Date:   Thu, 29 Dec 2022 23:25:16 +0100
Message-ID: <13173438.uLZWGnKmhe@suse>
In-Reply-To: <20221229-cifs-kmap-v1-1-c70d0e9a53eb@intel.com>
References: <20221229-cifs-kmap-v1-1-c70d0e9a53eb@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On gioved=EC 29 dicembre 2022 23:04:46 CET Ira Weiny wrote:
> kmap_local_page() requires kunmap_local() to unmap the mapping.  In
> addition memcpy_page() is provided to perform this common memcpy
> pattern.
>=20
> Replace the kmap_local_page() and broken kunmap() with memcpy_page()
>=20
> Fixes: d406d26745ab ("cifs: skip alloc when request has no pages")
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Steve French <sfrench@samba.org>
> Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/cifs/smb2ops.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index dc160de7a6de..0d7e9bcd9f34 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -4488,17 +4488,12 @@ smb3_init_transform_rq(struct TCP_Server_Info=20
*server,
> int num_rqst,
>=20
>  		/* copy pages form the old */
>  		for (j =3D 0; j < npages; j++) {
> -			char *dst, *src;
>  			unsigned int offset, len;
>=20
>  			rqst_page_get_length(new, j, &len, &offset);
>=20
> -			dst =3D kmap_local_page(new->rq_pages[j]) +=20
offset;
> -			src =3D kmap_local_page(old->rq_pages[j]) +=20
offset;
> -
> -			memcpy(dst, src, len);
> -			kunmap(new->rq_pages[j]);
> -			kunmap(old->rq_pages[j]);
> +			memcpy_page(new->rq_pages[j], offset,
> +				    old->rq_pages[j], offset, len);
>
=46WIW, it looks good to me...

Reviewed-by: Fabio M. De Francesco

Thanks,

=46abio
>  		}
>  	}
>=20
>=20
> ---
> base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
> change-id: 20221229-cifs-kmap-6700dabafcdf
>=20
> Best regards,
> --
> Ira Weiny <ira.weiny@intel.com>



