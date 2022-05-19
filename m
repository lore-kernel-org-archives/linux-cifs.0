Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11B8C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 19 May 2022 23:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245673AbiESXG3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 May 2022 19:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245672AbiESXGW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 May 2022 19:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD60F22BE2
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 16:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C7A16181A
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 23:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F589C385B8
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 23:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653001577;
        bh=oTBS4KrODMGY1py9GtHvpnSUmTFgrYs/LvftQswIdh0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=uY1/y9L1HAFHflEBu78WRouADtmDD3fbYIH3ZzCFaBuW3KDuoNpHEOtFvrofVfyqI
         H8ivYSMyJbAJTvBDTnogQDKud+drwqjbTQ8D8ZL/ejfxW0Z8netzakGoB4BKVXuS06
         mAx25aY+MS0glG/W/wO47J4bFys/pn8CWgs3ckjGeuCRqnBN2qq6TUuFJF6dVV7bY1
         53rMpwdoN0dQG+FpckLKarwxwLccEnFwF2K4liI7iGtMB+02qGtoPUErFzI9I7FUqo
         ue3gcrZ5kL6004UYfNT55jdKBnF1A6Tgcbl3sZRLXaeJHJiaV5l38+CymAWWHzstJT
         wh5FX2766ayBw==
Received: by mail-wm1-f43.google.com with SMTP id k26so3694052wms.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 16:06:17 -0700 (PDT)
X-Gm-Message-State: AOAM532iJtvf6KTZjCHauhjIo4zwnVrQOJqfBimVqY4hRH+opuvJAllZ
        1GQfI8we9GK4izng0UbXRdR5L1B6CtVnoSh4Ig0=
X-Google-Smtp-Source: ABdhPJzv3oYnrewbDf6j1fWYhLKkK+CknPJCAxF0lNXeOLqnpeqJBV2+oJqszmvTUsb+CdKxp2FWVjWntxncNGG+Oqs=
X-Received: by 2002:a05:600c:3b11:b0:394:57eb:c58b with SMTP id
 m17-20020a05600c3b1100b0039457ebc58bmr6175766wms.3.1653001575733; Thu, 19 May
 2022 16:06:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Thu, 19 May 2022 16:06:14
 -0700 (PDT)
In-Reply-To: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
References: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 20 May 2022 08:06:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
Message-ID: <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     Steve French <smfrench@gmail.com>
Cc:     Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-20 5:41 GMT+09:00, Steve French <smfrench@gmail.com>:
Hi Steve,
> Namjae and Hyeoncheol,
> Have you had any luck setting up virtual RDMA devices for testing ksmbd
> RDMA?
You seem to be asking about soft-ROCE(or soft-iWARP). Hyunchul had
been testing RDMA
 of ksmbd with it before.
Hyunchul, please explain how to set-up it.

Thanks!
>
> (similar to "/usr/sbin/rdma link add siw0 type siw netdev etho" then
> mount with "rdma" mount option)
>
>
>
> --
> Thanks,
>
> Steve
>
