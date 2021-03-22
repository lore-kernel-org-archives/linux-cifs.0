Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FF5C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 18:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE2AA61994
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 18:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhCVSX7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:23:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:44218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231651AbhCVSX5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Mar 2021 14:23:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 22EC4AB8A;
        Mon, 22 Mar 2021 18:23:56 +0000 (UTC)
From:   Paulo Alcantara <palcantara@suse.de>
To:     Al Viro <viro@zeniv.linux.org.uk>, linux-cifs@vger.kernel.org
Cc:     Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: broken hash use in fs/cifs/dfs_cache.c
In-Reply-To: <YFjYbftTAJdO+LNg@zeniv-ca.linux.org.uk>
References: <YFjYbftTAJdO+LNg@zeniv-ca.linux.org.uk>
Date:   Mon, 22 Mar 2021 15:23:53 -0300
Message-ID: <87pmzrrqrq.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> 	Found while trying to untangle some... unidiomatic string handling
> in cifs:
>
> static struct cache_entry *__lookup_cache_entry(const char *path)
> {
>         struct cache_entry *ce;
>         unsigned int h;
>         bool found = false;
>
>         h = cache_entry_hash(path, strlen(path));
>
>         hlist_for_each_entry(ce, &cache_htable[h], hlist) {
>                 if (!strcasecmp(path, ce->path)) {
>                         found = true;
>                         dump_ce(ce);
>                         break;
>                 }
>         }
>
>         if (!found)
>                 ce = ERR_PTR(-ENOENT);
>         return ce;
> }
>
> combined with
>
> static inline unsigned int cache_entry_hash(const void *data, int size)
> {
>         unsigned int h;
>
>         h = jhash(data, size, 0);
>         return h & (CACHE_HTABLE_SIZE - 1);
> }
>
> That can't possibly work.  The fundamental requirement for hashes is that
> lookups for all keys matching an entry *MUST* lead to searches in the same
> hash chain.  Here the test is strcasecmp(), so "foo" and "Foo" are expected
> to match the same entry.  But jhash() yields different values on those -
> it's a general-purpose hash, and it doesn't give a damn about upper and
> lower case letters.  Moreover, even though we look at the value modulo
> 32, I don't believe that it's going to be case-insensitive.

Good catch!  Yes, it is completely broken.

> Either the key comparison or the hash function is wrong here.  *IF* something
> external guarantees the full match, we don't need strcasecmp() - strcmp()
> would work.  Otherwise, the hash function needs to be changed.

Agreed.

I'll look into it.  Thanks!
