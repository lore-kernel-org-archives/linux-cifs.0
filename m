Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1EA2D61B;
	Sat,  1 Jun 2024 09:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717234622; cv=none; b=C4SDc0JRGZRdCuSo/S/logQiPLmWXKjuA2B81wCvkXdjJYUFqIwv+L/Va1+q68Wj3g5yETH6czTeFRK+38jZDrwC8TmUggO6wDyfTWsmHJw7JNEGsqHV3vYm7F9CPIWQbONs105mS8g/C9MoizySvRmhpHnTNas2xKuQILCv4pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717234622; c=relaxed/simple;
	bh=RZPCMPwVvgMPAOGxMHuPGSEMEvDQytJjVw+8CCV5LJI=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=Gt0BWf/3uPVbqjJOiLA5MUekK1aef8sDnHcttksTNFEjS4vxqY1cF0qIf7D+abdCRo38/+Th1tfsKgdmz0ae5hEZz5oI058XeWaA4bD3kPsUm0WVVPE/qpYEovZDpeMEM9Gr25Uph9O10iELnk5mfrZlArjmHxzIDesFhDxmFUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=oPntwHxm; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="oPntwHxm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	Reply-To:Subject:Cc:To:From:MIME-Version:Date:Message-ID:From:Sender:Reply-To
	:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=qTjigSZF4PwUn7XB/XLZ+k6MTHXmxb0W01t65wGS6Nw=; t=1717234620;
	x=1717666620; b=oPntwHxmTxD0YabuhE/E0ZPAo+lBXogC623ASG0o8qxDoPTRnl5xw+Lmzvo0y
	rU8oxLi4VVzmwdkuJdv1ba2RdcchvMTsHsgPjCC2Ycu8xWykOq0QoFdPNlGPzEhbFGID850kfa8ms
	brqVErJg0/jlyJ27YiKf1FWgSgqSqu42FpuGPuEoQMX+QhzFa4jy88DyBazvJnXYKstK3C7DNYeEV
	SXFvG68O3ynaKmiivfbogZg7qaZBKlsVa1XOB6fZC/Kfvzke2V/Q05NYUieX0bOk8Q+8o0XqNtxxQ
	2rLEWcZsdi7XUAUDe1sxVcM/ncW0XZWrrTpMuM+vDza71BJ2nw==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1sDLAS-0000a6-8T; Sat, 01 Jun 2024 11:36:52 +0200
Message-ID: <6e98d7b2-1068-4f05-a780-bad96ed5be27@leemhuis.info>
Date: Sat, 1 Jun 2024 11:36:51 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
To: Steve French <sfrench@samba.org>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
Subject: [regression] Bug 218902 - Kernel crash/reboot on cifs copy
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1717234620;1995c9d9;
X-HE-SMSGID: 1sDLAS-0000a6-8T

Hi, Thorsten here, the Linux kernel's regression tracker.

Steve, I noticed a report about a CIFS regression in bugzilla.kernel.org
you might be interested in.

As many (most?) kernel developers don't keep an eye on the bug tracker,
I decided to write this mail. To quote from
https://bugzilla.kernel.org/show_bug.cgi?id=218902 :

