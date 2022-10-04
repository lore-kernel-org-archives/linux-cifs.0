Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528BFC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 19:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJDTDU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 15:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJDTDT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 15:03:19 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804685724E
        for <linux-cifs@vger.kernel.org>; Tue,  4 Oct 2022 12:03:18 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2AF438112E;
        Tue,  4 Oct 2022 19:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664910197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9RNNpu28ZwYrDj16EqRWYIwnOaqPlHLiniAE09lH0m4=;
        b=zdvQcJ1Eo3cJZgM18LzTt4X7cy/DEl8SRzQlFdgiGhnbuq9Jqik2bb3ucuB3bKT5fbXmT6
        IvCWnjBU9zyhCEFFkGQGcSNpdzEDU63hnGXOeBPJU0D9EBtZb9igOvNX98hT6PKJMD49r6
        5i+bq1RS4BKgx5Vni7MLEeIYdZUTDWoTgEM+CitHAwVRGuEwvKnrM2bne4IQQFaPVXzE2B
        CyyYxkd62G8K/R1Z1RPXbNQJwoMdSN23JIh/fdOxry3LSqSPcchjURzYey7OLLltgpzlLb
        SnO6x2XwxTJDq2q2VHYieXzYzNFWeQsn/AKKEtiOjtcJO6UlM+cbsxXdd1zYvg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3] cifs: replace kfree() with kfree_sensitive() for
 sensitive data
In-Reply-To: <20220920181035.8845-1-ematsumiya@suse.de>
References: <20220920181035.8845-1-ematsumiya@suse.de>
Date:   Tue, 04 Oct 2022 16:04:06 -0300
Message-ID: <87ilkz4di1.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Replace kfree with kfree_sensitive, or prepend memzero_explicit() in
> other cases, when freeing sensitive material that could still be left
> in memory.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/r/202209201529.ec633796-oliver.sang@intel.com
> ---
> v3: fix use-after-free reported by kernel test robot (this UAF existed before this patch,
>     actually), adjust commit message slightly
> v2: remove unnecessary NULL checks before kfree_sensitive()
>
>  fs/cifs/cifsencrypt.c | 12 ++++++------
>  fs/cifs/connect.c     |  6 +++---
>  fs/cifs/fs_context.c  | 12 ++++++++++--
>  fs/cifs/misc.c        |  2 +-
>  fs/cifs/sess.c        | 24 +++++++++++++++---------
>  fs/cifs/smb2ops.c     |  6 +++---
>  fs/cifs/smb2pdu.c     | 19 ++++++++++++++-----
>  7 files changed, 52 insertions(+), 29 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
