Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BCE3955EB
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786628807; cv=none; b=u0nzILx6ZcN8w+u8aF5DwvMYgVabW/GRT5kP+A0vQip8LWtXdTXrKLVGf5o5o0oN26R/6Tu+abpeDFSYNNgOe7Ye8b4BDmFLTfm11Q3/4fVqcaw3mxNXc/eLYDsecydN3UAaiFX/XpPFRKJ+Z7P6enEGo19Q6QXXSqklUus9/EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786628807; c=relaxed/simple;
	bh=G7QJNujvn1I02H3hvahCw2Aka3s4EY6Pmqlz9uug4O8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vr2kOQ9KtD0gfxoUrgOQzzhd2LF4CtyxKRNF40a56iwO2AAAzj5CSBYPxUrw3wjK7nCAV6S1heWZo/I+Qjv19Rrj/3kFEg3PpXb9E69ix9Ltqduw+AHaLnXl9US0ZLWqgeIW9jTUcPtpTPtnvSvkd8WiO0nD8YjR06zllrdSZVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=qR24+Bvf; arc=none smtp.client-ip=95.215.58.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="qR24+Bvf"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=G7QJNujvn1I02H3hvahCw2Aka3s4EY6Pmqlz9uug4O8=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786628800; v=1; x=1787233600;
 b=qR24+BvfSvjW+Gcep59MfzuF2w/AwciO9G/0y32eeF11iA2lFYmhcxLF2YGL7SZJcQR67+zn
 9oZFdNzRHao9PErDRZfiDmOOXHQXC83MSyZ9f+owawI1ltv9KqtcSQFsYScNdjCUCf0Okfy66Zp
 ZfGu74/ENaR5OEkr+eMR3gR/H5YQmyZN0IkYLmFbWDgl1w9WJ6StoLOglA1T0SxB2U9vjFrSNgb
 XTWXhL4+E84+atGZGLiinZOQ2OohnJjK4/Onj5lTadpGAXeNNJrxdP1xcvtKc7+p1KzucGySNga
 jEO6DA8SOPdZ7NyBfW5nYtSjx7bBNBdu4Qi8xobqmu7NQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.0.104] (220.202.230.161)
	by smtp.migadu.com with ESMTPS id 178dabe0fb2c003d;
	Thu, 13 Aug 2026 13:46:29 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <0d6f8bee-e4bd-4a8a-b172-a76bd6e15425@chenxiaosong.com>
Date: Thu, 13 Aug 2026 21:46:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb/server: fix use-after-free in
 ksmbd_conn_transport_destroy()
To: Blue bird <obnred@gmail.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, tom@talpey.com,
 senozhatsky@chromium.org, Bahubali B Gumaji <bahubali.bg@samsung.com>,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com>
 <fc4bcb05-866d-471e-b07f-61575d46bb13@chenxiaosong.com>
 <CALT=-86GYBvQd_L89fddL-0bwcezo9NQgGf+bme0JppqKSWpVQ@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CALT=-86GYBvQd_L89fddL-0bwcezo9NQgGf+bme0JppqKSWpVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I will continue analyzing the other lock-related issue tomorrow.

Tonight, I still need to review some patches from my colleagues.

在 2026/8/13 21:37, Blue bird 写道:
> Agreed. I dug into it further on ksmbd-for-next-next and I think there are two
> sites that need the same treatment. Data below, and a patch that survives the
> reproducer at the end -- though please read the caveat before taking it.
> 
> All runs: branch smb3/ksmbd-for-next-next at e7317f3e41, fs/smb/ built against
> the 7.2.0-rc7 it is based on, freshly booted guest each time, kernel otherwise
> clean (Tainted: [O]=OOT_MODULE only), same lockfuzz2.py.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

