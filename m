Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A6412CD88
	for <linux-cifs@vger.kernel.org>; Thu,  2 Oct 2025 03:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759374644; cv=none; b=VTc/OopkaS018Rtaz7bSNswwkfeI8AqImuOlVgRgyCsLR7j99vp/2khEJ03BCzDeTQm6mn5b1ed8Rc25zDaj9nq3Q0mriLV+gsPQqemKg4EHas8zdF1qkpiWh8cswI58GAc6jt2r0exXq8wS7kjCbpTIhoBLjtcf2Eh3cB7HRXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759374644; c=relaxed/simple;
	bh=naEP5xX9TO/gvb3iIPnc1TNUkK4EGVLcKmnj14pAq8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MTmYBGhHcSwptsPG94HTS0ZR7numcK5uR9KuBY9UCApWhNuz7MiD2nPOeuoLxS2d5AOc9hjXjsqK8kYcUrsKm3RqWOA4TQm9kOhFTeCidg0CvPZz9PvLA4HJQsZr9Ps/xwOMaUOLFfj4IhV1xrlrMMlJDkaa33RubcTL3oiasXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFu33pto; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFu33pto"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4de584653cfso9402871cf.0
        for <linux-cifs@vger.kernel.org>; Wed, 01 Oct 2025 20:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759374641; x=1759979441; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NB4DkTvy4ic7040AJNZyVCiOCeeskAYwM8GSZW9U2fw=;
        b=RFu33ptou5bRMZv7QFdFxvZK39fLA96SjcNfOLZGjZ1Y6o1Jm/GvKexarN1H3F6d5E
         Nv6Bf5wr3XUj4XabnT/LHsE5T9L2EsHie33djR6GmWJTGAVpIv8S8aouzFL7aUKMOmf9
         7a8zRzg9CXJEqxYNIvapqAHk2ngaHVfLtG0liODXGPkexczf1t+8obJtPYFzdst4KJAU
         vaqyoe9BVY/e65G/bWvQBsbRvkuTzn2+vE9nPw74RI82wWTXOqLeN8KdKB6/7cmAWViy
         ItCzdIqhOsmgrQOgasSiMSiCFIYPJqQSZhItlWVfuR6+WUJyALrvpFaTnJSgFNPKfbRp
         eqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759374641; x=1759979441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NB4DkTvy4ic7040AJNZyVCiOCeeskAYwM8GSZW9U2fw=;
        b=FFTzlre96fqel1lNCx9xrI3CnGwGwbO5fzQCDav28gYU+GUVPRBy2r1ND/2OXrUio2
         GOB5QGeq8gf0BfYMNXiYzq5hfPmZevmy3Rzy0S0aeKV3uaNxAkMfF29t5NXH5eAKvh1P
         czFUfzTU6Jozi59bbdw35n2esMlyGOj6RZ3rX/kvwVlKeop/3qmykFP0tJ8p6PJVhBP9
         zD2aw1MqfFIHWzQ54NM7Lt5rqvyHsT5blxTtVd06hFbKd/sA8LeL4uazZT6L/ysQLaC6
         aaGhpLt8v5cXqCfNYRg05yrZxh29vwK+j6cSOTaIcS5Tcjk0l1C+oQtScAkNLjuiqnTL
         ziwA==
X-Forwarded-Encrypted: i=1; AJvYcCW1oKvRvV0z9syra3hVd2auSj3maLg4LzhBaQYarPfF6nseUsivJeaqqWP4ivu4J1OpLF1ITPFchPjF@vger.kernel.org
X-Gm-Message-State: AOJu0YwZx37o1Fktc8cHjjeqvF/Vh4FTslxlY+SgPTTbmFwyZD6QKGxl
	TnFFmLj19vJWCrL/c74tkwC2saJrkMbCAFPjPkkvLkgeu7TyoW4AcjBhGMngqTsY4+x1IFok2eL
	Nlx156Mh3AAXK1+SRDwZbLT2EkmVS9FIcT9V+
X-Gm-Gg: ASbGncsWUxEfzI7vI2Rbc1bXUYXJtU7K4sna3Kst4zAkiGK5kKfq/jHj6I5rPuXnJ3A
	1XpqId0opw3pDMwBCEqI7B1bpjA1lzd1F3XpDLutatHt5vhW64HcnMr4SE8UBPJ0farzsP9lFDM
	VF3VXGzNf2OGRloyeOt0Z3PB0apsj9n6pNT/lsm3szNwAzpzLrsLmxvCe258z5bKRW4qzf2rzh6
	PjqfERFa8GfsbDHGRZVAcx9kDnZP+54gLzshm1Hic8//tB74D3zHZ205VusCvvMIu9zyt7pKCsu
	cq7eyJKOEcg+SBdQMiqS/MBF5w0Oa5U4khuQUpZeRfsfEnxJxW5SJybqoSYcQWVSzOA8Cz54hQr
	XKwgKxHHi4g==
X-Google-Smtp-Source: AGHT+IHa609pDoaUoxAUZtMq2YewXC36i0IvPDKSVaNbgXkMgAIHvOC+0jqZTEgqTqHICMnCTBgoYiwMthezHz4BeZk=
X-Received: by 2002:a05:622a:407:b0:4b5:e220:e1bd with SMTP id
 d75a77b69052e-4e41d8a218amr91799971cf.51.1759374641237; Wed, 01 Oct 2025
 20:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919152441.228774-1-henrique.carvalho@suse.com> <u6r7m2pum2gusoazpzerzxu2attq5a4blighytwnkqnujayr7m@rzr6i6triw63>
