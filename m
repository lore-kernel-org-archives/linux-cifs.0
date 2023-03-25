Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEE4C6FD1C
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Mar 2023 08:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjCYIgK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Mar 2023 04:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjCYIf4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Mar 2023 04:35:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6139A4C37
        for <linux-cifs@vger.kernel.org>; Sat, 25 Mar 2023 01:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A0C5B802C8
        for <linux-cifs@vger.kernel.org>; Sat, 25 Mar 2023 08:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5FDC433EF
        for <linux-cifs@vger.kernel.org>; Sat, 25 Mar 2023 08:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679733346;
        bh=DG5bcWfwEWhKR+0zen5izh3M5JO/e2NW0uacSnkDOUo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Bo3JHJrxkzdTa36cIQqQFRu3PgNrFZvhoNMXOMjRFQACFMzrNY6dFxnfCcIhtoVKT
         Ly6zWhg/MJ0T64BoMzaFw4LrLw5EIxiwsxXLX8pqo/84S9U/cy1ykBv+hCzVlrTo90
         3cFwM27R77ZDfxWsfAqJ7Dm1T4R7Xq4DhkxnOMogLl2lMNd3z2UW4ARfl63qRP3api
         F1wVIpXXki9ONmmRXQk/yOqnVVCHxVJnnlv2jFdab8HwPexzMeNnaSueBkcex4RIP0
         x6l4zT1u5bf06gHPXpMIhsq9lPENoUzferdCLkGrW2cDNlaoush1Gn0YOUTK5h/HPh
         iABIRdUJHZFWg==
Received: by mail-oi1-f180.google.com with SMTP id r84so1662441oih.11
        for <linux-cifs@vger.kernel.org>; Sat, 25 Mar 2023 01:35:46 -0700 (PDT)
X-Gm-Message-State: AO0yUKVhMOc1dRLsOoOc0I0nXRirBXf4IB/p/noeRYcbICMzpN8ydCyc
        rQYpIfahqRffQID2u25AnZLQB8hjhlJS3iIGeDA=
X-Google-Smtp-Source: AK7set8miQkYueXUUo5HNlklR258MBTDDsb+9+vpBTcC79TV62Byclk/WSAOlrJsM9E/MIWWkVGw/uVgm5/LLBGAeQM=
X-Received: by 2002:aca:1b09:0:b0:383:fcba:70e6 with SMTP id
 b9-20020aca1b09000000b00383fcba70e6mr1280099oib.1.1679733345295; Sat, 25 Mar
 2023 01:35:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5713:0:b0:4c8:b94d:7a80 with HTTP; Sat, 25 Mar 2023
 01:35:44 -0700 (PDT)
In-Reply-To: <20230316134043.1824345-1-mmakassikis@freebox.fr>
References: <20230316134043.1824345-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Mar 2023 17:35:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Uffg4b=-tWVE+a8xyDUVv13V2VqyNDhsUzQAVD02x3Q@mail.gmail.com>
Message-ID: <CAKYAXd-Uffg4b=-tWVE+a8xyDUVv13V2VqyNDhsUzQAVD02x3Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-16 22:40 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Commit 83dcedd5540 ("ksmbd: fix infinite loop in
> ksmbd_conn_handler_loop()"),
> changes GFP modifiers passed to kvmalloc(). However, the latter calls
> kvmalloc_node() which does not support __GFP_NORETRY.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
This patch fix generic/551 test. I will directly update the patch description.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks.

> ---
>  fs/ksmbd/connection.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> index 5b10b03800c1..54e077597f4e 100644
> --- a/fs/ksmbd/connection.c
> +++ b/fs/ksmbd/connection.c
> @@ -329,10 +329,7 @@ int ksmbd_conn_handler_loop(void *p)
>
>  		/* 4 for rfc1002 length field */
>  		size = pdu_size + 4;
> -		conn->request_buf = kvmalloc(size,
> -					     GFP_KERNEL |
> -					     __GFP_NOWARN |
> -					     __GFP_NORETRY);
> +		conn->request_buf = kvmalloc(size, GFP_KERNEL);
>  		if (!conn->request_buf)
>  			break;
>
> --
> 2.34.1
>
>
