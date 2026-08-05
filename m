Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D6C3E3DBD
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 08:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785919234; cv=none; b=tfOY+6nYJ2oHM3M8t1MyMm/wpAgnkZvRA45V9YwX3XR+jfxR9JjScKlIRtro5dyHcnqQPh8FXCsYMO/8mFVD/AUAC+rPTetOLKUTTR48YEE87Rx9amj+BMPn4h6V3FaGLyp3txvDWzHl4JOuc6fzG4c0U70Y+oZxbhBjSiLRRuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785919234; c=relaxed/simple;
	bh=uWmNuYOBvzvgiuQBlNjheG5mz4MaB27+CEhMH8jKfWU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=apte6g6EdxEK+pVCciYQ+k3Mz+Zrsr32ugX49fyAq4UyKRQCgNwS7N7Uu6YulQOmekelTzoufYjCB3mIW/2tlCGGYtq+KUUWu4C3Y+gvN2LQSEuMaiExRGwSKADDs3ULNovTwglJk1qa2mHg53gtygNwVRMiZNEwWlyZGud8p8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=M2yDAwHM; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="M2yDAwHM"
Message-ID: <47938248-0b4d-49c3-83b1-88b657f93543@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785919226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R87Fgf++9VsRwrG8GrRMjxeQOZlI5X5nr9uwzPfXO9Y=;
	b=M2yDAwHMNn0dKd/f5UvAUagO/2koHjYtwoqLVJjmWjjV3oi4WSAuVWA+xN5VStNDQuutV5
	B3kFrMx2faGvQDmJcxXiXZ4eAaXj4KxPlxL8fejbQiBwAj1FBN1clRhHhJHOfj1xV7NGsF
	jri9Tud1Vw/z3FjKi57EAZT8Rnx8AIfMyD3yZ11FmPoDzKhzkXoB0NfhTI+ZD9qXoaqntL
	B1KXB0w943cyBn0UbFYsNkTsdj0lnDd9TTyulcpuZexxP41eRfsJrBtcqxoX65sHxQ7q4I
	X3DGDoIQQ05ADm6gFtq39L1zfd9qg/0Pd+5RJQmz7+1IbMuV1+g23r/p04kb8w==
Date: Wed, 5 Aug 2026 16:40:26 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH smb3-posix-extensions] FSA: allow rename over files with
 only POSIX opens
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com, linkinjeon@kernel.org,
 pc@manguebit.org, tom@talpey.com, senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805082018.309542-1-chenxiaosong@chenxiaosong.com>
 <20390239-0e72-40ee-95d5-1f6235ff8c46@samba.org>
In-Reply-To: <20390239-0e72-40ee-95d5-1f6235ff8c46@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I have created the MR:
https://gitlab.com/smb3-posix-extensions/smb3-posix-extensions/-/merge_requests/11/diffs

On 8/5/26 16:30, Ralph Boehme wrote:
> Can you please create a MR on gitlab?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

