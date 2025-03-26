Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5C625EFAE
	for <linux-cifs@vger.kernel.org>; Wed, 26 Mar 2025 21:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743023592; cv=none; b=Vr/V8RNxm4MpTVEIGYHSbxDllYte1R4+QBAcl34QtklVsq0nNlopmtUsZCSqa1O8/QnthIpYNimv8EqfI8t1jB87u27tjpvCx70SSvMhpPoLThdJQDYpvAomOQ5HuLwBVDe7+6bfQOIM8pJYxEKu4yOjlsKfKQKwHB9h8A+nqAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743023592; c=relaxed/simple;
	bh=LnjPLJr6Wk/AsszqGK+kqhPTldzYfx38sU9ApEmdsf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ik5wliR2p+QSL57OgX3xZTV+ebwINE+woWdznXYiAZ6bpIVqGwf1KgVb5Vt258WeCn3Lbklnh5Ziw6SsUIW8TmmAyekn+oC9qiYCBxOcIZjqvxjakRh4IGmQNriAPsizz8VewDKoCGfad5wxvNCwD4rpRCOEK4y5Pbt5j67hGK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=M96pAzD4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kyLmyF+A; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zw1uqds/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JJpNAX74; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="M96pAzD4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kyLmyF+A";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zw1uqds/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JJpNAX74"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E37021F391;
	Wed, 26 Mar 2025 21:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743023588; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0b6Qq1pz4JRK5PlMlVC2l+Cq5Qoz+kTOivR4+JV84Q=;
	b=M96pAzD4g//DoIoACcUeIrXV8p1CHgzN71BKT2vZiyQdxW1a/+iMRozpyda2yg1ITJjw1k
	4Se5X+zio7DYTQ4Zj99m5QtNykG1y3mXN0bWVr4+dVovg8rIJFOH/y/oE7Gzkym394pNrS
	VMkye10BNOtKpAj1Sby5cMzAjBbswIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743023588;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0b6Qq1pz4JRK5PlMlVC2l+Cq5Qoz+kTOivR4+JV84Q=;
	b=kyLmyF+AAjBxDG+CrkuBcpaoYUNsWBZfCIIVfZte9NfLug2OIfu6IqCy15jtK5ad+MYr7w
	w3TW+V8XK1xXcLBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743023587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0b6Qq1pz4JRK5PlMlVC2l+Cq5Qoz+kTOivR4+JV84Q=;
	b=zw1uqds/SlkYQTaWOFmCgi+pqlxK4SHs7bnaSnbeNmXtzZmeeF8+cZayA+wZ2AapZP/a00
	LiwXVXLOkt/HSaoRYS5n2AR0rrXFhF6nagojqHHDFglByOda762geZwr5ux+N5N3Nfbmdm
	uh87tNqvkZ2QdXOPPFxEpiWZA5rFoLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743023587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0b6Qq1pz4JRK5PlMlVC2l+Cq5Qoz+kTOivR4+JV84Q=;
	b=JJpNAX74ULUrdRkPRfuMNK7xZagG7P6Qhu1Dy7YTnN/30SqQO9twmYsa+3NJgXwElcBY0N
	bhszxHg7YpIKGfAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E78D13927;
	Wed, 26 Mar 2025 21:13:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pU5TDuNt5GdWQQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 26 Mar 2025 21:13:07 +0000
Date: Wed, 26 Mar 2025 18:13:05 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: "Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	Mark A Whiting <whitingm@opentext.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	henrique.carvalho@suse.com
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Message-ID: <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
 <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Hello,

On 03/26, Steve French wrote:
>Were you able to confirm that the problem started after 6.6.0 but
>regressed before 6.6.9 - any chance of narrowing the regression down
>by bisection?

This looks similar to a bug we found in our v6.4-based SLES products.

Bisecting it indicated the regression is
d08089f649a0 "cifs: Change the I/O paths to use an iterator rather than a p=
age list".

The first good commit we found is a395726cf823 "cifs: fix data
corruption in read after invalidate", but it was probably a bit before
that (we didn't check further because we couldn't afford to backport all
netfs modifications).

This is the fix we used (rebased on top of v6.6.71 tag):
https://git.exis.tech/linux.git/commit/?h=3Ddata_corruption_v6.x&id=3D8d4c4=
0e084f3d132434d5d3d068175c8db59ce65

@Ilja @Mark could you test it with your reproducer please?
@Steve can you try it with the reproducer mentioned in the commit
message please?


