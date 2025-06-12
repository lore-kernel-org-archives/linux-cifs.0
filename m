Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B52323AE7C
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 13:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749733529; cv=none; b=PTIPV67u+LAorzILQNdunPERRdJenaaZ5SvP04pWAkOf8W7I/ZbrixNXhLamILYg4KuSXrdG2rpzrJW/Jw2ZNcxNwXKTrCIpKoA9Y/JDv4o5uMRvwuOsdJi96g21s2EStq1uIihHGMV93P5BkKrDk+wCzvo18iWB0YPcMC5J3F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749733529; c=relaxed/simple;
	bh=yWkZsjK+N8Iz2jeqGN1SJmDI8n3dX+lp7H6tV+3rO/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=TeDTjU1ty476V0TcP3X3MQdZokXT5ZTSk1c/S32Tvlaxmqb4ZIIZiDURRepRqGGJVZKNC1QdDB5c6164S+wLpjLpQ4OyFcNaOS0d38ydexudeM+0HdhvxFbq7qAOriNhY6FQ0jbL7AP3Wt7KD578GfHWJ6UnfQj0P157rrLoP7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgNM1pyh; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgNM1pyh"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-604bff84741so2133218a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 06:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749733526; x=1750338326; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IuTAJCty9cwHzhI5O0i4R2uaUaR+kDx2UfqTVrOjFM=;
        b=AgNM1pyhG+abuDu7b9ldsiuKZK08UuF0d4FP3LgAd2D4ia7bFHPs8rq+2IGZUOHsqV
         AOvGYpy053QXGKExkM0PKiwEK7ZeEIC7MCkdyYIxTAix120UjbuUhFLXHxYnFugLJiFW
         r0Y2Kpp2n+KVPpVYqb3xjoPigXk6F62KJAe2yEVriwRdpLbjjz2+QBbcbeeeEr5j7xs4
         HcgNQ32ftXB8KBMpDTgSfEhtPmSCVwILi2DRMj0o6CgHHF7bqEFqoW3HAmO7kl1KDMO9
         BcTwXsu3uMnn70f0tn6cGvRX3Kbo4ZNJTWk5P1LgRBq38DeTfiCtlkWgCUUTl81O3gGF
         IOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749733526; x=1750338326;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0IuTAJCty9cwHzhI5O0i4R2uaUaR+kDx2UfqTVrOjFM=;
        b=ByqwGsrRZMbfNn7ZP8aX7mKmfM86dUAHaQFLN/FqEt+L8M92d1Aub60vWUiOqN6LEC
         yxfYHvgYMK1grdaOjVIuQ1ATrCU6knFMwHZdEGMB3samDevf0O5hyH2FDZnAfGxeq6Z7
         UJXq25+8pwWzj6bXyM0uvkFDSRMQ2ka9W5uqx82thfYrr+23FSbwG8Mo3TZ3T3tGdZUZ
         hlsILQvxhi6D0Qh4e+9gfGhqCespVacW2FZ7woUnpjWwbq0uWF5BWrj06aNFMScZ6zqc
         7QoWOv820kv+hkUuiEvD2VfxhhkWhc0aPkfRPkA5AFT9X/FwP/osmCRSiPn9kmQdU8c/
         3cQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXIetdWj7lVBQFPl/gPEecT/EQFUQxSvO9lcq8xQzhwGz88dihtKFCGdxHy8OonKcd1RSj9lUV3Ya2@vger.kernel.org
X-Gm-Message-State: AOJu0YxudcYoKbyB8mxEOxGhDpsevInIHr6QtQy9xgVyrCmzH0nCC7JV
	lnaPOrtRmEmbdGRv96pFjd8rGk56prCNCz4GavMzza5inu0vIjEYEQY3o2EWwYKqaD5koTje/fb
	ZT9LbvKKWcbPrUbeTbM2EP3ozWCWsVQgSYlbKpns=
X-Gm-Gg: ASbGnctr8oTJJx3UbhbQr1vQZL9cR+FCU40vqOFtODNmP+BkdYQUS11D0lqQ3cvGipA
	3OzqDwz5HhaOrZdjCoJVQbkCtoCJznTf2ZVHWrU/gqSHopUbgvvfRHzv4NBYbWCVaI2aFa6tdG9
	w7Rb2eoIYn0v4/4vDA6syxwToVAwPr52Nv4vpFMfDncA==
