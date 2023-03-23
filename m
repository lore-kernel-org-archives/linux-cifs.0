Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7C3C6FD1F
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 02:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjCWCxx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Mar 2023 22:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCWCxt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Mar 2023 22:53:49 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4A12068B
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 19:53:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y2so7867445pfw.9
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 19:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679540004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VAQFQ85/3WPrKuDmdBlBcaXEB7E3F+liqCQQ70y2Y8M=;
        b=OuwFSLLigCv++SvrQddIymQCwwpBPpUihgjtYIbdLAf5AwsGiN5QNov9cItuqv0y9X
         k6thlKCYbQSqJiJN6+qlyAGAFXOkjAPmIPzXrKTP10dpO2bI7zN7COSyUc8PgAfLcnhc
         Kq3XCbAvC4HqrTa793Rrjc0Y4w7fEDWe8obUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679540004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAQFQ85/3WPrKuDmdBlBcaXEB7E3F+liqCQQ70y2Y8M=;
        b=1hfd+aX7V4xmyc36qD1kaGSGFnbdU9s52ek/yhDEFfGqMuLkOGSRarQKDKPllXi71v
         TiSpGZYyYZHkz3gv/u0hNmlzXFDUdSD3qgzWW3WbIa79Ccb2U4ItIHAqTIIv0YJ4Yw0C
         /dNfLlMhCh3XbkhajQ4Aus96GtKvZulz0Ido4KPTKUpR8MAoaCmRStkXgyG1YJLIi50G
         rgvcJAipCuXwhMqsw+1aqSdFDziKyPjopZTyDs2g3Sdp/PxenyDqzdADrQDbErJdNBjV
         zQDFQ7MaCaut2CJmS2mikzaUsulttWpAj+YVINO1WcO66PsxGP6Cy5sg1lrKXqlU482S
         DKlQ==
X-Gm-Message-State: AO0yUKWMVvcFQMSpueibvgI2u7iB/IrlBsduNca7MNEhx5x2sP9uAyYz
        zPw6FiebxhJdCSuynbzzZMOqenGsLnslPVU+e+/71g==
X-Google-Smtp-Source: AK7set+9frsl6iphgJp4XN2dRyD/u+qSDw01NLmaAiVoEBQFFmPAiuiVjhddZPp/iOfg9bdjy4n5Lw==
X-Received: by 2002:a05:6a00:338f:b0:627:f40a:fd35 with SMTP id cm15-20020a056a00338f00b00627f40afd35mr4088208pfb.10.1679540004039;
        Wed, 22 Mar 2023 19:53:24 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id v22-20020a62a516000000b0058bc7453285sm10673226pfm.217.2023.03.22.19.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 19:53:23 -0700 (PDT)
Date:   Thu, 23 Mar 2023 11:53:19 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] ksmbd: return unsupported error on smb1 mount
Message-ID: <20230323025319.GA3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230321133312.103789-3-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321133312.103789-3-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/21 22:33), Namjae Jeon wrote:
[..]
> @@ -442,9 +442,26 @@ static int smb_handle_negotiate(struct ksmbd_work *work)
>  {
>  	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
>  
> -	ksmbd_debug(SMB, "Unsupported SMB protocol\n");
> -	neg_rsp->hdr.Status.CifsError = STATUS_INVALID_LOGON_TYPE;
> -	return -EINVAL;
> +	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
> +
> +	/*
> +	 * Remove 4 byte direct TCP header, add 1 byte wc, 2 byte bcc
> +	 * and 2 byte DialectIndex.
> +	 */
> +	*(__be32 *)work->response_buf =
> +		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);

	In other words cpu_to_be32(sizeof(struct smb_hdr)).

> +	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
> +
> +	neg_rsp->hdr.Command = SMB_COM_NEGOTIATE;
> +	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;

	I assume this should say cpu_to_le32(SMB1_PROTO_NUMBER).
