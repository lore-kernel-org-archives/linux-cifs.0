Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9795C7FD
	for <linux-cifs@vger.kernel.org>; Fri,  6 Jun 2025 20:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749241067; cv=none; b=NoAZHxrsQ5/TH0KfN9CoudhObocWXrMuf/IZYmD6YwhyV7AiFy1yW8YPNubmARzR9CGXyZmDxLdJyJtKRIMpGfa9o+K4VJ5gm+n/QOBfhC5gR/8n2570nk51hw40zp3AcrJonCF5EP7ljVUP3hTvcGj7qn2+HM9EJJG//dYcAko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749241067; c=relaxed/simple;
	bh=luFxJwmGsy38koepNkJaGoPuLvMdorQVgDCM58NTYac=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=OHMHIrRfBCD4YoydLV3slJRSrDrnaotqPyiw+/Y+kz7DatdFDQeVj8yUO0FDDa1ISPxoa5lJA1hEGhViQZ19nqQ05i/+FUKlza8Q8HjMqlvI/QYzG4mYiQcmx7+oLC8Br3TFp4dOOIrbULlFLtnsVEsDCq3HiRI9lWa4mTc+/m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=monsen.cc; spf=pass smtp.mailfrom=monsen.cc; dkim=pass (2048-bit key) header.d=monsen.cc header.i=@monsen.cc header.b=Szj65diJ; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=monsen.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monsen.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monsen.cc header.i=@monsen.cc header.b="Szj65diJ"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4e58ad70536so726173137.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Jun 2025 13:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monsen.cc; s=google; t=1749241064; x=1749845864; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ap5WNZtZxxpNJe8jyMsvMKvRk1Fvbe5mAT/5iBMfHBM=;
        b=Szj65diJFLjWeFdxW5LSMxFIrWhsQziGUr3Soj8y1U7mq7wFbbeOyYLrfI4PpS/MYe
         olU7zhWZqDUOVutgBNzO6OLt9YvoFX5kWjCQoR/uVFfCV+FL82eO7csmAdOu6Oqcz5Sj
         wBE3+UEA9GO7mB7qfRtAf0zGmg0vnlcWJWhEulAOzWwr6Fr/m/A7b12eqN8fnd+fhch2
         Gqsxqa+atsHhGoJk8jICVSJx39ZoRSirsqjz9ptC157K4Gl4gcNpteAkzAArg5EVCDpE
         Y0SXv4hgQBO9IyvRz6b0rlMlm3dPZT4UWWdIkWEIiJeofxwpcdZQjHSiQyFcQS7BNtmg
         aVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749241064; x=1749845864;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ap5WNZtZxxpNJe8jyMsvMKvRk1Fvbe5mAT/5iBMfHBM=;
        b=FpUTmZSBSlOJQ5eZei/yQYENlEj/KolwhBj1iaQflZcaEaSkRwwgCAM/RjnC4w4Vtg
         837FFWhsJM7zaqolYyrCpXfwc9+1iWGIILy4Pjc2ltRWomijOT1SJxdImPag2JUSvAA7
         RFw8eoGx17tluS6gxKoZSKX4HrkYi2ur525BsKi0nYeVmHMn3vLPtQDYop6DZ4cT9nia
         AEv2IK7V0Wwe0aWBd5w1SBFhixe1oejslZqLawcB/cnID55UNkNz2SqkCAcDGkNV2tUD
         qmLp/B2Ad8qKf0Zyq+H9p0bqzTb0CmyUlJXtNRH1VUvVP0xvbPDnSVdRvopAQ/tOdVWb
         u5Pg==
X-Gm-Message-State: AOJu0YyTUpVnU4XAWZPETDOuaojwt+a7k/NV/5TjPnyw1fOINE/SUsdc
	iuvrnh2JS0OS9KdS32bM6hN9oSABuRnp2jAdcwlwzPZBClHsLHU96QKt0iWp03SH6sn0frVzxGt
	wS/RyR37pG+xQstwTlYhGsnYfX8EWjxbhRD9uywaRRg4zFD9urTjo8dF4ew==
X-Gm-Gg: ASbGncuolPXJzZVa8IoFZjoLCWu8uaPv/DvwP70hPb7HVZVUSmDBf46FId8k4ExFyp9
	ZjnXEtEbVWyNPsip2H1+11Sqvu0CC5kLPUduh9z/raGFqDgcP7WQfEsuESefwulj/Gk/gQWIHgB
	lDPJDYDudZ/hHC33oa0Ugm0d+2osQDWsdNFeaes8JQeqHK85sYW9Q=
X-Google-Smtp-Source: AGHT+IHaR5x/vqC3Qpox3rc8DgR1MvcgOHutX8t7gvPuEoIPb3cLCB+34aylSMf/2srGQJYfxneXQlLfEe65kDJaTVw=
X-Received: by 2002:a05:6102:3ecf:b0:4e7:596e:ec11 with SMTP id
 ada2fe7eead31-4e7728d15cdmr5003951137.5.1749241063652; Fri, 06 Jun 2025
 13:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Remy Monsen <monsen@monsen.cc>
