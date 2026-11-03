Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745027;
	b=QvXMGJ9VOJR/Z0K1L9bPPkIeAWVU1+NtGV5pD4IO+w3fpery3v9NOLKOkwr23X6xnZI0
	 L5FMi24WunR9dd+p94OWUR41XBNUP3kQeaS7kROHvwtjvwTgtQ2PuQJAjXjjqDrfxkge/
	 QV1dug2UsVQPWOV2WF2NrGyynHYGstAtTfRj2NRyPM1DrE0lrfepvCRLwMfsyvkKo1j3T
	 /CbMjlsV+LI+EfY8d351jUakJkTAgdmVEV1DwonqXUeKOpVvB5tGV6KyLgTa59sYjhQrv
	 bX+hDoIOEg3EdrxWtS+48LY5icmn4YpAfX5VNVc/rEJXEQ2EyBOL3o+OVMDeXbPsPmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745027;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=/BBJbHNuCzH9XMQPoUzObGQyqovbapp1IjYMxTg0ZN0=;
	b=AMrjjDFIlXIsItSMivxNeCdc9R/W1EsHrIXN8ZyPKUIi9JwVNpfjwRfr8LF0qziXo9aH
	 bQDIATUa4fmgfL+mnMQJNCGbGwlioojoDbRYuumQb1CXFpBsUMCXYUnOXbctZGqTHbqjV
	 K4fFXPNw8ehjPQBWLFBH6Q/dgQNb6ZAVk60BO7Y9azdGlMhC4AYymlR+Qk1avbWnM+3Hx
	 2XYVk1GpBr8PpijLnehGii79A2uTn4ZpV5E6bbMvKzd8NmJ3TgoxL56TgtUlvdhw2CsdE
	 n+qOo/KUxFBQIwBePfrCo+fGBGDvuH8GeV2Z402aNncJxUIV4wnTYQ9Cy2EfABSdAQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=U7CaRO+S;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8C9606A32E;
	Tue,  3 Nov 2026 22:30:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D8C9606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=U7CaRO+S
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/BBJbHNuCzH9XMQPoUzObGQyqovbapp1IjYMxTg0ZN0=; b=U7CaRO+SVKe9zn6okHvZF6Nmpv
	jslxzwcpnwPAmChHGP9EZDgci6NVkgxNBS/fImEI6j/DDPk1mjYgTB4MJuUEmNnDEDgE3C0DMfpR2
	QETekCMUkSQxJ5zAmqdLKj3oGKTVt3PLFSUllqqr3geBmAvRsB+54VYr8PnAuwSVUfUnmRpboiAu/
	YXow4LLxrnDlkb5PGdzjoeyQtAUK4+KsNRuvXaZewZ8xUOOrWEU7IIHCoXxD32Bw6IDxsTGOzBcrS
	lXoSq1DXWpdOzQ7kVqtMa03aZ0WYkAMEKR8u2LhYcEF6ONrBTZOMDQbnJSRut1ZnSogcyjq250A31
	CnytkYYA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xON1H-00000000kDC-0Mxv;
	Tue, 03 Nov 2026 19:30:20 -0300
Message-ID: <7bd9007e90f271821114f617fda2c1ee@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>, Sasha Levin
 <sashal@kernel.org>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, wozizhi@huawei.com,
 lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
 glaming@microsoft.com, linux-cifs@vger.kernel.org, apais@microsoft.com,
 rlmenge@gmail.com, hargar@linux.microsoft.com
Subject: Re: [PATCH 6.6.y] smb: client: fix busy dentry warning on unmount
 after DIO
In-Reply-To: <CAE5sdEi4GOXeVDPEUk-RR7bjE8z=25f+waQNedMQd6VCum3TrQ@mail.gmail.com>
References: <20261102201410.55089-1-sidchintamaneni@gmail.com>
 <2026-11-03-1-daily-reply-0011-re-smb-busy-dentry-dio@kernel.org>
 <CAE5sdEi4GOXeVDPEUk-RR7bjE8z=25f+waQNedMQd6VCum3TrQ@mail.gmail.com>
Date: Tue, 03 Nov 2026 19:30:19 -0300
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

Siddharth Chintamaneni <sidchintamaneni@gmail.com> writes:

> On Tue, 3 Nov 2026 at 06:52, Sasha Levin <sashal@kernel.org> wrote:
>>
>> > commit 75f5c412fa867efa0bf9b646bffe0d912109e84a upstream.
>> >
>> > Kernel 6.6 predates the netfs I/O request conversion and instead splits
>> > I/O across three reference-counted structures that each hold a
>> > cifsFileInfo reference
>>
>> This is a hand-written 6.6 adaptation of 75f5c412fa86 ("smb: client: fix busy
>> dentry warning on unmount after DIO") rather than a cherry-pick, so I need an
>> ack from a cifs maintainer (Steve French or Paulo Alcantara) on the list before
>> queueing it. 6.1 also has 340cea84f691 and the same bug; please send a 6.1
>> variant too.
>>
>
> CC'ing Paulo Alcantara's correct email for review. Thanks!

LGTM.

Acked-by: Paulo Alcantara <pc@manguebit.org>
