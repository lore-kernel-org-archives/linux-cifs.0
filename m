Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF347145B11
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 04:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782273911; cv=none; b=Y6uVTByb+ClaVwCLwLHD/DyWzeKlZi7UrcXxUr9HJali4MEzZdQ4wSo1qNT6KZMP+YGts3CZZppGonZSeUGI0vUipJQFmSgG0cVTJexm0QL+zMX8NoqshkA31x547xQMp/IM1pdTg9rDMJCQnNH7DC6Z0oe9St+9R5REGxAeNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782273911; c=relaxed/simple;
	bh=OvKR4j9VdR1oFJtzxsQ9TjbQmBYWm3dD1sduivAAOtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tVJhrtu2zf0ETtlCWyiCWGQhMQGiqB59KnlNy04fzbFIEWI7StaH23UvpTZi4fZCx520rtu1YCDt3X/EErt59rgDmSRwgL5Elkm6qW2rTudGIy5cJXa9Dzqx0rLDqW/hhdEOrO7YebUteOFvyKUKjF2E/VgPWC2u5FVgTb1IWkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BbID0PqL; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BbID0PqL"
Message-ID: <392ac41f-7f54-465f-a514-0293300747d6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782273905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uieN+X5k55VjjHF9KEFqU840eTYcYHIinSVxpQryDOg=;
	b=BbID0PqLpBPsTHbJyL0t7aPcqG99U41Tap3ggBe5QLlUzrAMrz3TpxcY1t2sESp2gss6vp
	pnwFcv7YEexM1mvxhFobgbd3cCDRDlpevhXwY0qS41KYqegMPKlV6HVZw+rByLUx9tVefn
	fr2wxGGWNhBgFTSpO1u0nKiPB4fnGPA=
Date: Wed, 24 Jun 2026 12:04:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/9] smb/client: handle smb2_set_sparse() failure in
 EOF-extending fallocate
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
 <20260624021550.1548952-4-huiwen.he@linux.dev>
 <CAH2r5mtLZTXGcCGy5y24CH_uDRr6tPq21i6wS4SZHhqHn7o13w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAH2r5mtLZTXGcCGy5y24CH_uDRr6tPq21i6wS4SZHhqHn7o13w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

Yes, that is possible. I checked ext4, XFS and btrfs with examples like:

         truncate -s 1M file
         fallocate -n -o 2M -l 1M file
         filefrag -v file

and:

         truncate -s 1M file
         fallocate -o 2M -l 1M file
         filefrag -v file

With FALLOC_FL_KEEP_SIZE, the file size stays at 1M while the range
[2M, 3M) is preallocated. Without FALLOC_FL_KEEP_SIZE, the file size 
grows to 3M, but the filesystems still only allocate the requested
range [2M, 3M). Holes before that range are not removed.

Patch 3 only changes the error handling around the existing
smb2_set_sparse(..., false) call. I agree that clearing the sparse
attribute is not a general byte-range allocation mechanism.

Patch 9 handles the sparse EOF-adjacent case differently: small ranges 
are allocated by writing zeroes only to the requested range, and larger 
ranges remain unsupported. That avoids clearing the sparse attribute
for this case.

Thanks,
Huiwen


在 2026/6/24 10:48, Steve French 写道:
> Would it be possible in Linux to have a sparse file but still with
> space reserved beyond end of file?  In other words are there cases
> where you could have a file with holes in it in Linux which still
> fallocated beyond end of file.  What happens to ext4, xfs, btrfs if
> you try that?  Does fallocate beyond of file remove all holes in a
> (sparse) file?

