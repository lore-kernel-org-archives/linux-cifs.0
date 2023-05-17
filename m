Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E86C7EE23
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 11:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjEQLF2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 07:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjEQLF0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 07:05:26 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50B8ED
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 04:05:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-51b33c72686so413838a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 04:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684321510; x=1686913510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0dBeyJPRhXrYoMdL7UNGXjkGvgsaNG56xw0crWEgD48=;
        b=fZs9TRe94gxN+oZAjsjYdOyM87U2q+W7GnbL9O60H1JvP1tqtUwC17pq0QUKlJGGFN
         sWMUAQ6mL7j2Ri0G2lAaq8qFlqCPJeoyQWrFaE/QUnYuSEaZMdxtM0dVjt21cYb+NRtR
         fIyDlqZyNiUL5N4kihdoU22vynJr6u3AsCP9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321510; x=1686913510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dBeyJPRhXrYoMdL7UNGXjkGvgsaNG56xw0crWEgD48=;
        b=O4TRgiQzotiW3gcV+aEwnfBJ5xbMLWCaD0PZPxbDZAhveDYIsjDE7OrxNNiH9yRyw+
         f37yy7X1IUP/cu0b1ydNFiTb9V74hjPQP0NzecacwgzVzsq5MEL9TRKxATpKygl/9MA2
         4esFPOwXpqfLhtm0AsnhX4gCeapkJKSkSFFrutGBWz3b9vaByellpQTr13mhSJPqD0lt
         FdHKiXpARu463ywnsaUfq8wj6tl12X+jR49CGR9LqBi3kqaVd6quSVc2Crn0k8TijCyL
         Zr42s+H5as5kPY1cgf6gSK4apPcJFMMoEXyHfZpxpQk8Q0wpKR+tUYlOfvOpTnzOCdvp
         y8lg==
X-Gm-Message-State: AC+VfDy6a59uJGPrsW9bHx/BNnQb+w9cRY5+W0P6NMcGqMmUrTmhGdf+
        dKdT87mOzkYTCm6yYjpRrLNx1A==
X-Google-Smtp-Source: ACHHUZ59gWUw0K3SC48NuPVRI9YGaVxsWqMaxdfEEeT3DVeqP2cx1W2fGL4BWa7WNY3bj92hc4UihQ==
X-Received: by 2002:a17:90b:1e41:b0:250:a6bd:cb4a with SMTP id pi1-20020a17090b1e4100b00250a6bdcb4amr29708157pjb.29.1684321510346;
        Wed, 17 May 2023 04:05:10 -0700 (PDT)
Received: from google.com ([110.11.159.72])
        by smtp.gmail.com with ESMTPSA id ck6-20020a17090afe0600b0024ffa911e2asm1281337pjb.51.2023.05.17.04.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:05:10 -0700 (PDT)
Date:   Wed, 17 May 2023 20:05:05 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     HexRabbit <h3xrabbit@gmail.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix slab-out-of-bounds read in
 smb2_handle_negotiate
Message-ID: <20230517110505.GB20467@google.com>
References: <20230517095951.3476020-1-h3xrabbit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517095951.3476020-1-h3xrabbit@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/17 09:59), HexRabbit wrote:
> [ 3350.990282] BUG: KASAN: slab-out-of-bounds in smb2_handle_negotiate+0x35d7/0x3e60
> [ 3350.990282] Read of size 2 at addr ffff88810ad61346 by task kworker/5:0/276
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

[..]

> -	if (req->DialectCount == 0) {
> -		pr_err("malformed packet\n");
> +	smb2_buf_len = get_rfc1002_len(work->request_buf);
> +	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
> +	if (smb2_neg_size > smb2_buf_len) {
>  		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>  		rc = -EINVAL;
>  		goto err_out;
>  	}
>  
> -	smb2_buf_len = get_rfc1002_len(work->request_buf);
> -	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
> -	if (smb2_neg_size > smb2_buf_len) {
> +	if (req->DialectCount == 0) {
> +		pr_err("malformed packet\n");
>  		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>  		rc = -EINVAL;
>  		goto err_out;

May I please ask where out-of-bounds access happens and how does
`smb2_neg_size > smb2_buf_len` fix it?
