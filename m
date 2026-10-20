Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792469180;
	b=sHJI08ZR0BPoeMMt6NmEXZUa5sJjDZmEIvcn0I+c7cPHN+J0TVTIjNLFraZS1u2YmKLV
	 Pq+BQOeG0zSsh17xE8oZhTqduREe2Dn/ZB0ma8GLmr89nKz5rW1JdqL5Vu283GrLEGHZ0
	 Cesk96EBbqQ9eqJAZc98qERUotnlF/7Vt7ERyi8Xsgifixn4YenkTqYLsysIK+ek2f329
	 JIkCdF4ub1WfqHlRc376TYrdkK5dyVpzmsjcoR43TCr9Jzxse8rQ7WD/kzKYjq6fdO6kj
	 nGiY+e3vqu7tBDnXqJMBe8H7yULsAYlcvRfDQ/bTnIdTpH5Op+WQYoFZspiKZoAwzzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792469180;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=SlOD94vw3nOguvDcfYjJPVgYa5a7mmw0vwci1C2QK9o=;
	b=QRme+W34P79LYnOoJhrXdSm8NIl9+2MQGqRHHmMjXrcZUwqLdmCOQk9RQ/40IfAZsHwH
	 hd5wAD8CQZgHf8Y2LHEB7wMfoTwXB0+7br4vOX3RqvIERlYk0wTQ0LByLLRkYEVXNLsYI
	 281+YG8AZ11MNT29fzCwlOMkAGkdePsHGxQz+apCK15WGsrUzNOm3Q7IoijkWA00TODPH
	 HE42KFzWvJe6GYeI/H3kjs5o90JJbabGcOIzZi69ed8JEGFEFbScvbtE7gMRymV55KnvA
	 kt7yfm0HfHGBKLxPS8wYRXPWiFiolUWiXyoLoc0TzpyJ3Z3Ls3VO7NgAbmm/1pxJhyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=CAN530zE;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D97606A31E;
	Tue, 20 Oct 2026 04:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09D97606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=CAN530zE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:To:From:Message-ID:Sender:Cc:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SlOD94vw3nOguvDcfYjJPVgYa5a7mmw0vwci1C2QK9o=; b=CAN530zE09lhCPEh0rcTUl+pxN
	GvyJwxeYjEmFNgBSkj1QrB1ztFkRGpTwDdyw4781owZq+Zc9qFLVxIFd9PRNMa98GJP076sNaIeg/
	aRUDgQcNX4Xsuv2r3tuD/X1RyvceFLd2eW42gBacslkapRkPuijp7S+h/E9op4UqtmAN6TXD7R+t6
	NZbPmFhdThSvOqxqqn2OLd3/k4a2B0chbyQIsIb1nwqqGYec21tZwHPpIF+dij8mxGOv01CBVJ67O
	oG4+guZYN3nPQnD91RNixOL6trNg4fVKLpWfc6fWfyiiY8H8UCr1M0At3FSvJn7DD4/HTZcnjsxz5
	kiRM6sfQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xJ171-000000042Et-3NqD;
	Tue, 20 Oct 2026 01:06:07 -0300
Message-ID: <8bb0534e33a5f5d152d2b1768d1fd7c6@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: syzbot <syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com>,
 bharathsm@microsoft.com, linkinjeon@kernel.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ronniesahlberg@gmail.com, samba-technical@lists.samba.org,
 sprasad@microsoft.com, syzkaller-bugs@googlegroups.com, tom@talpey.com
Subject: Re: [syzbot] [cifs?] KASAN: slab-use-after-free Read in
 cifs_crypto_secmech_release
In-Reply-To: <6ad6be63.a20cb897.960b0.0079.GAE@google.com>
References: <6ad6be63.a20cb897.960b0.0079.GAE@google.com>
Date: Tue, 20 Oct 2026 01:06:07 -0300
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

#syz test: git://git.manguebit.org/linux.git cifs-fixes
