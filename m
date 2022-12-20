Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 844D5C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Dec 2022 14:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiLTOsd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Dec 2022 09:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiLTOsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Dec 2022 09:48:09 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAD11C112
        for <linux-cifs@vger.kernel.org>; Tue, 20 Dec 2022 06:48:08 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id n1so12642570ljg.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Dec 2022 06:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3v5fovTKN2ZyRZBEAOfB7vdPlSxh6UMqLLv+tijxbT8=;
        b=JBYkh6HxliA7S1ZX1hiitBpTST23mK3mmvVtgWM63B+xNCDbvqVAWSuq743FwFi8zf
         6apk0t2sLDVKjW3rDdCpVx74QXF/gKCR7RPetleTYQmBnsYV2nFSeez+N0LFnLD1LB4v
         yuoc+xfYMyOeMu/d/dT7r7KTm3CD4wTWF7s/jSGuy/Uu82Jcz9sgGKnqRPPYlZwqbqjN
         4MXwKKfb63ERs+TZza0PDgN4rjgxHI1RVsBSG+8CNaIvwS2p+LpXB2BAEWtZpD7Ix374
         QsiIwJf+JDphtPrBbDTR+KUxcfSQZlg+qaIKm7uwKFg4G1kb8aPGdKE/6WhoApWJ69wT
         FFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3v5fovTKN2ZyRZBEAOfB7vdPlSxh6UMqLLv+tijxbT8=;
        b=mn/M0BZpPjJ0qhWI7PuMmoBvlT9z+Y4BtsIpUmOAlH+8+FQlCD0lK5jzVZNnEAwsq5
         ufE0HPSU8zbL6gDt9425Va1MDP/Q/vZ+oj9GBH0pxOJ6S8cyehi/PByHmfS1oxUPi7+s
         /woh+HF3JFnQDGvQprjqAZawB71PsFBHOr5e/d/MCFqNIWltUozsL26x8g/QwSpNgfTd
         bNYa7lpp86+KmC0DpcGL1qTln/F8qxGYWneg35Ukzh5wRf/rdjkVl0Sj8ipIIE3oxJHz
         Y+DFZ32/IPybLuvJN51LdCiggrm5Bwuf1hun1uUyhsZdEtaasgRZFOjTw3QMr7Pvh0l7
         qhZA==
X-Gm-Message-State: ANoB5pl5wKCsrtj5xDHOEzzRSruZAEKdOe0GI2oBsYbUU9L+aMAJsAlK
        i9XiNhpCHpBsdcnI9OerKb90u82qv7eIHyVRUjQ=
X-Google-Smtp-Source: AA0mqf7Fh5ITuXhyM8/Jc4TdySg74VI/m0IGl+/KuH5Ftf5REfFbxRAbuBwF3ST2i5herLSDocaGKmCQuhXy4idIrNw=
X-Received: by 2002:a2e:9015:0:b0:27a:722:2fd7 with SMTP id
 h21-20020a2e9015000000b0027a07222fd7mr5938836ljg.229.1671547685283; Tue, 20
 Dec 2022 06:48:05 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
In-Reply-To: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Dec 2022 08:47:54 -0600
Message-ID: <CAH2r5muGBpwvpt6tTXDj2s=UHhJyG1=p94mcTaZ7QbrpuZ2R+w@mail.gmail.com>
Subject: Re: [PATCH] cifs: use the least loaded channel for sending requests
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

maybe a module load parm would be easier to use than kernel config
option (and give more realistic test comparison data for many)

On Tue, Dec 20, 2022 at 7:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Below is a patch for a new channel allocation strategy that we've been
> discussing for some time now. It uses the least loaded channel to send
> requests as compared to the simple round robin. This will help
> especially in cases where the server is not consuming requests at the
> same rate across the channels.
>
> I've put the changes behind a config option that has a default value of true.
> This way, we have an option to switch to the current default of round
> robin when needed.
>
> Please review.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/28b96fd89f7d746fc2b6c68682527214a55463f9.patch
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
