Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5F5382F18
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777630837; cv=pass; b=suKUeo3TqW0kcSPdc6kW3rKYi4u+8Itssd87TkCbrAIEKOHCdADQkV6d1wqSjghCWBLE3uSbwF3YoMOfUizaTEN7MT+TSXQwLIdTfytwhcD1cj7IuusrrKKpm5++9AhnUYyIpK0bAEoBje1ZVMRoSRjGj01wGcvnvzUMwT0jk3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777630837; c=relaxed/simple;
	bh=3AVVKAxAUnCxE5E5oZGJttIVJjViht9zKZkSiouvKYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bLLR63zH1gk1X+TnQBHnKSliuN752IMyodCMXSNRHTsi16OeGShcln/9fbcKYRk8K1+TXjVAh67hcv149YGG5tenPG9KNBJIRw2ZXjHZkqNIc0L6p8efMDLwIyuXANDZTLv7o85idr7wYKlJcuy5OLA3hCn0M79aIBfQIt6p6H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pwALY9La; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pwALY9La"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8f9568e074so285248266b.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 03:20:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777630833; cv=none;
        d=google.com; s=arc-20240605;
        b=QLgpWCRomE9ekDxE0jLZk0s13MYdPsQKx+0GIJp4lsCFsZQpcGfUGPNrGvrhMfQOtP
         Aqwv20S8lJy6UwVy8EHqAx1M14s8NzYsGP183pmPwuB7C6t5B1mpu+VyuGsKtjypdU34
         nWbgKkwLfciXTX5YAsFeIkgJLQYU8TXLunVT10RGBIsguNHVMruYZj8OuMuC5GDSYN+9
         iUtBsd6aEk00FC7ygLiYMMPcQ3nvJpLRF2LF6dYoZLI6t/cfozC4MYG++yC4g5y1XTYq
         yLXiDyx+AUTbC3x2fuZkX+YI8YBwuahb/2qP9sRSKxFLNyNg7J9I9wewqz8wFhxY8r7+
         D3yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E81fv8sbc6l5C3z21Koy/7nyh0ZHtZCQIiR6iLEvpxc=;
        fh=nPg8hoTTN7UPOx/8/kKtrBcvPSl0lCQThCI/quIVrz4=;
        b=kqFB/KqJaWSKJsu4+m+9anr9uEaydVBos5eIqFEqwgweqGZ7ztUTBi0HGIsdeMKbBe
         2jPycplAXy/BfKhy0p7XnECmeCq26vp8mj75D6LTygNc6edPgPjCS1ilFyDp4o8txodd
         QVoiD711FHcqeBz+CN1+cf1whhyVoV/J6Vzzw1MQPytuuWwIK0NZiO4OQxIRxaC5RUPW
         kA/WYNxaEIIxEZfpmsnTv2r2onht4EuLMwD3o1DyNuTHSCtkWqx3d0VWJVSRdRPHIcJ0
         23qYlyKJsZIZlKxZSKfHMlQnspM4LlOPJb5MV22r8xGLB8mt3uIwoSqLwp5n+PIkCEog
         hrtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777630833; x=1778235633; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E81fv8sbc6l5C3z21Koy/7nyh0ZHtZCQIiR6iLEvpxc=;
        b=pwALY9Laz1UlbAy5B0QOcAhnXo85bx1WTgT4kehDGb46e/eMULgYP4gOCLfHhakAX0
         et5P3uS0jfKeTbc+AawPAZVSrKeewtJuHkEqNeDsBVrYjho7QkqrNODkDoRwYtfwEXOW
         7CFpjM2/+Q5bC7iby83iogKhiApvxtA4Z6SAce4QONs/6oJWYqbEPhUwHm+tUOGSdfzq
         S+ZfHGC8XORbOwR0/nUMsEv00VjGxnArjkhrs2byvfrITJOkucjRHqebg3Rr4SQ7V0nd
         oqBfesQ/4TzHkIxzExLeulx/mNc/Fv6xNgOybBPoJn/8Otf3dKNEAhDGWFjK2KiDcoBR
         o7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777630833; x=1778235633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E81fv8sbc6l5C3z21Koy/7nyh0ZHtZCQIiR6iLEvpxc=;
        b=YCnQo9uE7SzVRnv+UzxKO1FCbAamTNMIFuA6h/kdhYmhrYEI27h/5O98p9Iqxu+OnP
         G9O1Wr3AleC0EYQOQ+UY+/hh81ir5GQQWgKP+n5j1gaKb8SfxGy9D9nRIwfoH40Fal6o
         YudhRubaRNAGbq0SXd/S20tkMsNJjmD5daeYc5qaK9wxe7OFdcpfaiib4Cnd9FYzPLzU
         B+5h/dmoG8rlG1LrLuToCWYUa5cW55AuoQSah4LhHDpQpam1atEug+wwNx7EE4PrMtLl
         /7Mf8CBFqD3eJtKmnWvdv4eyF9x21f+TsBZTTw2CneJkLEs8irRtGAwd4XSjy8tFTiiq
         s4wA==
