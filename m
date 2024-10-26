Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0682CB641
	for <linux-cifs@vger.kernel.org>; Sat, 26 Oct 2024 13:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729949115; cv=none; b=Jk60f+KxU8GKWJFIR8vbJy2ZK6hCf4le5EzRvKGdcEWmIpFFTXx16i56ORCC3MTyCaZhbpS4hFlBPEaG2QTAtUn4cS4pSMa2HKe3t8xbW4dTcqSj/SlR/CSth/zlAcUmXjd0FJ1aeIVKwHXJQVc/I7iP+tJdB7YNr6hSf83tNtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729949115; c=relaxed/simple;
	bh=EVH5AmLyIJTUAQi/DtTAVyPZL9dwmXNAwzDFZjhuo5g=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=gjVwGHAG3WGqBdK4tnoPJ4AAz+zcckCG/BUHst7jO8//GOuUFhm8LmYWX/+XO2TaIEQ0sP2cSiLoPpd+1fCHKsiBxD5wLgkmqLQwSaC5myBRdJHYPrBHfh9SUYkvRtNsoUR9vGSAYZBNXu/0a5oEz27gmtWAmTe6ThK0xYobcSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=RG7QdKnX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RG7QdKnX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:To:Date:Message-ID:CC;
	bh=SuQzAOrY5jU0EqOoLvyx9X/jgsK8525Z4lV5tmIKX9Q=; b=RG7QdKnXekUm2f70RwnUQFZfEt
	MdqRNcxN5xJyo6fC0Hoes7uT1agPKD6L8ac1LT5exMNLiPCjTb+T09iXIREzWHwEBBi25YNfGvKcN
	FAEzu88fGeCpSLnilkrTnUK76d/nHZg6ixDamx4FjwBShrBFVOpyjkYW7xrOjxj79awYCedRAodwd
	PPxRc+J7FWzi+s8GDdcUEEwejHPIOlKzbPrKVX0pFI0XqDELPyrc4KEJgkch/SZmcq/GKWDShjd87
	YzkbuVCD8MSxCZ2bL3GJVNzsV3Up4XPtsNxCfUyvdocAJ6d3ByXT6xBHA5unWl4t/QYB9eE/HOzFq
	TohVouD5OGJFdNL+EDnW63p1YOqvJs29K1Iaj0AC9qXexX9MLG69u4XxJBZKpnMqlXx8Wga3NmeBq
	AeML+wMle8dEkMVqFo6U82K9QJuJMdPFxKDjansQ/7V/gqFs9TBJyv2rMRvO4/6uom7cr+WzmoqCe
	8ul79pz+KVjNX8X+nfYTyMO0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1t4gc3-006ilP-23
	for linux-cifs@vger.kernel.org;
	Sat, 26 Oct 2024 13:13:51 +0000
Message-ID: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
Date: Sat, 26 Oct 2024 15:13:50 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
To: linux-cifs@vger.kernel.org
From: Ralph Boehme <slow@samba.org>
Subject: Directory Leases
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

I have implemented Directory Leases in Samba and wanted to do a few test 
with real world clients.

Mounting with

# mount.cifs //localhost/test /mnt/test/ -o 
username=slow,password=x,handlecache

(no idea if "handlecache" is needed, found it by skimming the code)

I don't see any usage of Directory Leases on the wire when I do an ls.

Do I need to pass any additional mount options? Anything else?

Kernel version is 6.11.3-200.fc40.x86_64.

Thanks!
-slow
