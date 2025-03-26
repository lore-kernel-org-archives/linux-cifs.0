Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229A18027
	for <linux-cifs@vger.kernel.org>; Wed, 26 Mar 2025 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743015516; cv=none; b=k/qZk5jk2/rIY8iUfrIKHAwvBjq+M8ChZjp5NyPwIbgIKJXMVIijWJLfLVJcC5IWKBy0f0XAVd0GMbl5gKA9BfDeXOS9Iyhlb9OqVYQ0nze9rULkJQbT8RpgvhJeUZeFJHJTPGSoxJR1nOl30OYMjOWxGwS/hPSNrx3f0FjEm10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743015516; c=relaxed/simple;
	bh=fsUhfFU9HXlqnhCtO74vIpBYGwbRHC+g6j6VtD6vv+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cv0WqD8tAo9DSTJ9Gg275zGZ7hMrWjAs6vcU5Xuvgzc/cTqSXZfsdj499/ZooN2UqrrNUUxyFU/RBsCJsgLzMoN6LhoBQdXGDA2mgsU2HkZMPL72C6ZGPy05mc0B65YmyA9OaEX4UnGf/eQuXuhnC+z0pJI97/yjPQH8QjggqjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQkoM3Vj; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQkoM3Vj"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3061513d353so2348341fa.2
        for <linux-cifs@vger.kernel.org>; Wed, 26 Mar 2025 11:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743015512; x=1743620312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BR3iDOSPxAcU9cHBKwLV0vyVBoISUaagSOM0XjjbFog=;
        b=iQkoM3Vjyv5vN7RWQQw87TQhDQWI9x6A7c+NX80JdV95+n5UpRGuHELgTAOmV9kXwx
         uaAx2lZirwkiCgTLTLnBXw5Z9LV/l1qXQPARMCJguj7XQXgmo+wWohFOypRWGsFqUMyg
         sYfHgt/sI3eGBGi9IjAbmJgBIWhPC/my/lW6D/+HrDAoGXq7zs0x53pLoCSPOYjL7db5
         6b7xpdEjI2tPSJ5RQD6dgDDxcfwjuXEt/w+u5xy2nvbnPFjQpvbL8mdwBGGzdBQpzxV9
         5Cs2I2wjfZCM2nJFj73mAjXz0tkcYRhKJthK0PLCyy8yo2OuIApAK9p/TO4n1AST5Vkj
         paEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743015512; x=1743620312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BR3iDOSPxAcU9cHBKwLV0vyVBoISUaagSOM0XjjbFog=;
        b=gDZj47ezsbyC9fSWki4ic57QHyM7vJyq28+3AkTRb5H/sDsaYcL5j6Oy9rxSaJ3p3C
         nUOHtPIx9LXjXp3xyCPjWDdilb0AQUDWQEi+jI6CUvUxQ1CLY/G+vDfRI9LX9WYiBE7e
         WJfQuifP3SjEtn1E/m0ao2XKuPTn+6Oy1mNxASAJg4yMou0u5BymDUjaYAEAlSPZOsQo
         yDiGM2bkO43nD1OIdKZA5qrppww28w2vEZKht6DApc4xljynTGFjwH7HTEgYkSQaDwjY
         0oN/L8J4S/TXulIYV8R8nwavaB2yI6CGurln2gllhOvtV2Rla3WQmPAKVcMNABUmK5UA
         1VgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe1faqJdOYWUVELxU4kJ0LqKacmz5anEv0dcG5HK+6m2sTc91/zv9fcLfrJIby8+2CCQlFG5L0hXLz@vger.kernel.org
X-Gm-Message-State: AOJu0YwSrlba9UUy2IfYNBQjUCddO01VIyMrFKLu0/y2/Gfoy8Uobk9y
	UwjCKu2JgBvVtmDWSiG24XRpBoG1t46KlJQm7am5elSgGoOlqKWG7ANS6Aeu9bMIqlxSxlDy+n8
	+VD1Koe8I31yOfmKC8isiuTt/wNs=
X-Gm-Gg: ASbGnctg4qFTpHf+yS92nxsZTgWMorJipwFGOfLe/zKkBFOf6KcKNHFx782FU/sQ0nE
	JHyvyLar7ab7K9NMKp1EnKQBAiz8/GhheMai3ZWHsgwuX5WRdetvVqKzMdLrFSyq3LcAjd3rUpW
	VPTkLLpD3lbMUHrHxz607HFvtJTts13kYYuQt1Lf5EDgnOvRVzK4/u4IHx44c=
