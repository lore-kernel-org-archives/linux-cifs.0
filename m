Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D2DC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Dec 2022 15:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiL0PFr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Dec 2022 10:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiL0PFq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Dec 2022 10:05:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C72DB9
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 07:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 001BDB8109B
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 15:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F13C433F2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672153541;
        bh=2fcxw8ZP1mtRGDU+uSz1R24zCeMo3laJ820Eilx25Bg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=BH6BPfUtjN54UkAYjo+IDrlN5wfZqatfM3BmnkiEpoKAKrdlymwQAZAMZmfMmMXCN
         FhpMtYGFLjXvXUpkjSh9Do3W8ukHALy2Vj19rZWGTJ5MUd8RaunIe4rnmDG/UcOahp
         C7YtTDJ28DdElq6Xxs8N3CrDNhNeioAZt5aGWYNyE2SiHzDrp7IvqLMxdBD0/qjlmq
         KCyGP8A7J8V3vlUMXlrU92An3YFhGdmUQT5VRGeWFXOlBaNsDizNHNa4c5my8imNfD
         6wqOSRz9RBFBJ1oR/1+14D7iAM+O5N3iVHh8k2HauBh7ppWFxuOBdO4Rqf2Dj2R0Lt
         +715nNbrRT14w==
Received: by mail-ot1-f41.google.com with SMTP id p17-20020a9d6951000000b00678306ceb94so8328064oto.5
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 07:05:41 -0800 (PST)
X-Gm-Message-State: AFqh2kqR6DgyPLWwTih4S4CViu38VUuIY5TI3WC38YR/uYnMWfwIGqgP
        uA68fbtMgOwDqIa/kXjihfrAA30mxR2C41OCfus=
X-Google-Smtp-Source: AMrXdXt2+PCVFIuzWzLLsIw5TES6ppcpxedqdJeINMhhJ9Ois5BbQSwigLoNq6TU/rwvHUeOT3m3PiMuNTBfogioq8w=
X-Received: by 2002:a05:6830:4119:b0:670:6e9b:2c89 with SMTP id
 w25-20020a056830411900b006706e9b2c89mr1329674ott.339.1672153540729; Tue, 27
 Dec 2022 07:05:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:2d06:0:0:0:0 with HTTP; Tue, 27 Dec 2022 07:05:40
 -0800 (PST)
In-Reply-To: <20221223105930.1405307-1-mmakassikis@freebox.fr>
References: <20221222104701.717586-1-mmakassikis@freebox.fr> <20221223105930.1405307-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 28 Dec 2022 00:05:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_CybBWJBMqpir0FFCU8yw0tkfXXUJDkCrqg=N9FmJBtg@mail.gmail.com>
Message-ID: <CAKYAXd_CybBWJBMqpir0FFCU8yw0tkfXXUJDkCrqg=N9FmJBtg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: send proper error response in smb2_tree_connect()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-12-23 19:59 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Currently, smb2_tree_connect doesn't send an error response packet on
> error.
>
> This causes libsmb2 to skip the specific error code and fail with the
> following:
>  smb2_service failed with : Failed to parse fixed part of command
>  payload. Unexpected size of Error reply. Expected 9, got 8
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
