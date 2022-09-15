Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CC9ECAAA1
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 13:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiION3t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 09:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiION3s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 09:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFB0BE3C
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 06:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD492623D8
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 13:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26157C433B5
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663248576;
        bh=8Fzi5gyC0HOJ6bRDK0OgEwIHq8DogyDKTeFddFKR3rI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=qL81RtpI4UfwGqnYY8U1nyEPtGWpacm8dd+ZCUv3nW9XJDMPv2EOWl/OiuNS64sRW
         QnqiNNOxsTdKSBh4SzxGIZes9jUa5WFSwV1HpB3DmqTCsyNIf+4mXaBYnVqMWOokvF
         hc2qRBBu3ZYQ5f6BF8QgWVMdlplUsNgR+eY6y29bIZIt0rBdyjyeGQeOLL0Kp7XhRq
         YXBMqqhG3VTD5ghbFxp3zNu02W36PXTR++sLwEKdaHpOXywcxZQVAyw41sqnN//mEk
         T3Q70QjUPBZ+KGD3Jq4xjf27ZDt4MGF+xzuHaaa4ToL3pClgz1V0z2lzkLOylW7PkC
         +HdLEG4toXirQ==
Received: by mail-oi1-f170.google.com with SMTP id n83so2209195oif.11
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 06:29:36 -0700 (PDT)
X-Gm-Message-State: ACgBeo2ptaEwWvagY+POmGnwsbFjaVIJcpw/T04GTtQkrQnjkv1e0WEg
        TuZJ3Nkk2/cqrJQmYxksNt5nsgdE/rppbsDqPNY=
X-Google-Smtp-Source: AA6agR7kRmiFrBSM/HpIph+XdowSnIBh0NmTYRz5VDzU6XVu/cRLYFZdVFmj/taPxn1IOLjayXUq0Z7/EM8REtxIh3c=
X-Received: by 2002:a05:6808:14d5:b0:344:8f50:1f0f with SMTP id
 f21-20020a05680814d500b003448f501f0fmr4376250oiw.257.1663248575248; Thu, 15
 Sep 2022 06:29:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 15 Sep 2022 06:29:34
 -0700 (PDT)
In-Reply-To: <20220909105119.955332-1-brauner@kernel.org>
References: <20220909105119.955332-1-brauner@kernel.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 15 Sep 2022 22:29:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_kmaPz0R2p-U5x=Nk0dKYt70+Uu5CuNyc+-Oa7cPzYaQ@mail.gmail.com>
Message-ID: <CAKYAXd_kmaPz0R2p-U5x=Nk0dKYt70+Uu5CuNyc+-Oa7cPzYaQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: port to vfs{g,u}id_t and associated helpers
To:     Christian Brauner <brauner@kernel.org>
Cc:     Steve French <sfrench@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-09 19:51 GMT+09:00, Christian Brauner <brauner@kernel.org>:
> A while ago we introduced a dedicated vfs{g,u}id_t type in commit
> 1e5267cd0895 ("mnt_idmapping: add vfs{g,u}id_t"). We already switched
> over a good part of the VFS. Ultimately we will remove all legacy
> idmapped mount helpers that operate only on k{g,u}id_t in favor of the
> new type safe helpers that operate on vfs{g,u}id_t.
>
> Cc: Seth Forshee (Digital Ocean) <sforshee@kernel.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
