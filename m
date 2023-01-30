Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDD3C636CD
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Jan 2023 21:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjA3VQM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjA3VQK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Jan 2023 16:16:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249EF7EED;
        Mon, 30 Jan 2023 13:16:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F796126D;
        Mon, 30 Jan 2023 21:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D17DC433A0;
        Mon, 30 Jan 2023 21:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675113368;
        bh=2S03H7fD4naG7KTpUwIw+Yz2fSOiRObvNN6hiNwBCUo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=eQEbwFYLjjkeFFEzczkfxYAB4mEibjmLyLyPer5+LBm+C9t1HlzqQhIh8K2NL2VM1
         mfTW2sxlxwkYHo/v7Nhejy+Ra6KeReeyXMIozKyuw3ed8El9tCL/SxvRx2t5gySnhX
         MEQleXNcqVQBt1F4SJTVkk6dSAiizJeWlDjysdNe+6W9m9HnwRMRXxLYC0bITxyEeJ
         EUgMz9Z3S7a5ya7MuMZ0+n65T/BaPJZZcOLuquI2T9Oa+lEZY4T9jfHNUrjfVOYcfb
         YQU+pUHwLf7ZtdiaTeX1qH8OwwZUPFGqb4pt+lYTz+xMDitkgd9boPw9h4HB0vMCqt
         y2KorzwgsxZ0g==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-142b72a728fso16834536fac.9;
        Mon, 30 Jan 2023 13:16:08 -0800 (PST)
X-Gm-Message-State: AFqh2kqdwWFbIkhj6y//yjGLYwystEtO+IkaV2BakfewjsFb1+q7mQSI
        rMyOEveKGU0MadIt1CHRkEmC/wSv9yVm/truulM=
X-Google-Smtp-Source: AMrXdXtB53/qFM1iiGo26TtT4yGfxrKK/gWnHN/GArEN8iZgkj9mWvEbKXmACHZBBoGkDKU99Iyuy25sg/Gc7QGT+mE=
X-Received: by 2002:a05:6870:8c11:b0:15f:de79:36c7 with SMTP id
 ec17-20020a0568708c1100b0015fde7936c7mr2738367oab.215.1675113367173; Mon, 30
 Jan 2023 13:16:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a8a:355:0:b0:4a5:1048:434b with HTTP; Mon, 30 Jan 2023
 13:16:06 -0800 (PST)
In-Reply-To: <20230130092357.36730-1-colin.i.king@gmail.com>
References: <20230130092357.36730-1-colin.i.king@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 31 Jan 2023 06:16:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_tPpu-w7vuALcfDnBe4Fsu4hFUdbJ==xUqfFmNuaUVHw@mail.gmail.com>
Message-ID: <CAKYAXd_tPpu-w7vuALcfDnBe4Fsu4hFUdbJ==xUqfFmNuaUVHw@mail.gmail.com>
Subject: Re: [PATCH][next] ksmbd: Fix spelling mistake "excceed" -> "exceeded"
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-01-30 18:23 GMT+09:00, Colin Ian King <colin.i.king@gmail.com>:
> There is a spelling mistake in an error message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
