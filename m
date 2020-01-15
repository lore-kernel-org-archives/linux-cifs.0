Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16662C32771
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 21:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE2332084D
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 21:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRxSo9LU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgAOVIa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jan 2020 16:08:30 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:46712 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgAOVIa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jan 2020 16:08:30 -0500
Received: by mail-il1-f193.google.com with SMTP id t17so16113653ilm.13
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 13:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=khgFgOSz6VqiPXUqPfddOa9psb4+3TSujlBQhh4cvyU=;
        b=PRxSo9LUZN+/dKRlMhpzNNOHWZOIfYx/9V6nLm4oT5BUMtdSsQTe0J5468eBXuVPAu
         sFMkmhGAuZfsYQ6ygrX704KkODrnHYT612OVnnoDYms0jnh3X07L+iuDz5FQLPi3zQQ3
         0/4LuFh9IFhi0EjkAKZtEa7j14NjMesNLGMkXpsQIAjP8z2JHyr/5Z2xrB5kt3354Y/B
         bzMUsQRhVIYnxZiCoym7aHn3zCjQusJd6P+hv5yznz1KMDdDaWOTqhjWMJrhjlBxWH9G
         oSU+LVXXxxPTKzlAbinDDzHSE3uoTfr9whUVYpr1DRuPISN4WpDuP0zAcF6rogvFu7kQ
         dXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=khgFgOSz6VqiPXUqPfddOa9psb4+3TSujlBQhh4cvyU=;
        b=cGAxu9g5J1n+ydJ18IQMD+ZhH/HRtRbvBCb6JX4vc/zxVXrdQ8lf71qZUyYpOcHlbM
         aFAL/Us7NiO9YshegQ1106VGHDqLet+NBAjr+ICYRmCSv1bXo0U/avAiDEpqOyBzUJlc
         XQbSnCFOBqV+a3+AzgBISwswKQ60X4k0LtdkmR3erQJ6hlln3M7oWDG92AdEse73Gdkz
         8IopLrpgyTWuaSlw5D4JmfmGx4dsqfaKvTWH6aAGBdtz6HJS6B7bY1wfYUu+OgcssG+5
         UUyBjnXDSUphfuFCQVlUULdWnpUVRF1skHPJdg2V93avLJfTdoKCvHHRh8lsD7s2hu4z
         e+FQ==
X-Gm-Message-State: APjAAAUCDQFWbJ22EuI5L3EnW4fmjXDfqEd2wVlJCZgEJfbdSZAYYdMV
        AtiFiVDPrmrzQVfeK9uqvFbIWTMISaA/41gGwJc=
X-Google-Smtp-Source: APXvYqyBfa4k4AuM4jFedTyWh4Imi01r+b/pAC0HlDVn6z4mpvi2L90DqO9XT8uCWyZkx6dr1F1DmJsUKzZAT57ADxc=
X-Received: by 2002:a92:cb8c:: with SMTP id z12mr444992ilo.5.1579122509557;
 Wed, 15 Jan 2020 13:08:29 -0800 (PST)
MIME-Version: 1.0
References: <20191204203803.2316-1-pc@cjr.nz>
In-Reply-To: <20191204203803.2316-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Jan 2020 15:08:18 -0600
Message-ID: <CAH2r5mv7UG8R0Cd0gA9jUO0eT0OX5_YgAW5ZHPdzaGx5+A9=EA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] DFS fixes
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing
(buildbot) and review of patches 5 and 6 in the series

On Wed, Dec 4, 2019 at 2:38 PM Paulo Alcantara (SUSE) <pc@cjr.nz> wrote:
>
> Hi,
>
> Follow v4 of DFS fixes and cleanups.
>
> Add kref to vol_info structure and avoid potential races in cache_ttl
> (Aurelien).
>
> Paulo Alcantara (SUSE) (6):
>   cifs: Clean up DFS referral cache
>   cifs: Get rid of kstrdup_const()'d paths
>   cifs: Introduce helpers for finding TCP connection
>   cifs: Merge is_path_valid() into get_normalized_path()
>   cifs: Fix potential deadlock when updating vol in cifs_reconnect()
>   cifs: Avoid doing network I/O while holding cache lock
>
>  fs/cifs/dfs_cache.c | 1110 +++++++++++++++++++++++--------------------
>  1 file changed, 586 insertions(+), 524 deletions(-)
>
> --
> 2.24.0
>


-- 
Thanks,

Steve
