Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1F819E822;
	Mon, 24 Jun 2024 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719251976; cv=none; b=TicpoxEdv2oSZzEXcautYovlzVq33aPFT3Z70nk2uhrTQecGh88B6GedSErBuuyf+7vs73VhRB5JHIKeDvDAn+fcnAmeLeiWefT1rvMY1cVntbYSSnOP6bCnLdXm4cIKyJs8F6Tx9QhXnr55uq9f/4Df2dGxF/viMtqts+gWasM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719251976; c=relaxed/simple;
	bh=M/phQX0hH9rYXb4ZxBy7KtQfTLRuPv3EdCjqqg+AHBM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdNr7a8rheUv2wfC3PV0U0sl9RtRXnxlmrRbwMmTfz3EuU62c/f2xnx5kAYVfVDdFrWUCQesnBeQ3uQYShhLuJgol/EIkPe9wGQ4cgazjT141B+MVKA33oWKrLNj/dY6sVBO8yFuHbbEp6uCd8roqRdcoJvlSJmQ1DO8Zx6b6a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=KiAkohik; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="KiAkohik"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1719251975; x=1750787975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PPo7y8yv85Odnfu13ied03pGxbHHn3NHPUOOH3BEjqo=;
  b=KiAkohikrzdWr52DjK/FbhRRDm88JBHoj+cRuZPlpRWv/PVt6HTZYRjq
   fuCEYAJvUTqRC5jNCRvh6YCc8Ho+zo/WwqIjzHLxRTUyql82Q/0CUN8Uo
   zidZsM1nqMk0b1NGt5QqhB1pV7q+NkvgJAeLDrQp6ZwxEvP7qn2CRvSQ5
   c=;
X-IronPort-AV: E=Sophos;i="6.08,262,1712620800"; 
   d="scan'208";a="415435616"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 17:59:32 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:64698]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.151:2525] with esmtp (Farcaster)
 id a92c4f05-8ddd-4534-b9e4-baab03ee6158; Mon, 24 Jun 2024 17:59:31 +0000 (UTC)
X-Farcaster-Flow-ID: a92c4f05-8ddd-4534-b9e4-baab03ee6158
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 24 Jun 2024 17:59:31 +0000
Received: from 3c06303d853a.ant.amazon.com (10.106.239.13) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 24 Jun 2024 17:59:27 +0000
Date: Mon, 24 Jun 2024 10:59:20 -0700
From: Andrew Paniakin <apanyaki@amazon.com>
To: <pc@cjr.nz>, <stfrench@microsoft.com>, <sashal@kernel.org>,
	<pc@manguebit.com>
CC: <regressions@lists.linux.dev>, <stable@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>, <abuehaze@amazon.com>, <simbarb@amazon.com>,
	<benh@amazon.com>
Subject: Re: [REGRESSION][BISECTED] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
Message-ID: <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 19/06/2024, Andrew Paniakin wrote:
> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> released in v6.1.54 and broke the failover when one of the servers
> inside DFS becomes unavailable. We reproduced the problem on the EC2
> instances of different types. Reverting aforementioned commint on top of
> the latest stable verison v6.1.94 helps to resolve the problem.
> 
> Earliest working version is v6.2-rc1. There were two big merges of CIFS fixes:
> [1] and [2]. We would like to ask for the help to investigate this problem and
> if some of those patches need to be backported. Also, is it safe to just revert
> problematic commit until proper fixes/backports will be available?
> 
> We will help to do testing and confirm if fix works, but let me also list the
> steps we used to reproduce the problem if it will help to identify the problem:
> 1. Create Active Directory domain eg. 'corp.fsxtest.local' in AWS Directory
> Service with:
> - three AWS FSX file systems filesystem1..filesystem3
> - three Windows servers; They have DFS installed as per
>   https://learn.microsoft.com/en-us/windows-server/storage/dfs-namespaces/dfs-overview:
>     - dfs-srv1: EC2AMAZ-2EGTM59
>     - dfs-srv2: EC2AMAZ-1N36PRD
>     - dfs-srv3: EC2AMAZ-0PAUH2U 
> 
>  2. Create DFS namespace eg. 'dfs-namespace' in Windows server 2008 mode
>  and three folders targets in it:
> - referral-a mapped to filesystem1.corp.local
> - referral-b mapped to filesystem2.corp.local
> - referral-c mapped to filesystem3.corp.local
> - local folders dfs-srv1..dfs-srv3 in C:\DFSRoots\dfs-namespace of every
>   Windows server. This helps to quickly define underlying server when
>   DFS is mounted.
> 
> 3. Enabled cifs debug logs:
> ```
> echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> echo 7 > /proc/fs/cifs/cifsFYI
> ```
> 
> 4. Mount DFS namespace on Amazon Linux 2023 instance running any vanilla
> kernel v6.1.54+:
> ```
> dmesg -c &>/dev/null
> cd /mnt
> mount -t cifs -o cred=/mnt/creds,echo_interval=5 \
>     //corp.fsxtest.local/dfs-namespace \
>     ./dfs-namespace
> ```
> 
> 5. List DFS root, it's also required to avoid recursive mounts that happen
> during regular 'ls' run:
> ```
> sh -c 'ls dfs-namespace'
> dfs-srv2  referral-a  referral-b
> ```
> 
> The DFS server is EC2AMAZ-1N36PRD, it's also listed in mount:
> ```
> [root@ip-172-31-2-82 mnt]# mount | grep dfs
> //corp.fsxtest.local/dfs-namespace on /mnt/dfs-namespace type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.11.26,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> //EC2AMAZ-1N36PRD.corp.fsxtest.local/dfs-namespace/referral-a on /mnt/dfs-namespace/referral-a type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.12.80,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> ```
> 
> List files in first folder:
> ```
> sh -c 'ls dfs-namespace/referral-a'
> filea.txt.txt
> ```
> 
> 6. Shutdown DFS server-2.
> List DFS root again, server changed from dfs-srv2 to dfs-srv1 EC2AMAZ-2EGTM59:
> ```
> sh -c 'ls dfs-namespace'
> dfs-srv1  referral-a  referral-b
> ```
> 
> 7. Try to list files in another folder, this causes ls to fail with error:
> ```
> sh -c 'ls dfs-namespace/referral-b'
> ls: cannot access 'dfs-namespace/referral-b': No route to host```
> 
> Sometimes it's also 'Operation now in progress' error.
> 
> mount shows the same output:
> ```
> //corp.fsxtest.local/dfs-namespace on /mnt/dfs-namespace type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.11.26,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> //EC2AMAZ-1N36PRD.corp.fsxtest.local/dfs-namespace/referral-a on /mnt/dfs-namespace/referral-a type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.12.80,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> ```
> 
> I also attached kernel debug logs from this test.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=851f657a86421
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0a924817d2ed9
> 
> Reported-by: Andrei Paniakin <apanyaki@amazon.com>
> Bisected-by: Simba Bonga <simbarb@amazon.com>
> ---
> 
> #regzbot introduced: v6.1.54..v6.2-rc1


Friendly reminder, did anyone had a chance to look into this report?
