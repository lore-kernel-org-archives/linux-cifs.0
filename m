Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4FA187FE0
	for <linux-cifs@vger.kernel.org>; Tue, 29 Oct 2024 10:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730196347; cv=none; b=VFRnBK9lR4bdFGWOxFg8fpyMHCiCGVgQ03W742H0BvtU5SdsWAKCSi3mU27KNkSXrsOPkXGX+bKCxhIXcI7pwLm870AoievgUdRo6aoS8swY9Wcid8AC+FILeM/o0dV24kx0A3cJQkkEwU0foDKopFoS34dOj8tTdv8jpN4bMT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730196347; c=relaxed/simple;
	bh=i2s2dl3R2VlS3w/KNS0Fk3o80A4ySs6WINPBFPRe4Lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SR1l2v7G4XvJFoBwoK+BQuf5Eml9O+rLQIQ3JLpx9iXxOE66vgGACJa26yvNkrsk/F+rLSXLfKRCvCsKI+5swW4RkDf/F5GpI/N3kBvLZQg9sqFglDh8DQloMOJbm7EIQ4ijhDC28woStGVAwSIFrnThAe5R5EgdhlH3I3xlF0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ukqDiKsV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ukqDiKsV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=84rDE6TsX4yZfxEu/amACybLOucaBQ1dH+ahRIQ11Wg=; b=ukqDiKsVRvcRVLleUEdL2/0lMM
	7fJaMbSGeZb2QQIxYuekIMxluexjpuAwIyW66ebRhdF+qvZpt9jzHZxYHWkEWNFSSlI6sH9h+SVPf
	50DryZ4uQOcIGoFRCMF5oE6L6LyLzVyJAApzoN9cG6nAD+rWZql96ZNMSiwTUf9XA14vvyxBNhHed
	wUUsRW06CtvtD8bEWKPArV67FGhmMVDwAP86XdQ7nOMpCs7dP5m8KC5k+mHQpNLgtYYJahfNeL/Mo
	7X8aAqdFsnO8gCLEQLzCAK07NPG4WAXYUVJc74t8hjECuhgpzfsZxkwV/w91/lSg+o8ih/XMKrObC
	rC7vC7w9eT+6HvjKNz7d5oqM7NjwiSzQVY3ovubsvRIXzHVoUMuilQM5s1Qm80TXI4lT7DdbvepSA
	tRc1fS8K7mp/17o41NCSgEcBq+iKwIP4NQyzPVV9IouCOfKyKfKmK/PA/p716KQlMMdbPmIYxzLXD
	n4ekEGEKbv/i2FagIuYQCeub;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1t5j6V-0076my-1e;
	Tue, 29 Oct 2024 10:05:35 +0000
Message-ID: <6e38eeba-9a82-48f4-bfcd-a4f2ce718782@samba.org>
Date: Tue, 29 Oct 2024 11:05:34 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Directory Leases
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 ronnie sahlberg <ronniesahlberg@gmail.com>
References: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
 <CAH2r5muwuKvifnG0XK3wShCtpR6EZOEozn=H95qx9ewHDO5jdA@mail.gmail.com>
 <42c8b091-a57a-4d4e-aebf-aee57dabf5d4@samba.org>
 <CAH2r5mtr0SJHzG4tNeRA=1H1gEswQUywj0G5kR+wuoPk1r1YVA@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
In-Reply-To: <CAH2r5mtr0SJHzG4tNeRA=1H1gEswQUywj0G5kR+wuoPk1r1YVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 10/28/24 10:11 PM, Steve French wrote:
> Doing some additional experiments to Windows and also to the updated
> Samba branch from Ralph, I see the directory lease request, and
> I see that after ls (which will cache the directory contents for about
> 30 second) we do get a big benefit from the metadata of the directory
> entries being cached e.g. "ls /mnt ; sleep 10; stat /mnt/file ; sleep
> 15 stat /mnt/file2 ; sleep 10 /mnt/file"  - we only get the roundtrips
> for the initial ls - the stat calls don't cause any network traffic
> since the directory is cached.
indeed, I can confirm that some cache is used for stat. Unfortunately it 
isn't used for readddir.

Also, coming back on the issue that the client is deferring a close on 
the directory with having a H lease:

In my understanding that's at least going to cause problems if other 
clients want to do anything on the server that is not allowed if there 
are conflicting opens like renaming a directory (which is not allowed if 
there are any opens below recursively). Unlinks will also be deferred as 
long as the client sticks to its handle.

The client should acquire a RH lease on directories if it wants to cache 
the handle and that's a prerequisite in order to cache readdir.

Afair the kernel is currently caching for 30 seconds. Increasing this 
time should not be done without also having a H lease.

-slow
