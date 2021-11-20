Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DD2C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Nov 2021 01:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhKTBMb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Nov 2021 20:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhKTBMa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 19 Nov 2021 20:12:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D80061B30;
        Sat, 20 Nov 2021 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637370568;
        bh=kJvDKwVsecZSZFCI1WaWAgRzPjk+pZ/KYYb2X6zEPtQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=QujDWoF9/Tpw8upwfM8D028xOPa5jf1h/b3Ij6SwPA+377CipbcDqNhrj097w0w3q
         MGMV6dxvnsDvE+ZcXW3zmte+VPg1nb6WNY134tVp9jo4Ditoe0Ng15eI0v0wxMZf6S
         4hkI/QpsdJq8lvRWmXq+YHXFcGgmbRngD+ZYlQTxW44+gWM7mWRhjmj+TooHlRN0Jx
         PFvcLhxCQKkHzse5X3GqDLUafMI4peHkF6PkSbtIICYdf30tvvqgjw8/XyH+RhKOlc
         VNd8sKt22lI2EMw4xHBDbUUa5TH64hfequnPuYqevNA2l5QDErO+m80L8vxJqRWuCq
         0i0p21AUZkmKg==
Received: by mail-ot1-f43.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so19293675otj.7;
        Fri, 19 Nov 2021 17:09:28 -0800 (PST)
X-Gm-Message-State: AOAM5323FWaHDuGNBi93zBLNS0r7aOdHp2t8/lFsIrm+54v/43wBefKD
        K+AFAdpAceU86pXOSm2F8CFkx3yoezgc9XiVL74=
X-Google-Smtp-Source: ABdhPJwUbt4cjCIb3q7JNHQ5fGe0oM0aTtabh4KqjDS8VRDFBcpxTPvD707PBHyD2C/ZwLHjsZdfbTdfRhVG4rx+gVk=
X-Received: by 2002:a9d:12b4:: with SMTP id g49mr5186525otg.232.1637370567459;
 Fri, 19 Nov 2021 17:09:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:4448:0:0:0:0:0 with HTTP; Fri, 19 Nov 2021 17:09:26
 -0800 (PST)
In-Reply-To: <20211119211214.2038038-1-carnil@debian.org>
References: <20211119211214.2038038-1-carnil@debian.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 20 Nov 2021 10:09:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8VdrCNuO_dt+A4x1QKeoV1wR2XzK_zFVCe6ENkQ15xsg@mail.gmail.com>
Message-ID: <CAKYAXd8VdrCNuO_dt+A4x1QKeoV1wR2XzK_zFVCe6ENkQ15xsg@mail.gmail.com>
Subject: Re: [PATCH] docs: filesystem: cifs: ksmbd: Fix small layout issues
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-20 6:12 GMT+09:00, Salvatore Bonaccorso <carnil@debian.org>:
> In some senteces there were missing spaces between words.
>
> Fix wording in item to show which prints are enabled and add a space
> beween the cat command and its argument.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Steve French <sfrench@samba.org>
> CC: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
