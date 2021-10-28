Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2FEC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 22:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442DC610E5
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 22:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhJ1WoQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Oct 2021 18:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhJ1WoQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Oct 2021 18:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B8560E8F
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 22:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635460909;
        bh=ZMwav7MCoqrBO+/gIXvwEP9Z8ECWbX62BdYT6UfIkzE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=G8BapWL78cKAzOMjjUMXmvJHu9pXiDz4Y2QN+snFqi6PrfuYO8iB/pwinBcMzH1Bz
         F3+d5NHEOB4B+cpqXOAIW7NbfRK3i+FFmcV1K8RfMZPUWubdGSccydaYJi0Rfut7mL
         n65gRalZ+nHcHSkAdXM6mrGjyJyATwLgdjgXA1+xPq5Rv6Hl1JL83nd+j8Ex8ZqjJ6
         rAe6QERKIot5YJdQrf7NfFIFKgd5xbUDNeX0LMT0ZWfzbi6jzKWyKiNFEWjCu4heNq
         nuOBqDgMNJbzGgl0xW7D6awZS7DcHK89zTam8kNBalhdzj/ufjmdAsPD5strVf6b9Y
         +GR3bnIz7OJJw==
Received: by mail-ot1-f45.google.com with SMTP id 107-20020a9d0a74000000b00553bfb53348so10884111otg.0
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 15:41:48 -0700 (PDT)
X-Gm-Message-State: AOAM533sXAsPjaDtifGl2d6qUYs7C5f+ehnE5xn20Rm5EyT/CJljWsL7
        84gW5WSCkBp6OhFkXkFrLsFzrZpKyRbtyp07+EA=
X-Google-Smtp-Source: ABdhPJw1kod9RfW+Vf5ngwjN1zZEQKL6rd+UlZPxT21C6vwGcj06uC/227osVFz/AQRdX698z7n+PGFWHmA0yaBPUhc=
X-Received: by 2002:a05:6830:25c2:: with SMTP id d2mr5879237otu.116.1635460908336;
 Thu, 28 Oct 2021 15:41:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 28 Oct 2021 15:41:47
 -0700 (PDT)
In-Reply-To: <20211028190125.391374-1-mmakassikis@freebox.fr>
References: <20211028190125.391374-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 29 Oct 2021 07:41:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-MeXyPu-ONTw115S+AbqJxrV8RZBW1H=isKEyCS5xVtg@mail.gmail.com>
Message-ID: <CAKYAXd-MeXyPu-ONTw115S+AbqJxrV8RZBW1H=isKEyCS5xVtg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix buffer length check in fsctl_validate_negotiate_info()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-29 4:01 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> The validate_negotiate_info_req struct definition includes an extra
> field to access the data coming after the header. This causes the check
> in fsctl_validate_negotiate_info() to count the first element of the
> array twice. This in turn makes some valid requests fail, depending on
> whether they include padding or not.
>
> Fixes: f7db8fd03a4b ("ksmbd: add validation in smb2_ioctl")
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
