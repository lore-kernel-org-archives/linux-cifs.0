Received: from out28-85.mail.aliyun.com (out28-85.mail.aliyun.com [115.124.28.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C242042;
	Sun, 22 Sep 2024 23:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727049344; cv=none; b=t/AOj/vZy0w+PpDgggbWdLFNc5tm2zLeC8eWhnI1B4aGZhWXEksqDp2MeYHaIQFDIpCqnBXUuEdeBMES2T2SmcxurbELkIIt8IztZlYRK/jpCNJHVJgLm1JPUVOl16bEgDSr+TQDgRMOv0Z0kPAvK21oDySZyodAOMRVADyuDHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727049344; c=relaxed/simple;
	bh=V6gp0Uk7RbpnyDUOqVK5X6HdHQDAce7AF24wSEJbj+M=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=sKPbWOLMpadbgpL2xp117NKVIgXI05AIxMEsa0p4gg5KQ2eQhAckV+t5O8pUQ9jU2vWNrI7+p2GGbDgXTawqLB/Ko7DCHmRJR8BqzVUmUnmVfp0agzCrNgrVSS56cnvh7AgJXlB9i6tZJLcfZcMQyp3uZon7PLTNj9KrE+ZfFn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.ZQEkZnP_1727049328)
          by smtp.aliyun-inc.com;
          Mon, 23 Sep 2024 07:55:29 +0800
Date: Mon, 23 Sep 2024 07:55:29 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: James Young <pronoiac@gmail.com>
Subject: Re: [REGRESSION] Corruption on cifs / smb write on ARM, kernels 6.3-6.9
Cc: pronoiac+kernel@gmail.com,
 stable@vger.kernel.org,
 regressions@lists.linux.dev,
 linux-cifs@vger.kernel.org,
 David Howells <dhowells@redhat.com>,
 linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>
In-Reply-To: <DFC1DAC5-5C6C-4DC2-807A-DAF12E4B7882@gmail.com>
References: <DFC1DAC5-5C6C-4DC2-807A-DAF12E4B7882@gmail.com>
Message-Id: <20240923075527.3B9A.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.81.07 [en]

Hi,

> I was benchmarking some compressors, piping to and from a network share on a NAS, and some consistently wrote corrupted data.
> 
> 
> First, apologies in advance:
> * if I'm not in the right place. I tried to follow the directions from the Regressions guide - https://www.kernel.org/doc/html/latest/admin-guide/reporting-regressions.html
> * I know there's a ton of context I don't know
> * I¡¯m trying a different mail app, because the first one looked concussed with plain text. This might be worse.
> 
> 
> The detailed description:
> I was benchmarking some compressors on Debian on a Raspberry Pi, piping to and from a network share on a NAS, and found that some consistently had issues writing to my NAS. Specifically:
> * lzop
> * pigz - parallel gzip
> * pbzip2 - parallel bzip2
> 
> This is dependent on kernel version. I've done a survey, below.
> 
> While I tripped over the issue on a Debian port (Debian 12, bookworm, kernel v6.6), I compiled my own vanilla / mainline kernels for testing and reporting this.
> 
> 
> Even more details:
> The Pi and the Synology NAS are directly connected by Gigabit Ethernet. Both sides are using self-assigned IP addresses. I'll note that at boot, getting the Pi to see the NAS requires some nudging of avahi-autoipd; while I think it's stable before testing, I'm not positive, and reconnection issues might be in play.
> 
> The files in question are tars of sparse file systems, about 270 gig, compressing down to 10-30 gig.
> 
> Compression seems to work, without complaint; decompression crashes the process, usually within the first gig of the compressed file. The output of the stream doesn't match what ends up written to disk.
> 
> Trying decompression during compression gets further along than it does after compression finishes; this might point toward something with writes and caches.
> 
> A previous attempt involved rpi-update, which:
> * good: let me install kernels without building myself
> * bad: updated the bootloader and firmware, to bleeding edge, with possible regressions; it definitely muddied the results of my tests
> I started over with a fresh install, and no results involving rpi-update are included in this email.
> 
> 
> A survey of major branches:
> * 5.15.167, LTS - good
> * 6.1.109, LTS - good
> * 6.2.16 - good
> * 6.3.13 - bad
> * 6.4.16 - bad
> * 6.5.13 - bad
> * 6.6.50, LTS - bad
> * 6.7.12 - bad
> * 6.8.12 - bad
> * 6.9.12 - bad
> * 6.10.9 - good
> * 6.11.0 - good
> 
> I tried, but couldn't fully build 4.19.322 or 6.0.19, due to issues with modules.
> 
> 
> Important commits:
> It looked like both the breakage and the fix came in during rc1 releases.
> 
> Breakage, v6.3-rc1:
> I manually bisected commits in fs/smb* and fs/cifs.
> 
> 3d78fe73fa12 cifs: Build the RDMA SGE list directly from an iterator
> > lzop and pigz worked. last working. test in progress: pbzip2
> 
> 607aea3cc2a8 cifs: Remove unused code
> > lzop didn't work. first broken
> 
> 
> Fix, v6.10-rc1:
> I manually bisected commits in fs/smb.
> 
> 69c3c023af25 cifs: Implement netfslib hooks
> > lzop didn't work. last broken one
> 
> 3ee1a1fc3981 cifs: Cut over to using netfslib
> > lzop, pigz, pbzip2, all worked. first fixed one
> 
> 
> To test / reproduce:
> It looks like this, on a mounted network share, with extra pv for progress meters:
> 
> cat 1tb-rust-ext4.img.tar.gz | \
>   gzip -d | \
>   lzop -1 > \
>   1tb-rust-ext4.img.tar.lzop
>   # wait 40 minutes
> 
> cat 1tb-rust-ext4.img.tar.lzop | \
>   lzop -d | \
>   sha1sum
>   # either it works, and shows the right checksum
>   # or it crashes early, due to a corrupt file, and shows an incorrect checksum
> 
> As I re-read this, I realize it might look like the compressor behaves differently. I added a "tee $output | sha1sum; sha1sum $output" and ran it on a broken version. The checksums from the pipe and for the file on disk are different.
> 
> 
> Assorted info:
> This is a Raspberry Pi 4, with 4 GiB RAM, running Debian 12, bookworm, or a port.
> 
> mount.cifs version: 7.0
> 
> # cat /proc/sys/kernel/tainted
> 1024
> 
> # cat /proc/version
> Linux version 6.2.0-3d78fe73f-v8-pronoiac+ (pronoiac@bisect) (gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #21 SMP PREEMPT Thu Sep 19 16:51:22 PDT 2024
> 
> 
> DebugData: 
> /proc/fs/cifs/DebugData
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 2.41
> Features: DFS,FSCACHE,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
> CIFSMaxBufSize: 16384
> Active VFS Requests: 1
> 
> Servers:
> 1) ConnectionId: 0x1 Hostname: drums.local
> Number of credits: 8062 Dialect 0x300
> TCP status: 1 Instance: 1
> Local Users To Server: 1 SecMode: 0x1 Req On Wire: 2
> In Send: 1 In MaxReq Wait: 0
> 
>         Sessions:
>         1) Address: 169.254.132.219 Uses: 1 Capability: 0x300047        Session Status: 1
>         Security type: RawNTLMSSP  SessionId: 0x4969841e
>         User: 1000 Cred User: 0
> 
>         Shares:
>         0) IPC: \\drums.local\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
>         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
>         Share Capabilities: None        Share Flags: 0x0
>         tid: 0xeb093f0b Maximal Access: 0x1f00a9
> 
>         1) \\drums.local\billions Mounts: 1 DevInfo: 0x20 Attributes: 0x5007f
>         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x735a9af5
>         Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
>         tid: 0x5e6832e6 Optimal sector size: 0x200      Maximal Access: 0x1f01ff
> 
> 
>         MIDs:
>         State: 2 com: 9 pid: 3117 cbdata: 00000000e003293e mid 962892
> 
>         State: 2 com: 9 pid: 3117 cbdata: 000000002610602a mid 962956
> 
> --
> 
> 
> 
> Let me know how I can help.
> The process of iterating can take hours, and it's not automated, so my resources are limited.
> 
> #regzbot introduced: 607aea3cc2a8
> #regzbot fix: 3ee1a1fc3981

I checked 607aea3cc2a8, it just removed some code in #if 0 ... #endif.
so this regression is not introduced in 607aea3cc2a8,  but the reproduce
frequency is changed here.


Another issue in 6.6.y maybe related
https://lore.kernel.org/linux-fsdevel/9e8f8872-f51b-4a09-a92c-49218748dd62@meta.com/T/

Do this regression still happen after the following patches are applied?

a60cc288a1a2 :Luis Chamberlain: test_xarray: add tests for advanced multi-index use
a08c7193e4f1 :Sidhartha Kumar: mm/filemap: remove hugetlb special casing in filemap.c
6212eb4d7a63 :Hongbo Li: mm/filemap: avoid type conversion

de60fd8ddeda :Kairui Song: mm/filemap: return early if failed to allocate memory for split
b2ebcf9d3d5a :Kairui Song: mm/filemap: clean up hugetlb exclusion code
a4864671ca0b :Kairui Song: lib/xarray: introduce a new helper xas_get_order
6758c1128ceb :Kairui Song: mm/filemap: optimize filemap folio adding


Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2024/09/23

