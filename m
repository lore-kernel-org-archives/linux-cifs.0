Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E9A3D25DC
	for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 19:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779046961; cv=none; b=WyG9gzlmKA/ouD2bE+nY3rbqAEgU3TYMUo2q9fGH8lBAaFeDiNdLZam91jEkmt2yZ1qnmaRzjXLM+tYTOAna6c4WQ7IwZduA2YNgtGMw7utwtAMAjav8gjp42PbO9i7mWHZW8KCwO40cCZaFOz9AWjqHwvgIkgaBK4ZHOpBjdYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779046961; c=relaxed/simple;
	bh=Yh57Sgr/gWBnJB7xyy4rfcpFajiqIjeqDjCkXqeiCrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuXUQ8Ou7u4aoI+lYDoO8oI59H5aj6nDHvT+MyxrpJcEYjgtMUMCfW1FtnHC0GMIYE+mZrra8AROY1XG1kVPRPsZnd1vXG5ikFfH1HM1SVCCdS6PpkFSWP4r8tyKEYLe4sKBwVzY81eNmwbPlFdjLdobEOYh65zHSger64aBPNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X9WoYI9M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VFUuEOdb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X9WoYI9M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VFUuEOdb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X9WoYI9M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VFUuEOdb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X9WoYI9M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VFUuEOdb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B4E416ABB4;
	Sun, 17 May 2026 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779046957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/FAkZbkMfyo4qXhO7GL+SjHerU1AeF92+eVxxXhSZ4=;
	b=X9WoYI9MaZwAoENQJj0fpqcKtJA+RX5qMmvWyE0LJ6TEBYyshyPT9vHz6EgIcXtIyVU62q
	v7v0RziQ+L2yJlUQ8MixH5e0Ei5n5IsmkwTtY4cFBCMuJzO2SZNiDkxUNsKuzhj3JODz4x
	dsF8iQJZa0hEXKDN5lcoEUdiE+IloPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779046957;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/FAkZbkMfyo4qXhO7GL+SjHerU1AeF92+eVxxXhSZ4=;
	b=VFUuEOdb/lnYMUOjBmUXaRDKf8PBDmQQK8pDzrq7P6EvHW8DQ0FEO+mI798A1cmXiqOFin
	OdQFusUNW6TItHAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779046957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/FAkZbkMfyo4qXhO7GL+SjHerU1AeF92+eVxxXhSZ4=;
	b=X9WoYI9MaZwAoENQJj0fpqcKtJA+RX5qMmvWyE0LJ6TEBYyshyPT9vHz6EgIcXtIyVU62q
	v7v0RziQ+L2yJlUQ8MixH5e0Ei5n5IsmkwTtY4cFBCMuJzO2SZNiDkxUNsKuzhj3JODz4x
	dsF8iQJZa0hEXKDN5lcoEUdiE+IloPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779046957;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/FAkZbkMfyo4qXhO7GL+SjHerU1AeF92+eVxxXhSZ4=;
	b=VFUuEOdb/lnYMUOjBmUXaRDKf8PBDmQQK8pDzrq7P6EvHW8DQ0FEO+mI798A1cmXiqOFin
	OdQFusUNW6TItHAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E9D2593A8;
	Sun, 17 May 2026 19:42:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CRsZHC0aCmpPWwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Sun, 17 May 2026 19:42:37 +0000
Date: Sun, 17 May 2026 21:42:28 +0200
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH v5 16/17] cifs: keep cfids in rbtree for efficient lookups
Message-ID: <agoVi61qbemLWd0i@suse.de>
References: <20260514180823.497293-1-sprasad@microsoft.com>
 <20260514180823.497293-16-sprasad@microsoft.com>
 <agYmnHcofYrvCcHV@suse.de>
 <CANT5p=r9k5AMMOGiX2M_ZYPBDD7LnLX_vXh6tOKBnMeyqbt8NQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANT5p=r9k5AMMOGiX2M_ZYPBDD7LnLX_vXh6tOKBnMeyqbt8NQ@mail.gmail.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,manguebit.org,microsoft.com,redhat.com,suse.com];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 05/15, Shyam Prasad N wrote:
