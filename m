Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9F1C678DB
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Mar 2023 04:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCGEKD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Mar 2023 23:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCGEJ7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Mar 2023 23:09:59 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A342D57092
        for <linux-cifs@vger.kernel.org>; Mon,  6 Mar 2023 20:09:57 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id kb15so12022308pjb.1
        for <linux-cifs@vger.kernel.org>; Mon, 06 Mar 2023 20:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678162197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xCPRlQDaKCOl35uB7DEeppGjNeAfkOs0IdZ9rllzha4=;
        b=itLqBA8V2WS4c+QNB2y61qFYPFBXYwdLW13Qv7V5TnrAsbaXdQ3Hirt63o+WNFvwPy
         /V6qtjVb3uU4vCXvGAlQOPmbR51iW1kg90EUZ3KyFQpRBQQvq1Xt4SZeNeNNmZZBF9W6
         h3iYy5w6Hn5u5g0Rc7w2tyvXqwiT1ZVglyS+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678162197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCPRlQDaKCOl35uB7DEeppGjNeAfkOs0IdZ9rllzha4=;
        b=2k0E0VfzKr4DwUL8xP0Wu1RRLyk58tU3DW9F+GM0zQfFUUX2u+MQ5zEJs8xGVQWnq5
         IXWO6T2+awRrlVhjKmGC7d/JPKhTWRHf1VRSL7GttKQtaIlj6guBbiMZHa/Hbi82QsRP
         rjeePkfkCHAHIPaoTf/hCPg8YtLU6Giza/aYHF0IJYBVM9TlmE0ex8pVAdKtr3x8em6s
         ZqbxekXfhuWiv9an99uv2DqatI4P2RMTF69Lg7bt3fvEi1k7ZC1wMoZGWxTER5zHfTqb
         ElZxEweanXDaFImhNQ+LMyN3Fzv3q5cSaqXdDG1aDSMXyoTfsS970V/A+98HtzZO1KJh
         +Hjg==
X-Gm-Message-State: AO0yUKWiewzvqWv3/+laQXLt4CGQf+nPV0cJWqGpCbHNxE7cKIKvXFap
        3/RJfD78J2/BR9NoXG/vZZqwOQ==
X-Google-Smtp-Source: AK7set9jJpxSSXOlHvCjEGUB8gNteybjTUummjA8UBZhpZPiLtWZ0watoT1Oc3cac9RZZdZOs0NFZg==
X-Received: by 2002:a17:90a:4bca:b0:230:a195:b8ac with SMTP id u10-20020a17090a4bca00b00230a195b8acmr13836773pjl.7.1678162196942;
        Mon, 06 Mar 2023 20:09:56 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id e16-20020a17090ab39000b0020b21019086sm217376pjr.3.2023.03.06.20.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 20:09:56 -0800 (PST)
Date:   Tue, 7 Mar 2023 13:09:52 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: add low bound validation to
 FSCTL_QUERY_ALLOCATED_RANGES
Message-ID: <20230307040952.GF5231@google.com>
References: <20230305123443.21509-1-linkinjeon@kernel.org>
 <20230305123443.21509-2-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230305123443.21509-2-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/05 21:34), Namjae Jeon wrote:
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7457,6 +7457,11 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
>  	start = le64_to_cpu(qar_req->file_offset);
>  	length = le64_to_cpu(qar_req->length);
>  
> +	if (start < 0 || length < 0) {
> +		ksmbd_fd_put(work, fp);
> +		return -EINVAL;
> +	}

Can we do sanity checking before we ksmbd_lookup_fd_fast()?
