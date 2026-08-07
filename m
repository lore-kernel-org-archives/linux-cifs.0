Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430D04734F5
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786105321; cv=none; b=nwuehUDq7F00M5ZpD00gnEMxgn0eRrL1lvckQBEa5fA83KxSGhbGjl3js2vtCvbuLZDnNJkaSkTCyzFH7kdUWR6TPGO/pipXTXDunt8ug679dtvbHk1xSnbgQAyk4WBzHT+7yHW1vcNglUyE7kEJuMcFtLiZqfSHxVQw1RUXAYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786105321; c=relaxed/simple;
	bh=DBHrIt3vR0qiB7popMBWRjJyFe6j0VkPsGjCQdZ+fys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A8dYB9mPNcl4TkeO7VcJj//hh2Q1h782MILl7mdV5X/L5E7973hkJ5HrQQzflAuhbainSkgAUYdgpluHOuZyX7PCF3l4XZ4DzMESeCezsCGXTC8/A8dr1PCfExJ8EB+LCXTliklo107+IHrEB+gE1gk4ikcFKi27u6oMfIW5CqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qNs5PkTq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1Fh4x3vf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v2pJG3mw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FELNO0Ow; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qNs5PkTq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1Fh4x3vf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v2pJG3mw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FELNO0Ow"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A4DA805E9;
	Fri,  7 Aug 2026 12:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786105300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjmeVLBbYMlbhqwFgwL4zaiBHOqm1IxwLytr3rwX5Ao=;
	b=qNs5PkTqXwX8bave4us1A2cH3eBnX9uBejU5kyI5xbJPIZxW0qCPWVrGn0I/gHjTJAJbRu
	PMEOpaGx27k6t6olGBQHrglqMRm6iXBktNbEWZ8tbzw3easLz/8DVQ2otaEoDQN5jbZxEO
	GWmDoDBZckkDI42Su45pfryCHjydWKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786105300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjmeVLBbYMlbhqwFgwL4zaiBHOqm1IxwLytr3rwX5Ao=;
	b=1Fh4x3vfMmAccXcolcdQEiAJsvgeNJjr4DvYs/XINN+tvF35ULnhzZtxEQh4ig+AvpNNZa
	QZsxvjZ2u7Em+ZBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v2pJG3mw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FELNO0Ow
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786105296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjmeVLBbYMlbhqwFgwL4zaiBHOqm1IxwLytr3rwX5Ao=;
	b=v2pJG3mwwpKw8RRnvGTqLAGP4IQjq09XCvnBQamSSB8xl9S5EX4yu4sVS3D3n543K4VJGD
	tC8cKsTlPGLXpys5QEr238cfcic/dJRIitKOIZBdItfWaMWBnXVEkfPTsg+nc0z06BZG8b
	qcvcb8iah5+JLHAn29PkletJUx6VBIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786105296;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjmeVLBbYMlbhqwFgwL4zaiBHOqm1IxwLytr3rwX5Ao=;
	b=FELNO0OwHn5kr5ExWOSXn0I2evfhESUdMeCRLtepCC0SaX41VzBwTFZJEyhdI4dfbRkj4O
	LdkpIolWfaLxvGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C39F779B6;
	Fri,  7 Aug 2026 12:21:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SonkA8/NdWrGMwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 07 Aug 2026 12:21:35 +0000
Date: Fri, 7 Aug 2026 09:21:32 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH] smb: client: require CONFIG_CIFS_DEBUG2=y for accounting
 tcon bytes stats
Message-ID: <anXLZxgBXIYcfkTT@suse.de>
References: <20260806190540.332207-1-ematsumiya@suse.de>
 <CAH2r5muNkfU9LyfvKhQjHUqTF-y=GX1BSXMgyVSR9tHoJYHQvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5muNkfU9LyfvKhQjHUqTF-y=GX1BSXMgyVSR9tHoJYHQvQ@mail.gmail.com>
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5A4DA805E9
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,manguebit.org,gmail.com,microsoft.com,talpey.com,suse.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 08/06, Steve French wrote:
>the problem I see with this is that for customer perf issues, it is
>often asked to look at the bytes read and bytes written stats to
>narrow down what is causing the perf issue, which tcon (and thus which
>server share)?

The point is, currently this is a debugging feature that has a perceptible
impact on non-debugging settings, so IMO it should definitely be disabled
by default, regardless of the choice on how to enable it.

That's why I suggested, in private to you, a runtime toggling approach by
writing something to /proc/fs/cifs/Stats to enable this.

