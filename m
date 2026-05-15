Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB9A46AEC5
	for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778842181; cv=pass; b=bQZRV5zilmQ2frMGUA7QUDa6h5q+08aQuu+uAvTkLXL8vSz0MoirfOJ1+uCQt8fOjlJI+ZoUYZnX7nkypsdsVL7FT8YLs4ixr+F8H5nwZRb2WbWTcKvPP7A2fe9TPFik/iFpeb9xgrJUdmmqMMD6m11wE8/u3gquS7W0woqjQ0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778842181; c=relaxed/simple;
	bh=d+Yw6Cc+JzlcLlY3zj5cEXmS5jR7vnNqCqybieF7hIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FmMImlt17D4FmrPNsBBpbBrsVMGGhoJ14N7KhW3LGU/NL4m43j69cKqrGEXYpJLfrKKr8w3JcK+Tq2TkEBmOjJxd+MHcw+Wxmu0y8AWR+pwsLnHzswxZrezmJ2aeiwHWgQGxXHByoCbH9tD4tL3jNmbWwyou73zeQEdezEPWuHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRk83xVr; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRk83xVr"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bce386d5b85so1035890166b.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 03:49:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778842177; cv=none;
        d=google.com; s=arc-20240605;
        b=lJ3An95V/HJOlsDU4NUk170Z7Azd0u03h9fFwpBAW5H/lmEotuAzziA0JbAEYAWTf1
         ItHR7EkuctVSSUlBqVD0PBUq0uq6ZWRweNbQPYCpSbMueoT6ZXPP73f06cIKVcURIMLd
         WlmJlgaNKOXxSqzpgZHhtDtR+MgYgM2xPtxW5wOsCcAyMnLt/8E9DpzUDuwywQKz984H
         7FpjiBnqVkE8cA7wZZFHKwr99ULCnL/TengsZ3K6Viz7zskVUqQSIJP/Jb5DxPByKHE+
         AYUEBDxvsgy3S8lSrI65bcIkcVEVhdaUt1cZz/ZRSP+7oXC6KjFeQZdL58UI4jojUb7h
         +gcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0yZcm3RfsQ3P8RKM6QcaGfH4Dx+ZmepZA1ACEuySlL4=;
        fh=nPg8hoTTN7UPOx/8/kKtrBcvPSl0lCQThCI/quIVrz4=;
        b=cpWn46z46odgD8B9vOU6/aj+sjTZmzk7HO1WOk7yvh8QA62eWYcjDlq0kUTpJheFuR
         PQ7WaM02LX7uyoUUfouZFSve90A8ierbMM7s7KL0vCyTx95SsmEq9SEF8j4Jj5jil2xy
         Mr2MTjvjXq6G9pTM0tIVdqHGMqrGhfLLQQ9eUqHk+hdd3TvP/OtZscouCo31Zk9w6Kd7
         xyA20wsQfNivbQiZOE1D9zg+cqkS0kNaZ1wIEJ6ylV2zfmxE5dQVcb1mWFfsfjgvHapq
         Zn1E/11eH9rTUZaa/n46V+3b03fe+crDIDP/3O5H2piZMZTxJqqiOpMxj2Qy8pLoR8SM
         UbIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778842177; x=1779446977; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yZcm3RfsQ3P8RKM6QcaGfH4Dx+ZmepZA1ACEuySlL4=;
        b=NRk83xVrnSqXz6JN3U2WC/rnodKSIxqRBl+iNznbfe/RS1FfHhSOGBrNQtnlbqa6Kq
         OpdYfyazGLVzLWK+edcQEvo3bLrN2aC0Sr1ERIE5ILp+bIvcWlKz1qdfxOKg28DGx2ho
         iG8UHJTXUmfD+jdGMorrmj2Kom2AX58lg3FNeQIY9DTjxHX3jIvIeznfo/BMi6jYsmDe
         w+glwaNg3Bp7j9wMn0GXJA9Q1g1C1LbQMaB3CmGebcbT/g4pJJmAVrzKf5UEEwdjrUs0
         tmSD53by6fd2D7iEAwcB6rDrQd1SX0aFeVHvWf4rtM+izFEx88AAk6agxLqU4WhcEsmF
         bHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778842177; x=1779446977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0yZcm3RfsQ3P8RKM6QcaGfH4Dx+ZmepZA1ACEuySlL4=;
        b=hVpYlysdIsU9dD/5zUSNvoq+9x5gp/bKEWE3HkLNBhlbSVjzTTLdV9cww/UkeIWwhe
         y7BWQQcVxKLiQL7DB2L4G5qysQywGhvtz+rH4re/0Rd43drifxl6yvzY2mZN3MaJ1Gr5
         IY4P9e3NQlr+Ez2dF+0ihwtxL2ukFiiwH8aeMzZvbfKmtRy6OdqCt8dJl4ITLn5JcDu7
         WO69rNqd9EDcIZeILeCUTohGJQ1pLagdFGbfLVNUNKlL9PK2gvw9wcZOteILgDOxTsys
         QOwZVLtjwFAjZ3N5zcnbBNL4jy5JImEOiOluMw2ky1Sa3xg6xVbtW1kibT1hOem3DHzI
         oLMg==
