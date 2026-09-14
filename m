Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3ED305687
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 02:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789354346; cv=none; b=FXeuJhp7uvRmk6cxWtB80D77l8wAr/wzStrNpUdak6SfrNvAsWIGqMLuKQvb2OnOIFhwBxRzFy2wTwmPkx8tnWkwnHQBEAwQcCdBpqK8PADZYkld28TBBMbNsYIV1j0EZRpVQc1KWNc4e76xYJ6Am8NxtMRLvgZkPvDetdlbzjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789354346; c=relaxed/simple;
	bh=LlTPvehi23WBaf19vrqq11ukqaGGcEjArBPpBjRucoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oZuj1f0mKTby+lYn3XPXvLh7+tSaT9G40sBzdjRbLp9zvZB6vjnS9XgHHYNipECseyIU4k7ia3JEAQyTS1aXZJWORVJcibXgRVLbvr7+v2CyW686ZoJz2hXCpoRajwfIrAqSxZMySojR8D2ycfxmh/PVloiTBzSTH5CjSP/WDzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=gGm0uO1S; arc=none smtp.client-ip=91.218.175.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="gGm0uO1S"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LlTPvehi23WBaf19vrqq11ukqaGGcEjArBPpBjRucoo=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789354339; v=1; x=1789959139;
 b=gGm0uO1ShDm6gUL/dVI/ZP+B5z6mHxxnwjeX4Hv2UPOKyY5fQOpMaSObnEjVwcQvBQuLcW21
 0l0GGa8uIBUzkYQoPv47hxePfr+czgKpre7NhJoyq+9Ih5fW8U4ONDtIW2X8ssuMXc8MqcUE5eM
 iaCcuYhHp8Za6OzknIRb4E0hwvChmC/k65X4sF73R6+2DzX1ej2QgiIJ8iT2kENU7PhEMgwZZpT
 zmq4henJ5/ZF//HqwT9eHwXtln9nuYZAb35Y3oA7CpqqHsnyqPMAmxbSspmoyGahmeltXDJmx/7
 7B5vx1DY8qetXh3DfAJ3Jkm5WqSEBqsOM/tCqpsn5Txzg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3f4385a223484ef3;
	Mon, 14 Sep 2026 02:52:09 +0000
X-Mizu-Trace-ID: 3f4385a223484ef3
X-Migadu-Flow: FLOW_OUT
Message-ID: <8360c969-33f5-4d96-a44d-c6fcb7a8a41f@chenxiaosong.com>
Date: Mon, 14 Sep 2026 10:52:02 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ksmbd: fix partial normalized name responses
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
 chenxiaosong@kylinos.cn, Mobin Aydinfar <mobin@mobintestserver.ir>,
 linux-cifs@vger.kernel.org
References: <20260913113552.11486-1-linkinjeon@kernel.org>
 <ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

If needed, I would be happy to help send v2.

And it would be better to use FILE_NAME_INFORMATION_SIZE (should be 
changed to 8) instead of FILE_ALTERNATE_NAME_INFORMATION_SIZE.

```
smb2_get_info_file()
{
...
	case FILE_ALTERNATE_NAME_INFORMATION:
         case FILE_NORMALIZED_NAME_INFORMATION:
                 fixed_len = FILE_NAME_INFORMATION_SIZE; // 8
...
}
```

On 9/14/26 10:38, ChenXiaoSong wrote:
> Hi Namjae,
> 
> According to MS-FSA 2.1.5.12.30: https://learn.microsoft.com/en-us/ 
> openspecs/windows_protocols/ms-fsa/3d5c68f8-fbc5-4f94-a51d-3600a319fd45
> 
>    Set AvailableNameLength to BlockAlignTruncate((OutputBufferSize - 
> FieldOffset(FILE_NAME_INFORMATION.FileName)), 2).
> 
> It seems that the following changes are also needed:
> ```
> smb2_get_info_file()
> {
>          unsigned int req_output_len = le32_to_cpu(req- 
>  >OutputBufferLength);
> ...
>          case FILE_NORMALIZED_NAME_INFORMATION:
>                  fixed_len = FILE_NORMALIZED_NAME_INFORMATION_SIZE;
>                  req_output_len = round_down(req_output_len, 2);
>                  break;
> ...
>          rc = buffer_check_err(req_output_len, fixed_len, rsp);
> }
> ```
> 
> By the way, it seems that `struct smb2_file_alt_name_info` should be 
> renamed to `struct smb2_file_name_info`, since both 
> FILE_ALTERNATE_NAME_INFORMATION and FILE_NORMALIZED_NAME_INFORMATION use 
> this structure. See:
> - MS-FSA 2.1.5.12.4 FileAlternateNameInformation: https:// 
> learn.microsoft.com/en-us/openspecs/windows_protocols/ms- 
> fsa/5051d021-8d06-4b7e-94e3-55b118193427
> - MS-FSA 2.1.5.12.30 FileNormalizedNameInformation: https:// 
> learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/3d5c68f8- 
> fbc5-4f94-a51d-3600a319fd45

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

