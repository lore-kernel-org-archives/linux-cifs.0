Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75302010E0
	for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2024 17:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732728976; cv=none; b=aut2nBaWeueBhY1r9Ci5tCRPsjmHAyVC58mXlxZEtD9nshdLkhRePzJZVbI6CDv97J71fh8gUdTsMM4r1q2bsUjqdkDdu1QQmw5n7EELoErycu9u2aFhwF2B/nY/gNgDWyvxXNYT09u8FbZDyDvPPD1AccDJNjQrRg+C0/BHvOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732728976; c=relaxed/simple;
	bh=QEC+ifYTCxFJwAQGf3UjeRIuYXtie0gIEs7HeuWHmrI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=S+ZMTBTPgFTTsAROlFQwIIb8w71uAsVIAZRf9TmOuF9v8HomkGa30ls/1nNGHdYRrPrngyYeVVocfjOR3pKojFmX2a3WBEhzhNGSK+yfUp4dN92mh7GzEyri5dOsDmJCNAQHh1S8IeOVjvaGoN81XjHJJwSCm1w5XtCV0ty+e+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=XmaWx+Bh; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="XmaWx+Bh"
Message-ID: <000336dd52367993e8e4c4533e6e80b3@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732728966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tLvTlm0SPKY/pOOcLHCB88WzsDjeIXlo2Uc1RDQqD+k=;
	b=XmaWx+BhRDYnRmnNkxIV4fJxwSCEZPzP7XmU+jmwiEJFLSnkVmA4FbNyCyd71ucNnHdevx
	wIigAOCStGfk6jcWSZx70tjTFx2uPXKlWngfhgjUJF/yjEgmlRajwFg6HH49Owc2jDXLPh
	DPYiEZTTyJBTiBSYoXJ/vtU2Um8xPjmS/q9B5YeZT55OOkhEDsxJ0TNQ37Q+Z4253D8d1O
	pUHVnQdqB+Aws/dUC1+Iy3vyWRW7ExDCn0auRd5cbaBryUokvF7C4y4zJpOCzwzwQBpWk4
	BUgD1ptrnifstq1jDUja/N0f1JQX2qHLy/4b4vNf8dG7a7msVtILJP+UBNtODQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Paul Aurich <paul@darkrain42.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>
Subject: Re: [PATCH v2 4/4] smb: During unmount, ensure all cached dir
 instances drop their dentry
In-Reply-To: <Z0FL4kIUiCMFDVfe@vaarsuvius.home.arpa>
References: <20241118215028.1066662-1-paul@darkrain42.org>
 <20241118215028.1066662-5-paul@darkrain42.org>
 <2a818d91e9f3c392b2739a4c2a018085@manguebit.com>
 <Z0FL4kIUiCMFDVfe@vaarsuvius.home.arpa>
Date: Wed, 27 Nov 2024 14:36:03 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paul Aurich <paul@darkrain42.org> writes:

> On 2024-11-21 23:05:51 -0300, Paulo Alcantara wrote:
>>
>>Why does it need to be a global workqueue?  Can't you make it per tcon?
>
> The problem with a per-tcon workqueue is I didn't see clean way to deal with 
> multiuser mounts and flushing the workqueue in close_all_cached_dirs() -- when 
> dealing with each individual tcon, we're still holding tlink_tree_lock, so an 
> arbitrary sleep seems problematic.

OK.

> There could be a per-sb workqueue (stored in cifs_sb or the master tcon) but 
> is there a way to get back to the superblock / master tcon with just a tcon 
> (e.g. cached_dir_lease_break, when processing a lease break)?

Yes - cifs_get_dfs_tcon_super() does that.

>>> The final cleanup work for cleaning up a cfid is performed via work
>>> queued in the serverclose_wq workqueue; this is done separate from
>>> dropping the dentries so that close_all_cached_dirs() doesn't block on
>>> any server operations.
>>>
>>> Both of these queued works expect to invoked with a cfid reference and
>>> a tcon reference to avoid those objects from being freed while the work
>>> is ongoing.
>>
>>Why do you need to take a tcon reference?
>
> In the existing code (and my patch, without the refs), I was seeing an 
> intermittent use-after-free of the tcon or cached_fids struct by queued work 
> processing a lease break -- the cfid isn't linked from cached_fids, but 
> smb2_close_cached_fid invoking SMB2_close can race with the unmount and 
> cifs_put_tcon
>
> Something like:
>
>      t1                              t2
> cached_dir_lease_break
> smb2_cached_lease_break
> smb2_close_cached_fid
> SMB2_close starts
>                                      cifs_kill_sb
>                                      cifs_umount
>                                      cifs_put_link
>                                      cifs_put_tcon
> SMB2_close continues

Makes sense.

> I had a version of the patch that kept the 'in flight lease breaks' on 
> a second list in cached_fids so that they could be cancelled synchronously 
> from free_cached_fids(), but I struggled with it (I can't remember exactly, 
> but I think I was struggling to get the linked list membership / removal 
> handling and num_entries handling consistent).

No worries.  The damn thing isn't trivial to follow.

>> Can't you drop the dentries
>>when tearing down tcon in cifs_put_tcon()?  No concurrent mounts would
>>be able to access or free it.
>
> The dentries being dropped must occur before kill_anon_super(), as that's 
> where the 'Dentry still in use' check is. All the tcons are put in 
> cifs_umount(), which occurs after:
>
>      kill_anon_super(sb);
>      cifs_umount(cifs_sb);

Right.  Can't we call cancel_work_sync() to make sure that any leases
breakes are processed on the cached directory handle before calling the
above?

> The other thing is that cifs_umount_begin() has this comment, which made me 
> think a tcon can actually be tied to two distinct mount points:
>
>          if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
>                  /* we have other mounts to same share or we have
>                     already tried to umount this and woken up
>                     all waiting network requests, nothing to do */
>
> Although, as I'm thinking about it again, I think I've misunderstood (and that 
> comment is wrong?).

Comment is correct as a single tcon may be shared among different
mounts.

Consider the following where a single tcon is shared:

mount.cifs //srv/share /mnt/1 -o $opts
mount.cifs //srv/share/dir /mnt/2 -o $opts

There will be two different superblocks that end up using same tcon.

> It did cross my mind to pull some of the work out of cifs_umount into 
> cifs_kill_sb (specifically, I wanted to cancel prune_tlinks earlier) -- no 
> prune_tlinks would make it more feasible to drop tlink_tree_lock in 
> close_all_cached_dirs(), at which point a per-tcon workqueue is more 
> practical.

Yeah, multiuser tcons just make it even more complicated.

Sorry for the delay as I've been quite busy with other stuff.

Great work, BTW.
