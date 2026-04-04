Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083D5330B11
	for <linux-cifs@vger.kernel.org>; Sat,  4 Apr 2026 05:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775278992; cv=none; b=FBb6au/0J29/lBdolLveAZnjv8u+jgS9CQ/9YF6mntzLy6Ql6hTxOuCUK3OWin5FkEVRP+7uO/uQmcWobjUUxetzzp19Yegc8Vt3TzgEQlDuYBhmmnK4ssVlEof7BiAd9w1J7FVneFME9QmqZgjtIoGQNq7fIcstbdz2tO9HxrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775278992; c=relaxed/simple;
	bh=ljLqHN4/YU54zGex0W8bOwmzab78gDAvWCE9IC2QNmc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=uPQ5smYeutK33A2hfpE4padBeIn4hciHsJEKVc/DRyp100GsYh0amFNbARlIYUEfpU3ItCgQRYvmqnbcLki093Sw615WDfAGF5diT2Snp3Iv8ZA+pEV3o10DwSz9GoDUzS+ilix3INW4AVG4hW+4Xrwd6p3F0wSEgha+h5Ku34E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=nCBdwPR3; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="nCBdwPR3"
Message-ID: <904cb9a8-2ff5-4725-8ce2-f70c4f98791e@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775278977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1U6dk8yrKlB+wf4qSWlG//ZdhnWAEAWP8rEKm7hKPZo=;
	b=nCBdwPR379jAGtjbyJXkAU75EJIIo5aFPgZMv4MModTb9rEN7HGKo5+c9qgZvSFEN0059b
	6X7VG63byGYf9Kmf6LEtZ9x76KeVT3frDZaTxcl/7t/b2923QqTTq/nFRHvTQgaPtxwdyQ
	K9pU2z81l/wwOR1opkyRmG4S+gQMUmJbrSMKPTERf4YG99rmjGlvPNnMUJZPwAkfZlF7jB
	nRdb1HjH7fmeQ4lpJFOnx8IxQ6l8FvKZnj7kBBBMPKYu51RGYRniX81jrUVriy2Bz26fN+
	5Qqqxc8qnzHSA1B6y69Ay+N0jHzUVv/UATYOPWGsXbDFmE3N4qu+c6cQNOxqBg==
Date: Sat, 4 Apr 2026 13:02:07 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free in __ksmbd_close_fd() lock
 cleanup
To: Namjae Jeon <linkinjeon@kernel.org>, munan Huang <munanevil@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260402083912.457676-1-munanevil@gmail.com>
 <CAKYAXd9Qnq6YgTfbS-59YATBvnbtKrX3w+D+WNk=izZVvQOoVQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd9Qnq6YgTfbS-59YATBvnbtKrX3w+D+WNk=izZVvQOoVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae and munan,

In `ksmbd_reopen_durable_fd()`, when -EBADF is returned, should 
`list_del(&smb_lock->clist)` be called?

If my understanding is incorrect, please let me know.

> 
> int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
> {
> 	...
> 	fp->conn = conn;
> 	...
> 
> 	list_for_each_entry(smb_lock, &fp->lock_list, flist) {
> 		spin_lock(&conn->llist_lock);
> 		list_add_tail(&smb_lock->clist, &conn->lock_list);
> 		spin_unlock(&conn->llist_lock);
> 	}
> 	...
> 	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
> 	if (!has_file_id(fp->volatile_id)) {
> 		fp->conn = NULL;
> 		fp->tcon = NULL;
> 		return -EBADF;
> 	}
> 	return 0;
> }

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 4/4/26 10:28, Namjae Jeon wrote:
> I will apply the following patch instead of your patch. Let me know if
> I am missing something.
> https://github.com/smfrench/smb3-kernel/ 
> commit/319ca5432460b0749e420f7cff637dfbc7e16be3
> Thanks.

