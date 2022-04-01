Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5BCC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 13:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbiDANgI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 09:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238533AbiDANgI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 09:36:08 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B12C14A6D7
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 06:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=quVYRh0fEdTM1F2UwsnqDhYFSYdtz94cQcLsxAqU6yU=; b=TeJ++a/FYjGsVDYZROkuXUZhHL
        KHfRynsy9zxQVtQX+RBpOCSyCUud5l9Mi+xiDdC/hmG9Q+rq4CLkxbj61l8gf64QZ1rBcyWaNxxBt
        Xe8uEt+AtCtg2icG968ka1i+1woBWKzgBaVGiuUo/qqcM3pdvlkwrv0EoPWtSmbea3nAiEIrmWpns
        UNyCoaeH/ELLqeECXm25+ogL5l4elm1uB5Pgha2asGrbhR9kAM9HCqexvCtw8+XI6dbGzOF4LZTF5
        u+YvbyB5+liSCVhSyBQq3ulsZeDxVVQ8T4NtnVtnpT7pX9NNbEPV5dYN/NYzOSifIkOBNJ8Xd+2DT
        ctlbAlkg==;
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naHPo-001ZjD-EJ; Fri, 01 Apr 2022 13:34:12 +0000
Date:   Fri, 1 Apr 2022 13:34:12 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [GIT PULL] ksmbd server fixes
Message-ID: <Ykb/VH9fvQT0bNiK@zeniv-ca.linux.org.uk>
References: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
 <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
 <YkZTaeF71ZnaF7+e@zeniv-ca.linux.org.uk>
 <CAKYAXd96PJL26_7xEhbynRG=ZPjLo6gQu-EjvVFup3pBhi2Agg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd96PJL26_7xEhbynRG=ZPjLo6gQu-EjvVFup3pBhi2Agg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 01, 2022 at 09:52:09PM +0900, Namjae Jeon wrote:
> > take source and new parent and do the following:
> >
> > 	if (READ_ONCE(source->d_parent) == new_parent) {
> > 		inode_lock_nested(new_parent->d_inode, I_MUTEX_PARENT);
> > 		if (likely(source->d_parent == new_parent))
> > 			return NULL;
and
		inode_unlock(new_parent->d_inode);
to do locking in proper order...

> > 	}
> > 	// fuck that, looks like a cross-rename one.
> > 	mutex_lock(&source->d_sb->s_vfs_rename_mutex);
> > 	// now all ->d_parent are stable
> > 	if (unlikely(source->d_parent == new_parent)) {
> > 		inode_lock_nested(new_parent->d_inode, I_MUTEX_PARENT);
> > 		// we want the same rules as for lock_rename()
> > 		mutex_unlock(&source->d_sb->s_vfs_rename_mutex);
> > 		return NULL;
> > 	}
> > 	// cross-directory it is...
> > 	same as lock_rename() after having grabbed ->s_vfs_rename_mutex

// p1 != p2, p1->d_sb == p2->d_sb, p1->d_sb->s_vfs_rename_mutex held
static struct dentry *lock_two_directories(struct dentry *p1, struct dentry *p2)
{
        struct dentry *p;

        p = d_ancestor(p2, p1);
        if (p) {
                inode_lock_nested(p2->d_inode, I_MUTEX_PARENT);
                inode_lock_nested(p1->d_inode, I_MUTEX_CHILD);
                return p;
        }

        p = d_ancestor(p1, p2);
        if (p) {
                inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
                inode_lock_nested(p2->d_inode, I_MUTEX_CHILD);
                return p;
        }

        inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
        inode_lock_nested(p2->d_inode, I_MUTEX_PARENT2);
        return NULL;
}

struct dentry *lock_rename(struct dentry *p1, struct dentry *p2)
{
        if (p1 == p2) {
                inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
                return NULL;
        }

        mutex_lock(&p1->d_sb->s_vfs_rename_mutex);
	return lock_two_directories(p1, p2);
}

struct dentry *lock_rename_child(struct dentry *c1, struct dentry *p2)
{
	if (READ_ONCE(c1->d_parent) == p2) {
		inode_lock_nested(p2->d_inode, I_MUTEX_PARENT);
		if (likely(c1->d_parent == p2))
			return NULL;

		// too bad, we'd raced with another rename
		inode_unlock(p2->d_inode);
	}

	// looks like it's cross-directory
	mutex_lock(&c1->d_sb->s_vfs_rename_mutex);

	// recheck, now that ->d_parent is stable
	if (likely(c1->d_parent != p2))
		return lock_two_directories(c1->d_parent, p2);

	// it's not cross-directory, after all - raced with another rename
	inode_lock_nested(p2->d_inode, I_MUTEX_PARENT);
	// drop ->s_vfs_rename_mutex, so we won't confuse unlock_rename()
	// note that locked p2 alone is enough to prevent moves to or from
	// p2, so c1->d_parent will remain p2 until we unlock p2
	mutex_unlock(&c1->d_sb->s_vfs_rename_mutex);
	return NULL;
}
