Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F5CC77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 19 May 2023 01:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjESBhk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 21:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjESBhi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 21:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B1210C9
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 18:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09154641B2
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 01:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647E9C4339C
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684460254;
        bh=0qoxn5oq/NO734Hm1RZ18EAzkYFWodYmRWDQeQqG61o=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=RntP658/ypKrYo2T5CmZoX7cBxKSJZM26rvsW2j/uWeG3UYpNInq1cmHPkl+1oxdc
         fuUvZzHUf146298pn0lqpQPnhKIfqjfT1kP0dbPld7g22wRNPR87Y+/nUU1GNHpGDy
         UzIqwYA7sY/IBBnSS4BpeNctbuKaJBpItiJmLn7Y/gNbDfFqH9WjlHbiMS45NEur1i
         83yr+t2MCGwSm4OVRUC23hVfZyYhpQ5A3ODDZk+Oe5whuB/fFCU8/M7gTYSFulvvZI
         fryUWRjkxczjOZHd/B4xVSFPpUDmv6Y1pjgHfd7cHf9BYxQPv740d4EdJV06mDaYYM
         qanqJLZczNExQ==
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-199dd37f0e4so2060345fac.2
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 18:37:34 -0700 (PDT)
X-Gm-Message-State: AC+VfDwu4SVoTaf3mxsDUp2ly/LHZe67jeolwuWUqqYD3VkXmCgst6/W
        oc1WR9MgRTLwqA2//6PD1mIDQOwQwoLF6TBVlzE=
X-Google-Smtp-Source: ACHHUZ7aFc24PB+f+xw7Esg/XkHo9xLsXCla4BKllFALYPERb3Fa7Wfpitdl0aBcYfhVkXpmnd5Ar/Gb0Ogux0gmz5c=
X-Received: by 2002:a05:6808:259:b0:38d:f794:26a with SMTP id
 m25-20020a056808025900b0038df794026amr289532oie.41.1684460253476; Thu, 18 May
 2023 18:37:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6415:0:b0:4da:311c:525d with HTTP; Thu, 18 May 2023
 18:37:32 -0700 (PDT)
In-Reply-To: <20230518144208.2099772-1-h3xrabbit@gmail.com>
References: <20230518144208.2099772-1-h3xrabbit@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 19 May 2023 10:37:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9gBFPORqQ17mELGyygyOPxY4awsGxvOLYj7O3ckUHjrw@mail.gmail.com>
Message-ID: <CAKYAXd9gBFPORqQ17mELGyygyOPxY4awsGxvOLYj7O3ckUHjrw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     HexRabbit <h3xrabbit@gmail.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-18 23:42 GMT+09:00, HexRabbit <h3xrabbit@gmail.com>:
> From: Kuan-Ting Chen <h3xrabbit@gmail.com>
>
> Check the remaining data length before accessing the context structure
> to ensure that the entire structure is contained within the packet.
> Additionally, since the context data length `ctxt_len` has already been
> checked against the total packet length `len_of_ctxts`, update the
> comparison to use `ctxt_len`.
>
> Signed-off-by: Kuan-Ting Chen <h3xrabbit@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 52 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 33 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 972176bff..0285c3f9e 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -849,13 +849,13 @@ static void assemble_neg_contexts(struct ksmbd_conn
> *conn,
>
>  static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
>  				  struct smb2_preauth_neg_context *pneg_ctxt,
> -				  int len_of_ctxts)
> +				  int ctxt_len)
>  {
>  	/*
>  	 * sizeof(smb2_preauth_neg_context) assumes SMB311_SALT_SIZE Salt,
>  	 * which may not be present. Only check for used HashAlgorithms[1].
>  	 */
> -	if (len_of_ctxts < MIN_PREAUTH_CTXT_DATA_LEN)
> +	if (ctxt_len < MIN_PREAUTH_CTXT_DATA_LEN)
        if (ctxt_len <
            sizeof(struct smb2_neg_context) + MIN_PREAUTH_CTXT_DATA_LEN)
You need to plus sizeof(struct smb2_neg_context) here.
MIN_PREAUTH_CTXT_DATA_LEN  accounts for HashAlgorithmCount,
SaltLength, and 1 HashAlgorithm.

>  		return STATUS_INVALID_PARAMETER;
