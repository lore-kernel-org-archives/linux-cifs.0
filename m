Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E86376
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746215895; cv=none; b=gWHvKl0Pq83KyuBkAkokSNOihhaKRuNmAznmmxcCHXUxAossEdbg44OMeLsQofeQgDujuPrGXXPJuLBJp97uiLkCS4pxDLXRGOgsbpikXpGaeuo5KOc7qKZQh0xhOcfeUtPZfVY7Xmxh8hD/KvTDOG+vAISdxOhipBcX4nb0PeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746215895; c=relaxed/simple;
	bh=/re5hbM5YQoAmmbtyJwcyIws4L3mMikI04GfQT2mAgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5gdmahsxPAo1kMKJKBgTGaIDJMdFqbyqWdMHC2TLN7a6iO1F18v0TwRtgEKi7ifZF/nROWzfyY9nWw/QTtbFfit8QdWFqiLTnUd3jLTwzbSAm132G0eIsOKkzJ3pcvlSbhjr8+KCldDvXoqKzunPzvhVsU7975r9ePlXb3j5II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WadZLGej; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8AFHgy3g; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WadZLGej; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8AFHgy3g; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WadZLGej";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8AFHgy3g";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WadZLGej";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8AFHgy3g"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 84AE91F385;
	Fri,  2 May 2025 19:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746215890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jR37bEjYFu0KReEjsHPDysVr0q4o6ARRTasO0h9ylmU=;
	b=WadZLGejuISsC275wpVaIvGAEiIXIV2TEy+/YhlJr90lPEsdAQ8sAFBv1/TIgiyB+UuwPT
	OAnr+0uTuKBu1QI6to7p6Nj6O+tBcSwvVBC3KOVM9ApawLTuBIUVWAbiOIOCYv4kCAfznF
	FMBIoRtnhwFIz1RtoQU6aM2LOgFDBO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746215890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jR37bEjYFu0KReEjsHPDysVr0q4o6ARRTasO0h9ylmU=;
	b=8AFHgy3guuV+OydpIYSsJRGKMJqygdkuMPnB+JZpWl8cczin/HwTcyq6lP3r/XZpMG15BJ
	F+Y0swc9SxvZc5AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746215890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jR37bEjYFu0KReEjsHPDysVr0q4o6ARRTasO0h9ylmU=;
	b=WadZLGejuISsC275wpVaIvGAEiIXIV2TEy+/YhlJr90lPEsdAQ8sAFBv1/TIgiyB+UuwPT
	OAnr+0uTuKBu1QI6to7p6Nj6O+tBcSwvVBC3KOVM9ApawLTuBIUVWAbiOIOCYv4kCAfznF
	FMBIoRtnhwFIz1RtoQU6aM2LOgFDBO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746215890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jR37bEjYFu0KReEjsHPDysVr0q4o6ARRTasO0h9ylmU=;
	b=8AFHgy3guuV+OydpIYSsJRGKMJqygdkuMPnB+JZpWl8cczin/HwTcyq6lP3r/XZpMG15BJ
	F+Y0swc9SxvZc5AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3424F1372E;
	Fri,  2 May 2025 19:58:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Snk6Os8jFWhweAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 02 May 2025 19:58:07 +0000
Date: Fri, 2 May 2025 16:58:00 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, paul@darkrain42.org, 
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH] smb: cached_dir.c: fix race in cfid release
Message-ID: <fh2ose2otti5opro6jmpoo6dr4uhc2nfdrlgo3e2ikim4y4gqq@7zxtxyyhphah>
References: <20250502180136.192407-1-henrique.carvalho@suse.com>
 <CAH2r5msw0gCUH29up7D5p2eH5LLGtmwu9E5PJagUi3S2trPHrA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5msw0gCUH29up7D5p2eH5LLGtmwu9E5PJagUi3S2trPHrA@mail.gmail.com>
X-Spam-Score: -3.79
X-Spamd-Result: default: False [-3.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.970];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,manguebit.com,gmail.com,microsoft.com,darkrain42.org,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 05/02, Steve French wrote:
>I fixed a minor checkpatch warning but also noticed this compile
>warning - is there a missing lock call?
>
>cached_dir.c:429:20: warning: context imbalance in 'cfid_release' -
>unexpected unlock

The lock is taken (inside kref_put_lock) if count =3D=3D 0 (i.e. when the
release function is called) and must be released from within the
release function (which is done here).

However, sparse can't recognize this and also there doesn't seem to
exist an annotation to indicate so.

