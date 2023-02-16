Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9C3C61DA4
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Feb 2023 14:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBPOSi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 09:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBPOSi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 09:18:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E74BEA5;
        Thu, 16 Feb 2023 06:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B09A60EC0;
        Thu, 16 Feb 2023 14:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E34C433EF;
        Thu, 16 Feb 2023 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557109;
        bh=qljvpZ/qaq0j/2hLjwXx+T0T6rRMPZee1Sgmk5JkV5s=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=KHM3W282p+2pGgneRpfxPG7goMRfcWSjxq+xnpldW2w6JKhwLtH9SUtQ9uCMqHv3p
         a46V69bXxy/hnrnMq35qIj8cqE8XfTOjDLhIhYITviDP5nRF+/bLiKoutFgj/5nyDE
         MrVaVCBr048D9Y5XBEwxDkNBzGNDkFalukjJvXR/ddsp4c3mN9RNRqV1NiBqY9ByTV
         ob1AOegXvqCiUhT9eYo8BzBL1pMwCWast2u53LjsF1EV10j4DUcUqINnbp2uCbZ02X
         I7qFmto24muf2R66k6TuP2qlXgrT4Azacnm5kD3FwMr/O+p3rmaK95uwGS8bPV/esM
         caYELCP7NDwpA==
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-16cc1e43244so2617535fac.12;
        Thu, 16 Feb 2023 06:18:29 -0800 (PST)
X-Gm-Message-State: AO0yUKXp5bw4BuXRVGB1Or9RafWUhm8Fd82Gba7xTHQGW6uAHeNDGMyT
        ovLsWiZzTDd6+YGKDv8fmnj5K4rxD0e7bp0N2GA=
X-Google-Smtp-Source: AK7set+JOHjtHJPlCIP6J9C0GtafRUfyZrmiSNoFjxYGcBGoBYUuE6dkoj9qz2KAqUi+7K1RFNkMv4FpIxTJOpnEUVo=
X-Received: by 2002:a05:6870:b52c:b0:16a:b198:74e9 with SMTP id
 v44-20020a056870b52c00b0016ab19874e9mr192502oap.215.1676557109059; Thu, 16
 Feb 2023 06:18:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a8a:355:0:b0:4a5:1048:434b with HTTP; Thu, 16 Feb 2023
 06:18:28 -0800 (PST)
In-Reply-To: <20230214063650.12832-1-hbh25y@gmail.com>
References: <20230214063650.12832-1-hbh25y@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 16 Feb 2023 23:18:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9bfOOTfFVFvx_gakLiPqZSZrNvT12OnRMq2cUBHcPzAA@mail.gmail.com>
Message-ID: <CAKYAXd9bfOOTfFVFvx_gakLiPqZSZrNvT12OnRMq2cUBHcPzAA@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: fix possible memory leak in smb2_lock()
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, lsahlber@redhat.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-02-14 15:36 GMT+09:00, Hangyu Hua <hbh25y@gmail.com>:
> argv needs to be free when setup_async_work fails or when the current
> process is woken up.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks.
