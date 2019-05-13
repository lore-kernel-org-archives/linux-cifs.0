Return-Path: <SRS0=ZeIh=TN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB38C04AB1
	for <linux-cifs@archiver.kernel.org>; Mon, 13 May 2019 04:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6F8F208C3
	for <linux-cifs@archiver.kernel.org>; Mon, 13 May 2019 04:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o7QFSTOc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfEMEh6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 May 2019 00:37:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41223 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfEMEh6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 May 2019 00:37:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id f12so3771974plt.8
        for <linux-cifs@vger.kernel.org>; Sun, 12 May 2019 21:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=uN76rzsR6XIOXkPQKNnLRUo/BDTPg9zCC6/UcXuUZI8=;
        b=o7QFSTOcNm4mQP6iTWPz5iaVt7pBSkI6iLZWZmkGknbBQ93s2E7Vlmyh3HPA8xP6oo
         /6Fd255/GjkWuNiX7xRhMOpcVdswYseXVvEiP24p/ggHJjSjgVgC+o4aXE6dhyhsFCEy
         tgmSMmCGAvIgplqW0cnRubKmednj6JzqV0CQDEra7JCPRIkiVK45NEwUodsdq78sug5w
         G0L4M0lxs3huHu8H7XkfOGlBJXaiwycjWNA5ksmmUWbFJEvLlb7+yi/nT1Bzg3Gtfxrp
         EtAzVr6X9w6KoasJAmlbgTGTvL6qaRP+ajHS7TeYHGTBPAZIpk8oHKXr06E2KoFYrQt1
         l8mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=uN76rzsR6XIOXkPQKNnLRUo/BDTPg9zCC6/UcXuUZI8=;
        b=gnUfxQyPzj121fr01z2lMfDzQxTUIgDuDOnFetRlJqtiqwPVZEHp49N+pJ62zyVEYv
         OPyK0EYZ20zGlYxlWMDMldmnSbhzuCdMLSiaLHi/h3ijJPuSqvuNJgFaVxsGgS0V+41N
         WRLiQpSSQ54bcL/Mtl5htmPGSVO8BwvlJEn+7jLf3iBFs2qvMSopHtybMM8NRV3uZ2U+
         mn9F6hyWklXh00JYrs73igYtOrHCrnGe3f4PNbjYk79udpEXSNnvHYSPX8kj9rsZzJ+v
         FwSoYJyGNTNuKgJfscZ9ujo6vG8WRtnzhLHV9CqJZBv+yDBxsY3izqx8amvKHH1hMqDa
         wGjQ==
X-Gm-Message-State: APjAAAWBxOgreJD2AyMSPzGZaCwgpyhOzMhzHhuJfI2Ula4iIXtaEd9b
        sOBc7k1tMcI7oMTfv6Na9ToKals4tI3m2LFk580wJw==
X-Google-Smtp-Source: APXvYqzAxKXk8qNPvQJSmFIe1zIzeaDumv69YbLhctsTZtma175UMwn0QdHdnuzA5PFsY0h5UzqinImBrj0dO7oNSA0=
X-Received: by 2002:a17:902:2beb:: with SMTP id l98mr26268794plb.290.1557722277234;
 Sun, 12 May 2019 21:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190513012417.2603-1-lsahlber@redhat.com>
In-Reply-To: <20190513012417.2603-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 12 May 2019 23:37:44 -0500
Message-ID: <CAH2r5ms4b_BDu9W3nTiYZopWS-A8Vf3s=vnOx3iJHNP+mgL1KQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: use the right include for signal_pending()
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cif-2.6.git for-next

On Sun, May 12, 2019 at 8:24 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 9a16ff4b9f5e..60661b3f983a 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -33,7 +33,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/processor.h>
>  #include <linux/mempool.h>
> -#include <linux/signal.h>
> +#include <linux/sched/signal.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
> --
> 2.13.6
>


-- 
Thanks,

Steve
