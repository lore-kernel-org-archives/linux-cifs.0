Received: from eproxy.izw-berlin.de (eproxy.izw-berlin.de [62.141.164.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC701B393A
	for <linux-cifs@vger.kernel.org>; Wed, 26 Mar 2025 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.141.164.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742983979; cv=none; b=bUqE0dO08CDyaLerwxxAqp817JPB27dEcz6hfSOBOIWCDnmgqsl13FfTQE8qpQw9bGL5x4QWXYVcI5LEF06LKN1JPXA0IQcKFd7joLTFcc6rXQygAayko33s+r4AyEfKVQY8Vn3gZO+8uxGxbQv455+Q9mixdA6QJ8sUgNnnrRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742983979; c=relaxed/simple;
	bh=ZqFLRw3qaFJuzKxokk3g3/Ip4zPA9XV7qpk61h5/Wig=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hGdAAsB8TZQurIpxfQ9vtnNqjTwYsC+v1/HPLIYePrAPgBZPdv4p+5TlbQwvAELmAESufvE1n6vfjOCgkSJRMj5sOPCY60BitAukrHHE30E4sqjBXTM/GC19lz9ZiDjw4ibf5a0qM2Hsov4vBinFLMLGTxLW2aSAnJT31RSnbKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=izw-berlin.de; spf=pass smtp.mailfrom=izw-berlin.de; dkim=pass (1024-bit key) header.d=izw-berlin.de header.i=@izw-berlin.de header.b=LvnevGjV; arc=none smtp.client-ip=62.141.164.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=izw-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=izw-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=izw-berlin.de header.i=@izw-berlin.de header.b="LvnevGjV"
Received: from izw-mail-3.izw-berlin.local ([192.168.2.11]) by eproxy.izw-berlin.de over TLS secured channel with Microsoft SMTPSVC(10.0.14393.4169);
	 Wed, 26 Mar 2025 11:11:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; d=izw-berlin.de; s=p2024; c=simple/simple;
	t=1742983905; h=from:subject:to:date:message-id;
	bh=ZqFLRw3qaFJuzKxokk3g3/Ip4zPA9XV7qpk61h5/Wig=;
	b=LvnevGjVJOuZk2bRQJ/YloYKDDwwpE+BYNXFqduNBcNU4aNC3t8sQeMm7QdcslEvNt9lq+56ghk
	ehDQ/rVCCA/f/MtFJCcBevGpNIjgGyDiJCSZvSM7xZJOHw8hXmM6UuIZVPB9/gV8VvvK88afSAht7
	t9YnGgbTh683+XiY/qA=
Received: from izw-mail-3.izw-berlin.local (192.168.2.11) by
 izw-mail-3.izw-berlin.local (192.168.2.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 26 Mar 2025 11:11:45 +0100
Received: from izw-mail-3.izw-berlin.local ([192.168.2.11]) by
 izw-mail-3.izw-berlin.local ([192.168.2.11]) with mapi id 15.01.2507.044;
 Wed, 26 Mar 2025 11:11:45 +0100
From: "Heckmann, Ilja" <heckmann@izw-berlin.de>
To: Mark A Whiting <whitingm@opentext.com>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>
Subject: AW: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Thread-Topic: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Thread-Index: AdudzFmZYMLtC4Y+RNm+sf4/yE+hZgAZ/woj
Date: Wed, 26 Mar 2025 10:11:44 +0000
Message-ID: <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
In-Reply-To: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Mar 2025 10:11:45.0204 (UTC) FILETIME=[7A6EE740:01DB9E37]

We ran into what probably is the same problem with silent data corruption t=
hat was only noticed thanks to using a data format with internal checksums.=
 It also went away when mounting a share with "cache=3Dnone" while running =
the kernel 6.6.9, but that had the side-effect that no executables could be=
 started from the share (I reported this in June 2024). This second problem=
 was fixed in 6.10, but at the same time mounting with "cache=3Dnone" stopp=
ed helping against the data corruption issue. It persists until now, with k=
ernel 6.12.8, although the frequency at which the problem manifests went do=
wn significantly.

The way we test for it is by running a certain workload 100 times in a loop=
 and counting the number of runs aborted because of errors. That number wen=
t down from about 10 per 100 runs with kernel 6.6.9 to about 1 per 100 runs=
 with 6.12.8. Its non-deterministic nature and the lack of in-house experti=
se to investigate the issue at the same level as Mark did stopped us from r=
eporting it so far. And while there is no way of knowing that the issue we =
observe in 6.12.8 is the same one, at least I can confirm that there is a s=
imilar issue in more recent kernel versions as well.

Best wishes,
Ilja Heckmann
________________________________________
Von: Mark A Whiting <whitingm@opentext.com>
Gesendet: Dienstag, 25. M=E4rz 2025 22:24:55
An: linux-cifs@vger.kernel.org
Betreff: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing, x86_=
64, kernel 6.6.71

Hello,

I have discovered a data corruption issue with our application writing to a=
 CIFS share. I believe this issue may be related to another report I saw on=
 this mailing list, https://lore.kernel.org/linux-cifs/DFC1DAC5-5C6C-4DC2-8=
07A-DAF12E4B7882@gmail.com/. I understand that updating to a newer kernel w=
ould likely fix this issue. However, at the moment, that's not an option fo=
r us. In the long term we are looking to upgrade to 6.12 but I'm hoping to =
find a solution for our current 6.6 kernel.

I have tested mounting with the "cache=3Dnone" option and that solves the p=
roblem, albeit with a very large performance hit.

The platform is an embedded system. We're using an off-the-shelf COM Expres=
s Type 7 module with an Intel XEON D-1713NT processor. We're running a cust=
om Linux system built using Buildroot, currently running the 6.6.71 kernel.=
 I've tested the latest 6.6.84 kernel and the problem still exists there. O=
ur application is writing large amounts of compressed data (4+ GB) to the n=
etwork share. When I read back the data to verify it, I'm seeing small port=
ions of the file that have been replaced with zeros.

I've attacked the issue from several angles. Starting with a TCP dump of a =
complete operation from mounting, data transfer, to unmounting the network =
share. Through Wireshark I can see that there is no write command to the se=
rver covering the sections of the output that ends up as zeros. This indica=
ted to me that the CIFS kernel driver is failing to write out portions of t=
he file.

I then enabled all the CIFS debug info I could via cifsFYI and the kernel d=
ynamic debug controls and tweaked the code to not rate limit the pr_debug c=
alls. I could trace through the resulting logs and find pairs of cifs_write=
_begin() / cifs_write_end() that covered all the data including the section=
s that ultimately don't get written out. However, tracing through the smb2_=
async_writev() messages I again could not find any writes that covered the =
corrupt portions. At this point I began to suspect some kind of race condit=
ion within the cifs_writepages() function.

I also analyzed the data corruption and noticed a pattern. It does not fail=
 100% of the time, and it does not always fail in the same place. This furt=
hered my belief that it was some kind of non-deterministic data race. The c=
orrupt data region is always less than a page in size (<4096 bytes), it's a=
lways zeros, and it always ends on a page boundary. Because I knew the expe=
cted format of the data, I could also tell that the corrupt data was always=
 at the beginning of a write syscall by our application.

I've attempted to read through the CIFS kernel code involved in this. But I=
've never worked in the VFS/filesystem layers before. And I'm having troubl=
e following / understanding the intricacies of the page cache, page dirtyin=
g/cleaning, and writeback.

My current best guess at what's happening is as follows:
    * Our application writes out a buffer of data to the file on a CIFS sha=
re, this is compressed data that isn't nicely aligned, the data does not en=
d on a page boundary. This is a newly created file that we are writing to, =
so this write extends the files EOF to the end of the newly written data wh=
ich is in the middle of a page in the cache.
    * cifs_writepages() is invoked to write the cached data back to the ser=
ver, it scans the cached pages and prepares to write out all the dirty page=
s (including the final partial page).
    * Our application performs another write. This extends the file and the=
 beginning of this write falls into the end of the previous final partial c=
ached page.
    * cifs_writepages() finishes writing out the dirty pages, including the=
 first portion of what it thought was the final partial page, and marks all=
 pages as clean.
    * On the next invocation of cifs_writepages(), it scans for dirty pages=
 and skips the beginning of the second write because it thinks that page is=
 clean. The following page is a completely new page and is dirty, so it sta=
rts a new write from that page. This would explain why the corruption is al=
ways at the beginning of our application's write and corrects itself at the=
 next page boundary.

I have yet to really prove this, but this type of race between dirty/clean =
pages would explain all the behavior I'm seeing. I'm hoping someone much mo=
re intimately familiar with the CIFS code can help point me in the right di=
rection.

I did try one quick and dirty fix, assuming it was a race I applied the fol=
lowing patch. This added a per inode mutex that completely serialized the c=
ifs_write_begin(), cifs_write_end(), and cifs_writepages() functions. This =
did seem to resolve the data corruption issue, but at the cost of occasiona=
l deadlocks writing to CIFS files.

> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index bbb0ef18d7b8..6e2e273b9838 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -1659,6 +1659,7 @@ cifs_init_once(void *inode)
>
>       inode_init_once(&cifsi->netfs.inode);
>       init_rwsem(&cifsi->lock_sem);
> +     mutex_init(&cifsi->tbl_write_mutex);
 > }
 >
>  static int __init
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 43b42eca6780..4af4c5036d81 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1606,6 +1606,17 @@ struct cifsInodeInfo {
>       bool lease_granted; /* Flag to indicate whether lease or oplock is =
granted. */
>       char *symlink_target;
>       __u32 reparse_tag;
> +
> +     /* During development we discovered what we believe to be a race co=
ndition
> +      * in the write caching behavior of cifs. Setting cache=3Dnone solv=
ed the
> +      * issue but with an unacceptable performance hit. The following mu=
tex was
> +      * added to serialize the cifs_write_begin, cifs_write_end, and
> +      * cifs_writepages functions in file.c. This appears to solve the i=
ssue
> +      * without completely disabling caching.
> +      *
> +      * -Mark Whiting (whitingm@opentext.com)
> +      */
> +     struct mutex tbl_write_mutex;
>  };
>
>  static inline struct cifsInodeInfo *
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index cb75b95efb70..d3bc652a7e65 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3085,6 +3085,7 @@ static int cifs_writepages(struct address_space *ma=
pping,
>  {
>       loff_t start, end;
>       int ret;
> +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
>
>       /* We have to be careful as we can end up racing with setattr()
>        * truncating the pagecache since the caller doesn't take a lock he=
re
> @@ -3119,6 +3120,7 @@ static int cifs_writepages(struct address_space *ma=
pping,
>       }
>
>  out:
> +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>       return ret;
>  }
>
> @@ -3174,6 +3176,8 @@ static int cifs_write_end(struct file *file, struct=
 address_space *mapping,
>       struct folio *folio =3D page_folio(page);
>       __u32 pid;
>
> +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
> +
>       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>               pid =3D cfile->pid;
>       else
> @@ -3233,6 +3237,7 @@ static int cifs_write_end(struct file *file, struct=
 address_space *mapping,
>       /* Indication to update ctime and mtime as close is deferred */
>       set_bit(CIFS_INO_MODIFIED_ATTR, &CIFS_I(inode)->flags);
>
> +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>       return rc;
>  }
>
> @@ -4905,6 +4910,7 @@ static int cifs_write_begin(struct file *file, stru=
ct address_space *mapping,
>       int rc =3D 0;
>
>       cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, len=
);
> +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
>
>  start:
>       page =3D grab_cache_page_write_begin(mapping, index);
> @@ -4965,6 +4971,7 @@ static int cifs_write_begin(struct file *file, stru=
ct address_space *mapping,
>                  this will be written out by write_end so is fine */
>       }
>  out:
> +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
>       *pagep =3D page;
>       return rc;
>  }

Here are some of the log excerpts for one of my test cases. In this file on=
e of the corrupt regions starts at file offset 1,074,214,474 (0x4007364A), =
and was corrupt for 2,486 bytes, ending on a page boundary. First there is =
a section of the log trimmed to just the cifs_write_begin() / cifs_write_en=
d() functions. You can see that there is a write shown at the exact offset/=
length of the corrupted data.

> Mar 25 15:25:39 TX2 kernel: [  124.080900] [1567] cifs_write_begin:4907: =
CIFS: fs/smb/client/file.c: write_begin from 1074212864 len 1610
> Mar 25 15:25:39 TX2 kernel: [  124.080906] [1567] cifs_write_end:3182: CI=
FS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 1074=
212864 with 1610 bytes
> Mar 25 15:25:39 TX2 kernel: [  124.080911] [1567] cifs_write_begin:4907: =
CIFS: fs/smb/client/file.c: write_begin from 1074214474 len 2486
> Mar 25 15:25:39 TX2 kernel: [  124.080916] [1567] cifs_write_end:3182: CI=
FS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 1074=
214474 with 2486 bytes
> Mar 25 15:25:39 TX2 kernel: [  124.080917] [1567] cifs_write_begin:4907: =
CIFS: fs/smb/client/file.c: write_begin from 1074216960 len 846
> Mar 25 15:25:39 TX2 kernel: [  124.080924] [1567] cifs_write_end:3182: CI=
FS: fs/smb/client/file.c: write_end for page 00000000880cee03 from pos 1074=
216960 with 846 bytes

Now here's a section of the log trimmed to just the smb2_async_writev() fun=
ction. You can see writes covering the data immediately before and after th=
e corrupted region, but there is no write to the corrupted region. I'm assu=
ming the corrupted region is always zeros because the server is extending a=
nd zero-filling the file to the new write offset after the gap of the missi=
ng write.

> Mar 25 15:25:39 TX2 kernel: [  123.829696] [1635] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1072214016 988260 bytes iter=
=3Df1464
> Mar 25 15:25:39 TX2 kernel: [  124.081016] [1636] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1073201152 1013322 bytes ite=
r=3Df764a
** Missing write: 1073201152 + 1013322 =3D 1074214474 **
> Mar 25 15:25:39 TX2 kernel: [  124.083901] [1636] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1074216960 39564 bytes iter=
=3D9a8c
> Mar 25 15:25:40 TX2 kernel: [  124.340557] [1637] smb2_async_writev:4945:=
 CIFS: fs/smb/client/smb2pdu.c: async write at 1074253824 1237843 bytes ite=
r=3D12e353

I can very easily reproduce this with our application. If anyone has any su=
ggestions to try, additional logging / tracing they would like me to perfor=
m, please let me know. I can provide more detailed, full logs if desired, b=
ut they're quite large. I'll continue to read through the code and try to u=
nderstand, if I find anything I will update you.

Thanks,
Mark Whiting