X-Gm-Message-State: AOJu0Yxi4wnZD21CMLenip73CyehPL+b/Z/s+CL3J0uTUX8Dx6TEOF9T
	avFC7ONfH54kYT5YGYkAEL040Ihcc7BfF7UtfYFq5ppGr2Fl+Ysbt5L+50GFo1kApUHK8xGRj9H
	9lO1sk1bIbKcstN1HetzcRZuP77IaSik=
X-Gm-Gg: AeBDietuorNPQP51sWA5DOnOZuM8bnY6qDIHzTS3FZOPnCJbcNFxFgKr/GYdyf40sMn
	mkYurHPl17FEJJ/CnHyX9TSWNSsfkUg31Ij8MjhB19Tk2Ytn7/J5A5UDZ08JQZlTOJjAMrkCRRf
	CmHFH4XgfpgInb/uK+d6EKIv96+iVJARtE25KnNDdfEEPblIV5/WmlsMRSQFdMaxMHHQCe9DoGC
	Yx3yiMoZktDUmxEDWkBsnFDYBN/a3KLrlqWYfKR8Ef+fw0Z5hGU4tAP+3teRjzfMxm76saq1Vg6
	QSszDvmT57kI3OgQ
X-Received: by 2002:a17:907:d28:b0:bab:9f73:3b5a with SMTP id
 a640c23a62f3a-bbac51e6b0bmr450421466b.16.1777630833015; Fri, 01 May 2026
 03:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428160804.281745-1-sprasad@microsoft.com>
 <20260428160804.281745-8-sprasad@microsoft.com> <afDoA7DS7SerAA5e@suse.de>
