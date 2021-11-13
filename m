Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BF6C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 18:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1930611AE
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 18:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhKMS33 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Nov 2021 13:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKMS32 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Nov 2021 13:29:28 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61C3C061766
        for <linux-cifs@vger.kernel.org>; Sat, 13 Nov 2021 10:26:24 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id z34so31091905lfu.8
        for <linux-cifs@vger.kernel.org>; Sat, 13 Nov 2021 10:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=B9aRyJokKrYX9jP1HJaDLKQZS6Llto3aBGXISeUXtYo=;
        b=qjAhTkwiYaxZuugPrNIykQGKFi/GOnpwdDLWPF7af9jV+6HHz2RB278m9PF7k22Q1q
         npnc4IADdzpDbIONBdpW6wnlsAdeLRKf34Rji5m3CESsTURGy0T0J4CQu5dwxupFqYhy
         F5+sgGzUG+I9iCXAKWgo1nqm9X6a/swUwA2fAwtlN0tj/wuE0ADJFLQCxh8DPp+pN5R7
         KfbVUj9DZt0B1VWEc7FWLBlB2L4J4SkilNeeXlVPLsrl0Z6zNXVchzqZNYR/U45m1iL3
         QHcZ47tvqaagFJOxgil3vfW9DwWS0HjWnqhon9yyz7I0M6SekD9IicDjkXWfqqSPneRY
         enaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=B9aRyJokKrYX9jP1HJaDLKQZS6Llto3aBGXISeUXtYo=;
        b=WIBQluVSd5aYDhyPqnSWh1dRVXY+d24qLmMhv6e9HFZMgdJOrWc3nStS4FyWt3G49R
         5le5ou1IUHchm/7cjI8IzuNsGVFPFbYb/ppFmh9oKMcxBjP/vr/0A9H7WmrFrbqCVAx7
         BEahN68s1XMtWy4rDW11F4xbnyQGo3yGfIDVNe6IOjrj8l7As0sZ8a1D/ndz9JI2VazY
         6pXOMw2V9HyiySJffVv+FueSjVlE8f6Hd3bEBKMg5fc+yapIhqwdNOOxlt6HAD1xtuy0
         nrRKP3hut0NJ7WmG/vQ2Bo54uSG3nIJYlOEyLNnNe1LD7GeInKNHQwIgajaWmO33p5Ec
         n/sA==
X-Gm-Message-State: AOAM531CJrnGbd83tL0m3o5oknYxEOi3tacW2shqYhQXh+utoHcRfa12
        f1m5q/oXKdQlbFzmU1AuE1osexiFq08XReTlaNmZ/HxdU0M=
X-Google-Smtp-Source: ABdhPJxNkLNFuiTLHJSyUi9qfQwghfNTMW49/h96o+3fGI6WjPfy97CwsYvC/7nc+rnl8s4fEsayDrXnNn5IxI2MSE8=
X-Received: by 2002:ac2:4309:: with SMTP id l9mr22433572lfh.667.1636827982835;
 Sat, 13 Nov 2021 10:26:22 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 13 Nov 2021 12:26:11 -0600
Message-ID: <CAH2r5mtUiH-D6t9ESF00XcKG5MPPvyDXnSK400KRAbYesBr4Pw@mail.gmail.com>
Subject: performance improvements with recent fixes and multichannel
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Noticed xfstests running faster with multichannel to Windows test
target with current for-next (31 more recent smb3 client patches) vs.
5.15

Will be interesting to see if this is consistent

cifs/001 2s ...  2s
generic/001 199s ...  101s
generic/002 1s ...  1s
generic/005 703s ...  55s
generic/006 616s ...  222s
generic/007 768s ...  419s
generic/010 3s ...  3s
generic/011 3557s ...  537s
generic/014 432s ...  288s
generic/024 8s ...  7s
generic/028 5s ...  5s
generic/029 2s ...  1s
generic/030 7s ...  5s
generic/033 2s ...  1s
generic/036 11s ...  10s
generic/069 14s ...  6s


-- 
Thanks,

Steve
