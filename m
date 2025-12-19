Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9173414F112
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 01:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766107888; cv=none; b=PEvf2BA+vGtWa3drojcAixTmQdTjX035LW1blby7C8YCJ9L1HiITb0aCECD8l/pGSqLOdDR2rspfjwDYukSDZmH+P+4wqeJFkVZjgxG/984SJZ5H9Ty79nrAzacRUs4Ln/zcC86tFlxZqPIdHKyNlHnYl7km1vSfU265hkrUfNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766107888; c=relaxed/simple;
	bh=gA3XroSxPfAk8QGaMHByMOJSj124fiQ0AT1uOo6JQ/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aM9mS/sHj4dfIxF0IPVQ2ZmX+wcTkjodtzmH1oIDcbM72Fm8MHrnIXeHUKz4PkzId7nRbQwKLemBvy/wCxg21WqiohxH5MCFVTUMKWMcrHU4vj/vvVPawKn7Ym+z9A5z7iaz3lVbQQ7HEYlVXjmn+eBw8c9VzCclUJZDXYHBxKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lULJakTg; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lULJakTg"
Message-ID: <9f9031de-6749-4de4-ae5b-d574b9fc06bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766107880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JESaJMc7DB4jyeKjON2148T4qnik//o6l3zhSjj7r1A=;
	b=lULJakTgX2aCrxEvQFQjmat8qLT5njp4D/vs8LbXx0cS8wUQtbVO9OXhyAJ9L8WjLTvpyu
	ynFPNNQruJeICE6UAkAk8El9qt1CnusCVpCejX9QCg99lTJAaMYbwoprp8/gRcoBcrwW/a
	WffcF6NBzJ59wCLaEAnP7yW+btvz4CU=
Date: Fri, 19 Dec 2025 09:30:36 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: dhowells@redhat.com, sfrench@samba.org, smfrench@gmail.com,
 linkinjeon@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
 <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev>
 <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

`SMB1_MIN_SUPPORTED_HEADER_SIZE` and `SMB2_MIN_SUPPORTED_HEADER_SIZE` 
are only used in `ksmbd_conn_handler_loop()` to check the PDU size, and 
seems not to cause slab-out-of-bounds issues.

Thanks,
ChenXiaoSong.

On 12/19/25 09:16, Namjae Jeon wrote:
> On Fri, Dec 19, 2025 at 10:00 AM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> Hi Namjae,
>>
>> We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and
>> `SMB2_MIN_SUPPORTED_PDU_SIZE`.
>>
>> But we "should not" add "+4" to them.
> Not adding the +4 will trigger a slab-out-of-bounds issue.
> You should check ksmbd_smb2_check_message() and
> ksmbd_negotiate_smb_dialect() as well as ksmbd_conn_handler_loop().
>>
>> The `ksmbd_conn_handler_loop()` function is as follows:
>>
>> ksmbd_conn_handler_loop()
>> {
>>     ...
>>     pdu_size = get_rfc1002_len(hdr_buf);
>>     ...
>>     if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
>>     ...
>>     if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
>>     ...
>> }
>>
>> Thanks,
>> ChenXiaoSong.
>>
