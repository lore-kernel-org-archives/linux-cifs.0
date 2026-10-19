Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2781F4C9E1C;
	Mon, 19 Oct 2026 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792406625; cv=none; b=CnnC704HUhBdlvyvBTIZiAbM43kkJ+x9f6xjiOlTsEDUomFh83IX8cRzi3uGIvVpG48iF6l1y04bhXtqQez0oZk8MPByqCVYhXkHeRiY/wpcxGi2uS0rQGRZ415GkLhuxEnW8JGkHCtVUQg8yxahJ8RjPtAKyKQ3kLcQLrCsrrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792406625; c=relaxed/simple;
	bh=mftenjTQky7BDdZEVEVb+1b5z++diCV1B6NTt17/ho0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h+QJzXM1b/Wa31uP7CxaDaLuFcKZaaP/wn0Baloy01Yv8t40ozexd6b7Ws4XtgxXmLLdkp8PxzaBFaIhubf/1mvphWCyM420MPihSOMpT8gnP5giOBOQr94+IaY3HdM2oSabFtbQ0U9VsD9NjhFKg+w3T9IGAXJVIMRQ7ZE7s9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZbrZfHTI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZbrZfHTI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=i7wx0P9Un+m+XA+rjZHaCJn2vSIVbWf8wZQ+1xnrFTU=; b=ZbrZfHTIsvaZgKVtQ0q3Hyqn86
	dNXBH4tt/QOM5T8XbHWxbnLsx3MEZ9SIJgipMfbIYaKxCltgzlAJSazJ6DJHfUG0N9wq8VUOEsCDB
	pbWlxU75ES9yb6o0FgtOV1ApLHtFLEcJ92iTBkwuXKDFG4+RaPIRbBdzfgfojTV/7EI+udmkw7wpD
	Yq0849J2IXGU1qFFoDe1S3buJbQu0ya6JxOMZgAYGoV6T780whVNDT/KuQvAck07NssA5L+Vo3DWc
	Gnq0Pqly31L3nAGOqDxfd7KEYszhUZ37qstoO8i5yTX4gpdRLArz+wypKuI9zmiBbh7eESdojTNpa
	DxEXxoJ2OUlc6A1VRaCg6UwHqmW0LUulARTSbuts3mvbipZV5CHeJgF//XzBAY8LAEgwOB1Lq69x7
	/qCxST0ctKLvIvVQ0OeFwL1RHCsdxZ4ZlnaJQu0zxd+NJnYY6JH5HuDtjHDqi3S/lc27FcKPONZxr
	Br7XpiMr7Ld1XxKQqpbgSU1p;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xIkq4-00000003T0f-3Xlv;
	Mon, 19 Oct 2026 10:43:32 +0000
Message-ID: <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
Date: Mon, 19 Oct 2026 12:43:31 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Namjae Jeon <linkinjeon@kernel.org>, Jan Koester <jan.koester@gmx.net>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky
 <senozhatsky@chromium.org>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Wang Zhaolong <wangzhaolong@fygo.io>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 wang zhaolong <wangzhaolong@fnnas.com>
References: <cover.1792345559.git.jan.koester@gmx.net>
 <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jan,

>> a ksmbd server joined to an Active Directory domain can authenticate
>> domain users with Kerberos, but not with NTLM: it has no password hash
>> for them, so the NTLMv2 response can't be checked locally. Clients that
>> fall back to NTLM (access by IP address, machines outside the domain,
>> mount.cifs with user name and password) are refused.
>>
>> Samba solves this by forwarding the response to a domain controller
>> over NETLOGON (NetrLogonSamLogonEx on a schannel connection). These two
>> patches give ksmbd the kernel half of that, and leave the NETLOGON client
>> to user space, like the rest of ksmbd's user handling:
>>
>> 1/2 adds a KSMBD_USER_FLAG_PASSTHROUGH login flag. For such a user,
>>      ksmbd_decode_ntlmssp_auth_blob() doesn't compute the response from a
>>      local hash. It sends the server challenge, the user, domain and
>>      workstation names and the NT/LM responses to user space in a new
>>      KSMBD_EVENT_NTLM_AUTHEN_REQUEST event, then takes the session base
>>      key from KSMBD_EVENT_NTLM_AUTHEN_RESPONSE and goes on with the
>>      existing key exchange. Both events have a strict netlink policy and
>>      are checked in ipc_validate_msg().
>>
>> 2/2 puts the workgroup, not the netbios name, into MsvAvNbDomainName and
>>      MsvAvDnsDomainName of the challenge's target info. A domain
>>      controller checks these when it verifies the NTLMv2 response (Samba
>>      in NTLMv2_RESPONSE_verify_workstation()), so without this patch
>>      every pass-through login fails with NT_STATUS_LOGON_FAILURE. The
>>      patch also checks that the challenge blob fits the response buffer,
>>      since the workgroup can be longer than the netbios name.
>>
>> Logins of users without the new flag are checked as before. The only
>> change they see is the domain names in the challenge's target info
>> (patch 2/2). ksmbd-tools doesn't set the flag yet. The user space side
>> we tested with is sharedd/adconnect from FenrirOS: it marks domain users
>> without a local hash as pass-through, and it answers the event through
>> a NETLOGON schannel client, tested against a Samba 4.22 AD DC.
>>
>> I can send the matching ksmbd-tools change if the interface looks
>> acceptable.
> Okay, Please send a PR to ksmbd-tools. Wang is also currently
> implementing AD/DC features in ksmbd and might be interested, so I'm
> adding him to CC.

why making this NTLM specific, I think it would be good to the whole session setup
blob exchange to userspace, so that authentication is not used in kernel at all?
And it will also help when IAKERB and other things will be implemented later.
It would also be good to have the infrastructure working with winbindd being
the bridge to the domain.

What exactly is "sharedd/adconnect from FenrirOS"?

And Wang, what are the AD/DC features?

metze
> Thanks for the patches!

