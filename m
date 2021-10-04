Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9F9C4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 00:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 440CC61362
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 00:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhJDAtJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Oct 2021 20:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhJDAtH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 3 Oct 2021 20:49:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 909A26124F
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 00:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633308439;
        bh=RV1XGy5CBakEQnglGMk3tyTvALMSk0wBuecQ1v9w6p8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=PiLH3XHpv+uvsbeZKkxEm9enNwlnwUfDbbVAU8YbiJI4DOkLUvbYcFHuHzqAG3TlE
         0oHPMyeCQ9fP27M8QeBUqmnnuGfeVX1+ZbyHTHoL5M0y0QNbtv8w8V0FapyKJ+GIak
         37gFzt8gOxVJQ24pnyVBhUlw2FhfkgA4tKSdyLJ/4wFC6CdyAxYD3aFPYPc60gtiLM
         OOsjHn7FvL6VRkyCv+5ud3TiJaCddGoE7bZZWOIYTRQTyzBDceUK3oo3VI10OObqZI
         HoJlyNvCINKWMwc0fgNjsvG+TVC8/SeZCKTRkIRG01QcTaMQpQakEbas7bjkVfGUnX
         f2mdAC3GCHqew==
Received: by mail-ot1-f50.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so19492410otq.7
        for <linux-cifs@vger.kernel.org>; Sun, 03 Oct 2021 17:47:19 -0700 (PDT)
X-Gm-Message-State: AOAM531efhJ2SzB0Ltvc838hr5b3SrOlffy/tnxCTr4eK0+nP722qcKQ
        4pXHiVb986fj99J4WTmPGxaKXGKKL9tC9EvFozw=
X-Google-Smtp-Source: ABdhPJz24q+go8C+V9BNbC9pEE8sO7r9bEjOPKPFteepTA7jiwdc5drxlPUOlUZMkDyJ2nSuv/B0CysXEbm3vxCyEJU=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr7133286ots.185.1633308438984;
 Sun, 03 Oct 2021 17:47:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sun, 3 Oct 2021 17:47:18 -0700 (PDT)
In-Reply-To: <YVo+0tjUiVPySJ1H@jeremy-acer>
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-14-slow@samba.org>
 <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com> <YVo+0tjUiVPySJ1H@jeremy-acer>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 4 Oct 2021 09:47:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_zBzcreFcCdcueyXJk5ttMEW0tR0KYyLynY61dgpibpw@mail.gmail.com>
Message-ID: <CAKYAXd_zBzcreFcCdcueyXJk5ttMEW0tR0KYyLynY61dgpibpw@mail.gmail.com>
Subject: Re: [PATCH v5 13/20] ksmbd: remove ksmbd_verify_smb_message()
To:     Jeremy Allison <jra@samba.org>
Cc:     Ralph Boehme <slow@samba.org>, linux-cifs@vger.kernel.org,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-04 8:37 GMT+09:00, Jeremy Allison <jra@samba.org>:
> On Sat, Oct 02, 2021 at 02:46:16PM +0900, Namjae Jeon wrote:
>
>>smb1 negotiate is needed for windows connection. Have you tested with
>>windows client ?
>
Hi Jeremy,
> Isn't this only needed for Win7 upgrading a connection from
> SMB1 -> SMB2 on initial connect. I don't think Win8 and above
> need this.
>
> Is this as far back as we want to support ?
Win10 still send smb1 negotiate request for auto negotiation.

Thanks!
>
