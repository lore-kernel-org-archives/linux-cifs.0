Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242EDC77B7D
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 05:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjERFpq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 01:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjERFpp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 01:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00DA273C
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 22:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D25164D2E
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 05:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB703C4339B
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 05:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684388742;
        bh=duPrUDTADKeZeT+wKLDHKevxsCzoer/aCoW+LqlM8Yc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=F/8zxhr66sqSoLEShst0BiArUfMoY6NOCKu108BVhdGR0MuuVliVUPnZnmNSoIlQx
         81Py2y0FI0gVPePfRPh/fLZB3gsFnJ1iOQIk2rSfQSe6axU0YxGWyhiOPAdmr/Zqya
         L1aN6oS5A4PqOglcxXMSA+qSsm0iMKTF7dHuDklNpwX1YPojR5R8WTUA6pJquF4+dY
         j/FybXSDkGlMGBJXgl29ClCayunZrX2ghcjnQCGaLuxO+YUbg35NNflHVXwATAFoqg
         yY4fLgWY/rblgzd8eGQ7Td1UUcvSirydtGqf6W/VP2p5sTnwTlr9PrwSloEMBWVeSL
         RdtqA2H1/evYA==
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3941c3ba226so1067972b6e.0
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 22:45:42 -0700 (PDT)
X-Gm-Message-State: AC+VfDxLvfa6tgx3vphxJGl3kpoM/tGOHYTkqIAX6/rFhRnFEcOcN1Qw
        z6BF7wpEhOoUpv+eqdibCdJudCsnHvRCVLM7Pto=
X-Google-Smtp-Source: ACHHUZ6003JV73AfmIllAXCyHPCrD6IxVdlj44p5rxQij10oosbltcgHP9lXU+ahO/nnFG3NZYTOWK9HX101n78gcaI=
X-Received: by 2002:a05:6808:1b23:b0:396:11b3:5851 with SMTP id
 bx35-20020a0568081b2300b0039611b35851mr860543oib.54.1684388742017; Wed, 17
 May 2023 22:45:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6415:0:b0:4da:311c:525d with HTTP; Wed, 17 May 2023
 22:45:41 -0700 (PDT)
In-Reply-To: <20230517185820.1264368-1-h3xrabbit@gmail.com>
References: <20230517185820.1264368-1-h3xrabbit@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 18 May 2023 14:45:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd85JZnU9pH8a0qGqXGWn=m3j=LS_kArV9TL1+m1f3fCgA@mail.gmail.com>
Message-ID: <CAKYAXd85JZnU9pH8a0qGqXGWn=m3j=LS_kArV9TL1+m1f3fCgA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     HexRabbit <h3xrabbit@gmail.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-18 3:58 GMT+09:00, HexRabbit <h3xrabbit@gmail.com>:
> From: Kuan-Ting Chen <h3xrabbit@gmail.com>
>
> Ensure the context's length is valid (excluding VLAs) before casting the
> pointer to the corresponding structure pointer type, also removed
> redundant check on `len_of_ctxts`.
>
> Signed-off-by: Kuan-Ting Chen <h3xrabbit@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 972176bff..83b877254 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -969,18 +969,16 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>  	len_of_ctxts = len_of_smb - offset;
>
>  	while (i++ < neg_ctxt_cnt) {
> -		int clen;
> -
> -		/* check that offset is not beyond end of SMB */
> -		if (len_of_ctxts == 0)
> -			break;
> +		int clen, ctxt_len;
>
>  		if (len_of_ctxts < sizeof(struct smb2_neg_context))
>  			break;
>
>  		pctx = (struct smb2_neg_context *)((char *)pctx + offset);
>  		clen = le16_to_cpu(pctx->DataLength);
> -		if (clen + sizeof(struct smb2_neg_context) > len_of_ctxts)
> +		ctxt_len = clen + sizeof(struct smb2_neg_context);
> +
> +		if (ctxt_len > len_of_ctxts)
>  			break;
>
>  		if (pctx->ContextType == SMB2_PREAUTH_INTEGRITY_CAPABILITIES) {
> @@ -989,6 +987,9 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn
> *conn,
>  			if (conn->preauth_info->Preauth_HashId)
>  				break;
>
> +			if (ctxt_len < sizeof(struct smb2_preauth_neg_context))
> +				break;
> +
>  			status = decode_preauth_ctxt(conn,
>  						     (struct smb2_preauth_neg_context *)pctx,
>  						     len_of_ctxts);
> @@ -1000,6 +1001,9 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>  			if (conn->cipher_type)
>  				break;
>
> +			if (ctxt_len < sizeof(struct smb2_encryption_neg_context))
You need to consider Ciphers flex-array size to validate ctxt_len. we
can get its size using CipherCount in smb2_encryption_neg_context.
> +				break;
> +
>  			decode_encrypt_ctxt(conn,
>  					    (struct smb2_encryption_neg_context *)pctx,
>  					    len_of_ctxts);
> @@ -1009,6 +1013,9 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>  			if (conn->compress_algorithm)
>  				break;
>
> +			if (ctxt_len < sizeof(struct smb2_compression_capabilities_context))
Ditto.
> +				break;
> +
>  			decode_compress_ctxt(conn,
>  					     (struct smb2_compression_capabilities_context *)pctx);
>  		} else if (pctx->ContextType == SMB2_NETNAME_NEGOTIATE_CONTEXT_ID) {
> @@ -1021,6 +1028,10 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>  		} else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES) {
>  			ksmbd_debug(SMB,
>  				    "deassemble SMB2_SIGNING_CAPABILITIES context\n");
> +
> +			if (ctxt_len < sizeof(struct smb2_signing_capabilities))
Ditto.

Thanks.
> +				break;
> +
>  			decode_sign_cap_ctxt(conn,
>  					     (struct smb2_signing_capabilities *)pctx,
>  					     len_of_ctxts);
> --
> 2.25.1
>
>
