Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C909C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 01:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802D861247
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 01:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350800AbhJABDe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 21:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhJABDd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Sep 2021 21:03:33 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B165C06176A;
        Thu, 30 Sep 2021 18:01:50 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u18so32649404lfd.12;
        Thu, 30 Sep 2021 18:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D+yM4mb4R4ftDgNZNH/Nen5f0X3rBwJtyETtRdq6+8k=;
        b=LWkYaOLcb/wX7NjIGEpBFWeQbXfBVDW06YfiUWGNOTDBEcYprWRQhMdSNGsYcVKRVo
         dIySEcS6atp26YPs2C57d/KesUn76yRovpn6/Uddc85mNB8VpPp1r7zVBvCtq/nhci0S
         HivDVLA9pt0yeYmr7uJsR62u1HAWeNZre1PH80BbC0pDVT3SnZ+73Sp1gTg/SvT+usph
         0jeLmYD0WTEBiUodATk3d6rolko5xEArtdvYXgRGuxJXqwo+q1FjZezjDZB2feIS+dTo
         RL3HYXeqm362IHod8hePP1V72a7mr9YNkllNdikLdBVh/l3/z0DAqaCHQHBxQ03nwRET
         uMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D+yM4mb4R4ftDgNZNH/Nen5f0X3rBwJtyETtRdq6+8k=;
        b=qVtWZ3mLv3oMs06IN3YcE2sH7Z3bJWUkVnXieWXxIkh9I7hHUnRLMnimmphk7WToT+
         DcyDqjFJ4l2yYb7WhSkH6seCdeg0bbT+DzfbL1dNOnapaFutVw5nNkdpJlcevRqwWNfk
         6m1CRDq1YL/9NvATaaTStA13bovpk2KWsrBinAsldJEvq/KvlI4stYYkFCxmQvA7PJZ1
         LJ3rdZnNXTmavjEJCgep+jPr4NUdUa7X4R2KwocxTduXfXsakkNw0DzFQR0IRVjaFOhz
         0smO7w08xjv6H4C1hMYiAFVWWEC9Tzs2kE8jUhNlVqfIdRgjS6IG1N7bjD+uyZKS8nFE
         trAw==
X-Gm-Message-State: AOAM531k+L0NxfZLrU3swZNiY940mjo4pjK9SqhhqGOsdyrnGlmFz/Xp
        6GLSE0CjIseY2V2xZOTc+R8mrK+sqp/FsycXJFepwMKq
X-Google-Smtp-Source: ABdhPJzwjb30UfsfswPAZwkzOkOELLG2leewCfDBZEgHey7tYsVQReVMadVCDDlsrpLcjqSIdE3+Z2THgn7Rp7eZamg=
X-Received: by 2002:a05:6512:dd:: with SMTP id c29mr2297630lfp.601.1633050108366;
 Thu, 30 Sep 2021 18:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210930122456.GA10068@kili> <CAKYAXd_VNuyn7HAfnZjkxhGQUnwgCYXe3xTuOEE=P+h6kyQoSg@mail.gmail.com>
In-Reply-To: <CAKYAXd_VNuyn7HAfnZjkxhGQUnwgCYXe3xTuOEE=P+h6kyQoSg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Sep 2021 20:01:37 -0500
Message-ID: <CAH2r5mvJS1G8Ay9AM4B99=HX5uGzhdefAsXtRYav0Y0RJJZWfg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: missing check for NULL in convert_to_nt_pathname()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added the acked-bys and pushed to ksmbd-for-next

On Thu, Sep 30, 2021 at 6:23 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-09-30 21:24 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> > The kmalloc() does not have a NULL check.  This code can be re-written
> > slightly cleaner to just use the kstrdup().
> >
> > Fixes: 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of share
> > access")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>
> Thanks for your patch!



-- 
Thanks,

Steve
