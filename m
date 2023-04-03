Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02381C76196
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Apr 2023 13:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjDCNQV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Apr 2023 09:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjDCNQU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Apr 2023 09:16:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7175A1994
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 06:16:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E2EEB81A0C
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 13:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3946C433EF
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680527776;
        bh=Ct0yjaa7sET89JxlQvHmhM3v1Ue6SREkjbPzNLxMRTk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=mrDwDV1lcRVgYoWgjgDlUZP1L8yvTL7TrL0XPowwbwPtqD3LSsKkulMM+h19KZQ1a
         nu04jjbZooKVp3/lWBsiTPmBV/LuNll2iDgNn1ewO7FqoOpSsTTGYahd+Ow/kZpQra
         zkUNysiI57Is3CFpjTYkmdJqzi5zkK3HAA7KJSd+npoiJ68AC0lM7cKz1+9uDph10B
         wcBrORBsnk6OkL+F+AxoN5XsdVJG5tdseLZQ2amYTm33URx/sL8iX125hZFUogcLYV
         I5sc/1csKRb1dH0xZ3ux7BV6QMxSKoS0lJxHZdxbU6qTlKYFAQ8fEObOSi2kmwl5W5
         qrELnxHTXM2rQ==
Received: by mail-ot1-f51.google.com with SMTP id cm7-20020a056830650700b006a11f365d13so14274308otb.0
        for <linux-cifs@vger.kernel.org>; Mon, 03 Apr 2023 06:16:16 -0700 (PDT)
X-Gm-Message-State: AAQBX9eTziKT1v8W0ZfwkSe2R8Jvc23WUBBCmHPI1Rc2kvTT/fPaIw5X
        PJYVvnxPjks50hA2ZKq0Gr9a5VUqNZqBpXb2HY4=
X-Google-Smtp-Source: AKy350aV8mk6CKlo4lVesgecKgQ08QZhjhDV93x7X9cevqpsSR4BQ39kim0EusQA9QnnpA9P59/Dq3iplobLFPKDAkg=
X-Received: by 2002:a9d:384:0:b0:69a:7f40:3fb9 with SMTP id
 f4-20020a9d0384000000b0069a7f403fb9mr7248163otf.3.1680527775899; Mon, 03 Apr
 2023 06:16:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:b12:0:b0:4c8:b94d:7a80 with HTTP; Mon, 3 Apr 2023
 06:16:15 -0700 (PDT)
In-Reply-To: <20230403092955.23752-1-ddiss@suse.de>
References: <20230403092955.23752-1-ddiss@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 3 Apr 2023 22:16:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9=D=tzo-2oqdxUqSQ9gc4ri+7ArLtc=ysxWx42y4eHfg@mail.gmail.com>
Message-ID: <CAKYAXd9=D=tzo-2oqdxUqSQ9gc4ri+7ArLtc=ysxWx42y4eHfg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set NegotiateContextCount once instead of every inc
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-04-03 18:29 GMT+09:00, David Disseldorp <ddiss@suse.de>:
> There are no early returns, so marshalling the incremented
> NegotiateContextCount with every context is unnecessary.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
