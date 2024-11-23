Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC0225A8
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732332523; cv=none; b=NdbBCkjFrUitxv4FUW9HKkSugYcxe2y1VSsukbG+GgGIj1fx4DayzpcNJ4B8t45QjIn+UdfSwvYOZI+y+ru2dhcn1LZZ9NNb6S51OpNsbl6gsnUoM049UpO2v5nUdRK6byXl+xG9nDvjFAy3qXbUwTmFBeoNc7AwIovrxcvl9jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732332523; c=relaxed/simple;
	bh=bhU1E3mmIyyE0oT5FenqIH/0n3YtJKaWhjlLSZks5I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNsrS2HiXx6yn7Wnio6pgsGo7pR4UkuF/+1yaWDBERJcc9ypRhUagcljKMNHyIpThFtTwhAxvCH336oUTWVmnJFa7Oaw6JYvQp9AaeChKBh303LVmqObR4WpCXER4MvOVV/hk3fd5g+BBtbctFe8gDBVy9UjJWkEKApu85/HCGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=y1KbSVMF; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=LkJqMf5r; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="y1KbSVMF";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="LkJqMf5r"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1732332515; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=EuqlADbDDad790JsteO6kxq7s6pd7mp9sGcHbYbQDh0=;
 b=y1KbSVMFthIRrrwzIJ4GAE22nPuIBw1uwfHCo/bb7mpuMQb+BKszr0v7Sut5287rE8WP3
 vYdBBgB3F7hOf+KAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1732332515; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=EuqlADbDDad790JsteO6kxq7s6pd7mp9sGcHbYbQDh0=;
 b=LkJqMf5rp3XZSQu7vx4+EpKWcbLXI1hfYpXUq2G6iYjCYLYYZP6wLBwfeFzLbrreiFO4H
 bYrzobWi7YX4Iha0TfLDgUhCUdCVaqXbwFJ4aHmTULl44sJetf44VqIYcj1dMwy8YeMv49A
 6OGAlzmVspO4wY0bQ/MQycVf448p/tCDZtzgpfnXtVfjiTfW8Uum8SgknmKKQYIShiMH5AX
 h8EWBcVD57FdHyYvDa5x0Y8pd+NsttG+pIy26Z3MMNwnrmKfOv7lOS4PQB83xz0wZI5UwCN
 0F53kFNUcpkdRAtSySWifktrkAVnbzAdEIasRWmfzHbA3Vsh1vEO3XPLxu5Q==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 0F3B782FA;
	Fri, 22 Nov 2024 19:28:35 -0800 (PST)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id 68E2C8C1645; Fri, 22 Nov 2024 19:28:34 -0800 (PST)
Date: Fri, 22 Nov 2024 19:28:34 -0800
From: Paul Aurich <paul@darkrain42.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH v2 4/4] smb: During unmount, ensure all cached dir
 instances drop their dentry
Message-ID: <Z0FL4kIUiCMFDVfe@vaarsuvius.home.arpa>
Mail-Followup-To: Paulo Alcantara <pc@manguebit.com>,
	linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
References: <20241118215028.1066662-1-paul@darkrain42.org>
 <20241118215028.1066662-5-paul@darkrain42.org>
 <2a818d91e9f3c392b2739a4c2a018085@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2a818d91e9f3c392b2739a4c2a018085@manguebit.com>