>On Thu, Aug 6, 2026 at 2:06=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>>
>> cifs_stats_bytes_{read,written} uses tcon->stat_lock to account for
>> R/W bytes.  This is done unconditionally on every read/write since
>> commit fcabb89299d7 ("cifs: simple stats should always be enabled").
>>
>> On a highly concurrent workload, a spinlock in the middle of the R/W
>> codepaths can become heavily contended, which is absurd given its
>> purpose (protect non-actionable debug/stat data).
>>
>> Make tcon->{bytes_read,bytes_written,stat_lock} usage depend on
>> CONFIG_CIFS_DEBUG2=3Dy.
>>
>> Fixes: fcabb89299d7 ("cifs: simple stats should always be enabled")
>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> ---
>>  fs/smb/client/cifs_debug.c |  4 +++-
>>  fs/smb/client/cifsglob.h   | 24 ++++++++++++++++++++----
>>  fs/smb/client/misc.c       |  2 ++
>>  fs/smb/client/smb1ops.c    | 19 +++++++++++++++----
>>  fs/smb/client/smb2ops.c    |  7 +++++--
>>  5 files changed, 45 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
>> index 4ed4f55a0bb7..3118174745e0 100644
>> --- a/fs/smb/client/cifs_debug.c
>> +++ b/fs/smb/client/cifs_debug.c
>> @@ -762,11 +762,13 @@ static ssize_t cifs_stats_proc_write(struct file *=
file,
>>                                         continue;
>>                                 list_for_each_entry(tcon, &ses->tcon_lis=
t, tcon_list) {
>>                                         atomic_set(&tcon->num_smbs_sent,=
 0);
>> +#ifdef CONFIG_CIFS_DEBUG2
>>                                         spin_lock(&tcon->stat_lock);
>>                                         tcon->bytes_read =3D 0;
>>                                         tcon->bytes_written =3D 0;
>> -                                       tcon->stats_from_time =3D ktime_=
get_real_seconds();
>>                                         spin_unlock(&tcon->stat_lock);
>> +#endif /* CONFIG_CIFS_DEBUG2 */
>> +                                       tcon->stats_from_time =3D ktime_=
get_real_seconds();
>>                                         if (server->ops->clear_stats)
>>                                                 server->ops->clear_stats=
(tcon);
>>                                 }
>> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
>> index 79e4e84f8985..e0e945c1de0f 100644
>> --- a/fs/smb/client/cifsglob.h
>> +++ b/fs/smb/client/cifsglob.h
>> @@ -1240,9 +1240,11 @@ struct cifs_tcon {
>>                         atomic_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS=
];
>>                 } smb2_stats;
>>         } stats;
>> +#ifdef CONFIG_CIFS_DEBUG2
>>         __u64    bytes_read;
>>         __u64    bytes_written;
>>         spinlock_t stat_lock;  /* protects the two fields above */
>> +#endif /* CONFIG_CIFS_DEBUG2 */
>>         time64_t stats_from_time;
>>         FILE_SYSTEM_DEVICE_INFO fsDevInfo;
>>         FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncate=
d */
>> @@ -1655,10 +1657,11 @@ convert_delimiter(char *path, char delim)
>>
>>  #define cifs_stats_inc atomic_inc
>>
>> +#ifdef CONFIG_CIFS_DEBUG2
>>  static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
>>                                             unsigned int bytes)
>>  {
>> -       if (bytes) {
>> +       if (likely(bytes)) {
>>                 spin_lock(&tcon->stat_lock);
>>                 tcon->bytes_written +=3D bytes;
>>                 spin_unlock(&tcon->stat_lock);
>> @@ -1668,10 +1671,23 @@ static inline void cifs_stats_bytes_written(stru=
ct cifs_tcon *tcon,
>>  static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
>>                                          unsigned int bytes)
>>  {
>> -       spin_lock(&tcon->stat_lock);
>> -       tcon->bytes_read +=3D bytes;
>> -       spin_unlock(&tcon->stat_lock);
>> +       if (likely(bytes)) {
>> +               spin_lock(&tcon->stat_lock);
>> +               tcon->bytes_read +=3D bytes;
>> +               spin_unlock(&tcon->stat_lock);
>> +       }
>> +}
>> +#else /* CONFIG_CIFS_DEBUG2 */
>> +static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
>> +                                           unsigned int bytes)
>> +{
>> +}
>> +
>> +static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
>> +                                        unsigned int bytes)
>> +{
>>  }
>> +#endif /* !CONFIG_CIFS_DEBUG2 */
>>
>>
>>  /*
>> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>> index 46e1382e8e04..597dc3c68cd2 100644
>> --- a/fs/smb/client/misc.c
>> +++ b/fs/smb/client/misc.c
>> @@ -145,7 +145,9 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_t=
con_ref_trace trace)
>>         INIT_LIST_HEAD(&ret_buf->tcon_list);
>>         INIT_LIST_HEAD(&ret_buf->cifs_sb_list);
>>         spin_lock_init(&ret_buf->open_file_lock);
>> +#ifdef CONFIG_CIFS_DEBUG2
>>         spin_lock_init(&ret_buf->stat_lock);
>> +#endif /* CONFIG_CIFS_DEBUG2 */
>>         spin_lock_init(&ret_buf->sb_list_lock);
>>         atomic_set(&ret_buf->num_local_opens, 0);
>>         atomic_set(&ret_buf->num_remote_opens, 0);
>> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
>> index dc5a8c1da623..484e12cb9181 100644
>> --- a/fs/smb/client/smb1ops.c
>> +++ b/fs/smb/client/smb1ops.c
>> @@ -817,14 +817,25 @@ cifs_clear_stats(struct cifs_tcon *tcon)
>>  static void
>>  cifs_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
>>  {
>> +       u64 bytes_read =3D 0, bytes_written =3D 0;
>> +
>> +#ifdef CONFIG_CIFS_DEBUG2
>> +       bytes_read =3D tcon->bytes_read;
>> +       bytes_written =3D tcon->bytes_written;
>> +#endif /* CONFIG_CIFS_DEBUG2 */
>> +
>>         seq_printf(m, " Oplocks breaks: %d",
>>                    atomic_read(&tcon->stats.cifs_stats.num_oplock_brks));
>>         seq_printf(m, "\nReads:  %d Bytes: %llu",
>> -                  atomic_read(&tcon->stats.cifs_stats.num_reads),
>> -                  (long long)(tcon->bytes_read));
>> +                  atomic_read(&tcon->stats.cifs_stats.num_reads), bytes=
_read);
>> +#ifndef CONFIG_CIFS_DEBUG2
>> +       seq_puts(m, " (CONFIG_CIFS_DEBUG2 is disabled)");
>> +#endif /* !CONFIG_CIFS_DEBUG2 */
>>         seq_printf(m, "\nWrites: %d Bytes: %llu",
>> -                  atomic_read(&tcon->stats.cifs_stats.num_writes),
>> -                  (long long)(tcon->bytes_written));
>> +                  atomic_read(&tcon->stats.cifs_stats.num_writes), byte=
s_written);
>> +#ifndef CONFIG_CIFS_DEBUG2
>> +       seq_puts(m, " (CONFIG_CIFS_DEBUG2 is disabled)");
>> +#endif /* !CONFIG_CIFS_DEBUG2 */
>>         seq_printf(m, "\nFlushes: %d",
>>                    atomic_read(&tcon->stats.cifs_stats.num_flushes));
>>         seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index 192649fec25d..e1e28f202d0c 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -1425,9 +1425,12 @@ smb2_print_stats(struct seq_file *m, struct cifs_=
tcon *tcon)
>>          *  Can't display SMB2_NEGOTIATE, SESSION_SETUP, LOGOFF, CANCEL =
and ECHO
>>          *  totals (requests sent) since those SMBs are per-session not =
per tcon
>>          */
>> +#ifdef CONFIG_CIFS_DEBUG2
>>         seq_printf(m, "\nBytes read: %llu  Bytes written: %llu",
>> -                  (long long)(tcon->bytes_read),
>> -                  (long long)(tcon->bytes_written));
>> +                  tcon->bytes_read, tcon->bytes_written);
>> +#else /* CONFIG_CIFS_DEBUG2 */
>> +       seq_puts(m, "\nBytes read: 0 Bytes written: 0 (CONFIG_CIFS_DEBUG=
2 is disabled)");
>> +#endif /* !CONFIG_CIFS_DEBUG2 */
>>         seq_printf(m, "\nOpen files: %d total (local), %d open on server=
",
>>                    atomic_read(&tcon->num_local_opens),
>>                    atomic_read(&tcon->num_remote_opens));
>> --
>> 2.55.0
>>
>
>
>--=20
>Thanks,
>
>Steve
>
