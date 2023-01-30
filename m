Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3359C54EAA
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Jan 2023 04:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbjA3EPm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Jan 2023 23:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbjA3EPl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Jan 2023 23:15:41 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518A32718
        for <linux-cifs@vger.kernel.org>; Sun, 29 Jan 2023 20:15:40 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g68so6752852pgc.11
        for <linux-cifs@vger.kernel.org>; Sun, 29 Jan 2023 20:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=58GLUmzTwYb3qKKyCXh7E1D5tYRikGavhnZW7KqYzpE=;
        b=gSPhxMatcRxlJNQTaNoO6CpIY0C7E++sw3LR0QtT3JAJaIXywGAEKdedJ5mzQrPKpX
         hazv2Hq785/5a8RQj1APm1FzRM2DYSuOVaMIRKisKUIl7RSzrQfpMVqW+ZJrMmJ4Gkh4
         XwxHhvWHx88Wpwr7InkhRg6JQfR1nh+eEO+2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58GLUmzTwYb3qKKyCXh7E1D5tYRikGavhnZW7KqYzpE=;
        b=r4Rv+rcnoYPIaX5lc+Pxkpd9J4jcytTqYEpuS1xgFzf5uGhZ4bc+w+KLoU4PgZOCZr
         LsAbyFbtnLuByho9p85bk+VQd7UXrjDSie9oiPkhPn27/vRNyknHcgFYoZMkHOBT77ac
         dVHQvZ1SfviV9aQ5ve16NBopvNuua1OBjZl765orKxMeUMRe4vq+Nmo9j+Bpil9m3jVw
         el27VXqHWgadxJE+YiCy9X93hF6PYI0dHLwPAj6IRLs79F4rDFymwIgzCbar/USBwlBH
         VBlSbuPrqwyScbuRSLSXzNY6NYn/uVeUhmJi+MGkM2+23haMvHbDBpEFrdP7czxdCwIO
         xSLg==
X-Gm-Message-State: AFqh2ko23AkH8cNNOZR+u9DLPrgZePaJYb/khVxoYakYZ9s5eeGNnNHE
        f8TBh2z9clN2oJdzvoPOAFWTWuzFcFtjZtvX
X-Google-Smtp-Source: AMrXdXtSroPaEaFc2L+7weTBDxXFdF7qQ0tQjiHbzWP9rqBjgIaTTgNfvbGeseX41UKAeS8rD65aQA==
X-Received: by 2002:a05:6a00:24d4:b0:57e:866d:c095 with SMTP id d20-20020a056a0024d400b0057e866dc095mr58185827pfv.25.1675052139722;
        Sun, 29 Jan 2023 20:15:39 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id z2-20020aa79f82000000b00593c679d405sm809537pfr.78.2023.01.29.20.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 20:15:39 -0800 (PST)
Date:   Mon, 30 Jan 2023 13:15:35 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dawei Li <set_pte_at@outlook.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ksmbd: replace rwlock with rcu for concurrenct
 access on conn list
Message-ID: <Y9dEZ5IgfwpZNlVm@google.com>
References: <20230115103209.146002-1-set_pte_at@outlook.com>
 <TYCP286MB23235FDD8102162698EF3154CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCP286MB23235FDD8102162698EF3154CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/01/15 18:32), Dawei Li wrote:
> 
>  void ksmbd_conn_free(struct ksmbd_conn *conn)
>  {
> -	write_lock(&conn_list_lock);
> -	list_del(&conn->conns_list);
> -	write_unlock(&conn_list_lock);
> +	spin_lock(&conn_list_lock);
> +	list_del_rcu(&conn->conns_list);
> +	spin_unlock(&conn_list_lock);
>  
>  	xa_destroy(&conn->sessions);
>  	kvfree(conn->request_buf);

From a quick look this does not seem like a correct RCU usage. E.g.
where do you wait for grace periods and synchronize readers/writers?
