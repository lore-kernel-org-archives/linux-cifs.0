Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EB323D7FC
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770046607; cv=none; b=Gtc270ICRpROXAcd2iF/V9wIo8RdE8uZFPgss49hxdzd1zhW+XuVqKVNjI7LhhwTGV1SqC/Fhdlli91wW7qGVaX/iX/ebuVOrPdpQpAyfxRhJNvqdr4QxHm4QoFkCB4KkOgoLPUz0UKWopHNBnq/dkrR3HDp0RlbSt2opXmK/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770046607; c=relaxed/simple;
	bh=qlNk8ojwP0MssfhDAiHXZdQFjsaKcZHQtOZZw/Elf70=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=cqSUlcA80sgdaCQeEx05qrpBewvXYG377BFFA+Ib/DhyKpRzfD4IjsDsoFXi+SSJplqiEwVoMesgTnTn5OlcHkhKp/lbnLJQ7tlc63X+KO1Nmf9g13rZoQKEb1nbv1PKi45f6s9MRPyIcCxxtScOk6Rdhsp64HQ2qQo9V2XDIRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ar7NVcLL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ar7NVcLL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770046605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+F9+bHd6Yhoz/AsFmijV0059CVfi5HbASDRf60esP9A=;
	b=ar7NVcLLe4jcXrx9obvVgvgRXniy1cwKgqcFbNKmRH5Bg1CDHb/QB7oU/j/JByrtL06qAE
	z4SRYc03BOf/t5dCNHw9xExu1aTC0qyx1BeK44L+w91qEnJKHw1n+VAteyUgB0hQqGVAgr
	7J58/mKy9re0M1gvFMHo+iqiaIt5KFw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-Iku8EnGQNKOg7kLMgLlTrw-1; Mon,
 02 Feb 2026 10:36:38 -0500
X-MC-Unique: Iku8EnGQNKOg7kLMgLlTrw-1
X-Mimecast-MFC-AGG-ID: Iku8EnGQNKOg7kLMgLlTrw_1770046596
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFCB4195605A;
	Mon,  2 Feb 2026 15:36:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07A401800577;
	Mon,  2 Feb 2026 15:36:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260202094906.1933479-2-chenxiaosong.chenxiaosong@linux.dev>
References: <20260202094906.1933479-2-chenxiaosong.chenxiaosong@linux.dev> <20260202094906.1933479-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    nspmangalore@gmail.com, henrique.carvalho@suse.com,
    meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, pali@kernel.org,
    linux-cifs@vger.kernel.org,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v3 1/1] smb/client: fix memory leak in SendReceive()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2462952.1770046588.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Feb 2026 15:36:28 +0000
Message-ID: <2462953.1770046588@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

chenxiaosong.chenxiaosong@linux.dev wrote:

> From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> =

> Reproducer:
> =

>   1. server: supports SMB1, directories are exported read-only
>   2. client: mount -t cifs -o vers=3D1.0 //${server_ip}/export /mnt
>   3. client: dd if=3D/dev/zero of=3D/mnt/file bs=3D512 count=3D1000 ofla=
g=3Ddirect
>   4. client: umount /mnt
>   5. client: sleep 1
>   6. client: modprobe -r cifs
> =

> The error message is as follows:
> =

>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shu=
tdown()
>   ----------------------------------------------------------------------=
-------
> =

>   Object 0x00000000d34491e6 @offset=3D896
>   Object 0x00000000bde9fab3 @offset=3D4480
>   Object 0x00000000104a1f70 @offset=3D6272
>   Object 0x0000000092a51bb5 @offset=3D7616
>   Object 0x000000006714a7db @offset=3D13440
>   ...
>   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x379/0x3f0, CPU#7: m=
odprobe/712
>   ...
>   Call Trace:
>    <TASK>
>    kmem_cache_destroy+0x69/0x160
>    cifs_destroy_request_bufs+0x39/0x40 [cifs]
>    cleanup_module+0x43/0xfc0 [cifs]
>    __se_sys_delete_module+0x1d5/0x300
>    __x64_sys_delete_module+0x1a/0x30
>    x64_sys_call+0x2299/0x2ff0
>    do_syscall_64+0x6e/0x270
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   ...
>   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when ca=
lled from cifs_destroy_request_bufs+0x39/0x40 [cifs]
>   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x142/0x160, CPU#7=
: modprobe/712
> =

> Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b=
21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> Fixes: 6be09580df5c ("cifs: Make smb1's SendReceive() wrap cifs_send_rec=
v()")
> Reported-by: Paulo Alcantara <pc@manguebit.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reviewed-by: David Howells <dhowells@redhat.com>

