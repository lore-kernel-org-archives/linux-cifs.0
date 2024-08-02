Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046491BF311;
	Fri,  2 Aug 2024 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722591870; cv=none; b=K6DTcK9zsf07on41F9JgOeZINpfwQjPrXnDQ3klprO/eNSeBZHjmMLGkaxH3+olZshplgA8OM/EmLx2OudK4TX9AXSu7EkVKoc1W52sx0UEV2JumXLHLJ3RwcKY0sWk56I9RFC5a6cLYohyWzFLHFsX+CfwCpmldNA4hEfabYHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722591870; c=relaxed/simple;
	bh=0KsIn/0/DWTpo7S1UBSEjNExMpvPx+YcOvQCaYBrQw0=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=YlaFuV4YpnRDhIHXZYDh9MJoMjUALfGk4jHo0zfvopXDNz85mCiYZkKK1OdSdBNTM8SkMH1D7X/LduG1Vej07CUnsZvWWq/6GzwzuojMsQxMsGcxAVnvEvHG9WhteUdy7vGwTaVSU/IcbsZkfNKGGZjVPRl7zDYqGGZmGamuNTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=w3PLQRUX; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="w3PLQRUX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:Subject
	:Reply-To:Cc:To:From:MIME-Version:Date:Message-ID:From:Sender:Reply-To:
	Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=tYBNKUdLVBT8EAn0QM/7P3VwYTzBHo4it3VetCjlnIA=; t=1722591868;
	x=1723023868; b=w3PLQRUX70Hpwlo9isDFSw52fHNxRajsdpWeyy9BAoKOzp6soXj0p+sG5j9MZ
	6IHV4cFx4v3AZZsxzE8kst+B5MdiPcWiAWoQHl61O2dourb+Rk0IeAFtzPIkEHycbsy71w7mWegfQ
	OP2a1tlumBswb5uH9xoMCghTIZ8tFX/FbMwCmaiq/1TsqWhsoqpLODS9F7pgbdLBHZUpqcTo7Z7qi
	KbWJswfClCmw6qfH0NYIS8DxaMULki3dw9w/qvIDWklsrnyuHlzeFgSt9IQzn5zKGwIUIfgGatLcl
	YUYiUnpiCj96y7dhzgtPZFUfBWxbbQMcSFLDvNFl017p3o9rGA==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1sZopf-00078S-Pw; Fri, 02 Aug 2024 11:44:19 +0200
Message-ID: <c0967665-343d-4ca9-90a0-a072159c1056@leemhuis.info>
Date: Fri, 2 Aug 2024 11:44:18 +0200
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
To: Paulo Alcantara <pc@manguebit.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 Steve French <sfrench@samba.org>,
 Gleb Korobeynikov <gkorobeynikov@astralinux.ru>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: [regression] smb: client: - Failure to mount DFS namespaces without
 ASCII symbols
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1722591868;e7825c62;
X-HE-SMSGID: 1sZopf-00078S-Pw

Hi, Thorsten here, the Linux kernel's regression tracker.

Paulo, I noticed a report about a regression in bugzilla.kernel.org that
appears to be caused by this change of yours:

3ae872de410751 ("smb: client: fix shared DFS root mounts with different
prefixes") [v6.5-rc1]

As many (most?) kernel developers don't keep an eye on the bug tracker,
I decided to write this mail. To quote from
https://bugzilla.kernel.org/show_bug.cgi?id=219083 :

>  Gleb Korobeynikov 2024-07-22 10:59:46 UTC
> 
> Windows version of SMB host: Windows Server 2022 Standard x64
> Kernel: 6.3.13(upstream)
> CONFIG_CIFS_DFS_UPCALL
> 
> In the function cifs_inval_name_dfs_link_error(), a check was added for tcon->origin_fullpath (3ae872de410751fe5e629e04da491a632d95201c). I believe it's unnecessary because when mounting a dfs name without ASCII characters, we always fail at this check and exit the function, leading to dfs namespaces not being mounted
> 
> Steps to reproduce:
> 
> 1. At Windows, create DFS namespace with name containing non-ASCII symbols (for example дфс)
> 
> 2. mount -t cifs \\\\<smb_server>\\дфс  /tmp/dfs -o domain=...,user=...,password=...
> 
> result:
> mount error(2): No such file or directory
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log messages (dmesg)
> 
> CIFS debug log:
> [Mon Jul 22 11:00:24 2024] CIFS: Status code returned 0xc0000033 STATUS_OBJECT_NAME_INVALID
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2 status code 0xc0000033 to POSIX err -2
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/dfs_cache.c: dfs_cache_noreq_update_tgthint: path: \test.local\дфс
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_smb_ses: ses_count=2
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_smb_ses: ses ipc: \\test.local\IPC$
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: cifs_put_tcon: tc_count=1
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: in cifs_put_tcon as Xid: 17 with uid: 0
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2pdu.c: Tree Disconnect
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/fscache.c: cifs_fscache_release_super_cookie: (0x0000000000000000)
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_smb_ses: ses_count=1
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_smb_ses: ses ipc: \\DC.test.local\IPC$
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: in __cifs_put_smb_ses as Xid: 18 with uid: 0
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2pdu.c: disconnect session 00000000360c6881
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_smb_ses: ses_count=1
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: __cifs_put_smb_ses: ses ipc: \\test.local\IPC$
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: in __cifs_put_smb_ses as Xid: 19 with uid: 0
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/smb2pdu.c: disconnect session 00000000db1ddbb6
> [Mon Jul 22 11:00:24 2024] CIFS: fs/smb/client/connect.c: VFS: leaving cifs_mount_put_conns (xid = 13) rc = 0
> [Mon Jul 22 11:00:24 2024] CIFS: VFS: cifs_mount failed w/return code = -2

And

>  Gleb Korobeynikov 2024-07-30 11:03:01 UTC
> 
> (In reply to Gleb Korobeynikov from comment #5)
>> (In reply to The Linux kernel's regression tracker (Thorsten Leemhuis) from
>> comment #4)
>> > Please check if 6.10 (or 6.11-rc1 once it's out on Monday) is still
>> affected
>> 
>> Alright, I will definitely check
> 
> Checked on 6.11-rc1. The reproduction issue happens identically.

See the ticket for more details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

[1] because bugzilla.kernel.org tells users upon registration their
"email address will never be displayed to logged out users"

P.S.: let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: 3ae872de410751fe5e629e04da491a632d95201c
#regzbot title: smb: client: failure to mount DFS namespaces without
ASCII symbols
#regzbot from: Gleb Korobeynikov <gkorobeynikov@astralinux.ru>
#regzbot duplicate: https://bugzilla.kernel.org/show_bug.cgi?id=219083
#regzbot ignore-activity
