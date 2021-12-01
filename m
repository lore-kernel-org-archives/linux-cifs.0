Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C22BC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Dec 2021 00:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345762AbhLAAf7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 19:35:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45174 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345744AbhLAAf7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Nov 2021 19:35:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D99DFCE1D19;
        Wed,  1 Dec 2021 00:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6244C53FCB;
        Wed,  1 Dec 2021 00:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638318755;
        bh=o/vguVdCIFrn8XRMYWINw9V41uwBDFShZeJRxnqWwho=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=lAA5qm4h4CeqHj7icP81QtUK9i8XTP7N1jKrKdgs7Pietyn+Gpb4BLyGFfH+QZ/lW
         3IENHjFLQayGdnN0/cTzM2xT2Lxh18YA6sFngAx11xcM86WY9+mVyO6mKyxFiXhckC
         1Vey1/8/59+fWf55QiJG2cGc/BVUIwUv3yf0HKYyyI0+GD1CkphpkFz4M8kp86D2aL
         NPEjpBSGRvFm4zTB8r8d75v9Z7oRd7kIb5u3IjEMK8f2I5UT6KKHgLNsfcpMl7VqY8
         UGyssa1hQvaHjAzslbzXJ4nBa0zJ9eUdy9oqAnwxby/wZDhkh1pIGpVIL2CMUttnRO
         0VZLd/7mq5KDA==
Received: by mail-oi1-f179.google.com with SMTP id u74so44842414oie.8;
        Tue, 30 Nov 2021 16:32:35 -0800 (PST)
X-Gm-Message-State: AOAM5312AJ3lKlRS1l9PyNvKk3VSWBQFM7p4G8cXccprwfke4GXlyQsx
        WLE6rgcefbppY7eV+VMMk67JWGoXjPbxdkM8FX0=
X-Google-Smtp-Source: ABdhPJxI1ik1dYJ6aPpTMBKWTgaM63xxSd+huBLdtmpJhNxeFVO031rRXXlqI3Ss5WQ1uJtWNwT1GPsfePUXXoFEcT0=
X-Received: by 2002:aca:eb0b:: with SMTP id j11mr2564526oih.51.1638318755138;
 Tue, 30 Nov 2021 16:32:35 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Tue, 30 Nov 2021 16:32:34
 -0800 (PST)
In-Reply-To: <20211130125047.GA24578@kili>
References: <20211130125047.GA24578@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 1 Dec 2021 09:32:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8MWZCft5s3tu2omjU__9J46sCXqO2rbph5Aqivzp3rUg@mail.gmail.com>
Message-ID: <CAKYAXd8MWZCft5s3tu2omjU__9J46sCXqO2rbph5Aqivzp3rUg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix error code in ndr_read_int32()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-30 21:50 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> This is a failure path and it should return -EINVAL instead of success.
> Otherwise it could result in the caller using uninitialized memory.
>
> Fixes: 303fff2b8c77 ("ksmbd: add validation for ndr read/write functions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
