Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C71C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 13:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 866AE6101E
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 13:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbhHJNYs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 09:24:48 -0400
Received: from smtp3.skymail.com.br ([168.0.132.13]:48932 "EHLO
        smtp3.skymail.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbhHJNYp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 09:24:45 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 09:24:44 EDT
Received: from webmail.multidadosti.com.br (unknown [10.1.3.23])
        by smtp3.smtp.skymail.prv (Postfix) with ESMTPA id 4GkYLp22GSz22BM
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 10:14:10 -0300 (-03)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=skymail.net.br;
        s=skymail; t=1628601250;
        bh=8s5FILJTIviVGwXlU+voD5nvgMGWcR4+h1ByAgZKRFc=;
        h=Date:From:To:Subject:Reply-To;
        b=33QyLvsVFqAaGnRwVnJXT04rEUbWTLImQTA/FAVsynWsFWOJbyRueOFmMc3aT3W+c
         Nl7ROZGTb50vEFLuxnIH5a5I6CR7Ph7NQxOGRxL08HxmWZ6K6CPDzFa7gF2LCkwp2U
         q3gwRQFz0OQOkVrc67hq80eMsVOublEeN2cqtOss=
Received: from 200-100-243-211.dial-up.telesp.net.br ([200.100.243.211])
 by webmail.multidadosti.com.br
 with HTTP (HTTP/2.0 POST); Tue, 10 Aug 2021 10:14:10 -0300
MIME-Version: 1.0
Date:   Tue, 10 Aug 2021 10:14:10 -0300
From:   =?UTF-8?Q?Rudi_Feij=C3=B3?= <rudi.feijo@multidadosti.com.br>
To:     linux-cifs@vger.kernel.org
Subject: Cifs erros in kern.log (CIFS VFS: No task to wake, unknown frame
 received! )
Reply-To: rudi.feijo@multidadosti.com.br
User-Agent: Webmail/1.4.10
Message-ID: <f107f53b9fe88517d84ab970dd40e7e6@multidadosti.com.br>
X-Sender: rudi.feijo@multidadosti.com.br
Organization: MultidadosTI
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Skymail-Auth: z7FAtTQ8SpGDjgo8KeGKWjKkAA+kcVt06InFLhIjWNEDD3msrDTRBppiyTyWHDtW7JxtlAul2oyUUzEPm8GE3ijKmSompFdO
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello

Recently we upgraded the linux/cifs part of our stack on our google 
cloud VM's.
Some new errors began popping up on kern.log, and our overall knowledge 
of both linux and cifs is very basic, so here it goes.

uname -r = 4.19.0-17-cloud-amd64
mount.cifs version: 6.8

The mount command is using mostly defaults,
mount.cifs -v -o user=x,password=y,uid=11,gid=11 //hostdir /mntdir

The host is a windows server 2012 R2 Datacenter, and the host path is on 
a NTFS drive
We have done no aditional configuration on windows, we just shared the 
directory

The windows servers as a file server to hold our php/js/other system 
files, while the linux VMs are the apache servers in a load balancer 
environment.
The host path also servers to store cache files from these same 
applications running on apache.

The kern.log have been showing a lot of messages. I can't tell the 
severity of them. Apparently the system is running normaly and without 
crashes.
Here is the example from yesterday, since the mount started. This is 
happening to all VMs using this linux image.

Aug  9 00:43:16 vmapphostname kernel: [    5.050322] FS-Cache: Loaded
Aug  9 00:43:16 vmapphostname kernel: [    5.052899] Key type 
dns_resolver registered
Aug  9 00:43:16 vmapphostname kernel: [    5.082320] FS-Cache: Netfs 
'cifs' registered for caching
Aug  9 00:43:16 vmapphostname kernel: [    5.083350] Key type 
cifs.spnego registered
Aug  9 00:43:16 vmapphostname kernel: [    5.084135] Key type cifs.idmap 
registered
Aug  9 00:43:16 vmapphostname kernel: [    5.085057] No dialect 
specified on mount. Default has changed to a more secure dialect, SMB2.1 
or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 
dialect to access old servers which do not support SMB3 (or SMB2.1) 
specify vers=1.0 on mount.
Aug  9 00:43:16 vmapphostname kernel: [    5.130312] No dialect 
specified on mount. Default has changed to a more secure dialect, SMB2.1 
or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 
dialect to access old servers which do not support SMB3 (or SMB2.1) 
specify vers=1.0 on mount.
Aug  9 02:45:00 vmapphostname kernel: [ 7308.426124] CIFS VFS: No task 
to wake, unknown frame received! NumMids 0
Aug  9 02:45:00 vmapphostname kernel: [ 7308.432985] 00000000: 424d53fe 
00000040 00000000 00000012  .SMB@...........
Aug  9 02:45:00 vmapphostname kernel: [ 7308.432991] 00000010: 00000001 
00000000 ffffffff ffffffff  ................
Aug  9 02:45:00 vmapphostname kernel: [ 7308.432992] 00000020: 00000000 
00000000 00000000 00000000  ................
Aug  9 02:45:00 vmapphostname kernel: [ 7308.432993] 00000030: 00000000 
00000000 00000000 00000000  ................
Aug  9 08:11:55 vmapphostname kernel: [37720.063969] CIFS VFS: No task 
to wake, unknown frame received! NumMids 0
Aug  9 08:11:55 vmapphostname kernel: [37720.070858] 00000000: 424d53fe 
00000040 00000000 00000012  .SMB@...........
Aug  9 08:11:55 vmapphostname kernel: [37720.070859] 00000010: 00000001 
00000000 ffffffff ffffffff  ................
Aug  9 08:11:55 vmapphostname kernel: [37720.070860] 00000020: 00000000 
00000000 00000000 00000000  ................
Aug  9 08:11:55 vmapphostname kernel: [37720.070861] 00000030: 00000000 
00000000 00000000 00000000  ................
Aug  9 09:35:31 vmapphostname kernel: [42736.024112] CIFS VFS: No task 
to wake, unknown frame received! NumMids 0
Aug  9 09:35:31 vmapphostname kernel: [42736.030971] 00000000: 424d53fe 
00000040 00000000 00000012  .SMB@...........
Aug  9 09:35:31 vmapphostname kernel: [42736.030972] 00000010: 00000001 
00000000 ffffffff ffffffff  ................
Aug  9 09:35:31 vmapphostname kernel: [42736.030973] 00000020: 00000000 
00000000 00000000 00000000  ................
Aug  9 09:35:31 vmapphostname kernel: [42736.030974] 00000030: 00000000 
00000000 00000000 00000000  ................
Aug  9 10:25:11 vmapphostname kernel: [45715.372317] CIFS VFS: 
Autodisabling the use of server inode numbers on \\hostdir. This server 
doesn't seem to support them properly. Hardlinks will not be recognized 
on this mount. Consider mounting with the "noserverino" option to 
silence this message.
Aug  9 10:27:23 vmapphostname kernel: [45847.429760] CIFS VFS: No task 
to wake, unknown frame received! NumMids 0
Aug  9 10:27:23 vmapphostname kernel: [45847.436646] 00000000: 424d53fe 
00000040 00000000 00000012  .SMB@...........
Aug  9 10:27:23 vmapphostname kernel: [45847.436648] 00000010: 00000001 
00000000 ffffffff ffffffff  ................
Aug  9 10:27:23 vmapphostname kernel: [45847.436649] 00000020: 00000000 
00000000 00000000 00000000  ................
Aug  9 10:27:23 vmapphostname kernel: [45847.436650] 00000030: 00000000 
00000000 00000000 00000000  ................
Aug  9 12:10:01 vmapphostname kernel: [52005.258451] CIFS VFS: No task 
to wake, unknown frame received! NumMids 2
Aug  9 12:10:01 vmapphostname kernel: [52005.265299] 00000000: 424d53fe 
00000040 00000000 00000012  .SMB@...........
Aug  9 12:10:01 vmapphostname kernel: [52005.265300] 00000010: 00000001 
00000000 ffffffff ffffffff  ................
Aug  9 12:10:01 vmapphostname kernel: [52005.265301] 00000020: 00000000 
00000000 00000000 00000000  ................
Aug  9 12:10:01 vmapphostname kernel: [52005.265302] 00000030: 00000000 
00000000 00000000 00000000  ................
Aug  9 13:33:38 vmapphostname kernel: [57021.694822] CIFS VFS: No task 
to wake, unknown frame received! NumMids 3
Aug  9 13:33:38 vmapphostname kernel: [57021.701711] 00000000: 424d53fe 
00000040 00000000 00000012  .SMB@...........
Aug  9 13:33:38 vmapphostname kernel: [57021.701713] 00000010: 00000001 
00000000 ffffffff ffffffff  ................
Aug  9 13:33:38 vmapphostname kernel: [57021.701714] 00000020: 00000000 
00000000 00000000 00000000  ................
Aug  9 13:33:38 vmapphostname kernel: [57021.701715] 00000030: 00000000 
00000000 00000000 00000000  ................

from this point on, the "CIFS VFS: No task to wake, unknown frame 
received!" message will happen regularly troughout the day.

Looking in /proc/fs/cifs/Stats, I see a lot of creates and oplockbreaks 
are failing, altho I can't seem to find the detailed log of each of 
these :

SMBs: 123331155
Bytes read: 75399636858  Bytes written: 4347610634
TreeConnects: 63003 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 35596756 total 2534986 failed
Closes: 33061769 total 0 failed
Flushes: 0 total 0 failed
Reads: 20429224 total 0 failed
Writes: 321116 total 0 failed
Locks: 0 total 0 failed
IOCTLs: 3 total 0 failed
QueryDirectories: 1467549 total 0 failed
ChangeNotifies: 0 total 0 failed
QueryInfos: 32099007 total 0 failed
SetInfos: 314551 total 0 failed
OplockBreaks: 41179 sent 12371 failed

I'm tasked with making this as error free as possible. Any suggestions 
and help is highly appreciated.

Thanks for your time,

Regards, Rudi
