Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0967EC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 07:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbiDAH04 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 03:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbiDAH04 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 03:26:56 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904FA13F8C2
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 00:25:06 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2e64a6b20eeso23202567b3.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 Apr 2022 00:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wj3YW/G/IvE8TUAMrE530/RnAxc/VZBeNn93nZCCf1k=;
        b=YJtQEOjc1sN24kbz1tnX4xojfokWq7YLFVlSwYdRMSZjNPYy4YXgHZ7vfUqzI34X/D
         juAVb4kyNe9lB2B9iGan18E+KjjlQpJC5reVqUIE/pdHi7o7WZ7BmKa40d4rHwRax1On
         BySm33UTuiPxHtf96vt+1R/IT34Y47g79n+OC05qWBVj7GU6h7US8nO3b+tatiKIHwJH
         rCusFvCAsU1y16pxpoYzRgNT4r3mFbvJTQOTNX21cQs0xR8xzn6cHCrbgPs1TPQXSKsm
         oy66A3ITruUyZYLC+8B8mG/soyBFnIPqVe7mqgqajM7XQ/+UpbbWxx+ENUVy2O4LTQ/X
         D4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wj3YW/G/IvE8TUAMrE530/RnAxc/VZBeNn93nZCCf1k=;
        b=B4dZQ8nxPdaRMtweRUtZNFtybiIQCmUvYwlgoeMgaqpq9kRFnmC6uJEtO/TshF+hOY
         NGgdd6mBTHhzpiG1DTXk/C5onRD1CsdAmKu6v3eAJJn+conaiTTTBrsdktANv72am9Ie
         I/aNYI5s81gh2eBooGYk6jun67RB+hiq2Lm76KsOoYukuWpJqZXMqouUl1ZgV4aR29yt
         0EakBa8OB5iuyalrVdLZmqg1/ji8PxjRJ4GFX0Tq9F63s4HpRiHe41GiC7JaFea0VbMb
         HtVVgpRB79VqIxWvOeHGD1yssMMVI09toJRYUrX1x+Wvuu+4MRgPEVuFfCRJX5la/jWQ
         0hzw==
X-Gm-Message-State: AOAM533L1Um/c7kXV3+emKXsBquimEsspmYDd+EdAeuTlrUSQ44FxDrW
        Mlv1AgJFJwP/IecHcMMWGrIAumJdf4jtrxzL8nA=
X-Google-Smtp-Source: ABdhPJy4DHcY3oV8jUoqdqK5d7HUvcDECsZPEOFSDMSxu5/iQHtyWFnGCCtc0FbsoKxSDQc9oNMnZqWs16vru3HBI0U=
X-Received: by 2002:a81:a1c9:0:b0:2e6:b8ea:e4a4 with SMTP id
 y192-20020a81a1c9000000b002e6b8eae4a4mr8710162ywg.176.1648797905782; Fri, 01
 Apr 2022 00:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=r5N3h4F31Oi-GrrZBr4c86LmO+voGTn=x1QkbP=881Qg@mail.gmail.com>
In-Reply-To: <CANT5p=r5N3h4F31Oi-GrrZBr4c86LmO+voGTn=x1QkbP=881Qg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 1 Apr 2022 17:24:54 +1000
Message-ID: <CAN05THSZf76KaEH5HiPWZq8jr6+9vqeMw7mVZw0_4zCHqaneUw@mail.gmail.com>
Subject: Re: [PATCH] cifs: release cached dentries only if mount is complete
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I worked with Shyam on this.

It looks like when mount fails we might end up with garbage pointers
for the tlink/tcon that is stored in the cifs_sb->tlink_tree
so when we traverse the tree we oops when dereferencing the pointers we get.
This patch avoids the resulting oops but we should also try to find
out why there are bad pointers in the tree.

I will try to review the code for inserting tlink/tcon into the tree
and the lifetimes of tlink/tcon tomorrow.

On Fri, Apr 1, 2022 at 5:17 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> This is a fix for a bug seen during mount failure during my testing.
> Ronnie has reviewed it. But will be good if you can review it too.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/fcd5a7da1f616a7134bc4fb4e329e8f085f63801.patch
>
> --
> Regards,
> Shyam