X-Google-Smtp-Source: AGHT+IGfCvM3t9ibEnVS+CfBW+jhioCw9eQar6RQUL+j4+hj9YDvfBz8pb41sPovCWKw1rusrmNvf/at3rPD9VymY1s=
X-Received: by 2002:a05:6512:2301:b0:549:5989:bb89 with SMTP id
 2adb3069b0e04-54b01222177mr316249e87.35.1743015511667; Wed, 26 Mar 2025
 11:58:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
In-Reply-To: <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
From: Steve French <smfrench@gmail.com>
Date: Wed, 26 Mar 2025 13:58:20 -0500
X-Gm-Features: AQ5f1JovlaLBVvECQ3mfzqoRiT3ps7w3U337N4eU8vjz2P45GJEONz-H7GlgpXA
Message-ID: <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: "Heckmann, Ilja" <heckmann@izw-berlin.de>
Cc: Mark A Whiting <whitingm@opentext.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Were you able to confirm that the problem started after 6.6.0 but
regressed before 6.6.9 - any chance of narrowing the regression down
by bisection?

On Wed, Mar 26, 2025 at 5:13=E2=80=AFAM Heckmann, Ilja <heckmann@izw-berlin=
.de> wrote:
>
> We ran into what probably is the same problem with silent data corruption=
 that was only noticed thanks to using a data format with internal checksum=
s. It also went away when mounting a share with "cache=3Dnone" while runnin=
g the kernel 6.6.9, but that had the side-effect that no executables could =
be started from the share (I reported this in June 2024). This second probl=
em was fixed in 6.10, but at the same time mounting with "cache=3Dnone" sto=
pped helping against the data corruption issue. It persists until now, with=
 kernel 6.12.8, although the frequency at which the problem manifests went =
down significantly.
>
> The way we test for it is by running a certain workload 100 times in a lo=
op and counting the number of runs aborted because of errors. That number w=
ent down from about 10 per 100 runs with kernel 6.6.9 to about 1 per 100 ru=
ns with 6.12.8. Its non-deterministic nature and the lack of in-house exper=
tise to investigate the issue at the same level as Mark did stopped us from=
 reporting it so far. And while there is no way of knowing that the issue w=
e observe in 6.12.8 is the same one, at least I can confirm that there is a=
 similar issue in more recent kernel versions as well.
>
> Best wishes,
> Ilja Heckmann
> ________________________________________
> Von: Mark A Whiting <whitingm@opentext.com>
> Gesendet: Dienstag, 25. M=C3=A4rz 2025 22:24:55
> An: linux-cifs@vger.kernel.org
> Betreff: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing, x8=
6_64, kernel 6.6.71
>
> Hello,
>
> I have discovered a data corruption issue with our application writing to=
 a CIFS share. I believe this issue may be related to another report I saw =
on this mailing list, https://lore.kernel.org/linux-cifs/DFC1DAC5-5C6C-4DC2=
-807A-DAF12E4B7882@gmail.com/. I understand that updating to a newer kernel=
 would likely fix this issue. However, at the moment, that's not an option =
for us. In the long term we are looking to upgrade to 6.12 but I'm hoping t=
o find a solution for our current 6.6 kernel.
>
> I have tested mounting with the "cache=3Dnone" option and that solves the=
 problem, albeit with a very large performance hit.
>
> The platform is an embedded system. We're using an off-the-shelf COM Expr=
ess Type 7 module with an Intel XEON D-1713NT processor. We're running a cu=
stom Linux system built using Buildroot, currently running the 6.6.71 kerne=
l. I've tested the latest 6.6.84 kernel and the problem still exists there.=
 Our application is writing large amounts of compressed data (4+ GB) to the=
 network share. When I read back the data to verify it, I'm seeing small po=
rtions of the file that have been replaced with zeros.
>
> I've attacked the issue from several angles. Starting with a TCP dump of =
a complete operation from mounting, data transfer, to unmounting the networ=
k share. Through Wireshark I can see that there is no write command to the =
server covering the sections of the output that ends up as zeros. This indi=
cated to me that the CIFS kernel driver is failing to write out portions of=
 the file.
>
> I then enabled all the CIFS debug info I could via cifsFYI and the kernel=
 dynamic debug controls and tweaked the code to not rate limit the pr_debug=
 calls. I could trace through the resulting logs and find pairs of cifs_wri=
