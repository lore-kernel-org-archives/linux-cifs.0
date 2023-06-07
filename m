Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F98C77B7A
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jun 2023 19:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjFGTHP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjFGTHN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jun 2023 15:07:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C73E8E;
        Wed,  7 Jun 2023 12:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACFB463D85;
        Wed,  7 Jun 2023 19:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F52C433EF;
        Wed,  7 Jun 2023 19:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686164832;
        bh=G8DEs9I7UH+XGHugDOSGDS8/fXnM7e5FafIGJcFDcTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lBuNueS1YZPZOhG8R2S21CP0YB45duJ/rLit1ecL5OOL/6lthveTZJDDRt+YGG0R+
         N8tICWPYPZ6aQ+X9HB0bBx73k0pt1Rnnc3Ma4vCoP0/OX825dcG81uf+CIO8IBfK+J
         ex6P+HiEXbvj0+wYhUVHiDTH6CzdlvODwvoRs5yU=
Date:   Wed, 7 Jun 2023 21:07:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     sfrench@samba.org, stable@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4 0/2] Backport few dfs related fixes to cifs
Message-ID: <2023060750-unpledged-effective-bd95@gregkh>
References: <20230607185313.11363-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607185313.11363-1-risbhat@amazon.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jun 07, 2023 at 06:53:11PM +0000, Rishabh Bhatnagar wrote:
> Recently we have been seeing kernel panic in cifs_reconnect function
> while accessing tgt_list. Looks like tgt_list is not initialized
> correctly. There are fixes already present in 5.10 and later trees.
> Backporting them to 5.4
> 
>  CIFS VFS: \\172.30.1.14 cifs_reconnect: no target servers for DFS
>  failover
>  BUG: unable to handle page fault for address: fffffffffffffff8
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 260e067 P4D 260e067 PUD 2610067 PMD 0
>  Oops: 0000 [#1] SMP PTI
>  RIP: 0010:cifs_reconnect+0x51d/0xef0 [cifs]
>  RSP: 0018:ffffc90000693da0 EFLAGS: 00010282
>  RAX: fffffffffffffff8 RBX: ffff8887fa63b800 RCX: fffffffffffffff8
>  Call Trace:
>  cifs_handle_standard+0x18d/0x1b0 [cifs]
>  cifs_demultiplex_thread+0xa5c/0xc90 [cifs]
>  kthread+0x113/0x130
> 
> *** BLURB HERE ***

No blurb?

And this says 5.4, yet your patches say 5.10?

Totally confused...

greg k-h