X-Gm-Message-State: AOJu0YypR169CJXq9nxkqPxJhkw8ZPylrxixcvmyqZYGD1Vo/NvFZ1gi
	ioKyX5TPfSdrT4AHkkEJwSF0O6S+H63nMkChlkZ1NZwnHzB/+FwRpfSKrIPcIOo7cL/AAimqcN6
	AQC2O9J+b8gsMFPpCIxgR1DkGVDmWeUU=
X-Gm-Gg: Acq92OG+CVxmwtQAAw6pqAcHzKdJXb1SWhpMaaG2Ci3HGV9y0IUg0mBBQYul6R2RZW2
	RKGx8HfNZomKqYK0AOHMEn4C5KdRJ2dN3Q/eNIsfX2a5Dd0+EtW0J9W14UJukc5I+9dKIkehVCo
	7UAc77sy2n5hRYTHFeH+3j8uVX8wmhtwmyfjlk/+kVlYaPlSyD9AEfW/sNCdFGJamCwQPHI63Ga
	fmvwFjPeVZ5HoFcwUZGf/m6NPC5ueeoqndXuhPRGfQ1sEdesk7lvEFYLJjlimW2CmQOdHuuOcE7
	BglRx5boe+0Xxa0Q
X-Received: by 2002:a17:907:c291:b0:bd4:e590:4238 with SMTP id
 a640c23a62f3a-bd517812d92mr189220666b.17.1778842176722; Fri, 15 May 2026
 03:49:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514180823.497293-1-sprasad@microsoft.com>
 <20260514180823.497293-16-sprasad@microsoft.com> <agYmnHcofYrvCcHV@suse.de>
In-Reply-To: <agYmnHcofYrvCcHV@suse.de>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 15 May 2026 16:19:25 +0530
X-Gm-Features: AVHnY4JFl-v1k7gTh5qehryL4acuoVV83R_LRXq7DxzM_MTqgwLacWympDKn5a0
Message-ID: <CANT5p=r9k5AMMOGiX2M_ZYPBDD7LnLX_vXh6tOKBnMeyqbt8NQ@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] cifs: keep cfids in rbtree for efficient lookups
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 2:13=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Hi Shyam,
>

Hi Enzo,
Thanks for the review.

> On 05/14, nspmangalore@gmail.com wrote:
> >From: Shyam Prasad N <sprasad@microsoft.com>
> >
> >Today tcon->cfids are maintained as a linked list. When we do
> >not limit the number of cfids (limited by system memory), this
> >can be a problem if the mount has a large number of active dir
> >accesses. We soon start hitting perf bottlenecks.
>
> Do you have performance results on your list vs rbtree tests?

