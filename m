Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95DBC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 13:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbiEDNW4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 09:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiEDNWz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 09:22:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAF82DB
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 06:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25A5BB825A3
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 13:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C914DC385A5
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 13:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651670356;
        bh=YHdExPxepyCp/QedZ30lxjZJF0NkG0OqFMr0q1a2g+g=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=XzirYjHB2DmSasbRl/BRqBhNy5qB4JavLuggINvd73kgA8Q6iCl1b16D0GxujjO6d
         7ChiBDNgNRIyS95YR2841d+jcTtxWlbVtbNosVJpZ0EL9DocKIJGslzw9AJJgnUH8i
         MjUIU0+A2iUKGuj7PtjjVpRgaH2iQkL/n4SL8yCFwqvnFCpZYRt60dfjU0IlXrj2WR
         uNskmH4fnHKCYyUtCLa0FP3Q3LUCfL0F/zTvm95KU5MOuOSa/Xmm2XQWI71/VK8t67
         sMEeZ+pgyPaK0VMCmOBzduITJOtVQCJh0LA6ken44S0eYolyNjROxrP98h2HsbZazI
         m+FB83/PZtDew==
Received: by mail-wr1-f50.google.com with SMTP id c11so1990631wrn.8
        for <linux-cifs@vger.kernel.org>; Wed, 04 May 2022 06:19:16 -0700 (PDT)
X-Gm-Message-State: AOAM532GwHaZUTYBaJIaEgbCnkybqBELeI6gDZ5fq+7dAx54HEwJAnXa
        OJz7++rAllx5xE/UiN9ToBjebZ3NeQch4fWTd3g=
X-Google-Smtp-Source: ABdhPJyNRTo9rAE0mD/o5V6dVwaH5XdKdJwVTjBP/5zWqZ22nsE85U43yzJgqYRkR43SvJjTMrfQ3pl8Y1GLU3cTXho=
X-Received: by 2002:a5d:584a:0:b0:20c:5bad:11c1 with SMTP id
 i10-20020a5d584a000000b0020c5bad11c1mr12791090wrf.62.1651670355000; Wed, 04
 May 2022 06:19:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4571:0:0:0:0:0 with HTTP; Wed, 4 May 2022 06:19:14 -0700 (PDT)
In-Reply-To: <20220503231323.740251-1-mmakassikis@freebox.fr>
References: <20220503231323.740251-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 4 May 2022 22:19:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8ciX9Jx_i8pKmfnsGeR+Htsg0YNqDJztMUG_Equ32_nQ@mail.gmail.com>
Message-ID: <CAKYAXd8ciX9Jx_i8pKmfnsGeR+Htsg0YNqDJztMUG_Equ32_nQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate length in smb2_write()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-04 8:13 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> The SMB2 Write packet contains data that is to be written
> to a file or to a pipe. Depending on the client, there may
> be padding between the header and the data field.
> Currently, the length is validated only in the case padding
> is present.
>
> Since the DataOffset field always points to the beginning
> of the data, there is no need to have a special case for
> padding. By removing this, the length is validated in both
> cases.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

> ---
>  smb2pdu.c | 49 +++++++++++++++++++------------------------------
>  1 file changed, 19 insertions(+), 30 deletions(-)
>
> diff --git a/smb2pdu.c b/smb2pdu.c
Can you resend the patch after making it on linux kernel source ?

Thanks!
