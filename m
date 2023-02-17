Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E4CC61DA4
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 03:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBQDES (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 22:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQDER (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 22:04:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AC953816;
        Thu, 16 Feb 2023 19:04:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B83E0B82AF2;
        Fri, 17 Feb 2023 03:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE80C433EF;
        Fri, 17 Feb 2023 03:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676603054;
        bh=tnwZHUNV/A6Ohqf/7DM1M/eShouPHHc1DKhnpkFHCH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3kP69MGqucrdNFfVA9sfK7SZKXlnLHxzCNecX4QorMGw56xDYPqlkLmfBrNM5ESi
         fo9+TpSFCATip2io+s3YbuZfexRP3UkuB/keMdtDlQ6OYKV3UWlo+L+64+H9tJpKWM
         86B53aphhQsaDhVD22TWo1HCVbVjNrt55jTiU4+7xpwH8uyG+KAMZbFkxDcRdEx3tH
         YDSTQSBR3kiz87IVpJMIH0VjoFHdrL545VuTBV0mYB85SgPDGToZfluyPaPLHpyybB
         4U4EH/pchFibuT0JFWL0oPukXI7ycYim1aE4dJAs9z3oeUIBw5qityrcPFvuOLPh6L
         3Zh2R2tQHQaBg==
Date:   Thu, 16 Feb 2023 19:04:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 11/17] cifs: Add a function to Hash the contents of an
 iterator
Message-ID: <Y+7urFTFOCXOq5kp@sol.localdomain>
References: <20230216214745.3985496-1-dhowells@redhat.com>
 <20230216214745.3985496-12-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216214745.3985496-12-dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Feb 16, 2023 at 09:47:39PM +0000, David Howells wrote:
> Add a function to push the contents of a BVEC-, KVEC- or XARRAY-type
> iterator into a symmetric hash algorithm.

I think you mean a "synchronous hash algorithm".

- Eric
