Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB81C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 00:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiFIAjh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jun 2022 20:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiFIAjh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jun 2022 20:39:37 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42511CFB
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jun 2022 17:39:36 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-31332df12a6so78075877b3.4
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jun 2022 17:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7pQpTPYri+YKCalqmxpuU4jWRS6DS5HIfmA8jY0UK1I=;
        b=QQG0Y0Ngf/LnM3NU7UfCipS9VHtZVFl3Db5YcaP/Rr4Dcw/4YXk7cuUcsrLoSdhAbE
         xmVElGIL4XnBBpC9+qtK97PUlVFMKDz9P9b2mLHPNybgq9Juh+zgvJidgWTI8i0tnKgb
         bssa0WRBqsqa2lZgOQNagv7XmxTE4I4h9zuedQI4FxLtbUiU2wCH5LKuvsB1VWO5mFRK
         WvkSXyaorpHHAImQgzSF6AQLvUn7nTWEuyxD3ihyvtW6UyaWS8zae4dAPnfQXDt8Ew5Z
         jbrN7xdO568iK9AnYLi2waXMC3aWbTc33vYfo6vupHrlk7nK1fSVk+3XCChCa1BliqI9
         68EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7pQpTPYri+YKCalqmxpuU4jWRS6DS5HIfmA8jY0UK1I=;
        b=h5V9CCmEcbrYTzqq6CWhZfUcvP98DGxkAIIcDRFU+XH38hMuvYwfpgOK1rSkz1Rx5w
         Qvmw33FjoehI39VUYlpFgx3Qz+lPCOV9JP686LFWyBKFdDKGbkvda0+TFsySwxd3JxrN
         XIeQp/hwCSWq8WykHMxv737ArgOrXDi2V6VGD7YzjgX2U0+etPMynHZjmRboxw9nOdLg
         6vIt0n0ZLRV5NNMT9sXr7IqCqdqIKZLT/kKPA0ekkSvoZo5suVwnF6NKN+pTWiz0wSWi
         q1FkqN2iSylmhsQTAcoVyrVPAmfcUvR4Y3ws37Py+Ol7DLLAipreeRkF7OlEPTwhjYKl
         6gyg==
X-Gm-Message-State: AOAM533LEdJwV2nFn0Jk88ToduMwAYrbgKGO9LIBkbidR3M+ZXFygNfP
        N/W9Gs5JUeTCH1N3qxpqR5HOTlq1VnUJYnpvgYZ+1kuV
X-Google-Smtp-Source: ABdhPJzRjhu52gpje8U4+pKMWCejXye6AQ78R0hOwWez7RTP6jM0ojuZUiIumiUQZqfXWwCkBvR996/TijAs8FMrL3g=
X-Received: by 2002:a81:83c5:0:b0:313:7a97:ed00 with SMTP id
 t188-20020a8183c5000000b003137a97ed00mr4541741ywf.54.1654735175532; Wed, 08
 Jun 2022 17:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220608215444.1216-1-ematsumiya@suse.de>
In-Reply-To: <20220608215444.1216-1-ematsumiya@suse.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 9 Jun 2022 10:39:23 +1000
Message-ID: <CAN05THSKxMrvLEQh+RFFt2L3fyy9zj4fz=GztZYDK6Mj-fcG=g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good. Reviewed-by for both patches.

On Thu, 9 Jun 2022 at 07:55, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Hi,
>
> These 2 patches are a simple way to fix the DNS issue that
> currently exists in cifs, where the upcall to key.dns_resolver will
> always return 0 for the record TTL, hence, making the resolve worker
> always use the default value SMB_DNS_RESOLVE_INTERVAL_DEFAULT
> (currently 600 seconds).
>
> This also makes the new setting `dns_interval' user-configurable via
> procfs (/proc/fs/cifs/dns_interval).
>
> One disadvantage here is that the interval is applied to all hosts
> resolution. This is still how it works today, because we're always using
> the default value anyway, but should someday this be fixed, then we can
> go back to rely on the keys infrastructure to cache each hostname with
> its own separate TTL.
>
> Please review and test. All feedback is welcome.
>
>
> Cheers
>
> Enzo
>
> Enzo Matsumiya (2):
>   cifs: create procfs for dns_interval setting
>   cifs: reschedule DNS resolve worker based on dns_interval
>
>  fs/cifs/cifs_debug.c  | 63 +++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifs_debug.h  |  2 ++
>  fs/cifs/cifsfs.c      |  1 +
>  fs/cifs/connect.c     |  4 +--
>  fs/cifs/dns_resolve.c |  8 ++++++
>  5 files changed, 76 insertions(+), 2 deletions(-)
>
> --
> 2.36.1
>
