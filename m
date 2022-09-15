Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7E2ECAAD3
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 13:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIONb7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 09:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIONb6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 09:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0876E8A8
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 06:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498F2623D9
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 13:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04BAC4347C
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 13:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663248716;
        bh=svT3bFMkP3zxbP4CG8S6T9DpiBrqXAYWGcsRrlvA2bk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=KYIp7oMS7Irdd2vDHpEFdf2iZNLNBSCrGR/flx/yZs3gDVFoTOxGFqVNRLdGL6YoR
         6o/BFAvZ2dghWnXYOJRAMvuO8UeAlhhJb9dIm/t5jUDmHSiFtytZ7i9XnKNq9BWYmk
         5KOWEiKYd0NNEPd8oezIpQ/xXIsToybxnW7yuUT3W6PGI7TQMzk/YQF/uEcGoK6fth
         o/aIc5lByWF9V5kMWRaYJddQ59KoZPS/UsbKD45JcPraNXBuO7v84XbKf/bLzXhqkC
         XqMUadRsAPIoO7YeSlthyFR83gR5uWRM3wqVRrjkfAIM5P7QcWmVV9hdARzXjuVLqC
         d9XdteZSeqOLQ==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-127dca21a7dso47443937fac.12
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 06:31:56 -0700 (PDT)
X-Gm-Message-State: ACgBeo1TX5E1NjCrPLVEkfnybrxeM+k9+4CBgWmqXjj8nQa9xhakM1At
        L7vc1aOa+kAauMX8qDX305mxKN9xzBYi3d3tc3M=
X-Google-Smtp-Source: AA6agR6kpdeHLFKC5RZGrUqRf9iDKZw8Y6hQ7O6nj/fU+drDLZu8MJWQH0N0LT/q8NvJiRW/wDhE8WDFpx0hawG3er4=
X-Received: by 2002:a05:6870:b290:b0:127:4089:227a with SMTP id
 c16-20020a056870b29000b001274089227amr5526906oao.8.1663248715815; Thu, 15 Sep
 2022 06:31:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 15 Sep 2022 06:31:55
 -0700 (PDT)
In-Reply-To: <20220911215542.104935-1-atteh.mailbox@gmail.com>
References: <20220911215542.104935-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 15 Sep 2022 22:31:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9EWSH7sRTbCfZWGvzSQDeEg1KcmA81sWXqerYWUN2kFw@mail.gmail.com>
Message-ID: <CAKYAXd9EWSH7sRTbCfZWGvzSQDeEg1KcmA81sWXqerYWUN2kFw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ksmbd: casefold utf-8 share names and fix ascii
 lowercase conversion
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-12 6:55 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> strtolower() corrupts all UTF-8 share names that have a byte in the C0
> (=C3=80 ISO8859-1) to DE (=C3=9E ISO8859-1) range, since the non-ASCII pa=
rt of
> ISO8859-1 is incompatible with UTF-8. Prevent this by checking that a
> byte is in the ASCII range with isascii(), before the conversion to
> lowercase with tolower(). Properly handle case-insensitivity of UTF-8
> share names by casefolding them, but fallback to ASCII lowercase
> conversion on failure or if CONFIG_UNICODE is not set. Refactor to move
> the share name casefolding immediately after the share name extraction.
> Also, make the associated constness corrections.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
> ---
>  v2:
>    - added missing kfree() to -E2BIG error path of casefold_sharename()
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
