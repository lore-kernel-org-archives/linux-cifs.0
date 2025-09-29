Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEAB3019CD
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759157066; cv=none; b=QCa+9reLYflaUaCek6rQybwavwisgvXMwzrC7PEVX+68UyOAo09fexRVFJbHFLvJbAeSAnTUY8ChqLCRb6D//MSZcQMlQf4rPb9RrjpXkSn738Zi01OoA/58T5nNsp9Sy+IzyLQOk3uYa9B/880lSCcEF5vTkYJ58vXFfr85Zcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759157066; c=relaxed/simple;
	bh=wnYm1RaICD/HsMtH0XRQ2j9XYtopaZXcaO7cvHYkqkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOW8cIV8o4ruU9KZpFPxNEyHs1prnZ4Xt6xh1D9B1c/1/v4OdW9aYpZ+l/g/bQeXkKgsdGh30PELAh/jG6NNHVitnYXnkTEChNGSHva/Fl06QifMEtwBYJ/+08bAaDcAVLsLkfdJazcBWabM99AnLnho7jHHIP3dW79T1LxvqeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nWSeSmT7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HFSQEsWJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nWSeSmT7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HFSQEsWJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nWSeSmT7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HFSQEsWJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nWSeSmT7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HFSQEsWJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9353B2059F;
	Mon, 29 Sep 2025 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759157060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJMOQu11Tfubqunb4EUNA+ShGbeYtjyejSlu2dFdT1w=;
	b=nWSeSmT7bWiGu9qei4ZWzS0r4KaM5X4SBGtbkI6rb5MsnP56ou0t9KzREtBoW6ycvKyi9M
	/E6X9DIVpjw8TcYF8ItnlG1HSN4IAIB3HDRNSU1JIBBFNdckIsTeIYF57sQupWMYB2pII5
	iuFXWEzzvH8AarckteMLPnAjw1E6/Ag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759157060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJMOQu11Tfubqunb4EUNA+ShGbeYtjyejSlu2dFdT1w=;
	b=HFSQEsWJMAJUGgME4BjDsB3ODlUUYdMEHD+hIGmtqHEwbdwwIeQsHzqXAC46iw1RV6lZ0j
	4iuu/JWm6hZpePCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759157060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJMOQu11Tfubqunb4EUNA+ShGbeYtjyejSlu2dFdT1w=;
	b=nWSeSmT7bWiGu9qei4ZWzS0r4KaM5X4SBGtbkI6rb5MsnP56ou0t9KzREtBoW6ycvKyi9M
	/E6X9DIVpjw8TcYF8ItnlG1HSN4IAIB3HDRNSU1JIBBFNdckIsTeIYF57sQupWMYB2pII5
	iuFXWEzzvH8AarckteMLPnAjw1E6/Ag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759157060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJMOQu11Tfubqunb4EUNA+ShGbeYtjyejSlu2dFdT1w=;
	b=HFSQEsWJMAJUGgME4BjDsB3ODlUUYdMEHD+hIGmtqHEwbdwwIeQsHzqXAC46iw1RV6lZ0j
	4iuu/JWm6hZpePCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E84E13A21;
	Mon, 29 Sep 2025 14:44:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DXPXNUOb2mgmNgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 14:44:19 +0000
Date: Mon, 29 Sep 2025 11:44:17 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH 00/20] smb: client: cached dir fixes and improvements
Message-ID: <lh2xlppdsuytbidpbl4tnua3wy5islx3iqbosy65hud4jo65l3@ysnku7wwx32v>
References: <20250929132805.220558-1-ematsumiya@suse.de>
 <CAH2r5mtAVB-Bvpf941+zN+DGoYHkX74sESVTVYb7oNVy4Gqfpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mtAVB-Bvpf941+zN+DGoYHkX74sESVTVYb7oNVy4Gqfpg@mail.gmail.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,manguebit.com,gmail.com,microsoft.com,talpey.com,suse.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

On 09/29, Steve French wrote:
>Looks promising (although wish could be done in smaller stages, easier
>to test and review).

The patch I sent you privately a while ago contained most of these in a
single patch, and it would be definitely not fun to review.

Also, I keep seeing reviews saying to "split patch into smaller bits for
easier review", so which one is it?

>Do you have any reproducers for the problems it fixes?

