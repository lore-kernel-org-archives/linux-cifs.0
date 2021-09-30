Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D28C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 23:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3970619E7
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 23:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350150AbhI3XWq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 19:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350178AbhI3XWp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1FF7619F5;
        Thu, 30 Sep 2021 23:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044062;
        bh=pwMFTpu6UjMcXbczxPhkqI2dpzFuWUbNB/t7W5OpaUk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=i6a5a13v6vDiB2Z5Zp6f7xmWyNmrl9VXiKI9/alh1UHim7O77DxfqE70YBhmQJwJJ
         mjztSqouqO0K/W4L50ZTMibiR46vwkdObyH8sKjcaIuIvD4qDRmMgKvWmULDvRcBV3
         BDosO+9vdWUqipY0Lan2ZN0kbFdrXqQYnU8V2sWW+pPrD8QxyfgrDOnR8Mxmdwz/LV
         jAUOLEzNMSd6FTDcEkS9UqPDWk2law8ldJZrp/gFpNDGYkGtGP8rFLam5SJF40hzK/
         opfEvkYLtpBcPNmp6oYWMGYtwcSg8sLQ8f/vkZXh+gw27n5yOebS+fDrAB3gDj+9ac
         jTHBQWLYNyhaA==
Received: by mail-ot1-f49.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so9343677otb.10;
        Thu, 30 Sep 2021 16:21:02 -0700 (PDT)
X-Gm-Message-State: AOAM532odo3iGB5AxIg9gzDCkxtOU7zVK7C2zU0rBRQ/9Bu5ddvVknRA
        DM5uDGJdhE7DrJrLpkUah2HYoBOhAl/loS4isY8=
X-Google-Smtp-Source: ABdhPJxrkZF8lbNaQWxg6uwD/gNrY0Ney582MtT68kXjQP+VBqZBUsm8Z6fc6dWFyZqKPc5qsGoyuZ+XBjO90S4OFDM=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr7213571ots.185.1633044062043;
 Thu, 30 Sep 2021 16:21:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 30 Sep 2021 16:21:01
 -0700 (PDT)
In-Reply-To: <20210930122456.GA10068@kili>
References: <20210930122456.GA10068@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 1 Oct 2021 08:21:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_VNuyn7HAfnZjkxhGQUnwgCYXe3xTuOEE=P+h6kyQoSg@mail.gmail.com>
Message-ID: <CAKYAXd_VNuyn7HAfnZjkxhGQUnwgCYXe3xTuOEE=P+h6kyQoSg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: missing check for NULL in convert_to_nt_pathname()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-30 21:24 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> The kmalloc() does not have a NULL check.  This code can be re-written
> slightly cleaner to just use the kstrdup().
>
> Fixes: 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of share
> access")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
