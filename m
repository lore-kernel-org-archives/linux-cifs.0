Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD3CC4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Aug 2021 14:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEE260FC0
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Aug 2021 14:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhHKOig (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Aug 2021 10:38:36 -0400
Received: from p3plsmtpa07-02.prod.phx3.secureserver.net ([173.201.192.231]:39755
        "EHLO p3plsmtpa07-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231872AbhHKOif (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 11 Aug 2021 10:38:35 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2021 10:38:35 EDT
Received: from [192.168.0.100] ([68.239.50.225])
        by :SMTPAUTH: with ESMTPSA
        id DpFtmhIwqTm4nDpFtmCU3h; Wed, 11 Aug 2021 07:30:53 -0700
X-CMAE-Analysis: v=2.4 cv=K4bnowaI c=1 sm=1 tr=0 ts=6113df1d
 a=Rhw2r8FBodfaBxRKvGSZLA==:117 a=Rhw2r8FBodfaBxRKvGSZLA==:17
 a=IkcTkHD0fZMA:10 a=hGzw-44bAAAA:8 a=_48QVlGLX4mx_EnlBLMA:9 a=QEXdDO2ut3YA:10
 a=HvKuF1_PTVFglORKqfwH:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: Cifs erros in kern.log (CIFS VFS: No task to wake, unknown frame
 received! )
To:     rudi.feijo@multidadosti.com.br, linux-cifs@vger.kernel.org
References: <f107f53b9fe88517d84ab970dd40e7e6@multidadosti.com.br>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <1c00d06c-aaaf-622a-3b65-c83a0333cd79@talpey.com>
Date:   Wed, 11 Aug 2021 10:30:53 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <f107f53b9fe88517d84ab970dd40e7e6@multidadosti.com.br>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfNgKvx507EaiieE/wSI/ridV7EFHvFylVRoLft+09cwqTiEd6BZQcC+AhfInilYrDkQDmv3oGqEO8GmEgvuTKFaP8WZfgK8H4GaNrfnyO35s9LyoJu92
 yTzhDIiiMi9trtFUM6A4VDAe+nM/ELA+C8f40oA5oPmrlDQmOYKjkxZ8do3bUoKVNEOgt3TDMEfmU6e1CljQN6Th+wq4BDMc+ysKLmlzfRnKbQ7igkg3qWmp
 lcc9dWNB/5b85XUnQl71YQ==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This message is not actually an error, and it was removed
in the following March commit:

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=219481a8f90ec3a5eed9638fb35609e4b1aeece7

> cifs: Silently ignore unknown oplock break handle
> 
> Make SMB2 not print out an error when an oplock break is received for an
> unknown handle, similar to SMB1.  The debug message which is printed for
> these unknown handles may also be misleading, so fix that too.
> 
> The SMB2 lease break path is not affected by this patch.
> 
> Without this, a program which writes to a file from one thread, and
> opens, reads, and writes the same file from another thread triggers the
> below errors several times a minute when run against a Samba server
> configured with "smb2 leases = no".

Tom.

On 8/10/2021 9:14 AM, Rudi Feijó wrote:
> Hello
> 
> Recently we upgraded the linux/cifs part of our stack on our google 
> cloud VM's.
> Some new errors began popping up on kern.log, and our overall knowledge 
> of both linux and cifs is very basic, so here it goes.
> 
> uname -r = 4.19.0-17-cloud-amd64
> mount.cifs version: 6.8
> 
> The mount command is using mostly defaults,
> mount.cifs -v -o user=x,password=y,uid=11,gid=11 //hostdir /mntdir
> 
> The host is a windows server 2012 R2 Datacenter, and the host path is on 
> a NTFS drive
> We have done no aditional configuration on windows, we just shared the 
> directory
> 
> The windows servers as a file server to hold our php/js/other system 
> files, while the linux VMs are the apache servers in a load balancer 
> environment.
> The host path also servers to store cache files from these same 
> applications running on apache.
> 
> The kern.log have been showing a lot of messages. I can't tell the 
> severity of them. Apparently the system is running normaly and without 
> crashes.
> Here is the example from yesterday, since the mount started. This is 
> happening to all VMs using this linux image.
> 
> Aug  9 00:43:16 vmapphostname kernel: [    5.050322] FS-Cache: Loaded
> Aug  9 00:43:16 vmapphostname kernel: [    5.052899] Key type 
> dns_resolver registered
> Aug  9 00:43:16 vmapphostname kernel: [    5.082320] FS-Cache: Netfs 
> 'cifs' registered for caching
> Aug  9 00:43:16 vmapphostname kernel: [    5.083350] Key type 
> cifs.spnego registered
> Aug  9 00:43:16 vmapphostname kernel: [    5.084135] Key type cifs.idmap 
> registered
> Aug  9 00:43:16 vmapphostname kernel: [    5.085057] No dialect 
> specified on mount. Default has changed to a more secure dialect, SMB2.1 
> or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 
> dialect to access old servers which do not support SMB3 (or SMB2.1) 
> specify vers=1.0 on mount.
> Aug  9 00:43:16 vmapphostname kernel: [    5.130312] No dialect 
> specified on mount. Default has changed to a more secure dialect, SMB2.1 
> or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 
> dialect to access old servers which do not support SMB3 (or SMB2.1) 
> specify vers=1.0 on mount.
> Aug  9 02:45:00 vmapphostname kernel: [ 7308.426124] CIFS VFS: No task 
> to wake, unknown frame received! NumMids 0
> Aug  9 02:45:00 vmapphostname kernel: [ 7308.432985] 00000000: 424d53fe 
> 00000040 00000000 00000012  .SMB@...........
> Aug  9 02:45:00 vmapphostname kernel: [ 7308.432991] 00000010: 00000001 
> 00000000 ffffffff ffffffff  ................
> Aug  9 02:45:00 vmapphostname kernel: [ 7308.432992] 00000020: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 02:45:00 vmapphostname kernel: [ 7308.432993] 00000030: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 08:11:55 vmapphostname kernel: [37720.063969] CIFS VFS: No task 
> to wake, unknown frame received! NumMids 0
> Aug  9 08:11:55 vmapphostname kernel: [37720.070858] 00000000: 424d53fe 
> 00000040 00000000 00000012  .SMB@...........
> Aug  9 08:11:55 vmapphostname kernel: [37720.070859] 00000010: 00000001 
> 00000000 ffffffff ffffffff  ................
> Aug  9 08:11:55 vmapphostname kernel: [37720.070860] 00000020: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 08:11:55 vmapphostname kernel: [37720.070861] 00000030: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 09:35:31 vmapphostname kernel: [42736.024112] CIFS VFS: No task 
> to wake, unknown frame received! NumMids 0
> Aug  9 09:35:31 vmapphostname kernel: [42736.030971] 00000000: 424d53fe 
> 00000040 00000000 00000012  .SMB@...........
> Aug  9 09:35:31 vmapphostname kernel: [42736.030972] 00000010: 00000001 
> 00000000 ffffffff ffffffff  ................
> Aug  9 09:35:31 vmapphostname kernel: [42736.030973] 00000020: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 09:35:31 vmapphostname kernel: [42736.030974] 00000030: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 10:25:11 vmapphostname kernel: [45715.372317] CIFS VFS: 
> Autodisabling the use of server inode numbers on \\hostdir. This server 
> doesn't seem to support them properly. Hardlinks will not be recognized 
> on this mount. Consider mounting with the "noserverino" option to 
> silence this message.
> Aug  9 10:27:23 vmapphostname kernel: [45847.429760] CIFS VFS: No task 
> to wake, unknown frame received! NumMids 0
> Aug  9 10:27:23 vmapphostname kernel: [45847.436646] 00000000: 424d53fe 
> 00000040 00000000 00000012  .SMB@...........
> Aug  9 10:27:23 vmapphostname kernel: [45847.436648] 00000010: 00000001 
> 00000000 ffffffff ffffffff  ................
> Aug  9 10:27:23 vmapphostname kernel: [45847.436649] 00000020: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 10:27:23 vmapphostname kernel: [45847.436650] 00000030: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 12:10:01 vmapphostname kernel: [52005.258451] CIFS VFS: No task 
> to wake, unknown frame received! NumMids 2
> Aug  9 12:10:01 vmapphostname kernel: [52005.265299] 00000000: 424d53fe 
> 00000040 00000000 00000012  .SMB@...........
> Aug  9 12:10:01 vmapphostname kernel: [52005.265300] 00000010: 00000001 
> 00000000 ffffffff ffffffff  ................
> Aug  9 12:10:01 vmapphostname kernel: [52005.265301] 00000020: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 12:10:01 vmapphostname kernel: [52005.265302] 00000030: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 13:33:38 vmapphostname kernel: [57021.694822] CIFS VFS: No task 
> to wake, unknown frame received! NumMids 3
> Aug  9 13:33:38 vmapphostname kernel: [57021.701711] 00000000: 424d53fe 
> 00000040 00000000 00000012  .SMB@...........
> Aug  9 13:33:38 vmapphostname kernel: [57021.701713] 00000010: 00000001 
> 00000000 ffffffff ffffffff  ................
> Aug  9 13:33:38 vmapphostname kernel: [57021.701714] 00000020: 00000000 
> 00000000 00000000 00000000  ................
> Aug  9 13:33:38 vmapphostname kernel: [57021.701715] 00000030: 00000000 
> 00000000 00000000 00000000  ................
> 
> from this point on, the "CIFS VFS: No task to wake, unknown frame 
> received!" message will happen regularly troughout the day.
> 
> Looking in /proc/fs/cifs/Stats, I see a lot of creates and oplockbreaks 
> are failing, altho I can't seem to find the detailed log of each of these :
> 
> SMBs: 123331155
> Bytes read: 75399636858  Bytes written: 4347610634
> TreeConnects: 63003 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 35596756 total 2534986 failed
> Closes: 33061769 total 0 failed
> Flushes: 0 total 0 failed
> Reads: 20429224 total 0 failed
> Writes: 321116 total 0 failed
> Locks: 0 total 0 failed
> IOCTLs: 3 total 0 failed
> QueryDirectories: 1467549 total 0 failed
> ChangeNotifies: 0 total 0 failed
> QueryInfos: 32099007 total 0 failed
> SetInfos: 314551 total 0 failed
> OplockBreaks: 41179 sent 12371 failed
> 
> I'm tasked with making this as error free as possible. Any suggestions 
> and help is highly appreciated.
> 
> Thanks for your time,
> 
> Regards, Rudi
> 