Since the issues covered are mostly caused by races, it's hard to come
up with a reproducer, let alone a reliable one.

I do however can say that we have customer bugs with the following
backtraces, that inspired all these changes.

Deadlock in open_cached_dir() when smb2_reconnect() is triggered:

> Kernel panic - not syncing: softlockup: hung tasks
> ...
> RIP: 0010:native_queued_spin_lock_slowpath+0x2d/0x2c0
> ...
>  _raw_spin_lock+0x25/0x30
>  smb2_close_cached_fid+0x17/0xc0
>  open_cached_dir+0x8ff/0xb60
>  ? smb2_query_info_compound+0x332/0x5c0
>  smb2_query_info_compound+0x332/0x5c0
>  ? step_into+0x10d/0x690
>  ? path_lookupat+0x98/0x140
>  ? filename_lookup+0x115/0x1c0
>  smb2_queryfs+0x6a/0xf0
>  cifs_statfs+0x9f/0x2b0
>  statfs_by_dentry+0x67/0x90
>  vfs_statfs+0x16/0xd0
>  user_statfs+0x54/0xa0
>  __do_sys_statfs+0x20/0x50
>  do_syscall_64+0x5b/0x80


Refcount underflow (UAF) in smb2_query_info_compound():

> refcount_t: underflow; use-after-free.
> WARNING: CPU: 1 PID: 11224 at ../lib/refcount.c:28 refcount_warn_saturate=
+0x9c/0x110
> ...
> RIP: 0010:refcount_warn_saturate+0x9c/0x110
> ...
> Call Trace:
>  <TASK>
>  smb2_query_info_compound+0x29c/0x5c0
>  ? step_into+0x10d/0x690
>  ? __legitimize_path+0x28/0x60
>  smb2_queryfs+0x6a/0xf0
>  smb311_queryfs+0x12d/0x140
>  ? kmem_cache_alloc+0x18a/0x340
>  ? getname_flags+0x46/0x1e0
>  cifs_statfs+0x9f/0x2b0
>  statfs_by_dentry+0x67/0x90
>  vfs_statfs+0x16/0xd0
>  user_statfs+0x54/0xa0
>  __do_sys_statfs+0x20/0x50
>  do_syscall_64+0x58/0x80

While developing the patches, I used xfstests generic/241 (dbench 4
clients) which makes heavy usage of cached dirs.

If you printk cfid fields at the end of open_cached_dir() when
rc =3D=3D 0, you should see that it sometimes has been invalidated, and a
now-closed fid is returned to the caller.

If you mix in random interruptions (ctrl-c or network drops) you should
end up with similar backtraces as above.

>I have been
>worried about tests like generic/011 and generic/013 that fail about
>10-20% of the time (probably due to deferred close issues/races) - and
>hoping that we can get more consistent tests ot repro deferred close
>issues so we don't see them in the future.

Yes, that problem also shows up in generic/241 -- even though running
dbench standalone is fine, the xfstest unit does a final cleanup of the
test dir and leads to ENOTEMPTY in the end.

I spent the last 1-2 months debugging this, trying to find a way to fix
it in this very series, but failed.


FWIW, improvement-wise, the pcap for that test, with the series
applied, shows ~5% less opens and ~14% less lease breaks.

Cheers,

Enzo

