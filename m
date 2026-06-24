Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E31380FE6
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 04:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274780; cv=none; b=rM9IA+q4i8G/YoBz89d+wM97tHaWwMgOZpi/WLttBvCOiLsbfnm/H4fOeGvxj7k3EY0Z3AEvfi4l5uF5j64JsgwfG16UgPwuLUBxiulCwEzLhZVntQR89rboM+Xmi8VA8OFfTiKe5mHKaRpVMdW8oB7xCuHB3sljNkkNuGbThg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274780; c=relaxed/simple;
	bh=a1BpRUvRRHZcyHMokHRMQWKUTAXfdB+PTDCOhoqnr3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgCfMh2rWzGBf/g1Q+iewymIVkCJhIzJ74ClsVe9ocaopljsdLQIBw/UPXjbSdjZ+aeTEKQghkDGp5hQ9gZFIl1qJcz9STAfNWPB0POFgli0WUF1OhTpziXDe33Zl8VAwZLGHiS6a9nF5x6ipF7DUmt2PV0t1wlks4+gWDXNPhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xCKTf3AZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DoW/Z4HN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AFVXWgGH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AD1xUmmk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xCKTf3AZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DoW/Z4HN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AFVXWgGH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AD1xUmmk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 188A175ACF;
	Wed, 24 Jun 2026 04:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782274777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G4FlaV64mpntM+HtCshUBPAgH6DDo0xOCmu9NHjd3Gg=;
	b=xCKTf3AZFkjGua5DG2f2TjTdlwxR09wstu5QzyDjGu1DJ2akX7/mQJiOiUhIzhL+BLwtq9
	K7keFQHoWO/g4CoONZ/nbmi5YuQOnJ3Dd13iYRHnUC0VAJzpcHLraF+vPX0R2DsuoZJFrK
	ftkHKZDSCdeLzlRC3duSTv2fCS+WqyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782274777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G4FlaV64mpntM+HtCshUBPAgH6DDo0xOCmu9NHjd3Gg=;
	b=DoW/Z4HNhrOM4dIJIynBTcC3lWmM8j1/aC7IwznZ5hLP6d7J56V3usLXjgtCYJdNjsJNrs
	v1y2G/0YxPY6feCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782274776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G4FlaV64mpntM+HtCshUBPAgH6DDo0xOCmu9NHjd3Gg=;
	b=AFVXWgGHm9hXx5neauwS8XY4PNoE/S2+rKru9j/5hdUekBVz2Hu+wfIl5NW3FXkPFrexcM
	xjXfhwJRf0vgeZ5ppUy0wzlxTiZ/mM9GvYwsNvhokXyMdqZIVH3N+U3Q87HQJoKHy8Nh9D
	vvlaaMZ+Vjx8oEem4TF3yJH24dxhm0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782274776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G4FlaV64mpntM+HtCshUBPAgH6DDo0xOCmu9NHjd3Gg=;
	b=AD1xUmmkQy3oFszxQGXiuaEbgksrUtTbY8p1jmm1WHW7MC4V7nTp3tioNOzJvreeKBG2VK
	s8zHciYORqeWUyCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98386779AB;
	Wed, 24 Jun 2026 04:19:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zhx8F9daO2ouOwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 24 Jun 2026 04:19:35 +0000
