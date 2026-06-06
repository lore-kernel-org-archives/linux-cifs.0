Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F204071DB
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780756574; cv=none; b=KBqi+F0eDq/YutB7smu9TbMjqNook/gVAblHvJ4mjAqcmj4gMA8iVDBNLqea3BgQ16lif49mQ7/GAoq+c39kMkJTn5kccxH2cAsZf6bCzutah+26AnxA6iN4P3vkJvYYDSyRe4CyeHHom+04JyypYA1DZ0jX//Ys+cIRAsjARCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780756574; c=relaxed/simple;
	bh=8nyGzZg2qYdEny7Lca99OO1lMtSV2JTa61kKBMgp+NI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cyQR9P1/KvQ8tCqe63SQFkKJqPCR2vHZTVwWmn8y3eE7sa0UiLJgrn7uAKqfrW4XRVL3/Qcg7H2OZEFZ/NClZnCXb2ia9ouiNjC6UZs5VN9M+LOElxtkqLPiwd4Vo+8tndZhEIwulp6Gp6KxCxr0t87Neuu+ujFuwpLS5T7B3rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=BPDefus9; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="BPDefus9"
Message-ID: <08f57c4c-09d6-4737-8b2d-85c33f2eb1a4@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780756567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vvOZ18zyJvhdTw/3GGJaz2UGS01otbRm0YxWwRrgsHs=;
	b=BPDefus9ANHpwlP9icLkFtC69ZGkC7OeRU9nNBWj8smhOQJbD+ZvfVnGGbSVpGzx03OHpI
	a73lnowA08JPVGCE2vOS7j97TLCfMb/Fe7JlEMFSTVQoNPx5r7uX6WhCgMHWIVBOA4pKpd
	rlrwIdXCGZJ2/Pi6CoI6vKlaB/zIeu63991ZcI20xszJDjshcWC9gpG0g9DUPwNFfWvRL6
	ZSxOfHONfNElKLS/EfxuGRmRabXVTD12Rlsps4GR5Pb+WPt1sZ0QZCZB+6FF7Cxc2fc2AB
	cb5TrFWIoChVuwYXC86/Gsttr47glzT0DCmStKJrIw81QOgzdixUPVkgvardLw==
Date: Sat, 6 Jun 2026 22:35:53 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] smb: move compression definitions into common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-2-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
 <a4502395-735d-4c90-a116-754a3e91137b@chenxiaosong.com>
 <CAKYAXd-H6PoLQ+4CTMFg0UvRB7m8V+UinVQRcCB1yk-icB0rrQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-H6PoLQ+4CTMFg0UvRB7m8V+UinVQRcCB1yk-icB0rrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

According to MS-FSCC 2.3.67: The actual file or directory compression 
performed when a server receives a request for 
COMPRESSION_FORMAT_DEFAULT and COMPRESSION_FORMAT_LZNT1 is 
implementation-dependent.

So my understanding is that DEFAULT and LZNT1 are equivalent. If so, we 
only need to use one of the two values, right?

在 2026/6/6 22:18, Namjae Jeon 写道:
> On Sat, Jun 6, 2026 at 10:51 PM ChenXiaoSong
> <chenxiaosong@chenxiaosong.com> wrote:
>>
>> Please see MS-FSCC 2.3.67:
>> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/77f650a3-e3a2-4a25-baac-4bf9b36bcc46
> What does COMPRESSION_FORMAT_DEFAULT mean? default?

