Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEE2C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 12:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiL2MRL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 07:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiL2MRD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 07:17:03 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C533310FFE
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 04:17:01 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id DBEE17FC20;
        Thu, 29 Dec 2022 12:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1672316219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5CXggY7lBhmfDQ81OA7h+Dd86G89wWPBLlUr4oD44S4=;
        b=TMsz3OGuLt3QK2BPPU+eyLVUcfmWPgpNeK3cMPAMunezGY1l+mv6g1wee9q6O8B36N78DO
        unvCSTqwD2s3ozH53myg8uJUpriI+rklxFjobYh2Xm5GGC7WUGGTBniS1tPrycW7vUAfp7
        KUKsiZwXOYLsaZiucTG2DbOdtANNq8aU1wRjRzrCslkvm0L+C6z9izJCpiigANpWV2Dk7+
        +lG4Wx4jUaJ8jeZoimmROmrWOq2ZeMGIrRErbcBV0D1azo/RTKah+ugY+GxJaMDvp++sE7
        YRVcEL0TWVV16/mlY0/CtPwx5QUH+us87vEwBZRlM60P3ctUPsY0+61PJG5pyw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: Re: Deadlock in Ubuntu 5.4 kernel
In-Reply-To: <CANT5p=qEwppcgZvbdLaABb6M-pRxyDQ05oHOb523n34tYyDqcw@mail.gmail.com>
References: <CANT5p=qEwppcgZvbdLaABb6M-pRxyDQ05oHOb523n34tYyDqcw@mail.gmail.com>
Date:   Thu, 29 Dec 2022 09:16:54 -0300
Message-ID: <87a6364d6x.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> A customer reported this deadlock in a Kubernetes setup running on Ubuntu-18.04.
> This must be a 5.4 kernel, running this code:
> https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-azure/+git/bionic
>
> Based on the stack, it appears to be a hang in DFS reconnect codepath,
> trying to access the DFS cache lock in dfs_cache_update_vol.
>
> Can you tell if this is a known issue that has been fixed since?

Looks like this has been fixed by

        06d57378bcc9 ("cifs: Fix potential deadlock when updating vol in cifs_reconnect()")

> And if Ubuntu should backport any fix to 5.4?

I would say so.  It would probably also require others dfs related
patches to be backported in addition to the above.

> I could not find the function in the mainline codebase.

Yes, it has changed alot.
