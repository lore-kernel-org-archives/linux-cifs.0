Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114AF2D8771
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 03:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775704309; cv=none; b=SPnqKSpKMOdsmlFgNqJG8Y+MFHfrVva5tXaigQ/xXppOxNob6VbsJ65phqZmnXpDuW9juUpgzYm0lCPy1SkdzGsr/GkwyQSSmeLkjcVKzwA1ZXETVb8oe+sfeelHJuOSuMWnMkBLF7Wv4saVebO2y33PLhbAZyHKZO0/vUYUhz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775704309; c=relaxed/simple;
	bh=BKu6slQSA59rMwyjMqQttlERuky3a+Q080V04uN6zGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vac5fAgxxbnPfQ9cWfcb2Nu6UyT9bXOlPh8Cw+5HASqeBjzO5nZTT3E1ofIHuhPx4unnkuYgX0UMQK6WMhX8pOwBDz5gMxmnQxNbUJQF+4aiLVQi45jZYRmuvfTWq/L7UGsWKa63zA4gkGycdoobgHW65KhuJzj3ySSxj8zPphs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Z1ZjEqhp; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Z1ZjEqhp"
Message-ID: <77013349-ff89-4593-985d-520d967d2638@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775704303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iy2d63mOs0uVe10NEgVk9hD0DgC4FR98sN+wcxJYrDM=;
	b=Z1ZjEqhpgbKzN9G8oZqzrhIBHt3yo4+ejBFoat8LAMBd3nVd4TBIiPBFEwO/oOCvUPHQ2U
	Wj/dCjyRa8pQLGk/r/AyeSHbyWcGVCPVG03kwIEUZryOyYMXPDuJ5Nf6yr6gYrr6XSQ3GB
	cNnDxD+G6SbNSPLIXOslY7RB+iVG1UPmdV7Pz0lCvtkkOJv8EprGHhK1xNpRZn6BK3oovp
	2WxUiF/X+SsXgMnSreq4SHk5zT63kFg1pil78DfODqD4w6Yvq7GEtx2xCiyAwQAL8udgWB
	kv9tzOVvQcNJGSckl1F1sH88+C53gttTdmBJV8c2hOjSqA4XNtsaq69U4WsDxA==
Date: Thu, 9 Apr 2026 11:09:47 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paulo Alcantara <pc@manguebit.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 stable <stable@kernel.org>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
 <2026040822-shortly-chump-8518@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2026040822-shortly-chump-8518@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

Should we use `get_unaligned_le32()` to get unaligned data?

> static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
>                                    void *ptr)                   
> {                                                               
>         u32 uid = le32_to_cpu(*(__le32 *)ptr);
>         ...
> }                                                               


> 
> Additionally, does parsing these extended attributes cause unaligned memory
> accesses?
> When parsing WSL extended attributes, the code derives the value pointer
> at an offset of ea_name_length (which is 6) plus 1 from ea_data. Since
> ea is a 4-byte aligned structure, the value sits at an unaligned offset.
> Helper functions like wsl_make_kuid() explicitly cast this unaligned
> pointer to a 32-bit type and dereference it:
>     le32_to_cpu(*(__le32 *)v);
>     
> Could this trigger an unaligned access exception and crash the kernel on
> architectures with strict alignment requirements?

-- 
ChenXiaoSong <chenxiaosong@kylinos.cn>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

