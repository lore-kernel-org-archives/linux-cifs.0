Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4657B1D88A6
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744297352; cv=none; b=uKuN28W9LLiBFr1PSP/3VwW8Ucc8elLnXdsut93mTW6pjrBADAKEZZh51MoEG9kWRx2Y19/Bzx1iLWOX8CipdRpJtHiEETSM6FjSQlAl1viBkjVOt1I2o1VS6UsAOqHt4AvTF4bNU4cTOfmpvi+iRpbYpTdrCJ7W8TGZrWGNQwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744297352; c=relaxed/simple;
	bh=MeqDpneSj5GuXh1uibcbAuj2zRk9kDLvMGZaCdCzQlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PphB15+gy8abnTjiV3L8/aVys4Ukl//8k812Q4lOal4XHd1pHR8NQYXUeFd9Rez01+poXR7Frk9Bc+G667dHTQMnHPoaZvZ05NmnsM2YxRdr2QISmDaqvhMkPnUV2UKePzbFXSXjhK6t8S5lyxSX4eHRi4d6q6IZksAtWVkTp08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1ufWrTx7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1ufWrTx7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=UwLvtdGW0+sL/zbgtCjIPaBj4FugKsVwphwbmdxGHtE=; b=1ufWrTx78bPwf3jKa0YdRu8GRl
	HicTdbiqeViH3i+ZiDXYymJL5aHDE5lOA0J/6COzwW7/ajsUIABtJ4CYH035vrMgEbnwU4QLcUosv
	qffkTpA9jQ0I3jTLWXQRG51B3XrIDvu4dw4dBArLtFt3vP3oZLd1j0JSaQ6LMq3ccOE2M6stE3iRF
	ZAzicV7O+TOgPXtp0Dbx/HslbBQ3PKM7NFPo9MYv0V3rCGhYnTwtCpTf2JKapbQWPXxXAm0isqY4d
	10tfIyLPdcJ67v8UY5q7He97hBEChLaPBZRzSEURqkfYYJ9BB39mBwF6thCIpaF3O/OvHBuzt1r7I
	1hQvw6oo/ZQLKPEvXsIrn3dZetIRYARPCe/C+8iWE3gwVvOqW74GQvLDBXiGcQ9Ro8Pknaax3YUK0
	gOOLoHMZj2CeFFLQ1K6IHA2447irkgXQc7pHiN9iOpwiiTysNTkT9Ny3W9tdgOODOsWaO+urUaGU+
	h+ob2Ey28p1Z8bzb5Fr4LEEO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2tQ9-0098HC-1s;
	Thu, 10 Apr 2025 15:02:26 +0000
Date: Thu, 10 Apr 2025 08:02:22 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	Tom Talpey <tom@talpey.com>,
	Steven French <Steven.French@microsoft.com>,
	"vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
Message-ID: <Z_fdfszysLKt4Xij@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <Z_b4DS3kOpbCI4pG@jeremy-HP-Z840-Workstation>
 <9f7da486-5d85-4ef3-8fcf-14b408d78700@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9f7da486-5d85-4ef3-8fcf-14b408d78700@samba.org>

On Thu, Apr 10, 2025 at 10:33:54AM +0200, Ralph Boehme wrote:
>On 4/10/25 12:43 AM, Jeremy Allison wrote:
>>Does Windows ever send FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE over
>>the wire ?
>
>No, it's local only, cf MS-FSCC and the thread "SMB2 DELETE vs UNLINK" 
>on the Linux cifs mailing list.
>
><https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/4718fc40-e539-4014-8e33-b675af74e3e1>

OK, but does the Windows SMB3 server filter it out ?

Can a Linux client send it over the wire and does
it have the desired effect ?
