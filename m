Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FE9C38142
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Jan 2023 10:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjA0Ki7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Jan 2023 05:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjA0Ki5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Jan 2023 05:38:57 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188121735;
        Fri, 27 Jan 2023 02:38:52 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pLM7x-004gYD-Ql; Fri, 27 Jan 2023 18:38:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Jan 2023 18:38:37 +0800
Date:   Fri, 27 Jan 2023 18:38:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, viro@zeniv.linux.org.uk,
        nspmangalore@gmail.com, rohiths.msft@gmail.com, tom@talpey.com,
        metze@samba.org, hch@infradead.org, willy@infradead.org,
        jlayton@kernel.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfrench@samba.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 06/13] cifs: Add a function to Hash the contents of an
 iterator
Message-ID: <Y9OprbIBseKadiej@gondor.apana.org.au>
References: <Y9Om95NlPTFiHMSj@gondor.apana.org.au>
 <2957463.1674815638@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2957463.1674815638@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jan 27, 2023 at 10:33:58AM +0000, David Howells wrote:
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > Please convert this to ahash.  The whole point of shash is to
> > process *small* amounts of data that is not on an SG list.
> 
> Is ahash offloaded to another thread or hardware?

That's something you can control when you allocate the ahash
object? You could even restrict it to sync algorithms by setting
type to 0 and mask to CRYPTO_ALG_SYNC.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
