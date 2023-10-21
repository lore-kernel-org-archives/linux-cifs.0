Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99366C0032E
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Oct 2023 12:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjJUMHy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Oct 2023 08:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjJUMHU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Oct 2023 08:07:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AAFD51
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 05:07:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E2CC433CD
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 12:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697890038;
        bh=nI4fO19jTVe69LiKV1uHGdIuR+eI7pn7nTzo+cFfuSk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=a9bPxtc/NCDAx4Y+IPyEk7CxQ1yJH4hgHDcj7WmV3cMdFsFEgnDh+mLMOHU9zi2yR
         SUTDCsRW7SL8EFbYHIJ7aqH2RBik79aPhNk9G7r/ez3QmU5qIDf4PuRPxhE8w/akwQ
         5B008mNKPZb6/lGlAQAIQkJd4CBVe4OZThjkXQ5MEvtbFl8Ig11bJAiNya9uGzWcGM
         wpa6bOqHAcZvFb2xFSasc5VfwEKgnpx80NRT2BWJH0HY5XKx893TS2J0FztEX7/0jF
         cxJNNChvzNI4rngALk5gfaRfVwgQDVBiv+42HU5PO4XStYu4VQqGfrlgqCf2YAxySq
         6QncUIpFXw9mQ==
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-58111e624bdso1051593eaf.3
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 05:07:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YzHHwps8OYnRfJwc6NW2mkzyGLB4YO6n3s1qumK9h9h7uos4jGY
        wvJuCQypCKY899zoCQceIUqD06jFJYQrH6PiUbg=
X-Google-Smtp-Source: AGHT+IFBc0xJHl8Oenmr+H/id3D6o3QGMKPSz5NjTkclqhhIFtU17cIYsAyhwE7dPGC4aUWGtg0HCP+cC0PAV0+pznU=
X-Received: by 2002:a4a:e6cb:0:b0:573:4da2:4427 with SMTP id
 v11-20020a4ae6cb000000b005734da24427mr4211060oot.7.1697890037491; Sat, 21 Oct
 2023 05:07:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:347:0:b0:4fa:bc5a:10a5 with HTTP; Sat, 21 Oct 2023
 05:07:16 -0700 (PDT)
In-Reply-To: <20231021074207.1066986-1-huangkangjing@gmail.com>
References: <20231021074207.1066986-1-huangkangjing@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 21 Oct 2023 21:07:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd86EeMnuQOZ-R+TTfdrhtc_fopVpwXuUMF-23yjvP3Gmg@mail.gmail.com>
Message-ID: <CAKYAXd86EeMnuQOZ-R+TTfdrhtc_fopVpwXuUMF-23yjvP3Gmg@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: fix missing RDMA-capable flag for IPoIB device
 in ksmbd_rdma_capable_netdev()
To:     Kangjing Huang <huangkangjing@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-10-21 16:42 GMT+09:00, Kangjing Huang <huangkangjing@gmail.com>:
> Physical ib_device does not have an underlying net_device, thus its
> association with IPoIB net_device cannot be retrieved via
> ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
> ib_device port GUID from the lower 16 bytes of the hardware addresses on
> IPoIB net_device and match its underlying ib_device using ib_find_gid()
>
> Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Reviewed-by: Tom Talpey <tom@talpey.com>
Applied it to #ksmbd-for-next-next. Thanks for your patch!
