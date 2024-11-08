Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4861DFDE
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731107536; cv=none; b=L+LeLRw3DlSSKFGZSYOHzsRQiL8l7BoMeE3rqQgsP1kD1oY5h8iLg1gkO3t7P2JXYsUgYa3hsCJKOIuug4zFG+mKz7+nPlpcuENVPQd9zJPc6eD/Q1vIzWkhr/ltsBJXRN13ak5osp1/ab6XbHnwyUUvKh9gt/raAFGw3ahW/B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731107536; c=relaxed/simple;
	bh=qjVEj6V9FOsqVoU1JToOJM3rnCt7+kScS4h5IdP0Ggo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mp+udg7kQ7xkLonJZ+bH16ERZNBl2OUPM7Nfk8dqZzdZjm9Pj4mKhm6Mjqtm551q0LEiMGXOfJjriz8QFJLHRSq69tSx1OTlCoMuynmiKY62gu1HxRrJpbpVU4EzQYt0Y0OOk0XijPqoB7jX0TtcD6oj7uyuCxzbM24Ncw1yJqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nhxvmmkd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MM9vk/7q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nhxvmmkd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MM9vk/7q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nhxvmmkd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MM9vk/7q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nhxvmmkd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MM9vk/7q"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AEC4621C35;
	Fri,  8 Nov 2024 23:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731107531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rb+PyuKCYIoD5Xl9ek0oP713CInYFBhCYIvJEyv0uok=;
	b=Nhxvmmkd/SP4ZYvxbJH3dIDRt2D66h7+UL7aRgHJ67/8N8QNCXvvT9wIqchje/nMgpoMn5
	G81x4yjMkWy5XSfeefaZZ4a7GJns2NIGziFO/f8BIT+4A8zk+glS5kmJxD7tfaI7u0glAn
	moCXAMr3Fxe532LWLFP46psqkRhkNs0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731107531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rb+PyuKCYIoD5Xl9ek0oP713CInYFBhCYIvJEyv0uok=;
	b=MM9vk/7q5o4x0tdaHVz/D+NrDRPN+/SbzgLPpylVBABVCczoD5qSptXfWtRaVD5vh6gq7p
	l8wcO7BuUq6hiTCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731107531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rb+PyuKCYIoD5Xl9ek0oP713CInYFBhCYIvJEyv0uok=;
	b=Nhxvmmkd/SP4ZYvxbJH3dIDRt2D66h7+UL7aRgHJ67/8N8QNCXvvT9wIqchje/nMgpoMn5
	G81x4yjMkWy5XSfeefaZZ4a7GJns2NIGziFO/f8BIT+4A8zk+glS5kmJxD7tfaI7u0glAn
	moCXAMr3Fxe532LWLFP46psqkRhkNs0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731107531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rb+PyuKCYIoD5Xl9ek0oP713CInYFBhCYIvJEyv0uok=;
	b=MM9vk/7q5o4x0tdaHVz/D+NrDRPN+/SbzgLPpylVBABVCczoD5qSptXfWtRaVD5vh6gq7p
	l8wcO7BuUq6hiTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36F391394A;
	Fri,  8 Nov 2024 23:12:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1tVgAMuaLmeqFwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 08 Nov 2024 23:12:10 +0000
Date: Fri, 8 Nov 2024 20:09:54 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Ralph =?utf-8?B?QsO2aG1l?= <slow@samba.org>
Subject: Re: [PATCH 0/5] SMB cached directory fixes around
 reconnection/unmounting
Message-ID: <igo6lqdjrldrgv5lq344yfsxrrgfwffdrxga3uh3umr324o3zb@icma7vfguafs>
References: <20241108222906.3257172-1-paul@darkrain42.org>
 <CAH2r5muDRhy2gsy7kz9GHC3maGxcxAcam8B3pgCmnS8xcEQX1w@mail.gmail.com>
 <Zy6UW5fuva5VdIWk@haley.home.arpa>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Zy6UW5fuva5VdIWk@haley.home.arpa>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,samba.org,manguebit.com,microsoft.com,talpey.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,darkrain42.org:email]
X-Spam-Score: -3.80
X-Spam-Flag: NO

