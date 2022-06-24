Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA58C43334
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jun 2022 21:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiFXV4K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jun 2022 17:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiFXV4K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jun 2022 17:56:10 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Jun 2022 14:56:09 PDT
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448D287B7A
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jun 2022 14:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SUgKVs7/jGpSheyNCdz1EXXAE1ML6F++Sd+H1f8ytmI=; b=M0xPDd0kpxH31Z+9AznHLvJ8i5
        zH8g7c0LrB8nY1Xat6Pkm99puJdkFashMSuD5+kB29DS3PPh9bsdQWzV/w8pcIFronN7/JS/s+xrZ
        i7MwI+N0GKGbbtBLrX+09Mzzf3J0Tjee35AfXJvbg2cD9NCJ3vurUtN/kaBTzFNSsZqzteqhcE3Kw
        2GNrkBMlvgF/9l3axE+kCy/PrA3DDnZk1Bw+gwwgqhVRz3LIHNAe/Gmy/DJiuJhJrlZvkZ3ADJLhK
        VfQHh42RY9uuWA0kH3hYl8iAgIo6iD81OTPI9hADxYZbpDhK4HiMqNANBOMM09c6hHtjUhp4rY19v
        ZGzogQiA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1o4qjH-0044TB-Lp;
        Fri, 24 Jun 2022 21:20:40 +0000
Date:   Fri, 24 Jun 2022 22:20:39 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-cifs@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/6] ksmbd: use vfs_llseek instead of dereferencing NULL
Message-ID: <YrYqp1eaxEcQxIeo@ZenIV>
References: <20220624165631.2124632-1-Jason@zx2c4.com>
 <20220624165631.2124632-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624165631.2124632-2-Jason@zx2c4.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 24, 2022 at 06:56:26PM +0200, Jason A. Donenfeld wrote:
> By not checking whether llseek is NULL, this might jump to NULL. Also,
> it doesn't check FMODE_LSEEK. Fix this by using vfs_llseek(), which
> always does the right thing.

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
