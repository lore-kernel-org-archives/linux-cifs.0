Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F37C6FD1D
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 14:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbjDDOKx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbjDDOKv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Apr 2023 10:10:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8841FED
        for <linux-cifs@vger.kernel.org>; Tue,  4 Apr 2023 07:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08513634B2
        for <linux-cifs@vger.kernel.org>; Tue,  4 Apr 2023 14:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFBBC433A4
        for <linux-cifs@vger.kernel.org>; Tue,  4 Apr 2023 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680617449;
        bh=yYt0PcX2CNYAzSHaj+qWV3gUrZ6UHJPGAiomppQNRrc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=E6gEXTA/sRNG1ZoW56u8LXtB4+VRRAz4WJ6GMpODyBL9XcT17WM0SwziOh1jdYt2i
         svZnypDumJxbJuZom+ud9nlbyJMJs8HXqQKodBx8Vu8t7dBh0mCC8OU3z8PndYl6Ik
         k9rskSs6Tf2jucsog2LhVmgaJAyzTW5H3S2fAsKaTC2NShWByDyMyJmvuxI/UH5ywA
         izVFsZfDwwi65l0YjQG5Fv9+ug0lgWwELVho30nP5w5eMkbBe6AAcJLNS2OxDLc4T+
         Wv/NB0FiXD+mMDPDa5eGJ5rKEar3sjQq46pcZmKUOSTKgU+osKMWSoYrrGHVKpWvpS
         iDh+uC8Fia2iA==
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-17683b570b8so34631247fac.13
        for <linux-cifs@vger.kernel.org>; Tue, 04 Apr 2023 07:10:49 -0700 (PDT)
X-Gm-Message-State: AAQBX9cg7f+Nd8D8LuQiL0rDSyeYMWg45UN6Gu03vVoPuaXR1DDaK4Yn
        mpPuI759muLUvMUKEWJK6YT0gxM4lwqp0YUnn4Y=
X-Google-Smtp-Source: AKy350aHH7m1rR8Fcm1UUlZ+e3hehpn2HjvpK/x3v3MxGTJgnyfBd8Q7asOvcd/bMgZ6YTFJj8uExH8zgxh5bgYGTP8=
X-Received: by 2002:a05:6870:508:b0:17b:7376:8c82 with SMTP id
 j8-20020a056870050800b0017b73768c82mr1368138oao.1.1680617448491; Tue, 04 Apr
 2023 07:10:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:744d:0:b0:4c8:b94d:7a80 with HTTP; Tue, 4 Apr 2023
 07:10:48 -0700 (PDT)
In-Reply-To: <20230403224748.27323-1-ddiss@suse.de>
References: <20230403224748.27323-1-ddiss@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 4 Apr 2023 23:10:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_pCtvayZj4FoEM1S_BH8g2U3Nf=4_8RfvZ7fLN3eY9qg@mail.gmail.com>
Message-ID: <CAKYAXd_pCtvayZj4FoEM1S_BH8g2U3Nf=4_8RfvZ7fLN3eY9qg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: avoid duplicate negotiate ctx offset increments
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-04-04 7:47 GMT+09:00, David Disseldorp <ddiss@suse.de>:
> Both pneg_ctxt and ctxt_size change in unison, with each adding the
> length of the previously added context, rounded up to an eight byte
> boundary.
> Drop pneg_ctxt increments and instead use the ctxt_size offset when
> passing output pointers to per-context helper functions. This slightly
> simplifies offset tracking and shaves off a few text bytes.
> Before (x86-64 gcc 7.5):
>    text    data     bss     dec     hex filename
>  213234    8677     672  222583   36577 ksmbd.ko
>
> After:
>    text    data     bss     dec     hex filename
>  213218    8677     672  222567   36567 ksmbd.ko
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

> ---
> Note: this applies atop my previous assemble_neg_contexts cleanup
>   ksmbd: set NegotiateContextCount once instead of every inc
Okay:) Thanks for your patch!