Cheers,

Enzo

>On Wed, Mar 26, 2025 at 5:13=E2=80=AFAM Heckmann, Ilja <heckmann@izw-berli=
n.de> wrote:
>>
>> We ran into what probably is the same problem with silent data corruptio=
n that was only noticed thanks to using a data format with internal checksu=
ms. It also went away when mounting a share with "cache=3Dnone" while runni=
ng the kernel 6.6.9, but that had the side-effect that no executables could=
 be started from the share (I reported this in June 2024). This second prob=
lem was fixed in 6.10, but at the same time mounting with "cache=3Dnone" st=
opped helping against the data corruption issue. It persists until now, wit=
h kernel 6.12.8, although the frequency at which the problem manifests went=
 down significantly.
>>
>> The way we test for it is by running a certain workload 100 times in a l=
oop and counting the number of runs aborted because of errors. That number =
went down from about 10 per 100 runs with kernel 6.6.9 to about 1 per 100 r=
uns with 6.12.8. Its non-deterministic nature and the lack of in-house expe=
rtise to investigate the issue at the same level as Mark did stopped us fro=
m reporting it so far. And while there is no way of knowing that the issue =
we observe in 6.12.8 is the same one, at least I can confirm that there is =
a similar issue in more recent kernel versions as well.
>>
>> Best wishes,
>> Ilja Heckmann
>> ________________________________________
>> Von: Mark A Whiting <whitingm@opentext.com>
>> Gesendet: Dienstag, 25. M=C3=A4rz 2025 22:24:55
>> An: linux-cifs@vger.kernel.org
>> Betreff: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing, x=
86_64, kernel 6.6.71
>>
>> Hello,
>>
>> I have discovered a data corruption issue with our application writing t=
o a CIFS share. I believe this issue may be related to another report I saw=
 on this mailing list, https://lore.kernel.org/linux-cifs/DFC1DAC5-5C6C-4DC=
2-807A-DAF12E4B7882@gmail.com/. I understand that updating to a newer kerne=
l would likely fix this issue. However, at the moment, that's not an option=
 for us. In the long term we are looking to upgrade to 6.12 but I'm hoping =
to find a solution for our current 6.6 kernel.
>>
>> I have tested mounting with the "cache=3Dnone" option and that solves th=
e problem, albeit with a very large performance hit.
>>
>> The platform is an embedded system. We're using an off-the-shelf COM Exp=
ress Type 7 module with an Intel XEON D-1713NT processor. We're running a c=
ustom Linux system built using Buildroot, currently running the 6.6.71 kern=
el. I've tested the latest 6.6.84 kernel and the problem still exists there=
=2E Our application is writing large amounts of compressed data (4+ GB) to =
the network share. When I read back the data to verify it, I'm seeing small=
 portions of the file that have been replaced with zeros.
>>
>> I've attacked the issue from several angles. Starting with a TCP dump of=
 a complete operation from mounting, data transfer, to unmounting the netwo=
rk share. Through Wireshark I can see that there is no write command to the=
 server covering the sections of the output that ends up as zeros. This ind=
icated to me that the CIFS kernel driver is failing to write out portions o=
f the file.
>>
>> I then enabled all the CIFS debug info I could via cifsFYI and the kerne=
l dynamic debug controls and tweaked the code to not rate limit the pr_debu=
g calls. I could trace through the resulting logs and find pairs of cifs_wr=
ite_begin() / cifs_write_end() that covered all the data including the sect=
ions that ultimately don't get written out. However, tracing through the sm=
b2_async_writev() messages I again could not find any writes that covered t=
he corrupt portions. At this point I began to suspect some kind of race con=
dition within the cifs_writepages() function.
>>
>> I also analyzed the data corruption and noticed a pattern. It does not f=
ail 100% of the time, and it does not always fail in the same place. This f=
urthered my belief that it was some kind of non-deterministic data race. Th=
e corrupt data region is always less than a page in size (<4096 bytes), it'=
s always zeros, and it always ends on a page boundary. Because I knew the e=
xpected format of the data, I could also tell that the corrupt data was alw=
ays at the beginning of a write syscall by our application.
>>
>> I've attempted to read through the CIFS kernel code involved in this. Bu=
t I've never worked in the VFS/filesystem layers before. And I'm having tro=
uble following / understanding the intricacies of the page cache, page dirt=
ying/cleaning, and writeback.
>>
>> My current best guess at what's happening is as follows:
>>     * Our application writes out a buffer of data to the file on a CIFS =
share, this is compressed data that isn't nicely aligned, the data does not=
 end on a page boundary. This is a newly created file that we are writing t=
