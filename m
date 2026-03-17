Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180333793A5
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755352; cv=none; b=Rd3Wn4B3ZCULNmweF/Fc3wMKJCTQDZFopgc5RL8y+CnyZ0nyD7aIOYN4amIQcR431I1BziKBScfcHbDSNKCvX5QeKyKF3FRBX3bCsk8gAG4hFh/X3APAsS26COqko1xsjKosng6xkXEX0I40QFSebKh9GMVCyXlbp48/pOt98PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755352; c=relaxed/simple;
	bh=o2oQEuqnYm1+FKuVuI8ESWgkSqRlhQsBcEr84I8A/W0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SEnU7wOkXJWEIquiRq6th9+Noi1SNOpfYxtUspf/uEHOFzrf74mo34SvTRPLYiHhDCt6QluL/BUIKe2XB5N+5PpQWDC4cW3YtZ/EtLxUXPhnuGjCnMqwmEID/ovuAHNIQerQhwdpyoF7uky4yPbHKX+AIBSAzzEfuLnwXZrj9Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=LsMKAMfa; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="LsMKAMfa"
Message-ID: <7ecf9af4-096a-45f5-9d00-fc7ae750e7db@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1773755337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3NtXWb1T5GNs3GjnylfVd2bcf08rb/CyD3OMTHUf4w=;
	b=LsMKAMfaieIOLp48o8vu5XywAIr/1+MZ1WjK5pLYEKzFlKMJeohFt4Ip5qXEmDuhGmknVF
	FUcSvqcjy4hJQRPlw+imCROPcSg7zHrpMlnUf4VgjI3wmI8Lr3+6mNQ/dyC9ivzKaZwlIm
	9O92/jI9qOQAvvUsB+6rDgSQUFDngidkmCJqP4wnY19XJyfuT9Nwf7UEhhRwg/RsQQ9YGZ
	MgXm+AYV9RrUxtcTBRs0I95tamNFgiIKZj0fG2EgX3MKyb19lQzG6L0Qiz5HEenyvnXHJG
	SWWZT9L/Rv7NnhA7fxiLqDD4ZP0/96hFMxC7bLUAiimXWAmD80jbhCcZFGTg7Q==
Date: Tue, 17 Mar 2026 21:48:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
To: Werner Kasselman <werner@verivus.ai>
Cc: "sfrench@samba.org" <sfrench@samba.org>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "linkinjeon@kernel.org" <linkinjeon@kernel.org>
References: <20260317130008.2609025-1-werner@verivus.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260317130008.2609025-1-werner@verivus.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

This patch seems to be identical to v3. Why did you resend it?

