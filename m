Return-Path: <SRS0=BNow=DM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E018C4363A
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 23:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D119206BE
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 23:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="le0qe7TZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgJEXzy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Oct 2020 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgJEXzy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Oct 2020 19:55:54 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB2EC0613CE
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 16:55:54 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m16so6769314ljo.6
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2020 16:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftbuSgGgPbQdU8tnDNvrvzCuF8DargoqMN7x7mXPfV8=;
        b=le0qe7TZOsPE1mmH+oNfWZ+pJm8wf9JBIU3wgr9hv5AOqHS36iW6M6D/YU0Nl0BFk6
         6uTG6W4sGsajllqhCjUBgHJu7qUEAJVvNzNayBvMgHT4cM0xzy1ZxqDDMhXbubYo7Bl8
         Hdnj/g+3XLgrsdPwOVj4+ZmmNUBr1x+j6R1J9RGRRrSSMFHrcjVlbqZ/w3OyszpDciIG
         uJyrjMp4jrrO8C3teg1uygCokvs+DTfE+0Cdqd5FgigkoKo7Cm+ZSuOlEAxVZQ12TQCA
         j6l0cmSG4BvjBi95az7MYlc+14snFSovqcMVymOPNeQLRVfKtYiZSQgubpZlR4+GYOfK
         76gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftbuSgGgPbQdU8tnDNvrvzCuF8DargoqMN7x7mXPfV8=;
        b=fzl4Lr+BMkS9ZxHUc328bQ/LAnEr+XxYzk1iRKUbj3F7PT1ZUb8yCHINxUSI6533vY
         XYYgUhACbtMCRHEz2N+3dsb6HBFzIU1INkbqXvDMZan7tBVfzhp31SSIvV0hQTumKsUB
         DKre7j1oiP6ml3z9T3EXAPhFQx5Ync3cmGdVCs57Z1qEz1epn5phrLkiZer07U5bYedA
         zbB+sOJLbMw8zD8CA0tz0jsiEVlwjwN+58M10hZJZY2ALIOLNio7C4mTbGhluoVaJfl7
         1+cjzAjiwvD77zttwvPw7Hy6LZ7WL8RF+3Ya2m+MR7WRGctxKQh2K4z2Z30JPD1PS4PR
         Xwtw==
X-Gm-Message-State: AOAM533OnnZ+sBo1xL3Dv60PKCMn4XSD6FnGDQaIqdFn7hYjCl4scsdY
        YR6MtnKyXGZvKnJRTbbelNo9PJCPRBy2NYgRaUQ=
X-Google-Smtp-Source: ABdhPJzbdnztAOYDIEnoGtMv7LmDhv9fwCok0PNzfd/cLTzrh2jl5slTc2YfDMqrObLbI6vzArXenrivzT52tlsRNkQ=
X-Received: by 2002:a05:651c:130d:: with SMTP id u13mr740608lja.265.1601942152553;
 Mon, 05 Oct 2020 16:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201004233705.31436-1-lsahlber@redhat.com>
In-Reply-To: <20201004233705.31436-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 5 Oct 2020 18:55:41 -0500
Message-ID: <CAH2r5mveYn1cxqqrguz8PVfhka4-rjPnFc1C48zdx8XP7uLgvw@mail.gmail.com>
Subject: Re: [PATCH 0/3 V2]: cifs: cache directory content for shroot
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged the first two (cleanup) patches into cifs-2.6.git for-next
pending additional testing.

Waiting on the larger, third patch until more review comments and a
chance to look more carefully and try it out.

On Sun, Oct 4, 2020 at 6:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve, Aurelien, List
>
> V2: addressing Aureliens comments
> * Fix comment style
> * Describe what ctx->pos == 2 means
> * use is_smb1_server()
>
>
> See initial implementation of a mechanism to cache the directory entries for
> a shared cache handle (shroot).
> We cache all the entries during the initial readdir() scan, using the context
> from the vfs layer as the key to handle if there are multiple concurrent readir() scans
> of the same directory.
> Then if/when we have successfully cached the entire direcotry we will server any
> subsequent readdir() from out of cache, avoinding making any query direcotry calls to the server.
>
> As with all of shroot, the cache is kept until the direcotry lease is broken.
>
>
> The first two patches are small and just a preparation for the third patch. They go as separate
> patches to make review easier.
> The third patch adds the actual meat of the dirent caching .
>
>
> For now this might not be too exciting because the only cache the root handle.
> I hope in the future we will expand the directory caching to handle any/many direcotries.
>


-- 
Thanks,

Steve
