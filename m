Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22473C001DF
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Jul 2023 23:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjGZXwy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Jul 2023 19:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjGZXwr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Jul 2023 19:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9B81FED
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 16:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14E8661CE4
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 23:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71170C433CA
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 23:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690415561;
        bh=t1oqI0RKnEmgPVxsjEtHStOpnbgO9rbhHrEa76azBfI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jxW7pBHjIk4Sc3oOOT841DN0ViEFYT/d93ATFbZnpOH6U1UcvaPBsS04b4COMHlPd
         +gR+a2YTerVSJrwdlZPJCvAMCeb07QkFPdjExcFCxRLqqdmAW17O3ZV7JDndwaOepa
         xx5qpuCBse79IZC2kaM8g7RfetohosEXxE0VuO1xS3HuUlZl2GRDWo1nq9Pg3gOg0q
         0NeNfMmGJLnklSqe8/YOnNhMGc4na23ltO2kISmpEYZXzXSsd7EsGt0PUUXq77JVzf
         c7iilhHCs4bbtp780KWeJ1SdkeisbsE/v1j6/QbsZu3fKI9qJWG/WwqaFJn6DYRjz/
         4DJf9HzLX0/IA==
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-56344354e2cso308426eaf.1
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 16:52:41 -0700 (PDT)
X-Gm-Message-State: ABy/qLaqyFBucfVwjnAX8cpP+WVZ07Wgur1a+4QJ09SUMwrOoBbCaIEl
        gyxC/VYz7GVwa15qtJb4mZaYZ5WRRRN6YcESet8=
X-Google-Smtp-Source: APBJJlEhCJUft8LmvtDtgfnJfYhsGBLfOl40QJe9F6XeMT7cQ7I0eN/aCKd6xGAQF/NBBrlskLWMBu0S2qUG3mYaMFs=
X-Received: by 2002:a4a:6c1b:0:b0:566:ecdf:665c with SMTP id
 q27-20020a4a6c1b000000b00566ecdf665cmr2880815ooc.1.1690415560587; Wed, 26 Jul
 2023 16:52:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:610:0:b0:4e8:f6ff:2aab with HTTP; Wed, 26 Jul 2023
 16:52:40 -0700 (PDT)
In-Reply-To: <20230725123147.525642-1-yangyingliang@huawei.com>
References: <20230725123147.525642-1-yangyingliang@huawei.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 27 Jul 2023 08:52:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9_wjaNWhmuVob48zDYQZ6PLH2XajbCxZ5FoCUVdxMyVg@mail.gmail.com>
Message-ID: <CAKYAXd9_wjaNWhmuVob48zDYQZ6PLH2XajbCxZ5FoCUVdxMyVg@mail.gmail.com>
Subject: Re: [PATCH -next] smb: switch to use kmemdup_nul() helper
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org,
        senozhatsky@chromium.org, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-07-25 21:31 GMT+09:00, Yang Yingliang <yangyingliang@huawei.com>:
> Use kmemdup_nul() helper instead of open-coding to
> simplify the code.
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
