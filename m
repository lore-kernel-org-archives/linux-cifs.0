Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61BD3CB2F7;
	Fri,  6 Mar 2026 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811001; cv=none; b=qsZu+tvTNvldORxqhK9T1ZWZPgfY7+Mcq8X9ugqRjbNKfF3VWqSyOA3C0VvVCaNlyURXYzoAAPtQAvpXbyUdR9mekqfPkKBrTk8CpWS6ob0QNlJm0eurIGnL3c7Kj7LzeBhnPzNFYhnRxV6hrO0VLiPB+rBpMUUrGdySMOPPn7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811001; c=relaxed/simple;
	bh=S8O+YJDjPMalDPqau/iEUYmFgbPFP1LbFkWmzEAaqPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rmwmk8Hjq5RUMPkRYN1SHLShkIBlD3xFPnWQIK8jV0Bo5E/DCYcD4eNFcs4jmuEd8bysfQW/bg1PbxZB1bfPKrVCtAvMmhXEmr73tTLdSeksDWJ/xdck+1GdSMUA1dyyjJs4VQ/ZssDm6NjCAIOe5w/gCYF3WlC06rof1gsryWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nbynUlgh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nbynUlgh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=6VzTsbiSBGxG915ExsRatXh3vQwjAOELBtf1VCpqhoY=; b=nbynUlghyi/PIvY9Hrsrcdco+f
	pXm8txkyqhZXhHHt1JQZzU6ImpkoVjXcKGdwPD0kaTr5Cf9QVYqJ4g2gDEN8qVseebXFQMqwpVQKi
	t1ruPY26DKc1yY0IO+nN2yglrg6LKFw4LGRqgR9ZF4Q1JUOtITttj9ShEQVUTqdFEqnq6UGr3861j
	kd3kubXOxkC838dnVfj0mbMa0z7ix2ctnkq95qDxFX06yPhkAMkH7bcge2BBjkdAhMIFzj3Hfl/Gj
	g3Z1ppiyXl9W0dgY5ZF0LMbRxakG42lcFi87nw7A3h8DNWdIQ1c8InKGvm8a9lRP2ziOc7DD7yTAr
	aya2zHXnzD8L+5OKQF2G7vLFGlfqDGsbhA/+quLQJ1MATd5TycRZC+5K0PAoF5N/A/YDpMndthLgS
	SRS8Q+AYKRTBiue4AXVBtxM4wBcD5EGyBDyIndjgiR18NOYwgq3Jl0i/SFrIlTDnzsZmuG4kDNtpI
	ZF1bkfsLDFS1cl5sH3ZSaRsN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vyX7e-0000000AWBW-3IZc;
	Fri, 06 Mar 2026 15:29:50 +0000
Message-ID: <a3f513c1-a7ad-422b-8fd8-145b222f77e7@samba.org>
Date: Fri, 6 Mar 2026 16:29:50 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: fix smbdirect link failure
To: Arnd Bergmann <arnd@kernel.org>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
References: <20260306144415.3402532-1-arnd@kernel.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260306144415.3402532-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Arnd,

> When CONFIG_INFINIBAND is set to =m, it is not possible to have SMBDIRECT
> built-in, and it turns into a loadable module, but this does not prevent
> CIFS and SMB_SERVER from being built-in, which in turn causes this
> link error:
> 
> ld.lld-22: error: undefined symbol: smbdirect_socket_release
>>>> referenced by smbdirect.c:212 (fs/smb/client/smbdirect.c:212)
>>>>                fs/smb/client/smbdirect.o:(smbd_destroy) in archive vmlinux.a
>>>> referenced by smbdirect.c:212 (fs/smb/client/smbdirect.c:212)
>>>>                fs/smb/client/smbdirect.o:(smbd_reconnect) in archive vmlinux.a
>>>> referenced by smbdirect.c:338 (fs/smb/client/smbdirect.c:338)
>>>>                fs/smb/client/smbdirect.o:(smbd_get_connection) in archive vmlinux.a
> 
> Enforce the dependency at Kconfig level, so that the respective smpdirect
> options are only offered if it's possible to link against the common
> module and infiniband.
> 
> Fixes: 28504d6ee127 ("smb: client: make use of smbdirect.ko")

Thanks for the fix!

Steve can you put that an top of ksmbd-for-next for the moment.
Then I'll squash the hunks in the correct patch and provide
a new branch, as the 2nd would have:

Fixes: 30807ad55601 ("smb: server: make use of smbdirect.ko")

But both hashes are unlikely be the ones landing upstream,
so as we do rebase anyway I'd squash them, but maybe
I'll have time for the rebase after -rc4.

So we should take it as is for now, but maybe without the
Fixes tag, but acked by me.

Thanks!
metze
