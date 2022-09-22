Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0730ECAAD8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 17:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiIVR6B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiIVR55 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 13:57:57 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15579F3903
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 10:57:57 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-127dca21a7dso14925194fac.12
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 10:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TgDgY+ntTJT5LrRO/2yKf3PhPIjqGDJ5ckxVAeXb9pM=;
        b=EzxJCwqj8SUwpLATOCTQCPXxDArAx6jFOBINEfe0RkA59zcTvCk63VJoJ1bzwwuIVb
         V1mD5vSARYHIY+JC4SPQ/okkb4NfsVbzqL94CXKsz3w9yhvAfHII3L0jSoZFPnLVF9K/
         b96T0Tc7ngdEn6LxvZQF4QI0CBnLRHl8wFXus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TgDgY+ntTJT5LrRO/2yKf3PhPIjqGDJ5ckxVAeXb9pM=;
        b=OCKTYS5DcSFPH9M03061pwd9+4ZOMKE0eflavIRHgutBMvbg9LoxyoZp3etDkbE7iY
         eeSeBCHHfIA6js69VLMMdwOqmq0Evwg691+/znyuRBCVT7gtQDPcbFkgaKFlE4abWiiO
         Bg4yDTm9+o3jFMLgvwBNvGDsnk/jO0V7A7z/Nc7Zuys6IGHmL1CL/eVRG5gNCggRw0Jr
         C14Cy5VbNPA1FneIt19FNuXzmnyFtkzXwOuuz5fzbB1epREWPy1XhcxICaHO/a9odH4K
         1pdCNQwJNX9K02U7Pq5J4BvLd9BwFEAC7O8KKaUILm9eVYzMAh7Ur6ptd1w+C9OHN97f
         PWwA==
X-Gm-Message-State: ACrzQf1FYa3WFm6rd/5C6qZAdShg4ThPdvIQ8AyvSh8mz5nb5fAUtTOk
        r6o+H3qgXMJYl2RgMD3idbK2pP5x471cpA==
X-Google-Smtp-Source: AMsMyM40379rzw7jvPdl5GlKf2HzSTnGwnu4bm5/K3L1Dg7Vzl5GNFOsK8Wd7/E7/gSk2y5BLx45GQ==
X-Received: by 2002:a05:6870:972b:b0:12b:67d8:5d46 with SMTP id n43-20020a056870972b00b0012b67d85d46mr2909472oaq.173.1663869476099;
        Thu, 22 Sep 2022 10:57:56 -0700 (PDT)
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com. [209.85.160.49])
        by smtp.gmail.com with ESMTPSA id v13-20020a4ade8d000000b0047634c1c419sm2026799oou.12.2022.09.22.10.57.54
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 10:57:55 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1278624b7c4so14956651fac.5
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 10:57:54 -0700 (PDT)
X-Received: by 2002:a05:6870:c0c9:b0:127:c4df:5b50 with SMTP id
 e9-20020a056870c0c900b00127c4df5b50mr2732855oad.126.1663869474518; Thu, 22
 Sep 2022 10:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220922151728.1557914-1-brauner@kernel.org> <d74030ae-4b9a-5b39-c203-4b813decd9eb@schaufler-ca.com>
In-Reply-To: <d74030ae-4b9a-5b39-c203-4b813decd9eb@schaufler-ca.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 22 Sep 2022 10:57:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLbq9oX5HDaMpC59qurmwj6geteNcNOtQtb5JN9J0qFw@mail.gmail.com>
Message-ID: <CAHk-=whLbq9oX5HDaMpC59qurmwj6geteNcNOtQtb5JN9J0qFw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/29] acl: add vfs posix acl api
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        v9fs-developer@lists.sourceforge.net, linux-cifs@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 22, 2022 at 9:27 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Could we please see the entire patch set on the LSM list?

While I don't think that's necessarily wrong, I would like to point
out that the gitweb interface actually does make it fairly easy to
just see the whole patch-set.

IOW, that

  https://git.kernel.org/pub/scm/linux/kernel/git/vfs/idmapping.git/log/?h=fs.acl.rework

that Christian pointed to is not a horrible way to see it all. Go to
the top-most commit, and it's easy to follow the parent links.

It's a bit more work to see them in another order, but I find the
easiest way is actually to just follow the parent links to get the
overview of what is going on (reading just the commit messages), and
then after that you "reverse course" and use the browser back button
to just go the other way while looking at the details of the patches.

And I suspect a lot of people are happier *without* large patch-sets
being posted to the mailing lists when most patches aren't necessarily
at all relevant to that mailing list except as context.

                 Linus