v3: 
https://lore.kernel.org/linux-cifs/435dda9f-93f5-41db-9d21-70371d31857b@chenxiaosong.com/T/#t

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 3/17/26 21:00, Werner Kasselman wrote:
> smb_grant_oplock() has two issues in the oplock publication sequence:
> 
> 1) opinfo is linked into ci->m_op_list (via opinfo_add) before
>     add_lease_global_list() is called.  If add_lease_global_list()
>     fails (kmalloc returns NULL), the error path frees the opinfo
>     via __free_opinfo() while it is still linked in ci->m_op_list.
>     Concurrent m_op_list readers (opinfo_get_list, or direct iteration
>     in smb_break_all_levII_oplock) dereference the freed node.
> 
> 2) opinfo->o_fp is assigned after add_lease_global_list() publishes
>     the opinfo on the global lease list.  A concurrent
>     find_same_lease_key() can walk the lease list and dereference
>     opinfo->o_fp->f_ci while o_fp is still NULL.
> 
> Fix by restructuring the publication sequence to eliminate post-publish
> failure:
> 
> - Set opinfo->o_fp before any list publication (fixes NULL deref).
> - Preallocate lease_table via alloc_lease_table() before opinfo_add()
>    so add_lease_global_list() becomes infallible after publication.
> - Keep the original m_op_list publication order (opinfo_add before
>    lease list) so concurrent opens via same_client_has_lease() and
>    opinfo_get_list() still see the in-flight grant.
> - Use opinfo_put() instead of __free_opinfo() on err_out so that
>    the RCU-deferred free path is used.
> 
> This also requires splitting add_lease_global_list() to take a
> preallocated lease_table and changing its return type from int to void,
> since it can no longer fail.
> 
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Fixes: 1dfd062caa16 ("ksmbd: fix use-after-free by using call_rcu() for oplock_info")
> Cc: stable@vger.kernel.org
> Signed-off-by: Werner Kasselman <werner@verivus.com>
> ---
>   fs/smb/server/oplock.c | 72 ++++++++++++++++++++++++++----------------
>   1 file changed, 45 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> index 393a4ae47cc1..9b2bb8764a80 100644
> --- a/fs/smb/server/oplock.c
> +++ b/fs/smb/server/oplock.c
> @@ -82,11 +82,19 @@ static void lease_del_list(struct oplock_info *opinfo)
>   	spin_unlock(&lb->lb_lock);
>   }
>   
> -static void lb_add(struct lease_table *lb)
> +static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)
>   {
> -	write_lock(&lease_list_lock);
> -	list_add(&lb->l_entry, &lease_table_list);
> -	write_unlock(&lease_list_lock);
> +	struct lease_table *lb;
> +
> +	lb = kmalloc_obj(struct lease_table, KSMBD_DEFAULT_GFP);
> +	if (!lb)
> +		return NULL;
> +
> +	memcpy(lb->client_guid, opinfo->conn->ClientGUID,
> +	       SMB2_CLIENT_GUID_SIZE);
> +	INIT_LIST_HEAD(&lb->lease_list);
> +	spin_lock_init(&lb->lb_lock);
> +	return lb;
>   }
>   
>   static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
> @@ -1042,34 +1050,27 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
>   	lease2->version = lease1->version;
>   }
>   
> -static int add_lease_global_list(struct oplock_info *opinfo)
> +static void add_lease_global_list(struct oplock_info *opinfo,
> +				  struct lease_table *new_lb)
>   {
>   	struct lease_table *lb;
>   
> -	read_lock(&lease_list_lock);
> +	write_lock(&lease_list_lock);
>   	list_for_each_entry(lb, &lease_table_list, l_entry) {
>   		if (!memcmp(lb->client_guid, opinfo->conn->ClientGUID,
>   			    SMB2_CLIENT_GUID_SIZE)) {
>   			opinfo->o_lease->l_lb = lb;
>   			lease_add_list(opinfo);
> -			read_unlock(&lease_list_lock);
> -			return 0;
> +			write_unlock(&lease_list_lock);
> +			kfree(new_lb);
> +			return;
>   		}
>   	}
> -	read_unlock(&lease_list_lock);
>   
> -	lb = kmalloc_obj(struct lease_table, KSMBD_DEFAULT_GFP);
> -	if (!lb)
> -		return -ENOMEM;
> -
> -	memcpy(lb->client_guid, opinfo->conn->ClientGUID,
> -	       SMB2_CLIENT_GUID_SIZE);
> -	INIT_LIST_HEAD(&lb->lease_list);
> -	spin_lock_init(&lb->lb_lock);
> -	opinfo->o_lease->l_lb = lb;
> +	opinfo->o_lease->l_lb = new_lb;
>   	lease_add_list(opinfo);
> -	lb_add(lb);
> -	return 0;
> +	list_add(&new_lb->l_entry, &lease_table_list);
> +	write_unlock(&lease_list_lock);
>   }
>   
>   static void set_oplock_level(struct oplock_info *opinfo, int level,
> @@ -1189,6 +1190,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
>   	int err = 0;
>   	struct oplock_info *opinfo = NULL, *prev_opinfo = NULL;
>   	struct ksmbd_inode *ci = fp->f_ci;
> +	struct lease_table *new_lb = NULL;
>   	bool prev_op_has_lease;
>   	__le32 prev_op_state = 0;
>   
> @@ -1291,21 +1293,37 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
>   	set_oplock_level(opinfo, req_op_level, lctx);
>   
>   out:
> -	opinfo_count_inc(fp);
> -	opinfo_add(opinfo, fp);
> -
> +	/*
> +	 * Set o_fp before any publication so that concurrent readers
> +	 * (e.g. find_same_lease_key() on the lease list) that
> +	 * dereference opinfo->o_fp don't hit a NULL pointer.
> +	 *
> +	 * Keep the original publication order so concurrent opens can
> +	 * still observe the in-flight grant via ci->m_op_list, but make
> +	 * everything after opinfo_add() no-fail by preallocating any new
> +	 * lease_table first.
> +	 */
> +	opinfo->o_fp = fp;
>   	if (opinfo->is_lease) {
> -		err = add_lease_global_list(opinfo);
> -		if (err)
> +		new_lb = alloc_lease_table(opinfo);
> +		if (!new_lb) {
> +			err = -ENOMEM;
>   			goto err_out;
> +		}
>   	}
>   
> +	opinfo_count_inc(fp);
> +	opinfo_add(opinfo, fp);
> +
> +	if (opinfo->is_lease)
> +		add_lease_global_list(opinfo, new_lb);
> +
>   	rcu_assign_pointer(fp->f_opinfo, opinfo);
> -	opinfo->o_fp = fp;
>   
>   	return 0;
>   err_out:
> -	__free_opinfo(opinfo);
> +	kfree(new_lb);
> +	opinfo_put(opinfo);
>   	return err;
>   }
>   

