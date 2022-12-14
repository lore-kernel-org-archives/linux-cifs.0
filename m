Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C53C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Dec 2022 04:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbiLNE7M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLNE7K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Dec 2022 23:59:10 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8105D22BD2
        for <linux-cifs@vger.kernel.org>; Tue, 13 Dec 2022 20:59:09 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id v11so5517886ljk.12
        for <linux-cifs@vger.kernel.org>; Tue, 13 Dec 2022 20:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AkHTjbFTE4B9gk6maXDD1B13DWlXW3IkznpvbVqmGb0=;
        b=d4PsM3Zp+/9cMM7zYMp0df1GAm0FtVi79ZK5exzsEnWqZ/647L4TD27kfB/u/Iu/Wz
         gaiIsGBWlip+7E0Zu9nTQJQWckEv5ajSxUVGh0LHh4MnajVDt2Q+Phbj13L9tJeNsD7r
         jJTjEndhy6JlesP9ppKG59kNHBjhoXJJ7sXhuteK9mSl8SsixGJZPmj4LvytrGoZBqBA
         iV+P5JoyhczPsla92XptgItuIjSVAYXi8O2qIdgdW0BIE9g1e7zOfQtYgGEZdcQ5F9xz
         zy+j6Z5fLqluuPmcDEQeJox9zH2x+D+ts4SoG10fF3HpoiNnUr8ruCkoU5AnAVwir8NH
         RNrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AkHTjbFTE4B9gk6maXDD1B13DWlXW3IkznpvbVqmGb0=;
        b=0w5qT/FKzL4ddQy3QaqwsE0aorSmjcScG1RVpRYpiE30/UNtTnZhH32cbGOe+CLTgn
         Vv/E1GfupGYnYkLcI4tzoUDi4zvW0CTWSZm/qXNrLl1HOEG4EjAlCI0lVNyS25AdjRbh
         LTAym9amV7pwj7QYEEDvG8kiUC4yLgTTVZR7daKLUwsJG7UXRdJCw/VkOs5pD+sbvwEJ
         cvDzVeHvkjSXQezWdtk6Ozv5wUtNNUoO77AW/0U0QNMQUU/Yi2U2ILX6nfIx9fibeMXo
         y4WEgVPAbtb35/Vucrfy1dNSyeSS0OJ2WlQBJh3BcdmDC615cot9alwlZGBNHVrpO4tl
         a2hQ==
X-Gm-Message-State: ANoB5pnNdZOWc5jJgg+TtA7T0Qz1NQ4K3r3+aL6l9hO+JI4c+ygSQ+lJ
        EMLw1QoCgF4744GIBrBzQ4oxo511stfwWJh/Bjd2tX/bKp8=
X-Google-Smtp-Source: AA0mqf5y+6PCw0wQM3WMgbVhxPk3QZa845YLXCCJtkzpJrmUqzp6TfIDbCTvg5kQ6Q5UZqsL+7WMWY/SIrde1GmHVN0=
X-Received: by 2002:a2e:a90a:0:b0:26d:ccb6:1d47 with SMTP id
 j10-20020a2ea90a000000b0026dccb61d47mr27345823ljq.199.1670993947746; Tue, 13
 Dec 2022 20:59:07 -0800 (PST)
MIME-Version: 1.0
References: <20221214023911.85141-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20221214023911.85141-1-yang.lee@linux.alibaba.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 13 Dec 2022 22:58:55 -0600
Message-ID: <CAH2r5mtyckeEjGWaU6e2DkXvkU2hbPS4eCDaf_NU3XUvGZNJ7g@mail.gmail.com>
Subject: Re: [PATCH -next] cifs: Remove duplicated include in cifsglob.h
To:     Yang Li <yang.lee@linux.alibaba.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next


On Tue, Dec 13, 2022 at 8:44 PM Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> ./fs/cifs/cifsglob.h: linux/scatterlist.h is included more than once.
>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3459
> Fixes: f7f291e14dde ("cifs: fix oops during encryption")
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  fs/cifs/cifsglob.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 703685e2db5e..82f2d3070c26 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -23,7 +23,6 @@
>  #include "cifs_fs_sb.h"
>  #include "cifsacl.h"
>  #include <crypto/internal/hash.h>
> -#include <linux/scatterlist.h>
>  #include <uapi/linux/cifs/cifs_mount.h>
>  #include "../smbfs_common/smb2pdu.h"
>  #include "smb2pdu.h"
> --
> 2.20.1.7.g153144c
>


-- 
Thanks,

Steve