Date: Wed, 24 Jun 2026 01:19:25 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Chunjie Zhu <chunjie.zhu@citrix.com>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <lsahlber@redhat.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix smb client defer close causes file corruption
Message-ID: <ajtavBgQP79ajERS@suse.de>
References: <20260622091450.2668504-1-chunjie.zhu@citrix.com>
 <CAH2r5mu7sdqJ4NJQzsqhY+3LmHE7AcREM9nYAbEZCNZ08yEafA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mu7sdqJ4NJQzsqhY+3LmHE7AcREM9nYAbEZCNZ08yEafA@mail.gmail.com>
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
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[citrix.com:email,imap1.dmz-prg2.suse.org:helo,vhd.new:url,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 06/23, Steve French wrote:
>Do you see different behavior of this to different servers (Samba,
>Windows, ksmbd, Azure xSMB etc)?
>
>Disabling deferred close carries metadata integrity issues because it
>will lead users to set actimeo (or acregmax) to higher values, and
>disabling deferred close could significantly hurt performance for some
>common workload patterns (open/write/close/open/read/close e.g.)
>
>Other narrower client fixes for this presumably could be done, e.g.
>forcing close on the deferred close when rename a hardlink.

That looks like a safe measure to have IMO.


Cheers,

Enzo

>On Mon, Jun 22, 2026 at 4:40=E2=80=AFAM Chunjie Zhu <chunjie.zhu@citrix.co=
m> wrote:
>>
>> Test environment
>>
>>  4 hosts as smb client, 1 host as smb server
>>  smb client hosts, kernel 6.6.138
>>  mount options,
>>   //10.70.48.15/xxx /run/xxx cifs rw,relatime,vers=3D3.0,
>>   cache=3Dloose,username=3Dxxx,domain=3Dxxx,uid=3D0,noforceuid,
>>   gid=3D0,noforcegid,addr=3D10.70.48.15,file_mode=3D0755,
>>   dir_mode=3D0755,soft,nounix,serverino,mapposix,reparse=3Dnfs,
>>   rsize=3D1048576,wsize=3D1048576,bsize=3D1048576,echo_interval=3D60,
>>   actimeo=3D0,closetimeo=3D1
>>
>> Work around
>>
>>  mount with cache=3Dnone or closetimeo=3D0
>>
>> The Race Condition Flow
>>
>>  Step 1: Host-01 closes file
>>
>>   Host-01:
>>    file close (eeefe8d0.vhd)
>>    -> CIFS defers SMB2 CLOSE
>>    -> Handle H1 stored in deferred_closes list
>>    -> Lease L1 (RWH or RH) still active on server
>>    -> Entry: { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=
=3DI1 }
>>
>>  Step 2: Host-02 does hardlink and rename
>>
>>   Host-02:
>>    hardlink(eeefe8d0.vhd, 0f11b74e.vhd)
>>    -> SMB2: Creates new name for same inode
>>    -> Server: inode I1 now has 2 names (link count =3D 2)
>>    -> Host-01 lease L1: NO BREAK (same inode, just added name)
>>
>>    crate(eeefe8d0.vhd.new)
>>    -> Entry { path=3D"eeefe8d0.vhd.new", handle=3DH2, inode=3DI2 }
>>
>>    rename(eeefe8d0.vhd.new, eeefe8d0.vhd)
>>    -> SMB2: Replaces =E2=80=9Ceeefe8d0.vhd=E2=80=9D name =E2=86=92 point=
s to new inode I2
>>    -> Server: old inode I1 now only accessible as =E2=80=9C0f11b74e.vhd=
=E2=80=9D
>>    -> Server SHOULD send: Lease Break notification to H1 =E2=86=90 KEY!
>>
>>  Step 3: Lease break delivery is not reliable
>>
>>   strict locking off, level2 oplock
>>
>>    Host-01:
>>    -> Lease break not received or processed
>>    -> H1 is in deferred_closes list (not "active")
>>
>>    Result: Stale entry remains:
>>       { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=3DI1_O=
LD }
>>
>>    Host-02:
>>    -> Open 0f11b74e.vhd in readonly
>>
>>    Result:
>>       { path=3D"0f11b74e.vhd", inode=3DI1_NEW }
>>
>>  Step 4: Host-01 reopens file
>>
>>   Host-01:
>>    file open (eeefe8d0.vhd)
>>    -> Kernel checks deferred_closes for =E2=80=9Ceeefe8d0.vhd=E2=80=9D
>>    -> Found H1! (matched by pathname string)
>>    -> REUSES H1 without checking
>>    -> close or reconnect, flush buffered writes
>>       slient corruption?
>>
>> Signed-off-by: Chunjie Zhu <chunjie.zhu@citrix.com>
>> ---
>>  fs/smb/client/fs_context.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>> index 0812af001417..4ed33de0a00d 100644
>> --- a/fs/smb/client/fs_context.c
>> +++ b/fs/smb/client/fs_context.c
>> @@ -1300,11 +1300,11 @@ static int smb3_fs_context_parse_param(struct fs=
_context *fc,
>>                 ctx->acdirmax =3D ctx->acregmax =3D HZ * result.uint_32;
>>                 break;
>>         case Opt_closetimeo:
>> -               if (result.uint_32 > SMB3_MAX_DCLOSETIMEO / HZ) {
>> -                       cifs_errorf(fc, "closetimeo too large\n");
>> +               if (result.uint_32 !=3D 0) {
>> +                       cifs_errorf(fc, "closetimeo must be 0, deferred =
close is disabled\n");
>>                         goto cifs_parse_mount_err;
>>                 }
>> -               ctx->closetimeo =3D HZ * result.uint_32;
>> +               ctx->closetimeo =3D 0;
>>                 break;
>>         case Opt_echo_interval:
>>                 if (result.uint_32 < SMB_ECHO_INTERVAL_MIN ||
>> @@ -1795,7 +1795,7 @@ int smb3_init_fs_context(struct fs_context *fc)
>>
>>         ctx->acregmax =3D CIFS_DEF_ACTIMEO;
>>         ctx->acdirmax =3D CIFS_DEF_ACTIMEO;
>> -       ctx->closetimeo =3D SMB3_DEF_DCLOSETIMEO;
>> +       ctx->closetimeo =3D 0;
>>         ctx->max_cached_dirs =3D MAX_CACHED_FIDS;
>>         /* Most clients set timeout to 0, allows server to use its defau=
lt */
>>         ctx->handle_timeout =3D 0; /* See MS-SMB2 spec section 2.2.14.2.=
12 */
>> --
>> 2.52.0
>>
>>
>
>
>--=20
>Thanks,
>
>Steve
>
