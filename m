Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBC31A267
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 00:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781050474; cv=none; b=Zae1HS7vNpsT6ySOsh3gV1zA5apKbTTjbaEbCma8HeSYRjEynR/UPiI/yTmul4Kp5W0xOmPopRvK2ll5HlM9+nbTYHei5BynQCqcCAKhSGEI1QNpnw6pJSfSAnR5yrg2f44RVMC0BY2u+z5SqAHCrGEUUVM9Wf7IsOIzc6SuM0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781050474; c=relaxed/simple;
	bh=wuHT2a8LaxOttgwXCHj25ocLMBnvEp5BL4N9Bi2lNlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=awrDG7DvYCfVK5ADvwNBIzzcCVHZgtCfpWPCiWjgY6EqQlGzYzSPfokhA+ef9lqGY0++w9LkzJW9cxB8VODxISqp2pMduIPw8b3kZLJIoZ9gNZusZc+YbPYdhFW/yhdkVbMnTaKnSkI8ugcUuJapvIrNHdMG6T88qK8OHKfPadg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=SWe/+Vph; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="SWe/+Vph"
Message-ID: <069dbbfd-e3f7-4566-a7ef-624e56aea46a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781050467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5gl6BT1q0kdmHwT6w06itGQHnU2DSUQJDnVQbbvgjM=;
	b=SWe/+Vphi7Vd4+xDJ/HzgyiQLBs8CDJ8N1K2qwc36FAIVrwj8EVIleS6rzFL9bFLN3d42s
	I3e/y0YP4/9uL2mk6hr3FrHFp0ZDvVDkYfttux4c+7UjA4grAP4v6wj5UEAVsVa4mNOwR2
	Em+7scxMtE/lLKXMEVgYkgKL+6Cn/wnP2utImWRPf3UCIU5OPeAWaxTyrFVZK2l3T3u2l6
	bO9pGMs3HYP4ccGDUDaYdLYJ2+JTCehtM7vwngBFiafkb2yXPstVoXCMf3fu1BMz4GFIG8
	1ekaA5u+GGDz8jLK83zVqjlzx73U10zMqq3M7FolbIy1z2G2MwpPIsqasHzhjg==
Date: Wed, 10 Jun 2026 08:14:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: xfstest generic/035
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5muMKwYGGAcBN_LQcE2zhd-+Kk+fKsRiTokpYXwZoGS68A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5muMKwYGGAcBN_LQcE2zhd-+Kk+fKsRiTokpYXwZoGS68A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

Is anyone currently working on this issue? If not, I'm planning to spend 
some time looking into it.

在 2026/6/9 6:34, Steve French 写道:
> Do you also see xfstest generic/035 fail to ksmbd (but works to Samba)?
> 
> Client's mount options are "modefromsid,idsfromsid" otherwise default
> 
> generic/035         - output mismatch (see
> /data/xfstests-dev/results//ksmbd/generic/035.out.bad)
>      --- tests/generic/035.out   2024-05-15 02:56:12.624944737 -0500
>      +++ /data/xfstests-dev/results//ksmbd/generic/035.out.bad
> 2026-06-08 17:26:09.357104228 -0500
>      @@ -1,3 +1,4 @@
>       QA output created by 035
>       overwriting regular file:
>      +nlink is 1, should be 0
>       overwriting directory:
>      ...
>      (Run 'diff -u /data/xfstests-dev/tests/generic/035.out
> /data/xfstests-dev/results//ksmbd/generic/035.out.bad'  to see the
> entire diff)
> 

