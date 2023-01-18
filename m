Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6104CC32793
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 22:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjARW7T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjARW7T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 17:59:19 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F49D4F34B
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 14:59:18 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EB3197FC01;
        Wed, 18 Jan 2023 22:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1674082756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lVRdbQ2jVYpwXFfT+q2ZultCpIccDri+Vo3E3fCiYJE=;
        b=YGcxxPRPxQE6IeranvCfkmsB4Xlkosj/Ibu9L/yxTwL7lwe+YRbmVx7XxJBdoHy3BFu1r5
        TxmrYmD2LsbRSVnE5tf65U/hIClWApYZ+QETpvpfdZMkLAOU4FvzI3AutaK3fZFr7haYO0
        Lyn1DXKSDX0dzFIhlU0o0IfJrAMsVCabVkxQcT2tPaEyZDVkxpJhfxrdwuGbICx67c+vQY
        LU31uXRAM7PksDarx/6kiaI6Oi4uzJuVKjqpQO0wod2gZ9InqRFawPeUn+VfUMWY0ibZkH
        MlsaW4pPN79TwgPb+h5QbGNJdP0gZnFqou/+Bu1M/fT5QsSevzAOSrkpo7nVIA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: [PATCH] cifs: do not include page data when checking signature
In-Reply-To: <CAN05THREk=3Zk2VTpfm6qyAA88mV2xm0qtiL0-p44ZRhXPuzmw@mail.gmail.com>
References: <20230118170657.17585-1-ematsumiya@suse.de>
 <871qnrvc7z.fsf@cjr.nz>
 <CAH2r5muxweTSeBdGjcG1W_WjuM7fdd4JpqPCB7AqVXjn8QyhBw@mail.gmail.com>
 <87tu0nwkrc.fsf@cjr.nz>
 <CAH2r5mt2UvW32AZrvjde75NL3V5qWLbc=WTTdaLZsi2B4oYEhA@mail.gmail.com>
 <CAN05THREk=3Zk2VTpfm6qyAA88mV2xm0qtiL0-p44ZRhXPuzmw@mail.gmail.com>
Date:   Wed, 18 Jan 2023 19:59:12 -0300
Message-ID: <87mt6fwitb.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ronnie sahlberg <ronniesahlberg@gmail.com> writes:

> We should update the buildbot so we clear dmesg before every test and
> then check for and fail any test that results in something unexpected.

Yes, agreed.

Our internal buildbot does this after running a single test

        bad_dmesg_rx = re.compile(r'Call trace:|blocked for more than.*seconds|BUG: sleeping function called from invalid context|^WARNING|possible recursive locking detected')
        if bad_dmesg_rx.search(dmesg):
            ...

We should probably have 'CIFS VFS:' in that regex as well.