te_begin() / cifs_write_end() that covered all the data including the secti=
ons that ultimately don't get written out. However, tracing through the smb=
2_async_writev() messages I again could not find any writes that covered th=
e corrupt portions. At this point I began to suspect some kind of race cond=
ition within the cifs_writepages() function.
>
> I also analyzed the data corruption and noticed a pattern. It does not fa=
il 100% of the time, and it does not always fail in the same place. This fu=
rthered my belief that it was some kind of non-deterministic data race. The=
 corrupt data region is always less than a page in size (<4096 bytes), it's=
 always zeros, and it always ends on a page boundary. Because I knew the ex=
pected format of the data, I could also tell that the corrupt data was alwa=
ys at the beginning of a write syscall by our application.
>
> I've attempted to read through the CIFS kernel code involved in this. But=
 I've never worked in the VFS/filesystem layers before. And I'm having trou=
ble following / understanding the intricacies of the page cache, page dirty=
ing/cleaning, and writeback.
>
> My current best guess at what's happening is as follows:
>     * Our application writes out a buffer of data to the file on a CIFS s=
hare, this is compressed data that isn't nicely aligned, the data does not =
end on a page boundary. This is a newly created file that we are writing to=
, so this write extends the files EOF to the end of the newly written data =
which is in the middle of a page in the cache.
>     * cifs_writepages() is invoked to write the cached data back to the s=
erver, it scans the cached pages and prepares to write out all the dirty pa=
ges (including the final partial page).
>     * Our application performs another write. This extends the file and t=
he beginning of this write falls into the end of the previous final partial=
 cached page.
>     * cifs_writepages() finishes writing out the dirty pages, including t=
he first portion of what it thought was the final partial page, and marks a=
ll pages as clean.
>     * On the next invocation of cifs_writepages(), it scans for dirty pag=
es and skips the beginning of the second write because it thinks that page =
is clean. The following page is a completely new page and is dirty, so it s=
tarts a new write from that page. This would explain why the corruption is =
always at the beginning of our application's write and corrects itself at t=
he next page boundary.
>
> I have yet to really prove this, but this type of race between dirty/clea=
n pages would explain all the behavior I'm seeing. I'm hoping someone much =
more intimately familiar with the CIFS code can help point me in the right =
direction.
>
> I did try one quick and dirty fix, assuming it was a race I applied the f=
ollowing patch. This added a per inode mutex that completely serialized the=
 cifs_write_begin(), cifs_write_end(), and cifs_writepages() functions. Thi=
