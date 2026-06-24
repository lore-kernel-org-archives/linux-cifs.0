Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBF4257844
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 04:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274725; cv=none; b=cu3zSAp5a2DpLTQZ2LHQ8ilS3WwnNaqUF51quUjvcsGLDX/5dBzIt3x04LzBQPiX9nbW/TyMhzT33OpKecpGyv/dWvRHvc8S15ff5KWy5fhEIy71O2hhz17caZ2jNWg3MJ0+P0LBs5Dh7fYByDK6GQbiUapqtVZwhydm37ercXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274725; c=relaxed/simple;
	bh=Ln3f4jHbRjgqIAFjnX3GV4s3yW8BgfoR2Rz/fEXucKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehX9CQNt/yI40KB2knQI5R2uF6EtB5kB6ZEsFap0bq8ROUwMK32b3Z7J5INkY4ZLutSBm2wVibEuZZgiEcBUDy+HJwcassbU+ACZ+rUODYTelRJg2+qPz2WqRT6zlkaCrhOZPrwQBEOnUiMNeNYvwQipTrDN5SpJ/lSboRSkCBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NArCLdS4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SuhzLGnR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NArCLdS4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SuhzLGnR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NArCLdS4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SuhzLGnR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NArCLdS4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SuhzLGnR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 27270711D9;
	Wed, 24 Jun 2026 04:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782274722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FCE4KNoj1QlHduUNv2zHIzC3ljmJTeCJqSylxMX75G8=;
	b=NArCLdS4GNbe/Tc8YEHrl32CCbnGMcdOMg61GufgzM9zoQhEdWWYMI2po6beUwC661T4YH
	Z9DTe03xQQmI5Tv5hqdnPN5hqRyz7nGnevAW0PxpQQy8w7ssSgQWD3yhxVvMxIQhRROBZq
	rjZL9zLe9POFub3ojbBfAm9i7jvKE9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782274722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FCE4KNoj1QlHduUNv2zHIzC3ljmJTeCJqSylxMX75G8=;
	b=SuhzLGnRiwfl3vg0vAAu6dJxxOeGNYDMm7rdKSSENFhArWtTCYKGERHXNcI97HgLt8lTIY
	aOLafKjDhmtDKdCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782274722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FCE4KNoj1QlHduUNv2zHIzC3ljmJTeCJqSylxMX75G8=;
	b=NArCLdS4GNbe/Tc8YEHrl32CCbnGMcdOMg61GufgzM9zoQhEdWWYMI2po6beUwC661T4YH
	Z9DTe03xQQmI5Tv5hqdnPN5hqRyz7nGnevAW0PxpQQy8w7ssSgQWD3yhxVvMxIQhRROBZq
	rjZL9zLe9POFub3ojbBfAm9i7jvKE9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782274722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FCE4KNoj1QlHduUNv2zHIzC3ljmJTeCJqSylxMX75G8=;
	b=SuhzLGnRiwfl3vg0vAAu6dJxxOeGNYDMm7rdKSSENFhArWtTCYKGERHXNcI97HgLt8lTIY
	aOLafKjDhmtDKdCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4C3E779AB;
	Wed, 24 Jun 2026 04:18:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Xoj+GqFaO2pqOgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 24 Jun 2026 04:18:41 +0000
Date: Wed, 24 Jun 2026 01:18:39 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Chunjie Zhu <chunjie.zhu@citrix.com>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lsahlber@redhat.com, pc@manguebit.com, 
	samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com, tom@talpey.com
Subject: Re: Subject: Re: [PATCH] fix smb client defer close causes file
 corruption
Message-ID: <ajtYUL_7qdzu21mx@suse.de>
References: <CAH2r5mu7sdqJ4NJQzsqhY+3LmHE7AcREM9nYAbEZCNZ08yEafA@mail.gmail.com>
 <20260624034414.5087-1-chunjie.zhu@citrix.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260624034414.5087-1-chunjie.zhu@citrix.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,redhat.com,manguebit.com,lists.samba.org,samba.org,microsoft.com,talpey.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 06/24, Chunjie Zhu wrote:
>From my experience, these common workloads tend to occur within a single
>process. Therefore, it might be worth optimizing cifs_get_readable_path
>by extending its matching logic: instead of matching only the file path,
>we could also check the process PID. The old handler would then be reused
>only when both the file path and the PID match.
>
>Do you think this approach is viable?

I don't think this is a good idea; PIDs change and are naturally made to
be reused as well, so storing PID for a 'later' (no matter how later)
check is 100% unreliable.

As for the original bug report, do you happen to have a simple
reproducer?

I created one on top of your instructions and I'm definitely getting a
lease break on rename, which IIUC is the alleged root cause.
This was with closetimeo=30 on a Windows Server 2022 share.

Also, I'm failing to understand how cache= has any impact on this -- I
get the same successful results with none,loose,strict.


Cheers,

Enzo

