Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF26C6FD1C
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 03:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCXDuH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 23:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCXDuG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 23:50:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C6224CAD
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 20:50:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so3870573pjv.5
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 20:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679629805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fQExOH7zoSyyuBR5LP60lSx+TJMaE3oMApzRAxm8rFQ=;
        b=PDHXe9VLqC0lHchHG4H7pMxTQYtQt2f5nwLMq7F+ZjTuo4nx6Zk+QRWqooC3jKqr9P
         DijHwJDq+5JfBB405QHa7HfIwybNGmFCFftoI78vCdSnP/9yy9QTq25mw67Mi0BjZR52
         bJwsCX3kRAgE+PRIHwf8XW6mEe2h0moB35qs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679629805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQExOH7zoSyyuBR5LP60lSx+TJMaE3oMApzRAxm8rFQ=;
        b=i/iqqaTqoRXJwXajyVHg3oAOx2A3Nf1PDqx7mATG2Rzk7rENh+bXZcmbsdUWDMYyJs
         uKCl2pxkPKsTNMmAXCQ9rFcvoCYhaoYK8P5rqWBX6ppJ3720ffmV6VnofK21bDrNM2dK
         m4Qn4+aVtU86bCdVP9EWlJtyN++e6vEsu/S5vWcyZE3i0+R26rh2wSnI7XT9ESSdh2fX
         WP11CFSDOLtciRlQuIO6Jh/wymnd1gJsbjDMSCBdiZZ8EAw/ot0FkjaiHPvtMNfgHPD3
         2DZ8U6J9hJKgpLxTf76S1zfzT7d6jUVModx/4adZxJsonrV5eX1cVzUBpQjv2XuGWRt6
         118w==
X-Gm-Message-State: AAQBX9eX/WtRssD+UMiZ924mnDxRlYOFLlVELRLMPsHmxc+vA50iqiRP
        FIoxTa/+0SC0/Sg8OlsJiF+jsA==
X-Google-Smtp-Source: AKy350axGoE+JZ3g52AW1w9zfKmTuXFWDjJxbC7+9VjebmC53K/eWxX+bKXBLHS1GrdaCk1nxkuDeQ==
X-Received: by 2002:a17:90a:43:b0:234:d42:1628 with SMTP id 3-20020a17090a004300b002340d421628mr1332339pjb.10.1679629804927;
        Thu, 23 Mar 2023 20:50:04 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id 1-20020a170902c10100b0019ac9c4f32esm12976420pli.309.2023.03.23.20.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 20:50:04 -0700 (PDT)
Date:   Fri, 24 Mar 2023 12:50:00 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] ksmbd: don't terminate inactive sessions after a few
 seconds
Message-ID: <20230324035000.GD3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321133312.103789-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/21 22:33), Namjae Jeon wrote:
[..]
> @@ -335,14 +336,23 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
>  		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
>  			total_read = -EAGAIN;
>  			break;
> -		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
> -			   max_retry) {
> +		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
> +			/*
> +			 * If max_retries is negative, Allow unlimited
> +			 * retries to keep connection with inactive sessions.
> +			 */
> +			if (max_retries == 0) {
> +				total_read = length;
> +				break;
> +			} else if (max_retries > 0) {
> +				max_retries--;
> +			}
> +
>  			usleep_range(1000, 2000);
>  			length = 0;
> -			max_retry--;
>  			continue;
>  		} else if (length <= 0) {
> -			total_read = -EAGAIN;
> +			total_read = length;
>  			break;
>  		}
>  	}

By the way, ksmbd_tcp_readv() calls kvec_array_init() on each iteration.
Shouldn't we call it only if length > 0? That is only if the most recent
call to kernel_recvmsg() has read some data.
