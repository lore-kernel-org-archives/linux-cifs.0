Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E6DC41513
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Aug 2023 01:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjHKBqC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Aug 2023 21:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHKBqC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Aug 2023 21:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A8010D
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 18:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97F0C61000
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 01:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0096DC433C9
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 01:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691718361;
        bh=iqiXWIe5QlOOdINsnsfowpZN7OXuexVO70V0bfth9hQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VXPqv4Q+WIyY7kGZCpBsr7RgPEqZADS12c22r4UbSuVzTeZ6TJ8AGTjAFTon7sj5O
         Rfq9CMDEJ9gyPmHWehZsoxTvMs80dSYbVOwE1qEJJqBHlDvhMHDGePlj60kuMCnDFA
         S8hR23BLKX3ca/bPNMC34znhtYlCmHcus6K/IHc/pxjYFhfL7VX5pHYc0efT3WYmz2
         Lr11cqA0atQ83IkDSwr3v2bZy+Dmq1mbd06DqcwuuqOPd0sUB80IIaj5XxTNPgsei/
         HJFoKWiU5oqMDsmbdYonBoryyNwvUHSawc+Mhw4c5OJ5CBWJH6zJec/1wuOTD/k6L8
         C51bWV2O+5b8w==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-56d2fe54863so1007749eaf.0
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 18:46:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YwxFesAYzB3/S0XUTWm74oeBGuk+oFFnmbB2k2kM+1jc9FSyStl
        sQ0vNnt6w3aQiynT6KTFhDYepO9XcnHkdH75r8c=
X-Google-Smtp-Source: AGHT+IFBzAXW/EZ1mu2tGlKiBcTLxj73IZ9m0rATdO0JzhDJdQWqle+FRgZI0/tmmK5qoZo2jfwzC7MCEVE1bkaEguE=
X-Received: by 2002:a4a:b145:0:b0:56c:d045:2aba with SMTP id
 e5-20020a4ab145000000b0056cd0452abamr2469495ooo.4.1691718360126; Thu, 10 Aug
 2023 18:46:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:14c:0:b0:4e8:f6ff:2aab with HTTP; Thu, 10 Aug 2023
 18:45:59 -0700 (PDT)
In-Reply-To: <20230810200132.9733-1-atteh.mailbox@gmail.com>
References: <20230810200132.9733-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 11 Aug 2023 10:45:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_HkDWdzhzRJGvhuwY7NFCA5CN3HX4NLCYe2oOj7KW28w@mail.gmail.com>
Message-ID: <CAKYAXd_HkDWdzhzRJGvhuwY7NFCA5CN3HX4NLCYe2oOj7KW28w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix `force create mode' and `force directory mode'
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-08-11 5:01 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> `force create mode' and `force directory mode' should be bitwise ORed
> with the perms after `create mask' and `directory mask' have been
> applied, respectively.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