o, so this write extends the files EOF to the end of the newly written data=
 which is in the middle of a page in the cache.
>>     * cifs_writepages() is invoked to write the cached data back to the =
server, it scans the cached pages and prepares to write out all the dirty p=
ages (including the final partial page).
>>     * Our application performs another write. This extends the file and =
the beginning of this write falls into the end of the previous final partia=
l cached page.
>>     * cifs_writepages() finishes writing out the dirty pages, including =
the first portion of what it thought was the final partial page, and marks =
all pages as clean.
>>     * On the next invocation of cifs_writepages(), it scans for dirty pa=
ges and skips the beginning of the second write because it thinks that page=
 is clean. The following page is a completely new page and is dirty, so it =
starts a new write from that page. This would explain why the corruption is=
 always at the beginning of our application's write and corrects itself at =
the next page boundary.
>>
>> I have yet to really prove this, but this type of race between dirty/cle=
an pages would explain all the behavior I'm seeing. I'm hoping someone much=
 more intimately familiar with the CIFS code can help point me in the right=
 direction.
>>
>> I did try one quick and dirty fix, assuming it was a race I applied the =
following patch. This added a per inode mutex that completely serialized th=
e cifs_write_begin(), cifs_write_end(), and cifs_writepages() functions. Th=
is did seem to resolve the data corruption issue, but at the cost of occasi=
onal deadlocks writing to CIFS files.
>>
>> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>> > index bbb0ef18d7b8..6e2e273b9838 100644
>> > --- a/fs/smb/client/cifsfs.c
>> > +++ b/fs/smb/client/cifsfs.c
>> > @@ -1659,6 +1659,7 @@ cifs_init_once(void *inode)
>> >
>> >       inode_init_once(&cifsi->netfs.inode);
>> >       init_rwsem(&cifsi->lock_sem);
>> > +     mutex_init(&cifsi->tbl_write_mutex);
>>  > }
>>  >
>> >  static int __init
>> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
>> > index 43b42eca6780..4af4c5036d81 100644
>> > --- a/fs/smb/client/cifsglob.h
>> > +++ b/fs/smb/client/cifsglob.h
>> > @@ -1606,6 +1606,17 @@ struct cifsInodeInfo {
>> >       bool lease_granted; /* Flag to indicate whether lease or oplock =
is granted. */
>> >       char *symlink_target;
>> >       __u32 reparse_tag;
>> > +
>> > +     /* During development we discovered what we believe to be a race=
 condition
>> > +      * in the write caching behavior of cifs. Setting cache=3Dnone s=
olved the
>> > +      * issue but with an unacceptable performance hit. The following=
 mutex was
>> > +      * added to serialize the cifs_write_begin, cifs_write_end, and
>> > +      * cifs_writepages functions in file.c. This appears to solve th=
e issue
>> > +      * without completely disabling caching.
>> > +      *
>> > +      * -Mark Whiting (whitingm@opentext.com)
>> > +      */
>> > +     struct mutex tbl_write_mutex;
>> >  };
>> >
>> >  static inline struct cifsInodeInfo *
>> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>> > index cb75b95efb70..d3bc652a7e65 100644
>> > --- a/fs/smb/client/file.c
>> > +++ b/fs/smb/client/file.c
>> > @@ -3085,6 +3085,7 @@ static int cifs_writepages(struct address_space =
*mapping,
>> >  {
>> >       loff_t start, end;
>> >       int ret;
>> > +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
>> >
>> >       /* We have to be careful as we can end up racing with setattr()
>> >        * truncating the pagecache since the caller doesn't take a lock=
 here
>> > @@ -3119,6 +3120,7 @@ static int cifs_writepages(struct address_space =
*mapping,
>> >       }
>> >
>> >  out:
>> > +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>> >       return ret;
>> >  }
>> >
>> > @@ -3174,6 +3176,8 @@ static int cifs_write_end(struct file *file, str=
uct address_space *mapping,
>> >       struct folio *folio =3D page_folio(page);
>> >       __u32 pid;
>> >
>> > +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
>> > +
>> >       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>> >               pid =3D cfile->pid;
>> >       else
>> > @@ -3233,6 +3237,7 @@ static int cifs_write_end(struct file *file, str=
uct address_space *mapping,
>> >       /* Indication to update ctime and mtime as close is deferred */
>> >       set_bit(CIFS_INO_MODIFIED_ATTR, &CIFS_I(inode)->flags);
>> >
>> > +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>> >       return rc;
>> >  }
>> >
>> > @@ -4905,6 +4910,7 @@ static int cifs_write_begin(struct file *file, s=
truct address_space *mapping,
>> >       int rc =3D 0;
>> >
>> >       cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, =
len);
>> > +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
>> >
>> >  start:
>> >       page =3D grab_cache_page_write_begin(mapping, index);
>> > @@ -4965,6 +4971,7 @@ static int cifs_write_begin(struct file *file, s=
truct address_space *mapping,
>> >                  this will be written out by write_end so is fine */
>> >       }
>> >  out:
>> > +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>> >       *pagep =3D page;
>> >       return rc;
>> >  }
>>
>> Here are some of the log excerpts for one of my test cases. In this file=
 one of the corrupt regions starts at file offset 1,074,214,474 (0x4007364A=
), and was corrupt for 2,486 bytes, ending on a page boundary. First there =
is a section of the log trimmed to just the cifs_write_begin() / cifs_write=
_end() functions. You can see that there is a write shown at the exact offs=
et/length of the corrupted data.
>>
>> > Mar 25 15:25:39 TX2 kernel: [  124.080900] [1567] cifs_write_begin:490=
7: CIFS: fs/smb/client/file.c: write_begin from 1074212864 len 1610
>> > Mar 25 15:25:39 TX2 kernel: [  124.080906] [1567] cifs_write_end:3182:=
 CIFS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 1=
