Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604B2C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Nov 2022 00:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiKPAVb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Nov 2022 19:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiKPAV1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Nov 2022 19:21:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4A22A726;
        Tue, 15 Nov 2022 16:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08BD60E65;
        Wed, 16 Nov 2022 00:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E42C433D6;
        Wed, 16 Nov 2022 00:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668558086;
        bh=hwUOc/FCJNlwMvzC8ps/UK4ePUya28SQYKY1V9Te5Ek=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=MOyQfLkgUboBUhoax1FFM3j8JxTYQqCIqrLPZHit1GbcD9tr+UUvOcnMfbJ5BKyC9
         tO+c04mcakviQC+8F5HZ0VV3g2ID9BjaLWOIP7v7yFUuBNcvb9BXMyb+AdgX6Wz6od
         BSFVgLrdtSUlHPcuQo3F6Lzto1IdFt1WSbUtvzZxIBC2wo/eEpN6jeKUoaaYvD3D3G
         PsgMVQ+XuPNJj+d4jLjoexPbVY0eNVGYzKsfaCbXjUkCjkXD7eIshMtbuehbyqDxzO
         yETkmF/5PoApznpM6ZHM/u634RfZZnSQQTlfA6NefZjkfvFIhXNW374Z0O6Ot4wuYB
         ML9FE+PKKqxCg==
Received: by mail-oi1-f180.google.com with SMTP id s206so16750514oie.3;
        Tue, 15 Nov 2022 16:21:26 -0800 (PST)
X-Gm-Message-State: ANoB5pkXM1AZVXSeRBvy84XG2V6NZjvjNJKwEydBZoQLq/DmYBTY4sgK
        sZcvbS0wFtjsuFe1y1S9hviZZnUbCGApeHv6mKY=
X-Google-Smtp-Source: AA0mqf4mdSSC3UAEYBUd+P0Z6luz95XKyNOxCm8IWo4hHdxZbcKdV3WWPlBD8NHhTuekkl7Ac6go5tjCouAf1VDaF70=
X-Received: by 2002:aca:b9c4:0:b0:34f:63a5:a654 with SMTP id
 j187-20020acab9c4000000b0034f63a5a654mr386110oif.257.1668558085274; Tue, 15
 Nov 2022 16:21:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6839:1a4e:0:0:0:0 with HTTP; Tue, 15 Nov 2022 16:21:24
 -0800 (PST)
In-Reply-To: <Y3OxronfaPYv9qGP@work>
References: <Y3OxronfaPYv9qGP@work>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 16 Nov 2022 09:21:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-evHBWbXbfa4tg9LEGVv6f=y9PBbDaBSySmsN0LuCCMQ@mail.gmail.com>
Message-ID: <CAKYAXd-evHBWbXbfa4tg9LEGVv6f=y9PBbDaBSySmsN0LuCCMQ@mail.gmail.com>
Subject: Re: [PATCH][next] ksmbd: replace one-element arrays with
 flexible-array members
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-11-16 0:35 GMT+09:00, Gustavo A. R. Silva <gustavoars@kernel.org>:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element arrays with flexible-array
> members in multiple structs in fs/ksmbd/smb_common.h and one in
> fs/ksmbd/smb2pdu.h.
>
> Important to mention is that doing a build before/after this patch results
> in no binary output differences.
>
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy() and help us make progress towards globally enabling
> -fstrict-flex-arrays=3 [1].
>
> Link: https://github.com/KSPP/linux/issues/242
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html
> [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
