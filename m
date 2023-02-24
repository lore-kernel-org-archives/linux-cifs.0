Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CC8C6FA8E
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Feb 2023 17:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBXRXv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBXRXu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Feb 2023 12:23:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367B01968A
        for <linux-cifs@vger.kernel.org>; Fri, 24 Feb 2023 09:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677259388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fRYK0MsjqV5B1YODg8uGsmehuhwPYk48TBRRGZHiyX4=;
        b=SjndmboZgoFzvrHp01JJA2tVyGHnMoZLsPZjBBZ4bm2q6W717IzSm/hhX1yBbz6Ju1l3dY
        NhSnNc3GJYk4dmD8aapK+PTYuwMCObidp+nS7PbA2yoAHYvl+51zoR6C8eLfIYeVkB5r2f
        U803gps3MJvyLafI58R4lNJ8xJrd9/Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-RVuFmVE2Owq3TQkaFqbO9A-1; Fri, 24 Feb 2023 12:23:00 -0500
X-MC-Unique: RVuFmVE2Owq3TQkaFqbO9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F31093C01DE8;
        Fri, 24 Feb 2023 17:22:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F11A2166B29;
        Fri, 24 Feb 2023 17:22:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wgPPFN0MvHYwtaPAtQkDFHwZrDXxZ+bOWk-qSyGMiLV6g@mail.gmail.com>
References: <CAHk-=wgPPFN0MvHYwtaPAtQkDFHwZrDXxZ+bOWk-qSyGMiLV6g@mail.gmail.com> <2134430.1677240738@warthog.procyon.org.uk> <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com> <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org> <2213409.1677249075@warthog.procyon.org.uk> <2244151.1677251586@warthog.procyon.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dhowells@redhat.com, Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Matthew Wilcox <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] cifs: Improve use of filemap_get_folios_tag()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2385426.1677259377.1@warthog.procyon.org.uk>
Date:   Fri, 24 Feb 2023 17:22:57 +0000
Message-ID: <2385427.1677259377@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Of course, I'd be even happier if Willy is right and the code could
> use the generic write_cache_pages() and avoid all of these things
> entirely. I'm not clear on why cifs and afs are being so different in
> the first place, and some of the differences are just odd (like that
> skip count).

The main reason is that write_cache_pages() doesn't (and can't) check
PG_fscache (btrfs uses PG_private_2 for other purposes).  NFS, 9p and ceph,
for the moment, don't cache files that are open for writing, but I'm intending
to change that at some point.  The intention is to unify the writepages code
for at least 9p, afs, ceph and cifs in netfslib in the future.

David