In-Reply-To: <u6r7m2pum2gusoazpzerzxu2attq5a4blighytwnkqnujayr7m@rzr6i6triw63>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Oct 2025 22:10:30 -0500
X-Gm-Features: AS18NWC7RSHhJcoGzg8tYFLk_6duFHC6jP6sUUEz1bQwGYxKLDmBRJfLs7i1bU4
Message-ID: <CAH2r5ms_m0OLzw0XUyusqi1CdSN8_x-TdWRNLpC=qJ+9o5bVjw@mail.gmail.com>
Subject: Re: [PATCH 1/6] smb: client: ensure open_cached_dir_by_dentry() only
 returns valid cfid
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Enzo,
Added your RB to the 3 patches in Henrique's series that you had indicated.


Also have reordered patches in cifs-2.6.git for-next to put higher
priority/reviewed ones lower down,
and have temporarily pulled out Bharath's patch
("0004-smb-client-cap-smb-directory-cache-memory-via-module.patch")
pending more updates/review etc.

On Fri, Sep 19, 2025 at 10:55=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>
> On 09/19, Henrique Carvalho wrote:
> >open_cached_dir_by_dentry() was exposing an invalid cached directory to
> >callers. The validity check outside the function was exclusively based
> >on cfid->time.
> >
> >Add validity check before returning success and introduce
> >is_valid_cached_dir() helper for consistent checks across the code.
> >
> >Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >---
> > fs/smb/client/cached_dir.c | 9 +++++----
> > fs/smb/client/cached_dir.h | 6 ++++++
> > fs/smb/client/dir.c        | 2 +-
> > fs/smb/client/inode.c      | 2 +-
> > 4 files changed, 13 insertions(+), 6 deletions(-)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index b69daeb1301b..63dc9add4f13 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -36,9 +36,8 @@ static struct cached_fid *find_or_create_cached_dir(st=
ruct cached_fids *cfids,
> >                        * fully cached or it may be in the process of
> >                        * being deleted due to a lease break.
> >                        */
> >-                      if (!cfid->time || !cfid->has_lease) {
> >+                      if (!is_valid_cached_dir(cfid))
> >                               return NULL;
> >-                      }
> >                       kref_get(&cfid->refcount);
> >                       return cfid;
> >               }
> >@@ -194,7 +193,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >        * Otherwise, it is either a new entry or laundromat worker remov=
ed it
> >        * from @cfids->entries.  Caller will put last reference if the l=
atter.
> >        */
> >-      if (cfid->has_lease && cfid->time) {
> >+      if (is_valid_cached_dir(cfid)) {
> >               cfid->last_access_time =3D jiffies;
> >               spin_unlock(&cfids->cfid_list_lock);
> >               *ret_cfid =3D cfid;
> >@@ -233,7 +232,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >                       list_for_each_entry(parent_cfid, &cfids->entries,=
 entry) {
> >                               if (parent_cfid->dentry =3D=3D dentry->d_=
parent) {
> >                                       cifs_dbg(FYI, "found a parent cac=
hed file handle\n");
> >-                                      if (parent_cfid->has_lease && par=
ent_cfid->time) {
> >+                                      if (is_valid_cached_dir(parent_cf=
id)) {
> >                                               lease_flags
> >                                                       |=3D SMB2_LEASE_F=
LAG_PARENT_LEASE_KEY_SET_LE;
> >                                               memcpy(pfid->parent_lease=
_key,
> >@@ -420,6 +419,8 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon=
,
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> >               if (dentry && cfid->dentry =3D=3D dentry) {
> >+                      if (!is_valid_cached_dir(cfid))
> >+                              break;
> >                       cifs_dbg(FYI, "found a cached file handle by dent=
ry\n");
> >                       kref_get(&cfid->refcount);
> >                       *ret_cfid =3D cfid;
> >diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> >index 46b5a2fdf15b..aa12382b4249 100644
> >--- a/fs/smb/client/cached_dir.h
> >+++ b/fs/smb/client/cached_dir.h
> >@@ -64,6 +64,12 @@ struct cached_fids {
> >       struct delayed_work laundromat_work;
> > };
> >
> >+static inline bool
> >+is_valid_cached_dir(struct cached_fid *cfid)
> >+{
> >+      return cfid->time && cfid->has_lease;
> >+}
> >+
> > extern struct cached_fids *init_cached_dirs(void);
> > extern void free_cached_dirs(struct cached_fids *cfids);
> > extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> >index 5223edf6d11a..56c59b67ecc2 100644
> >--- a/fs/smb/client/dir.c
> >+++ b/fs/smb/client/dir.c
> >@@ -322,7 +322,7 @@ static int cifs_do_create(struct inode *inode, struc=
t dentry *direntry, unsigned
> >               list_for_each_entry(parent_cfid, &tcon->cfids->entries, e=
ntry) {
> >                       if (parent_cfid->dentry =3D=3D direntry->d_parent=
) {
> >                               cifs_dbg(FYI, "found a parent cached file=
 handle\n");
> >-                              if (parent_cfid->has_lease && parent_cfid=
->time) {
> >+                              if (is_valid_cached_dir(parent_cfid)) {
> >                                       lease_flags
> >                                               |=3D SMB2_LEASE_FLAG_PARE=
NT_LEASE_KEY_SET_LE;
> >                                       memcpy(fid->parent_lease_key,
> >diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> >index fe453a4b3dc8..9c8b8bd20edd 100644
> >--- a/fs/smb/client/inode.c
> >+++ b/fs/smb/client/inode.c
> >@@ -2639,7 +2639,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
> >               return true;
> >
> >       if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
> >-              if (cfid->time && cifs_i->time > cfid->time) {
> >+              if (cifs_i->time > cfid->time) {
> >                       close_cached_dir(cfid);
> >                       return false;
> >               }
> >--
> >2.50.1
>
> Reviwed-by: Enzo Matsumiya <ematsumiya@suse.de>



--=20
Thanks,

Steve
