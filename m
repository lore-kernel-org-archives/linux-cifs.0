Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF3D72601;
	Fri, 16 May 2025 13:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747403415; cv=none; b=sYNI/5Qjw62UeyYGbdXLXYccEs1nhV+JJCK8CKGSOcy63uIqd4BEe8Q+lV5ee7NSFc6Zk+w8GCX/MZpswaULIKyRNVd8ySym50c74LwRjqkOBvVxXqPS6RRP7sDuIyfP38EQ32ZdSF5ZfZy8KAjwQOw7DCvzaS6mT3jWhWnRyWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747403415; c=relaxed/simple;
	bh=EHqziaXxgZ35+O1nOFw6ZeKiJTPk/sgxKRz+uIqS31k=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=LV9hUeyeWzfEpWcGn3lORnyHCpBSGhWsolg/2LeGcx93/m3OyyoqygpSD/s1pCpe/M3FSfEYepQ73aHDYSEMrpKROgCoY56W8HeDJaLZBF7jHfx5om/KQP1yHFUjLJ48iJArVYrCBp9Y794WNuD+OhtOyJBIkIW+M2aR6K/ntjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=j41yxktd; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="j41yxktd"
Message-ID: <860a4f7600814b17e48dbabe1ae19f68@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1747403405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mmzWBrBQb2s1Dtr15zDCHkAoFy2O5uJ5sgPONiWBjy8=;
	b=j41yxktdbr+Dm7gUXSMeKrfnhWxRgh/SeO1Y/ee64tjOHEYFeZNONI1qllTLKU7j88OV52
	TT2XZ3jem65KVGA9dZXCU6yxl6SZf8AdyKoedDIEZSWTwmtnxwMBx/zxMrifb9hwKti6e7
	/S18liezDjx/MXxaAzvP5bpDqiqDmtcv+2rUdKJqohWzQ4i4fAo71f5kRE2fw3W5ezt5w4
	ZglMenOH+DMzm388dIwvseQH45mtuGWmtBt+LLcCoqJULCeAvlYVbPnBBtVuf216Mrxrz7
	2RlxeH2vjXFCWL6Czr8/jnT8m0T10UkXShHN9bfnsGOHU6BFNh1q5mgi9o3Rnw==
From: Paulo Alcantara <pc@manguebit.com>
To: Wang Zhaolong <wangzhaolong1@huawei.com>, sfrench@samba.org,
 sfrench@us.ibm.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, chengzhihao1@huawei.com,
 wangzhaolong1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
In-Reply-To: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
References: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
Date: Fri, 16 May 2025 10:49:59 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Wang Zhaolong <wangzhaolong1@huawei.com> writes:

> V2:
>   - Correct spelling mistakes in the commit message, such as 'lopp' -> 'loop'.
>   - The titles of patches follow the same style.
>
> This patch series addresses a use-after-free vulnerability in the SMB/CIFS
> client readdir implementation that can be triggered during concurrent
> directory reads when a signal interrupts directory enumeration.
>
> The root cause is in the operation sequence in find_cifs_entry():
> 1. When query_dir_next() fails due to signal interruption (ERESTARTSYS)
> 2. The code continues to access last_entry pointer before checking the return code
> 3. This can access freed memory since the buffer may have been released
>
> The race condition can be triggered by processes accessing the same directory
> with concurrent readdir operations, especially when signals are involved.
>
> The fix is straightforward:
> 1. First patch ensures we check the return code before using any pointers
> 2. Second patch improves defensiveness by resetting all related buffer pointers
>    when freeing the network buffer
>
> Wang Zhaolong (2):
>   smb: client: Fix use-after-free in cifs_fill_dirent
>   smb: client: Reset all search buffer pointers when releasing buffer
>
>  fs/smb/client/readdir.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
