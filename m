Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F69C77B7A
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 10:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjEQKRT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 06:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjEQKRS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 06:17:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CCF35AB
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 03:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D426F644D1
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 10:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA85C433A1
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 10:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684318636;
        bh=sCFLyn3uqstufpWA52G97KF1TGOj+19OWL0e0FFdjQ8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=O/MS9xOKJVDcX/sGpQ1j8yqv+6nqKGzL/K+4pCrEUMMG2hX2cR3JOsOwZhxCd8q+3
         P4ba8Z5h9Jor7EE/Ut73HZ/UxFQ8CbGzSMM56JtnbKmY45EeuL/PHT1ycvWNRU7K5u
         By/ngrmlNnzzhOioqGg+M8RznS7i2v/VhTpA/Lhd/m+sLtiXQ+TR5U9IVc+ss0PfsP
         xY9G+1eRXXcNELVfCWpAgKHScr2A4YpWSQMUBV8RZQrwuZhVHhlAU7Czb22RPdYR6n
         R3ybQu3LlKAND9Kr1MdoNwBZ6Rp8VZQyRhyA0wu93nBsykvCBup7uEfJeXnHYT3udp
         XpterhTXxaQYQ==
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-38ef6217221so414850b6e.3
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 03:17:16 -0700 (PDT)
X-Gm-Message-State: AC+VfDxg8+8Qdu+2DqIghURNB2lWt/ohXO2QSXYjayv9ARHu0Xm+WVgg
        bGZ2gdpIcq94zUj/orKlWMfEDwcmjjtF3ZRlMLg=
X-Google-Smtp-Source: ACHHUZ4w4qE+kBlt0fcGBIGrtVGNxxLElAykIREHw8Nf5AsR5o9iviA/S+F+Qr7fVUsImbMLmwmmk9JSowGAmdiqWJI=
X-Received: by 2002:a05:6808:614e:b0:38c:5a32:325b with SMTP id
 dl14-20020a056808614e00b0038c5a32325bmr16447973oib.41.1684318635396; Wed, 17
 May 2023 03:17:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:290:0:b0:4da:311c:525d with HTTP; Wed, 17 May 2023
 03:17:15 -0700 (PDT)
In-Reply-To: <20230517095951.3476020-1-h3xrabbit@gmail.com>
References: <20230517095951.3476020-1-h3xrabbit@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 17 May 2023 19:17:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_V2RgWTHzrG-1A8kX+rpyyQ06=hX2s5AqwW8ERWaaE1w@mail.gmail.com>
Message-ID: <CAKYAXd_V2RgWTHzrG-1A8kX+rpyyQ06=hX2s5AqwW8ERWaaE1w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix slab-out-of-bounds read in smb2_handle_negotiate
To:     HexRabbit <h3xrabbit@gmail.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-17 18:59 GMT+09:00, HexRabbit <h3xrabbit@gmail.com>:
> Check request_buf length first to avoid out-of-bounds read by
> req->DialectCount.
>
> [ 3350.990282] BUG: KASAN: slab-out-of-bounds in
> smb2_handle_negotiate+0x35d7/0x3e60
> [ 3350.990282] Read of size 2 at addr ffff88810ad61346 by task
> kworker/5:0/276
> [ 3351.000406] Workqueue: ksmbd-io handle_ksmbd_work
> [ 3351.003499] Call Trace:
> [ 3351.006473]  <TASK>
> [ 3351.006473]  dump_stack_lvl+0x8d/0xe0
> [ 3351.006473]  print_report+0xcc/0x620
> [ 3351.006473]  kasan_report+0x92/0xc0
> [ 3351.006473]  smb2_handle_negotiate+0x35d7/0x3e60
> [ 3351.014760]  ksmbd_smb_negotiate_common+0x7a7/0xf00
> [ 3351.014760]  handle_ksmbd_work+0x3f7/0x12d0
> [ 3351.014760]  process_one_work+0xa85/0x1780
>
> Signed-off-by: HexRabbit <h3xrabbit@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Sergey will say, "Do we still have a requirement that there should be
a real name in SoB?"

Thanks for your patch!
