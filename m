Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7794FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Apr 2022 04:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbiD3EOT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Apr 2022 00:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbiD3EOR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Apr 2022 00:14:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ED96419
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFA2DB838AF
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A941C385AD
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651291853;
        bh=qhvXresu2i8th+vYS/jRzkGgpEykIPnbiRrYkGPIREw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Gdk+WKsibmNJ7xKqTdpwr8Ps4LZ+SvalBsmsEncyk2Y82FOuMbecDFTo9Kgrs1SVT
         slSH7XwnpM2qMFZpU/sbzZi16iRUrKrPWPIcvBSZWn3Ar4F0wZgRJmNCgLOJNH9egM
         Xf8EX++pd/sfAHv2V0gb5vyXsDFa9Biji2LKJQRWPgB//CUY9fWlpyMZZZP0L3ZmEU
         xqEFe2caWk4kMLcyoUffBwExFUskN4Q56OPVZ+h7RO/VvXbH/8IpFisOjQB7kWdNX/
         ZPds8CJlIGkFAHrA2IakJCT/+mME+LDa1u1EXoA0a9W3ZpstSknZz1iGh8kR05rkiP
         auiH2Myw3TAPQ==
Received: by mail-wr1-f43.google.com with SMTP id b19so12997419wrh.11
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:10:53 -0700 (PDT)
X-Gm-Message-State: AOAM531lAsFXvy0IACT/SETqy5mw46BFXfv8xVA7isEQxbYekvzkcOTs
        4s+HvYfqdbTEfvaP2XMVSZcu1L2VEi3pbAFdmlI=
X-Google-Smtp-Source: ABdhPJxnTuu1VRQWlHgrlhaLy/bFoLAo8GIOyW2LsL0g1dPfMyVeSZ4PJ7ZB+X0SwSz6EJmrfYY5ExTeQaj5CUR9ilE=
X-Received: by 2002:adf:fe47:0:b0:20a:c899:829f with SMTP id
 m7-20020adffe47000000b0020ac899829fmr1634743wrs.165.1651291851714; Fri, 29
 Apr 2022 21:10:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64e7:0:0:0:0:0 with HTTP; Fri, 29 Apr 2022 21:10:51
 -0700 (PDT)
In-Reply-To: <20220429233029.42741-3-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com> <20220429233029.42741-3-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 30 Apr 2022 13:10:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8LiCbb+Srp5MgsisihZC-25t3gmBkN1xRzKhfaLn81kg@mail.gmail.com>
Message-ID: <CAKYAXd8LiCbb+Srp5MgsisihZC-25t3gmBkN1xRzKhfaLn81kg@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] ksmbd: smbd: simplify tracking pending packets
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-04-30 8:30 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Because we don't have to tracking pending packets
> by dividing these into packets with payload and
> packets without payload, merge the tracking code.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
