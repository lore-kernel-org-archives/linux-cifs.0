Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EE354918
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761861397; cv=none; b=H+o6gsFkDX8wpO4G6Ct3Rg88v60T05Ta9cO47M80MAnDveSFxnaVtAb4oW47BaUItxcgYYwGCe62YkbmxWgWiqAWRfnRNp9lIIYbGaJnjcwmHAocs5UCQsPpQR28D8CRouUw9AxY9VgJgPpdIVKyks12pHNHc2s8ONRuAMQxN7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761861397; c=relaxed/simple;
	bh=jZ7fl4wbdCODUJAvN5qHlstdFOcfuopVts8R+OwBHnA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=LZLugN55S+Llx+ev4No+JqHe2ZsAlnGQvEZVCLJ/8a3AJYr8qjI8yoI1d+FncCJFkW8RJB/E10R/6r+ZeBTTAPR7Y+08jA/kmnkqdJdKu2+tcg5oyEj9hUDoIEASy+3Ok8pOGikpXCeWk8Iq2jTD1+ODaXzgUxO0CYhFrdqPoOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=xX/MqZmo; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="xX/MqZmo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lrp7oZcssLre8OSty3nvFtedD2Eeb+b+ydR91eu9J3Q=; b=xX/MqZmojPBIIMz29YmAKCtNfj
	OWQ69NtJkKy8yPj/6FNKEXf1z3WDrYC58E5xXGU3qIjRYZuA7gnSADVQ+ymWVcQ2WBueT1giliW+M
	orF4aIq4PCJHhZq1SGuzEBLEe9sEo1GemCsk/tl9YSjGVLRNRbv12RuUsQSpdM1UlqfwSC2NXVhD9
	B97pdyc1tOzxFEAb6W10+JvBtzCmKNl5+cvSebqpGkmpccR0brCtuf/taoJVyQgejgCn5Mn3wf4Jz
	86h38Qxm4JTSu0m6/t24bpyolGodR6XkfThEWvO7FL/1ZsTWaTeG7yCaGxYaybG0SkPsgkygrDybg
	ovnksGhA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vEad7-00000000fEr-07BS;
	Thu, 30 Oct 2025 18:56:25 -0300
Message-ID: <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 sprasad@microsoft.com, smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in
 /proc/fs/cifs/open_dirs
In-Reply-To: <20251030170116.31239-3-bharathsm@microsoft.com>
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com>
Date: Thu, 30 Oct 2025 18:56:24 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bharath SM <bharathsm.hsk@gmail.com> writes:

> Expose the SMB directory lease bits in the cached-dir proc
> output for debugging purposes.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c |  7 +++++++
>  fs/smb/client/cached_dir.h |  1 +
>  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
>  3 files changed, 27 insertions(+), 4 deletions(-)

Are you increasing cached_fid structure just for debugging purposes?
That makes no sense.

cached_fid structure has a dentry pointer, so what about accessing lease
flags as below

        u8 lease_state = CIFS_I(d_inode(cfid->dentry))->oplock;
