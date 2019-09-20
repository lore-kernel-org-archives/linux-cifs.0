Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA17EC49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 11:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B893B208C0
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 11:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408659AbfITLEM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Sep 2019 07:04:12 -0400
Received: from rigel.uberspace.de ([95.143.172.238]:38820 "EHLO
        rigel.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406008AbfITLEM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Sep 2019 07:04:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2019 07:04:11 EDT
Received: (qmail 21475 invoked from network); 20 Sep 2019 10:57:29 -0000
Received: from localhost (HELO webmail.rigel.uberspace.de) (127.0.0.1)
  by ::1 with SMTP; 20 Sep 2019 10:57:29 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Sep 2019 12:57:28 +0200
From:   Moritz M <mailinglist@moritzmueller.ee>
To:     linux-cifs@vger.kernel.org
Subject: Possible timeout problem when opening a file twice on a SMB mount
Message-ID: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
X-Sender: mailinglist@moritzmueller.ee
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I've some trouble with saving files with a particular software, LyX[0] 
in this case.
The problem is that saving a file on a SMB share makes the programm 
freeze for 30 s
due to creating an empty temp file.

While investigating I created a small python script which mimics 
(compared the strace output)
the LyX behaviour and also freezes the python script for 30 s.
That makes me believe that it could be a cifs problem.

The python script is:

#!/usr/bin/env python3

import os, sys

fd = os.open( "/mnt/share/foo.txt", 
os.O_RDWR|os.O_CREAT|os.O_EXCL|os.O_CLOEXEC, 0o600 )
fd = os.access( "/mnt/share/foo.txt", os.F_OK )
fd = os.chmod( "/mnt/share/foo.txt", 0o755 )
fd = os.open( "/mnt/share/foo.txt", os.O_WRONLY|os.O_CREAT|os.O_TRUNC, 
0o666 )

# Close opened file
os.close( fd )


Stracing it with

strace -f -t -T -e trace=openat,close,chmod,access python open.py

gives

23:18:52 openat(AT_FDCWD, "/mnt/share/foo.txt", 
O_RDWR|O_CREAT|O_EXCL|O_CLOEXEC, 0600) = 3 <0.002434>
23:18:52 access("/mnt/share/foo.txt", F_OK) = 0 <0.000091>
23:18:52 chmod("/mnt/share/foo.txt", 0755) = 0 <0.000168>
23:18:52 openat(AT_FDCWD, "/mnt/share/foo.txt", 
O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 4 <30.033585>

The second openat call takes 30 s and freezes the script.

When doing a os.close( fd ) after first open in the python script it 
works as expected:

23:22:11 openat(AT_FDCWD, "/mnt/share/foo.txt", 
O_RDWR|O_CREAT|O_EXCL|O_CLOEXEC, 0600) = 3 <0.002464>
23:22:11 close(3)                       = 0 <0.001652>
23:22:11 access("/mnt/share/foo.txt", F_OK) = 0 <0.000082>
23:22:11 chmod("/mnt/share/foo.txt", 0755) = 0 <0.000175>
23:22:11 openat(AT_FDCWD, "/mnt/share/foo.txt", 
O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 3 <0.003221>

My setup ist (server is a Synology Diskstation):

$ uname -r
5.1.21-1-MANJARO

$ mount.cifs -V
mount.cifs version: 6.8

$ samba --version
Version 4.4.16


Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.19
Features: 
DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0
Servers:
Number of credits: 510 Dialect 0x311
1) Name: x.x.x.x Uses: 1 Capability: 0x300045	Session Status: 1 TCP 
status: 1 Instance: 1
	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId: 
0x14e3311d
	Shares:
	0) IPC: \\server\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
	PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
	Share Capabilities: None	Share Flags: 0x0
	tid: 0xf1884345	Maximal Access: 0x1f00a9

	1) \\server\share Mounts: 1 DevInfo: 0x20 Attributes: 0x5006f
	PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x1dc3f115
	Share Capabilities: None Aligned, Partition Aligned,	Share Flags: 0x800
	tid: 0xe3ad48c8	Optimal sector size: 0x200	Maximal Access: 0x1f01ff

	MIDs:



Does anybody has a clue why it takes exactly 30 s when opening a file 
twice?
Even more important: how can I prevent it?
Any help is appreciated.

Thanks
Moritz

[0]: https://www.lyx.org/

