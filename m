Return-Path: <SRS0=i0zP=ZO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37297C432C0
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 16:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1356A20714
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 16:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfKVQ0m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:26:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46700 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfKVQ0m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Nov 2019 11:26:42 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iYBlO-00009b-M1; Fri, 22 Nov 2019 16:26:30 +0000
Date:   Fri, 22 Nov 2019 16:26:30 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     David Howells <dhowells@redhat.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cifs: Don't use iov_iter::type directly
Message-ID: <20191122162630.GD26530@ZenIV.linux.org.uk>
References: <20191121081923.GA19366@infradead.org>
 <157432403818.17624.9300948341879954830.stgit@warthog.procyon.org.uk>
 <30992.1574327471@warthog.procyon.org.uk>
 <20191121160725.GA19291@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121160725.GA19291@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Nov 21, 2019 at 08:07:25AM -0800, Christoph Hellwig wrote:

> > However, all the code that is doing direct accesses using '&' has to change to
> > make that work - so I've converted it all to using accessors so that I only
> > have to change the header file, except that the patch to do that crossed with
> > a cifs patch that added more direct accesses, IIRC.
> 
> But I still don't really see the point of the wrappers.  Maybe they are
> ok as a migration strategy, but in that case this patch mostly makes
> sense as part of the series only.

Wrappers have one benefit, though - they are greppable.  'type' really isn't.
_IF_ we go for "use that field directly", let's rename the damn field.
