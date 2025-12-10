Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50E81C84DE
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 00:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765327091; cv=none; b=Qhwbdl93tsh0WqCN02xvtgSf/A2zOvx/C3Q3Y000aIrR3EWOJXf/DlHPq73njxiFcABt+dkAi+3n8t8bRZ52XcG9eWCAdQyF9hRlI2nCj3pN1M06wQkOPloVcS1TTzFPOpbjKGV8b2Bx3ai6m6JNKBL+PKpXLA6Dywghmm5/NMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765327091; c=relaxed/simple;
	bh=YeUNvUnY12hPxWaRossHRjXvKHX4teVExfWsnUuR498=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AmkCDt8W8b69EDghCfj3evEO5rSKj/+P5smigTT4wiwfcnvloN5hcd7UjFQ/nykFiLNcMuzip67psV+0lctqcVa6JHpcFc5dN0exXpOincRUPgS+Vf0b1sDSXTSQ30KN+fS7JuRziIClcXXwmwMe8kCSrMS7Ux7oNGr4pwPSMeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZeXmT7gw; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZeXmT7gw"
Message-ID: <531e1da0-b353-4285-855f-a7f023ab6dde@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765327075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KgorKmlkWsea8RMYdoHt9YPPtv/f8MnF9nRMFJqyGgI=;
	b=ZeXmT7gwvm0QOD6O4Bro8LSxWn8xdDT0ndi8EuSgOWKLoNVI31J2sZ89OEYB+z9WIGiZ4a
	IdM5Y3jA+hBT+WE1Qj/faTv8GbDyWgocMoWGIjkFRoQKFNNG3a7h0QaxOyVbFf65DO3KBx
	UDWfhzhjsglcEKpquTsejNVH2QZrVBE=
Date: Wed, 10 Dec 2025 08:37:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 11/13] smb: introduce struct create_posix_ctxt_rsp
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
 ZhangGuoDong <zhangguodong@kylinos.cn>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251209011020.3270989-12-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd8so+qB4zAXmj2mNSxqQ4emJe6eqhg-UgpKYgP+URk_yA@mail.gmail.com>
 <c153bfca-4b19-4ffe-8c65-21a0b87263fa@linux.dev>
 <CAKYAXd8ANQKPbzzxfhp1eiH5my-uoZvr-x0iRYaqu=+BnV0P8A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd8ANQKPbzzxfhp1eiH5my-uoZvr-x0iRYaqu=+BnV0P8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

In the POSIX-SMB2 2.2.14.2.16 documentation, the OwnerSID and GroupSID 
fields in this structure are flexible members, and how these two SIDs 
are defined depends on where the structure is used.

https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md#2214216-smb2_create_posix_context-response

Thanks,
ChenXiaoSong.

On 12/10/25 8:31 AM, Namjae Jeon wrote:
> On Wed, Dec 10, 2025 at 9:13 AM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>> Hi Namjae,
>>
>> The `create_posix_rsp` structures on the client and server sides differ,
>> but they share a common part, and only this common part is defined in
>> POSIX‑SMB2 2.2.14.2.16.
> I agree with moving create_posix_rsp struct to common, but doing it
> partially feels forced and unnatural.