> Computer crashs when copying files from a local drive to a cifs mounted files system.
> 
> This bug exists since kernel 6.8.4 and is always present in last kernel 6.9.
> 
> Step to reproduce: on AlmaLinux 9
> 
> Boot with kernel 6.9.1-2 or 6.8.4
> 
> Open a terminal and copy some files on the cifs mounted directory. (Copy can be performed either by cp * ~/COMMUN or using Thunar)
> 
> --> The computer freezes and reboots producing an /boot/initram.....kdump.img file
> 
> 
> The bug is not present in kernel 5.14.0-427 nor in 6.7.9
> The bug does not affect read operations from the cifs mounted directory
> 
> Mount options:
> //192.168.1.112/commun /home/olivier/COMMUN cifs noauto,x-systemd.automount,user,nosuid,gid=100,uid=1026,credentials=/home/olivier/passwd 0 0
> -----------------------------------------------------------
> 
> The /var/log/messages contains the following:
> May 19 09:41:12 deyme18 kernel: watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [cifsd:1959]
> [...]
> May 19 09:41:12 deyme18 kernel: CPU: 2 PID: 1959 Comm: cifsd Kdump: loaded Tainted: G E 6.8.4-1.el9.elrepo.x86_64 #1
> May 19 09:41:12 deyme18 kernel: Hardware name: PC Specialist LTD N2x0WU /N2x0WU , BIOS 1.07.18 02/15/2019
> May 19 09:41:12 deyme18 kernel: RIP: 0010:native_queued_spin_lock_slowpath+0x72/0x2d0
> May 19 09:41:12 deyme18 kernel: Code: 08 0f 92 c2 8b 45 00 0f b6 d2 c1 e2 08 30 e4 09 d0 a9 00 01 ff ff 0f 85 f2 01 00 00 85 c0 74 12 0f b6 45 00 84 c0 74 0a f3 90 <0f> b6 45 00 84 c0 75 f6 b8 01 00 00 00 66 89 45 00 5b 5d 41 5c 41
> May 19 09:41:12 deyme18 kernel: RSP: 0018:ffffad7d40d3bd60 EFLAGS: 00000202
> May 19 09:41:12 deyme18 kernel: RAX: 0000000000000001 RBX: ffffffffc1ede988 RCX: 0000000000000000
> May 19 09:41:12 deyme18 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc1ede988
> May 19 09:41:12 deyme18 kernel: RBP: ffffffffc1ede988 R08: 0000000000000000 R09: ffff9f5a4b100b40
> May 19 09:41:12 deyme18 kernel: R10: ffff9f5a259eb1c8 R11: 01d9e3d51959a6a5 R12: ffff9f5a03db0038
> May 19 09:41:12 deyme18 kernel: R13: ffff9f5a516f4ec0 R14: ffff9f5a259eb000 R15: 0000000000000000
> May 19 09:41:12 deyme18 kernel: FS: 0000000000000000(0000) GS:ffff9f5d5ec80000(0000) knlGS:0000000000000000
> May 19 09:41:12 deyme18 kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> May 19 09:41:12 deyme18 kernel: CR2: 000055fa37ada5c0 CR3: 00000002d7a1e001 CR4: 00000000003706f0
> May 19 09:41:12 deyme18 kernel: Call Trace:
> May 19 09:41:12 deyme18 kernel: <IRQ>
> May 19 09:41:12 deyme18 kernel: ? watchdog_timer_fn+0x261/0x2f0
> May 19 09:41:12 deyme18 kernel: ? __pfx_watchdog_timer_fn+0x10/0x10
> May 19 09:41:12 deyme18 kernel: ? __hrtimer_run_queues+0x10f/0x2b0
> May 19 09:41:12 deyme18 kernel: ? hrtimer_interrupt+0x106/0x240
> May 19 09:41:12 deyme18 kernel: ? __sysvec_apic_timer_interrupt+0x6b/0x180
> May 19 09:41:12 deyme18 kernel: ? sysvec_apic_timer_interrupt+0x9d/0xd0
> May 19 09:41:12 deyme18 kernel: </IRQ>
> May 19 09:41:12 deyme18 kernel: <TASK>
> May 19 09:41:12 deyme18 kernel: ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> May 19 09:41:12 deyme18 kernel: ? native_queued_spin_lock_slowpath+0x72/0x2d0
> May 19 09:41:12 deyme18 kernel: _raw_spin_lock+0x30/0x40
> May 19 09:41:12 deyme18 kernel: __cifs_put_smb_ses+0x53/0x440 [cifs]
> May 19 09:41:12 deyme18 kernel: smb2_find_smb_tcon+0x61/0xd0 [cifs]
> May 19 09:41:12 deyme18 kernel: smb2_handle_cancelled_mid+0x42/0x90 [cifs]
> May 19 09:41:12 deyme18 kernel: __release_mid+0x8a/0xb0 [cifs]
> May 19 09:41:12 deyme18 kernel: cifs_demultiplex_thread+0x2fc/0x790 [cifs]
> May 19 09:41:12 deyme18 kernel: ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
> May 19 09:41:12 deyme18 kernel: kthread+0xee/0x120
> May 19 09:41:12 deyme18 kernel: ? __pfx_kthread+0x10/0x10
> May 19 09:41:12 deyme18 kernel: ret_from_fork+0x2d/0x50
> May 19 09:41:12 deyme18 kernel: ? __pfx_kthread+0x10/0x10
> May 19 09:41:12 deyme18 kernel: ret_from_fork_asm+0x1b/0x30
> May 19 09:41:12 deyme18 kernel: </TASK>
> May 19 09:41:23 deyme18 systemd-logind[719]: The system will reboot now!
> May 19 09:41:23 deyme18 systemd-logind[719]: System is rebooting.

6.7.y worked fine; I asked for a bisection; a second reporter ran into
the same problem; apparently they all use something RHEL9-like.

See the ticket for more details. Note, you have to use bugzilla to reach
the reporter, as I sadly[1] can not CCed them in mails like this.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

[1] because bugzilla.kernel.org tells users upon registration their
"email address will never be displayed to logged out users"

P.S.: let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v6.7..v6.8
#regzbot title: smb: client:
#regzbot from: Dufgrinder
#regzbot duplicate: https://bugzilla.kernel.org/show_bug.cgi?id=218902
#regzbot ignore-activity
