Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D1961FCF;
	Fri, 20 Sep 2024 20:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726862892; cv=none; b=tAbJM2MMuQbejfafK00vmYCbf6pjGHImeNLLWoP3dp6KcgaSuW4O38ITx902K8mCtt3ccTjRSAUCzjzfVVvYrwljSCa9g4/+W6RY1O9hHfwqTLJ/LZPInbO8QfCe+z3ZjOpShNFew7PH/0g7d9kXy4nRKfCD1C/swg2H1TrhXsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726862892; c=relaxed/simple;
	bh=FyCY36yI5w0lTSq34HxZmH4EPDjzQfp2huhYuiHkwRA=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=lClN/U9l9fMJbdRg8xZ9TXe/OplwTHYtNaNlkaTbJMTkGa0KQUIkksT/dcGVI1ClEv+rq2fncQHXd93cnd1bWV81UBh//UrzNnXbYksMSZn7Hg0oVpSG4Mq+LBOfhDQSlcWtDS+oODv3ShyutXOZmBo9IBfdrS4PJtirzP/DlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LquIpaDo; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LquIpaDo"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-718d8d6af8fso1792152b3a.3;
        Fri, 20 Sep 2024 13:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726862890; x=1727467690; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jqXxksIhdYu3U6EyI/SaQCdXTyiEORhvEkCurrA15Ic=;
        b=LquIpaDooPK9WJ+6Fl04RLTvu2Lrn6TbaaSv0SKcvQN7vcIS4NHJGLuHalpYt4qr2I
         PuOhgI7RjvTI3bjylnl3X/GUVYx2rrdAChrQNU4QLRrrdUmgocysnwd901OkRWIrxiPp
         9nnpBkSTTsQhjxcWCiUhDfVK5Qonz8dI1yXbAHIFXs0V2xK0IYcT50CZZZ/JVccJ3Y8W
         Pnn/nShq/dCY8oTPM4jOxcbPTQ1Oem/hchB5wZQ0cnefXWftd9/OdTFBLQDAVIMajKmp
         dyARWi6sQpPTlyVInVKwHvGgxg8wOLud0CX+SYLHNqGYyS7uOps4C8mA+wJIblsp1oSG
         7m1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726862890; x=1727467690;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqXxksIhdYu3U6EyI/SaQCdXTyiEORhvEkCurrA15Ic=;
        b=vqLlsrzSrtYmEbBXyq/O0zIo/TgXPGSGqzCS5wCM0Mw/N8BIu4dtCmiQg/agMkwG8m
         nyAMSXZGoLHH7ToXkMjZfGAwKDuxEtGTXOB0qK+lY2Lo7tOAqZBCTrU4RPUBUw7m2tMk
         s4+7Pf3OM3U3cpU8dGh4f5SWBgrhZHVf1n2EXajuEQzYfw321/swMrV8oFxlzR6J84aj
         1Uj2n3gVjVqhW1K/giZCnh2XJV/5NbNaBn7/o4acKesqvoBG5wl87wvz7qGF4Dx2d6P8
         YdNfprdwmOSPbEiKs6oToK+kw5L1FTvUm9d4/WH5xUaUDzhGxas0unktSHpZj/rK2Cm5
         Q4tw==
X-Forwarded-Encrypted: i=1; AJvYcCVK1LPJhTKIpa10+2Boy904lODZ6Df7ilD9wOUsgmWSRCtGKmsBRvxnoGCnyNl196W9ttFZcnSyGZSC@vger.kernel.org, AJvYcCVe7pDMJwMjTr3Hw9xyMoHUMj9GmApdyUQBtAfGMdv0VH42C8MjEIj2qowtK++4Nm4mk33fTin5mBTnQRqg@vger.kernel.org
X-Gm-Message-State: AOJu0YwtfC9offX8Dzfk7mNGFWm9fz4YimPJ9kUUtjbae4P1MGtlNla3
	NBYilGH/Xxnv9gnfrcH0fFPeMVg2YzBpI5dKRphGHdsKuTO/BTn+
X-Google-Smtp-Source: AGHT+IFnZTuVUXfi09IMvJbRV9nzRJbWPXCtMyEyTm2x1nnbKFEaAJF7P+WRaiwkpd1Vvtm+qwMHRA==
X-Received: by 2002:a05:6a20:b68a:b0:1d0:2533:1a42 with SMTP id adf61e73a8af0-1d30a8ecf33mr4553539637.9.1726862890221;
        Fri, 20 Sep 2024 13:08:10 -0700 (PDT)
Received: from smtpclient.apple ([2601:645:c600:8760:2cea:7b3a:57f3:3330])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db4998ff14sm11207518a12.66.2024.09.20.13.08.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2024 13:08:09 -0700 (PDT)
From: James Young <pronoiac@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: [REGRESSION] Corruption on cifs / smb write on ARM, kernels 6.3-6.9
Message-Id: <DFC1DAC5-5C6C-4DC2-807A-DAF12E4B7882@gmail.com>
Date: Fri, 20 Sep 2024 13:07:58 -0700
Cc: stable@vger.kernel.org,
 regressions@lists.linux.dev,
 linux-cifs@vger.kernel.org,
 David Howells <dhowells@redhat.com>,
 linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>
To: pronoiac+kernel@gmail.com
X-Mailer: Apple Mail (2.3776.700.51)

I was benchmarking some compressors, piping to and from a network share =
on a NAS, and some consistently wrote corrupted data.


