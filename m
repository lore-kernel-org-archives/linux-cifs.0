Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F183128D9
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 04:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784868707; cv=none; b=pkL3JJi46J3mxzdkVvZ0+tbySdtyPjt7Pdhpzj1qNWvj/Wh+7LS3WKfQifpH9WaUydc94XJg4/Ub5gmbT7Zi3Fx3zOXJDiuoUuSRilbH8omu0rfCfhFRU0SYLpE5ovH1W49gH75oO2WAwo9mZTnEdYKc3HOOV3WYAJbqnNPPPU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784868707; c=relaxed/simple;
	bh=l3uotQg+BF6am/nT/S2L1dXBa9p5sUXNXnqDlwrBIQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iU/lbV9DMby/T7pAd4iggAik/b6tXsBceBpOGE3p0jE+8aNtPmTXVxX/jjy6Ig396buy1y2gpCeRiH8KL+QBDCO8vr8OQ1vK7EXFuGJensbnA6kFKwymyaEsIHeX62TnrC2EgEJ49audJc07hOJyrC+7ZQHqe6GyDbTBGy8iLmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=q8MlsSKf; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="q8MlsSKf"
Message-ID: <09e27951-06a6-4dc7-bc44-cf9eff87d271@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784868701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Iva+/lDdfBysQhNAXJZV/BkE1gNWZl/90SRLyCVwoc=;
	b=q8MlsSKf5ocbletV1lNR2YQL8PnpQze/urm5UudY7cehS0fvu+/D7i4bbkpZ3mKQI5txEc
	W9FJmEtueJTznsVAT46fsbRgidKyI0vrNI3z1U1BRN2/IVxx1WHa1txUxziHI23ki6VuXe
	PZia5COGCBkZS8JENxq5+dpJwHG5xrpIaImrUUs/O6vGmrm/k/6nRofAW7Ssw/Vps3mayi
	P/7nbkulUXEnZ8lzvi1w8fw6zvdrRp1kkQIVuuZD4E9wFLNbvS4a/XEimdFJ9Bg681IWyp
	q4mBZFHuV1HGDVgzgtNg4dzlIez0pxuU/sY2DyZsxvBR3FFJ1zh22Vb9/h/Q2g==
Date: Fri, 24 Jul 2026 12:51:14 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: only rebind the reopened file's own oplock on
 durable reconnect
To: Your Name <qwe.aldo@gmail.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
 tom@talpey.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260723230053.684176-1-you@example.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723230053.684176-1-you@example.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

By the way, your email signature is "Your Name". Did you forget to set 
your name in .gitconfig?

On 7/24/26 07:00, Your Name wrote:
> From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> 
> ksmbd_reopen_durable_fd() walks the inode's m_op_list and rebinds every
> detached oplock to the reconnecting session:
> 
> 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
> 				lockdep_is_held(&ci->m_lock)) {
> 		if (op->conn)
> 			continue;
> 		op->conn = ksmbd_conn_get(fp->conn);
> 		op->sess = work->sess;
> 	}
> 
> The only key is op->conn == NULL, which every detached durable handle on
> that inode matches, not just the one owned by fp.  When two sessions hold
> durable handles on the same file and both disconnect, reconnecting one of
> them adopts the other session's oplock: op->sess is overwritten with the
> reconnecting session without taking a reference on it, while op->conn
> pins the connection.
> 
> The sibling teardown path, session_fd_check(), keys on the identity of
> the connection being torn down (op->conn == conn) rather than on shared
> state, and so does not have this problem.
> 
> Once the adopting session is destroyed, ksmbd_session_destroy() frees it
> while the foreign oplock still points at it.  The reader in
> ksmbd_close_fd_app_instance_id() validates only opinfo->conn, which is
> still live thanks to the reference taken above, and then dereferences the
> stale session:
> 
> 	if (!opinfo->conn) {
> 		up_read(&fp->f_ci->m_lock);
> 		goto out;
> 	}
> 
> 	ft = &opinfo->sess->file_table;
> 	write_lock(&ft->lock);
> 
>    BUG: KASAN: slab-use-after-free in _raw_write_lock+0x74/0xd0
>    Write of size 4 at addr ffff88810a970528 by task kworker/0:0/9
>    Workqueue: ksmbd-io handle_ksmbd_work
>    Call Trace:
>     _raw_write_lock+0x74/0xd0
>     ksmbd_close_fd_app_instance_id+0x183/0x410
>     smb2_open+0x1346/0x4430
>     handle_ksmbd_work+0x2bb/0x7b0
> 
> Reached from an authenticated session against a share with the default
> durable-handle and oplock configuration: two sessions open the same file
> with a durable-v2 handle and an RH lease under distinct AppInstanceIds,
> both log off, one reconnects with DH2C, and a later durable-v2 create
> carrying the other AppInstanceId walks into the freed session.
> 
> Constrain the loop to the oplock owned by the file being reopened.
> 
> Fixes: f363a0fb134a ("ksmbd: fix app-instance durable supersede session UAF")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
>   fs/smb/server/vfs_cache.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> index d95c405eab11..1e9d13344825 100644
> --- a/fs/smb/server/vfs_cache.c
> +++ b/fs/smb/server/vfs_cache.c
> @@ -1720,7 +1720,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
>   	down_write(&ci->m_lock);
>   	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
>   				lockdep_is_held(&ci->m_lock)) {
> -		if (op->conn)
> +		if (op->conn || op->o_fp != fp)
>   			continue;
>   		op->conn = ksmbd_conn_get(fp->conn);
>   		op->sess = work->sess;

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