s did seem to resolve the data corruption issue, but at the cost of occasio=
nal deadlocks writing to CIFS files.
>
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index bbb0ef18d7b8..6e2e273b9838 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -1659,6 +1659,7 @@ cifs_init_once(void *inode)
> >
> >       inode_init_once(&cifsi->netfs.inode);
> >       init_rwsem(&cifsi->lock_sem);
> > +     mutex_init(&cifsi->tbl_write_mutex);
>  > }
>  >
> >  static int __init
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 43b42eca6780..4af4c5036d81 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -1606,6 +1606,17 @@ struct cifsInodeInfo {
> >       bool lease_granted; /* Flag to indicate whether lease or oplock i=
s granted. */
> >       char *symlink_target;
> >       __u32 reparse_tag;
> > +
> > +     /* During development we discovered what we believe to be a race =
condition
> > +      * in the write caching behavior of cifs. Setting cache=3Dnone so=
lved the
> > +      * issue but with an unacceptable performance hit. The following =
mutex was
> > +      * added to serialize the cifs_write_begin, cifs_write_end, and
> > +      * cifs_writepages functions in file.c. This appears to solve the=
 issue
> > +      * without completely disabling caching.
> > +      *
> > +      * -Mark Whiting (whitingm@opentext.com)
> > +      */
> > +     struct mutex tbl_write_mutex;
> >  };
> >
> >  static inline struct cifsInodeInfo *
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index cb75b95efb70..d3bc652a7e65 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -3085,6 +3085,7 @@ static int cifs_writepages(struct address_space *=
mapping,
> >  {
> >       loff_t start, end;
> >       int ret;
> > +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
> >
> >       /* We have to be careful as we can end up racing with setattr()
> >        * truncating the pagecache since the caller doesn't take a lock =
here
> > @@ -3119,6 +3120,7 @@ static int cifs_writepages(struct address_space *=
mapping,
> >       }
> >
> >  out:
> > +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
> >       return ret;
> >  }
> >
> > @@ -3174,6 +3176,8 @@ static int cifs_write_end(struct file *file, stru=
ct address_space *mapping,
> >       struct folio *folio =3D page_folio(page);
> >       __u32 pid;
> >
> > +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
> > +
> >       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> >               pid =3D cfile->pid;
> >       else
> > @@ -3233,6 +3237,7 @@ static int cifs_write_end(struct file *file, stru=
ct address_space *mapping,
> >       /* Indication to update ctime and mtime as close is deferred */
> >       set_bit(CIFS_INO_MODIFIED_ATTR, &CIFS_I(inode)->flags);
> >
> > +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
> >       return rc;
> >  }
> >
> > @@ -4905,6 +4910,7 @@ static int cifs_write_begin(struct file *file, st=
ruct address_space *mapping,
> >       int rc =3D 0;
> >
> >       cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, l=
en);
> > +     mutex_lock(&CIFS_I(mapping->host)->tbl_write_mutex);
> >
> >  start:
> >       page =3D grab_cache_page_write_begin(mapping, index);
> > @@ -4965,6 +4971,7 @@ static int cifs_write_begin(struct file *file, st=
ruct address_space *mapping,
> >                  this will be written out by write_end so is fine */
> >       }
> >  out:
> > +     mutex_unlock(&CIFS_I(mapping->host)->tbl_write_mutex);
> >       *pagep =3D page;
> >       return rc;
> >  }
>
> Here are some of the log excerpts for one of my test cases. In this file =
one of the corrupt regions starts at file offset 1,074,214,474 (0x4007364A)=
, and was corrupt for 2,486 bytes, ending on a page boundary. First there i=
s a section of the log trimmed to just the cifs_write_begin() / cifs_write_=
end() functions. You can see that there is a write shown at the exact offse=
t/length of the corrupted data.
>
> > Mar 25 15:25:39 TX2 kernel: [  124.080900] [1567] cifs_write_begin:4907=
: CIFS: fs/smb/client/file.c: write_begin from 1074212864 len 1610
> > Mar 25 15:25:39 TX2 kernel: [  124.080906] [1567] cifs_write_end:3182: =
CIFS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 10=
74212864 with 1610 bytes
> > Mar 25 15:25:39 TX2 kernel: [  124.080911] [1567] cifs_write_begin:4907=
: CIFS: fs/smb/client/file.c: write_begin from 1074214474 len 2486
> > Mar 25 15:25:39 TX2 kernel: [  124.080916] [1567] cifs_write_end:3182: =
CIFS: fs/smb/client/file.c: write_end for page 0000000086519afd from pos 10=
74214474 with 2486 bytes
> > Mar 25 15:25:39 TX2 kernel: [  124.080917] [1567] cifs_write_begin:4907=
: CIFS: fs/smb/client/file.c: write_begin from 1074216960 len 846
> > Mar 25 15:25:39 TX2 kernel: [  124.080924] [1567] cifs_write_end:3182: =
CIFS: fs/smb/client/file.c: write_end for page 00000000880cee03 from pos 10=
74216960 with 846 bytes
>
> Now here's a section of the log trimmed to just the smb2_async_writev() f=
unction. You can see writes covering the data immediately before and after =
the corrupted region, but there is no write to the corrupted region. I'm as=
suming the corrupted region is always zeros because the server is extending=
 and zero-filling the file to the new write offset after the gap of the mis=
sing write.
>
> > Mar 25 15:25:39 TX2 kernel: [  123.829696] [1635] smb2_async_writev:494=
5: CIFS: fs/smb/client/smb2pdu.c: async write at 1072214016 988260 bytes it=
er=3Df1464
> > Mar 25 15:25:39 TX2 kernel: [  124.081016] [1636] smb2_async_writev:494=
5: CIFS: fs/smb/client/smb2pdu.c: async write at 1073201152 1013322 bytes i=
ter=3Df764a
> ** Missing write: 1073201152 + 1013322 =3D 1074214474 **
> > Mar 25 15:25:39 TX2 kernel: [  124.083901] [1636] smb2_async_writev:494=
5: CIFS: fs/smb/client/smb2pdu.c: async write at 1074216960 39564 bytes ite=
r=3D9a8c
> > Mar 25 15:25:40 TX2 kernel: [  124.340557] [1637] smb2_async_writev:494=
5: CIFS: fs/smb/client/smb2pdu.c: async write at 1074253824 1237843 bytes i=
ter=3D12e353
>
> I can very easily reproduce this with our application. If anyone has any =
suggestions to try, additional logging / tracing they would like me to perf=
orm, please let me know. I can provide more detailed, full logs if desired,=
 but they're quite large. I'll continue to read through the code and try to=
 understand, if I find anything I will update you.
>
> Thanks,
> Mark Whiting
>
>


--=20
Thanks,

Steve
