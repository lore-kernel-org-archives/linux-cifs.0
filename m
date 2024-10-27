Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C495CA5B
	for <linux-cifs@vger.kernel.org>; Sun, 27 Oct 2024 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038597; cv=none; b=SzlQtCVUKnXihyj5pJ/qKJDWYTCB89OIBTf9Ja0/BxBossvl7LWTZfblTIt/OS0FQ8EjOQCK+3QmX1Y6+EsY9z2xKM9YJ5jFL7nbJBNS7x9SuNKxUC/SVVqef959RK1wPhrQlykYlczQvHb8tKxIJ6E8mo5a4JYfv248mFE6A5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038597; c=relaxed/simple;
	bh=2q4XaHYIY/SVOSF0xgfUbownSXBMozaLR0F/ym0GQo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NGg5iOSheCz60rcYrlEcQUS8myE0XJITCCQyzZCDedjT7wh8kyr0trwRha/bZtMEeqhjr8CyNHZeY5s9urh6plIxAqWsmMRX2fWi9BA+R+RP9k3GIZa/oC5Wj6zazCPfQ8K0+OtjcqKtJOpIxs56sqamdS9Q3fAFxtKVMve30qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qjGma4Sf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qjGma4Sf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=LgmgHzqJ4L9Bs/rMBobEZM9UTDn5pN0GXYENHFfOs+A=; b=qjGma4Sfm10c1+q7RRJiOvj4Ho
	BTogAaT5gwoG81yZo6z+zdeWgsv0kwxzFGk6ME2tecLoFfiVbcC6VdrsoQlWB28tBi0rR+QT6yehd
	cy8d0zmfDppADHm9fEJZtVg8VFc9jgUc5Vwes1xc7pESEdcj0KTUtsOPSQ0B8PFijR3yzbMVX9Jjx
	sXgas4lcOo0We7PceskufbCU1Baz1Wl3nrKD4UDJ4GjoLn+wHRDFd8am43a8R5Jh3NYa1/C60Vm6L
	qJHkizfQWRJPxDeYk5og8l0i6vSPWMFxOXdMuyowfJ1HuK+65pFTr8oICwX1zrDxYrCO5bnxedsn5
	VKR99FpMgLo5IWzZxHAfLka/bVK0z8u/VawyBPoz6cu/jXA25BgGZGLZN5FdpkUXl6R8kTSqU6n2Y
	3xguQdK2PefbsPcItUP6ufgMRwWURk6M8HRTY7iCV2x4FLQPO67CINGMKB00TChXtUOHkmSSQmRJ2
	DOSvFr4pmq09zwDdBFg7VPLM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1t5449-006qMF-1W;
	Sun, 27 Oct 2024 14:16:25 +0000
Message-ID: <42c8b091-a57a-4d4e-aebf-aee57dabf5d4@samba.org>
Date: Sun, 27 Oct 2024 15:16:24 +0100
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
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
References: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
 <CAH2r5muwuKvifnG0XK3wShCtpR6EZOEozn=H95qx9ewHDO5jdA@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
In-Reply-To: <CAH2r5muwuKvifnG0XK3wShCtpR6EZOEozn=H95qx9ewHDO5jdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/24 4:24 AM, Steve French wrote:
> I built and installed Samba with your recent directory lease series
> and tried some experiments with cifs.ko to it and I do see directory
> lease requested by the client and held for 30 seconds for the
> directory (or directories) that I do ls on,...

hm, guess I was not looking close enough, I rechecked and now I can see 
the client requesting directory leases and the server granting them.

Two things seem odd:

- the client only requests a READ lease without a HANDLE lease,

- the client opens a directory with R lease, does a query-info on it and 
then opens the directory a second time, without lease, and uses that 
second handle for the directory listing.

In my understanding a directory lease without H lease is useless, as it 
limits lifetime of the cache to the lifetime of the handle and you can't 
defer the close on the directory handle without a H lease.

Cf the presentation "SMB2.2 Advancements for WAN" from SDC 2011 page 20:

"Without H leases, the R lease is of no value."

open_cached_dir() seems to be the function requesting the directory 
lease and it requests SMB2_OPLOCK_LEVEL_II which is mapped to 
SMB2_LEASE_READ_CACHING_LE.

Thanks!
-slow