First, apologies in advance:
* if I'm not in the right place. I tried to follow the directions from =
the Regressions guide - =
https://www.kernel.org/doc/html/latest/admin-guide/reporting-regressions.h=
tml
* I know there's a ton of context I don't know
* I=E2=80=99m trying a different mail app, because the first one looked =
concussed with plain text. This might be worse.


The detailed description:
I was benchmarking some compressors on Debian on a Raspberry Pi, piping =
to and from a network share on a NAS, and found that some consistently =
had issues writing to my NAS. Specifically:
* lzop
* pigz - parallel gzip
* pbzip2 - parallel bzip2

This is dependent on kernel version. I've done a survey, below.

While I tripped over the issue on a Debian port (Debian 12, bookworm, =
kernel v6.6), I compiled my own vanilla / mainline kernels for testing =
and reporting this.


Even more details:
The Pi and the Synology NAS are directly connected by Gigabit Ethernet. =
Both sides are using self-assigned IP addresses. I'll note that at boot, =
getting the Pi to see the NAS requires some nudging of avahi-autoipd; =
while I think it's stable before testing, I'm not positive, and =
reconnection issues might be in play.

The files in question are tars of sparse file systems, about 270 gig, =
compressing down to 10-30 gig.

Compression seems to work, without complaint; decompression crashes the =
process, usually within the first gig of the compressed file. The output =
of the stream doesn't match what ends up written to disk.

Trying decompression during compression gets further along than it does =
after compression finishes; this might point toward something with =
writes and caches.

A previous attempt involved rpi-update, which:
* good: let me install kernels without building myself
* bad: updated the bootloader and firmware, to bleeding edge, with =
possible regressions; it definitely muddied the results of my tests
I started over with a fresh install, and no results involving rpi-update =
are included in this email.


A survey of major branches:
* 5.15.167, LTS - good
* 6.1.109, LTS - good
* 6.2.16 - good
* 6.3.13 - bad
* 6.4.16 - bad
* 6.5.13 - bad
* 6.6.50, LTS - bad
* 6.7.12 - bad
* 6.8.12 - bad
* 6.9.12 - bad
* 6.10.9 - good
* 6.11.0 - good

I tried, but couldn't fully build 4.19.322 or 6.0.19, due to issues with =
modules.


Important commits:
It looked like both the breakage and the fix came in during rc1 =
releases.

Breakage, v6.3-rc1:
I manually bisected commits in fs/smb* and fs/cifs.

3d78fe73fa12 cifs: Build the RDMA SGE list directly from an iterator
> lzop and pigz worked. last working. test in progress: pbzip2

607aea3cc2a8 cifs: Remove unused code
> lzop didn't work. first broken


Fix, v6.10-rc1:
I manually bisected commits in fs/smb.

69c3c023af25 cifs: Implement netfslib hooks
> lzop didn't work. last broken one

3ee1a1fc3981 cifs: Cut over to using netfslib
> lzop, pigz, pbzip2, all worked. first fixed one


To test / reproduce:
It looks like this, on a mounted network share, with extra pv for =
progress meters:

cat 1tb-rust-ext4.img.tar.gz | \
  gzip -d | \
  lzop -1 > \
  1tb-rust-ext4.img.tar.lzop
  # wait 40 minutes

cat 1tb-rust-ext4.img.tar.lzop | \
  lzop -d | \
  sha1sum
  # either it works, and shows the right checksum
  # or it crashes early, due to a corrupt file, and shows an incorrect =
checksum

As I re-read this, I realize it might look like the compressor behaves =
differently. I added a "tee $output | sha1sum; sha1sum $output" and ran =
it on a broken version. The checksums from the pipe and for the file on =
disk are different.


Assorted info:
This is a Raspberry Pi 4, with 4 GiB RAM, running Debian 12, bookworm, =
or a port.

mount.cifs version: 7.0

# cat /proc/sys/kernel/tainted
1024

# cat /proc/version
Linux version 6.2.0-3d78fe73f-v8-pronoiac+ (pronoiac@bisect) (gcc =
(Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #21 =
SMP PREEMPT Thu Sep 19 16:51:22 PDT 2024


DebugData:=20
/proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.41
Features: =
DFS,FSCACHE,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),X=
ATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 1

Servers:
1) ConnectionId: 0x1 Hostname: drums.local
Number of credits: 8062 Dialect 0x300
TCP status: 1 Instance: 1
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 2
In Send: 1 In MaxReq Wait: 0

        Sessions:
        1) Address: 169.254.132.219 Uses: 1 Capability: 0x300047        =
Session Status: 1
        Security type: RawNTLMSSP  SessionId: 0x4969841e
        User: 1000 Cred User: 0

        Shares:
        0) IPC: \\drums.local\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: =
0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
        Share Capabilities: None        Share Flags: 0x0
        tid: 0xeb093f0b Maximal Access: 0x1f00a9

        1) \\drums.local\billions Mounts: 1 DevInfo: 0x20 Attributes: =
0x5007f
        PathComponentMax: 255 Status: 1 type: DISK Serial Number: =
0x735a9af5
        Share Capabilities: None Aligned, Partition Aligned,    Share =
Flags: 0x0
        tid: 0x5e6832e6 Optimal sector size: 0x200      Maximal Access: =
0x1f01ff


        MIDs:
        State: 2 com: 9 pid: 3117 cbdata: 00000000e003293e mid 962892

        State: 2 com: 9 pid: 3117 cbdata: 000000002610602a mid 962956

--



Let me know how I can help.
The process of iterating can take hours, and it's not automated, so my =
resources are limited.

#regzbot introduced: 607aea3cc2a8
#regzbot fix: 3ee1a1fc3981

-James

