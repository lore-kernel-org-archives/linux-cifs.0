Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3044CCDB474
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Oct 2023 17:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjJPRbR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Oct 2023 13:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbjJPRbH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Oct 2023 13:31:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50146A7;
        Mon, 16 Oct 2023 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yLqLiO937F4b67IKVnxwlg7DScyO6XZyFuWgKPb++No=; b=L1zCkWf6sNpT4565aixenhdGzR
        DJ47v2X4sBmxJbecCe3NUKOhIUzK0Si5HChZCsFnKqdAnVlwGMP7X1pSG+gvuG2rG7GGrPYpeOqf8
        l0J7ExE2vIDMc2A+p3JTK6Qwcu2sZN+lNB/MyNqg7RjBaik+S7XUT9gPVA46uclofeXWPU109y2Xs
        eTABCOwFjsEe4+MOdk4YiF2j7UQYtih2hRWh/4hS5BFFje0KFHYSN9+4ilxnP/6zdl8LD/G+PeiM3
        QeW+uUzICWEHeWXUyPP47eaZdg6CeP2/2cZbpCc662thbzWxh3J7dI8MRlYtrhB5ATDzanIkAwXB6
        gJ+UWNEQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsRQY-007NmB-Gn; Mon, 16 Oct 2023 17:30:50 +0000
Date:   Mon, 16 Oct 2023 18:30:50 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH][SMB3 client] fix touch -h of symlink
Message-ID: <ZS1zSoRwv+yr5BHS@casper.infradead.org>
References: <CAH2r5mui-uk5XVnJMM2UQ40VJM5dyA=+YChGpDcLAapBTCk4kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mui-uk5XVnJMM2UQ40VJM5dyA=+YChGpDcLAapBTCk4kw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 16, 2023 at 12:26:23PM -0500, Steve French wrote:
> For example:
>           touch -h -t 02011200 testfile
>     where testfile is a symlink would not change the timestamp, but
>           touch -t 02011200 testfile
>     does work to change the timestamp of the target
> 
> Looks like some symlink inode operations are missing for other fs as well

Do we have an xfstests for this?

