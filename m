Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DCAC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 11:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BF960238
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 11:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhIFLrF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 07:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbhIFLrF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 07:47:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7685C061575
        for <linux-cifs@vger.kernel.org>; Mon,  6 Sep 2021 04:46:00 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u1so3779642plq.5
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 04:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=lW3tY7sqTS9AC/wvBKZE4PLv9ITPtXz20urRdfjGwXE=;
        b=RMyqK+dTSAlsSF5IwNwcy4sy3B75Z19d1Zjfe0HDfWnvXVOW2xEvognTfJqY79+F1K
         h5UQ/hUdcIV3s4vU8typRflY6D3EmdEBIJY7o1BmDBKy1UDMgWLEuhj8IlAQDUw73I4u
         EGFIJgoDH7oBm9uTkquxH4zZLS/d8JLDLw+VvIAgX6j5Uo3I0HXRH6llXH/cyl4iuJUx
         198uVra8JLtuF/DKS5iN2I95EsB0UZuLoaDHvhu2+P9k9rfOSlPHiGKn9sdnf2FWbY0o
         TKH2b9/99PZH2g/dqCTZKqfBbYthSXRMcRbUKfGJowrNKvn72eo+vL/NOpCsmBSlObwj
         t4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=lW3tY7sqTS9AC/wvBKZE4PLv9ITPtXz20urRdfjGwXE=;
        b=AB48fOLjoGJRg8WRkYE1SjxDDdzhXUiQtHY/3Uxo3vqmEnMKIlviQNP/lqYKHR2aJY
         wW6TSLOC0+GVQdPugjKvNVWTL3ujtYh4Q/ogqAQUgWvUo8YG/sWUHEcO/qhkPBCXOJwT
         scLiEy/KlPRErppLp+xCVRuHqDOBupk6ohVuwbhZUUTmJtEPYhUUNhkxzs43VVhWfUA9
         qB+BmdPry4WdtFpVQpkDnRl6LHwCjmRglIF7GbK7qIwE8aXhS8F2NkS7RZJXPnPYD9D3
         /f3fqwEpmh8tXzieHvtMkSiU2xDIk82rvF1YkaBl0zZDluj8aSJ0tisgKZ6o/u8hQHc9
         Q69g==
X-Gm-Message-State: AOAM530SmR2XKjwLl2V/2ikpumtEkHYyEXnfQgkrHfW+mYCIpx9vO+0v
        CpFSOLhtzUY31m39Y3Lxn536eHY70dA=
X-Google-Smtp-Source: ABdhPJw2Oxy7nUBkF+TOODwK4Lr2iVM53fNfJdCkmsp6lh5lhKIrWDrvoXvx7LrE7MrvgBH88g9SQw==
X-Received: by 2002:a17:90b:fc6:: with SMTP id gd6mr13718761pjb.186.1630928759870;
        Mon, 06 Sep 2021 04:45:59 -0700 (PDT)
Received: from xzhoux.usersys.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm7386232pfu.67.2021.09.06.04.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:45:59 -0700 (PDT)
Date:   Mon, 6 Sep 2021 19:45:51 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Rohith Surabattula <rohiths@microsoft.com>
Subject: [regression] lock test hang since 5.13-rc-smb3-part2
Message-ID: <20210906114551.azccg5o4lh4fompe@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Since this commit:

commit c3f207ab29f793b8c942ce8067ed123f18d5b81b
Author: Rohith Surabattula <rohiths@microsoft.com>
Date:   Tue Apr 13 00:26:42 2021 -0500

    cifs: Deferred close for files

Xfstests generic/478 on CIFS can't finish like before. The test programme
never returns but killable. The kernel does not warn about soft or hard
lockups. So it looks like looping forever at some point.

It's always reproducible. Without this commit, generic/478 fails the test
because of different lock schema but complete very fast. With this commit,
test hang like forever.

Sorry that I do not look further here, because I have another bisecting to
do to hunting another regression.

Thanks,
Murphy
