Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FF6C35670
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 02:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC82C205C9
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 02:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgBXCAB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 23 Feb 2020 21:00:01 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:51816 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXCAB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 23 Feb 2020 21:00:01 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 01O1xueA033845;
        Sun, 23 Feb 2020 17:59:58 -0800
Message-ID: <5E532E1C.7090009@tlinx.org>
Date:   Sun, 23 Feb 2020 17:59:56 -0800
From:   L Walsh <cifs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     Steve French <smfrench@gmail.com>
CC:     linux-cifs <linux-cifs@vger.kernel.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression -- linux 5.5.3: can no longer mount with unix extentions
 using cifs 2.1 (Win10-only client additions).
References: <5E51DAEA.8090702@tlinx.org> <CAH2r5mtNgEi1noHAY0v_LmnwFOOZ1LsQ20zwTwWNk4uL5HY3EA@mail.gmail.com>
In-Reply-To: <CAH2r5mtNgEi1noHAY0v_LmnwFOOZ1LsQ20zwTwWNk4uL5HY3EA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2020/02/22 17:57, Steve French wrote:
> This is unlikely related to smb2.1 ... As it doesn't support either 
> smb1 Unix extensions or smb3.1.1 posix extensions.
---
    Shouldn't the mount have fallen back automatically to the unix 
extensions
that worked?  I have had the hard links working correctly which I thought
required the unix extensions.  Right now, it seems my ability to
access my win7 workstation from the unix client is messed up -- get
permission errors all over the place, so this limits my testing.


However this problem with link/symlines I can preproduce:
I was able to create some type of symlink/softlink as well as
able to use existing symlinks on windows to access other windows
destinations.

For example (following are 4 dir listings of my C-drive
root).  First is how things look under win cmd. and 1A is cygwin listing 

2rd is slightly interesting it's how the linux client see that same root.
without cifsacls in place.

3th is the most broken showing howt he linux client sees the root mounting
it with cifsacls.

If note: 'bliss/Isthar' is my domain server.
---------------------------

Win7 View of files in root of C drive:
Win7 dir of win7 root:
2016/09/24  13:55    <SYMLINKD>     D [\\Bliss\Documents]
2016/06/13  17:40    <SYMLINKD>     Documents [\\Bliss\Documents]
2015/06/05  11:52    <SYMLINKD>     FolderChanger [M:\FolderChanger]
2017/05/13  01:02    <SYMLINKD>     Home [Users]
2017/05/13  01:02    <SYMLINKD>     lib64 [lib]
2016/01/14  21:17    <SYMLINKD>     M [\\Ishtar\Music\Anime]
2016/09/24  13:54    <SYMLINKD>     P [D:\Pictures]
2014/11/06  19:45    <JUNCTION>     Prog [C:\Program Files (x86)]
2013/04/21  22:53    <SYMLINKD>     Prog64 [Program Files]
2015/08/09  15:05    <JUNCTION>     ProgD [C:\ProgramData]
2019/02/22  16:15    <JUNCTION>     S [\??\\\Bliss\Share]
2017/04/17  08:45    <SYMLINKD>     Share [S:\]
2019/06/27  21:17    <JUNCTION>     T [C:\??\Bliss\Share]
2014/01/12  14:07    <SYMLINKD>     temp [tmp]


1a) As an aside, for completeness of listing types:
Cygwin on the workstation, cygwin loses info in regards to
reparsed points junctions and mountd(not shown) vs. symlinks.

drwxrwxr-x+  1            0 Feb 13 10:47 D/
lrwxrwxrwx   1           17 Jun 13  2016 Documents -> //Bliss/Documents/
lrwxrwxrwx   1           16 Jun  5  2015 FolderChanger -> /m/FolderChanger/
lrwxrwxrwx   1            5 May 13  2017 Home -> Users/
drwxrwxr-x+  1            0 May 17  2019 M/
drwxrwxr-x+  1            0 Jan 22 16:18 P/
lrwxrwxrwx   1           20 Nov  6  2014 Prog -> /Program Files (x86)/
lrwxrwxrwx   1           13 Apr 21  2013 Prog64 -> Program Files/
lrwxrwxrwx   1           12 Aug  9  2015 ProgD -> /ProgramData/
drwxrwxr-x   1            0 Feb 23 04:02 S/
lrwxrwxrwx   1            2 Apr 17  2017 Share -> /s/
drwxrwxr-x   1            0 Feb 19 03:54 T/
lrwxrwxrwx   1            3 May 13  2017 lib64 -> lib/


2: mount as 1 user: seems to be mostly good.
(basic diff -- no 'cifsacl' on mount;  Note that the links listed below
do work and put you in their target)
Linux5.5.3 Client of Win7 root:

