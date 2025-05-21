Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D061A288
	for <linux-cifs@vger.kernel.org>; Wed, 21 May 2025 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747851356; cv=none; b=PgJwir71uLLisu9irMEzlxnADCcg5JrVkrJZiESnFDDaHyStgc7QWHogA0Fm9+dPs9/lJ1/5+Yqoc5Geq0shhYmMkT/urmKEIykcv2WI0Hw2EnALuJGuw2tybi8Dp4WClnSqivBmpn0yknx7jpS6Bdv1bzpIp3/pCw5bZWHMhpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747851356; c=relaxed/simple;
	bh=anm5RzVUWKKqKHNMajALfMxUCyyODeOtqUpS8uXBphg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=pNFgPEPYqMbXmOa0zsZ95oCAVHUj6foSyKlYuN++Pa3fUma2o/RjDhNeCd62VhRnq9ZQnT6733JuQ8lfbGWlBR1B/ViCw3bL8bASP5CbIGJORrwDm2r0fpKH8ypty81GgJQgq/PLoTDy+K1YtMdQGo1CoYezNZCI6MHoWrRajXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=invypp1B; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="invypp1B"
Message-ID: <b5a2d0da7fd3f86766f3e9f0faeec7e6@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1747851347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yvm1O4MMjG2/xnCn+CSfYn8BizNqOwxcONvz01rZbvk=;
	b=invypp1B+Lod560onybBbnud8RnxMe9PguAaUJQzqbKguc+rqX1bd58++jpfGkplxjI+OO
	561Mcv5JR2Exo6XqWvNeWnjQgzcVdEFuLiuJPHrsc4owyqi+OQBqZKgrQTKccVEA6eBZk/
	NwshElVtg8A+rtyPLkZszNhkqJnCcWn0Gn7wSwB/PKEZtDfEVwi893Vdfdp+xMo7ueHCrx
	qeb09jMXsotSSWEFRip/JgOu8fMIDofU/uD9RIon/TpNpWKjpkUkn825GbHWrQKKeIxdk8
	2eyd1jNFxY//iUc6B8mQCI/LJLJMvsLGFDIe6m/gwUo/BSORvuH6NyIughwOdw==
From: Paulo Alcantara <pc@manguebit.com>
To: Johannes Berg <johannes@sipsolutions.net>, linux-cifs@vger.kernel.org
Cc: netfs@lists.linux.dev, David Howells <dhowells@redhat.com>
Subject: Re: 6.14.6: copy from cifs mount never finishes
In-Reply-To: <e5d03b84a3631ace93bb36c5cd6ba5202c11e14f.camel@sipsolutions.net>
References: <50815dea489f26cf2c8d34162d8be5f0a7d3465e.camel@sipsolutions.net>
 <e5d03b84a3631ace93bb36c5cd6ba5202c11e14f.camel@sipsolutions.net>
Date: Wed, 21 May 2025 15:15:41 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Johannes Berg <johannes@sipsolutions.net> writes:

> So I'm on 6.14.6 on Fedora, trying to copy a few relatively small files.
> I went to lunch and when I came back it still wasn't finished, and the
> first file was just growing and growing in size ...
>
> The filesystem was mounted with just
>
> # mount.cifs -ouser=<user>,dom=<dom> '\\server\share\some\deep\path' /mnt
>
> The server is some Windows server, I think, our IT runs it. Probably not
> Azure since it's an internal IP address.
>
> I also have a pcap now, but I'm not going to post it to the list.
>
>
> Reproducing it, I see:
>
> $ ls -l /mnt/dmesg_log.txt
> -rwxr-xr-x. 1 root root 271261 May 13 13:00 /mnt/dmesg_log.txt
> $ strace cp /mnt/dmesg_log.txt /tmp/
> execve("/usr/bin/cp", ["cp", "/mnt/dmesg_log.txt", "/tmp/"], 0x7ffcae506680 /* 85 vars */) = 0
> ...
> openat(AT_FDCWD, "/tmp/", O_RDONLY|O_PATH|O_DIRECTORY) = 3
> newfstatat(AT_FDCWD, "/mnt/dmesg_log.txt", {st_mode=S_IFREG|0755, st_size=271261, ...}, 0) = 0
> newfstatat(3, "dmesg_log.txt", 0x7ffdcacac290, 0) = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/mnt/dmesg_log.txt", O_RDONLY) = 4
> fstat(4, {st_mode=S_IFREG|0755, st_size=271261, ...}) = 0
> openat(3, "dmesg_log.txt", O_WRONLY|O_CREAT|O_EXCL, 0755) = 5
> ioctl(5, BTRFS_IOC_CLONE or FICLONE, 4) = -1 EXDEV (Invalid cross-device link)
> fstat(5, {st_mode=S_IFREG|0755, st_size=0, ...}) = 0
> fadvise64(4, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
> uname({sysname="Linux", nodename="jberg1-mobl2.ger.corp.intel.com", ...}) = 0
> copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) = -1 EXDEV (Invalid cross-device link)
> mmap(NULL, 1056768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1d2a6fe000
> read(4, "[ 3410.434280] iwlwifi 0000:3d:0"..., 1048576) = 983040
>
> now that's already wrong, the file is only 271261 bytes! That should
> have returned 271261, not 983040.
>
> Next that data is written out, nothing special, except when I look at
> the data, after offset 271261 it's filled up with zeroes.
>
> write(5, "[ 3410.434280] iwlwifi 0000:3d:0"..., 983040) = 983040
>
>
> It gets worse from here though, because now even the next read doesn't
> return 0 for EOF:
>
> read(4, "[ 3410.434280] iwlwifi 0000:3d:0"..., 1048576) = 983040
> write(5, "[ 3410.434280] iwlwifi 0000:3d:0"..., 983040) = 983040
>
>
> And that just repeats forever.

As we've talked, this should be fixed by

        34eb98c6598c ("netfs: Fix setting of transferred bytes with short DIO reads") [1]

I'll make sure to get it through -stable once released.

Thanks.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git #vfs-6.16.netfs
