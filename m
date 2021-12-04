Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B96C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Dec 2021 10:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345218AbhLDKdh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Dec 2021 05:33:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51482 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbhLDKdh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Dec 2021 05:33:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0811760BBA
        for <linux-cifs@vger.kernel.org>; Sat,  4 Dec 2021 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3AEC341C4
        for <linux-cifs@vger.kernel.org>; Sat,  4 Dec 2021 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638613811;
        bh=ci+L3IWEarwL/gRWf1WJ9+a9BViN5WpEGo+APQ6XkY8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ltj93G9PGOrrtjFj7Bv+ijy/w85l6FDfJaHz4G5v/1mS50Gy4xl8Dr0J6+OpmAFdj
         Djy7aZkYNdT8lkZJWfV8O2isNGr2lfxZrg2sJMwT5j0Qqam9DyP5D/FGNwYIlWNlOT
         rjx/VHy4Q/x9tpZ93aHah9kf9M5YOpv1mVbPZAhyijqmeePNtu5mEpgIvL63/GEX5o
         GUF6p0piuUXvPMyI5bNHh7lPtyy4yMNrr4Gy9bloF4I4m4JPEiT86m2KE2DCi/sc6l
         C+oIqDELoyKm5SgmUn269r4AUAPLTEXkGts9YB4dS/A3O4LNZIHgMnKtfM5Rix4QD0
         DFABhU/WElrrA==
Received: by mail-ot1-f46.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso6796923otj.11
        for <linux-cifs@vger.kernel.org>; Sat, 04 Dec 2021 02:30:11 -0800 (PST)
X-Gm-Message-State: AOAM530ZO/ROVRE9t2PmEucsV9nsx7cjBwt+HPkm9MkH1LIR3BBcT8VH
        26SuDZVEb4yT8LI4/2YBySPJtoJgUETrEGc0SHA=
X-Google-Smtp-Source: ABdhPJz9Jq5uVhqiq+D5UnayW2drS9OMMctbHtvhy/fMalBnRo+cxSNu4ugvFfmuqVsghVLx4Y4CJtO73OP9JquR3EU=
X-Received: by 2002:a9d:12b4:: with SMTP id g49mr20618171otg.232.1638613810631;
 Sat, 04 Dec 2021 02:30:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Sat, 4 Dec 2021 02:30:10 -0800 (PST)
In-Reply-To: <20211201204118.3617544-1-mmakassikis@freebox.fr>
References: <20211201204118.3617544-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 4 Dec 2021 19:30:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-erXQGuqZ3Vq=993wg+km-QsDHvU_gy8gRAucGzVqM=w@mail.gmail.com>
Message-ID: <CAKYAXd-erXQGuqZ3Vq=993wg+km-QsDHvU_gy8gRAucGzVqM=w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove unused parameter from smb2_get_name()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-02 5:41 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> The 'share' parameter is no longer used by smb2_get_name() since
> commit 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of
> share access").
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
