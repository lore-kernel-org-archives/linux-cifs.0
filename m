Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C83C433DB
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 17:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66BF06148E
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 17:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCVRsg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:48:36 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:54046 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhCVRsb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 13:48:31 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOOfF-008GTe-87; Mon, 22 Mar 2021 17:48:29 +0000
Date:   Mon, 22 Mar 2021 17:48:29 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     linux-cifs@vger.kernel.org
Cc:     Paulo Alcantara <palcantara@suse.de>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        linux-fsdevel@vger.kernel.org
Subject: broken hash use in fs/cifs/dfs_cache.c
Message-ID: <YFjYbftTAJdO+LNg@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

	Found while trying to untangle some... unidiomatic string handling
in cifs:

static struct cache_entry *__lookup_cache_entry(const char *path)
{
        struct cache_entry *ce;
        unsigned int h;
        bool found = false;

        h = cache_entry_hash(path, strlen(path));

        hlist_for_each_entry(ce, &cache_htable[h], hlist) {
                if (!strcasecmp(path, ce->path)) {
                        found = true;
                        dump_ce(ce);
                        break;
                }
        }

        if (!found)
                ce = ERR_PTR(-ENOENT);
        return ce;
}

combined with

static inline unsigned int cache_entry_hash(const void *data, int size)
{
        unsigned int h;

        h = jhash(data, size, 0);
        return h & (CACHE_HTABLE_SIZE - 1);
}

That can't possibly work.  The fundamental requirement for hashes is that
lookups for all keys matching an entry *MUST* lead to searches in the same
hash chain.  Here the test is strcasecmp(), so "foo" and "Foo" are expected
to match the same entry.  But jhash() yields different values on those -
it's a general-purpose hash, and it doesn't give a damn about upper and
lower case letters.  Moreover, even though we look at the value modulo
32, I don't believe that it's going to be case-insensitive.

Either the key comparison or the hash function is wrong here.  *IF* something
external guarantees the full match, we don't need strcasecmp() - strcmp()
would work.  Otherwise, the hash function needs to be changed.
