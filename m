Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1E41B8E0
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 21:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786138932; cv=none; b=vCflCh+7Zsdaa5p02vRSUhFM6rtmxFVH4gOydlkTUzF63PCNpzwM+kJcDqN8KUZyeIBfbcXyp0R26W2Y7grWAazC4lw7LNF+CVlscRFRYUPE26Cg2VF0y3XVBXXPqlc2gqG80uU2Ce29RjWxxoMvoUqhlVtLskTZKU9LrUxit/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786138932; c=relaxed/simple;
	bh=ipMUr8nmuVWLNfI1B88zMl64bbxKRCy6m8wzg4IlmlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZ7rvoy7hoXwsRJ07w74Q9hj723SHtS8Z8uCE5UrulcFXF6KDDcfFMnMrCuOBIzmdFizOUZ4HKXnx3v9FWk0wy6/6uwbDtdDkv5NZpEBT5d/1thLP+3Y3U40SPSSVEG4zWs3YWVV6ftdMiDBi3z30tBxBRPOT3UwkQnk5i/Lkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=IB5Howoc; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="IB5Howoc"
Message-ID: <a5776b98-7b5d-4c30-bd2a-f690b7ce7323@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786138926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ld35yKIQeYdXbvFPHVx4zk0mqP6mIduFuI9KrfLw56k=;
	b=IB5Howoc7TVU5gfS9Lb4TzEO+FlIs2/kYb8L1PgCSIKl22QyEczRnPTQBOrzoFllzUpYfd
	c8Ce0WhEd6f+UAliif6wUhyzVATICOR5R2694xpEFqCZ7ya+ZrGe4tHGOYM/hNM1e9Cn1+
	p9++3mWpMSzD3USYmymqwHB5AE6y+AOeY1FD8TQscG5hI+a7H6wWccKk0fV/IR+cLIKdjm
	F7sNDVRcAM4auvYR8I9eVkB3ed+EDAeTbykYBB4mPJU7IimGKL9iv5EYwLAbgfMwE1SZz0
	QK7x4gfvOZtXQqAQbxTeSPJa3mJoI0qMFgTIk0oyF3fewn7G5rQAgk2zGUtXwg==
Date: Sat, 8 Aug 2026 05:42:14 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Fwd: ksmbd NTLM challenge blob heap buffer overflow (pre-auth)
To: vova tokarev <vladimirelitokarev@gmail.com>
Cc: linkinjeon@kernel.org, stfrench@microsoft.com, security@kernel.org,
 linux-cifs@vger.kernel.org
References: <CAGBKPgMzL+67L=wrKoCoOq-OQWW1enRLYUtUTHwcPSZ1vt0T8w@mail.gmail.com>
 <CAGBKPgOX-cc8FkeUfBZvUFEABH6dMmKj28jv1w+xatn4+dvYQg@mail.gmail.com>
 <8231ce4e-2a6f-4177-a7e3-5c210ae9a44a@chenxiaosong.com>
 <CAGBKPgOi8DS7qjgP_MD7_3zUEyikFBK-8mEVwoJS8rDjYznWRw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAGBKPgOi8DS7qjgP_MD7_3zUEyikFBK-8mEVwoJS8rDjYznWRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi vova,

I am using the same `ksmbd.conf` as you, the length of the netbios name 
is 202.

After debugging, I found that the maximum value of 
`strlen(ksmbd_netbios_name())` is 15.

```
struct ksmbd_startup_request {
	__s8    netbios_name[16];
}
```

I also checked the ksmbd-tools source code (Link[1]), and it copies at 
most 15 characters:
```
// ksmbd-tools.git
// mountd/ipc.c
static int ipc_ksmbd_starting_up(void)
{
...
	if (global_conf.netbios_name) {
		strncpy(ev->netbios_name,
			global_conf.netbios_name,
			sizeof(ev->netbios_name) - 1);
	}
...
}

Link[1]: 
https://github.com/cifsd-team/ksmbd-tools/blob/c0ce0753144adab006552ed42e6862758ed6929d/mountd/ipc.c#L162

在 2026/8/8 1:32, vova tokarev 写道:
> The overflow is server-side, driven by the netbios name length. Your
> 290-byte response shows the server name is ~15 chars - too short for
> the overflow (needs >31 chars).
> 
> Please configure ksmbd with a long name before running the PoC:
> 
>    [global]
>        netbios name =
> AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>        server min protocol = SMB2
>        guest account = nobody
> 
>    [share]
>        path = /tmp/share
>        guest ok = yes
>        read only = yes
> 
> Then restart ksmbd.mountd and re-run the PoC. KASAN should fire.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