(mount options: 
user,noauto,rw,uid=law,gid=Administrators,domainauto,resilienthandles,noblocksend,serverino,nocase,vers=2.1,credentials=/home/law/.ssh/athenae,setuids,noauto,rsize=1048576,wsize=1048576)
(kernellog:
[743714.609791] CIFS: Attempting to mount //Athenae/C/)

l--------- 1            0 Sep 24  2016 D -> /??/UNC/Bliss/Documents/
l--------- 1            0 Jun 13  2016 Documents -> /??/UNC/Bliss/Documents/
l--------- 1            0 Jun  5  2015 FolderChanger -> 
/??/M:/FolderChanger/
l--------- 1            0 May 13  2017 Home -> Users/
l--------- 1            0 Jan 14  2016 M -> /??/UNC/Ishtar/Music/Anime/
l--------- 1            0 Sep 24  2016 P -> /??/D:/Pictures/
drwxr-xr-x 2            0 Nov  6  2014 Prog/
l--------- 1            0 Apr 21  2013 Prog64 -> Program Files/
drwxr-xr-x 2            0 Aug  9  2015 ProgD/
drwxr-xr-x 2            0 Feb 22  2019 S/
l--------- 1            0 Apr 17  2017 Share -> /??/S://
drwxr-xr-x 2            0 Jun 27  2019 T/
l--------- 1            0 May 13  2017 lib64 -> lib/
l--------- 1            0 Jan 12  2014 temp -> tmp/




This is where problems are: -- multiple errors listed in kernel

Same kernel (Linux5.5.3) Client of Win7 root:
This mount line adds 'cifsacl':
(mount options: 
user,noauto,rw,uid=law,gid=Administrators,cifsacl,domainauto,resilienthandles,noblocksend,serverino,nocase,vers=2.1,credentials=/home/law/.ssh/athenae,setuids,noauto,rsize=1048576,wsize=1048576 
0 0

kernellog:
[786299.920847] CIFS: Attempting to mount //Athenae/C/
[786317.942002] cifs_acl_to_fattr: 1 callbacks suppressed
[786317.942004] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786317.955716] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786317.964091] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786317.972594] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786317.980362] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786317.987305] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786317.997108] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786318.004615] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786318.014402] CIFS VFS: Autodisabling the use of server inode numbers 
on \\Athenae\C.
----Note, NOW, server inodes doesn't work

[786318.022149] CIFS VFS: The server doesn't seem to support them 
properly or the files might be on different servers (DFS).
[786318.033131] CIFS VFS: Hardlinks will not be recognized on this 
mount. Consider mounting with the "noserverino" option to silence this 
message.
--
-----and NOW hardlinks won't work.


[786318.051199] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786318.058613] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.484773] cifs_acl_to_fattr: 1 callbacks suppressed
[786327.484775] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.498098] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.506405] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.515147] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.523366] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.530254] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.541838] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.549552] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.562458] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc
[786327.569879] CIFS VFS: cifs_acl_to_fattr: error -95 getting sec desc

****output on user terminal:  Not really desirable or usable output:

ls: cannot access '/Athenae/D': Operation not supported
ls: cannot access '/Athenae/Documents': Operation not supported
ls: cannot access '/Athenae/FolderChanger': Operation not supported
ls: cannot access '/Athenae/Home': Operation not supported
ls: cannot access '/Athenae/lib64': Operation not supported
ls: cannot access '/Athenae/M': Operation not supported
ls: cannot access '/Athenae/P': Operation not supported
ls: cannot access '/Athenae/pagefile.sys': Device or resource busy
ls: cannot access '/Athenae/Prog64': Operation not supported
ls: cannot access '/Athenae/S': No such file or directory
ls: cannot access '/Athenae/Share': Operation not supported
ls: cannot access '/Athenae/Symbols': Operation not supported
ls: cannot access '/Athenae/Symbols-': Input/output error
ls: cannot access '/Athenae/T': No such file or directory
ls: cannot access '/Athenae/temp': Operation not supported

**** nothing is readable though permissions should allow

d????????? ?       ?            ? D/
d????????? ?       ?            ? Documents/
d????????? ?       ?            ? FolderChanger/
d????????? ?       ?            ? Home/
d????????? ?       ?            ? M/
d????????? ?       ?            ? P/
drwx------ 2   98304 Feb 14 14:34 Prog/
d????????? ?       ?            ? Prog64/
drwx------ 2   40960 Jan 27 09:41 ProgD/
d????????? ?       ?            ? S/
d????????? ?       ?            ? Share/
d????????? ?       ?            ? T/
d????????? ?       ?            ? lib64/
d????????? ?       ?            ? temp/




---------------------------
>
> There was an issue with inode numbers returned for root of drives in 
> windows (returning zero incorrectly). Can you see if this works to non 
> root share?
----
    I only have one (1) disk on my windows box...various reasons.
O.T.

OF note my login from the linux client has no access
