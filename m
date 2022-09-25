Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A77FC04A95
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 03:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIYDkx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 24 Sep 2022 23:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiIYDkv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 24 Sep 2022 23:40:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352452F67E
        for <linux-cifs@vger.kernel.org>; Sat, 24 Sep 2022 20:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF08360FB4
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 03:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F051C43141
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 03:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664077249;
        bh=ppFq5lSeYTjfrVCpTzza8AMMw0G/2ASowM3lLm6eKaY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gF27bXeUUfIsAQkdE8n9I1aGCpSdge7t9gwtFsQi/PlvrnVv4+Jnojs4uznDxqmu9
         bE8sDMiwKbzdrLU5FmlvARhkC1FrRF6pTbtcjSkKs9dzSSqGbrDq3b/y4jmzOFJ6pS
         LmJHlguu888tCHrX+t7zmh+RWoxKV9CxsOV1X0Lz2Zhjh9/L1Mm9XpfF6cg6uu9pyI
         Qv+6Ug4McfrZVaQCtAzZVYQymqRDte3KoEW3K3HvLkC98SUnocXTsaL/ovUmk8mYfw
         ykjx4OS40pTjhIj4wI+Q3YzmCHCbkCxqVl443Cm2P/Louaogi+APueOM9NQ5rIrw5h
         +/HRlBtd6OlQA==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-11e9a7135easo5346492fac.6
        for <linux-cifs@vger.kernel.org>; Sat, 24 Sep 2022 20:40:49 -0700 (PDT)
X-Gm-Message-State: ACrzQf0gzK9cBVy0vNOubNjeufaatsuU5sO1tWsfpn3KVuk2UEWN3fPe
        33HUVYDjHvr5ofuXJjy/drbSvC03Nb7pYWHBP84=
X-Google-Smtp-Source: AMsMyM47MAvF4/yH3MaoWg/BKTpEsAeddiI2HMLVq0o1POvcEvhSqsNEOliBzwNhBjXLcn9wrdRDiej0vcft5QTurPM=
X-Received: by 2002:a05:6870:9a26:b0:12d:7e1:e9c7 with SMTP id
 fo38-20020a0568709a2600b0012d07e1e9c7mr9727942oab.257.1664077248174; Sat, 24
 Sep 2022 20:40:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sat, 24 Sep 2022 20:40:47
 -0700 (PDT)
In-Reply-To: <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
References: <cover.1663961449.git.tom@talpey.com> <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 25 Sep 2022 12:40:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
Message-ID: <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
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
> ---
>  fs/ksmbd/transport_rdma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 494b8e5af4b3..0315bca3d53b 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max = 255;
>  static int smb_direct_send_credit_target = 255;
>
>  /* The maximum single message size can be sent to remote peer */
> -static int smb_direct_max_send_size = 8192;
> +static int smb_direct_max_send_size = 1364;
>
>  /*  The maximum fragmented upper-layer payload receive size supported */
>  static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
>
>  /*  The maximum single-message size which can be received */
> -static int smb_direct_max_receive_size = 8192;
> +static int smb_direct_max_receive_size = 1364;
Can I know what value windows server set to ?

I can see the following settings for them in MS-SMBD.pdf
Connection.MaxSendSize is set to 1364.
Connection.MaxReceiveSize is set to 8192.

Why does the specification describe setting it to 8192?
>
>  static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
>
> --
> 2.34.1
>
>