Date: Fri, 6 Jun 2025 22:17:31 +0200
X-Gm-Features: AX0GCFtHZy0WZLXTSTyjX5N_HfEDAaUduAZFuyJl4eoli0lSoTEHrSklHE_UyxY
Message-ID: <CAN+tdP7y=jqw3pBndZAGjQv0ObFq8Q=+PUDHgB36HdEz9QA6FQ@mail.gmail.com>
Subject: CIFS 7.1 causes I/O-errors when encountering directory junctions on
 remote windows machine
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I hope this is the right place to ask for help on this.

Background:
I use an Alma Linux machine to take backup of the file system on a
couple of Windows servers via CIFS/SMB3. Recently, I upgraded the
machine to Alma Linux 9.6 (from 9.5) and suddenly my backups started
to throw error messages.
I investigated a bit, and since I had a recent backup of the old
setup, testing revealed that the old setup (alma 9.5) still works
perfectly fine, while the updated one (Alma 9.6) was throwing errors.

The errors seem to be down to the way it handles directory junctions.
My NTFS file system contains a couple of those, pointing to a
completely different computer on the network. Under Alma 9.5, these
junctions are just reported to the file system as links without a
valid target, leading to this output from ls:
root@backup [575]> ls -l /mnt/fileserver/Data/JunctionTest
total 0
lrw-r-----. 1 monsen monsen 25 Jun  6 20:41 TestJunction ->
'/??/UNC/web.monsen.cc/Web'

No error messages are shown anywhere, including dmesg/console.


Now, if I instead run the same thing on the machine updated to Alma
9.6, i get an io-error thrown (which is what causes issues for my
backups, it can't verify consistency when the FS throws i/o-errors on
it)
ls -l /mnt/fileserver/Data/JunctionTest
ls: cannot access '/mnt/fileserver/Data/JunctionTest/TestJunction':
Input/output error
total 0
l????????? ? ? ? ?            ? TestJunction

In addition to that, the following error is logged to the console:
[   76.407630] CIFS: VFS: absolute symlink '\??\UNC\web.monsen.cc\Web'
cannot be converted from NT format because points to unknown target



Googling for the error message resulted in very few hits, but it did
point to a code submission made to CIFS 7.1.X that made changes to
just this functionality specifically some months ago. I am not
familiar enough with CIFS code to start digging through it myself
unfortunately. Now, I realize these links didn't actually work in CIFS
7.0 either, but it treated them like normal Linux links without a
target, instead of causing serious errors


For the record, I am not trying to get these links to actually work
when accessed from a Linux machine (although that would be nice of
course), but my issue is simply that CIFS now causes I/O errors to be
thrown, a change in behavior from earlier versions, which causes quite
annoying problems which I struggle to work around.

Also note that all these links were made on the Windows machine using
the "mklink -D linkName target" command, I am not trying to make any
of these from the linux machine.
It is also worth noting that the linux machine do have full access to
the destination of that link, it is just CIFS not understanding it,
but I can easily mount that location manually on the linux machine
using the same credential file (both machines are domain joined to the
same domain).
This also seems to just be a problem with Directory Junctions pointing
to a different computers than the one where the share resides, If I
make one pointing to another directory on the same file system it
works fine.


The relevant lines from my fstab looks like this
//file.monsen.cc/BackupSource$   /mnt/fileserver        smb3
defaults,noauto,noserverino,credentials=/etc/cifs.conn,ro,uid=1000,gid=1000,file_mode=0640,dir_mode=0750
//web.monsen.cc/Web     /mnt/web         smb3
defaults,noauto,noserverino,credentials=/etc/cifs.conn,ro,uid=1000,gid=1000,file_mode=0640,dir_mode=0750

I've already tried adding vers= to that line and tried different
versions, but that didn't seem to do anything.




For the broken (Alma 9.6) setup, the system looks like this:
Linux backup.monsen.cc 5.14.0-570.19.1.el9_6.x86_64 #1 SMP
PREEMPT_DYNAMIC Wed Jun 4 04:00:24 EDT 2025 x86_64 x86_64 x86_64
GNU/Linux
mount.cifs version: 7.1

Contents of /proc/fs/cifs/DebugData:
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.48
Features: DFS,SMB_DIRECT,STATS,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x1 Hostname: file.monsen.cc
ClientGUID: 3C39E3A1-9909-B64C-BB1D-67C17F69C8DF
Number of credits: 803,1,1 Dialect 0x311
Server capabilities: 0x300067
TCP status: 1 Instance: 1
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840
In Send: 0 In MaxReq Wait: 0
Compression: no built-in support

        Sessions:
        1) Address: 2a01:0799:2a93:fd00:0010:0099:0099:0032 Uses: 1
Capability: 0x300067        Session Status: 1
        Security type: RawNTLMSSP  SessionId: 0x26c01b4000069
        User: 1000 Cred User: 0

        Shares:
        0) IPC: \\file.monsen.cc\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
        Share Capabilities: None        Share Flags: 0x30
        tid: 0x1        Maximal Access: 0x11f01ff

        1) \\file.monsen.cc\BackupSource$ Mounts: 1 DevInfo: 0x20020
