Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B76C144D21
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728400608; cv=none; b=ZwROu/AE//s3CPf830sP4OuM3VgSYGw6kffvVdox0B2E/ne1+esPdgWAVQzSyGyasSJnk5IVmLDkC1hdjhnhlz7BHxi3BzJd5T58/zuCFu4OQjWl5dmfyZaZhZvS23FH+jFu/z/GGErB9gJUU9EKr9xv9cb21soUwd8wx8mfqxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728400608; c=relaxed/simple;
	bh=EfcEh7j3NXmVgH2RD5ed2vXLeQEMwoOnDs+PMm/nGE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnXbidzeWhFIKhmF3ekQRLOJujiFrjFqkPyU6TptuU5MR1fw/pQQWsliuOnTv7YjymL8ZNjmDMpYM9gS4uB0KQNOfVdtmS0BHZzw96uHB6qZ2t1JgllD8pyIXkfruLdlbWVc3n0V1d4WESShdeInPK1+9eMcGIzYi+DnpRGq+Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2GKrd0kI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2GKrd0kI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=e32O0NXV/VjU0tZcqVjHSltKqE5C0YTzWJ8kYHFbhD8=; b=2GKrd0kIC6b+ODicSpGDDrqgfb
	8Y2TzqPAFBFI3Fb7UQUaBuFWOrIAYtqflqZepdkEFHSWv+J/nd4Kh0ivZcF1cxdFQ6UM0KduW1Hz/
	zUiM8GZICWClPcMX6yhWGJEHF673sxnCWBoXzEhTTnRLM/ECP2RDgcszHUTMQ9ii2Rj0VpIe811NX
	0X2ysdupFsN5RMFCCpJwfAQaPyKph5bKgAxMkDFCrxlt8azfFFYvz75kV+jVS8uwV8hhsSc8TomiW
	8zh4GMyCuqDkG8PN7oGMC/NxaK54TTo1ZGgA5MGgw0EJmTM6l6Jdf1KHXKLRvNVbQr/Pq+GLgiXbB
	kQwKi2Qjxmws9EO9pC0q/Y0T9oNt4dF8X5CuLdKfxnyvHxsLiMShTl7n8P9E4I7RH+8FUs6TOaHI5
	u6jpg4ivDqoCwGBs+JQN9nHjHgcRssPYZ1nYDRc61cut8ly8HcVDWicLjzAnBGPtpD2yfBf4XmjH4
	G5VodV8eCBxWXv+UFkeLB9VH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1syBx4-003vvF-2F;
	Tue, 08 Oct 2024 15:16:43 +0000
Date: Tue, 8 Oct 2024 08:16:39 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE
 on copy_chunk
Message-ID: <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>

On Tue, Oct 08, 2024 at 11:35:16AM +0200, Ralph Boehme via samba-technical wrote:
>On 10/8/24 10:45 AM, Ralph Boehme wrote:
>>On 10/8/24 10:41 AM, Ralph Boehme via samba-technical wrote:
>>>The problem is the O_APPEND on the destination file handle.
>>>
>>>We pass that flag if
>>>
>>>         if (posix_open && (access_mask & FILE_APPEND_DATA)) {
>>>                 flags |= O_APPEND;
>>>         }
>>>
>>>Is this on a posix mount? Otherwise it seems to be the clients 
>>>fault passing FILE_APPEND_DATA.
>>
>>gah, it's an "&&", not an "||", so it's your client I would say.
>
>thinking about it, I wonder whether that condition is actually useful 
>or if we should remove it.
>
>@Jeremy (or others): mapping from FILE_APPEND_DATA access mask to open 
>flag O_APPEND seems wrong imho. Do you remember why you added it? Or 
>anyone else?

It was done as part of the SMB1 extensions - trying to "pass-through" all
possible POSIX open flags.

Just remove it.