>On Mon, Sep 29, 2025 at 8:28=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>>
>> Hi,
>>
>> This patch series aims to refactor cached dir related code in order to
>> improve performance, improve code maintenance/readability, and of course
>> fix several, existing and potential, bugs.
>>
>> Please note that the below only makes sense to the whole series applied.
>>
>> Semantic fixes:
>> - cfid->has_lease vs cfid->is_open: when opening a cached dir, we get a =
fid
>>   (is_open) and a lease (has_lease), however, has_lease is used differen=
tly
>>   throughout the code, meaning, most of the time, that the cfid is 'usab=
le'
>>   (fix in patch 11)
>> - refcounting also follows has_lease, up to a point, when we need to
>>   'steal' the reference, then we might have a cfid with 2 refs but
>>   has_lease =3D=3D false (fix in patches 1-5)
>> - cfid lookup: currently done with open_cached_dir() with @lookup_only a=
rg,
>>   but that is not visibly good-looking and also highly inflexible (becau=
se
>>   it only works for paths (char *).
>>
>>
>> Technical fixes:
>> - due to the many "Dentry still in use" bugs, cleaning up a cfid has bec=
ome
>>   too complex -- there are 3 workers to do that asynchronously, and the
>>   release callback itself.  Complexity aside, this still has bugs because
>>   open_cached_dir() design doesn't account for any concurrent invalidati=
on,
>>   leading sometimes to double opens/closes, sometimes straight UAF/deadl=
ock
>>   bugs (examples upon request).
>>   (fix in patches 1-11)
>> - locking: the list lock is not used consistently; sometimes protecting =
only
>>   the list, sometimes protecting only a cfid, sometimes both.
>>   cfid->fid_lock only protects ->dentry, nothing else.  This leads to
>>   inconsistent data being read when a concurrent invalidation occurs, e.=
g.
>>   cached_dir_lease_break() (sets ->time =3D 0) vs cifs_dentry_needs_reva=
l()
>>   (reads ->time unlocked)
>>   * also, open_cached_dir() always assume it has >1 refs, but such
>>     assumption is proven wrong when SMB2_open_init() triggers
>>     smb2_reconnect(), and kref_put() is ran locked in the rc !=3D 0 case,
>>     leading to a deadlock because the extra ref has been dropped async
>>   (both fixed in patch 19 and others)
>>
>> Improvements:
>> Having all above fixes and changes allows a cleaner code with a simpler
>> design:
>> - code readability is improved (cf. whole series)
>> - usage of cached dirs in places that weren't making use of it (cf. patc=
hes
>>   12-18)
>> - patch 19 (locking) not only fixes the synchronization problems, but RC=
U +
>>   seqcounting allows faster lookups (read-mostly) while also allowing
>>   consistent reads and stability for callers (prevents UAF)
>> - because a directory is always a parent, bake-in support for when openi=
ng
>>   a path, ParentLeaseKey can be set for any target child (cf. patch 12)
>>
>>
>> Cheers,
>>
>> Enzo Matsumiya (20):
>>   smb: client: remove cfids_invalidation_worker
>>   smb: client: remove cached_dir_offload_close/close_work
>>   smb: client: remove cached_dir_put_work/put_work
>>   smb: client: remove cached_fids->dying list
>>   smb: client: remove cached_fid->on_list
>>   smb: client: merge {close,invalidate}_all_cached_dirs()
>>   smb: client: merge free_cached_dir in release callback
>>   smb: client: split find_or_create_cached_dir()
>>   smb: client: enhance cached dir lookups
>>   smb: client: refactor dropping cached dirs
>>   smb: client: simplify cached_fid state checking
>>   smb: client: prevent lease breaks of cached parents when opening
>>     children
>>   smb: client: actually use cached dirs on readdir
>>   smb: client: wait for concurrent caching of dirents in cifs_readdir()
>>   smb: client: remove cached_dirent->fattr
>>   smb: client: add is_dir argument to query_path_info
>>   smb: client: use cached dir on queryfs/smb2_compound_op
>>   smb: client: fix dentry revalidation of cached root
>>   smb: client: rework cached dirs synchronization
>>   smb: client: cleanup open_cached_dir()
>>
>>  fs/smb/client/cached_dir.c | 946 ++++++++++++++++---------------------
>>  fs/smb/client/cached_dir.h |  74 +--
>>  fs/smb/client/cifs_debug.c |   7 +-
>>  fs/smb/client/cifsfs.c     |   2 +-
>>  fs/smb/client/cifsglob.h   |   5 +-
>>  fs/smb/client/dir.c        |  27 +-
>>  fs/smb/client/file.c       |   2 +-
>>  fs/smb/client/inode.c      |  38 +-
>>  fs/smb/client/misc.c       |   9 +-
>>  fs/smb/client/readdir.c    | 146 +++---
>>  fs/smb/client/smb1ops.c    |   6 +-
>>  fs/smb/client/smb2inode.c  |  48 +-
>>  fs/smb/client/smb2misc.c   |   2 +-
>>  fs/smb/client/smb2ops.c    |  49 +-
>>  fs/smb/client/smb2pdu.c    |  99 +++-
>>  fs/smb/client/smb2proto.h  |  10 +-
>>  16 files changed, 733 insertions(+), 737 deletions(-)
>>
>> --
>> 2.49.0
>>
>
>
>--=20
>Thanks,
>
>Steve
