Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5146F47605C;
	Fri,  4 Sep 2026 11:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788520318; cv=none; b=GP8+oM4yKdKP2AXuJAgDPU3xgHgwBCyn9C4Hfv+djyDwhj+s+QiDopfYzmU41cg0xWtCVQS06BQcX9A570rbdr/uhKtaE5YZdQ6EkMo1Mz6uV6EoUZ0Zi1v/YcKVDxVA+Jh4X/nL7eIq9+Ytcpu4C04CWl/vDLDbpsrhcf58b2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788520318; c=relaxed/simple;
	bh=LucPl5wpiXhubkDHUJGCXwCDLV3zcb0boTvESRiFrSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKQN7KzPfIHdqsOvPzptvMCXXWaAXizzdQofLilQSvT0OfBnB4yLGzinf9tT8/5C12bwrMq7JkXN/JDeaM7QL0g+yfLoPavkPiC0SKnq5Ps/WqXi/kGTF+QiKsY23A+HSGREjtKKGvqetEy6x8jsnkunK1pr8cNCcLEOOHy3kkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHXvXP0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHXvXP0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9F51F00A3D;
	Fri,  4 Sep 2026 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788520316;
	bh=TRMsq4nqQL0fBcw/P7GxsAHRsBPM0zF4AlxgHiF//tA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XHXvXP0qoloSDDF+PJgvYn+wsZtUBr6M6yNp0gksJa5AXaWtf7CBOc5UIAvZJcgYa
	 LFPT2wf2mU0R34aQr/hmILDsoWK41JJbs+gLcs+/XFzd/rqz83bA45xVKMA50fwjW6
	 TYdJolvLC+86FgBbJ4qZHPUHqvvwO7shosao7BUtoyFXsHhF2HCdp1Q8wXSwWFcVFl
	 orUaI5skPo0bJGQoRsb7ZZYHfMca0we6LEN21veggRCA7MHLxy+laoMsUekHkFAYA6
	 ol2zkipllA0zpHWhKsA184IgFMSuSOqZaApIRPV8BPovueolntFz6c57lz3TbRtczB
	 bFDtsa59Qi5FQ==
Date: Fri, 4 Sep 2026 13:11:53 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Paulo Alcantara <pc@manguebit.org>, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] super: make iterate_supers_type() deletion-safe
Message-ID: <20260904-rockkonzert-bergtour-dahin-23c9c5c87d0f@brauner>
References: <20260903013336.92081-1-kmehltretter@gmail.com>
 <32afuwcqxfzvc2qwsvx6ecpyvbunr45wnvmezbbqzz25qtfn35@tvotjvtm3soe>
 <20260904-astronaut-anpfiff-unbebaut-743381f4995a@brauner>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260904-astronaut-anpfiff-unbebaut-743381f4995a@brauner>

On Fri, Sep 04, 2026 at 12:29:39PM +0200, Christian Brauner wrote:
> On Thu, Sep 03, 2026 at 12:16:14PM +0200, Jan Kara wrote:
> > On Thu 03-09-26 03:33:36, Karl Mehltretter wrote:
> > > iterate_supers_type() drops sb_lock while invoking the callback and keeps
> > > only a passive reference to the current superblock. That reference keeps
> > > the object allocated, but does not keep its s_instances node linked.
> > > 
> > > After the callback releases s_umount, final teardown can unlink the current
> > > s_instances node. The iterator then advances through a reinitialized node.
> > > With the current hlist it stops without visiting the remaining superblocks.
> > > The unlink moved from generic_shutdown_super() to kill_super_notify(), but
> > > the cursor lifetime has been unsafe since the helper was introduced.
> > > 
> > > The CIFS DFS lookup can consequently miss a matching superblock and return
> > > -EINVAL.
> > > 
> > > Walk the global superblock list in reverse and filter it by filesystem
> > > type. A passive reference keeps its s_list node linked, and reverse
> > > traversal preserves newest-first visitation. Superblocks removed from
> > > fs_supers remain on the global list, but teardown marks them SB_DYING
> > > before unlinking them, so the existing filter excludes them.
> > > 
> > > This broadens the scan from superblocks of one type to all superblocks.
> > > The only in-tree caller is the CIFS DFS lookup, so the broader scan is
> > > limited to that path.
> > > 
> > > Fixes: 43e15cdbefea ("new helper: iterate_supers_type()")
> > > Cc: stable@vger.kernel.org
> > > Assisted-by: LLM
> > > Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> > 
> > Good spotting! But what I'm wondering about is whether we just shouldn't
> > move where we delete sb from fs_supers. Currently we do that in
> > kill_super_notify() to hide the sb from sget_fc() (which would otherwise
> > permanently retry and call test() for S_DEAD sb which can cause problems).
> > But if we just skipped S_DEAD superblocks in sget_fc(), we could move
> > removal from fs_supers list to put_super() (make it symmetric with the
> > handling of super_blocks list) and that would also fix
> > iterate_supers_type(). Christian, what do you think?
> 
> Yes, that might work work.

