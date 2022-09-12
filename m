Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E20EECAAD5
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 10:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiILKVA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 06:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiILKU7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 06:20:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB5918E04
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 03:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E322601B5
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 10:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9310C433D6
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 10:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662978055;
        bh=9uSyWP/O7LuUwPnWtxbeIYzuRbjjy9UvpU3A6QVH4FA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=aOdvn6gujbUMu5RO7yU8Y4JWBGFSRmEH4lmFqQLZ+9I/XIwHk0QGnhepaenKv4XSM
         RnfcQAg/xRjObCfgv6ikcGOVGo8DPg65Y08GZTFb9zYSrQMxwCx1Mx0Cy4ESYQ+pV9
         IcCpli3FyxToTCuT48hrOIGcjVPEZvQqt1Jw7IpPU9vgAKgcwYedx9mhJRiHqO1hLL
         kGpcNXb3k9EBw5SXu8mejpY7sYrhSkNuCcvzeoxD+/usMCy6C7WVdAJUCKpry3RwdV
         q/F+Up56XYlUXAeUrSD7nnyuqzPWBpO3WE2ipGf6YJ0ibEMeZxoMFalt0V9ynip5qh
         1fZ5yJ0QeOyFg==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1278a61bd57so22051686fac.7
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 03:20:55 -0700 (PDT)
X-Gm-Message-State: ACgBeo0nii7Ax0BDa0y7w3wW2XZ3egaQk+BtmIAgPMCbNtAPrWpHHsAb
        yeH5Fu6mW+wnhxl7FKkyRYPcxQyF6+ZP8nR1EvA=
X-Google-Smtp-Source: AA6agR5zlMBU+KAW7dZioMkZ3SQm/kIq+NF37GytbU5IHG3EgofIE8waF4cHNRUF/8qiV/8TOypykDCzgttdJXuJ7TI=
X-Received: by 2002:a05:6870:f69d:b0:10d:81ea:3540 with SMTP id
 el29-20020a056870f69d00b0010d81ea3540mr11860823oab.257.1662978054824; Mon, 12
 Sep 2022 03:20:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 12 Sep 2022 03:20:54
 -0700 (PDT)
In-Reply-To: <20220911205729.299358-1-atteh.mailbox@gmail.com>
References: <20220911205729.299358-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 12 Sep 2022 19:20:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ondWwEuHhVZnVp0dd6N5ZZzw=2EJXSicEYSjwdBB46A@mail.gmail.com>
Message-ID: <CAKYAXd_ondWwEuHhVZnVp0dd6N5ZZzw=2EJXSicEYSjwdBB46A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: casefold utf-8 share names and fix ascii
 lowercase conversion
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-12 5:57 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
Hi Atte,

[snip]
> +static char *casefold_sharename(struct unicode_map *um, const char *name=
)
> +{
> +	char *cf_name;
> +	int cf_len;
> +
> +	cf_name =3D kzalloc(KSMBD_REQ_MAX_SHARE_NAME, GFP_KERNEL);
> +	if (!cf_name)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (IS_ENABLED(CONFIG_UNICODE)) {
> +		const struct qstr q_name =3D {.name =3D name, .len =3D strlen(name)};
> +
> +		if (!um)
> +			goto out_ascii;
Minor nit, Wouldn't it be simpler to change something like the one below?

+	if (IS_ENABLED(CONFIG_UNICODE) && um) {

Thanks!
> +
> +		cf_len =3D utf8_casefold(um, &q_name, cf_name,
> +				       KSMBD_REQ_MAX_SHARE_NAME);
> +		if (cf_len < 0)
> +			goto out_ascii;
> +
> +		return cf_name;
> +	}
> +
> +out_ascii:
> +	cf_len =3D strscpy(cf_name, name, KSMBD_REQ_MAX_SHARE_NAME);
> +	if (cf_len < 0)
> +		return ERR_PTR(-E2BIG);
> +
> +	for (; *cf_name; ++cf_name)
> +		*cf_name =3D isascii(*cf_name) ? tolower(*cf_name) : *cf_name;
> +	return cf_name - cf_len;
> +}
> +
