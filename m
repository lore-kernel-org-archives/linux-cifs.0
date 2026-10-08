Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5B033F38A
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 03:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791431940; cv=none; b=FwdS4PLM42qKTEsgUX3N7G1RSOgpwrEE+ZA2RacA7dl1tGpsk1DBlum+jIk66O6VeLqIdUpA5v8EIQ9rBTaYPeZ/zF+nLYpz68vgCddbfKYBOkIFhHQVbkE8JtQlFLg0YNvyAC52jzmWVim3I6UrXytOR3Du6wzJN+63/tr0VoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791431940; c=relaxed/simple;
	bh=nkwu7vfUb2ryMR3QqjL0EFc7gRy739u6enhSo1K/f6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UWATaG60dzKDsJz99qBioOGPha/cBfOZrjSHFUOt9OwUEqWdhZI/wtmy0dG0f0z0x9WKdONBsfWfgo+YmQomkydjFyCMiN6JOEN7wosmizNXbxYa3qMX4RVMVmjN8xHcSh7kw1eKb8IXX67sN7+MlMsOcDr4bpsuJn+CAyvhA9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NSFJMhLu; arc=none smtp.client-ip=91.218.175.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NSFJMhLu"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nkwu7vfUb2ryMR3QqjL0EFc7gRy739u6enhSo1K/f6A=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791431933; v=1; x=1792036733;
 b=NSFJMhLun2mtj9kGmj1hnVDKiNY594I4F45hckO++XZD1jkH12peQqvYtXVXMxnpgkEsO09S
 cb5GnMQuRLpIpXblZfJSngWWdTGuljM1jKgZDkQMIWOd5DyxMAjJCQ1YaMxE76UTEGE6qsVFmgy
 wdZT0ni7hPRtmBCwtjYaANO46EmQHL3DfMkJG2WiLGuVC8QuamkM9OIgeSuqSLVSeP2YUzP869r
 5uAaHUTbYfLv6KdjAwOwv4Gg4EOj6pcWG00G/ezQnyXOyX5N8RZAr94NvZyKmF+NOzMx4dc8jks
 MgTXVgZI/Zqd7IHM5pK35EgrN7sd5bXr9EStUOv127mxA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cfde8933eece9068;
	Thu, 08 Oct 2026 03:58:43 +0000
X-Mizu-Trace-ID: cfde8933eece9068
X-Migadu-Flow: FLOW_OUT
Message-ID: <817aca1f-5e17-418c-9bd9-c2a0180ca9f1@chenxiaosong.com>
Date: Thu, 8 Oct 2026 11:58:41 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: validate share path for batch oplock reconnects
To: Namjae Jeon <linkinjeon@kernel.org>,
 Sung Byeongchan <tjdqudcks0424@naver.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261007074444.84875-1-tjdqudcks0424@naver.com>
 <CAKYAXd9sNGp8G8N0D=4a_SX89L7zGGGcH_kN0r7WUhvur=fc=g@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9sNGp8G8N0D=4a_SX89L7zGGGcH_kN0r7WUhvur=fc=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/2026 10:51 PM, Namjae Jeon wrote:
>> @@ -2489,9 +2489,10 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
>>                  if (opinfo->level != SMB2_OPLOCK_LEVEL_BATCH) {
>>                          pr_err("oplock level is not equal to SMB2_OPLOCK_LEVEL_BATCH\n");
>>                          ret = -EBADF;
>> +                       goto out;
>>                  }
>>
>> -               goto out;
>> +               goto validate_name;
> SMB specification(MS-SMB2) explicitly skip path name validation. The
> filename mismatch check applies only to lease-based opens
> (opinfo->is_lease in ksmbd). This violates the reconnect semantics.

Yes, see MS-SMB2 3.3.5.9.7

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

