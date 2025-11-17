Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C71E0B86
	for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763341631; cv=none; b=k4XhkD1iuadP6tnJ7dfyGxTq25LX5WdHpmZ1BCEVP6UCSZzwUkuNp9tIfOr304s0JDUT9RSCbeecoWIXcSVXdj5G1v1voe5gVVqODXcFgMiJjzUGIXuUfeZSnOshiq/yrbFCbi/lB9XMMI5uZ6ElYvhkFjRcRDfMshL0acZZmWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763341631; c=relaxed/simple;
	bh=qfvghGrk88hjixVn8XxhQY9SDWCNe8IC4Z886OL8slw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IdXKMldYJU4mHGIaodg/RxW+ntDvk0TlIZCAlhbXi/reEb4PX69IFpu1lG/PgShke1Qik02uXTQK/F7QNpdNPiSZ2PUPVeQnAbBhuBEKHNowDRezclTCuDtgpjsxmgLXAMfu7xxb3QO5s5N+xyV04tpKteKbKElbktzoUxPX//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vt97B47O; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vt97B47O"
Message-ID: <d7a7ce57-f486-491e-9002-cc8cfc115521@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763341627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uw/aDYlRunZCRePiD31BJ7MFKINjajXrZ9FD+GYSV9w=;
	b=Vt97B47OmTj+AMWfauflbZImpDro1PYZB2MrtrRtlMlFnlM6UTHgP2NWDB3r4zXYkkbUV4
	cPFO2tyjgJJVkHEP5dwtC/Ozoy1o2judqssfeD+dzIhsDtAkxLRdeovXNV8fM+MS4Oijn3
	M71fOu/hvlUj/gh+S/bWNRXeNrm/RGU=
Date: Mon, 17 Nov 2025 09:06:15 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 1/1] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to
 common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com
References: <20251116065213.282598-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251116065213.282598-2-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

I have confirmed that when FileSystemName uses flexible array member, 
fsAttrInfo in struct cifs_tcon does not include FileSystemName.

The following part in the CIFSSMBQFSAttributeInfo() function is correct, 
we cannot add MAX_FS_NAME_LEN to sizeof(FILE_SYSTEM_ATTRIBUTE_INFO).

```c
CIFSSMBQFSAttributeInfo()
{
...
     memcpy(&tcon->fsAttrInfo, response_data,
         sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)); // it's correct here
...
}
```

And in the following part of the SMB2_QFS_attr() function, we should 
change it to `memcpy(..., min_t(..., min_len))`.

```c
SMB2_QFS_attr()
{
...
     if (level == FS_ATTRIBUTE_INFORMATION)
             memcpy(&tcon->fsAttrInfo, offset
                     + (char *)rsp, min_t(unsigned int,
                     rsp_len, max_len)); // should use `min_len` here
...
}
```

Thanks,
ChenXiaoSong.

On 11/17/25 07:00, Namjae Jeon wrote:

> Did you check if it is being used here too?
> cifssmb.c:4866:        sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));

