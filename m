Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A6C3370E3
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 14:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712970; cv=none; b=aCtPe/m5smCtd5D/11NzUuLBM9hJ69q039peB0gIC85X24Qzcr4YhLFJMfcV2l8PFT4mrjvm1eeUJfWL0J94Hk0gV8Enn68RrUJ/hhoKRarOHr8ycdnnq7extrVamY4uE6yJR/kuROAv++5/NTuSYNBuYivKvPdC1dBnsrZ2qOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712970; c=relaxed/simple;
	bh=5KdtLgRmD9xffcBvciXVRE0+6NFQ/DLhSxdEKGyb6xw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IoPimSbxfMINEH+2F1aqh1O2UA1XZl9QGCrURHKC6SqF9TnbW5+3LD6P0wmhwQxvrJ3K0Oa5Fh6q6Oa/1HYfHIcsKZ8LgbZS3i6WpJBdBYvrhPZ9dzCDeCheniGitevehSXkQMB5LOWqlVbsTt44EdU9HLiPoF3AAhE/VnCQyIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uWRR2Czb; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uWRR2Czb"
Message-ID: <287b5c2b-3cb2-4115-a16a-bd1ff85f5071@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760712966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqRuTsLACDDYXSd8AWirB4EvePJIoVUPqSSwBDM1YAQ=;
	b=uWRR2Czbf31+5VLMcVQ11R3g8jb1omGftHtbrALLEb4JOEeBO9ls+KDPjZ7yYXRcTk2foO
	+gCcGn2Kj8U/UYvIVtcvMwlDo8oiZySEs5B7BwamYVoKxpL10qxBNcO5EKMleGihlKMCxg
	o4bsj6+HmM26B8FDuIDknwked/b+md4=
Date: Fri, 17 Oct 2025 22:55:58 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/6] smb/server: fix return values of
 smb2_0_server_cmds proc
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
To: sfrench@samba.org, smfrench@gmail.com, linkinjeon@kernel.org,
 linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
In-Reply-To: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

v1 has typos, and I've already sent this v2.

Thanks.

On 10/17/25 6:46 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> These functions should return error code when an error occurs,
> then __process_request() will print the error messages.
> 
> v1->v2: Update patch #01 #02 due to typos.
> 
> v1: https://lore.kernel.org/all/20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev/
> 
> ChenXiaoSong (6):
>    smb/server: fix return value of smb2_read()
>    smb/server: fix return value of smb2_notify()
>    smb/server: fix return value of smb2_query_dir()
>    smb/server: fix return value of smb2_ioctl()
>    smb/server: fix return value of smb2_oplock_break()
>    smb/server: update some misguided comment of smb2_0_server_cmds proc
> 
>   fs/smb/server/smb2pdu.c | 30 +++++++++++++++++-------------
>   1 file changed, 17 insertions(+), 13 deletions(-)
> 