>> Other narrower client fixes for this presumably could be done, e.g.
>> forcing close on the deferred close when rename a hardlink.
>>
>> On Mon, Jun 22, 2026 at 4:40=E2=80=AFAM Chunjie Zhu <chunjie.zhu@citrix.com=
>> > wrote:
>> >
>> > Test environment
>> >
>> >  4 hosts as smb client, 1 host as smb server
>> >  smb client hosts, kernel 6.6.138
>> >  mount options,
>> >   //10.70.48.15/xxx /run/xxx cifs rw,relatime,vers=3D3.0,
>> >   cache=3Dloose,username=3Dxxx,domain=3Dxxx,uid=3D0,noforceuid,
>> >   gid=3D0,noforcegid,addr=3D10.70.48.15,file_mode=3D0755,
>> >   dir_mode=3D0755,soft,nounix,serverino,mapposix,reparse=3Dnfs,
>> >   rsize=3D1048576,wsize=3D1048576,bsize=3D1048576,echo_interval=3D60,
>> >   actimeo=3D0,closetimeo=3D1
>> >
>> > Work around
>> >
>> >  mount with cache=3Dnone or closetimeo=3D0
>> >
>> > The Race Condition Flow
>> >
>> >  Step 1: Host-01 closes file
>> >
>> >   Host-01:
>> >    file close (eeefe8d0.vhd)
>> >    -> CIFS defers SMB2 CLOSE
>> >    -> Handle H1 stored in deferred_closes list
>> >    -> Lease L1 (RWH or RH) still active on server
>> >    -> Entry: { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=
>> =3DI1 }
>> >
>> >  Step 2: Host-02 does hardlink and rename
>> >
>> >   Host-02:
>> >    hardlink(eeefe8d0.vhd, 0f11b74e.vhd)
>> >    -> SMB2: Creates new name for same inode
>> >    -> Server: inode I1 now has 2 names (link count =3D 2)
>> >    -> Host-01 lease L1: NO BREAK (same inode, just added name)
>> >
>> >    crate(eeefe8d0.vhd.new)
>> >    -> Entry { path=3D"eeefe8d0.vhd.new", handle=3DH2, inode=3DI2 }
>> >
>> >    rename(eeefe8d0.vhd.new, eeefe8d0.vhd)
>> >    -> SMB2: Replaces =E2=80=9Ceeefe8d0.vhd=E2=80=9D name =E2=86=92 points=
>>  to new inode I2
>> >    -> Server: old inode I1 now only accessible as =E2=80=9C0f11b74e.vhd=
>> =E2=80=9D
>> >    -> Server SHOULD send: Lease Break notification to H1 =E2=86=90 KEY!
>> >
>> >  Step 3: Lease break delivery is not reliable
>> >
>> >   strict locking off, level2 oplock
>> >
>> >    Host-01:
>> >    -> Lease break not received or processed
>> >    -> H1 is in deferred_closes list (not "active")
>> >
>> >    Result: Stale entry remains:
>> >       { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=3DI1_OL=
>> D }
>> >
>> >    Host-02:
>> >    -> Open 0f11b74e.vhd in readonly
>> >
>> >    Result:
>> >       { path=3D"0f11b74e.vhd", inode=3DI1_NEW }
>> >
>> >  Step 4: Host-01 reopens file
>> >
>> >   Host-01:
>> >    file open (eeefe8d0.vhd)
>> >    -> Kernel checks deferred_closes for =E2=80=9Ceeefe8d0.vhd=E2=80=9D
>> >    -> Found H1! (matched by pathname string)
>> >    -> REUSES H1 without checking
>> >    -> close or reconnect, flush buffered writes
>> >       slient corruption?
>> >
>> > Signed-off-by: Chunjie Zhu <chunjie.zhu@citrix.com>
>> > ---
>> >  fs/smb/client/fs_context.c | 8 ++++----
>> >  1 file changed, 4 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>> > index 0812af001417..4ed33de0a00d 100644
>> > --- a/fs/smb/client/fs_context.c
>> > +++ b/fs/smb/client/fs_context.c
>> > @@ -1300,11 +1300,11 @@ static int smb3_fs_context_parse_param(struct fs_=
>> context *fc,
>> >                 ctx->acdirmax =3D ctx->acregmax =3D HZ * result.uint_32;
>> >                 break;
>> >         case Opt_closetimeo:
>> > -               if (result.uint_32 > SMB3_MAX_DCLOSETIMEO / HZ) {
>> > -                       cifs_errorf(fc, "closetimeo too large\n");
>> > +               if (result.uint_32 !=3D 0) {
>> > +                       cifs_errorf(fc, "closetimeo must be 0, deferred c=
>> lose is disabled\n");
>> >                         goto cifs_parse_mount_err;
>> >                 }
>> > -               ctx->closetimeo =3D HZ * result.uint_32;
>> > +               ctx->closetimeo =3D 0;
>> >                 break;
>> >         case Opt_echo_interval:
>> >                 if (result.uint_32 < SMB_ECHO_INTERVAL_MIN ||
>> > @@ -1795,7 +1795,7 @@ int smb3_init_fs_context(struct fs_context *fc)
>> >
>> >         ctx->acregmax =3D CIFS_DEF_ACTIMEO;
>> >         ctx->acdirmax =3D CIFS_DEF_ACTIMEO;
>> > -       ctx->closetimeo =3D SMB3_DEF_DCLOSETIMEO;
>> > +       ctx->closetimeo =3D 0;
>> >         ctx->max_cached_dirs =3D MAX_CACHED_FIDS;
>> >         /* Most clients set timeout to 0, allows server to use its defaul=
>> t */
>> >         ctx->handle_timeout =3D 0; /* See MS-SMB2 spec section 2.2.14.2.1=
>> 2 */
>> > --
>> > 2.52.0
>> >
>> >
>>
>>
>> --=20
>> Thanks,
>>
>> Steve
>>
>
