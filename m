Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794072273;
	b=YpuJ9LcOytUv+oxmSZg3eUlZIZOF0alC2NH3zJ6TQFTpQkre1UOqDRrzCPGj7lPDv6YJ
	 AHPdTKJVnca0+qj5dQgipWUiyuF77aWhOZHI5968i0Tlh+uCwKpaqlvj8/M+/JXIp9EKp
	 5dMXn4/cAz2SGV4UaY+9OeK050/nvXmqE44e6Y2TP1cgUcKsiLd7t7STD++XAQlp7bzO2
	 ZMp+R4AoGvkBGkrprQWJRugw9YoRzYo9UgqMWcSTqtoKuUxKB7FXNHsusYRMSy6Yujnc8
	 hdWQfh4k5xvFinQwi6Z7lyIhXUGIDZryTrI7kSKTypojh+v9M+UMTekLhwzRbunumXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794072273;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=SPOL0FT7rZBQ4un4ld/pKpMxsIgQgOIWYBuwtPXOli8=;
	b=QSqRwpI+keIWTcreqIlCH2uV27Ocm3bsRt2rJXT8oYtoxUHAXRUG0GDul3+vtAiBoWXG
	 yTDzleCSoGRi/CY8Eq/MaC6Zz++lYXcho9vkGpAekwlFnnrbHtjY28c6Oali1oYoeCNp3
	 1slwDwnFOAj3tPN68HqasGNJ9WgZ1dbC64Hh+oBNDafE88ShMwo0eeEmTQrQcRrLpXLUK
	 TfYR5m0JTd9rIjcA5cYUYBRuDVDp2bRgk3pPLRGNX1CLFM7rurxVycMI/XtOc90TtS8my
	 4j05gb5LyPb0SA7iKIw289FpUPxg5A1g+dC2VSM3ocx6XbB16T/eYXGv2nTBwNeCc1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=UnOSovKh;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EC2606A326;
	Sat,  7 Nov 2026 17:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30EC2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=UnOSovKh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SPOL0FT7rZBQ4un4ld/pKpMxsIgQgOIWYBuwtPXOli8=; b=UnOSovKhYybiO0e6m70k7k/Kv2
	e5OomIEHaD7V+8iHWX6k4VTVqsA2TQubTvqew4E4kcX9ctKVN003qVuJXoJqYFU572kAAkzmxuGUC
	Gmn1UzwwV/xYao0tIBA12ofetjbJX3fMIvr/bvZ4/cOGllSwVVeMLmbbNtmwnST8OtXKONV3dKd7A
	w1UOll+GcINl9lK2o0YMCEwON9XvD5wYmjj98+DYkyC3BjB2+knoEdH9kB/lY6ni6914OdIwSKS3T
	aVYd/jOMDkpf2ohBcD3uSFbTCMiFmumJvXkUxTvQyr88QHX5mXevk1dTHWNJ9VCNhkMmPjarRwqzd
	E5eRP1qQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPk9R-000000017pW-2wNK;
	Sat, 07 Nov 2026 14:24:26 -0300
Message-ID: <3f65be10a84fca4ecada2db56213c80b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Yifan Zhang <yfzhang23@stu.pku.edu.cn>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Steve
 French <sfrench@us.ibm.com>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] cifs: bound invalid NTLMSSP signature diagnostic
In-Reply-To: <179367391951.8187.8527449085887136856@stu.pku.edu.cn>
References: <179367391951.8187.8527449085887136856@stu.pku.edu.cn>
Date: Sat, 07 Nov 2026 14:24:26 -0300
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

Yifan Zhang <yfzhang23@stu.pku.edu.cn> writes:

> The NTLMSSP Signature field is an eight-byte binary value and need not be
> NUL-terminated. decode_ntlmssp_challenge() prints it with %s on the
> signature-mismatch path, so the diagnostic can continue beyond the received
> blob until it encounters a zero byte.
>
> KASAN reports:
>
>   BUG: KASAN: slab-out-of-bounds in string
>   Read of size 1
>   string
>   vsnprintf
>   _printk
>   decode_ntlmssp_challenge
>
> Print the fixed-width field with the bounded hexadecimal format.
> ...

Applied.
