Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FB2CD3423
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Sep 2023 23:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjIRXTX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Sep 2023 19:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjIRXTX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Sep 2023 19:19:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3D290
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 16:19:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D9C433CA
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 23:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695079157;
        bh=8gJSxJDC8eROFngCmwmPOWlvPHFAa5muEgSTbjWRFJY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=kO+SD9UgUhTkesFj73NODbKR1xqqStjh6KiWASK6wn016BNlfRmSMhCibGFSRgIGM
         9cny1uzgBnFrcz5gKYm5eTzkjVbohV/cEJF6RPKMAv+IB4Vuz3t9uETL0Xa3GALzFb
         CvgJqzHxnXepFaE05lreS7PyPkd2U4LZAwF7Dg0smWjpSJS9+n/SCC/eg+4V5mQucv
         Yb/JgO+4dt1IK8aam0mOwx+7EZrbv78/BBDI6PmvWMdomrQMzAVpPbsbkr7OlkObE3
         9O0loTt3Q/UKsn6ax4v0rf6hV2kBVZsGEw7w3VRU4kNgOYkIB8BB+WiNvtR60DRBJ7
         XCeq2k+zy69aQ==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5733710eecaso3055128eaf.1
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 16:19:17 -0700 (PDT)
X-Gm-Message-State: AOJu0YyXQKGkiyPnbLc/5AIOJInUxyLlhGeITVKMrysuVi1q8pdAnzZs
        hV2060hX3IYxsa0BwhXQaKW97Mvrn/6LCfmYKuU=
X-Google-Smtp-Source: AGHT+IF/5HifJGk4o8HMMIn3r8y21Bb1QstTosLZNcAHOm3G6W5nx/WP7pT98U//FRmt9X69K+0DeahyaSArCd+2dhM=
X-Received: by 2002:a4a:7607:0:b0:56e:4bb5:3095 with SMTP id
 t7-20020a4a7607000000b0056e4bb53095mr9177478ooc.5.1695079156972; Mon, 18 Sep
 2023 16:19:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6802:119b:b0:4fa:bc5a:10a5 with HTTP; Mon, 18 Sep 2023
 16:19:15 -0700 (PDT)
In-Reply-To: <3b086b54-ff6e-1cf7-2e33-37651814f06e@talpey.com>
References: <3b086b54-ff6e-1cf7-2e33-37651814f06e@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 19 Sep 2023 08:19:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_xUSWxsGERAuA26keWzDGmmKN5pO=BOcOzH-2v5V+r8g@mail.gmail.com>
Message-ID: <CAKYAXd_xUSWxsGERAuA26keWzDGmmKN5pO=BOcOzH-2v5V+r8g@mail.gmail.com>
Subject: Re: Known SMBDirect issue?
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-09-19 7:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
> Namjae, after building a 6.6.0-rc2 kernel to test here at the IOLab,
> I was surprised to see the smbdirect connection break during the
> Connectathon "special" tests. The basic tests all work fine, but shortly
> after the special tests begin, I start seeing this on the server (this
> is with softRoCE, though I see similar failures over softiWarp):
I'll try to reproduce it tonight. I found no problems in testing with
the Windows client last week. I will have to check with cifs.ko &
softROCE.

Thanks for your report!
>
> [ 1266.623187] rxe0: qp#17 do_complete: non-flush error status = 2
> [ 1266.623233] ksmbd: smb_direct: Recv error. status='local QP operation
> error (2)' opcode=0
> [ 1266.623605] ksmbd: smb_direct: disconnected
> [ 1266.623610] ksmbd: sock_read failed: -107
> [ 1266.628656] rxe0: qp#18 do_complete: non-flush error status = 2
> [ 1266.628684] ksmbd: smb_direct: Recv error. status='local QP operation
> error (2)' opcode=0
> [ 1266.628820] ksmbd: smb_direct: disconnected
> [ 1266.628824] ksmbd: sock_read failed: -107
> [ 1266.633354] rxe0: qp#19 do_complete: non-flush error status = 2
> [ 1266.633380] ksmbd: smb_direct: Recv error. status='local QP operation
> error (2)' opcode=0
> [ 1266.633583] ksmbd: smb_direct: disconnected
>
> The local QP error 2 is IB_WC_LOC_QP_OP_ERR, which is a buffer error
> of some sort, could be a receive buffer unavailable or maybe a length
> overrun. Both of these seem highly improbable, because the "basic" tests
> run fine. The client sees only a disconnection with IB_WC_REM_OP_ERR,
> which is expected in this case.
>
> OTOH it could be a client send issue, maybe a too-large datagram or an
> smbdirect credit overrun. But it's the server detecting the error, so
> I'm starting there for now.
>
> This worked as recently as 6.5, definitely it was all fine in 6.4. I am
> not yet able to drill down to the level of figuring out what SMB3
> payload was being received by ksmbd.
>
> Steve tells me you test over RDMA semi-often. Have you seen this?
> Any ideas are welcome.
>
> Tom.
>