On 11/08, Paul Aurich wrote:
>No, this series doesn't try to address that. I was just focused on the=20
>issues around the lifecycle of the cfids and the dentry:s.

I'll be reviewing the patches next week, but for now I can say +1.

We've been debugging this issue for the past month or so, and it's been
quite hard to understand/debug who was racing who.

The 'dentry still in use' bug seems to appear only for the root dentry,
whereas cached_fids for subdirectories sometimes can get duplicates, and
thus one dangling, where in the end an underflow + double list_del()
happens to it, e.g.:

(this is coming from cifs_readdir())
crash> cached_fid.entry,cfids,path,has_lease,is_open,on_list,time,tcon,refc=
ount 0xffff892f4b5b3e00
   entry =3D {
     next =3D 0xffff892e053ed400,
     prev =3D 0xffff892d8e3ecb88
   },
   cfids =3D 0xffff892d8e3ecb80,
   path =3D 0xffff892f48b7b3b0 "\\dir1\\dir2\\dir3",
   has_lease =3D 0x0,
   is_open =3D 0x0,
   on_list =3D 0x1,
   time =3D 0x0,
   tcon =3D 0x0,
   refcount =3D { ... counter =3D 0x2 ... }

(this is at the crashing frame on smb2_close_cached_fid())
crash> cached_fid.entry,cfids,path,has_lease,is_open,on_list,time,tcon,refc=
ount ffff892e053ee000
   entry =3D {
     next =3D 0xdead000000000100,
     prev =3D 0xdead000000000122
   },
   cfids =3D 0xffff892d8e3ecb80,
   path =3D 0xffff892f825ced30 "\\dir1\\dir2\\dir3",
   has_lease =3D 0x0,
   is_open =3D 0x1,
   on_list =3D 0x1,
   time =3D 0x1040998fc,
   tcon =3D 0xffff892fe0b4d000,
   refcount =3D { ... counter =3D 0x0 ... }

You can see that the second one had already been deleted (refcount=3D0,
->entry is poisoned), but the first one hasn't been filled in by
open_cached_dir() yet, but already has 2 references to it.

A reliable reproducer I found for this was running xfstests '-g
generic/dir' in one terminal, and generic/072 some seconds later.

(in the beginning I thought that a reconnect was required to trigger
this bug, but any kind of interruption (I could trigger it with ctrl-c
mid-xfstests a few times) should trigger it)

actimeo >=3D 0 seems to play a role as well, because things can get quite
complicated (unsure if problematic though) with a callchain such as:

open_cached_dir
   -> path_to_dentry
     -> lookup_positive_unlocked
       -> lookup_dcache
         -> cifs_d_revalidate (dentry->d_op->d_revalidate)
           -> cifs_revalidate_dentry
             -> cifs_revalidate_dentry_attr
               -> cifs_dentry_needs_reval
                 -> open_cached_dir_by_dentry


Anyway, thanks a lot for you patches, Paul.  Like I said, I'll be
testing + reviewing them soon.


Cheers,

Enzo

>On 2024-11-08 16:39:03 -0600, Steve French wrote:
>>The perf improvement allowing caching of directories (helping "ls"
>>then "ls" again for same dir) not just the perf improvement with "ls
>>"then "stat" could be very important.
>>
>>Did this series also address Ralph's point about missing requesting
>>"H" (handle caching) flag when requesting directory leases from the
>>server?
>>
>>On Fri, Nov 8, 2024 at 4:35=E2=80=AFPM Paul Aurich <paul@darkrain42.org> =
wrote:
>>>
>>>The SMB client cached directory functionality has a few problems around
>>>flaky/lost server connections, which manifest as a pair of BUGs when
>>>eventually unmounting the server connection:
>>>
>>>    [18645.013550] BUG: Dentry ffff888140590ba0{i=3D1000000000080,n=3D/}=
  still in use (2) [unmount of cifs cifs]