>On Fri, May 15, 2026 at 2:13=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>>
>> Hi Shyam,
>>
>
>Hi Enzo,
>Thanks for the review.
>
>> On 05/14, nspmangalore@gmail.com wrote:
>> >From: Shyam Prasad N <sprasad@microsoft.com>
>> >
>> >Today tcon->cfids are maintained as a linked list. When we do
>> >not limit the number of cfids (limited by system memory), this
>> >can be a problem if the mount has a large number of active dir
>> >accesses. We soon start hitting perf bottlenecks.
>>
>> Do you have performance results on your list vs rbtree tests?
>
>Not specifically for this. But I ran benchmarks with a file containing
>100k dentries, and compared the numbers with and without the whole
>patch set. Performance has not regressed.

Interesting, I'll try out this series when I have more time (not this
week) -- I need to dig the tests I was doing back then that got me into
those obstacles I mention.

>> I tried this exact same change a few months ago, and my experience was
>> that, under a stress test (e.g. dbench), performance was severely
>> degraded with the rbtree version because of the many rebalances
>> (e.g. too many lease breaks causing rbtree erases).
>
>Interesting. Will run dbench with the changes and check. Do you have
>the dbench configuration you used?

xfstests generic/241 should be enough, or if on a too fast/slow
machine/network, try playing around with the parameters from that test
(it uses "dbench -t 60 -D $TEST_DIR/dbench 4" hardcoded)

