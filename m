Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E51A2628D;
	Tue, 30 Sep 2025 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759241823; cv=none; b=ODJPHI3d3rsCcS2/AcISK9tlSE0uIt9t9AHAYD/NhuYGN3SHG/NwA8yIEaMLD64qvoxsAQKUbmAA/x3KOq5iv/1K00HOv92R8AKOtb1/HeJbFtteCOHY0wZsgcvB72fknXTsVr8P2IjN8DNfleJkGB/Q5yu2ZqMCIc+Yd56eJ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759241823; c=relaxed/simple;
	bh=6d/4bFwswWm48/ncRnHTzPTOPZm44oBy0/a6SmLuzzg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ipPaECAUX4M2wu8UrtIWMui25l+qZkj2eglgUdI8TFin4p6Zi0tbmRZR1xgyvMQA5cyhq2RLwJthSh1/8+2cPRepOJcS0F0MWCrQekxbf6IwxPgU+qtDO16yFRCMehntzn9B5JhYGWeeabTc3taldDX2gze4+haiFx0A7Pa9MdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id AF61D5AE95;
	Tue, 30 Sep 2025 16:08:39 +0200 (CEST)
Message-ID: <46c59609-032d-4148-8c19-bf7106c4fa34@proxmox.com>
Date: Tue, 30 Sep 2025 16:08:38 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] smb: client: transport: avoid reconnects triggered by
 pending task work
From: Fiona Ebner <f.ebner@proxmox.com>
To: linux-kernel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, bharathsm@microsoft.com, tom@talpey.com,
 sprasad@microsoft.com, ronniesahlberg@gmail.com, pc@manguebit.org,
 sfrench@samba.org
References: <20250915151950.1017597-1-f.ebner@proxmox.com>
Content-Language: en-US
In-Reply-To: <20250915151950.1017597-1-f.ebner@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1759241298137

Ping

Am 15.09.25 um 5:19 PM schrieb Fiona Ebner:
> When io_uring is used in the same task as CIFS, there might be
> unnecessary reconnects, causing issues in user-space applications
> like QEMU with a log like:
> 
>> CIFS: VFS: \\10.10.100.81 Error -512 sending data on socket to server
> 
> Certain io_uring completions might be added to task_work with
> notify_method being TWA_SIGNAL and thus TIF_NOTIFY_SIGNAL is set for
> the task.
> 
> In __smb_send_rqst(), signals are masked before calling
> smb_send_kvec(), but the masking does not apply to TIF_NOTIFY_SIGNAL.
> 
> If sk_stream_wait_memory() is reached via sock_sendmsg() while
> TIF_NOTIFY_SIGNAL is set, signal_pending(current) will evaluate to
> true there, and -EINTR will be propagated all the way from
> sk_stream_wait_memory() to sock_sendmsg() in smb_send_kvec().
> Afterwards, __smb_send_rqst() will see that not everything was written
> and reconnect.
> 
> 
> A reproducer exposing the issue using QEMU:
> #!/bin/bash
> target=$1
> dd if=/dev/urandom of=/tmp/disk.raw bs=1M count=100
> qemu-img create -f raw $target 100M
> ./qemu-system-x86_64 --qmp stdio \
> --blockdev raw,node-name=node0,file.driver=file,file.filename=/tmp/disk.raw,file.aio=io_uring \
> --blockdev raw,node-name=node1,file.driver=file,file.filename=$target,file.aio=native,file.cache.direct=on \
> <<EOF
> {"execute": "qmp_capabilities"}
> {"execute": "blockdev-mirror", "arguments": { "job-id": "mirror0", "device": "node0", "target": "node1", "sync": "full" } }
> EOF
> 
> Another reproducer is having a QEMU virtual machine with one disk
> using io_uring and one disk on CIFS and doing IO to both disks at the
> same time.
> 
> I also got a reproducer based on liburing's examples/io_uring-cp.c
> which I can send along if you are interested in it.
> 
> 
> Fiona Ebner (2):
>   smb: client: transport: avoid reconnects triggered by pending task
>     work
>   smb: client: transport: minor indentation style fix
> 
>  fs/smb/client/transport.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 