>>>    [18645.789274] VFS: Busy inodes after unmount of cifs (cifs)
>>>
>>>Based on bisection, these issues started with the lease directory cache
>>>handling introduced in commit ebe98f1447bb ("cifs: enable caching of
>>>directories for which a lease is held"), and go away if I mount with
>>>'nohandlecache'.  I started seeing these on Debian Bookworm stable kernel
>>>(v6.1.x), but the issues persist even in current git versions.  I think =
the
>>>situation was improved (occurrence frequency went down) with
>>>commit 5c86919455c1 ("smb: client: fix use-after-free in
>>>smb2_query_info_compound()").
>>>
>>>
>>>I'm able to reproduce the "Dentry still in use" errors by connecting to =
an
>>>actively-used SMB share (the server organically generates lease breaks) =
and
>>>leaving these running for 'a while':
>>>
>>>- while true; do cd ~; sleep 1; for i in {1..3}; do cd /mnt/test/subdir;=
 echo $PWD; sleep 1; cd ..; echo $PWD; sleep 1; done; echo ...; done
>>>- while true; do iptables -F OUTPUT; mount -t cifs -a; for _ in {0..2}; =
do ls /mnt/test/subdir/ | wc -l; done; iptables -I OUTPUT -p tcp --dport 44=
5 -j DROP; sleep 10; echo "unmounting"; umount -l -t cifs -a; echo "done un=
mounting"; sleep 20; echo "recovering"; iptables -F OUTPUT; sleep 10; done
>>>
>>>('a while' is anywhere from 10 minutes to overnight. Also, it's not the
>>>cleanest reproducer, but I stopped iterating once I had something that w=
as
>>>even remotely reliable for me...)
>>>
>>>This series attempts to fix these, as well as a use-after-free that could
>>>occur because open_cached_dir() explicitly frees the cached_fid, rather =
than
>>>relying on reference counting.
>>>
>>>
>>>The last patch in this series (smb: During umount, flush any pending lea=
se
>>>breaks for cached dirs) is a work-in-progress, and should not be taken a=
s-is.
>>>The issue there:
>>>
>>>Unmounting an SMB share (cifs_kill_sb) can race with a queued lease brea=
k from
>>>the server for a cached directory.  When this happens, the cfid is remov=
ed
>>>from the linked list, so close_all_cached_dirs() cannot drop the dentry.=
  If
>>>cifs_kill_sb continues on before the queued work puts the dentry, we tri=
gger
>>>the "Dentry still in use" BUG splat.  Flushing the cifsiod_wq seems to h=
elp
>>>this, but some thoughts:
>>>
>>>1. cifsiod_wq is a global workqueue, rather than per-mount.  Flushing the
>>>   entire workqueue is potentially doing more work that necessary.  Shou=
ld
>>>   there be a workqueue that's more appropriately scoped?
>>>2. With an unresponsive server, this causes umount (even umount -l) to h=
ang
>>>   (waiting for SMB2_close calls), and when I test with backports on a 6=
=2E1
>>>   kernel, appears to cause a deadlock between kill_sb and some cifs
>>>   reconnection code calling iterate_supers_type.  (Pretty sure the dead=
lock
>>>   was addressed by changes to fs/super.c, so not really an SMB problem,=
 but
>>>   just an indication that flush_waitqueue isn't the right solution).
>>>3. Should cached_dir_lease_break() drop the dentry before queueing work
>>>   (and if so, is it OK to do this under the spinlock, or should the spi=
nlock
>>>   be dropped first)?
>>>4. Related to #3 -- shouldn't close_all_cached_dirs() be holding the spi=
nlock
>>>   while looping?
>>>
>>>
>>>Lastly, patches 2, 3, and 5 (in its final form) are beneficial going bac=
k to
>>>v6.1 for stable, but it's not a clean backport because some other import=
ant
>>>fixes (commit 5c86919455c1 ("smb: client: fix use-after-free in
>>>smb2_query_info_compound()") weren't picked up.
>>>
>>>Paul Aurich (5):
>>>  smb: cached directories can be more than root file handle
>>>  smb: Don't leak cfid when reconnect races with open_cached_dir
>>>  smb: prevent use-after-free due to open_cached_dir error paths
>>>  smb: No need to wait for work when cleaning up cached directories
>>>  smb: During umount, flush any pending lease breaks for cached dirs
>>>
>>> fs/smb/client/cached_dir.c | 106 ++++++++++++++++---------------------
>>> 1 file changed, 47 insertions(+), 59 deletions(-)
>>>
>>>--
>>>2.45.2
>>>
>>>
>>
>>
>>--=20
>>Thanks,
>>
>>Steve
>
>
