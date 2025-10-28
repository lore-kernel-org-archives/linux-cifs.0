Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D82283FF8
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761623903; cv=none; b=fvZ1Wi8J/FAdjY1MKweSD92DDE8CeMixFjmNiP4E3DtXWHLLJVB9v7F9jJlSk9kU7Gpm4wyCbCBcjfmafTnRL/7kfuPHFjmchRMoVAFGDjDbDLz56QPC/c0F6KFeXiSRv4WDV6mQtbOnPqWSH4CuqG+Vtf1iJZNdDXr8GHhU9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761623903; c=relaxed/simple;
	bh=VP4T6rUdU/ddECsl/aZycZiR5lezQ2/cHMQj9C56QzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPPCXrdZmpH/r714nDFjUvSL5XKi0X6L2BrkK7IZbIEB35THYjd7OMCm4CK8t/DjRzp45rgC3Eqx75NVzozWy2zgKO2fTU/c9VYMPfFhSBlXsJGPoqDA2MwRF7UoDtgK+qsZt9HHQi8LBh5mkAnS3f7jWwhHNCdnrFDaBkBHK5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U3b+S8O6; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U3b+S8O6"
Message-ID: <75086bc6-9747-4a10-b4ee-ebf9ffdf25ec@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761623889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZL1/VUO7eAG2V742XYwsgahCIY/duuttonLMJA+0L8=;
	b=U3b+S8O6KyRSZCsC9CN8qtEDQE5VagMVloKv9HsoIwk1rLt1+o3rdywLZ/eQnga+u3yGov
	uX/h3+YwSnx9RKdDpnymXZLp9kXxixifYR5F1MxgdxRiKEptSXUjQdCPyOJVtxmC3v6cne
	+j1vMNP+a1M7oBWayBqq/aSmiGSISgo=
Date: Tue, 28 Oct 2025 11:57:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 05/24] smb: move some duplicate definitions to
 common/smb1pdu.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027071316.3468472-6-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_u5+p5hjvQey+TM8w4+P7aN7zSfwDbrUKRtbwx4vtyDw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd_u5+p5hjvQey+TM8w4+P7aN7zSfwDbrUKRtbwx4vtyDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Would it be harder to maintain if only part of the definitions are moved?

Moving the related definitions together would make maintenance easier, 
that's just my personal opinion.

On 10/28/25 11:42 AM, Namjae Jeon wrote:
> On Mon, Oct 27, 2025 at 4:15 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> In order to maintain the code more easily, move duplicate definitions to
>> new common header file.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> ksmbd does not use all smb1 pdus. Instead of moving all smb1 definitions,
> move the ones ksmbd uses to smb1pdu.h.
> Thanks.

-- 
Thanks,
ChenXiaoSong.

