Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8529029B795
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 01:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785978956; cv=none; b=pOCNhEnWggFJImSBX2cnodRPoDXzSsD2hc54eBwy87yKZl+ySq8sU6bF5+snEm01W6wtrIViQnbxIFtjNJsgJQool7BDzoXPuIB8WkRNOnaRy/6XS12uznCLG1Ili8TJ2vnAwMc68vgJfbT55Bm5kOGyKERLgW1vWPr1Wl9qoqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785978956; c=relaxed/simple;
	bh=1UTP3OE1vj+QPQ3LNM9DIDoYsYAB8IHkwyCfkwFkjJ0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=d1pgWuIquIODs9eBgLYkwkSseKaQHWqKNJfrJqeAD2vjKqIxr2tF8bjll6Sarw2CslPMqv/S8lrnmHwtfOhn+lOt6TVuRG/KgW8+1BdIuaJr0BzlzVVX8Rz5hW11H35sTWxOBtbPSlcH8CyeBPhAY/OLVF45YC3t4NiJcxCambY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=6uE7EN8A; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="6uE7EN8A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zGk0aieBRAk5SMJKaHrHXgW1HkW6veAePnDjk44IDZI=; b=6uE7EN8AU2g/QOHY/HhclJVTEd
	+5XJhQiODb4dwrZHZgwa+tzvyO61LOdkW0h70YZcAU8tAAjVfZ3nWlpznvhK6sYr6JpSt/yJ9j88q
	qR2wNNelY8QqN6yrOHAV+jAPan4kNV5kqlBa9/YUt3cqi2TvrVdBSMg7/ZrTPK2M2ZEf276wMaSYB
	GvrKGGwW2sQehKT5uDM2u8qXUaa71IpcnE5F3L8gk8vI35vsggbmtCZqyyHAHhWlp3X7KIfS3Ufpb
	mchwb35GB3tw1RdJoFq4yR+XOsNWlywV/nKzMPq2bsqcCLCWxq/kukzzVYPATV/9kDZv6rS5hSX3u
	S5UxncsA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.4)
	id 1wrmi1-00000000k8p-06of;
	Wed, 05 Aug 2026 22:15:45 -0300
Message-ID: <dc3725f8e227b1dc7c1bee1189806e3f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Gustavo Nobrega <gustavofn@gmail.com>, linux-cifs@vger.kernel.org
Cc: stfrench@microsoft.com
Subject: Re: Per-entry WSL EA queries during readdir cause severe ls -la
 slowdown on high-latency links (6.12)
In-Reply-To: <20260805203900.2930456-1-gustavofn@gmail.com>
References: <20260805203900.2930456-1-gustavofn@gmail.com>
Date: Wed, 05 Aug 2026 22:15:44 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gustavo Nobrega <gustavofn@gmail.com> writes:

> I'm reporting what looks like a missing negative cache for WSL extended-
> attribute queries during directory listing. On a high-latency link this turns
> a 3ms operation into 21 seconds.

Yes - we currently don't cache xattrs.

> Environment
> -----------
> Client:  Linux 6.12.0-211.16.1.el10_2.0.1.x86_64 (RHEL 10.2)
> Server:  Windows Server, SMB 3.1.1
> Link:    site-to-site VPN between datacenters, ~76ms RTT
> Share:   FTP landing zone, 511 subdirectories in the parent
>
> Mount options:
>   vers=3.1.1,cache=strict,upcall_target=app,uid=5000,forceuid,gid=5000,
>   forcegid,file_mode=0664,dir_mode=0775,iocharset=utf8,soft,nounix,mapposix,
>   reparse=nfs,nativesocket,symlink=native,rsize=4194304,wsize=4194304,
>   acdirmax=300,acregmax=30
>
> Symptom
> -------
>   # time ls -la /mnt/share > /dev/null
>   real    0m39.031s
>
> An identical mount of the same share from a 5.10 client completes in 0.003s.
>
> /proc/fs/cifs/Stats after a single ls -la (511 entries):
>
>   QueryDirectories: 3 total 0 failed
>   Creates:        512 total 0 failed
>   Closes:         512 total 0 failed
>   QueryInfos:     511 total 0 failed
>
> Enumeration itself is 3 round trips. The client then issues a compounded
> create/query/close against every single entry.
>
> Root cause
> ----------
> smb3 tracepoints show what those per-entry queries actually are:
>
>   ls-766626 [000] ..... smb3_cmd_err: sid=0x... tid=0x29 cmd=16 mid=40511 \
>       status=0xc0000052 rc=-61
>
>   $ grep -oP '(?<=status=)\S+' trace | sort | uniq -c
>       268 0xc0000052
>         1 0xc000019c
>         1 0x80000006
>
> 0xc0000052 is STATUS_NO_EAS_ON_FILE, on cmd=16 (QUERY_INFO), 268 times in one
> listing. The client is probing for the WSL EAs ($LXUID/$LXGID/$LXMOD/$LXDEV)
> on every entry. The server has none and says so, every time, at 76ms per
> round trip.

It's not that the client thinks the files have WSL EAs.  For some reason
the query directory response doesn't seem to satisfy the client in terms
of metadata in order to instantiate those files during directory
listing.  That is why it is sending query info for each file to get more
metadata information.  The WSL EAs are queried unconditionally when
querying information about a file.  This is done for saving any
potentially additional roundtrips in case they have.

The extra query info usually when the client finds a file with a reparse
attribute set, 'cifsacl' or 'modefromsid' mount option being used,
'mfsymlinks' mount option is set and a regular file could be a potential
symlink, etc.  If that isn't the case, then the bug is somewhere else.

I'll look at the network traces sent off-list and then let you know.

Thanks for the detailed report!
