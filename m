Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C6F21D590
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 00:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582853; cv=none; b=qK82GWlz5TjZ8b252S1eUiInLHAo5Eri9Rd0u/GYmAbJeNJa5HZ709SG85awTSXrGdxAvuHsmr1IHdgY8cXodfFbhcsmB+b/uGelNlFXnJlobrfs5WPIfzw/HvdzUO94PFn4ulmns7oocQU4O97RiT0+4ybGyRE5VSanNxB1XoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582853; c=relaxed/simple;
	bh=kvgWr9/LLaAlM/9Kwbk6u2fxtFoT6o/IiJwQXTBt2IQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oKwkL6H+dJm6WTGKZEhXp5z53MvfyogUPuA/fWYXf1OxMBGfPf/48lU9Q1FfmAup0p6xr4dksyETdLAEnERxQ2wbt65osDXvkzeYE/Kv2a6WdodhsPlZCKjsolxMdP3QjCkaN0agL5OaDth4pmD0uYVRVOc2P2Pt/Mpi2MS/Bzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dHPRhmwa; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dHPRhmwa"
Message-ID: <e3b7e66b-1a03-49bb-8fd7-a1ca5ea4c0f1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772582848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kvgWr9/LLaAlM/9Kwbk6u2fxtFoT6o/IiJwQXTBt2IQ=;
	b=dHPRhmwa0+u13hvvwoqiM57kjJ7KARRrB9mfxRAPIkbIW359UVukSkhefh1uEHMN8S8za9
	CS4Pk28rYyAgW8lBVJlWKIoQYK9lgTHbZeP3ZFNDenXD2aGcL3k69+aJXyCsQ01jiwmigQ
	61sTkChRgESa0lKByZ4rNEoouOw+VJk=
Date: Wed, 4 Mar 2026 08:07:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 1/7] smb/client: fix buffer size for smb311_posix_qinfo
 in smb2_compound_op()
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn,
 chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
 <20260303151317.136332-2-zhang.guodong@linux.dev>
 <CAH2r5msFB7KBUMmfwq7HwpF7+WLOySGhhfQm93OwZLWTmp1a9Q@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <CAH2r5msFB7KBUMmfwq7HwpF7+WLOySGhhfQm93OwZLWTmp1a9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I will try to test it, but this is a very obvious bug.

On 2026/3/4 07:58, Steve French wrote:
> Good catch - were you able to repro a crash or other bug when running
> without the patch?
