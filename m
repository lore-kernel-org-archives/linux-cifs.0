Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491A82580F3
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 05:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112097; cv=none; b=BOhfKAjjHLg3LfP561+VxlLqHR5xp2K7Xs3DWtymfh7IoOO5TdUDi0MEycEDskEyUi5OyzgEqNEahA07efMVrjzTIEx+cG2gE7v4YhGIhHCky7ACXyT+4H7z1QXu+lEMt2l2E+abtvsDeU9WrD5T3YEyDtDS+0USxTbRCyZATfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112097; c=relaxed/simple;
	bh=2mPXhxuo4IJLFRgjZkd3pfZh9s8yOOrFx08zNBmK6RI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lcRKzQlEUG+O2UfXTAmYxHwsdniWGfyrCFCidEhSECiiKTY+ErhJZrXmqHeNF2CxSZGPBnTwELGjkzin891RuZ8aNXnDvzHtYkrlgMfp3O3Yk9DvBhVmgcWlUGfCYjtRqgf47FS08qXN629HNNkAwRfERvk0SUndACe9l7co4d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=erZoRNz6; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="erZoRNz6"
Message-ID: <35ae5b68-f271-43c9-8641-359fcf60e2e7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761112092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6oX/rM+xj8YZ9WX2a8hmSx1b38bj76scMgut5Iyc/fk=;
	b=erZoRNz6mEV43d7tALhAhwrlB58PxpclLFOdxK+rZIBRjygPxl144whehz/6zZCgYnbuoT
	rGMDKLNsO4FUtLuYoroVAKOwC2WZ6hrqh6Wm9KTGSe7rJtT++28zhmXauevxqVnCKK2Fcq
	izvuooxM8Xs2EVO88iZT80RFrOAgiU4=
Date: Wed, 22 Oct 2025 13:47:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 09/22] smb: move copychunk definitions to
 common/smb2pdu.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org,
 smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com,
 christophe.jaillet@wanadoo.fr, zhangguodong@kylinos.cn,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014071917.3004573-10-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-zUyxsrevM9huWDeyOb3Y7XbT3ngqq1Xax0um-dXTwqg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-zUyxsrevM9huWDeyOb3Y7XbT3ngqq1Xax0um-dXTwqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

In this patch, COPY_CHUNK_RES_KEY_SIZE has already been moved to 
common/smb2pdu.h

-- 
Thanks,
ChenXiaoSong.

On 10/20/25 1:03 PM, Namjae Jeon wrote:
>> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
>> index 0be63c00f848..9b5880e60a4e 100644
>> --- a/fs/smb/client/smb2pdu.h
>> +++ b/fs/smb/client/smb2pdu.h
>> @@ -191,36 +191,12 @@ struct crt_sd_ctxt {
>>          struct smb3_sd sd;
>>   } __packed;
>>
>> -
>> -#define COPY_CHUNK_RES_KEY_SIZE        24
>>   struct resume_key_req {
>>          char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
>>          __le32  ContextLength;  /* MBZ */
>>          char    Context[];      /* ignored, Windows sets to 4 bytes of zero */
>>   } __packed;
> This can also be moved along with copychunk structures.
> Thanks.

