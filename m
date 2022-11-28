Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38775C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Nov 2022 17:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbiK1RW2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Nov 2022 12:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiK1RW1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Nov 2022 12:22:27 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFC319B
        for <linux-cifs@vger.kernel.org>; Mon, 28 Nov 2022 09:22:26 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id h5so9708945ljk.11
        for <linux-cifs@vger.kernel.org>; Mon, 28 Nov 2022 09:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wSE3Ldymljc0w6HwknemxKCjum4rM1V9tzMeV8n5h4E=;
        b=o0RhSxYUsqXyrYS5DhF+tqAWqCErYUF1wHjacCcKCgoBxKiMwhxTPnmu8r3P4xSBb8
         iPameT3iozJNV8LxPyjczsWOyr9pop7IoYSAUglW0xPvhUocFGwHKTWjvQxG0NupXtTs
         img3iLhHhh5GRcoLb1huw6wDXSmxxQyGwZnrKmkDgMCNNTx5Ciy3EKrXaXDQvVv+EEI8
         MFax8wCxYByeIaQOdgo36Ry3XHyB0WjrYhEthWxgWjA7dO9YrpyBFFqwTFuq5J8NJT6L
         c6Z/lc1WFHomn56tM1pIRvHdPmiR6LGZqC/k92J1u6Mb9cAwpLwkImIgd8DTzElgxRke
         xAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSE3Ldymljc0w6HwknemxKCjum4rM1V9tzMeV8n5h4E=;
        b=MmrDSK+9R1dgPgdWvbi3gGlyVROqF05l4oTZgYVis6Kl2ZEqZwD7sNAbPrvniWSYTm
         MwWEYXZxrdxF5fiBdGF6R4X2axbuLyiDCEDT+Lu6V6kkBe12HLp9bmQmUDFokTieyQ+d
         Npl5JLqDsik7Uij9gngimUVioJ8ZPFvDqTrRNmImOgxOk6cKcf8vkTYy2pLQzLOV0X2q
         a46J3rN68d2Y9J3ZaDsYZstZ9rR83eAXtCGXVIuSe0Ch9Y8VaLx+wXsRNO89lzjJYFj0
         ekWg5ffvMiNxe6dTL5A81cbO4hLV6DIr7Xu/0TsM/6KYflJk5hxYMFFwdWf9c8J6a/5n
         17lw==
X-Gm-Message-State: ANoB5pkdbWnBqz2i/GOiGrOo0iaKRWewBJ/2EPNGas3rM325QsSz96DC
        JocA3TRCRZ+W20T0+GF90fO/yadYN45dSa9lI+0I5Hzw2rE=
X-Google-Smtp-Source: AA0mqf6TDmGbCN49eOgSwWynhZWGRaaTsoGhtUiiFhy5O2UVMkTxbLs9uUkO3vvo8tgvdRMm0KsqdvHGPXWq/L9XmWg=
X-Received: by 2002:a05:651c:2ca:b0:277:1e9b:2b07 with SMTP id
 f10-20020a05651c02ca00b002771e9b2b07mr18360111ljo.242.1669656144372; Mon, 28
 Nov 2022 09:22:24 -0800 (PST)
MIME-Version: 1.0
References: <Y4DJ2o6w+SxIH7Yl@sernet.de> <CAH2r5mscUWuAbsSjw1DOFT=yG3dDZhcmCtAVLNhoH-5hrby-tg@mail.gmail.com>
 <Y4TNnusYnxfwYN0s@sernet.de>
In-Reply-To: <Y4TNnusYnxfwYN0s@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 28 Nov 2022 11:22:13 -0600
Message-ID: <CAH2r5mtZpmX5EQPD8AqZNLuskimE0=NG8du6gRHXivxNv1uuCg@mail.gmail.com>
Subject: Re: Parse owner and group sids from smb311 posix extension qfileinfo call
To:     Volker.Lendecke@sernet.de
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated patch in for-next and added Paulo's RB

On Mon, Nov 28, 2022 at 9:03 AM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Am Sat, Nov 26, 2022 at 06:31:51PM -0600 schrieb Steve French:
> > Looks like this does help the group information returned by stat, but
> > will need to make it easier to translate the owner sid to UID (GID was
> > an easier mapping since gid was returned as "S-1-22-"... but SID for
> > uid owner has to be looked up)
>
> Next version. I have to learn that -EINVAL and not EINVAL is the right
> error return in the kernel.



-- 
Thanks,

Steve
