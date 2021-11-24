Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DD0C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Nov 2021 00:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhKXAbW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:31:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239746AbhKXAbW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 23 Nov 2021 19:31:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573AB60240
        for <linux-cifs@vger.kernel.org>; Wed, 24 Nov 2021 00:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637713693;
        bh=2USpfCXgZhdtlWOxtsBJks70U8VVDTMSqwUUVzI2D6U=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Jor4tYsFlkIPILrvwxbPv2KQsSbzqsoLwNaQsATpFlwELgTRhVCbN+eqqbjvD9fmC
         /5sto+aoUDQwSha7j54OjSo27rK1T6/4nc9COWHZGrfxNQ5LQmRW6X7014LS+yf3rw
         O/lM4iFWGoHpgDc3gHhKA16Io0JC50UerWwhus4S8qS294u7VxDuVcoJn8Bo3oztmP
         LldBkWvaim0mbgH81jisC6IV5xZKpRZvK30cIMVcOy7IhRcJP/TKyBabNbbqTT0oGM
         fytpZqxvKlB/7oqRUpM3tdMHrOXwu6LQmQDRW/BuV17qTIGUus+eB16uGKiyt7lXTt
         9wvv7c2BjRXOw==
Received: by mail-ot1-f53.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso1565202otf.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Nov 2021 16:28:13 -0800 (PST)
X-Gm-Message-State: AOAM532vU1H1i5kLbGwnWA7v69ZXXqaKfL+j8D935QcRk74AW5A7dxbU
        55Iupm7uHY5Qs3EuhloaMFBIy0TEAJp1LkX20rY=
X-Google-Smtp-Source: ABdhPJxPL1mSSESu8C0mC4kJ4SEWkzXlaOK2GsbURGrFN1ZoXzzkCpA8PzJ5HdZLV8tzJtDmWYb16mhMA6DdBFnD460=
X-Received: by 2002:a9d:12b4:: with SMTP id g49mr8700332otg.232.1637713692713;
 Tue, 23 Nov 2021 16:28:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Tue, 23 Nov 2021 16:28:12
 -0800 (PST)
In-Reply-To: <20211123021013.32566-1-hyc.lee@gmail.com>
References: <20211123021013.32566-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 24 Nov 2021 09:28:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_FPQ8bZJQaFs=Oj3NLZ6wyzJHbd6E-ACqxydaQdiGP+A@mail.gmail.com>
Message-ID: <CAKYAXd_FPQ8bZJQaFs=Oj3NLZ6wyzJHbd6E-ACqxydaQdiGP+A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use oid registry functions to decode OIDs
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-23 11:10 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Use look_up_OID to decode OIDs rather than
> implementing functions.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