074212864 with 1610 bytes
>> > Mar 25 15:25:39 TX2 kernel: [  124.080911] [1567] cifs_write_begin:490=
7: CIFS: fs/smb/client/file.c: write_begin from 1074214474 len 2486
>> > Mar 25 15:25:39 TX2 kernel: [  124.080916] [1567] cifs_write_end:3182:=
 CIFS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 1=
074214474 with 2486 bytes
>> > Mar 25 15:25:39 TX2 kernel: [  124.080917] [1567] cifs_write_begin:490=
7: CIFS: fs/smb/client/file.c: write_begin from 1074216960 len 846
>> > Mar 25 15:25:39 TX2 kernel: [  124.080924] [1567] cifs_write_end:3182:=
 CIFS: fs/smb/client/file.c: write_end for page 00000000880cee03 from pos 1=
074216960 with 846 bytes
>>
>> Now here's a section of the log trimmed to just the smb2_async_writev() =
function. You can see writes covering the data immediately before and after=
 the corrupted region, but there is no write to the corrupted region. I'm a=
ssuming the corrupted region is always zeros because the server is extendin=
g and zero-filling the file to the new write offset after the gap of the mi=
ssing write.
>>
>> > Mar 25 15:25:39 TX2 kernel: [  123.829696] [1635] smb2_async_writev:49=
45: CIFS: fs/smb/client/smb2pdu.c: async write at 1072214016 988260 bytes i=
ter=3Df1464
>> > Mar 25 15:25:39 TX2 kernel: [  124.081016] [1636] smb2_async_writev:49=
45: CIFS: fs/smb/client/smb2pdu.c: async write at 1073201152 1013322 bytes =
iter=3Df764a
>> ** Missing write: 1073201152 + 1013322 =3D 1074214474 **
>> > Mar 25 15:25:39 TX2 kernel: [  124.083901] [1636] smb2_async_writev:49=
45: CIFS: fs/smb/client/smb2pdu.c: async write at 1074216960 39564 bytes it=
er=3D9a8c
>> > Mar 25 15:25:40 TX2 kernel: [  124.340557] [1637] smb2_async_writev:49=
45: CIFS: fs/smb/client/smb2pdu.c: async write at 1074253824 1237843 bytes =
iter=3D12e353
>>
>> I can very easily reproduce this with our application. If anyone has any=
 suggestions to try, additional logging / tracing they would like me to per=
form, please let me know. I can provide more detailed, full logs if desired=
, but they're quite large. I'll continue to read through the code and try t=
o understand, if I find anything I will update you.
>>
>> Thanks,
>> Mark Whiting
>>
>>
>
>
>--=20
>Thanks,
>
>Steve
>
