Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C42AC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Dec 2021 10:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354971AbhLDKdD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Dec 2021 05:33:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50568 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbhLDKdD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Dec 2021 05:33:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C0AAB80B0D
        for <linux-cifs@vger.kernel.org>; Sat,  4 Dec 2021 10:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91EEC341C4
        for <linux-cifs@vger.kernel.org>; Sat,  4 Dec 2021 10:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638613774;
        bh=ms4/tADhZfNgFN9hRRn4jKXw1ch3rgh1nLg8a0R3bIg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=eUBuirFkFzhxE20KmU8hzbTrJJmsveHSUlkz5sUBcpjN7N4JrDiamaCcY3sWb3uHJ
         zIqWpt0pDZInb+bR6cW6AkVumzruJATJEUANflDLqTJ7lr+KFcpPUE5c0V+s8Y2JDK
         FQFeVAAW+k0PjVZ8m8hXQSIOoZQicemg+QExd5PNIUrhErSTDA8t3mPLtSHft9GDVT
         jvXbWMhYTy7r4mPfmOVkptVe6JfqghqZcS2OaUpd9h4iFv61xZTIY5YCykZ8UfqSbr
         oTyWMFAYfxnz42PqKgpxHrxwW4dOddKI8m3fYl+I4OU9G7wYHQpBA+TizAgIkhYhvK
         p/3F/6ETbtyRw==
Received: by mail-oi1-f176.google.com with SMTP id bf8so11083781oib.6
        for <linux-cifs@vger.kernel.org>; Sat, 04 Dec 2021 02:29:34 -0800 (PST)
X-Gm-Message-State: AOAM533yEkKeAIUoUhnURu+4xzioHDb2tkg+zK6oX573YGl+/pdjcMZX
        GfI51W9O7/waMNFZwBx6qSDLGxs5gvU58e8fJu4=
X-Google-Smtp-Source: ABdhPJwAsq9/LtuNOlBPvNENGQ4m4EuIILKcVdBY7mzlOPNU8IoR+Gg5Jic1xud4Kwaqs2z1DhQpG/0Xt67IeaP/vS0=
X-Received: by 2002:aca:eb0b:: with SMTP id j11mr14299831oih.51.1638613774068;
 Sat, 04 Dec 2021 02:29:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Sat, 4 Dec 2021 02:29:33 -0800 (PST)
In-Reply-To: <20211201204049.3617310-1-mmakassikis@freebox.fr>
References: <20211201204049.3617310-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 4 Dec 2021 19:29:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-PCd-UecfaN+ci6-K-uuMfjPkwwq3WDvsTPHjaGfWZgg@mail.gmail.com>
Message-ID: <CAKYAXd-PCd-UecfaN+ci6-K-uuMfjPkwwq3WDvsTPHjaGfWZgg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove unused fields from ksmbd_file struct definition
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-02 5:40 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> These fields are remnants of the not upstreamed SMB1 code.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
