Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DB1C6FD1C
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Mar 2023 23:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCTXcR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Mar 2023 19:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCTXcQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Mar 2023 19:32:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AD4274BA
        for <linux-cifs@vger.kernel.org>; Mon, 20 Mar 2023 16:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB1EB8118F
        for <linux-cifs@vger.kernel.org>; Mon, 20 Mar 2023 23:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886E9C433EF
        for <linux-cifs@vger.kernel.org>; Mon, 20 Mar 2023 23:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679355107;
        bh=/wCIWKEk/Z30MLIny8wHvea7m2wCgNJZsnKTavmhvyk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ja3nFZ9ggJpiybIXWKOVEFW/yBYtqHs/V7WxmB7kD+edk6pMDBVDHhtLLR62wW5Yb
         RBhbXQwJQ0KbA9Y7R4lPmhRzAWq4Cf9e1I7Vn6lNLjcEGH3qF9Pxp/wDvdo51BYVvk
         1NdVQY90eEfisJyg4ScTwWNSgnMvRnK9uyTRdOi+bYlyjZVp4ZriaZ6yIvqf6gTMgT
         7bNe58+cRVGsr8CFzo70F7+USfzNJ1fains7OFUsq4qaF1lKcVIzf9pALrIZHnB2At
         Q742Ygb9YG5hvYwkDz5RsPr0MoAy4R1npZ9YYURJr/6GcZeTa+UG3ABJSVOx9irSxg
         apg5S7za2PklA==
Received: by mail-ot1-f47.google.com with SMTP id k14-20020a056830150e00b0069f156d4ce9so3050615otp.6
        for <linux-cifs@vger.kernel.org>; Mon, 20 Mar 2023 16:31:47 -0700 (PDT)
X-Gm-Message-State: AO0yUKUNJvc1FAKzt7dNQxSEcGBvYUSGBYqC1yzQBcUjSdtL0Zm9OCsA
        milcIhM+gQRvgPX+r+AhFUQkHD6beT+V8TqR+5k=
X-Google-Smtp-Source: AK7set8WQDMO+pncyT53HEjJA/YKf152srOghVuZGs31v/qUJPZDaeCSJDroyGW569rNkbFBDb9Bw5AbtJ4LM/JFvBk=
X-Received: by 2002:a9d:3e53:0:b0:69a:7f40:3fb9 with SMTP id
 h19-20020a9d3e53000000b0069a7f403fb9mr42821otg.3.1679355106681; Mon, 20 Mar
 2023 16:31:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:7744:0:b0:4c8:b94d:7a80 with HTTP; Mon, 20 Mar 2023
 16:31:46 -0700 (PDT)
In-Reply-To: <CAH2r5mvj=ObccFPLXiX0bGsxs_Y6Vex-z138NnyGeke92XNrZg@mail.gmail.com>
References: <CAH2r5mvj=ObccFPLXiX0bGsxs_Y6Vex-z138NnyGeke92XNrZg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Mar 2023 08:31:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8nTkaotzdz-t-qb=uR5EDxoiTrXDWwrtuemu3oxgS9QA@mail.gmail.com>
Message-ID: <CAKYAXd8nTkaotzdz-t-qb=uR5EDxoiTrXDWwrtuemu3oxgS9QA@mail.gmail.com>
Subject: Re: ksmbd not returning errors on unsupported dialects
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-21 3:43 GMT+09:00, Steve French <smfrench@gmail.com>:
> David Howells had noticed that ksmbd returned "Input/output error"
> when mounting with vers=2.0 to ksmbd.    Looking at this more
> carefully, mounting to ksmbd works with 3.1.1 (and 3.0 and 2.1) as
> expected, but he is correct it fails with the wrong error for
> unsupported dialects like 2.0. ksmbd would be expected to fail with
> mounts with vers-2.1 but this error would be confusing to users.
>
> The problem is that ksmbd is returning STATUS_SUCESS on the negprot in
> the first part of the SMB1 header, but returning no information in the
> NegProt part of the response (e.g. StructureSize, SecurityMode,
> Dialect etc.)
>
> Looks like the bug is that you meant to return a status not supported
> or similar but left that out (or similar to what you do with vers=1.0,
> kill the socket which causes HOST DOWN to be returned by the Linux
> client).
>
> MS-SMB2 3.3.5.4 may have the exact error that is best to return in this
> case
I will take a look.
Thanks for report!
>
> --
> Thanks,
>
> Steve
>
