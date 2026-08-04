Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CA73D566B
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836476; cv=none; b=g4MUcbwQp7cgvaQBo4004ExMgV386IDeKDfFIPVj3/WeTwkpDkXkyzM3I5l7991si6Bk5CfA4z2fYBkL7MRQtBIlbfRJizo5twAs/mwKia18Rw1Sx2yE7UnFy1mt3DdSFEU9VDmobKUzww6o8gjoKBjsxeLQKNDHWpBaafxiNRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836476; c=relaxed/simple;
	bh=K6DBPq9qexQLVfCzoPr8AHX8JKfb6uxvquye6acpQWQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rctR49Jj+opBUQCKDfFbbRFulWOKpgewYVm27Ctqnk2yWKNOr8yz+zx9+arVbnUyiLOJ47cg3BcnxBBXSyPx3/a93aKxfi/B4fi5iMu0fr55dqnU0dxZM7mnWdTjwx3xh2iEoFY693OaaNOE/PIJAsQpNKlSppFjFqgUCYrU2ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=QHdBOh9F; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="QHdBOh9F"
Message-ID: <82cb92ad-832f-4257-b6f2-eff3c39f273a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785836469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v3H/VAefG9ErFt6nfbWi7tLvoz8sMF+P/VGKSRBqMXQ=;
	b=QHdBOh9FHClFk4vlwcDpMrnad4158CG5QVkesCjkeexMPD9tb/WuZQ1jhTr4tJoLIpE7u6
	jyhCHz9SIW4gdym5oCAB0ynnUsAQP7rJ2SLPj37IwoCUn3TPvIk+C6/wahC1CfHbHJ05/a
	/FsHklxcGY4JXCaejqqfPTYkVZMux16xoIPQaWNWwnH6cr3curFPiESrNQmNm7jHkdPjwF
	3kbO7cdT1UoeSXtO2+tPuEL76LEqyrx/ahdrUlduRchKGOhg3kVQruvysNJq1wPN7YW0N3
	wMrYCdRcUDyuQAxEV+P6PWH95A0ee8QJZBZz1Ijdh5/JQAJl9undmbdST9TcIg==
Date: Tue, 4 Aug 2026 17:40:43 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
 <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
 <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
In-Reply-To: <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Ralph,

I am puzzled by Samba's implementation. When mounted with `posix` 
option, why does `rename_internals_fsp()` still check `found_open = 
files_forall()` (Link[1])? Based on your description, should it only 
check non-POSIX opens?

```
// samba.git
// source3/smbd/smb2_reply.c

1344 NTSTATUS rename_internals_fsp()
1352 {
...
1504                 found_open = files_forall(conn->sconn,
1505                                           rename_check_open_fn,
1506                                           &check_state);
1507                 if (found_open != NULL) {
1508                         DBG_NOTICE("Target file open\n");
1509                         status = NT_STATUS_ACCESS_DENIED;
1510                         goto out;
1511                 }
...
```

Link[1]: 
https://git.samba.org/?p=samba.git;a=blob;f=source3/smbd/smb2_reply.c;h=6bdc02c2374ac6b55def452b2b819b85453b0bb1;hb=HEAD#l1504

On 8/4/26 17:05, ChenXiaoSong wrote:
> Hi Ralph,
> 
> Thanks for your sharing.
> 
> This seems to be the rule for determining whether there are any open 
> child files or subdirectories under the old directory of rename operation.
> 
> For checking whether the new file of rename operation is open, there 
> does not seem to be a POSIX-specific rule.
> 
> Please let me know if my understanding is incorrect.
> 
> On 8/4/26 16:44, Ralph Boehme wrote:
>>
>> - allow rename if there are only other POSIX opens
>> - fail the rename if there's one or more non-POSIX opens
>>
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

