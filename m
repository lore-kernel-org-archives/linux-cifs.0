Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08209406822
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786620053; cv=none; b=TVf67gplaGTg99PSRsJPPOJ7UoVr1aAQtLn82im85zeCj7wZAMWd4Y1MA2Wf+aB56ZrEGXVbarQPsJdC2D90S/Ex0vXN+PYYULD5zGbY0qW4/ZETiShislC0ZZngbUeMgb3yHp2kgYhht8mPnjz0UzPr3ZkBq3gjLOwLlLQhrtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786620053; c=relaxed/simple;
	bh=2oMKEQ7RhlITtpFVYLZ9qUm/Idy8fEjA1jKAwmTa4l4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sFBA3llOTMd2XdXrCR0EJZlvrFhy+gdNojV9jJ3ZNLxd6QB2ZBMf4PRSbiOPLqTqd3qYTqp01jMt3VKH+zc+qOj4QG73w0ZOd4qBJG4coIUR8YtRQ8kmVUiN9sPc5/Sw3qIhkmb6R+hDIC3h0cKglg8uD0zww/z5O+aW005AGjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=i/ujuODA; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="i/ujuODA"
Message-ID: <8891ec1f-3c9f-4286-8d51-bcfa05d0972e@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786620043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLXbUi/N/5p6FFcnuV97c9kmxSfMMKyTt4ntQ8swV+U=;
	b=i/ujuODAcVCR0U+1geZ2b0lo/oaIhEIUk/Yfftcg5AnIii6g05BP9Nighnf9EJOHp4CoJS
	u6AP7Z8azJcauGZpjVykYZzk/Wdaq1ctacme0JEglGdCIPMIq1RXvwiabmDIHD34f5xerv
	5Z8ogJT20oYzsnd7Pt9sd6CuNauBOfbVDYu0ptk7Nq40fwDYO+q37ZxHGyhYtgHAAzxOKB
	oFf23ovmjclM7kjVODB8OO91d3DDJxB0M2knEnoH7MwPt+nvgAqXD8c6RvOWiZmZW3sadE
	peU6s5eaSLSHT/IGCN9lokkUVLw7bYRW+cZr43NdvfWoa4seiH29Es4N4sqRxg==
Date: Thu, 13 Aug 2026 19:20:31 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Blue bird <obnred@gmail.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
 tom@talpey.com, linux-cifs@vger.kernel.org
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com>
 <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
 <9ad355b5-5ae9-4dc3-98d9-cf46795d877b@chenxiaosong.com>
 <CALT=-87Ziq01X+GLYXpOMThBMC6gcFLV3uaP1qy+k_vM6G+-AQ@mail.gmail.com>
 <76c86e67-23f4-457b-ba9b-240ac424beee@chenxiaosong.com>
 <CALT=-86u8tvAZpiLbVQWc=Cadic1p7Dg+a_AnO0tShYWQS2UoA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CALT=-86u8tvAZpiLbVQWc=Cadic1p7Dg+a_AnO0tShYWQS2UoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Yes, they are different issues. We still need to continue analyzing the 
BUG_ON issue.

在 2026/8/13 19:03, Blue bird 写道:
> Thanks for the patch and for the credit -- but I think that is a different bug
> from the one I reported, and the fs/locks.c:312 BUG_ON is still open.
> 
> Your patch fixes a proc_dir_entry use-after-free in
> ksmbd_conn_transport_destroy() on module unload. Mine is a BUG_ON in
> __ksmbd_close_fd() on connection teardown, from a byte-range lock whose
> file_lock still has blocked requests chained onto it. Different file, different
> path, and the reproducer for yours is mount/umount/modprobe -r rather than lock
> traffic.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

