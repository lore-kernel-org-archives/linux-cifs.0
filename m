Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDDB407566
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770664259; cv=none; b=KXWudd0dGu1XJV5qfnDpff2vJFQctuB0o6ZMiic15EEvz3yzT6f318YdpwQgPrgHItHFf5N8JQf5hIBco9uKTr+oVn1viX31EBHKLWtLyoD7L549hNnNZlEs2g0Px1WOSclJQ4j9/tiGHxn/CPdX2eiuWiNL9CLDEdOvzBX6omo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770664259; c=relaxed/simple;
	bh=cQs4xgMd9DYCyDRXzFUnae2wYr87H/yhKLV7ZPGwmLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwuDpnQpxtNd3AjvgN5o9UkEGme12rKVUyMWANOSL4ZyyLUjMsLM+HMolj5QjDZUCnsrHYhErpo42v2w+aDNOaUbX6enET5nnMdoyhLWPLc6vqULaUeSc0LIyBGrakV7V+GSKkPlMgDKsFInUW4tw5fP4f87uQWF/PgGKim+a3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Hiyly9TP; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Hiyly9TP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=rZBrS1kXf0zVoK3EThIVTVBxf2pU/t+jjNnV6z1sXNs=; b=Hiyly9TPjyglxw2+HQ15gpI0Dr
	22QlZafIuMggRhaBOq/Y55MxVIF2zfln3PNhf5ivg/Xhx6skmIGV3odlJ8G/Nc8u3QeSNZAwravvr
	2yXJNz6IS2Gto6XChEF/G16pcKIzjdehlTm8Yyvec90uK5CJuNAmK9IBt8MwEFa0S7PU2kCCSPyx1
	kWOcp6ChUac/S/FYJx8P1Tn6EmN7I+JVQduNkb4SRrsrTTSrui3T8zyg+5PnD8iiU0sy7t6dFfGrk
	dm0Oz8VfzrE6lrttUaA9PWDG522ht05Wz8xVq1dLlWJ2YIdTKU1qW1ppKR5BnEKlc4aAA35aZ/3GE
	L4hsbDekzqB/PMWeMPHWWNetScV6CBkZoo3PGeUO8LE7QcmRh1b7T8ehXUxiA1q1vJvXmaQb4Akrv
	kVniAGTuwKLzXdiZoLpeNuetDQvFmlS100l7YcDX9N20D38yNzXQ5YlXVs/cz0ETIYq5DGJIuaXRn
	qlujUGKNNzez1ct9n5VuPnm2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vpWeu-00000005H9t-1rir;
	Mon, 09 Feb 2026 19:10:56 +0000
Message-ID: <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
Date: Mon, 9 Feb 2026 20:10:55 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>
References: <cover.1770311507.git.metze@samba.org>
 <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <7140153c-7858-474b-abe5-aee69bd196a2@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.02.26 um 14:22 schrieb Stefan Metzmacher via samba-technical:
> Am 09.02.26 um 08:29 schrieb Namjae Jeon:
>>>
>>> I tested with with mlx5_ib, irdma (roce) and rxe.
>>> There's still a known problem with iwarp.
>> Let me know what the known problem is.
> 
> It's the rw credit deadlock, as use rw credits
> for the wrong thing, which means we easily deadlock
> if the client uses an array smbdirect_buffer_descriptor_v1,
> where the could larger than the possible rw credits
> be calculated. While the max possible rw credits we calculate
> is the value that is needed in order to
> transfer the maximal rw size into a single
> smbdirect_buffer_descriptor_v1.
> 
> This commit adds a WARN_ONCE detection for the
> problem:
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=e6260d7a518972ae1ca627e411cc16095c044d59
> 
> See the diff and commit messages of the top ~15 commits
> in my for-6.18/ksmbd-smbdirect-regression-v4, which try to
> fix the problem.
> 
> I try to fix it once I have the needed pcie adapters in
> order to out my Chelsio T520-BT cards into the free x4 slot
> of my testservers.
> 
> As there are some strange page fault problems with the irdma
> driver, see
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=a6b515cda103c1ac1537c92a4e9dbd75a31d92ef
> And also
> https://git.samba.org/?p=metze/samba/wip.git;a=commitdiff;h=e784b53167dc2cf4316b66a7599dab5b9e6c7208
> 
> For the client problem with irdma, see
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=fb5cc2a59b4719015979a1f1355f66f27002b4cf
> irdma_map_mr_sg may merge sg elements any may not return
> the same value as the given sg_nents on success.
> 
>>>
>>> So far I can't see any regression compared the
>>> state before these 144 patches.
>>>
>>> Namjae, can you please test in your setup?
>>
>> Is there any reason to print the log below by default?
>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>> called from smbdirect_socket_shutdown in line=650 status=LISTENING
>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>> called from smbdirect_socket_shutdown in line=650 status=LISTENING
>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>> called from smbdirect_socket_shutdown in line=650 status=CONNECTED
>> ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
>> called from smbdirect_socket_shutdown in line=650 status=CONNECTED
> 
> I can move the above message to level INFO.
> 
>> ksmbd: smb_direct: status=ERROR first_error=-ESHUTDOWN => -ENOTCONN
> 
> This is basically the same messages as the one we
> had in smb_direct_read() before:
> 
>          if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
>                  pr_err("disconnected\n");
>                  return -ENOTCONN;
>          }
> 
> If I remember correctly it appeared just as:
> 
> 'ksmbd: disconnected'
> 
> I can just move the new message to level INFO too, ok?

My master-fs-smb branch has 3 commits which should disable the
messages by default, let me know if your happy with the logic
and I'll squash them to the correct commit.

https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=8b2f53aec19ebc180c11504600b5e5372d2220cb

metze

