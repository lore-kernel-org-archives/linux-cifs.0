Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D149C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 20:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3CDD6192D
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 20:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhCVUYV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 16:24:21 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:55502 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCVUYC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 16:24:02 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOR5j-008IYS-7B; Mon, 22 Mar 2021 20:23:59 +0000
Date:   Mon, 22 Mar 2021 20:23:59 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <palcantara@suse.de>,
        Steve French <stfrench@microsoft.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: broken hash use in fs/cifs/dfs_cache.c
Message-ID: <YFj83zCYiKZQgWSs@zeniv-ca.linux.org.uk>
References: <YFjYbftTAJdO+LNg@zeniv-ca.linux.org.uk>
 <87o8fbqbjc.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8fbqbjc.fsf@suse.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Mar 22, 2021 at 07:38:15PM +0100, Aurélien Aptel wrote:
> Al Viro <viro@zeniv.linux.org.uk> writes:
> > Either the key comparison or the hash function is wrong here.  *IF* something
> > external guarantees the full match, we don't need strcasecmp() - strcmp()
> > would work.  Otherwise, the hash function needs to be changed.
> 
> I think here we need to make the hash case-insensitive.
> 
> Perhaps calling jhash() with lower-cased bytes like so (pseudo-code):

[snip]

Then you really do not want to recalculate it again and again.
Look:

__lookup_cache_entry() calculates it for the key

lookup_cache_entry() contains
        if (cnt < 3) {
                h = cache_entry_hash(path, strlen(path));
                ce = __lookup_cache_entry(path);
                goto out;
        }

... and
                ce = __lookup_cache_entry(npath);
                if (!IS_ERR(ce)) {
                        h = cache_entry_hash(npath, strlen(npath));
                        break;
                }
(in a loop, at that)

Take a look at that the aforementioned loop:
        h = cache_entry_hash(npath, strlen(npath));
        e = npath + strlen(npath) - 1;
        while (e > s) {
                char tmp;

                /* skip separators */
                while (e > s && *e == sep)
                        e--;
                if (e == s)
                        goto out;

                tmp = *(e+1);
                *(e+1) = 0;

                ce = __lookup_cache_entry(npath);
                if (!IS_ERR(ce)) {
                        h = cache_entry_hash(npath, strlen(npath));
                        break;
                }

                *(e+1) = tmp;
                /* backward until separator */
                while (e > s && *e != sep)
                        e--;
        }
We call __lookup_cache_entry() for shorter and shorter prefixes of
npath.  They get NUL-terminated for the duration of __lookup_cache_entry(),
then reverted to the original.  What for?  cache_entry_hash() already
gets length as explicit argument.  And strcasecmp() is trivially
replaced with strncasecmp().

Just have __lookup_cache_entry() take key, hash and length.  Then it
turns into
		len = e + 1 - s;
		hash = cache_entry_hash(path, len);
		ce = __lookup_cache_entry(path, hash, len);
		if (!IS_ERR(ce)) {
			h = hash;
			break;
		}
and we are done.  No need to modify npath contents, undo the modifications
or *have* npath in the first place - the reason the current variant needs to
copy path is precisely that it goes to those contortions.

Incidentally, you also have a problem with trailing separators - anything
with those inserted into hash won't be found by lookup_cache_entry(),
since you trim the trailing separators from the key on searches.
