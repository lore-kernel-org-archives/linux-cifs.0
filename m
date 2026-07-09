Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FD937AA7A
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 09:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783589125; cv=none; b=MFlRj9+eNDVwc8h3h6IFXd1L7YGSZZ0XIlxAgzfT44VSvcY9aHea+3d5Ry3U3qdWeP1t1lHcrupNRlm/3JsuJutXvXxOJYBw2h5899W3CL+UfJ7nRgr55yUXBtd67GOivYKPGKmB+R/W3HRnaodnqbBFbMQxJHXU2/7iQWIQuYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783589125; c=relaxed/simple;
	bh=VWUIdim85fi1PxHXZ8qSGPX3/KnAWpQc+3g7sDv4lbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHR8ux/oLSZ6VP41EpsURAJ96Mdw8Drblsyb4mQ7m/VPTgZwyOj0et45doNZLV6Mpe9v8xXZoUo21CDcG5ePwVXySw5QKaNYaSjxBlLv1rid/MQXGYM6OSICUJaa6fDPMNCU1hMd9wwx4T/nU6unLTrVkGCJ60b5m1LN56x+fmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=POysK3Nj; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="POysK3Nj"
Message-ID: <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783589119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vbiupaFa+B4f6Tq91B+zMmpXr56BZs3WEo7EBAVnIjE=;
	b=POysK3NjnUYFU9bR1GR4SlUxO66bPxJncCc/KFQWUuyMQwUbZZPGnu/vFSbtr6qWW/dbkL
	jaD+ZPFfi8F8hFSLdSU8zBWEstgO5egU/eiLbbUacOpReOR2lS9wd6XWX7x2xzIL6laZ8T
	/C2Ci/TrFODOX7XdrSFoCpJ83QmlO+j7PcrjD3DmA2LSbGGhVMuU+cnwBPWDvI6SgCaSpW
	OU6MPWgk0q8rIBp5HMyDjmdlRLx2XiGCu2N1GrN8TERiqXRFF/L5+ru0TLLtcmYPrrSiVN
	53kmUmA1GV/+8pULujnMHaXNy5eHbOKNQ1hukZ0F7OPt8ejIkpLS4s/tNT07BA==
Date: Thu, 9 Jul 2026 17:24:47 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260709000618.66534-5-g.blivet@me.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Gaël and Namjae,

Do you think it would be better to send STATUS_CANCELLED in smb2_notify()?

On 7/9/26 08:06, Gaël Blivet-Bailly wrote:
> +static void smb2_notify_cancel_deferred(struct work_struct *w)
> +{
> +	struct notify_cancel_ctx *ctx =
> +		container_of(w, struct notify_cancel_ctx, work);
> +	struct ksmbd_work *in_work = ctx->in_work;
> +	struct smb2_hdr *in_hdr;
> +
> +	in_hdr = smb_get_msg(in_work->response_buf);
> +	in_hdr->Status = STATUS_CANCELLED;
> +	ksmbd_conn_write(in_work);
> +	ksmbd_free_work_struct(in_work);
> +	kfree(ctx);
> +}
> +
> +static void smb2_notify_cancel_fn(void **argv)
> +{
> +	...
> +	INIT_WORK(&ctx->work, smb2_notify_cancel_deferred);
> +	schedule_work(&ctx->work);
> +}

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