Attributes: 0xc706ff
        PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x8521e41
        Share Capabilities: None Aligned, Partition Aligned,
TRIM-support,      Share Flags: 0x0
        tid: 0x5        Optimal sector size: 0x1000     Maximal Access: 0x1200a9


        Server interfaces: 5    Last updated: 144 seconds ago
        1)      Speed: 10Gbps
                Capabilities: rss
                IPv4: 10.49.99.32
                Weight (cur,total): (0,1)
                Allocated channels: 0

        2)      Speed: 10Gbps
                Capabilities: rss
                IPv6: fe80:0000:0000:0000:683a:7c9c:6cd1:b904
                Weight (cur,total): (0,1)
                Allocated channels: 0

        3)      Speed: 10Gbps
                Capabilities: rss
                IPv6: 2a01:0799:2a93:fd00:c8db:1fef:914b:a7c0
                Weight (cur,total): (0,1)
                Allocated channels: 0

        4)      Speed: 10Gbps
                Capabilities: rss
                IPv6: 2a01:0799:2a93:fd00:0010:0049:0099:0032
                Weight (cur,total): (1,1)
                Allocated channels: 1
                [CONNECTED]

        5)      Speed: 10Gbps
                Capabilities: rss
                IPv6: 2a01:0799:2a93:fd00:0000:0000:0000:1013
                Weight (cur,total): (0,1)
                Allocated channels: 0


        MIDs:
--








For the working setup (Alma 9.5), the setup looks like this:
Linux backup.monsen.cc 5.14.0-503.40.1.el9_5.x86_64 #1 SMP
PREEMPT_DYNAMIC Mon May 5 06:06:04 EDT 2025 x86_64 x86_64 x86_64
GNU/Linux
mount.cifs version: 7.0

Contents of /proc/fs/cifs/DebugData:
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.48
Features: DFS,SMB_DIRECT,STATS,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x1 Hostname: file.monsen.cc
ClientGUID: 207E0272-18B4-B148-94B9-E67C47EA0225
Number of credits: 614,1,1 Dialect 0x311
Server capabilities: 0x300067
TCP status: 1 Instance: 1
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840
In Send: 0 In MaxReq Wait: 0
Compression: disabled on mount

        Sessions:
        1) Address: 2a01:0799:2a93:fd00:0010:0049:0099:0032 Uses: 1
Capability: 0x300067        Session Status: 1
        Security type: RawNTLMSSP  SessionId: 0x26c01b0000025
        User: 1000 Cred User: 0

        Shares:
        0) IPC: \\file.monsen.cc\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
        Share Capabilities: None        Share Flags: 0x30
        tid: 0x1        Maximal Access: 0x11f01ff

        1) \\file.monsen.cc\BackupSource$ Mounts: 1 DevInfo: 0x20020
Attributes: 0xc706ff
        PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x8521e41
        Share Capabilities: None Aligned, Partition Aligned,
TRIM-support,      Share Flags: 0x0
        tid: 0x5        Optimal sector size: 0x1000     Maximal Access: 0x1200a9


        Server interfaces: 5    Last updated: 51 seconds ago
        1)      Speed: 10Gbps
                Capabilities: rss
                IPv4: 10.49.99.32
                Weight (cur,total): (0,1)
                Allocated channels: 0

        2)      Speed: 10Gbps
                Capabilities: rss
                IPv6: fe80:0000:0000:0000:683a:7c9c:6cd1:b904
                Weight (cur,total): (0,1)
                Allocated channels: 0

        3)      Speed: 10Gbps
                Capabilities: rss
                IPv6: 2a01:0799:2a93:fd00:c8db:1fef:914b:a7c0
                Weight (cur,total): (0,1)
                Allocated channels: 0

        4)      Speed: 10Gbps
                Capabilities: rss
                IPv6: 2a01:0799:2a93:fd00:0010:0049:0099:0032
                Weight (cur,total): (1,1)
                Allocated channels: 1
                [CONNECTED]

        5)      Speed: 10Gbps
                Capabilities: rss
                IPv6: 2a01:0799:2a93:fd00:0000:0000:0000:1013
                Weight (cur,total): (0,1)
                Allocated channels: 0


        MIDs:
--





The Windows server (file) I am connecting to is a Windows Server 2019
Datacenter, Version 1809, OS build 17763.7314
The other server those links are pointing to (web) is a Windows Server
2016 Datacenter, Version 1607, Build 14393.7969, but CIFS never seem
to even try connecting to this box, but I also have a backup target on
this server that contains directory junctions too, which results in
the exact same behavior as described above when connected to using the
latest Alma 9.6 kernel..

On the windows side the directory junction looks like this:
06.06.2025  08:41    <SYMLINKD>     TestJunction [\\web.monsen.cc\Web]



Thanks for your attention, and for any help/insight you can provide.
Please let me know if you need more information.

Sincerely,
Remy Monsen
