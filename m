Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF141191F91
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789315852; cv=none; b=GNxShWqvh2cb6fvAKZ3fHVFL3gX7updJ6j0ELv/JGNJvANawV0JwCKOb55rLEz+KAFr9Ik7u1WtX6CIxtle3vWTMuLuzmRfVLlwTNzYBNoKdc+jQmZwrpruRCgdpijZNvqeItFyEHne1JfocjXnc5ioKNntrqZ4b1POSaKycajA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789315852; c=relaxed/simple;
	bh=FPufHam9DIrQdO54YW4mwWexU9cTJFnDu9Ld6J+gIoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kI1BFwpd5dz5rmwLGaBMIKarV4S9YP+xo1173USnnPorMK9ZhT9Xf8PFR7Ez2Mp5hgnp1qgQMc9t14MO780ib6KXC+C7bdxwwmKfkfUXV3L9i09OYJokgS6We6utbedx3sgy/3mbf/I4xlAJNelavqUjTg/hTNw61lKqj3l6OLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=kIMA2gPm; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="kIMA2gPm"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FPufHam9DIrQdO54YW4mwWexU9cTJFnDu9Ld6J+gIoM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789315846; v=1; x=1789920646;
 b=kIMA2gPmO3VviPYudTgAmerlxu5gZfqnsLn2v/A7uVofoD1IUe2an4xZ1QA2552RQ52ktEIl
 UGh+Ya5Wm/H9I8W2XmWTaxqpxNVAUkMvRwcZW6cOiMMu4+57CQ1LG8oxT59DvSTFUQ3/8P6tYGX
 CFKNYUAPCD/d2N+pRTRizG9KRVXXvhQKL2SDmL3X3IANtxuIMpFi+MVr9dMDhlLpVOQAzTsABYR
 0CGAqestgq5YgaY1coEyjuhaCzTYOmgmDMqhSI9rO1K218BsGFmFQPIOlnjya+CHnMgfnlelCa5
 TUY41uoPzP6CKCkv1bTeqPHKk2aYnTEoUrBULIfOSAKAw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 73dca2414569f217;
	Sun, 13 Sep 2026 16:10:36 +0000
X-Mizu-Trace-ID: 73dca2414569f217
X-Migadu-Flow: FLOW_OUT
Message-ID: <bb7ca0a6-918d-4fa2-96ca-9ccc31c20bf8@chenxiaosong.com>
Date: Mon, 14 Sep 2026 00:10:41 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ksmbd: keep compound responses on query info errors
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
 chenxiaosong@chenxiaosong.com, Mobin Aydinfar <mobin@mobintestserver.ir>,
 linux-cifs@vger.kernel.org
References: <20260913113600.11540-1-linkinjeon@kernel.org>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260913113600.11540-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The `rsp_org` parameter in the following 3 functions can be removed now:

- get_standard_info_pipe()
- get_internal_info_pipe()
- smb2_get_info_file_pipe()

On 9/13/2026 7:36 PM, Namjae Jeon wrote:
> - * @rsp_org:		base response buffer pointer in case of chained response
>    *
>    * Return:	0 on success, otherwise error
>    */
>   static int buffer_check_err(int reqOutputBufferLength,
>   			    unsigned int fixed_len,
> -			    struct smb2_query_info_rsp *rsp,
> -			    void *rsp_org)
> +			    struct smb2_query_info_rsp *rsp)
>   {

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

