Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14920C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 16:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiHKQoO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbiHKQn7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 12:43:59 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752FD915FC
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 09:16:34 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 6FE9E8026B;
        Thu, 11 Aug 2022 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660234592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iw8LBSxtwGyKpEEJe9lCY07iJwMyPnqvJfEkcpHnAbg=;
        b=gM0rZ+FeNwlbQ3U90bjLl7/Daiq9fi8R/V9smdowFU/insrnH5B5eGZu4Kx2iBA36ePtM6
        v3dNVkeECxAUsmcFrrXERJ415yXF28gmZCOHXgtC8rXED3QqI8QpkdCfB58TdFFfLY0b6N
        EqmAH1AuD/BEvSk8b2en9v1Uux+kAOf0IdKq9NwFg2ozOS1ugaW6UsX1mUU4R7j0gjfCFx
        1nqHUgwI6kpWGu0kDeGpYKciBzbul+i642S7P3NVFpMuANpUwOQnkrKZIcx66yZntuubrX
        5ijl0BAnvAz3nwmyIRX28m02nGGCzsfHTCLJbE4sDsSWa3vqPD//MTpSV/jtSw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Subject: Re: [PATCH][SMB3 client] allow deferred close timeout to be
 configurable
In-Reply-To: <CAH2r5mviEtcCQa1Pbyf6OeQKQ8dzJrK+BQE61qaGk6rQUaGH4A@mail.gmail.com>
References: <CAH2r5msJ6=LfoyGWyi94o+Z1FcJFdxpcLyPRz9K9gK5SpvPCUQ@mail.gmail.com>
 <87zggasr6o.fsf@cjr.nz>
 <CAH2r5mviEtcCQa1Pbyf6OeQKQ8dzJrK+BQE61qaGk6rQUaGH4A@mail.gmail.com>
Date:   Thu, 11 Aug 2022 13:16:43 -0300
Message-ID: <87wnbesql0.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Will fix the typos thanks.

Thanks.

> There are a couple of minor differences from Bharath's earlier patch e.g.
>
> "closetimeo" rather than "dclosetimeo" (I am ok if you prefer the longer name),
> and also this mount option is printed in list of mount options if set.

Both look good to me.  I personally don't care much about naming,
though.
