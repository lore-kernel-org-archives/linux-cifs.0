Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD5685C4E
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 16:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408672; cv=none; b=cBmJR/wThqF7napGuscsRNf7uHBScnZk6RiPm3qN83CodiijypQBKEkqHQdeMvTYUrG8d6tb3ixXLrhTUDZC005N0o8D/RTVmg/dX7044oSSZBIjampvzthHr6Vs/4TI5eORHClwhN3NtGgPkwn3aOJHcKIfaYjvzvXbp07dGb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408672; c=relaxed/simple;
	bh=x/t/9866+XJupmrTu04IJoL6xWmDz+wQOW+f/1l95mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYcedPj34cLjnR8puk94yu7Y+EKDSHych7e9LSlnV/DN6vB/4Ci7cJC2N9XQFLtl59JLGFPGxYoAym+40pwlpfT4OfFDGJEPwfGr/alYXEQregvjcAVK6XDSWLnDiuKRC4t/Xa+bF9RXWKscRP6DIV5dUxb17qdXvxfPEIA7jdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YApLYdmB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YApLYdmB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=zMxR+A2koUavQNh4I5bOCzAzxmXskWL8t7JgfYxOp5o=; b=YApLYdmBNIVKCLW6dze9FoADVY
	zyXDjMIwoLQ1CIUee5sDungsxhlO0H/7K2S65C+LJHO+6x3fRoZA7R+2pJd+eHUli8zvPw+22k79g
	fla2T6dsue3LlGWeJuEKS/w9C67veNxMkXmdyti3TuATI9/kq3pS2QnjqbRb/U7pvBdPGtSrPE729
	IbT2N1J4bz+pL6QVfEf/9nvcDt7p5kDsv0EOqwIzplWF6g6LyVfDMjLKnNMW1uZSkaSPpaHvEasMR
	4xkeXSbUb2TdvGRLmdwqFrOb+VJCLclHbDxoos4rNSTB/1WdzCUrjTLAEQoh4gCRkRE72FgUzbEBA
	ACrb8spSWhoA48hnZ5HkgkmSrUQnDRnCRwpR8fFE/JhdFXtT2xnR1I1pbMnKQCxCQg7qjSohnJwtN
	GtLR8zCd4+K2ymt28Xb32iLo5hxrNa6PAf7ZKxAJFCgFnVsgvv7awjIHsurymkxyZLkpba1kZJ0rd
	wegVZqW0GJ/nuCR5GdOm6bE/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1U0h-008xxV-1z;
	Mon, 29 Apr 2024 16:37:47 +0000
Message-ID: <ba6a8bcd-ce81-4ca4-9d90-16955ee5508d@samba.org>
Date: Mon, 29 Apr 2024 18:37:47 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: query fs info level 0x100
To: Steve French <smfrench@gmail.com>, Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 "Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>,
 samba-technical <samba-technical@lists.samba.org>,
 Jeremy Allison <jra@samba.org>
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
 <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
 <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.04.24 um 18:13 schrieb Steve French via samba-technical:
> On Mon, Apr 29, 2024 at 12:31 AM Ralph Boehme <slow@samba.org> wrote:
>>
>> On 4/29/24 1:27 AM, Steve French wrote:
>>> Trying some xfstests to current Samba (master branch, Samba 4.21),
>>> they fail because query fs info (level 0x100) is returning
>>> STATUS_INVALID_INFO_CLASS) - this works to ksmbd and I thought it used
>>> to work to Samba.   I do see the SMB3.1.1 opens with the POSIX open
>>> context works - but the query fs info failing causes xfstests to fail.
>>>
>>> Is that missing rom current mainline Samba?
>>
>> have you enabled SMB3 UNIX Extensions?
>>
>> smb3 unix extensions = yes
> 
> Yes - it is set to yes in the smb.conf for both the global section and
> the per share section
> 
> I also see that POSIX extensions in:
> 1) the server returns posix negotiation context in the SMB3.1.1
> negotiate protocol response
> 2) the server returns the level 100 (FILE_POSIX_INFO) query info responses
> 
> But the (current Samba) server fails the level 100 (level 0x64 in hex)
> FS_POSIX_INFO with "STATUS_INVALID_ERROR_CLASS"
> which causes all xfstests to break since they can't verify the mount
> (e.g. with "stat -f").
> Nothing related to this on the client has changed, and ksmbd has
> always supported this so works fine there.

I guess fsinfo_unix_valid_level() needs
fsp->posix_flags & FSP_POSIX_FLAGS_OPEN
instead of
fsp->posix_flags == FSP_POSIX_FLAGS_OPEN

In smbd_do_qfilepathinfo() we do the check with '&' instead of '=='.

metze
