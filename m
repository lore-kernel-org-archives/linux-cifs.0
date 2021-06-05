Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6443FC4743E
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 21:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A2386138C
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 21:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFEVHk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Jun 2021 17:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhFEVHj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 5 Jun 2021 17:07:39 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E443CC061766
        for <linux-cifs@vger.kernel.org>; Sat,  5 Jun 2021 14:05:50 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id n12so12477787lft.10
        for <linux-cifs@vger.kernel.org>; Sat, 05 Jun 2021 14:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MOtfuGINOt+IBuV9+T9aD9vvx+UkLLo/B+Wl6b0KUTc=;
        b=riVINL0yL7aPf1MaBADLyPwxsXd5Ai+63ogAygWXzr3q8tJE5B9RsoSLsIlnn4pBLn
         9nqbxqLAkfaJyaAA0qWYy94CZZm3JHPaZ7WOSDQ7z2zXGy5cRKW32FysCkZ4v0kJsPkm
         lbsbFaHQ8AmJwbl95CxDE4xTwmYb233pm0P5+9UrUzN+Z+bGJGxglP3sLq8cB02XHitt
         OroevPbDwWt0joXy+VbIogmV5IrVP5aa1wqpeIoGL8M4vgiiA+tWWXRsJDSbBniKZIvt
         LktOuswnhW5UNKIzoe6U2IMjVF2OJvO59Qds0VKOCQ9tkUJU4erpThLp+P61xjwl0e3I
         krng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MOtfuGINOt+IBuV9+T9aD9vvx+UkLLo/B+Wl6b0KUTc=;
        b=llzAarh2ZtDKgkG9nXax6FkLCD40O2+BH78R0aiQ8pHqzhMRhbI11KsB+VOzoUMqL5
         kra9WaS0zEF8lo8RzPjPNsUiLURkDCeEhOEk7YFEqRyTk3nVwrBdRYSk4esCYfniwLNH
         iz3Pl7cRKi21IEQklXAOuHYxYVoyR5T/w8QvpdVCBPZUTBUUIZQjxolETJTbdVo+1OZy
         7Vn26HRz7dmcj2Ryq3kBB+CS2VrKAy/MCq8TyIuJINrwEpmBOXGyKt+jZNLVNYcv7VqA
         TNgEPaCI8A3gW7tfYa0FZk5GnPmiQaNgu3kyJQSNMMkEXrpsRwds4DxKRb4/QZNRQr4I
         31EQ==
X-Gm-Message-State: AOAM530334huIqb2dzoA12cT2941xR3F2sXGkxpPyAQkV8B2IAxCAMJj
        uPhgE2Jgctmx5zDoPgx+fGfhcsjqAwyQkjFNEpU=
X-Google-Smtp-Source: ABdhPJxGGMigaIUAoV723uArHkbFKdK43BaNqJTMcpFQM+AngCWjwZXEQIXF4qisBz0XDaxgZqHBfdpfBDp/dg/wYgg=
X-Received: by 2002:a05:6512:33d0:: with SMTP id d16mr7234421lfg.184.1622927149106;
 Sat, 05 Jun 2021 14:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210604222533.4760-1-pc@cjr.nz>
In-Reply-To: <20210604222533.4760-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 5 Jun 2021 16:05:38 -0500
Message-ID: <CAH2r5mvGCgqzyPRtD3+X0pqhSO-mP0MW4kXfb51QxpLJ40UQTQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] dfs fixes
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into for-next (pending testing and more review) six
of the 7 patches in the series - patch 5 wouldn't apply.

On Fri, Jun 4, 2021 at 5:25 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Steve,
>
> Follow a series with dfs fixes and improvements.
>
>   - correctly handle different charsets when passing around DFS paths
>     by converting them all to a default enconding in cache (utf8).
>
>   - keep SMB sessions alive as long as dfs mounts are actives in order
>     to refresh cached entries by using IPC tcons.
>
>   - set a mininum of 2 minutes for refreshing cached entries
>
>   - fix broken hash of case sensitive DFS paths
>
>   - skip unnecessary tree disconnect of IPCs when shutting down SMB
>     sessions (it didn't even work before).
>
>   - do not share tcp servers when mounting dfs shares because they may
>     failover to completely different targets (use nosharesock).
>
> Paulo Alcantara (7):
>   cifs: do not send tree disconnect to ipc shares
>   cifs: get rid of @noreq param in __dfs_cache_find()
>   cifs: keep referral server sessions alive
>   cifs: handle different charsets in dfs cache
>   cifs: fix path comparison and hash calc
>   cifs: set a minimum of 2 minutes for refreshing dfs cache
>   cifs: do not share tcp servers with dfs mounts
>
>  fs/cifs/cifs_fs_sb.h |    7 +-
>  fs/cifs/cifsglob.h   |    3 +-
>  fs/cifs/connect.c    |  132 +++---
>  fs/cifs/dfs_cache.c  | 1004 +++++++++++++++++-------------------------
>  fs/cifs/dfs_cache.h  |   45 +-
>  5 files changed, 498 insertions(+), 693 deletions(-)
>
> --
> 2.31.1
>


-- 
Thanks,

Steve