@Henrique do you think you could rework the patch to something like:

cfid_release() {
	list_del();
	on_list =3D false;
	num_entries--;
}

cfid_put() {
	lock();
	if (kref_put(..., cfid_release)) {
		unlock();
		dput();
		SMB2_close();
		free_cached_dir();
		return;
	}
	unlock();
}


Cheers,

Enzo

>On Fri, May 2, 2025 at 1:04=E2=80=AFPM Henrique Carvalho
><henrique.carvalho@suse.com> wrote:
>>
>> find_or_create_cached_dir() could grab a new reference after kref_put()
>> had seen the refcount drop to zero but before cfid_list_lock is acquired
>> in smb2_close_cached_fid(), leading to use-after-free.
>>
>> Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
>> held, closing that gap.
>>
>> While we are at it:
>> * rename the functions smb2_close_cached_fid() and close_cached_dir()
>>   for clarity;
>> * replace the calls to kref_put() for cfid_put().
>>
>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>> ---
>>  fs/smb/client/cached_dir.c | 28 ++++++++++++++++------------
>>  fs/smb/client/cached_dir.h |  2 +-
>>  fs/smb/client/inode.c      |  4 ++--
>>  fs/smb/client/readdir.c    |  4 ++--
>>  fs/smb/client/smb2inode.c  |  2 +-
>>  fs/smb/client/smb2ops.c    |  8 ++++----
>>  6 files changed, 26 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>> index fe738623cf1b..ff4f9f8150cf 100644
>> --- a/fs/smb/client/cached_dir.c
>> +++ b/fs/smb/client/cached_dir.c
>> @@ -14,7 +14,7 @@
>>
>>  static struct cached_fid *init_cached_dir(const char *path);
>>  static void free_cached_dir(struct cached_fid *cfid);
>> -static void smb2_close_cached_fid(struct kref *ref);
>> +static void cfid_release(struct kref *ref);
>>  static void cfids_laundromat_worker(struct work_struct *work);
>>
>>  struct cached_dir_dentry {
>> @@ -370,11 +370,13 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
>>                          * lease. Release one here, and the second below.
>>                          */
>>                         cfid->has_lease =3D false;
>> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +
>> +                       /* If this cfid_put calls back cfid_release the =
code is wrong anyway. */
>> +                       cfid_put(cfid);
>>                 }
>>                 spin_unlock(&cfids->cfid_list_lock);
>>
>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +               cfid_put(cfid);
>>         } else {
>>                 *ret_cfid =3D cfid;
>>                 atomic_inc(&tcon->num_remote_opens);
>> @@ -413,13 +415,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tc=
on,
>>  }
>>
>>  static void
>> -smb2_close_cached_fid(struct kref *ref)
>> +cfid_release(struct kref *ref)
>>  {
>>         struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
>>                                                refcount);
>>         int rc;
>>
>> -       spin_lock(&cfid->cfids->cfid_list_lock);
>>         if (cfid->on_list) {
>>                 list_del(&cfid->entry);
>>                 cfid->on_list =3D false;
>> @@ -454,16 +455,19 @@ void drop_cached_dir_by_name(const unsigned int xi=
d, struct cifs_tcon *tcon,
>>         spin_lock(&cfid->cfids->cfid_list_lock);
>>         if (cfid->has_lease) {
>>                 cfid->has_lease =3D false;
>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +
>> +               /* If this cfid_put calls back cfid_release the code is =
wrong anyway. */
>> +               cfid_put(cfid);
>>         }
>>         spin_unlock(&cfid->cfids->cfid_list_lock);
>> -       close_cached_dir(cfid);
>> +       cfid_put(cfid);
>>  }
>>
>>
>> -void close_cached_dir(struct cached_fid *cfid)
>> +void cfid_put(struct cached_fid *cfid)
>>  {
>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +       struct cached_fids *cfids =3D cfid->tcon->cfids;
>> +       kref_put_lock(&cfid->refcount, cfid_release, &cfids->cfid_list_l=
ock);
>>  }
>>
>>  /*
>> @@ -564,7 +568,7 @@ cached_dir_offload_close(struct work_struct *work)
>>
>>         WARN_ON(cfid->on_list);
>>
>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +       cfid_put(cfid);
>>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>>  }
>>
>> @@ -688,7 +692,7 @@ static void cfids_invalidation_worker(struct work_st=
ruct *work)
>>         list_for_each_entry_safe(cfid, q, &entry, entry) {
>>                 list_del(&cfid->entry);
>>                 /* Drop the ref-count acquired in invalidate_all_cached_=
dirs */
>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +               cfid_put(cfid);
>>         }
>>  }
>>
>> @@ -741,7 +745,7 @@ static void cfids_laundromat_worker(struct work_stru=
ct *work)
>>                          * Drop the ref-count from above, either the lea=
se-ref (if there
>>                          * was one) or the extra one acquired.
>>                          */
>> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +                       cfid_put(cfid);
>>         }
>>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>>                            dir_cache_timeout * HZ);
>> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
>> index 1dfe79d947a6..f4fc7818dda5 100644
>> --- a/fs/smb/client/cached_dir.h
>> +++ b/fs/smb/client/cached_dir.h
>> @@ -73,7 +73,7 @@ extern int open_cached_dir(unsigned int xid, struct ci=
fs_tcon *tcon,
>>  extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>>                                      struct dentry *dentry,
>>                                      struct cached_fid **cfid);
>> -extern void close_cached_dir(struct cached_fid *cfid);
>> +extern void cfid_put(struct cached_fid *cfid);
>>  extern void drop_cached_dir_by_name(const unsigned int xid,
>>                                     struct cifs_tcon *tcon,
>>                                     const char *name,
>> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>> index 75be4b46bc6f..c3ef1f93a80d 100644
>> --- a/fs/smb/client/inode.c
>> +++ b/fs/smb/client/inode.c
>> @@ -2610,10 +2610,10 @@ cifs_dentry_needs_reval(struct dentry *dentry)
>>
>>         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
>>                 if (cfid->time && cifs_i->time > cfid->time) {
>> -                       close_cached_dir(cfid);
>> +                       cfid_put(cfid);
>>                         return false;
>>                 }
>> -               close_cached_dir(cfid);
>> +               cfid_put(cfid);
>>         }
>>         /*
>>          * depending on inode type, check if attribute caching disabled =
for
>> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
>> index 50f96259d9ad..1e1768152803 100644
>> --- a/fs/smb/client/readdir.c
>> +++ b/fs/smb/client/readdir.c
>> @@ -1093,7 +1093,7 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
>>          * find_cifs_entry in case there will be reconnects during
>>          * query_directory.
>>          */
>> -       close_cached_dir(cfid);
>> +       cfid_put(cfid);
>>         cfid =3D NULL;
>>
>>   cache_not_found:
>> @@ -1199,7 +1199,7 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
>>
>>  rddir2_exit:
>>         if (cfid)
>> -               close_cached_dir(cfid);
>> +               cfid_put(cfid);
>>         free_dentry_path(page);
>>         free_xid(xid);
>>         return rc;
>> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
>> index 57d9bfbadd97..f805d71a8d19 100644
>> --- a/fs/smb/client/smb2inode.c
>> +++ b/fs/smb/client/smb2inode.c
>> @@ -975,7 +975,7 @@ int smb2_query_path_info(const unsigned int xid,
>>                                                      cfid->fid.volatile_=
fid,
>>                                                      &data->fi);
>>                         }
>> -                       close_cached_dir(cfid);
>> +                       cfid_put(cfid);
>>                         return rc;
>>                 }
>>                 cmds[num_cmds++] =3D SMB2_OP_QUERY_INFO;
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index 2fe8eeb98535..97c4d44c9a69 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -889,7 +889,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tc=
on *tcon,
>>         if (cfid =3D=3D NULL)
>>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_f=
id);
>>         else
>> -               close_cached_dir(cfid);
>> +               cfid_put(cfid);
>>  }
>>
>>  static void
>> @@ -940,10 +940,10 @@ smb2_is_path_accessible(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>>         rc =3D open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfi=
d);
>>         if (!rc) {
>>                 if (cfid->has_lease) {
>> -                       close_cached_dir(cfid);
>> +                       cfid_put(cfid);
>>                         return 0;
>>                 }
>> -               close_cached_dir(cfid);
>> +               cfid_put(cfid);
>>         }
>>
>>         utf16_path =3D cifs_convert_path_to_utf16(full_path, cifs_sb);
>> @@ -2804,7 +2804,7 @@ smb2_query_info_compound(const unsigned int xid, s=
truct cifs_tcon *tcon,
>>         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
>>         free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
>>         if (cfid)
>> -               close_cached_dir(cfid);
>> +               cfid_put(cfid);
>>         kfree(vars);
>>  out_free_path:
>>         kfree(utf16_path);
>> --
>> 2.47.0
>>
>>
>
>
>--=20
>Thanks,
>
>Steve
>
