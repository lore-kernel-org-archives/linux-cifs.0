Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33899C352A1
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Dec 2022 04:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiLFEmp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Dec 2022 23:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiLFEmp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Dec 2022 23:42:45 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763725F99
        for <linux-cifs@vger.kernel.org>; Mon,  5 Dec 2022 20:42:42 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id p36so17496267lfa.12
        for <linux-cifs@vger.kernel.org>; Mon, 05 Dec 2022 20:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EmQnhFLYiKVLZ0sQxBjLXkPoOHHxOBv8/dLLVHr33BU=;
        b=nbnCJFb1UM/7eT5kl6UMan5FW3VaziTWa7/nh//braawBcn5TqWN5D8jS6B/T5PBQI
         U/ar8Z3PHZvRjKV4ipKi6wOpDMWCfhb1AvPbhdxB44wvET2KvyUiF1H4yGH4wtpLDfXU
         BR+PZKFAbNp2zkjKy3T00mKrkCScomK40jeKmHYuW/EMisVUUiRxDZY+RR4G56ulbbv0
         QJcI8fK6ah2zzRNVOYwVdFx3N1uy21GgZkQqLuqGun8ZgHkJLTp+o03FER/tKMXenjsW
         0eo4UKQtbTP4W0UN+S+GSyugZv/VEF02nPzlFBZ2AtCkBk/KGCQmFyECI/+la6mzFeIC
         bR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EmQnhFLYiKVLZ0sQxBjLXkPoOHHxOBv8/dLLVHr33BU=;
        b=AKwwLVDkcaNu6TDKZ8cDW6QAIWc+Bm11BXBsgTELy6kBxs+DNCgheZJhL+wNBj9Nou
         k8t7nQr0FFLHbfl2PFfDyWqNwVA/XNTpd+yoOPV1aXn8EeHX3aM7vRnHtxjQzWw6Lmo5
         pePZEhzjvfXbZeaUSrGqDSQKbG3O4dUH+Hf2w1JOwWDUr80gn5bqGemFWbHlhiJ0baGT
         C8ugepd6qFBXKWxbo6Pjudpgtf7RPxq2P9Zv+SLyhkDX18VXh8ACi/FJh0K7ML6yPOZY
         YDNZeC+i3Cuc712B5mgE5OqPyfD3Kw6sixoJEL4Gd4DcYua/Nbkj36AJbQeyxh5FDAo/
         QjwQ==
X-Gm-Message-State: ANoB5pkr6m6tjuFeWG7z3JaG46u0otSQvVUgvkmzrkLJh0Xxian/lJzx
        k4aVArqYihP71OJ3U9EvfjWL6B/AEsgUPyTnIX/Q+U/jmjY=
X-Google-Smtp-Source: AA0mqf57OrDVOXhUTa4ozOdA768OvYfpqUnqVu7DvaGpyBAHMk2rQqboIzSXdXhNWfZ8Ec5byIBpUUUbXCHwfPkdrjg=
X-Received: by 2002:ac2:4bd1:0:b0:4a2:4dc3:a2e with SMTP id
 o17-20020ac24bd1000000b004a24dc30a2emr23841388lfq.403.1670301760473; Mon, 05
 Dec 2022 20:42:40 -0800 (PST)
MIME-Version: 1.0
References: <184e4ae599e.dafedd623365931.2204914765704117230@elijahpepe.com> <184e4fef6ac.ef8cabb03371505.6462526642609891535@elijahpepe.com>
In-Reply-To: <184e4fef6ac.ef8cabb03371505.6462526642609891535@elijahpepe.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 5 Dec 2022 22:42:29 -0600
Message-ID: <CAH2r5mvYhYfO10U8QbRVsx03VUnudv-hcQvtqyw4Qt+4ugGT9A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix tabbing
To:     Elijah Conners <business@elijahpepe.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>, tom <tom@talpey.com>,
        pc <pc@cjr.nz>, sfrench <sfrench@samba.org>,
        sprasad <sprasad@microsoft.com>, lsahlber <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

wasn't this problem introduced in your previous patch?  Why not merge
them together since this is a cleanup for the tab problem in the
previous patch

On Mon, Dec 5, 2022 at 7:15 PM Elijah Conners <business@elijahpepe.com> wrote:
>
> Signed-off-by: Elijah Conners <business@elijahpepe.com>
> ---
>  fs/cifs/cifsroot.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsroot.c b/fs/cifs/cifsroot.c
> index f0aba7c824dc..46aaa731723d 100644
> --- a/fs/cifs/cifsroot.c
> +++ b/fs/cifs/cifsroot.c
> @@ -37,9 +37,9 @@ static void __init parse_srvaddr(char *start, char *end, struct in6_addr *out6,
>         addr[i] = '\0';
>
>         if (inet_pton(AF_INET6, addr, &in6) > 0) {
> -    *out6 = in6;
> -  } else {
> -    *out32 = in_aton(addr);
> +               *out6 = in6;
> +       } else {
> +               *out32 = in_aton(addr);
>    }
>  }
>
> --
> 2.29.2.windows.2
>
>
>


-- 
Thanks,

Steve