On 2024-11-21 23:05:51 -0300, Paulo Alcantara wrote:
>Hi Paul,
>
>Thanks for looking into this!  Really appreciate it.
>
>Paul Aurich <paul@darkrain42.org> writes:
>
>> The unmount process (cifs_kill_sb() calling close_all_cached_dirs()) can
>> race with various cached directory operations, which ultimately results
>> in dentries not being dropped and these kernel BUGs:
>>
>> BUG: Dentry ffff88814f37e358{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
>> VFS: Busy inodes after unmount of cifs (cifs)
>> ------------[ cut here ]------------
>> kernel BUG at fs/super.c:661!
>>
>> This happens when a cfid is in the process of being cleaned up when, and
>> has been removed from the cfids->entries list, including:
>>
>> - Receiving a lease break from the server
>> - Server reconnection triggers invalidate_all_cached_dirs(), which
>>   removes all the cfids from the list
>> - The laundromat thread decides to expire an old cfid.
>>
>> To solve these problems, dropping the dentry is done in queued work done
>> in a newly-added cfid_put_wq workqueue, and close_all_cached_dirs()
>> flushes that workqueue after it drops all the dentries of which it's
>> aware. This is a global workqueue (rather than scoped to a mount), but
>> the queued work is minimal.
>
>Why does it need to be a global workqueue?  Can't you make it per tcon?

The problem with a per-tcon workqueue is I didn't see clean way to deal with 
multiuser mounts and flushing the workqueue in close_all_cached_dirs() -- when 
dealing with each individual tcon, we're still holding tlink_tree_lock, so an 
arbitrary sleep seems problematic.

There could be a per-sb workqueue (stored in cifs_sb or the master tcon) but 
is there a way to get back to the superblock / master tcon with just a tcon 
(e.g. cached_dir_lease_break, when processing a lease break)?

>> The final cleanup work for cleaning up a cfid is performed via work
>> queued in the serverclose_wq workqueue; this is done separate from
>> dropping the dentries so that close_all_cached_dirs() doesn't block on
>> any server operations.
>>
>> Both of these queued works expect to invoked with a cfid reference and
>> a tcon reference to avoid those objects from being freed while the work
>> is ongoing.
>
>Why do you need to take a tcon reference?

In the existing code (and my patch, without the refs), I was seeing an 
intermittent use-after-free of the tcon or cached_fids struct by queued work 
processing a lease break -- the cfid isn't linked from cached_fids, but 
smb2_close_cached_fid invoking SMB2_close can race with the unmount and 
cifs_put_tcon

Something like:

     t1                              t2
cached_dir_lease_break
smb2_cached_lease_break
smb2_close_cached_fid
SMB2_close starts
                                     cifs_kill_sb
                                     cifs_umount
                                     cifs_put_link
                                     cifs_put_tcon
SMB2_close continues

I had a version of the patch that kept the 'in flight lease breaks' on 
a second list in cached_fids so that they could be cancelled synchronously 
from free_cached_fids(), but I struggled with it (I can't remember exactly, 
but I think I was struggling to get the linked list membership / removal 
handling and num_entries handling consistent).

> Can't you drop the dentries
>when tearing down tcon in cifs_put_tcon()?  No concurrent mounts would
>be able to access or free it.

The dentries being dropped must occur before kill_anon_super(), as that's 
where the 'Dentry still in use' check is. All the tcons are put in 
cifs_umount(), which occurs after:

     kill_anon_super(sb);
     cifs_umount(cifs_sb);

The other thing is that cifs_umount_begin() has this comment, which made me 
think a tcon can actually be tied to two distinct mount points:

         if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
                 /* we have other mounts to same share or we have
                    already tried to umount this and woken up
                    all waiting network requests, nothing to do */

Although, as I'm thinking about it again, I think I've misunderstood (and that 
comment is wrong?).

It did cross my mind to pull some of the work out of cifs_umount into 
cifs_kill_sb (specifically, I wanted to cancel prune_tlinks earlier) -- no 
prune_tlinks would make it more feasible to drop tlink_tree_lock in 
close_all_cached_dirs(), at which point a per-tcon workqueue is more 
practical.

>After running xfstests I've seen a leaked tcon in
>/proc/fs/cifs/DebugData with no CIFS superblocks, which might be related
>to this.
>
>Could you please check if there is any leaked connection in
>/proc/fs/cifs/DebugData after running your tests?

After I finish with my tests (I'm not using xfstests, although perhaps 
I should be) and unmount the share, DebugData doesn't show any connections for 
me.


~Paul

