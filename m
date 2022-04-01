Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCD5C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 01:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbiDABWc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 21:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243718AbiDABWc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 21:22:32 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A8E26D5
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 18:20:43 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1na5xx-001NkK-Ip; Fri, 01 Apr 2022 01:20:41 +0000
Date:   Fri, 1 Apr 2022 01:20:41 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [GIT PULL] ksmbd server fixes
Message-ID: <YkZTaeF71ZnaF7+e@zeniv-ca.linux.org.uk>
References: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
 <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 29, 2022 at 06:48:51PM -0700, Linus Torvalds wrote:
> On Mon, Mar 28, 2022 at 6:39 PM Steve French <smfrench@gmail.com> wrote:
> >
> > - four patches relating to dentry race
> 
> I took a look at this, and I absolutely hate it.
> 
> You are basically exporting vfs-internal functions (__lookup_hash() in
> particular) that really shouldn't be exported.
> 
> And the _reason_ you are exporting them seems to be that you have
> copied most of do_renameat2() as ksmbd_vfs_rename() but then made
> various small changes.
> 
> This all makes me _very_ uncomfortable.
> 
> I really get the feeling that we'd be much better off exporting
> something that is just a bigger part of that rename logic, not that
> really low-level __lookup_hash() thing.
> 
> >From what I can tell, almost everything between that __lookup_hash()
> and the final vfs_rename() call is shared, even to the point of error
> label names (ok, you call it "out5", the vfs layer calls it "exit5".
> 
> The main exception is that odd
> 
>         parent_fp = ksmbd_lookup_fd_inode(old_parent->d_inode);
>         if (parent_fp) {
>               ...
> 
> sequence, but that looks like it could have been done before the
> __lookup_hash() too.

If only...  Note that
        if (old_dentry != old_child) {
		err = -ESTALE;
		dput(old_dentry);
		goto out4;
	}
thing in there.  -ESTALE is actually wrong - what happens there is
a lost race with rename.  

The source of headache is that they are trying to implement not
"rename this entry in this directory to that entry in that directory";
it's "rename an opened file, no matter which directory it's in".

Comes from shit-for-brains protocol, that tries both to treat file
name as a piece of metadata (which, in itself, would be defensible)
*and* allow cross-directory moves.  Shoved into the same fchown-like
scheme.

So they end up with source already looked up.  We want both parents
locked and we bloody well want them to be the parents of the objects
we'll operate upon.

What that code does is
	* pin a reference to current parent of source
	* look the parent of destination of up
	* lock both
	* ... and pray that child is still the child of what we'd locked.
	*	for that, take a snapshot of its name (it's not guaranteed
		to be stable otherwise)
	*	look that name up in what used to be its parent
	*	... and see if what we've got is our source.

In case of mismatch (i.e. cross-directory rename at any point between
dget_parent() and the end of lock_rename()) we fail with -ESTALE.  Note
that we do *not* do anything of that sort if that cross-directory rename
happens just prior to dget_parent() - that is accepted just fine.

This is bogus.  That song and dance is done after we'd locked the
thing that used to be the parent of source.  At that point nothing
can move into or out of that sucker, so all we need is a check that
old_child->d_parent is equal to old_parent and, probably, that it's
still hashed.

No re-lookup is needed.  What's more, I suspect that the right thing
to do would be a specialized variant of lock_rename() that would
take source and new parent and do the following:

	if (READ_ONCE(source->d_parent) == new_parent) {
		inode_lock_nested(new_parent->d_inode, I_MUTEX_PARENT);
		if (likely(source->d_parent == new_parent))
			return NULL;
	}
	// fuck that, looks like a cross-rename one.
	mutex_lock(&source->d_sb->s_vfs_rename_mutex);
	// now all ->d_parent are stable
	if (unlikely(source->d_parent == new_parent)) {
		inode_lock_nested(new_parent->d_inode, I_MUTEX_PARENT);
		// we want the same rules as for lock_rename()
		mutex_unlock(&source->d_sb->s_vfs_rename_mutex);
		return NULL;
	}
	// cross-directory it is...
	same as lock_rename() after having grabbed ->s_vfs_rename_mutex

Pass old_child and new_path.dentry to this lock_rename() analogue.
As soon as it returns, we know that old_child->d_parent is stable,
that it and new_path.dentry are properly locked for rename.
No dget_parent() needed (just dget(old_child->d_parent)), no need to
bother with re-lookups, snapshots, etc. - check that old_child is
still hashed and if it isn't, we really can return a hard error.
Unlike this -ESTALE, it's not a transient condition.

To be paired with unlock_rename() - just remember to pass it the
value of old_child->d_parent taken *before* vfs_rename().  And
it would have to live in fs/namei.c, right next to lock_rename(),
obviously.

I don't think that __lookup_hash() makes a good _name_ (or calling
conventions) to expose, but it's not really different from e.g.
lookup_one_len() as far exposing internals is concerned.
We want the parent held exclusive and that's all there is to it.

BTW, what the hell is this about?
        if (d_is_symlink(new_path.dentry)) {
		err = -EACCES;
		goto out2;
	}
new_path is the new parent; why bother with that check at all?
It's not as if any kind of lookup in it would have a chance to
succeed...

> I'd be even happier if we could actually hjave some common helper
> starting at that
> 
>         trap = lock_rename(...);
> 
> because that whole locking and 'trap' logic is kind of a big deal, and
> the locking is the only thing that makes __lookup_hash() work.
> 
> Adding Al to the cc in case he has any ideas. Maybe he's ok with this
> whole thing, and with his blessing I'll take this pull as-is, but as
> it is I'm not comfortable with it.

Unfortunately, it's not similar to rename(2) - different things given
to it ;-/  Bits and pieces might be possible to factorize, but the
difference in what we start from is fundamental.
