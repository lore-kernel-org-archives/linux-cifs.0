Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B21530D3E0
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 02:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789353503; cv=none; b=feUjl1LR/tnjyaiEvJVHt7jGzbYgTHgMh2I/tfIyXoHMtSj7TBV+7qNw//XQ6Fzl1MKRZm7H/eGCI+XTOxNm9XCWn+yWSS0W65/8Vz2gCcZKupwfoaVehSxItJItAdYhmSJiVUSqaQ1iymj5OAj3OOCfk57qY5OlSMQ+1XLLshs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789353503; c=relaxed/simple;
	bh=3Ik4WNQy3c9C8bVnq3trfSLp9qmQTeT7JCMtUUcJNvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJr7uq7vTfBnbdHzS0ARcqSnkXAIgDfpkYB1EGg8Lkf/jWgiw+Rlzr9eHg8aE9A+lhjTtI+7AboS0o+B5nCyzmqfBcRDLZbAdAx0d+DOSlR3UD1b6rvg6e4h4XgE4f0m+MHu/UKzsBmZMW79M6evGiyUEeeKUj9YBHK9o9CmH2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=npfzqa+Y; arc=none smtp.client-ip=91.218.175.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="npfzqa+Y"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3Ik4WNQy3c9C8bVnq3trfSLp9qmQTeT7JCMtUUcJNvQ=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789353496; v=1; x=1789958296;
 b=npfzqa+Ybk5d07ENizaKNyFMq+D3eHLoaHCjvXmggUKGs6z+ckxIKvC+T9TCPcp5B5ZHVvJk
 sBi9vzfrqgJnfRijfz7/Zlgdsedu5yXes7YXB96Ejsg3daj+ejRlwwa3JEd1VasVZ9QDqCda16R
 v2BNbh2HXZc9/RWkIJIoTGluK83OrJRWEz8GzgwywrBFkb5QtjhhszEd3RiL3XhYTl5+S5lC1O+
 M2NOucxigImYhWijqCrwvswqV3a+rcpwTMlUrZzHeTNcwT4rxX6af6hPma/daHF//5yU4g2A7+p
 XUkOAvgCV3fg36bZupplGxoT8i5O51pD3b9xI0lp8VnIQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bd8c35e081a59473;
	Mon, 14 Sep 2026 02:38:05 +0000
X-Mizu-Trace-ID: bd8c35e081a59473
X-Migadu-Flow: FLOW_OUT
Message-ID: <ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com>
Date: Mon, 14 Sep 2026 10:38:00 +0800
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
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260913113552.11486-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Namjae,

According to MS-FSA 2.1.5.12.30: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/3d5c68f8-fbc5-4f94-a51d-3600a319fd45

   Set AvailableNameLength to BlockAlignTruncate((OutputBufferSize - 
FieldOffset(FILE_NAME_INFORMATION.FileName)), 2).

It seems that the following changes are also needed:
```
smb2_get_info_file()
{
         unsigned int req_output_len = le32_to_cpu(req->OutputBufferLength);
...
         case FILE_NORMALIZED_NAME_INFORMATION:
                 fixed_len = FILE_NORMALIZED_NAME_INFORMATION_SIZE;
                 req_output_len = round_down(req_output_len, 2);
                 break;
...
         rc = buffer_check_err(req_output_len, fixed_len, rsp);
}
```

By the way, it seems that `struct smb2_file_alt_name_info` should be 
renamed to `struct smb2_file_name_info`, since both 
FILE_ALTERNATE_NAME_INFORMATION and FILE_NORMALIZED_NAME_INFORMATION use 
this structure. See:
- MS-FSA 2.1.5.12.4 FileAlternateNameInformation: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/5051d021-8d06-4b7e-94e3-55b118193427
- MS-FSA 2.1.5.12.30 FileNormalizedNameInformation: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/3d5c68f8-fbc5-4f94-a51d-3600a319fd45

On 9/13/26 19:35, Namjae Jeon wrote:
> Windows may request FILE_NORMALIZED_NAME_INFORMATION with an output
> buffer that only fits the fixed portion of the variable-length response.
> Treat the fixed portion as FILE_ALTERNATE_NAME_INFORMATION_SIZE so ksmbd
> returns STATUS_BUFFER_OVERFLOW instead of STATUS_INFO_LENGTH_MISMATCH.
> 
> This avoids rejecting valid partial normalized-name responses.
> 
> Fixes: 6b8b79226bc3 ("ksmbd: fix partial file information responses")
> Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/smb/server/smb2pdu.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index f4d96799e1d2..38cddbf3e6ed 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -7318,6 +7318,9 @@ static int smb2_get_info_file(struct ksmbd_work *work,
>   		case FILE_ALTERNATE_NAME_INFORMATION:
>   			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
>   			break;
> +		case FILE_NORMALIZED_NAME_INFORMATION:
> +			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
> +			break;
>   		case FILE_STREAM_INFORMATION:
>   			fixed_len = FILE_STREAM_INFORMATION_SIZE;
>   			break;

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