In-Reply-To: <afDoA7DS7SerAA5e@suse.de>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 1 May 2026 15:50:21 +0530
X-Gm-Features: AVHnY4J3OuACeVFTVQUAbb8DUkjoYEsqRhOOByD9KNVPZCuF6tqQbUIIH11jg8k
Message-ID: <CANT5p=papMX6+7+VVZya6hN9WTUjD_UDLHSgWMxbNrgp8tGFuw@mail.gmail.com>
Subject: Re: [PATCH v3 08/19] cifs: make cfid locks more granular
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 10:48=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>
> On 04/28, nspmangalore@gmail.com wrote:
> >From: Shyam Prasad N <sprasad@microsoft.com>
> >
> >Today all synchronization of cfid related data structures are done
> >using cfid_list_lock. This can serialize caching of different dirs
> >unnecessarily.
> >
> >This change introduces two new locks to provide finer locking.
> >Every cfid will now have a cfid_lock. This is designed to protect
> >everything inside a cfid that is not related to list operations.
> >
> >Every cfid will now also have a cfid_open_mutex. This is designed to
> >protect parallel open calls to the same dir.
> >
> >Additionally, this change will now make accesses to cfid->dentries
> >more stringent using the de_mutex.
>
> Such lock provides no synchronization, race prevention, or any real
> benefit really, cf. 17ef15fa80cf ("smb: client: remove unused fid_lock")
cfid_list_lock for all cached_dir operations introduces major
bottlenecks since for example, open_cached_dir of on directory will
now be serialized behind the same operation on another directory. I
think you agree with that.
de_mutex are necessary to avoid race in access to cached_dentries.
These are a must.
I think you maybe referring to cfid_lock. It does provide protection
in some critical paths, in the absence of cfid_list_lock for the big
chunky protection now.
>
> e.g. here list operations on cfid->entry are not protected by that lock,
> and the list moving/removal are one of the biggest problems ("dentry
> still in use") with e.g. laundromat vs tcon reconnect scenarios.
>
> By no means I'm suggesting that cfid->entry access should be locked --
> quite the contrary, actually;  I can confirm it's fully possible to have
> the whole cfid infrastructure lockless as I've done it myself based on
> my previous series
> https://lore.kernel.org/linux-cifs/lh2xlppdsuytbidpbl4tnua3wy5islx3iqbosy=
65hud4jo65l3@ysnku7wwx32v/
>
> >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >---
> > fs/smb/client/cached_dir.c | 155 +++++++++++++++++++++++++------------
> > fs/smb/client/cached_dir.h |  13 +++-
> > fs/smb/client/cifs_debug.c |   7 +-
> > fs/smb/client/cifsglob.h   |   2 +
> > fs/smb/client/dir.c        |  34 ++++++--
> > 5 files changed, 149 insertions(+), 62 deletions(-)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index a9bc0c81868c8..ad2439856a1fe 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -16,13 +16,29 @@ static struct cached_fid *init_cached_dir(const char=
 *path);
> > static void free_cached_dir(struct cached_fid *cfid);
> > static void smb2_close_cached_fid(struct kref *ref);
> > static void cfids_laundromat_worker(struct work_struct *work);
> >-static void close_cached_dir_locked(struct cached_fid *cfid);
> >
> > struct cached_dir_dentry {
> >       struct list_head entry;
> >       struct dentry *dentry;
> > };
> >
> >+bool cached_dir_copy_lease_key(struct cached_fid *cfid,
> >+                            __u8 lease_key[SMB2_LEASE_KEY_SIZE])
> >+{
> >+      bool valid;
> >+
> >+      if (!cfid)
> >+              return false;
> >+
> >+      spin_lock(&cfid->cfid_lock);
> >+      valid =3D is_valid_cached_dir(cfid);
> >+      if (valid)
> >+              memcpy(lease_key, cfid->fid.lease_key, SMB2_LEASE_KEY_SIZ=
E);
> >+      spin_unlock(&cfid->cfid_lock);
> >+
> >+      return valid;
> >+}
> >+
> > static bool emit_cached_dirents(struct cached_dirents *cde,
> >                               struct dir_context *ctx)
> > {
> >@@ -244,9 +260,13 @@ static struct cached_fid *find_or_create_cached_dir=
(struct cached_fids *cfids,
> >                        * fully cached or it may be in the process of
> >                        * being deleted due to a lease break.
> >                        */
> >-                      if (!is_valid_cached_dir(cfid))
> >+                      spin_lock(&cfid->cfid_lock);
> >+                      if (!is_valid_cached_dir(cfid)) {
> >+                              spin_unlock(&cfid->cfid_lock);
> >                               return NULL;
> >+                      }
> >                       kref_get(&cfid->refcount);
> >+                      spin_unlock(&cfid->cfid_lock);
> >                       return cfid;
> >               }
> >       }
> >@@ -273,7 +293,9 @@ static struct cached_fid *find_or_create_cached_dir(=
struct cached_fids *cfids,
> >        * Concurrent processes won't be to use it yet due to @cfid->time=
 being
> >        * zero.
> >        */
> >+      spin_lock(&cfid->cfid_lock);
> >       cfid->has_lease =3D true;
> >+      spin_unlock(&cfid->cfid_lock);
> >
> >       return cfid;
> > }
> >@@ -396,19 +418,23 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >               kfree(utf16_path);
> >               return -ENOENT;
> >       }
> >+      spin_unlock(&cfids->cfid_list_lock);
> >+
> >       /*
> >        * Return cached fid if it is valid (has a lease and has a time).
> >        * Otherwise, it is either a new entry or laundromat worker remov=
ed it
> >        * from @cfids->entries.  Caller will put last reference if the l=
atter.
> >        */
> >+
> >+      spin_lock(&cfid->cfid_lock);
> >       if (is_valid_cached_dir(cfid)) {
> >               cfid->last_access_time =3D jiffies;
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+              spin_unlock(&cfid->cfid_lock);
> >               *ret_cfid =3D cfid;
> >               kfree(utf16_path);
> >               return 0;
> >       }
> >-      spin_unlock(&cfids->cfid_list_lock);
> >+      spin_unlock(&cfid->cfid_lock);
> >
> >       pfid =3D &cfid->fid;
> >
> >@@ -438,6 +464,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >
> >                       spin_lock(&cfids->cfid_list_lock);
> >                       list_for_each_entry(parent_cfid, &cfids->entries,=
 entry) {
> >+                              spin_lock(&parent_cfid->cfid_lock);
> >                               if (parent_cfid->dentry =3D=3D dentry->d_=
parent) {
> >                                       cifs_dbg(FYI, "found a parent cac=
hed file handle\n");
> >                                       if (is_valid_cached_dir(parent_cf=
id)) {
> >@@ -447,8 +474,10 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >                                                      parent_cfid->fid.l=
ease_key,
> >                                                      SMB2_LEASE_KEY_SIZ=
E);
> >                                       }
> >+                                      spin_unlock(&parent_cfid->cfid_lo=
ck);
> >                                       break;
> >                               }
> >+                              spin_unlock(&parent_cfid->cfid_lock);
> >                       }
> >                       spin_unlock(&cfids->cfid_list_lock);
> >               }
> >@@ -527,10 +556,13 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >               smb2_set_replay(server, &rqst[1]);
> >       }
> >
> >+      mutex_lock(&cfid->cfid_open_mutex);
> >+
>
> This will make concurrent threads find 'no cfid for path' and then
> they'll all do the SMB2 open serialized, which will make no use at all
> of the first cached one.

