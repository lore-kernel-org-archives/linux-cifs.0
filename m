Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8171C77B7D
	for <linux-cifs@archiver.kernel.org>; Mon,  8 May 2023 01:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjEHBFO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 May 2023 21:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjEHBFN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 May 2023 21:05:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6DF100F0
        for <linux-cifs@vger.kernel.org>; Sun,  7 May 2023 18:05:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24e25e2808fso3643476a91.0
        for <linux-cifs@vger.kernel.org>; Sun, 07 May 2023 18:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683507911; x=1686099911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mRS6snNN4aNwfeU7otD6/Z6wTNPRLeOOEZEBPPGnjVs=;
        b=WwYmdjL6aIpMWX6XBrDWujG7QJcZVVn0zggl16jkLp3nq4H9bl96dC7oWhNvpi6tdp
         7T231Z66IjvioKe8+t9xGDxYRCH2GRT4bhVJmeB89kyj8jJPZjBNNxgMbUmNmMf8huoX
         ResMDHieKeoqCL5qpcZh02w7PilOjGzfS/e/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683507911; x=1686099911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRS6snNN4aNwfeU7otD6/Z6wTNPRLeOOEZEBPPGnjVs=;
        b=bDJSGBEKt+nd+R2dtYbAj2d5m4sDFCaKOt6AIyVolmGosanzgtj4rDipwGmCfaV+EN
         RnVwgZNCnYRpsN79XlMn4X01UAz8m81gua9cbsuNw3oATJlBmPdLk7aav76PksH9q0Uv
         VySwKnBuIYgh5yVY4XNTwC5q6Ib1vLytAe7m/Cqrw4qJkWerQJbCQli3/QxMgq/uDrD8
         nO2PueD8OLfxYdh5uEJunkMUO7z2jDFhYNvniWkmoOcSmx2W0TcbZxwkpOe0w3hbJcEs
         sglRo7n89np57/PnMEGmyKJGa3jmcNUmLQaoWX1zmuwSlDZ5lV3xDQ9bY8A6fLNPDCI4
         cjGw==
X-Gm-Message-State: AC+VfDxWQj0bZE/K/UztdlrFj75dhh7gkq/tyfcc2+AA7vLzkqzoT1n+
        aKn1Obespy0qq4UjEYPo8LXoMlVdWtXBNWW0iOY=
X-Google-Smtp-Source: ACHHUZ4f6MTVP4WXLA5C+oky4xRzxxucNTuqoCvbB4fMcSphFI/YOKjscOv47VXlxh6Ce/ZA5xmbqQ==
X-Received: by 2002:a17:90a:fd8e:b0:250:2922:1f3c with SMTP id cx14-20020a17090afd8e00b0025029221f3cmr9217533pjb.33.1683507911457;
        Sun, 07 May 2023 18:05:11 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id gp24-20020a17090adf1800b0024e227828a9sm3712510pjb.24.2023.05.07.18.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 18:05:10 -0700 (PDT)
Date:   Mon, 8 May 2023 10:05:06 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Pumpkin <cc85nod@gmail.com>
Subject: Re: [PATCH 1/6] ksmbd: fix global-out-of-bounds in
 smb2_find_context_vals
Message-ID: <20230508010506.GA11511@google.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505151108.5911-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/06 00:11), Namjae Jeon wrote:
> From: Pumpkin <cc85nod@gmail.com>
> 
> If the length of CreateContext name is larger than the tag, it will access
> the data following the tag and trigger KASAN global-out-of-bounds.
> 
> Currently all CreateContext names are defined as string, so we can use
> strcmp instead of memcmp to avoid the out-of-bound access.

[..]

> +++ b/fs/ksmbd/oplock.c
> @@ -1492,7 +1492,7 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
>  			return ERR_PTR(-EINVAL);
>  
>  		name = (char *)cc + name_off;
> -		if (memcmp(name, tag, name_len) == 0)
> +		if (!strcmp(name, tag))
>  			return cc;
>  
>  		remain_len -= next;

I'm slightly surprised that that huge `if` before memcmp() doesn't catch
it

		if ((next & 0x7) != 0 ||
		    next > remain_len ||
		    name_off != offsetof(struct create_context, Buffer) ||
		    name_len < 4 ||
		    name_off + name_len > cc_len ||
		    (value_off & 0x7) != 0 ||
		    (value_off && (value_off < name_off + name_len)) ||
		    ((u64)value_off + value_len > cc_len))
			return ERR_PTR(-EINVAL);

Is that because we should check `name_len` instead of `name_off + name_len`?
IOW

		if (name_len != cc_len)
			return ERR_PTR();
