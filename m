Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8024023B0
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746200160; cv=none; b=Mgf3dU8AT8rnq+ElCowcWNHs3+9znaEhZ+ntyeZSMZiY3LjHiYwkzpC3OO8JW25KE6fnv00V3GwpUSwfF0QVYOSqpqKCPmReHPdfiisU2Ce095csp1cXUX6xDko0SahGAN8XMRBaet3OS4gIliZaUURfWfpOXIYVq+OWQXaKAio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746200160; c=relaxed/simple;
	bh=eJwz7LjSmEGPsANUNntRn5nKX1C9ea3lDwPNy1zTWiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYYRiEuhshKi/WqppgkTa7iN4cWCv9pL+QsJCfhju+Ny2QXeWpS7QgE8+DZqCvv+Z6PEnxtloY2AMcWS86x5X/6vTUB1Et6HhndAHRAw08YjoOOZ87rMaaGQw6nQlwvYb21uugIOgE7+OFuLqKeR7Ci7DZhrVpLGha9HawhVv0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wzrUaKaQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bvRRS3QG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wzrUaKaQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bvRRS3QG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wzrUaKaQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bvRRS3QG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wzrUaKaQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bvRRS3QG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 868892124A;
	Fri,  2 May 2025 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746200155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsSguiApjDERBH9l0oqiIT0ZPd7PnqLeyssDCj+LoQ0=;
	b=wzrUaKaQnfbSxGTADt7v22aJ4U+FZbn+RLGqDfWgOjRM0NUZeWq/hZypHzgV+sySvQQIos
	2Slb7K8KBgEypqADyn2jKH4Oce7rkkiHRHFyQflxCkgwFqD+8io4JvDkAWLNKPH0qzj0BI
	VRvKbBOceThAQb+GjhJShmMQ6Ttr5So=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746200155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsSguiApjDERBH9l0oqiIT0ZPd7PnqLeyssDCj+LoQ0=;
	b=bvRRS3QGjz58YfmvoCu06it5Owv/AQSjK5zV9v9z4tBHwFMpRAIH++oupsiSxLzvbU7gGl
	TqmXA4emL9ECK9Aw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746200155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsSguiApjDERBH9l0oqiIT0ZPd7PnqLeyssDCj+LoQ0=;
	b=wzrUaKaQnfbSxGTADt7v22aJ4U+FZbn+RLGqDfWgOjRM0NUZeWq/hZypHzgV+sySvQQIos
	2Slb7K8KBgEypqADyn2jKH4Oce7rkkiHRHFyQflxCkgwFqD+8io4JvDkAWLNKPH0qzj0BI
	VRvKbBOceThAQb+GjhJShmMQ6Ttr5So=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746200155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsSguiApjDERBH9l0oqiIT0ZPd7PnqLeyssDCj+LoQ0=;
	b=bvRRS3QGjz58YfmvoCu06it5Owv/AQSjK5zV9v9z4tBHwFMpRAIH++oupsiSxLzvbU7gGl
	TqmXA4emL9ECK9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8713D1372E;
	Fri,  2 May 2025 15:35:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y+7eDlrmFGhiPQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 02 May 2025 15:35:54 +0000
Date: Fri, 2 May 2025 12:35:28 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad <nspmangalore@gmail.com>, 
	Bharath SM <bharathsm.hsk@gmail.com>, Paulo Alcantara <pc@manguebit.com>, 
	Paul Aurich <paul@darkrain42.org>, ronnie sahlberg <ronniesahlberg@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
Message-ID: <psb2vmrvmi3guqujqsg4mevhfq6o2l3dtzqwhaszigu35p7c3y@yozknorae2uv>
References: <20250502051517.10449-1-sprasad@microsoft.com>
 <CAH2r5mv+CmYtEZ8oGcQQYzwmh0HYgBpaFwLSR3NqtUWxNwTL=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mv+CmYtEZ8oGcQQYzwmh0HYgBpaFwLSR3NqtUWxNwTL=Q@mail.gmail.com>
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,darkrain42.org,vger.kernel.org,microsoft.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 05/02, Steve French wrote:
>In my testing this first patch led to hangs very quickly running xfstests
>(in that example was to windows server with multichannel). More testing and
>review feedback would be appreciated

Same here.  Very easy reproducer:

# mount.cifs -o ... //srv/share /mnt
# rm -rf /mnt/*
<RCU stall on open_cached_dir_by_dentry() when spinning trying to lock
fid_lock on loop>

I'll debug it and reply with what I find.


Cheers,

