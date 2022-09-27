Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91ED6C32771
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 00:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiI0Agi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Sep 2022 20:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiI0Agh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Sep 2022 20:36:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1008F6A491
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 17:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A162C61524
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 00:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BC9C43470
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 00:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664238996;
        bh=hkEHi1zVEgI2x2xhSnBa8voxQUcn7dlJwipJaY5fF9Y=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=n3I0j/q1HvWMOPjE7rG2kid+G8TJ4D2dMpBBU3dh/2gNVBobR5RibJ94A3tz+P9gk
         qmig9U580Xz6/d6/N3MWBzkLHLBsxwiUNLfGqJavh6TDDJYVfF4Xem6DXhi8Ix8OlQ
         FY+ZLHoT71YGNndAerDha15FIcsHMj5Y5IUpi+9F85zs8nQbEJO1ZhrxYK4zIjWGcC
         BEpvMe8+hh14wUNIn/9dqDM5V1iirVg7q5mzFZOkSrFckKhi63Fxkyxg6M70rKCbya
         QrngfmvGlG26CeoadlhjBKaJf1eJYlY/UCSsxIi/qusrB40lkzNW2uzxd9F7uXAZ71
         0cibTCvlW9Qog==
Received: by mail-ot1-f50.google.com with SMTP id 102-20020a9d0bef000000b0065a08449ab3so5503664oth.2
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 17:36:36 -0700 (PDT)
X-Gm-Message-State: ACrzQf23v2iAEWzvYuEWNXlFA+z1FXEUKZl8NRFwTq6f+akwnBzZGtrt
        1S4/qtwC8lhm825wFAxsVtqM11XWvzPHK2KhtA8=
X-Google-Smtp-Source: AMsMyM6Z8xKM9cJWmt0GAcqDgQcEDWuWGTRtvc9V89cxAraF9yaxfm6z07FFavz0MHpsrkROjECSaHoqcMHFR5STeX4=
X-Received: by 2002:a9d:da6:0:b0:655:dd4e:7afc with SMTP id
 35-20020a9d0da6000000b00655dd4e7afcmr11051198ots.339.1664238995271; Mon, 26
 Sep 2022 17:36:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 26 Sep 2022 17:36:34
 -0700 (PDT)
In-Reply-To: <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
References: <cover.1663961449.git.tom@talpey.com> <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 27 Sep 2022 09:36:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8zeUDeaV44m1ibr9jsdid0Edyp8NfZm34Z5bCULYDfAQ@mail.gmail.com>
Message-ID: <CAKYAXd8zeUDeaV44m1ibr9jsdid0Edyp8NfZm34Z5bCULYDfAQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive segment sizes
To:     Tom Talpey <tom@talpey.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
> Reduce ksmbd smbdirect max segment send and receive size to 1364
> to match protocol norms. Larger buffers are unnecessary and add
> significant memory overhead.
>
> Signed-off-by: Tom Talpey <tom@talpey.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
