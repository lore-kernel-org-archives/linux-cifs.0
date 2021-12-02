Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6DCC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Dec 2021 16:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359197AbhLBQSN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Dec 2021 11:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359376AbhLBQRm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Dec 2021 11:17:42 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FBCC06175C
        for <linux-cifs@vger.kernel.org>; Thu,  2 Dec 2021 08:14:19 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z5so220484edd.3
        for <linux-cifs@vger.kernel.org>; Thu, 02 Dec 2021 08:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=cb/wMGNOhwX9zMYZn7+hTfD7KSDc+wnhDPy2SNk0YVE=;
        b=dQQlTqBfGoyiXAmrE/6WB2K+CJIkPvSksT69jAJAHoO6qhJ1Y23tI5NCEsZcpg1bCb
         iv6luZk1CmKP2tb3ROdxEDRJb80yBthQVjFifIJZ2sfbzOMghJfOcIxr8c+KDMB3NcoO
         cisxzK0RghREcudj20+zxLGOJBhZYVHaCctB0aeCPpWnNSGd5IvvALN9DYG2vLFpwRqY
         P8fefJ1CWZp/dIo1M4vCaSj/yURZmC+u1I4QAUrBP23nFCt1XxPsGy1KRWA1SPVzTHY+
         vjFwerSao3E8Zn0KSEIWhc7tFpGaJMagKsLdpPsCQK62rPGzjTOeYbQF1i8NBPqdJvSz
         YIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=cb/wMGNOhwX9zMYZn7+hTfD7KSDc+wnhDPy2SNk0YVE=;
        b=x7jr3zkFefcUMmTuvV0apIAw3IGow2Of+5IxQ1+A0yxkNTcQuJKoe6rXSYydmFyAdY
         CBn4At03AGjWKQvc7mI0D4Gw1M8Elv+GOaU0BfxzT3wCkm/KOiYIlEvLCwRsNiGqK+IF
         5HsHPPm0binLZ3ZGUEb1rQ801zZfyxl+hVksqB46qOjSy9ADdvxHlHm3T+4lx3FrK8Tc
         nxMkHCNgGnzUtfDZ2GHbn+KTkTAwZu9xjskQr+hJQ2xzjF+DOyCbfez9yPZocL2/0FZB
         MyMrqy/Hn4E+Xv3LvQqr6Sj7mHv1ruFqapvf5bNJvmHMmr28Rd5cItst/IdTEDGy3Drf
         vbJQ==
X-Gm-Message-State: AOAM533FuaQPBKFiXJUw0Zf08MquIgc3tTYq0a8UcIu/GTqU5/SRzwmL
        hq1j9C7Qcsv+tHHXNE0+gB5Puiyr5O6cKWcbr2QVrFTDqRwrBw==
X-Google-Smtp-Source: ABdhPJxT2gxYPhEE87c8SrDepDK+kaace9SntsE6A16rZPN/ooArVVGmVWxS4ZsmVj+F01HGh5PCmd6QGF33pCj4S1U=
X-Received: by 2002:a05:6402:1613:: with SMTP id f19mr18720417edv.322.1638461657727;
 Thu, 02 Dec 2021 08:14:17 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qfOdaFQF+EUgjgQx=zGb09FCu=zjZ7q622G--dUy7F3w@mail.gmail.com>
In-Reply-To: <CANT5p=qfOdaFQF+EUgjgQx=zGb09FCu=zjZ7q622G--dUy7F3w@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 2 Dec 2021 21:44:06 +0530
Message-ID: <CANT5p=r5WgGN9Txpa=NmPVO72kmzUb609_r06N3P-nAhkwJg9A@mail.gmail.com>
Subject: Re: [PATCH SET] fscache fixes
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>, linux-cachefs@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 2, 2021 at 5:32 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Please review and consider the following fixes in fscache integration
> of cifs.ko.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d70e50047c7daa3de17c7c41a0c4ef4f9e4443c9.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/089dd629653b857b6096966e9d2df301653a36ea.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a9a62cdfe26c782dadd0b94ab529b883426d0acd.patch
>
> --
> Regards,
> Shyam

Adding David and Jeff for review.

-- 
Regards,
Shyam
