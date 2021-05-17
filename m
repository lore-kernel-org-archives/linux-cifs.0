Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF7DC433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 17 May 2021 22:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A6660FE8
	for <linux-cifs@archiver.kernel.org>; Mon, 17 May 2021 22:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343604AbhEQWEN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 May 2021 18:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238000AbhEQWEK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 May 2021 18:04:10 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D15AC061573
        for <linux-cifs@vger.kernel.org>; Mon, 17 May 2021 15:02:53 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w33so3050469lfu.7
        for <linux-cifs@vger.kernel.org>; Mon, 17 May 2021 15:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=QM6v02npgS78lQUQ9Ig3VjPMW7DzlRYucUqPXHtXQ1w=;
        b=vhFysmGM8zYLcD/FoZ9sqSgImRmqfHPszxg8UaMcNiosFqgfpEPAJ2CoUU1yQm+9G0
         IkvRXOkmix43vgGPL2w5keI25P7Vb6NJtQgRtLTutjnaWIIt3oaPryre+WwBsoX8j1sn
         F0T3K1Mw84dd7wTJUnF6L7Ora/F/WQOR/KRtEuaL0/osPzL/UYgBK3qzcLO9XDK8wvhW
         1qG1zOeCGSpovA+bB6u+3MTTpDyKbc8pzJUeaBPJtyq6ZGghj/JAemTxmf0y/IQKSDIl
         PCRo7uXzgiVKR5E0Ws7psNPwS6G0Vud7SYwived6B804kEeqh2/FsgV/tDGLzSZ5m5U5
         eS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=QM6v02npgS78lQUQ9Ig3VjPMW7DzlRYucUqPXHtXQ1w=;
        b=XjGw86JRYurg6Sa/nfqHQGZzDEenYd76RwlwJ0WKprXgpAkKGt0fSIvGq9horwSNqK
         qmI5aNbxL+gRCmwlIBmecmj80owOOL2mLr3Ci3NqKVozxINmJMl8zcNJJnGvvoNcsYv7
         qyaj9QoZSE62WcLNQChtOiLKMITNxyoNj/V58cI2gXp43Ak+gq71SD5FP8FvfNY8KF2f
         mzN78pxg/PdrVE71wNw+Xr4P0A3cb4Fc/kHLcCU65hiBhbdHoow9wyJo+qy2ErSJgNey
         KY2q2rVd+zz4/YplK1yLPbdBQCxdcRrkvOGHkRlOWoNcPQ0O1gSYQHVcdxHa6GHM3sDM
         WARQ==
X-Gm-Message-State: AOAM530VtkwILAcwKxwOxpzti24p/GyzYFvWT14y9fnUdRfwIt2YQPdK
        r0CL7qGwZfc3oWJ6V5jNzRA6LL1HSmDg3JXy9H0Dc/norCYsGA==
X-Google-Smtp-Source: ABdhPJwOuONohaj0HKy/1v1bbw9lVOFFHnRURIYyaz5A3yjsNdcu5q1QGcIzQgFJI64cPZ9v43cg7kM+5JgHrGSTAqI=
X-Received: by 2002:a19:f611:: with SMTP id x17mr1377021lfe.313.1621288971795;
 Mon, 17 May 2021 15:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtOj24Rh8-3fJBz0X2kXY7m3Zt6LZfPqL+YBu_MzT7eMw@mail.gmail.com>
In-Reply-To: <CAH2r5mtOj24Rh8-3fJBz0X2kXY7m3Zt6LZfPqL+YBu_MzT7eMw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 May 2021 17:02:40 -0500
Message-ID: <CAH2r5mu8W5bvEK-5fd448Pv=U0AzoWDaSvBSV4btm+_t8PRodA@mail.gmail.com>
Subject: Re: current Linux client vs. current ksmbd
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All buildbot tests passed (current cifs on 5.13-rc2 to current ksmbd)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/36


On Mon, May 17, 2021 at 2:14 PM Steve French <smfrench@gmail.com> wrote:
>
> Noticed two failures in the latest test run - not sure if reproducible
> yet (tests  cifs/105 and generic/464)
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/35
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
