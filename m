Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794952901;
	b=5s7ybsZ6T4Tc3s2FD4trBrGEMmqQ2HBsagIJqRZM1l7hIKAGe3cpZjvolr3F5IAv+ACE
	 oZCApKlFSslczbJQBJMx5zGqSvBJkG4LBL6OkCrUiVgfKiDOusIgFnBWnWT0Tpl4eAcLV
	 7gq1PiDUyKwHelgUQvEruUPcnZuiezTtDpxkhva8fMuZYIKZPtTPT/onx3DwihzZ8PZ6/
	 lc4WtzRXhD3LPGTaPUF9aDfFhn00nXZy/Wmsamjor2+l8gVpRXjgkFJ/6+NKIGZZ1A+GC
	 t18DsQCIaSPTu0lLbJq7TDX8rZz3SsRy9Cco0pOc1ZSENgGVFicw+I+8hI1GXh07gSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794952901;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=4cbf2Owog0hDBZ76HilEt6qXHX410lWcKJL5m0X+4Qo=;
	b=5O+Zo5nuXvwozmRPQGOixbsq88I471vMTaBuQXHwDK2vhy503lKhbFvA567AJ5LgsP7n
	 iwSKVq93l9Pw/KboqQazN4MFKDhJnRhg2nwI+nPuyc1zQj043tGngyabiOHG/oEguH1HY
	 wpole82KZN5dOl9L7m1ib9HLaz5qeJHiLU0T2MYpXJiSh5qaWKd+BOlOQKhNuKELkk4PG
	 UeyZhYW+bL+jvDctNla4Xs9sM6NJZ3bPSq7jMaruzyVEBPR1TwY+d9CzV/FYAma1rxV8y
	 03fPvAY2pGeiSyRqGcCAlrbuBuWbb4pq9L9AlisqNYCe7mD44bbri0THFB3HaNY663Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="RDJgaK/a";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC67606A32A;
	Tue, 17 Nov 2026 22:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DC67606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=RDJgaK/a
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4cbf2Owog0hDBZ76HilEt6qXHX410lWcKJL5m0X+4Qo=; b=RDJgaK/asHf65ZZ1Ft8yqxQi4l
	7tPzI2n5j+JvXfBgNT2xv8n255s6YFT+uBip2nqwCV5PmjXd9qdulWsJ7g9N+XHVz4YPav/edovhT
	tqxDWu1ve2O3NGKmYI7obcGoxDNHMkEtL4ZYCjF9WZpbwCEGROCn1DRRXZVDODLRyUdBjjh0foLRg
	ctH7BJajeWWJlXg6AyiYVLGrhsS6DZvmujjJ3g+/P2cITEmCbMwsv2BNPkyKPHV8cOVonf6NSiVC9
	+tR9a0MZ3UmDjPb3ZDKzBQkybTi0swovp9XcblholrIga77HBL5QMgzFIoNor3W8Q4oj66aSlIbpX
	lHevR5pA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xTRF7-00000000E39-2UW4;
	Tue, 17 Nov 2026 19:01:33 -0300
Message-ID: <aefc2a49baa1c3c1b153757612d2503a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: koraynilay <koray.fra@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Hyunchul
 Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, koraynilay <koray.fra@gmail.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: fix negative timestamps being read from smb
In-Reply-To: <20261112111637.184045-2-koray.fra@gmail.com>
References: <20261112111637.184045-1-koray.fra@gmail.com>
 <20261112111637.184045-2-koray.fra@gmail.com>
Date: Tue, 17 Nov 2026 19:01:33 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

koraynilay <koray.fra@gmail.com> writes:

> When reading a timestamp before epoch 0, cifs converts it from NT format
> to Unix format without normalizing it, leading to the nanoseconds field
> to be used as a negative number, which leads to a garbled stat command
> output.
>
> This bug also violates a struct timespec64 invariant, as documented in
> the set_normalized_timespec64() kernel-doc:
> [...]
>  * Note: The tv_nsec part is always in the range of 0 <= tv_nsec < NSEC_PER_SEC.
>  * For negative values only the tv_sec field is negative !
>  */
>
> Reproducer, with /tmp as the local filesystem folder exported as [test]
> in ksmbd.conf and /mnt as the smb folder mounted with mount -t cifs:
>
>   mount -t cifs //127.0.0.1/test /mnt -o username=user,password=pass
>   touch -d "1969-07-20 20:17:40.123456789" /tmp/test.txt
>   stat -c "Server local (/tmp):   %y" /tmp/test.txt
>   stat -c "CIFS client  (/mnt):   %y" /mnt/test.txt --cached=never
>   smbclient //127.0.0.1/test -U user%pass -c "allinfo test.txt"
>
> which prints (stat output is garbled because of negative value):
>
>   Server local (/tmp):   1969-07-20 20:17:40.123456789 +0000
>   CIFS client  (/mnt):   1969-07-20 20:17:41.()*+,--00 +0000
>   altname: TESTT~K6.TXT
>   [...]
>   access_time:    Sun Jul 20 20:17:40 1969 UTC
>   write_time:     Sun Jul 20 20:17:40 1969 UTC
>   [...]
>
> Fix this by using set_normalized_timespec64() in cifs_NTtimeToUnix().
> ...

Applied.
