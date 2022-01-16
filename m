Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F379EC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Jan 2022 12:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiAPMrS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Jan 2022 07:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiAPMrS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Jan 2022 07:47:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1D9C061574;
        Sun, 16 Jan 2022 04:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A85EB80D0D;
        Sun, 16 Jan 2022 12:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240F1C36AE9;
        Sun, 16 Jan 2022 12:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642337235;
        bh=gzmka/Na6RWNoQDABCe/KQMbbOHfVLh1iPS/yWVkd6k=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=dQNogFX6++VUeUBuV9XDdaq2wrd27Wc5zew398fPSzg7hwDcsYBbJE79WWkif18R5
         SWBbFoZDshGkhCCVqukKhKiY7sHovpQiLGurFwLWnlSk1nK2Vf/dtGRCAm7WAoCTKA
         u1dMbgJbMPWr/29tAakkn5cHt/v2QNdcFGI2mChiEsfF2TlZaQAYOzRNuSTHRM5F3o
         KBl5dTWz6FnP2i3fF1fu0tDe3ja7RaPFJogoJG1QmcspM3l5bgnz8ueRUZ3ft0wt56
         /nHtD3sR28VtL1WEO1y6fFnt3SdP/2jbCy7/g8aCJl705iPER9atSW1v6XLFiCnQLn
         BLx3QpyTDdJqA==
Received: by mail-yb1-f171.google.com with SMTP id p5so37613046ybd.13;
        Sun, 16 Jan 2022 04:47:15 -0800 (PST)
X-Gm-Message-State: AOAM5300GdciT8gxWLHHpU0vQGGB78lS+Y3uXemx+V8pqKYxIJB1fCyp
        mqeJS/7EA2t8XvwXwbAxApSndKj9l1YOBJ6Sx0k=
X-Google-Smtp-Source: ABdhPJwYkz0M6LP5oww/71SQm6s4Q2LjJ9rtygOlZF1tp53GG6GJkTnDoTSeGIAkgKhM769IqgXw+iVUcGaKdrLN9uo=
X-Received: by 2002:a5b:749:: with SMTP id s9mr6170947ybq.529.1642337234185;
 Sun, 16 Jan 2022 04:47:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Sun, 16 Jan 2022
 04:47:13 -0800 (PST)
In-Reply-To: <20220115114900.GB7552@kili>
References: <20220115114900.GB7552@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 16 Jan 2022 21:47:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9HBkFpYaOWJeVKVwLbqvykSSKNV0AYur_QaUjCTV00+Q@mail.gmail.com>
Message-ID: <CAKYAXd9HBkFpYaOWJeVKVwLbqvykSSKNV0AYur_QaUjCTV00+Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: uninitialized variable in create_socket()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-15 20:49 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> The "ksmbd_socket" variable is not initialized on this error path.
>
> Cc: stable@vger.kernel.org
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and
> tranport layers")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