Enzo

>Thanks,
>
>Steve
>
>On Fri, May 2, 2025, 12:15=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
>> From: Shyam Prasad N <sprasad@microsoft.com>
>>
>> There are several accesses to cfid structure today without
>> locking fid_lock. This can lead to race conditions that are
>> hard to debug.
>>
>> With this change, I'm trying to make sure that accesses to cfid
>> struct members happen with fid_lock held.
>>
>> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>> ---
>>  fs/smb/client/cached_dir.c | 87 ++++++++++++++++++++++----------------
>>  1 file changed, 50 insertions(+), 37 deletions(-)
>>
>> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>> index fe738623cf1b..f074675fa6be 100644
>> --- a/fs/smb/client/cached_dir.c
>> +++ b/fs/smb/client/cached_dir.c
>> @@ -31,6 +31,7 @@ static struct cached_fid
>> *find_or_create_cached_dir(struct cached_fids *cfids,
>>
>>         spin_lock(&cfids->cfid_list_lock);
>>         list_for_each_entry(cfid, &cfids->entries, entry) {
>> +               spin_lock(&cfid->fid_lock);
>>                 if (!strcmp(cfid->path, path)) {
>>                         /*
>>                          * If it doesn't have a lease it is either not y=
et
>> @@ -38,13 +39,16 @@ static struct cached_fid
>> *find_or_create_cached_dir(struct cached_fids *cfids,
>>                          * being deleted due to a lease break.
>>                          */
>>                         if (!cfid->time || !cfid->has_lease) {
>> +                               spin_unlock(&cfid->fid_lock);
>>                                 spin_unlock(&cfids->cfid_list_lock);
>>                                 return NULL;
>>                         }
>>                         kref_get(&cfid->refcount);
>> +                       spin_unlock(&cfid->fid_lock);
>>                         spin_unlock(&cfids->cfid_list_lock);
>>                         return cfid;
>>                 }
>> +               spin_unlock(&cfid->fid_lock);
>>         }
>>         if (lookup_only) {
>>                 spin_unlock(&cfids->cfid_list_lock);
>> @@ -192,19 +196,20 @@ int open_cached_dir(unsigned int xid, struct
>> cifs_tcon *tcon,
>>                 kfree(utf16_path);
>>                 return -ENOENT;
>>         }
>> +
>>         /*
>>          * Return cached fid if it is valid (has a lease and has a time).
>>          * Otherwise, it is either a new entry or laundromat worker
>> removed it
>>          * from @cfids->entries.  Caller will put last reference if the
>> latter.
>>          */
>> -       spin_lock(&cfids->cfid_list_lock);
>> +       spin_lock(&cfid->fid_lock);
>>         if (cfid->has_lease && cfid->time) {
>> -               spin_unlock(&cfids->cfid_list_lock);
>> +               spin_unlock(&cfid->fid_lock);
>>                 *ret_cfid =3D cfid;
>>                 kfree(utf16_path);
>>                 return 0;
>>         }
>> -       spin_unlock(&cfids->cfid_list_lock);
>> +       spin_unlock(&cfid->fid_lock);
>>
>>         /*
>>          * Skip any prefix paths in @path as lookup_positive_unlocked()
>> ends up
>> @@ -219,17 +224,6 @@ int open_cached_dir(unsigned int xid, struct
>> cifs_tcon *tcon,
>>                 goto out;
>>         }
>>
>> -       if (!npath[0]) {
>> -               dentry =3D dget(cifs_sb->root);
>> -       } else {
>> -               dentry =3D path_to_dentry(cifs_sb, npath);
>> -               if (IS_ERR(dentry)) {
>> -                       rc =3D -ENOENT;
>> -                       goto out;
>> -               }
>> -       }
>> -       cfid->dentry =3D dentry;
>> -       cfid->tcon =3D tcon;
>>
>>         /*
>>          * We do not hold the lock for the open because in case
>> @@ -301,9 +295,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on
>> *tcon,
>>                 }
>>                 goto oshr_free;
>>         }
>> -       cfid->is_open =3D true;
>> -
>> -       spin_lock(&cfids->cfid_list_lock);
>>
>>         o_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
>>         oparms.fid->persistent_fid =3D o_rsp->PersistentFileId;
>> @@ -314,7 +305,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on
>> *tcon,
>>
>>
>>         if (o_rsp->OplockLevel !=3D SMB2_OPLOCK_LEVEL_LEASE) {
>> -               spin_unlock(&cfids->cfid_list_lock);
>>                 rc =3D -EINVAL;
>>                 goto oshr_free;
>>         }
>> @@ -323,21 +313,15 @@ int open_cached_dir(unsigned int xid, struct
>> cifs_tcon *tcon,
>>                                  &oparms.fid->epoch,
>>                                  oparms.fid->lease_key,
>>                                  &oplock, NULL, NULL);
>> -       if (rc) {
>> -               spin_unlock(&cfids->cfid_list_lock);
>> +       if (rc)
>>                 goto oshr_free;
>> -       }
>>
>>         rc =3D -EINVAL;
>> -       if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
>> -               spin_unlock(&cfids->cfid_list_lock);
>> +       if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
>>                 goto oshr_free;
>> -       }
>>         qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>> -       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct
>> smb2_file_all_info)) {
>> -               spin_unlock(&cfids->cfid_list_lock);
>> +       if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct
>> smb2_file_all_info))
>>                 goto oshr_free;
>> -       }
>>         if (!smb2_validate_and_copy_iov(
>>                                 le16_to_cpu(qi_rsp->OutputBufferOffset),
>>                                 sizeof(struct smb2_file_all_info),
>> @@ -345,10 +329,26 @@ int open_cached_dir(unsigned int xid, struct
>> cifs_tcon *tcon,
>>                                 (char *)&cfid->file_all_info))
>>                 cfid->file_all_info_is_valid =3D true;
>>
>> -       cfid->time =3D jiffies;
>> -       spin_unlock(&cfids->cfid_list_lock);
>>         /* At this point the directory handle is fully cached */
>>         rc =3D 0;
>> +       spin_lock(&cfid->fid_lock);
>> +       if (!cfid->dentry) {
>> +               if (!npath[0]) {
>> +                       dentry =3D dget(cifs_sb->root);
>> +               } else {
>> +                       dentry =3D path_to_dentry(cifs_sb, npath);
>> +                       if (IS_ERR(dentry)) {
>> +                               spin_unlock(&cfid->fid_lock);
>> +                               rc =3D -ENOENT;
>> +                               goto out;
>> +                       }
>> +               }
>> +               cfid->dentry =3D dentry;
>> +       }
>> +       cfid->tcon =3D tcon;
>> +       cfid->is_open =3D true;
>> +       cfid->time =3D jiffies;
>> +       spin_unlock(&cfid->fid_lock);
>>
>>  oshr_free:
>>         SMB2_open_free(&rqst[0]);
>> @@ -363,6 +363,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on
>> *tcon,
>>                         cfid->on_list =3D false;
>>                         cfids->num_entries--;
>>                 }
>> +               spin_lock(&cfid->fid_lock);
>>                 if (cfid->has_lease) {
>>                         /*
>>                          * We are guaranteed to have two references at t=
his
>> @@ -372,6 +373,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on
>> *tcon,
>>                         cfid->has_lease =3D false;
>>                         kref_put(&cfid->refcount, smb2_close_cached_fid);
>>                 }
>> +               spin_unlock(&cfid->fid_lock);
>>                 spin_unlock(&cfids->cfid_list_lock);
>>
>>                 kref_put(&cfid->refcount, smb2_close_cached_fid);
>> @@ -400,13 +402,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tc=
on,
>>
>>         spin_lock(&cfids->cfid_list_lock);
>>         list_for_each_entry(cfid, &cfids->entries, entry) {
>> +               spin_lock(&cfid->fid_lock);
>>                 if (dentry && cfid->dentry =3D=3D dentry) {
>>                         cifs_dbg(FYI, "found a cached file handle by
>> dentry\n");
>>                         kref_get(&cfid->refcount);
>> +                       spin_unlock(&cfid->fid_lock);
>>                         *ret_cfid =3D cfid;
>>                         spin_unlock(&cfids->cfid_list_lock);
>>                         return 0;
>>                 }
>> +               spin_unlock(&cfid->fid_lock);
>>         }
>>         spin_unlock(&cfids->cfid_list_lock);
>>         return -ENOENT;
>> @@ -427,8 +432,11 @@ smb2_close_cached_fid(struct kref *ref)
>>         }
>>         spin_unlock(&cfid->cfids->cfid_list_lock);
>>
>> -       dput(cfid->dentry);
>> -       cfid->dentry =3D NULL;
>> +       /* no locking necessary as we're the last user of this cfid */
>> +       if (cfid->dentry) {
>> +               dput(cfid->dentry);
>> +               cfid->dentry =3D NULL;
>> +       }
>>
>>         if (cfid->is_open) {
>>                 rc =3D SMB2_close(0, cfid->tcon, cfid->fid.persistent_fi=
d,
>> @@ -451,12 +459,13 @@ void drop_cached_dir_by_name(const unsigned int xi=
d,
>> struct cifs_tcon *tcon,
>>                 cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", nam=
e);
>>                 return;
>>         }
>> -       spin_lock(&cfid->cfids->cfid_list_lock);
>> +       spin_lock(&cfid->fid_lock);
>>         if (cfid->has_lease) {
>> +               /* mark as invalid */
>>                 cfid->has_lease =3D false;
>>                 kref_put(&cfid->refcount, smb2_close_cached_fid);
>>         }
>> -       spin_unlock(&cfid->cfids->cfid_list_lock);
>> +       spin_unlock(&cfid->fid_lock);
>>         close_cached_dir(cfid);
>>  }
>>
>> @@ -538,6 +547,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tc=
on)
>>                 cfids->num_entries--;
>>                 cfid->is_open =3D false;
>>                 cfid->on_list =3D false;
>> +               spin_lock(&cfid->fid_lock);
>>                 if (cfid->has_lease) {
>>                         /*
>>                          * The lease was never cancelled from the server,
>> @@ -546,6 +556,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tc=
on)
>>                         cfid->has_lease =3D false;
>>                 } else
>>                         kref_get(&cfid->refcount);
>> +               spin_unlock(&cfid->fid_lock);
>>         }
>>         /*
>>          * Queue dropping of the dentries once locks have been dropped
>> @@ -600,6 +611,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon,
>> __u8 lease_key[16])
>>
>>         spin_lock(&cfids->cfid_list_lock);
>>         list_for_each_entry(cfid, &cfids->entries, entry) {
>> +               spin_lock(&cfid->fid_lock);
>>                 if (cfid->has_lease &&
>>                     !memcmp(lease_key,
>>                             cfid->fid.lease_key,
>> @@ -612,6 +624,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon,
>> __u8 lease_key[16])
>>                          */
>>                         list_del(&cfid->entry);
>>                         cfid->on_list =3D false;
>> +                       spin_unlock(&cfid->fid_lock);
>>                         cfids->num_entries--;
>>
>>                         ++tcon->tc_count;
>> @@ -621,6 +634,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon,
>> __u8 lease_key[16])
>>                         spin_unlock(&cfids->cfid_list_lock);
>>                         return true;
>>                 }
>> +               spin_unlock(&cfid->fid_lock);
>>         }
>>         spin_unlock(&cfids->cfid_list_lock);
>>         return false;
>> @@ -656,9 +670,6 @@ static void free_cached_dir(struct cached_fid *cfid)
>>         WARN_ON(work_pending(&cfid->close_work));
>>         WARN_ON(work_pending(&cfid->put_work));
>>
>> -       dput(cfid->dentry);
>> -       cfid->dentry =3D NULL;
>> -
>>         /*
>>          * Delete all cached dirent names
>>          */
>> @@ -703,6 +714,7 @@ static void cfids_laundromat_worker(struct work_stru=
ct
>> *work)
>>
>>         spin_lock(&cfids->cfid_list_lock);
>>         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
>> +               spin_lock(&cfid->fid_lock);
>>                 if (cfid->time &&
>>                     time_after(jiffies, cfid->time + HZ *
>> dir_cache_timeout)) {
>>                         cfid->on_list =3D false;
>> @@ -717,6 +729,7 @@ static void cfids_laundromat_worker(struct work_stru=
ct
>> *work)
>>                         } else
>>                                 kref_get(&cfid->refcount);
>>                 }
>> +               spin_unlock(&cfid->fid_lock);
>>         }
>>         spin_unlock(&cfids->cfid_list_lock);
>>
>> @@ -726,7 +739,6 @@ static void cfids_laundromat_worker(struct work_stru=
ct
>> *work)
>>                 spin_lock(&cfid->fid_lock);
>>                 dentry =3D cfid->dentry;
>>                 cfid->dentry =3D NULL;
>> -               spin_unlock(&cfid->fid_lock);
>>
>>                 dput(dentry);
>>                 if (cfid->is_open) {
>> @@ -742,6 +754,7 @@ static void cfids_laundromat_worker(struct work_stru=
ct
>> *work)
>>                          * was one) or the extra one acquired.
>>                          */
>>                         kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +               spin_unlock(&cfid->fid_lock);
>>         }
>>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>>                            dir_cache_timeout * HZ);
>> --
>> 2.43.0
>>
>>
