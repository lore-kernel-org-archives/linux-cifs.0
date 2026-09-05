Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3779454788;
	Sat,  5 Sep 2026 23:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788650499; cv=none; b=SGKTmKBvAWZ3BwzIwsbWoscRNcBlyHDgRRsTKU9Wxnh4hADV66eMTF0kh1GH+UIG8BUZhOPvvW1VBvhNwq300+xMPr6PQT0uciQj7Ho/gb0UiHZbgHiZsa8VAF0g/8DDLvOZzsY2MLdDDLFKBI+qYeB15KIQRUkzB9I8vYJXfqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788650499; c=relaxed/simple;
	bh=5T/aicP0TnclLPU5wnf84xNr+s/WFtsD1IJ6HkgnE28=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=P86bXYWXLrlLCc8hOhsbfH8wFwlqgXsNCp+WMSl6cSkf8TiU5LYu1Z5b+CioT8IhYhr29jD4bNcZc81y/ulO+rqpyY4BCYybnJFSDIhmASVJ9S3aeMxLy/vHFElzq+WugEpHZGJzQysb19vtEBb9KGKXeuyPAIcVFdnQjWuB5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=l3m/LLkC; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="l3m/LLkC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bKhkQNF7LlWqke6YHxjBoK7l4G+YBO31j9ZWaMZeeK8=; b=l3m/LLkC13uXj8e5NnkFzXZ8KF
	IKmWh2PyZw3At1a2pTbw6K2W/1QmkYTcI7YMZQSor8JlczNGGTcp9//AiEidkexktWbhRkwbcps/z
	Pagi6r/RChVYVv3Wwr3UGZyz9SxJkXMYvz8y0RbDIm1/Pl2WvMNHGJryNiru1NajS/lo8iy96W2rC
	bZ/h/F+Dezb0d+P9t562I3VPE2VthBYC9w6QP6aYXwpJuugfFUd/k4zgZa2ovzXhXGSREqidEGzN4
	fQ+uMu4trkbvxSU5pvVza4EHp2RxeEF3SXgneF34tPfF5Su3IKmCHA29OYBPsbibydwnJ42ure74X
	A43Vg1zw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x2zhO-00000000lU5-0GUj;
	Sat, 05 Sep 2026 20:21:26 -0300
Message-ID: <b79a2d5372c3b983a57e33d2732fd45b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bjoern Doebel <doebel@amazon.de>, Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath
 SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Aurelien
 Aptel <aaptel@suse.com>, doebel@amazon.de
Subject: Re: [PATCH] smb: client: avoid leaking refcount in
 cifs_queue_oplock_break()
In-Reply-To: <20260903212858.728118-1-doebel@amazon.de>
References: <20260903212858.728118-1-doebel@amazon.de>
Date: Sat, 05 Sep 2026 20:21:25 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bjoern Doebel <doebel@amazon.de> writes:

> cifs_queue_oplock_break() unconditionally takes a reference on the
> target file before queueing cifs_oplock_break(). Only that work item
> decreases the reference counter again.
>
> If another oplock break arrives while that work is still queued,
> queue_work() will return false and not queue this second work item. As a
> result, we will never reach the point to drop the file reference again
> and are leaking this reference. This can be triggered when interacting
> with a slow-responding server.
>
> As a result, later unmount operations for this file system will fail with
>
>   BUG: Dentry ... still in use (1) [unmount of cifs cifs]
>   VFS: Busy inodes after unmount of cifs (cifs)
>   kernel BUG at fs/super.c:777!
>
> Fix this by only incrementing the reference count if the work has been
> queued successfully. Taking it after queue_work() is safe because all
> three callers hold tcon->open_file_lock across the call and
> _cifsFileInfo_put() decrements under that same lock, so a worker that
> starts the handler in the window cannot drop the reference before it has
> been taken.
> ...

Applied.