Concurrent threads calling cifs_readdir cannot take advantage of
cached dir anyway, as the cached_dirents are not populated till at
least the first QueryDir response is received. So even today, we
choose for those parallel callers to make uncached QueryDirs to the
server.

Till the first SMB2_open response is received, what you're saying
makes sense. But even there, the alternative would be for parallel
calls to wait for the first open_cached_dir to complete.
One option is for find_or_create_cached_dir to return the cfid even if
it is under construction, and open_cached_dir to wait on the
completion event. Perhaps we can solve that in another patch?

>
> >       rc =3D compound_send_recv(xid, ses, server,
> >                               flags, 2, rqst,
> >                               resp_buftype, rsp_iov);
> >       if (rc) {
> >+              mutex_unlock(&cfid->cfid_open_mutex);
> >               if (rc =3D=3D -EREMCHG) {
> >                       tcon->need_reconnect =3D true;
> >                       pr_warn_once("server share %s deleted\n",
> >@@ -538,10 +570,9 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >               }
> >               goto oshr_free;
> >       }
> >+      spin_lock(&cfid->cfid_lock);
> >       cfid->is_open =3D true;
> >
> >-      spin_lock(&cfids->cfid_list_lock);
> >-
> >       o_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> >       oparms.fid->persistent_fid =3D o_rsp->PersistentFileId;
> >       oparms.fid->volatile_fid =3D o_rsp->VolatileFileId;
> >@@ -551,8 +582,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >
> >
> >       if (o_rsp->OplockLevel !=3D SMB2_OPLOCK_LEVEL_LEASE) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >               rc =3D -EINVAL;
> >+              spin_unlock(&cfid->cfid_lock);
> >+              mutex_unlock(&cfid->cfid_open_mutex);
> >               goto oshr_free;
> >       }
> >
> >@@ -561,18 +593,21 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >                                oparms.fid->lease_key,
> >                                &oplock, NULL, NULL);
> >       if (rc) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+              spin_unlock(&cfid->cfid_lock);
> >+              mutex_unlock(&cfid->cfid_open_mutex);
> >               goto oshr_free;
> >       }
> >
> >       rc =3D -EINVAL;
> >       if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+              spin_unlock(&cfid->cfid_lock);
> >+              mutex_unlock(&cfid->cfid_open_mutex);
> >               goto oshr_free;
> >       }
> >       qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> >       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info)) {
> >-              spin_unlock(&cfids->cfid_list_lock);
> >+              spin_unlock(&cfid->cfid_lock);
> >+              mutex_unlock(&cfid->cfid_open_mutex);
> >               goto oshr_free;
> >       }
> >       if (!smb2_validate_and_copy_iov(
> >@@ -584,7 +619,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> >
> >       cfid->time =3D jiffies;
> >       cfid->last_access_time =3D jiffies;
> >-      spin_unlock(&cfids->cfid_list_lock);
> >+      spin_unlock(&cfid->cfid_lock);
> >+      mutex_unlock(&cfid->cfid_open_mutex);
> >       /* At this point the directory handle is fully cached */
> >       rc =3D 0;
> >
> >@@ -595,23 +631,24 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> > out:
> >       if (rc) {
> >+              bool drop_lease_ref =3D false;
> >+
> >               spin_lock(&cfids->cfid_list_lock);
> >               if (cfid->on_list) {
> >                       list_del(&cfid->entry);
> >                       cfid->on_list =3D false;
> >                       cfids->num_entries--;
> >               }
> >+              spin_lock(&cfid->cfid_lock);
> >               if (cfid->has_lease) {
> >-                      /*
> >-                       * We are guaranteed to have two references at th=
is
> >-                       * point. One for the caller and one for a potent=
ial
> >-                       * lease. Release one here, and the second below.
> >-                       */
> >                       cfid->has_lease =3D false;
> >-                      close_cached_dir_locked(cfid);
> >+                      drop_lease_ref =3D true;
> >               }
> >+              spin_unlock(&cfid->cfid_lock);
> >               spin_unlock(&cfids->cfid_list_lock);
> >
> >+              if (drop_lease_ref)
> >+                      close_cached_dir(cfid);
> >               close_cached_dir(cfid);
> >       } else {
> >               *ret_cfid =3D cfid;
> >@@ -642,12 +679,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tc=
on,
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> >               if (cfid->dentry =3D=3D dentry) {
> >-                      if (!is_valid_cached_dir(cfid))
> >+                      spin_lock(&cfid->cfid_lock);
> >+                      if (!is_valid_cached_dir(cfid)) {
> >+                              spin_unlock(&cfid->cfid_lock);
> >                               break;
> >+                      }
> >                       cifs_dbg(FYI, "found a cached file handle by dent=
ry\n");
> >                       kref_get(&cfid->refcount);
> >                       *ret_cfid =3D cfid;
> >                       cfid->last_access_time =3D jiffies;
> >+                      spin_unlock(&cfid->cfid_lock);
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return 0;
> >               }
> >@@ -662,6 +703,8 @@ __releases(&cfid->cfids->cfid_list_lock)
> > {
> >       struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
> >                                              refcount);
> >+      u64 persistent_fid =3D 0, volatile_fid =3D 0;
> >+      bool is_open;
> >       int rc;
> >
> >       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> >@@ -676,9 +719,17 @@ __releases(&cfid->cfids->cfid_list_lock)
> >       dput(cfid->dentry);
> >       cfid->dentry =3D NULL;
> >
> >-      if (cfid->is_open) {
> >-              rc =3D SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid=
,
> >-                         cfid->fid.volatile_fid);
> >+      spin_lock(&cfid->cfid_lock);
> >+      is_open =3D cfid->is_open;
> >+      if (is_open) {
> >+              persistent_fid =3D cfid->fid.persistent_fid;
> >+              volatile_fid =3D cfid->fid.volatile_fid;
> >+              cfid->is_open =3D false;
> >+      }
> >+      spin_unlock(&cfid->cfid_lock);
> >+
> >+      if (is_open) {
> >+              rc =3D SMB2_close(0, cfid->tcon, persistent_fid, volatile=
_fid);
> >               if (rc) /* should we retry on -EBUSY or -EAGAIN? */
> >                       cifs_dbg(VFS, "close cached dir rc %d\n", rc);
> >       }
> >@@ -691,6 +742,7 @@ void drop_cached_dir_by_name(const unsigned int xid,=
 struct cifs_tcon *tcon,
> > {
> >       struct cached_fid *cfid =3D NULL;
> >       int rc;
> >+      bool drop_lease_ref =3D false;
> >
> >       rc =3D open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
> >       if (rc) {
> >@@ -698,11 +750,16 @@ void drop_cached_dir_by_name(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >               return;
> >       }
> >       spin_lock(&cfid->cfids->cfid_list_lock);
> >+      spin_lock(&cfid->cfid_lock);
> >       if (cfid->has_lease) {
> >               cfid->has_lease =3D false;
> >-              close_cached_dir_locked(cfid);
> >+              drop_lease_ref =3D true;
> >       }
> >+      spin_unlock(&cfid->cfid_lock);
> >       spin_unlock(&cfid->cfids->cfid_list_lock);
> >+
> >+      if (drop_lease_ref)
> >+              close_cached_dir(cfid);
> >       close_cached_dir(cfid);
> > }
> >
> >@@ -711,8 +768,7 @@ void drop_cached_dir_by_name(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >  *
> >  * The release function will be called with cfid_list_lock held to remo=
ve the
> >  * cached dirs from the list before any other thread can take another @=
cfid
> >- * ref. Must not be called with cfid_list_lock held; use
> >- * close_cached_dir_locked() called instead.
> >+ * ref. Must not be called with cfid_list_lock held.
> >  *
> >  * @cfid: cached dir
> >  */
> >@@ -722,30 +778,6 @@ void close_cached_dir(struct cached_fid *cfid)
> >       kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfid=
s->cfid_list_lock);
> > }
> >
> >-/**
> >- * close_cached_dir_locked - put a reference of a cached dir with
> >- * cfid_list_lock held
> >- *
> >- * Calling close_cached_dir() with cfid_list_lock held has the potentia=
l effect
> >- * of causing a deadlock if the invariant of refcount >=3D 2 is false.
> >- *
> >- * This function is used in paths that hold cfid_list_lock and expect a=
t least
> >- * two references. If that invariant is violated, WARNs and returns wit=
hout
> >- * dropping a reference; the final put must still go through
> >- * close_cached_dir().
> >- *
> >- * @cfid: cached dir
> >- */
> >-static void close_cached_dir_locked(struct cached_fid *cfid)
> >-{
> >-      lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> >-
> >-      if (WARN_ON(kref_read(&cfid->refcount) < 2))
> >-              return;
> >-
> >-      kref_put(&cfid->refcount, smb2_close_cached_fid);
> >-}
> >-
> > /*
> >  * Called from cifs_kill_sb when we unmount a share
> >  */
> >@@ -784,8 +816,10 @@ void close_all_cached_dirs(struct cifs_sb_info *cif=
s_sb)
> >                               goto done;
> >                       }
> >
> >+                      spin_lock(&cfid->cfid_lock);
> >                       tmp_list->dentry =3D cfid->dentry;
> >                       cfid->dentry =3D NULL;
> >+                      spin_unlock(&cfid->cfid_lock);
> >
> >                       list_add_tail(&tmp_list->entry, &entry);
> >               }
> >@@ -825,16 +859,20 @@ void invalidate_all_cached_dirs(struct cifs_tcon *=
tcon)
> >       list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >               list_move(&cfid->entry, &cfids->dying);
> >               cfids->num_entries--;
> >+              spin_lock(&cfid->cfid_lock);
> >               cfid->is_open =3D false;
> >-              cfid->on_list =3D false;
> >               if (cfid->has_lease) {
> >                       /*
> >                        * The lease was never cancelled from the server,
> >                        * so steal that reference.
> >                        */
> >                       cfid->has_lease =3D false;
> >-              } else
> >+                      spin_unlock(&cfid->cfid_lock);
> >+              } else {
> >+                      spin_unlock(&cfid->cfid_lock);
> >                       kref_get(&cfid->refcount);
> >+              }
> >+              cfid->on_list =3D false;
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >
> >@@ -883,12 +921,14 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon=
, __u8 lease_key[16])
> >
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry(cfid, &cfids->entries, entry) {
> >+              spin_lock(&cfid->cfid_lock);
> >               if (cfid->has_lease &&
> >                   !memcmp(lease_key,
> >                           cfid->fid.lease_key,
> >                           SMB2_LEASE_KEY_SIZE)) {
> >                       cfid->has_lease =3D false;
> >                       cfid->time =3D 0;
> >+                      spin_unlock(&cfid->cfid_lock);
> >                       /*
> >                        * We found a lease remove it from the list
> >                        * so no threads can access it.
> >@@ -904,6 +944,7 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, =
__u8 lease_key[16])
> >                       spin_unlock(&cfids->cfid_list_lock);
> >                       return true;
> >               }
> >+              spin_unlock(&cfid->cfid_lock);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >       return false;
> >@@ -927,6 +968,8 @@ static struct cached_fid *init_cached_dir(const char=
 *path)
> >       INIT_LIST_HEAD(&cfid->entry);
> >       INIT_LIST_HEAD(&cfid->dirents.entries);
> >       mutex_init(&cfid->dirents.de_mutex);
> >+      mutex_init(&cfid->cfid_open_mutex);
> >+      spin_lock_init(&cfid->cfid_lock);
> >       kref_init(&cfid->refcount);
> >       return cfid;
> > }
> >@@ -983,6 +1026,7 @@ static void cfids_laundromat_worker(struct work_str=
uct *work)
> >       list_cut_before(&entry, &cfids->dying, &cfids->dying);
> >
> >       list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >+              spin_lock(&cfid->cfid_lock);
> >               if (cfid->last_access_time &&
> >                   time_after(jiffies, cfid->last_access_time + HZ * dir=
_cache_timeout)) {
> >                       cfid->on_list =3D false;
> >@@ -994,8 +1038,13 @@ static void cfids_laundromat_worker(struct work_st=
ruct *work)
> >                                * server. Steal that reference.
> >                                */
> >                               cfid->has_lease =3D false;
> >-                      } else
> >+                              spin_unlock(&cfid->cfid_lock);
> >+                      } else {
> >+                              spin_unlock(&cfid->cfid_lock);
> >                               kref_get(&cfid->refcount);
> >+                      }
> >+              } else {
> >+                      spin_unlock(&cfid->cfid_lock);
> >               }
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >@@ -1062,12 +1111,16 @@ void free_cached_dirs(struct cached_fids *cfids)
> >       spin_lock(&cfids->cfid_list_lock);
> >       list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >               cfid->on_list =3D false;
> >+              spin_lock(&cfid->cfid_lock);
> >               cfid->is_open =3D false;
> >+              spin_unlock(&cfid->cfid_lock);
> >               list_move(&cfid->entry, &entry);
> >       }
> >       list_for_each_entry_safe(cfid, q, &cfids->dying, entry) {
> >               cfid->on_list =3D false;
> >+              spin_lock(&cfid->cfid_lock);
> >               cfid->is_open =3D false;
> >+              spin_unlock(&cfid->cfid_lock);
> >               list_move(&cfid->entry, &entry);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> >index 09f1f488059c9..f82db6a7ca5b0 100644
> >--- a/fs/smb/client/cached_dir.h
> >+++ b/fs/smb/client/cached_dir.h
> >@@ -48,6 +48,8 @@ struct cached_fid {
> >       struct work_struct put_work;
> >       struct work_struct close_work;
> >       struct cached_dirents dirents;
> >+      struct mutex cfid_open_mutex; /* Serializes OPEN response process=
ing and lease key population */
> >+      spinlock_t cfid_lock; /* Protects: has_lease, time, is_open, file=
_all_info_is_valid, last_access_time, fid.lease_key reads */
> >
> >       /* Must be last as it ends in a flexible-array member. */
> >       struct smb2_file_all_info file_all_info;
> >@@ -56,8 +58,12 @@ struct cached_fid {
> > /* default MAX_CACHED_FIDS is 16 */
> > struct cached_fids {
> >       /* Must be held when:
> >-       * - accessing the cfids->entries list
> >-       * - accessing the cfids->dying list
> >+       * - modifying cfids->entries list (add/remove entries)
> >+       * - modifying cfids->dying list
> >+       * - modifying cfid->on_list or cfids->num_entries
> >+       *
> >+       * Lock ordering: if you need both cfid_list_lock and cfid_lock,
> >+       * acquire cfid_list_lock FIRST, then cfid_lock to avoid deadlock=
.
> >        */
> >       spinlock_t cfid_list_lock;
> >       int num_entries;
> >@@ -78,6 +84,9 @@ is_valid_cached_dir(struct cached_fid *cfid)
> >       return cfid->time && cfid->has_lease;
> > }
> >
> >+bool cached_dir_copy_lease_key(struct cached_fid *cfid,
> >+                            __u8 lease_key[SMB2_LEASE_KEY_SIZE]);
> >+
> > struct cached_fids *init_cached_dirs(void);
> > void free_cached_dirs(struct cached_fids *cfids);
> > int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const cha=
r *path,
> >diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> >index 217444e3e6d01..cc7d26a3917c5 100644
> >--- a/fs/smb/client/cifs_debug.c
> >+++ b/fs/smb/client/cifs_debug.c
> >@@ -327,6 +327,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file=
 *m, void *v)
> >                                               (unsigned long)atomic_lon=
g_read(&cfids->total_dirents_entries),
> >                                               (unsigned long long)atomi=
c64_read(&cfids->total_dirents_bytes));
> >                               list_for_each_entry(cfid, &cfids->entries=
, entry) {
> >+                                      spin_lock(&cfid->cfid_lock);
> >                                       seq_printf(m, "0x%x 0x%llx 0x%llx=
 ",
> >                                               tcon->tid,
> >                                               ses->Suid,
> >@@ -338,11 +339,13 @@ static int cifs_debug_dirs_proc_show(struct seq_fi=
le *m, void *v)
> >                                       seq_printf(m, "%s", cfid->path);
> >                                       if (cfid->file_all_info_is_valid)
> >                                               seq_printf(m, "\tvalid fi=
le info");
> >+                                      spin_unlock(&cfid->cfid_lock);
> >                                       if (cfid->dirents.is_valid)
> >                                               seq_printf(m, ", valid di=
rents");
> >-                                      if (!list_empty(&cfid->dirents.en=
tries))
> >+                                      if (READ_ONCE(cfid->dirents.entri=
es_count))
> >                                               seq_printf(m, ", dirents:=
 %lu entries, %lu bytes",
> >-                                              cfid->dirents.entries_cou=
nt, cfid->dirents.bytes_used);
> >+                                              READ_ONCE(cfid->dirents.e=
ntries_count),
> >+                                              READ_ONCE(cfid->dirents.b=
ytes_used));
> >                                       seq_printf(m, "\n");
> >                               }
> >                               spin_unlock(&cfids->cfid_list_lock);
> >diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> >index 38d5600efe2c8..a15971ffeee58 100644
> >--- a/fs/smb/client/cifsglob.h
> >+++ b/fs/smb/client/cifsglob.h
> >@@ -2068,6 +2068,8 @@ require use of the stronger protocol */
> >  *                            ->can_cache_brlcks
> >  * cifsInodeInfo->deferred_lock       cifsInodeInfo->deferred_closes  c=
ifsInodeInfo_alloc
> >  * cached_fids->cfid_list_lock        cifs_tcon->cfids->entries       i=
nit_cached_dirs
> >+ * cached_fid->cfid_open_mutex        cached_fid OPEN/lease serializati=
on     alloc_cached_dir
> >+ * cached_fid->cfid_lock      cached_fid state                alloc_cac=
hed_dir
> >  * cached_fid->dirents.de_mutex       cached_fid->dirents             a=
lloc_cached_dir
> >  * cifsFileInfo->fh_mutex     cifsFileInfo                    cifs_new_=
fileinfo
> >  * cifsFileInfo->file_info_lock       cifsFileInfo->count             c=
ifs_new_fileinfo
> >diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> >index 6d2378eeb7f68..4e5c580e4de0a 100644
> >--- a/fs/smb/client/dir.c
> >+++ b/fs/smb/client/dir.c
> >@@ -194,6 +194,7 @@ static int cifs_do_create(struct inode *inode, struc=
t dentry *direntry, unsigned
> >       struct cached_fid *parent_cfid =3D NULL;
> >       int rdwr_for_fscache =3D 0;
> >       __le32 lease_flags =3D 0;
> >+      bool found_parent_cfid;
> >
> >       *oplock =3D 0;
> >       if (tcon->ses->server->oplocks)
> >@@ -319,24 +320,33 @@ static int cifs_do_create(struct inode *inode, str=
uct dentry *direntry, unsigned
> >
> > retry_open:
> >       if (tcon->cfids && direntry->d_parent && server->dialect >=3D SMB=
30_PROT_ID) {
> >+              found_parent_cfid =3D false;
> >               parent_cfid =3D NULL;
> >               spin_lock(&tcon->cfids->cfid_list_lock);
> >               list_for_each_entry(parent_cfid, &tcon->cfids->entries, e=
ntry) {
> >+                      spin_lock(&parent_cfid->cfid_lock);
> >                       if (parent_cfid->dentry =3D=3D direntry->d_parent=
) {
> >+                              kref_get(&parent_cfid->refcount);
> >+                              spin_unlock(&parent_cfid->cfid_lock);
> >+                              spin_unlock(&tcon->cfids->cfid_list_lock)=
;
> >+                              found_parent_cfid =3D true;
> >                               cifs_dbg(FYI, "found a parent cached file=
 handle\n");
> >-                              if (is_valid_cached_dir(parent_cfid)) {
> >+                              if (cached_dir_copy_lease_key(parent_cfid=
,
> >+                                                    fid->parent_lease_k=
ey)) {
> >                                       lease_flags
> >                                               |=3D SMB2_LEASE_FLAG_PARE=
NT_LEASE_KEY_SET_LE;
> >-                                      memcpy(fid->parent_lease_key,
> >-                                             parent_cfid->fid.lease_key=
,
> >-                                             SMB2_LEASE_KEY_SIZE);
> >+                                      mutex_lock(&parent_cfid->dirents.=
de_mutex);
> >                                       parent_cfid->dirents.is_valid =3D=
 false;
> >                                       parent_cfid->dirents.is_failed =
=3D true;
> >+                                      mutex_unlock(&parent_cfid->dirent=
s.de_mutex);
> >                               }
> >+                              close_cached_dir(parent_cfid);
> >                               break;
> >                       }
> >+                      spin_unlock(&parent_cfid->cfid_lock);
> >               }
> >-              spin_unlock(&tcon->cfids->cfid_list_lock);
> >+              if (!found_parent_cfid)
> >+                      spin_unlock(&tcon->cfids->cfid_list_lock);
> >       }
> >
> >       oparms =3D (struct cifs_open_parms) {
> >@@ -737,7 +747,12 @@ cifs_lookup(struct inode *parent_dir_inode, struct =
dentry *direntry,
> >                        * dentry is negative and parent is fully cached:
> >                        * we can assume file does not exist
> >                        */
> >-                      if (cfid->dirents.is_valid) {
> >+                      bool dirents_valid;
> >+
> >+                      mutex_lock(&cfid->dirents.de_mutex);
> >+                      dirents_valid =3D cfid->dirents.is_valid;
> >+                      mutex_unlock(&cfid->dirents.de_mutex);
> >+                      if (dirents_valid) {
> >                               close_cached_dir(cfid);
> >                               goto out;
> >                       }
> >@@ -848,7 +863,12 @@ cifs_d_revalidate(struct inode *dir, const struct q=
str *name,
> >                        * dentry is negative and parent is fully cached:
> >                        * we can assume file does not exist
> >                        */
> >-                      if (cfid->dirents.is_valid) {
> >+                      bool dirents_valid;
> >+
> >+                      mutex_lock(&cfid->dirents.de_mutex);
> >+                      dirents_valid =3D cfid->dirents.is_valid;
> >+                      mutex_unlock(&cfid->dirents.de_mutex);
> >+                      if (dirents_valid) {
> >                               close_cached_dir(cfid);
> >                               return 1;
> >                       }
> >--
> >2.43.0
> >
> >



--=20
Regards,
Shyam
