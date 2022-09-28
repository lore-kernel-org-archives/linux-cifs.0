Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B2BC04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 13:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiI1N3D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiI1N3C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 09:29:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C933AA1D38
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 06:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8665AB82057
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 13:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335ADC433D6
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664371739;
        bh=MevNP3zrW9j44pCtDZE0vlhDglcFk4tMvWYl8VzamX8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jNuN2QF9Su29TBgzewX8NG6jx6UHIFdr1+tEtJUlWvCUh6iR2VTo98RfqMK4pZU+Q
         y3iovhNGfB5ZprpSNrUOg9zw7KpnJXljVLScNdCHZyH7ot11Nrdm99tbGm97i/5gxF
         zfZu6z3ujylphOSQ6r9qL8LW7Cr1tnL4lxOmFYqA/ha/QxXVMT+uYDuZUaJnZORwym
         aGLWcAG/UJ560vmiaMSP0psAWK6Yaig2i3ItqyE4aQ3UJV7Ixo7omjkagI9b/FbsIQ
         U4gZ0Kuiw719XUD7DMEZoa75g9LOx/wm3ClXYPNKfs1rUBcsxCkSbw6RY9x7H8mjf5
         2B/7m4SAeF+BA==
Received: by mail-oi1-f172.google.com with SMTP id m130so15363563oif.6
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 06:28:59 -0700 (PDT)
X-Gm-Message-State: ACrzQf0IBmXN+CpOo9FGIODBLJDoeC4kfNqdwTGkO3IGUhWxAGwaRstB
        9vweMtMaLEUs6FfwzPySK6+/PPyN3IG8J0Dr9Go=
X-Google-Smtp-Source: AMsMyM4frkabNR9eKPhg2pPUDmCmu44b0pbvEcOj8OutZ+lXJrx4TXZLAlPI8Nb4CAjeQbCUOE79ErY0rE/y4Jo5puI=
X-Received: by 2002:a05:6808:211d:b0:34f:e0fc:6e6e with SMTP id
 r29-20020a056808211d00b0034fe0fc6e6emr4497834oiw.8.1664371738359; Wed, 28 Sep
 2022 06:28:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 28 Sep 2022 06:28:57
 -0700 (PDT)
In-Reply-To: <20220927215721.328425-1-atteh.mailbox@gmail.com>
References: <20220927215721.328425-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 28 Sep 2022 22:28:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9WFFv=ZqV+Jp3S1+OruWPFZrc9WeC1OWSqUYiOtYeZHg@mail.gmail.com>
Message-ID: <CAKYAXd9WFFv=ZqV+Jp3S1+OruWPFZrc9WeC1OWSqUYiOtYeZHg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: make utf-8 file name comparison work in __caseless_lookup()
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-28 6:57 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> Case-insensitive file name lookups with __caseless_lookup() use
> strncasecmp() for file name comparison. strncasecmp() assumes an
> ISO8859-1-compatible encoding, which is not the case here as UTF-8
> is always used. As such, use of strncasecmp() here produces correct
> results only if both strings use characters in the ASCII range only.
> Fix this by using utf8_strncasecmp() if CONFIG_UNICODE is set. On
> failure or if CONFIG_UNICODE is not set, fallback to strncasecmp().
> Also, as we are adding an include for `linux/unicode.h', include it
> in `fs/ksmbd/connection.h' as well since it should be explicit there.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your work!