Draft, feel free to grab, Jan or Karl.

---
 fs/kernfs/mount.c |  4 ++--
 fs/super.c        | 39 +++++++++++++++++++--------------------
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f183a96778b9..a57399021c8b 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -434,8 +434,8 @@ void kernfs_kill_sb(struct super_block *sb)
 	up_write(&root->kernfs_supers_rwsem);
 
 	/*
-	 * Remove the superblock from fs_supers/s_instances
-	 * so we can't find it, before freeing kernfs_super_info.
+	 * Mark the superblock dead so sget_fc() can't find it,
+	 * before freeing kernfs_super_info.
 	 */
 	kill_anon_super(sb);
 	kfree(info);
diff --git a/fs/super.c b/fs/super.c
index 05e443173038..0f9e13eedb4f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -433,15 +433,19 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 void put_super(struct super_block *s)
 {
 	if (refcount_dec_and_test(&s->s_passive)) {
+		struct file_system_type *type = s->s_type;
 
 		spin_lock(&sb_lock);
 		list_del_init(&s->s_list);
+		hlist_del_init(&s->s_instances);
 		spin_unlock(&sb_lock);
 
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(s->s_mounts);
 		call_rcu(&s->rcu, destroy_super_rcu);
+		/* The unlink above may touch type->fs_supers, so drop it last. */
+		put_filesystem(type);
 	}
 }
 
@@ -558,17 +562,6 @@ static void kill_super_notify(struct super_block *sb)
 	if (sb->s_flags & SB_DEAD)
 		return;
 
-	/*
-	 * Remove it from @fs_supers so it isn't found by new
-	 * sget_fc() walkers anymore. Any concurrent mounter still
-	 * managing to grab a temporary reference is guaranteed to
-	 * already see SB_DYING and will wait until we notify them about
-	 * SB_DEAD.
-	 */
-	spin_lock(&sb_lock);
-	hlist_del_init(&sb->s_instances);
-	spin_unlock(&sb_lock);
-
 	/* Drop sget_fc()'s claim; a never-registered entry stays with the sb. */
 	if (sb->s_super_dev->sd_dev) {
 		super_dev_put(sb->s_super_dev);
@@ -577,11 +570,15 @@ static void kill_super_notify(struct super_block *sb)
 
 	/*
 	 * Let concurrent mounts know that this thing is really dead.
-	 * We don't need @sb->s_umount here as every concurrent caller
-	 * will see SB_DYING and either discard the superblock or wait
-	 * for SB_DEAD.
+	 * sget_fc() skips SB_DEAD superblocks and calls test() under
+	 * sb_lock, so set it under sb_lock: once we return no test()
+	 * runs on this superblock anymore and none will start. Everyone
+	 * else already saw SB_DYING and either discarded the superblock
+	 * or waits for SB_DEAD.
 	 */
+	spin_lock(&sb_lock);
 	super_wake(sb, SB_DEAD);
+	spin_unlock(&sb_lock);
 }
 
 /**
@@ -608,7 +605,6 @@ void deactivate_locked_super(struct super_block *s)
 		list_lru_destroy(&s->s_dentry_lru);
 		list_lru_destroy(&s->s_inode_lru);
 
-		put_filesystem(fs);
 		put_super(s);
 	} else {
 		super_unlock_excl(s);
@@ -795,12 +791,12 @@ void generic_shutdown_super(struct super_block *sb)
 	}
 	/*
 	 * Broadcast to everyone that grabbed a temporary reference to this
-	 * superblock before we removed it from @fs_supers that the superblock
-	 * is dying. Every walker of @fs_supers outside of sget_fc() will now
-	 * discard this superblock and treat it as dead.
+	 * superblock that it is dying. Every walker of @fs_supers outside
+	 * of sget_fc() will now discard this superblock and treat it as
+	 * dead.
 	 *
-	 * We leave the superblock on @fs_supers so it can be found by
-	 * sget_fc() until we passed sb->kill_sb().
+	 * sget_fc() keeps finding the superblock until SB_DEAD is set, so
+	 * a concurrent mounter waits until we passed sb->kill_sb().
 	 */
 	super_wake(sb, SB_DYING);
 	super_unlock_excl(sb);
@@ -879,6 +875,9 @@ struct super_block *sget_fc(struct fs_context *fc,
 	spin_lock(&sb_lock);
 	if (test) {
 		hlist_for_each_entry(old, &fc->fs_type->fs_supers, s_instances) {
+			/* Only unlinked at the last passive reference. */
+			if (super_flags(old, SB_DEAD))
+				continue;
 			if (test(old, fc))
 				goto share_extant_sb;
 		}
-- 
2.53.0

