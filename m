Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6420586353
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 01:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766106029; cv=none; b=Y5kzLnTBj0c2HaPkb7Vzoz0g8r20Ln5iq9BAQVuoChHn2DjB9panHGTcEjTZIDSeoqxJPOlY5okUO+VmTROIAznDSKpIilkpPa28NCE86TD/x3TbYH03Zxn2gwOwrEBtw07vlg5mdjHDiO4l2RP7/7haIgCBzzZTFOI1Z90pWJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766106029; c=relaxed/simple;
	bh=8mROQPJNKi6QNtqbnBVZDKs+lCOk6FBzGAkQ58rxSD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4hTHbLNhWD6+UhfGh5m9hjRPcg8kMbjD/Gg8uad/rr625v1sUzRd1FbA7ZJUG4DVfCnlfUysDEQrRP6bgeSmg3sx4/Zpda6lPeNl4J8x9RO7eoBJwJpF4KIwGwZujpx6dXOMhIOVZ9xKPVEv3nhFMbF7LA81srxXQ0qEA/MfHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pigB5KIk; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pigB5KIk"
Message-ID: <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766106020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJwe8ZBMg2mF5tnpZjcRjVLZIfCtL+sT3jDqOTw+Csw=;
	b=pigB5KIkY1SglINsFyb3ZxHY6yQ2z+sWCPCMVVhcWkM4Y9mq4zD/QA869DIQDm3zCVQHsF
	I0ETa8624LWnOfZnJ2kZd0o+WLYiD5am8/7Y7f/lyxN6v506iTIXPE2d21eOevMoeG5+eW
	5Da2c8JBow1CcWowaSZtSBMnv9FyT+Y=
Date: Fri, 19 Dec 2025 08:59:36 +0800
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
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and 
`SMB2_MIN_SUPPORTED_PDU_SIZE`.

But we "should not" add "+4" to them.

The `ksmbd_conn_handler_loop()` function is as follows:

ksmbd_conn_handler_loop()
{
   ...
   pdu_size = get_rfc1002_len(hdr_buf);
   ...
   if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
   ...
   if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
   ...
}

Thanks,
ChenXiaoSong.

On 12/19/25 08:16, Namjae Jeon wrote:
> On Fri, Dec 19, 2025 at 2:11 AM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> See RFC1002 4.3.1.
>>
>> The LENGTH field is the number of bytes following the LENGTH
>> field.  In other words, LENGTH is the combined size of the
>> TRAILER field(s).
>>
>> Link: https://lore.kernel.org/linux-cifs/e4fbcbad-459a-412c-918c-0279ec890353@linux.dev/
>> Reported-by: David Howells <dhowells@redhat.com>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/server/connection.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
>> index b6b4f1286b9c..da6dfd0d80c2 100644
>> --- a/fs/smb/server/connection.c
>> +++ b/fs/smb/server/connection.c
>> @@ -296,7 +296,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
>>   }
>>
>>   #define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
>> -#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
>> +#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr))
> +4 is needed to validate the ByteCount field of the smb1 request and
> the StructureSize2 field of the smb2 request. Let's change the macro
> name from HEADER_SIZE to PDU_SIZE and add +4 to
> SMB1_MIN_SUPPORTED_PDU_SIZE.
>>
>>   /**
>>    * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
>> --
>> 2.43.0
>>

