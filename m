Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF4CC04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 00:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiI2AHG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 20:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiI2AHE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 20:07:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ACD1166EA
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 17:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 907D3B80D8E
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 00:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4094AC433D6
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 00:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664410021;
        bh=acvG0u70mGfaa4YZbwFXmogcRislV3e0n4Mqqnwh2EY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hGIRm9Rye20sg+nexbrtqAEFRavMqkXsv/2RZnCJqCQPwKVcgXA+UL+7GeQIxWuDx
         0AYAfYXUg7kab8Alzk2szdfQ5weuJw9y2pqqLQJhDp5IWngvdjBN10GQHSYlzk1VbI
         8gdxcNYFSzR+zptRHdarBbEXPskVG555KbzKaWiemL2yITcq6sf/5oH+fj4mlQ3YDf
         NhTGEPnVnl1qePa9k/hKo429vRgQLotaKZxj3JWU0hYQqp0LSgLueLsUYNJV8v9Z3a
         WfzpANYvkJsNG+286ElTdrQ0NzEUnVh2L6mu2IigrGRm736n4qzpFAx8dj3qHi7SnD
         41tw8daZ6BIOA==
Received: by mail-oi1-f171.google.com with SMTP id l5so4921239oif.7
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 17:07:01 -0700 (PDT)
X-Gm-Message-State: ACrzQf2sMI+dOLIEbthTJ7+ggEgcLPg7V1HA6N2fqAgynX9Mm28UP9NZ
        v2srOAjaGRD0gRRolBqvXLIQTy6OJlp/fXqtfX0=
X-Google-Smtp-Source: AMsMyM6gFN7XDr9cjS34n7fP/FT/IM/SuCkkmtSu5Paj+I/mM7WQlZrD4F1RaCJQ8SkuNITPlT0dev687BgzzYAw5aQ=
X-Received: by 2002:a05:6808:211d:b0:34f:e0fc:6e6e with SMTP id
 r29-20020a056808211d00b0034fe0fc6e6emr5841615oiw.8.1664410020419; Wed, 28 Sep
 2022 17:07:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 28 Sep 2022 17:06:59
 -0700 (PDT)
In-Reply-To: <20220928184259.75500-1-atteh.mailbox@gmail.com>
References: <20220928184259.75500-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 29 Sep 2022 09:06:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-4ksLPmOkc9u3okpMHJ=HofAxCd7cXo4KnptQyg=dJgg@mail.gmail.com>
Message-ID: <CAKYAXd-4ksLPmOkc9u3okpMHJ=HofAxCd7cXo4KnptQyg=dJgg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ksmbd: validate share name from share config response
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-29 3:42 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> Share config response may contain the share name without casefolding as
> it is known to the user space daemon. When it is present, compare it to
> the share name the share config request was made with. If they differ,
> casefold it and compare again. If they still differ, we have a share
> config which is incompatible with the way we do share config caching.
> Currently, this is the case if CONFIG_UNICODE is not set, the share
> name contains non-ASCII characters, and those non-ASCII characters do
> not match those in the share name known to user space. In other words,
> when CONFIG_UNICODE is not set, UTF-8 share names now work but are only
> case-insensitive in the ASCII range.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your work!