X-Google-Smtp-Source: AGHT+IGaCMdIQwoxHPAMZKRJAglDEbgxJbAg7wyaeO7Hw3yiNNxNrlQqZc1Vw9ZWgqbQyD2P8gBYFQUne1GIRvPm2Yg=
X-Received: by 2002:a05:6402:26c5:b0:608:8204:c600 with SMTP id
 4fb4d7f45d1cf-6088204c7f2mr2349815a12.3.1749733525135; Thu, 12 Jun 2025
 06:05:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-2-sprasad@microsoft.com> <aEpIiybxbTbIbDBP@vaarsuvius.home.arpa>
In-Reply-To: <aEpIiybxbTbIbDBP@vaarsuvius.home.arpa>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Jun 2025 18:35:13 +0530
X-Gm-Features: AX0GCFvFFYIG9pKFcSQPw2Jded80qwj0q5QEmevQW8VovNnoYwq-X3HfMbonA_I
Message-ID: <CANT5p=oV8SoYT9AWBCBU5uVFaboeWFyGw8jj9rckLn1eyOj3Cg@mail.gmail.com>
Subject: Re: [PATCH 2/7] cifs: protect cfid accesses with fid_lock
To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	bharathsm.hsk@gmail.com, meetakshisetiyaoss@gmail.com, pc@manguebit.com, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 8:55=E2=80=AFAM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> On 2025-06-04 15:48:11 +0530, nspmangalore@gmail.com wrote:
> >From: Shyam Prasad N <sprasad@microsoft.com>
> >
> >There are several accesses to cfid structure today without
> >locking fid_lock. This can lead to race conditions that are
> >hard to debug.
> >
> >With this change, I'm trying to make sure that accesses to cfid
> >struct members happen with fid_lock held.
> >
> >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >---
> > fs/smb/client/cached_dir.c | 86 ++++++++++++++++++++++----------------
> > 1 file changed, 49 insertions(+), 37 deletions(-)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index e6fc92667d41..e62d3bebff9a 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -31,6 +31,7 @@ static struct cached_fid *find_or_create_cached_dir(st=
ruct cached_fids *cfids,
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> >+              spin_lock(&cfid->fid_lock);
> >               if (!strcmp(cfid->path, path)) {
> >                       /*
> >                        * If it doesn't have a lease it is either not ye=
t
> >@@ -38,13 +39,16 @@ static struct cached_fid *find_or_create_cached_dir(=
struct cached_fids *cfids,
> >                        * being deleted due to a lease break.
> >                        */
> >                       if (!cfid->time || !cfid->has_lease) {
> >+                              spin_unlock(&cfid->fid_lock);
> >                               spin_unlock(&cfids->cfid_list_lock);
> >                               return NULL;
> >                       }
> >                       kref_get(&cfid->refcount);
> >+                      spin_unlock(&cfid->fid_lock);
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return cfid;
> >               }
> >+              spin_unlock(&cfid->fid_lock);
> >       }
> >       if (lookup_only) {
> >               spin_unlock(&cfids->cfid_list_lock);
> >@@ -193,19 +197,20 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >               kfree(utf16_path);
> >               return -ENOENT;
> >       }
> >+
> >       /*
> >        * Return cached fid if it is valid (has a lease and has a time).
> >        * Otherwise, it is either a new entry or laundromat worker remov=
ed it
> >        * from @cfids->entries.  Caller will put last reference if the l=
atter.
> >        */
> >-      spin_lock(&cfids->cfid_list_lock);
> >+      spin_lock(&cfid->fid_lock);
> >       if (cfid->has_lease && cfid->time) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+              spin_unlock(&cfid->fid_lock);
> >               *ret_cfid =3D cfid;
> >               kfree(utf16_path);
> >               return 0;
> >       }
> >-      spin_unlock(&cfids->cfid_list_lock);
> >+      spin_unlock(&cfid->fid_lock);
> >
> >       /*
> >        * Skip any prefix paths in @path as lookup_noperm_positive_unloc=
ked() ends up
> >@@ -220,17 +225,6 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >               goto out;
> >       }
> >
> >-      if (!npath[0]) {
> >-              dentry =3D dget(cifs_sb->root);
> >-      } else {
> >-              dentry =3D path_to_dentry(cifs_sb, npath);
> >-              if (IS_ERR(dentry)) {
> >-                      rc =3D -ENOENT;
> >-                      goto out;
> >-              }
> >-      }
> >-      cfid->dentry =3D dentry;
> >-      cfid->tcon =3D tcon;
>
> I think moving this down below to after the "At this point the directory
> handle is fully cached" comment is going to regress c353ee4fb119 ("smb:
> Initialize cfid->tcon before performing network ops").

Hi Paul,

Are you referring to the tcon reference?
If so, I think the way to fix that is to get a reference (tc_count++)
on tcon right when we add it to the cfid->tcon, and put the reference
in smb2_close_cached_fid.
I think that should take care of any concerns of race. Let me know if
you disagree.

>
> >       /*
> >        * We do not hold the lock for the open because in case
> >@@ -302,9 +296,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >               }
> >               goto oshr_free;
> >       }
> >-      cfid->is_open =3D true;
>
> Moving this down below is going to regress part of 66d45ca1350a ("cifs: C=
heck
> the lease context if we actually got a lease"), I think. If parsing the l=
ease
> fails, the cfid is disposed, but since `is_open` is false, the code won't=
 call
> SMB2_close.

That's a good point. I'll submit a patch to fix this.

>
> >-
> >-      spin_lock(&cfids->cfid_list_lock);
> >
> >       o_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> >       oparms.fid->persistent_fid =3D o_rsp->PersistentFileId;
> >@@ -315,7 +306,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >
> >
> >       if (o_rsp->OplockLevel !=3D SMB2_OPLOCK_LEVEL_LEASE) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >               rc =3D -EINVAL;
> >               goto oshr_free;
> >       }
> >@@ -324,21 +314,15 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >                                &oparms.fid->epoch,
> >                                oparms.fid->lease_key,
> >                                &oplock, NULL, NULL);
> >-      if (rc) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+      if (rc)
> >               goto oshr_free;
> >-      }
> >
> >       rc =3D -EINVAL;
> >-      if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+      if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
> >               goto oshr_free;
> >-      }
> >       qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> >-      if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info)) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+      if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info))
> >               goto oshr_free;
> >-      }
> >       if (!smb2_validate_and_copy_iov(
> >                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> >                               sizeof(struct smb2_file_all_info),
> >@@ -346,10 +330,25 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >                               (char *)&cfid->file_all_info))
> >               cfid->file_all_info_is_valid =3D true;
> >
> >-      cfid->time =3D jiffies;
> >-      spin_unlock(&cfids->cfid_list_lock);
> >       /* At this point the directory handle is fully cached */
> >       rc =3D 0;
> >+      if (!cfid->dentry) {
> >+              if (!npath[0]) {
> >+                      dentry =3D dget(cifs_sb->root);
> >+              } else {
> >+                      dentry =3D path_to_dentry(cifs_sb, npath);
> >+                      if (IS_ERR(dentry)) {
> >+                              rc =3D -ENOENT;
> >+                              goto out;
> >+                      }
> >+              }
> >+      }
> >+      spin_lock(&cfid->fid_lock);
> >+      cfid->dentry =3D dentry;
> >+      cfid->tcon =3D tcon;
> >+      cfid->is_open =3D true;
> >+      cfid->time =3D jiffies;
> >+      spin_unlock(&cfid->fid_lock);
> >
> > oshr_free:
> >       SMB2_open_free(&rqst[0]);
> >@@ -364,6 +363,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >                       cfid->on_list =3D false;
> >                       cfids->num_entries--;
> >               }
> >+              spin_lock(&cfid->fid_lock);
> >               if (cfid->has_lease) {
> >                       /*
> >                        * We are guaranteed to have two references at th=
is
> >@@ -373,6 +373,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >                       cfid->has_lease =3D false;
> >                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> >               }
> >+              spin_unlock(&cfid->fid_lock);
> >               spin_unlock(&cfids->cfid_list_lock);
> >
> >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> >@@ -401,13 +402,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tc=
on,
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> >+              spin_lock(&cfid->fid_lock);
> >               if (dentry && cfid->dentry =3D=3D dentry) {
> >                       cifs_dbg(FYI, "found a cached file handle by dent=
ry\n");
> >                       kref_get(&cfid->refcount);
> >+                      spin_unlock(&cfid->fid_lock);
> >                       *ret_cfid =3D cfid;
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return 0;
> >               }
> >+              spin_unlock(&cfid->fid_lock);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >       return -ENOENT;
> >@@ -428,8 +432,11 @@ smb2_close_cached_fid(struct kref *ref)
> >       }
> >       spin_unlock(&cfid->cfids->cfid_list_lock);
> >
> >-      dput(cfid->dentry);
> >-      cfid->dentry =3D NULL;
> >+      /* no locking necessary as we're the last user of this cfid */
> >+      if (cfid->dentry) {
> >+              dput(cfid->dentry);
> >+              cfid->dentry =3D NULL;
> >+      }
> >
> >       if (cfid->is_open) {
> >               rc =3D SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid=
,
> >@@ -452,12 +459,13 @@ void drop_cached_dir_by_name(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >               cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name=
);
> >               return;
> >       }
> >-      spin_lock(&cfid->cfids->cfid_list_lock);
> >+      spin_lock(&cfid->fid_lock);
> >       if (cfid->has_lease) {
> >+              /* mark as invalid */
> >               cfid->has_lease =3D false;
> >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> >       }
> >-      spin_unlock(&cfid->cfids->cfid_list_lock);
> >+      spin_unlock(&cfid->fid_lock);
> >       close_cached_dir(cfid);
> > }
> >
> >@@ -539,6 +547,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tc=
on)
> >               cfids->num_entries--;
> >               cfid->is_open =3D false;
> >               cfid->on_list =3D false;
> >+              spin_lock(&cfid->fid_lock);
> >               if (cfid->has_lease) {
> >                       /*
> >                        * The lease was never cancelled from the server,
> >@@ -547,6 +556,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tc=
on)
> >                       cfid->has_lease =3D false;
> >               } else
> >                       kref_get(&cfid->refcount);
> >+              spin_unlock(&cfid->fid_lock);
> >       }
> >       /*
> >        * Queue dropping of the dentries once locks have been dropped
> >@@ -601,6 +611,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, _=
_u8 lease_key[16])
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> >+              spin_lock(&cfid->fid_lock);
> >               if (cfid->has_lease &&
> >                   !memcmp(lease_key,
> >                           cfid->fid.lease_key,
> >@@ -613,6 +624,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, _=
_u8 lease_key[16])
> >                        */
> >                       list_del(&cfid->entry);
> >                       cfid->on_list =3D false;
> >+                      spin_unlock(&cfid->fid_lock);
> >                       cfids->num_entries--;
> >
> >                       ++tcon->tc_count;
> >@@ -622,6 +634,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, _=
_u8 lease_key[16])
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return true;
> >               }
> >+              spin_unlock(&cfid->fid_lock);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >       return false;
> >@@ -657,9 +670,6 @@ static void free_cached_dir(struct cached_fid *cfid)
> >       WARN_ON(work_pending(&cfid->close_work));
> >       WARN_ON(work_pending(&cfid->put_work));
> >
> >-      dput(cfid->dentry);
> >-      cfid->dentry =3D NULL;
> >-
> >       /*
> >        * Delete all cached dirent names
> >        */
> >@@ -704,6 +714,7 @@ static void cfids_laundromat_worker(struct work_stru=
ct *work)
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >+              spin_lock(&cfid->fid_lock);
> >               if (cfid->time &&
> >                   time_after(jiffies, cfid->time + HZ * dir_cache_timeo=
ut)) {
> >                       cfid->on_list =3D false;
> >@@ -718,6 +729,7 @@ static void cfids_laundromat_worker(struct work_stru=
ct *work)
> >                       } else
> >                               kref_get(&cfid->refcount);
> >               }
> >+              spin_unlock(&cfid->fid_lock);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >
> >@@ -728,8 +740,8 @@ static void cfids_laundromat_worker(struct work_stru=
ct *work)
> >               dentry =3D cfid->dentry;
> >               cfid->dentry =3D NULL;
> >               spin_unlock(&cfid->fid_lock);
> >-
> >               dput(dentry);
> >+
> >               if (cfid->is_open) {
> >                       spin_lock(&cifs_tcp_ses_lock);
> >                       ++cfid->tcon->tc_count;
> >--
> >2.43.0
>
> ~Paul
>


--=20
Regards,
Shyam
