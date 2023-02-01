Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41E8C38142
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Feb 2023 08:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjBAIxR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Feb 2023 03:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjBAIxR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Feb 2023 03:53:17 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA1938EB8;
        Wed,  1 Feb 2023 00:53:14 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pN8rD-006In5-1j; Wed, 01 Feb 2023 16:52:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Feb 2023 16:52:43 +0800
Date:   Wed, 1 Feb 2023 16:52:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, dhowells@redhat.com, viro@zeniv.linux.org.uk,
        nspmangalore@gmail.com, rohiths.msft@gmail.com, tom@talpey.com,
        metze@samba.org, hch@infradead.org, willy@infradead.org,
        jlayton@kernel.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfrench@samba.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 05/12] cifs: Add a function to Hash the contents of an
 iterator
Message-ID: <Y9ooW52m0Afnhj7Z@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131182855.4027499-6-dhowells@redhat.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:
> Add a function to push the contents of a BVEC-, KVEC- or XARRAY-type
> iterator into a symmetric hash algorithm.

There is no such thing as a symmetric hash.  You're using shash
which stands for synchronous hash.

In any case, as I said in the previous review this is abusing the
shash API.  Please use ahash instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