Not specifically for this. But I ran benchmarks with a file containing
100k dentries, and compared the numbers with and without the whole
patch set. Performance has not regressed.

>
> I tried this exact same change a few months ago, and my experience was
> that, under a stress test (e.g. dbench), performance was severely
> degraded with the rbtree version because of the many rebalances
> (e.g. too many lease breaks causing rbtree erases).

Interesting. Will run dbench with the changes and check. Do you have
the dbench configuration you used?

>
> I'd be happy to hear this changed since then (with all cached dir fixes
> that came in) -- I have several improvement ideas to apply on top of
> the rbtree solution :)
>

Happy to hear out the ideas. :)
Let's target the next rc1 to make significant perf gains with dir leases.

>
> A quick observation for this patch inlined below.
>
> >This change stores cfids in a rbtree instead of a linked list.
> >The nodes of this tree are keyed based on the path inside the tcon.
> >
> >Additionally, for faster lookups by dentry, introducing a hashtable
> >to allow lookups of cfids by dentry faster. This is important
> >since open_cached_dir_by_dentry is called quite frequently.
> >
> >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >---
> > fs/smb/client/cached_dir.c | 227 ++++++++++++++++++++++++++-----------
> > fs/smb/client/cached_dir.h |   8 +-
> > fs/smb/client/cifs_debug.c |   4 +-
> > 3 files changed, 172 insertions(+), 67 deletions(-)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index 389695b203247..3cf4cfa23c377 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -22,6 +22,7 @@ static void smb2_close_cached_fid(struct kref *ref);
> > static void cfids_laundromat_worker(struct work_struct *work);
> >
> > #define CACHED_DIRENT_HASH_BITS       7
> >+#define CACHED_DIR_DENTRY_HT_BITS     8
> >
> > struct cached_dir_dentry {
> >       struct list_head entry;
> >@@ -1239,6 +1240,57 @@ int cifs_wait_for_pending_dcache(struct cached_fi=
d *cfid,
> >       return ret;
> > }
> >
> >+static struct cached_fid *cfid_rb_find(struct rb_root *root, const char=
 *path)
> >+{
> >+      struct rb_node *node =3D root->rb_node;
> >+
> >+      while (node) {
> >+              struct cached_fid *cfid =3D rb_entry(node, struct cached_=
fid, node);
> >+              int cmp =3D strcmp(path, cfid->path);
> >+
> >+              if (cmp < 0)
> >+                      node =3D node->rb_left;
> >+              else if (cmp > 0)
> >+                      node =3D node->rb_right;
> >+              else
> >+                      return cfid;
> >+      }
> >+      return NULL;
> >+}
> >+
> >+static struct cached_fid *cfid_dentry_ht_find(struct cached_fids *cfids=
,
> >+                                            struct dentry *dentry)
> >+{
> >+      struct cached_fid *cfid;
> >+
> >+      hlist_for_each_entry(cfid,
> >+                           &cfids->dentry_ht[hash_ptr(dentry, CACHED_DI=
R_DENTRY_HT_BITS)],
> >+                           dentry_node) {
> >+              if (cfid->dentry =3D=3D dentry)
> >+                      return cfid;
> >+      }
> >+      return NULL;
> >+}
> >+
> >+static void cfid_rb_insert(struct rb_root *root, struct cached_fid *new=
)
> >+{
> >+      struct rb_node **link =3D &root->rb_node;
> >+      struct rb_node *parent =3D NULL;
> >+
> >+      while (*link) {
> >+              struct cached_fid *cfid =3D rb_entry(*link, struct cached=
_fid, node);
> >+              int cmp =3D strcmp(new->path, cfid->path);
> >+
> >+              parent =3D *link;
> >+              if (cmp < 0)
> >+                      link =3D &(*link)->rb_left;
> >+              else
> >+                      link =3D &(*link)->rb_right;
> >+      }
> >+      rb_link_node(&new->node, parent, link);
> >+      rb_insert_color(&new->node, root);
> >+}
> >+
>
> There's rb_find() and rb_add() already, and I really think you should
> use them -- no duplicate code -> less cifs-maintained code, thus less
> chance for bugs.
> It would only require 2 (bool/int) "cfid_cmp()" helpers to do strcmp()
> (if you structure it well enough, it might even be possible to do some
> validation/skipping within the compare functions).

I see. Let me work on this next week.

>
> > static struct cached_fid *find_or_create_cached_dir(struct cached_fids =
*cfids,
> >                                                   const char *path,
> >                                                   bool lookup_only,
> >@@ -1246,22 +1298,21 @@ static struct cached_fid *find_or_create_cached_=
dir(struct cached_fids *cfids,
> > {
> >       struct cached_fid *cfid;
> >
> >-      list_for_each_entry(cfid, &cfids->entries, entry) {
> >-              if (!strcmp(cfid->path, path)) {
> >-                      /*
> >-                       * If it doesn't have a lease it is either not ye=
t
> >-                       * fully cached or it may be in the process of
> >-                       * being deleted due to a lease break.
> >-                       */
> >-                      spin_lock(&cfid->cfid_lock);
> >-                      if (!is_valid_cached_dir(cfid)) {
> >-                              spin_unlock(&cfid->cfid_lock);
> >-                              return NULL;
> >-                      }
> >-                      kref_get(&cfid->refcount);
> >+      cfid =3D cfid_rb_find(&cfids->entries, path);
> >+      if (cfid) {
> >+              /*
> >+               * If it doesn't have a lease it is either not yet
> >+               * fully cached or it may be in the process of
> >+               * being deleted due to a lease break.
> >+               */
> >+              spin_lock(&cfid->cfid_lock);
> >+              if (!is_valid_cached_dir(cfid)) {
> >                       spin_unlock(&cfid->cfid_lock);
> >-                      return cfid;
> >+                      return NULL;
> >               }
> >+              kref_get(&cfid->refcount);
> >+              spin_unlock(&cfid->cfid_lock);
> >+              return cfid;
> >       }
> >       if (lookup_only) {
> >               return NULL;
> >@@ -1276,7 +1327,7 @@ static struct cached_fid *find_or_create_cached_di=
r(struct cached_fids *cfids,
> >       }
> >       cfid->cfids =3D cfids;
> >       cfids->num_entries++;
> >-      list_add(&cfid->entry, &cfids->entries);
> >+      cfid_rb_insert(&cfids->entries, cfid);
> >       cfid->on_list =3D true;
> >       kref_get(&cfid->refcount);
> >       /*
> >@@ -1458,26 +1509,30 @@ int open_cached_dir(unsigned int xid, struct cif=
s_tcon *tcon,
> >                       struct cached_fid *parent_cfid;
> >
> >                       spin_lock(&cfids->cfid_list_lock);
> >-                      list_for_each_entry(parent_cfid, &cfids->entries,=
 entry) {
> >+                      hlist_for_each_entry(parent_cfid,
> >+                                           &cfids->dentry_ht[hash_ptr(d=
entry->d_parent,
> >+                                                              CACHED_DI=
R_DENTRY_HT_BITS)],
> >+                                           dentry_node) {
> >+                              if (parent_cfid->dentry !=3D dentry->d_pa=
rent)
> >+                                      continue;
> >                               spin_lock(&parent_cfid->cfid_lock);
> >-                              if (parent_cfid->dentry =3D=3D dentry->d_=
parent) {
> >-                                      cifs_dbg(FYI, "found a parent cac=
hed file handle\n");
> >-                                      if (is_valid_cached_dir(parent_cf=
id)) {
> >-                                              lease_flags
> >-                                                      |=3D SMB2_LEASE_F=
LAG_PARENT_LEASE_KEY_SET_LE;
> >-                                              memcpy(pfid->parent_lease=
_key,
> >-                                                     parent_cfid->fid.l=
ease_key,
> >-                                                     SMB2_LEASE_KEY_SIZ=
E);
> >-                                      }
> >-                                      spin_unlock(&parent_cfid->cfid_lo=
ck);
> >-                                      break;
> >+                              cifs_dbg(FYI, "found a parent cached file=
 handle\n");
> >+                              if (is_valid_cached_dir(parent_cfid)) {
> >+                                      lease_flags
> >+                                              |=3D SMB2_LEASE_FLAG_PARE=
NT_LEASE_KEY_SET_LE;
> >+                                      memcpy(pfid->parent_lease_key,
> >+                                             parent_cfid->fid.lease_key=
,
> >+                                             SMB2_LEASE_KEY_SIZE);
> >                               }
> >                               spin_unlock(&parent_cfid->cfid_lock);
> >+                              break;
> >                       }
> >                       spin_unlock(&cfids->cfid_list_lock);
> >               }
> >       }
> >       cfid->dentry =3D dentry;
> >+      hlist_add_head(&cfid->dentry_node,
> >+                     &cfids->dentry_ht[hash_ptr(dentry, CACHED_DIR_DENT=
RY_HT_BITS)]);
> >       cfid->tcon =3D tcon;
> >
> >       /*
> >@@ -1630,7 +1685,9 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >
> >               spin_lock(&cfids->cfid_list_lock);
> >               if (cfid->on_list) {
> >-                      list_del(&cfid->entry);
> >+                      if (cfid->dentry)
> >+                              hlist_del_init(&cfid->dentry_node);
> >+                      rb_erase(&cfid->node, &cfids->entries);
> >                       cfid->on_list =3D false;
> >                       cfids->num_entries--;
> >               }
> >@@ -1674,26 +1731,28 @@ int open_cached_dir_by_dentry(struct cifs_tcon *=
tcon,
> >               return -ENOENT;
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >-      list_for_each_entry(cfid, &cfids->entries, entry) {
> >-              if (cfid->dentry =3D=3D dentry) {
> >-                      spin_lock(&cfid->cfid_lock);
> >-                      if (!is_valid_cached_dir(cfid)) {
> >-                              spin_unlock(&cfid->cfid_lock);
> >-                              rc =3D -ENOENT;
> >-                              break;
> >-                      }
> >-                      cifs_dbg(FYI, "found a cached file handle by dent=
ry\n");
> >-                      kref_get(&cfid->refcount);
> >-                      *ret_cfid =3D cfid;
> >-                      cfid->last_access_time =3D jiffies;
> >-                      rc =3D 0;
> >-                      trace_cfid =3D cfid;
> >+      cfid =3D cfid_dentry_ht_find(cfids, dentry);
> >+      if (cfid) {
> >+              spin_lock(&cfid->cfid_lock);
> >+              if (!is_valid_cached_dir(cfid)) {
> >                       spin_unlock(&cfid->cfid_lock);
> >                       spin_unlock(&cfids->cfid_list_lock);
> >-                      trace_smb3_open_cached_dir_by_dentry(cfid, dentry=
->d_name.name,
> >-                                                       dentry->d_name.l=
en, 0);
> >+                      trace_smb3_open_cached_dir_by_dentry(cfid,
> >+                                         dentry->d_name.name,
> >+                                         dentry->d_name.len, rc);
> >                       return rc;
> >               }
> >+              cifs_dbg(FYI, "found a cached file handle by dentry\n");
> >+              kref_get(&cfid->refcount);
> >+              *ret_cfid =3D cfid;
> >+              cfid->last_access_time =3D jiffies;
> >+              rc =3D 0;
> >+              spin_unlock(&cfid->cfid_lock);
> >+              spin_unlock(&cfids->cfid_list_lock);
> >+              trace_smb3_open_cached_dir_by_dentry(cfid,
> >+                                 dentry->d_name.name,
> >+                                 dentry->d_name.len, rc);
> >+              return rc;
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >       trace_smb3_open_cached_dir_by_dentry(NULL, dentry->d_name.name,
> >@@ -1715,7 +1774,9 @@ __releases(&cfid->cfids->cfid_list_lock)
> >       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> >
> >       if (cfid->on_list) {
> >-              list_del(&cfid->entry);
> >+              if (cfid->dentry)
> >+                      hlist_del_init(&cfid->dentry_node);
> >+              rb_erase(&cfid->node, &cfid->cfids->entries);
> >               cfid->on_list =3D false;
> >               cfid->cfids->num_entries--;
> >       }
> >@@ -1790,6 +1851,7 @@ void close_all_cached_dirs(struct cifs_sb_info *ci=
fs_sb)
> > {
> >       struct rb_root *root =3D &cifs_sb->tlink_tree;
> >       struct rb_node *node;
> >+      struct rb_node *cfid_node;
> >       struct cached_fid *cfid;
> >       struct cifs_tcon *tcon;
> >       struct tcon_link *tlink;
> >@@ -1807,7 +1869,9 @@ void close_all_cached_dirs(struct cifs_sb_info *ci=
fs_sb)
> >               if (cfids =3D=3D NULL)
> >                       continue;
> >               spin_lock(&cfids->cfid_list_lock);
> >-              list_for_each_entry(cfid, &cfids->entries, entry) {
> >+              for (cfid_node =3D rb_first(&cfids->entries);
> >+                   cfid_node; cfid_node =3D rb_next(cfid_node)) {
> >+                      cfid =3D rb_entry(cfid_node, struct cached_fid, n=
ode);
> >                       tmp_list =3D kmalloc_obj(*tmp_list, GFP_ATOMIC);
> >                       if (tmp_list =3D=3D NULL) {
> >                               /*
> >@@ -1823,6 +1887,7 @@ void close_all_cached_dirs(struct cifs_sb_info *ci=
fs_sb)
> >
> >                       spin_lock(&cfid->cfid_lock);
> >                       tmp_list->dentry =3D cfid->dentry;
> >+                      hlist_del_init(&cfid->dentry_node);
> >                       cfid->dentry =3D NULL;
> >                       spin_unlock(&cfid->cfid_lock);
> >
> >@@ -1850,7 +1915,8 @@ void close_all_cached_dirs(struct cifs_sb_info *ci=
fs_sb)
> > void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
> > {
> >       struct cached_fids *cfids =3D tcon->cfids;
> >-      struct cached_fid *cfid, *q;
> >+      struct cached_fid *cfid;
> >+      struct rb_node *rb_node =3D NULL, *next_node =3D NULL;
> >
> >       if (cfids =3D=3D NULL)
> >               return;
> >@@ -1861,8 +1927,14 @@ void invalidate_all_cached_dirs(struct cifs_tcon =
*tcon, bool sync)
> >        * during this process.
> >        */
> >       spin_lock(&cfids->cfid_list_lock);
> >-      list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >-              list_move(&cfid->entry, &cfids->dying);
> >+      for (rb_node =3D rb_first(&cfids->entries);
> >+           rb_node; rb_node =3D next_node) {
> >+              next_node =3D rb_next(rb_node);
> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
> >+              if (cfid->dentry)
> >+                      hlist_del_init(&cfid->dentry_node);
> >+              rb_erase(rb_node, &cfids->entries);
> >+              list_add(&cfid->dying_entry, &cfids->dying);
> >               cfids->num_entries--;
> >               spin_lock(&cfid->cfid_lock);
> >               cfid->is_open =3D false;
> >@@ -1926,7 +1998,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon=
, __u8 lease_key[16])
> >               return false;
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >-      list_for_each_entry(cfid, &cfids->entries, entry) {
> >+      for (struct rb_node *rb_node =3D rb_first(&cfids->entries);
> >+           rb_node; rb_node =3D rb_next(rb_node)) {
> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
> >               spin_lock(&cfid->cfid_lock);
> >               if (cfid->has_lease &&
> >                   !memcmp(lease_key,
> >@@ -1939,7 +2013,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon=
, __u8 lease_key[16])
> >                        * We found a lease remove it from the list
> >                        * so no threads can access it.
> >                        */
> >-                      list_del(&cfid->entry);
> >+                      if (cfid->dentry)
> >+                              hlist_del_init(&cfid->dentry_node);
> >+                      rb_erase(rb_node, &cfids->entries);
> >                       cfid->on_list =3D false;
> >                       cfids->num_entries--;
> >
> >@@ -1971,7 +2047,9 @@ static struct cached_fid *init_cached_dir(const ch=
ar *path)
> >
> >       INIT_WORK(&cfid->close_work, cached_dir_offload_close);
> >       INIT_WORK(&cfid->put_work, cached_dir_put_work);
> >-      INIT_LIST_HEAD(&cfid->entry);
> >+      RB_CLEAR_NODE(&cfid->node);
> >+      INIT_HLIST_NODE(&cfid->dentry_node);
> >+      INIT_LIST_HEAD(&cfid->dying_entry);
> >       INIT_LIST_HEAD(&cfid->dirents.entry_list);
> >       mutex_init(&cfid->dirents.de_mutex);
> >       mutex_init(&cfid->cfid_open_mutex);
> >@@ -2026,14 +2104,20 @@ static void cfids_laundromat_worker(struct work_=
struct *work)
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       /* move cfids->dying to the local list */
> >-      list_cut_before(&entry, &cfids->dying, &cfids->dying);
> >+      list_splice_init(&cfids->dying, &entry);
> >
> >-      list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >+      for (struct rb_node *rb_node =3D rb_first(&cfids->entries), *next=
_node;
> >+           rb_node; rb_node =3D next_node) {
> >+              next_node =3D rb_next(rb_node);
> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
> >               spin_lock(&cfid->cfid_lock);
> >               if (dir_cache_timeout && cfid->last_access_time &&
> >                   time_after(jiffies, cfid->last_access_time + HZ * dir=
_cache_timeout)) {
> >                       cfid->on_list =3D false;
> >-                      list_move(&cfid->entry, &entry);
> >+                      if (cfid->dentry)
> >+                              hlist_del_init(&cfid->dentry_node);
> >+                      rb_erase(rb_node, &cfids->entries);
> >+                      list_add(&cfid->dying_entry, &entry);
> >                       cfids->num_entries--;
> >                       if (cfid->has_lease) {
> >                               /*
> >@@ -2052,8 +2136,8 @@ static void cfids_laundromat_worker(struct work_st=
ruct *work)
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >
> >-      list_for_each_entry_safe(cfid, q, &entry, entry) {
> >-              list_del(&cfid->entry);
> >+      list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
> >+              list_del(&cfid->dying_entry);
> >
> >               dput(cfid->dentry);
> >               cfid->dentry =3D NULL;
> >@@ -2085,7 +2169,13 @@ struct cached_fids *init_cached_dirs(void)
> >       if (!cfids)
> >               return NULL;
> >       spin_lock_init(&cfids->cfid_list_lock);
> >-      INIT_LIST_HEAD(&cfids->entries);
> >+      cfids->entries =3D RB_ROOT;
> >+      cfids->dentry_ht =3D kcalloc(1 << CACHED_DIR_DENTRY_HT_BITS,
> >+                                 sizeof(*cfids->dentry_ht), GFP_KERNEL)=
;
> >+      if (!cfids->dentry_ht) {
> >+              kfree(cfids);
> >+              return NULL;
> >+      }
> >       INIT_LIST_HEAD(&cfids->dying);
> >
> >       INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worke=
r);
> >@@ -2113,25 +2203,34 @@ void free_cached_dirs(struct cached_fids *cfids)
> >
> >       cancel_delayed_work_sync(&cfids->laundromat_work);
> >
> >+      kfree(cfids->dentry_ht);
> >+      cfids->dentry_ht =3D NULL;
> >+
> >       spin_lock(&cfids->cfid_list_lock);
> >-      list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >+      for (struct rb_node *rb_node =3D rb_first(&cfids->entries), *next=
_node;
> >+           rb_node; rb_node =3D next_node) {
> >+              next_node =3D rb_next(rb_node);
> >+              cfid =3D rb_entry(rb_node, struct cached_fid, node);
> >               cfid->on_list =3D false;
> >+              if (cfid->dentry)
> >+                      hlist_del_init(&cfid->dentry_node);
> >               spin_lock(&cfid->cfid_lock);
> >               cfid->is_open =3D false;
> >               spin_unlock(&cfid->cfid_lock);
> >-              list_move(&cfid->entry, &entry);
> >+              rb_erase(rb_node, &cfids->entries);
> >+              list_add(&cfid->dying_entry, &entry);
> >       }
> >-      list_for_each_entry_safe(cfid, q, &cfids->dying, entry) {
> >+      list_for_each_entry_safe(cfid, q, &cfids->dying, dying_entry) {
> >               cfid->on_list =3D false;
> >               spin_lock(&cfid->cfid_lock);
> >               cfid->is_open =3D false;
> >               spin_unlock(&cfid->cfid_lock);
> >-              list_move(&cfid->entry, &entry);
> >+              list_move(&cfid->dying_entry, &entry);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >
> >-      list_for_each_entry_safe(cfid, q, &entry, entry) {
> >-              list_del(&cfid->entry);
> >+      list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
> >+              list_del(&cfid->dying_entry);
> >               free_cached_dir(cfid);
> >       }
> >
> >diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> >index 9226463000499..4091fa7867618 100644
> >--- a/fs/smb/client/cached_dir.h
> >+++ b/fs/smb/client/cached_dir.h
> >@@ -11,6 +11,7 @@
> > #include <linux/completion.h>
> > #include <linux/build_bug.h>
> > #include <linux/list.h>
> >+#include <linux/rbtree.h>
> > #include <linux/netfs.h>
> >
> > struct cifs_search_info;
> >@@ -139,7 +140,9 @@ struct cached_dirents {
> > };
> >
> > struct cached_fid {
> >-      struct list_head entry;
> >+      struct rb_node node;
> >+      struct hlist_node dentry_node;
> >+      struct list_head dying_entry;
> >       struct cached_fids *cfids;
> >       const char *path;
> >       bool has_lease;
> >@@ -182,7 +185,8 @@ struct cached_fids {
> >        */
> >       spinlock_t cfid_list_lock;
> >       int num_entries;
> >-      struct list_head entries;
> >+      struct rb_root entries;
> >+      struct hlist_head *dentry_ht;
> >       struct list_head dying;
> >       struct delayed_work laundromat_work;
> >       /* aggregate accounting for all cached dirents under this tcon */
> >diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> >index 131af7333fc58..9240ee6391dd1 100644
> >--- a/fs/smb/client/cifs_debug.c
> >+++ b/fs/smb/client/cifs_debug.c
> >@@ -328,7 +328,9 @@ static int cifs_debug_dirs_proc_show(struct seq_file=
 *m, void *v)
> >                                               cfids->num_entries,
> >                                               (unsigned long)atomic_lon=
g_read(&cfids->total_dirents_entries),
> >                                               (unsigned long long)atomi=
c64_read(&cfids->total_dirents_bytes));
> >-                              list_for_each_entry(cfid, &cfids->entries=
, entry) {
> >+                              for (struct rb_node *rb_node =3D rb_first=
(&cfids->entries);
> >+                                   rb_node; rb_node =3D rb_next(rb_node=
)) {
> >+                                      cfid =3D rb_entry(rb_node, struct=
 cached_fid, node);
> >                                       spin_lock(&cfid->cfid_lock);
> >                                       seq_printf(m, "0x%x 0x%llx 0x%llx=
 ",
> >                                               tcon->tid,
> >--
> >2.43.0
> >
> >



--=20
Regards,
Shyam