>> I'd be happy to hear this changed since then (with all cached dir fixes
>> that came in) -- I have several improvement ideas to apply on top of
>> the rbtree solution :)
>>
>
>Happy to hear out the ideas. :)
>Let's target the next rc1 to make significant perf gains with dir leases.
>
>>
>> A quick observation for this patch inlined below.
>>
>> >This change stores cfids in a rbtree instead of a linked list.
>> >The nodes of this tree are keyed based on the path inside the tcon.
>> >
>> >Additionally, for faster lookups by dentry, introducing a hashtable
>> >to allow lookups of cfids by dentry faster. This is important
>> >since open_cached_dir_by_dentry is called quite frequently.
>> >
>> >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>> >---
>> > fs/smb/client/cached_dir.c | 227 ++++++++++++++++++++++++++-----------
>> > fs/smb/client/cached_dir.h |   8 +-
>> > fs/smb/client/cifs_debug.c |   4 +-
>> > 3 files changed, 172 insertions(+), 67 deletions(-)
>> >
>> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>> >index 389695b203247..3cf4cfa23c377 100644
>> >--- a/fs/smb/client/cached_dir.c
>> >+++ b/fs/smb/client/cached_dir.c
>> >@@ -22,6 +22,7 @@ static void smb2_close_cached_fid(struct kref *ref);
>> > static void cfids_laundromat_worker(struct work_struct *work);
>> >
>> > #define CACHED_DIRENT_HASH_BITS       7
>> >+#define CACHED_DIR_DENTRY_HT_BITS     8
>> >
>> > struct cached_dir_dentry {
>> >       struct list_head entry;
>> >@@ -1239,6 +1240,57 @@ int cifs_wait_for_pending_dcache(struct cached_f=
id *cfid,
>> >       return ret;
>> > }
>> >
>> >+static struct cached_fid *cfid_rb_find(struct rb_root *root, const cha=
r *path)
>> >+{
>> >+      struct rb_node *node =3D root->rb_node;
>> >+
>> >+      while (node) {
>> >+              struct cached_fid *cfid =3D rb_entry(node, struct cached=
_fid, node);
>> >+              int cmp =3D strcmp(path, cfid->path);
>> >+
>> >+              if (cmp < 0)
>> >+                      node =3D node->rb_left;
>> >+              else if (cmp > 0)
>> >+                      node =3D node->rb_right;
>> >+              else
>> >+                      return cfid;
>> >+      }
>> >+      return NULL;
>> >+}
>> >+
>> >+static struct cached_fid *cfid_dentry_ht_find(struct cached_fids *cfid=
s,
>> >+                                            struct dentry *dentry)
>> >+{
>> >+      struct cached_fid *cfid;
>> >+
>> >+      hlist_for_each_entry(cfid,
>> >+                           &cfids->dentry_ht[hash_ptr(dentry, CACHED_D=
IR_DENTRY_HT_BITS)],
>> >+                           dentry_node) {
>> >+              if (cfid->dentry =3D=3D dentry)
>> >+                      return cfid;
>> >+      }
>> >+      return NULL;
>> >+}
>> >+
>> >+static void cfid_rb_insert(struct rb_root *root, struct cached_fid *ne=
w)
>> >+{
>> >+      struct rb_node **link =3D &root->rb_node;
>> >+      struct rb_node *parent =3D NULL;
>> >+
>> >+      while (*link) {
>> >+              struct cached_fid *cfid =3D rb_entry(*link, struct cache=
d_fid, node);
>> >+              int cmp =3D strcmp(new->path, cfid->path);
>> >+
>> >+              parent =3D *link;
>> >+              if (cmp < 0)
>> >+                      link =3D &(*link)->rb_left;
>> >+              else
>> >+                      link =3D &(*link)->rb_right;
>> >+      }
>> >+      rb_link_node(&new->node, parent, link);
>> >+      rb_insert_color(&new->node, root);
>> >+}
>> >+
>>
>> There's rb_find() and rb_add() already, and I really think you should
>> use them -- no duplicate code -> less cifs-maintained code, thus less
>> chance for bugs.
>> It would only require 2 (bool/int) "cfid_cmp()" helpers to do strcmp()
>> (if you structure it well enough, it might even be possible to do some
>> validation/skipping within the compare functions).
>
>I see. Let me work on this next week.
>
>>
>> > static struct cached_fid *find_or_create_cached_dir(struct cached_fids=
 *cfids,
>> >                                                   const char *path,
>> >                                                   bool lookup_only,
>> >@@ -1246,22 +1298,21 @@ static struct cached_fid *find_or_create_cached=
_dir(struct cached_fids *cfids,
>> > {
>> >       struct cached_fid *cfid;
>> >
>> >-      list_for_each_entry(cfid, &cfids->entries, entry) {
>> >-              if (!strcmp(cfid->path, path)) {
>> >-                      /*
>> >-                       * If it doesn't have a lease it is either not y=
et
>> >-                       * fully cached or it may be in the process of
>> >-                       * being deleted due to a lease break.
>> >-                       */
>> >-                      spin_lock(&cfid->cfid_lock);
>> >-                      if (!is_valid_cached_dir(cfid)) {
>> >-                              spin_unlock(&cfid->cfid_lock);
>> >-                              return NULL;
>> >-                      }
>> >-                      kref_get(&cfid->refcount);
>> >+      cfid =3D cfid_rb_find(&cfids->entries, path);
>> >+      if (cfid) {
>> >+              /*
>> >+               * If it doesn't have a lease it is either not yet
>> >+               * fully cached or it may be in the process of
>> >+               * being deleted due to a lease break.
>> >+               */
>> >+              spin_lock(&cfid->cfid_lock);
>> >+              if (!is_valid_cached_dir(cfid)) {
>> >                       spin_unlock(&cfid->cfid_lock);
>> >-                      return cfid;
>> >+                      return NULL;
>> >               }
>> >+              kref_get(&cfid->refcount);
>> >+              spin_unlock(&cfid->cfid_lock);
>> >+              return cfid;
>> >       }
>> >       if (lookup_only) {
>> >               return NULL;
>> >@@ -1276,7 +1327,7 @@ static struct cached_fid *find_or_create_cached_d=
ir(struct cached_fids *cfids,
>> >       }
>> >       cfid->cfids =3D cfids;
>> >       cfids->num_entries++;
>> >-      list_add(&cfid->entry, &cfids->entries);
>> >+      cfid_rb_insert(&cfids->entries, cfid);
>> >       cfid->on_list =3D true;
>> >       kref_get(&cfid->refcount);
>> >       /*
>> >@@ -1458,26 +1509,30 @@ int open_cached_dir(unsigned int xid, struct ci=
fs_tcon *tcon,
>> >                       struct cached_fid *parent_cfid;
>> >
>> >                       spin_lock(&cfids->cfid_list_lock);
>> >-                      list_for_each_entry(parent_cfid, &cfids->entries=
, entry) {
>> >+                      hlist_for_each_entry(parent_cfid,
>> >+                                           &cfids->dentry_ht[hash_ptr(=
dentry->d_parent,
>> >+                                                              CACHED_D=
IR_DENTRY_HT_BITS)],
>> >+                                           dentry_node) {
>> >+                              if (parent_cfid->dentry !=3D dentry->d_p=
arent)
>> >+                                      continue;
>> >                               spin_lock(&parent_cfid->cfid_lock);
>> >-                              if (parent_cfid->dentry =3D=3D dentry->d=
_parent) {
>> >-                                      cifs_dbg(FYI, "found a parent ca=
ched file handle\n");
>> >-                                      if (is_valid_cached_dir(parent_c=
fid)) {
>> >-                                              lease_flags
>> >-                                                      |=3D SMB2_LEASE_=
FLAG_PARENT_LEASE_KEY_SET_LE;
>> >-                                              memcpy(pfid->parent_leas=
e_key,
>> >-                                                     parent_cfid->fid.=
lease_key,
>> >-                                                     SMB2_LEASE_KEY_SI=
ZE);
>> >-                                      }
>> >-                                      spin_unlock(&parent_cfid->cfid_l=
ock);
>> >-                                      break;
>> >+                              cifs_dbg(FYI, "found a parent cached fil=
e handle\n");
>> >+                              if (is_valid_cached_dir(parent_cfid)) {
>> >+                                      lease_flags
>> >+                                              |=3D SMB2_LEASE_FLAG_PAR=
ENT_LEASE_KEY_SET_LE;
>> >+                                      memcpy(pfid->parent_lease_key,
>> >+                                             parent_cfid->fid.lease_ke=
y,
>> >+                                             SMB2_LEASE_KEY_SIZE);
>> >                               }
>> >                               spin_unlock(&parent_cfid->cfid_lock);
>> >+                              break;
>> >                       }
>> >                       spin_unlock(&cfids->cfid_list_lock);
>> >               }
>> >       }
>> >       cfid->dentry =3D dentry;
>> >+      hlist_add_head(&cfid->dentry_node,
>> >+                     &cfids->dentry_ht[hash_ptr(dentry, CACHED_DIR_DEN=
TRY_HT_BITS)]);
>> >       cfid->tcon =3D tcon;
>> >
>> >       /*
>> >@@ -1630,7 +1685,9 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
>> >
>> >               spin_lock(&cfids->cfid_list_lock);
>> >               if (cfid->on_list) {
>> >-                      list_del(&cfid->entry);
>> >+                      if (cfid->dentry)
>> >+                              hlist_del_init(&cfid->dentry_node);
>> >+                      rb_erase(&cfid->node, &cfids->entries);
>> >                       cfid->on_list =3D false;
>> >                       cfids->num_entries--;
>> >               }
>> >@@ -1674,26 +1731,28 @@ int open_cached_dir_by_dentry(struct cifs_tcon =
*tcon,
>> >               return -ENOENT;
>> >
>> >       spin_lock(&cfids->cfid_list_lock);
>> >-      list_for_each_entry(cfid, &cfids->entries, entry) {
>> >-              if (cfid->dentry =3D=3D dentry) {
>> >-                      spin_lock(&cfid->cfid_lock);
>> >-                      if (!is_valid_cached_dir(cfid)) {
>> >-                              spin_unlock(&cfid->cfid_lock);
>> >-                              rc =3D -ENOENT;
>> >-                              break;
>> >-                      }
>> >-                      cifs_dbg(FYI, "found a cached file handle by den=
try\n");
>> >-                      kref_get(&cfid->refcount);
>> >-                      *ret_cfid =3D cfid;
>> >-                      cfid->last_access_time =3D jiffies;
>> >-                      rc =3D 0;
>> >-                      trace_cfid =3D cfid;
>> >+      cfid =3D cfid_dentry_ht_find(cfids, dentry);
>> >+      if (cfid) {
>> >+              spin_lock(&cfid->cfid_lock);
>> >+              if (!is_valid_cached_dir(cfid)) {
>> >                       spin_unlock(&cfid->cfid_lock);
>> >                       spin_unlock(&cfids->cfid_list_lock);
>> >-                      trace_smb3_open_cached_dir_by_dentry(cfid, dentr=
y->d_name.name,
>> >-                                                       dentry->d_name.=
len, 0);
>> >+                      trace_smb3_open_cached_dir_by_dentry(cfid,
>> >+                                         dentry->d_name.name,
>> >+                                         dentry->d_name.len, rc);
>> >                       return rc;
>> >               }
>> >+              cifs_dbg(FYI, "found a cached file handle by dentry\n");
>> >+              kref_get(&cfid->refcount);
>> >+              *ret_cfid =3D cfid;
>> >+              cfid->last_access_time =3D jiffies;
>> >+              rc =3D 0;
>> >+              spin_unlock(&cfid->cfid_lock);
>> >+              spin_unlock(&cfids->cfid_list_lock);
>> >+              trace_smb3_open_cached_dir_by_dentry(cfid,
>> >+                                 dentry->d_name.name,
>> >+                                 dentry->d_name.len, rc);
>> >+              return rc;
>> >       }
>> >       spin_unlock(&cfids->cfid_list_lock);
>> >       trace_smb3_open_cached_dir_by_dentry(NULL, dentry->d_name.name,
>> >@@ -1715,7 +1774,9 @@ __releases(&cfid->cfids->cfid_list_lock)
>> >       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
>> >
>> >       if (cfid->on_list) {
>> >-              list_del(&cfid->entry);
>> >+              if (cfid->dentry)
>> >+                      hlist_del_init(&cfid->dentry_node);
>> >+              rb_erase(&cfid->node, &cfid->cfids->entries);
>> >               cfid->on_list =3D false;
>> >               cfid->cfids->num_entries--;
>> >       }
>> >@@ -1790,6 +1851,7 @@ void close_all_cached_dirs(struct cifs_sb_info *c=
ifs_sb)
>> > {
>> >       struct rb_root *root =3D &cifs_sb->tlink_tree;
>> >       struct rb_node *node;
>> >+      struct rb_node *cfid_node;
>> >       struct cached_fid *cfid;
>> >       struct cifs_tcon *tcon;
>> >       struct tcon_link *tlink;
>> >@@ -1807,7 +1869,9 @@ void close_all_cached_dirs(struct cifs_sb_info *c=
ifs_sb)
>> >               if (cfids =3D=3D NULL)
>> >                       continue;
>> >               spin_lock(&cfids->cfid_list_lock);
>> >-              list_for_each_entry(cfid, &cfids->entries, entry) {
>> >+              for (cfid_node =3D rb_first(&cfids->entries);
>> >+                   cfid_node; cfid_node =3D rb_next(cfid_node)) {
>> >+                      cfid =3D rb_entry(cfid_node, struct cached_fid, =
node);
>> >                       tmp_list =3D kmalloc_obj(*tmp_list, GFP_ATOMIC);
>> >                       if (tmp_list =3D=3D NULL) {
>> >                               /*
>> >@@ -1823,6 +1887,7 @@ void close_all_cached_dirs(struct cifs_sb_info *c=
ifs_sb)
>> >
>> >                       spin_lock(&cfid->cfid_lock);
>> >                       tmp_list->dentry =3D cfid->dentry;
>> >+                      hlist_del_init(&cfid->dentry_node);
>> >                       cfid->dentry =3D NULL;
>> >                       spin_unlock(&cfid->cfid_lock);
>> >
>> >@@ -1850,7 +1915,8 @@ void close_all_cached_dirs(struct cifs_sb_info *c=
ifs_sb)
>> > void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
>> > {
>> >       struct cached_fids *cfids =3D tcon->cfids;
>> >-      struct cached_fid *cfid, *q;
>> >+      struct cached_fid *cfid;
>> >+      struct rb_node *rb_node =3D NULL, *next_node =3D NULL;
>> >
>> >       if (cfids =3D=3D NULL)
>> >               return;
>> >@@ -1861,8 +1927,14 @@ void invalidate_all_cached_dirs(struct cifs_tcon=
 *tcon, bool sync)
>> >        * during this process.
>> >        */
>> >       spin_lock(&cfids->cfid_list_lock);
>> >-      list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
>> >-              list_move(&cfid->entry, &cfids->dying);
>> >+      for (rb_node =3D rb_first(&cfids->entries);
>> >+           rb_node; rb_node =3D next_node) {
>> >+              next_node =3D rb_next(rb_node);
>> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
>> >+              if (cfid->dentry)
>> >+                      hlist_del_init(&cfid->dentry_node);
>> >+              rb_erase(rb_node, &cfids->entries);
>> >+              list_add(&cfid->dying_entry, &cfids->dying);
>> >               cfids->num_entries--;
>> >               spin_lock(&cfid->cfid_lock);
>> >               cfid->is_open =3D false;
>> >@@ -1926,7 +1998,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tco=
n, __u8 lease_key[16])
>> >               return false;
>> >
>> >       spin_lock(&cfids->cfid_list_lock);
>> >-      list_for_each_entry(cfid, &cfids->entries, entry) {
>> >+      for (struct rb_node *rb_node =3D rb_first(&cfids->entries);
>> >+           rb_node; rb_node =3D rb_next(rb_node)) {
>> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
>> >               spin_lock(&cfid->cfid_lock);
>> >               if (cfid->has_lease &&
>> >                   !memcmp(lease_key,
>> >@@ -1939,7 +2013,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tco=
n, __u8 lease_key[16])
>> >                        * We found a lease remove it from the list
>> >                        * so no threads can access it.
>> >                        */
>> >-                      list_del(&cfid->entry);
>> >+                      if (cfid->dentry)
>> >+                              hlist_del_init(&cfid->dentry_node);
>> >+                      rb_erase(rb_node, &cfids->entries);
>> >                       cfid->on_list =3D false;
>> >                       cfids->num_entries--;
>> >
>> >@@ -1971,7 +2047,9 @@ static struct cached_fid *init_cached_dir(const c=
har *path)
>> >
>> >       INIT_WORK(&cfid->close_work, cached_dir_offload_close);
>> >       INIT_WORK(&cfid->put_work, cached_dir_put_work);
>> >-      INIT_LIST_HEAD(&cfid->entry);
>> >+      RB_CLEAR_NODE(&cfid->node);
>> >+      INIT_HLIST_NODE(&cfid->dentry_node);
>> >+      INIT_LIST_HEAD(&cfid->dying_entry);
>> >       INIT_LIST_HEAD(&cfid->dirents.entry_list);
>> >       mutex_init(&cfid->dirents.de_mutex);
>> >       mutex_init(&cfid->cfid_open_mutex);
>> >@@ -2026,14 +2104,20 @@ static void cfids_laundromat_worker(struct work=
_struct *work)
>> >
>> >       spin_lock(&cfids->cfid_list_lock);
>> >       /* move cfids->dying to the local list */
>> >-      list_cut_before(&entry, &cfids->dying, &cfids->dying);
>> >+      list_splice_init(&cfids->dying, &entry);
>> >
>> >-      list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
>> >+      for (struct rb_node *rb_node =3D rb_first(&cfids->entries), *nex=
t_node;
>> >+           rb_node; rb_node =3D next_node) {
>> >+              next_node =3D rb_next(rb_node);
>> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
>> >               spin_lock(&cfid->cfid_lock);
>> >               if (dir_cache_timeout && cfid->last_access_time &&
>> >                   time_after(jiffies, cfid->last_access_time + HZ * di=
r_cache_timeout)) {
>> >                       cfid->on_list =3D false;
>> >-                      list_move(&cfid->entry, &entry);
>> >+                      if (cfid->dentry)
>> >+                              hlist_del_init(&cfid->dentry_node);
>> >+                      rb_erase(rb_node, &cfids->entries);
>> >+                      list_add(&cfid->dying_entry, &entry);
>> >                       cfids->num_entries--;
>> >                       if (cfid->has_lease) {
>> >                               /*
>> >@@ -2052,8 +2136,8 @@ static void cfids_laundromat_worker(struct work_s=
truct *work)
>> >       }
>> >       spin_unlock(&cfids->cfid_list_lock);
>> >
>> >-      list_for_each_entry_safe(cfid, q, &entry, entry) {
>> >-              list_del(&cfid->entry);
>> >+      list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
>> >+              list_del(&cfid->dying_entry);
>> >
>> >               dput(cfid->dentry);
>> >               cfid->dentry =3D NULL;
>> >@@ -2085,7 +2169,13 @@ struct cached_fids *init_cached_dirs(void)
>> >       if (!cfids)
>> >               return NULL;
>> >       spin_lock_init(&cfids->cfid_list_lock);
>> >-      INIT_LIST_HEAD(&cfids->entries);
>> >+      cfids->entries =3D RB_ROOT;
>> >+      cfids->dentry_ht =3D kcalloc(1 << CACHED_DIR_DENTRY_HT_BITS,
>> >+                                 sizeof(*cfids->dentry_ht), GFP_KERNEL=
);
>> >+      if (!cfids->dentry_ht) {
>> >+              kfree(cfids);
>> >+              return NULL;
>> >+      }
>> >       INIT_LIST_HEAD(&cfids->dying);
>> >
>> >       INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_work=
er);
>> >@@ -2113,25 +2203,34 @@ void free_cached_dirs(struct cached_fids *cfids)
>> >
>> >       cancel_delayed_work_sync(&cfids->laundromat_work);
>> >
>> >+      kfree(cfids->dentry_ht);
>> >+      cfids->dentry_ht =3D NULL;
>> >+
>> >       spin_lock(&cfids->cfid_list_lock);
>> >-      list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
>> >+      for (struct rb_node *rb_node =3D rb_first(&cfids->entries), *nex=
t_node;
>> >+           rb_node; rb_node =3D next_node) {
>> >+              next_node =3D rb_next(rb_node);
>> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
>> >               cfid->on_list =3D false;
>> >+              if (cfid->dentry)
>> >+                      hlist_del_init(&cfid->dentry_node);
>> >               spin_lock(&cfid->cfid_lock);
>> >               cfid->is_open =3D false;
>> >               spin_unlock(&cfid->cfid_lock);
>> >-              list_move(&cfid->entry, &entry);
>> >+              rb_erase(rb_node, &cfids->entries);
>> >+              list_add(&cfid->dying_entry, &entry);
>> >       }
>> >-      list_for_each_entry_safe(cfid, q, &cfids->dying, entry) {
>> >+      list_for_each_entry_safe(cfid, q, &cfids->dying, dying_entry) {
>> >               cfid->on_list =3D false;
>> >               spin_lock(&cfid->cfid_lock);
>> >               cfid->is_open =3D false;
>> >               spin_unlock(&cfid->cfid_lock);
>> >-              list_move(&cfid->entry, &entry);
>> >+              list_move(&cfid->dying_entry, &entry);
>> >       }
>> >       spin_unlock(&cfids->cfid_list_lock);
>> >
>> >-      list_for_each_entry_safe(cfid, q, &entry, entry) {
>> >-              list_del(&cfid->entry);
>> >+      list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
>> >+              list_del(&cfid->dying_entry);
>> >               free_cached_dir(cfid);
>> >       }
>> >
>> >diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
>> >index 9226463000499..4091fa7867618 100644
>> >--- a/fs/smb/client/cached_dir.h
>> >+++ b/fs/smb/client/cached_dir.h
>> >@@ -11,6 +11,7 @@
>> > #include <linux/completion.h>
>> > #include <linux/build_bug.h>
>> > #include <linux/list.h>
>> >+#include <linux/rbtree.h>
>> > #include <linux/netfs.h>
>> >
>> > struct cifs_search_info;
>> >@@ -139,7 +140,9 @@ struct cached_dirents {
>> > };
>> >
>> > struct cached_fid {
>> >-      struct list_head entry;
>> >+      struct rb_node node;
>> >+      struct hlist_node dentry_node;
>> >+      struct list_head dying_entry;
>> >       struct cached_fids *cfids;
>> >       const char *path;
>> >       bool has_lease;
>> >@@ -182,7 +185,8 @@ struct cached_fids {
>> >        */
>> >       spinlock_t cfid_list_lock;
>> >       int num_entries;
>> >-      struct list_head entries;
>> >+      struct rb_root entries;
>> >+      struct hlist_head *dentry_ht;
>> >       struct list_head dying;
>> >       struct delayed_work laundromat_work;
>> >       /* aggregate accounting for all cached dirents under this tcon */
>> >diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
>> >index 131af7333fc58..9240ee6391dd1 100644
>> >--- a/fs/smb/client/cifs_debug.c
>> >+++ b/fs/smb/client/cifs_debug.c
>> >@@ -328,7 +328,9 @@ static int cifs_debug_dirs_proc_show(struct seq_fil=
e *m, void *v)
>> >                                               cfids->num_entries,
>> >                                               (unsigned long)atomic_lo=
ng_read(&cfids->total_dirents_entries),
>> >                                               (unsigned long long)atom=
ic64_read(&cfids->total_dirents_bytes));
>> >-                              list_for_each_entry(cfid, &cfids->entrie=
s, entry) {
>> >+                              for (struct rb_node *rb_node =3D rb_firs=
t(&cfids->entries);
>> >+                                   rb_node; rb_node =3D rb_next(rb_nod=
e)) {
>> >+                                      cfid =3D rb_entry(rb_node, struc=
t cached_fid, node);
>> >                                       spin_lock(&cfid->cfid_lock);
>> >                                       seq_printf(m, "0x%x 0x%llx 0x%ll=
x ",
>> >                                               tcon->tid,
>> >--
>> >2.43.0
>> >
>> >
>
>
>
>--=20
>Regards,
>Shyam
>
