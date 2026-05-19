Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D96369D4D
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 23:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779235066; cv=none; b=ovLagkZLD6AmVgr5YWC8IP7sU9/pkjpfCI/hckChPIcyZ5vVZBtv/DVqzHZ6LxJ+jPQfyDGDiTE4cv1GExvHG03zit+wMIa4fPX3RDClez3Ow+vHnzBbABsDmPGru0v1FmeYnaZnzn0NegOwgjcwZqql9KV/X1LlI9sDYufyotQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779235066; c=relaxed/simple;
	bh=SjobuCK5727uEw3Sd7Ovza7HA9UzzPVsKB+pDkr+DlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UP850WfnGG+/p7efdphvyDMXgIp5VD48dHWutdQXG9InleO/PoK2ibf8FyROdCBSibtugQ/qzFJmBVp9peS09wCE38xXeVFRP/5XREx3jRbfxhcWooSVtVT1cRtqYvsHRCsqxqi+hFk9noMIiGcHwLRep+IZmZwQPM5MsROdVqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=RX0mAxa1; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="RX0mAxa1"
Message-ID: <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779235060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9QT9UfVVkD0OEkaW9QLzIJiPvSRA/ed8zXIAg11eXU=;
	b=RX0mAxa13YWPFvEiNsgFPmwINy3mGeYWFd75NsEj9AcOwdVe/bEEG2o3g0IZdfd16MQs+Z
	SDQ3L5sh1RloqN8/m5RwwhTjk9fhHfBuCGI/d2NWGt27i5QWS/9xKqmkVwAbnyegbMF6zX
	vLH7yA1mh7Pm/BHZBTLzVwJcLvpTFvfMjzwAEYzlp+MRvZijtwP2bHKMEmYZARscHMSlOA
	VzifhykA/9vCpaPRJNFtpaMnHvSKO0Md46X5Yfg90nApInOq7xo9ac/5ZD5OgYERDoeSKG
	3sQdcFUMQ+YlLgw8pgJ2obiGtW7EyFRao4j+1oe5VsdHEDt85s23y7eLoZ0+wA==
Date: Wed, 20 May 2026 07:57:17 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: chenxiaosong@chenxiaosong.com, smfrench@gmail.com, linkinjeon@kernel.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org
Cc: linux-cifs@vger.kernel.org
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Are there any other Samba maintainers I should send this patch to? It 
seems that samba-technical@lists.samba.org did not receive my email.

I added cancel notify support to smbclient of Samba to make it easier to 
debug the ksmbd notify I am currently developing.

On 2026/5/19 17:51, chenxiaosong@chenxiaosong.com wrote:
> From: ChenXiaoSong<chenxiaosong@kylinos.cn>
> 
> When client stops querying a directory for change notifications, it should
> send a cancel request to the server.
> 
> Signed-off-by: ChenXiaoSong<chenxiaosong@kylinos.cn>
> ---
>   source3/client/client.c | 57 ++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 54 insertions(+), 3 deletions(-)
