Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8912B3921D8
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 23:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789429755; cv=none; b=kTG1kxJZehykjuaJCc7SVll5rbBkRSEPEzpJjjlf0IP6VrXsp2PgxndqMvgoCqf43rlzMi5GRl8vgOv/1GiJiKtAjaMhyv28H8epg7N3w0FiqQw8o5shr4URgnQ5cwbQHdeStFercWChTf9OZK5PZ5JTZfHtX+IWlrI8zCN/D2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789429755; c=relaxed/simple;
	bh=1s4qECh5atXlexRf19vpBoKsTrx2P8TXyD3JaHc1j60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLmeVBCeWTodofggzxe2E9qB7jUdIx+emg/V7ywf5GeZeSfbHW3QVi6DTXse+ESYvI4pCi0GuItkxOwugK+hoFv5ZN4aEF64uxbFKia+RZ9N/o34eB9bGma7qerRY0qaub3izpOhn+4n53bjcbIPvQ9XcHlXl7at8bOUDFPHd+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=OHG2avxW; arc=none smtp.client-ip=91.218.175.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="OHG2avxW"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1s4qECh5atXlexRf19vpBoKsTrx2P8TXyD3JaHc1j60=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789429746; v=1; x=1790034546;
 b=OHG2avxWoWms+julpdobBCp3lOj3fiAWFFbFMbcfFB4bS5dLo7RQhE5g/dJWaMLe0AsVRQ/Z
 eALRB/z4GrQ2mx7oPT8Av8VIpEF7BfNGewpXHNZFJZp94DHJ7fItdAT4THQF3wdNcLrmaO/Bfw8
 KHfVluV7jDNE5Lx+TeYn/kEHcyz715h7wfwVir1k1s46SUSdYeXKdfrBOUtBtiNgTTbcl3VQpeV
 I5r65YGhhjN547XeOjUg9rHvin5n7AmaZXxfRfEruf4KtZg6d/IYx4AXa3gk+Lzz2V2UdEDjqJH
 3QjmyTIqj5mjTWh0lgJL/u979Js9LOSw6G6Bs+Q96GdLA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5164600ab1574f70;
	Mon, 14 Sep 2026 23:49:06 +0000
X-Mizu-Trace-ID: 5164600ab1574f70
X-Migadu-Flow: FLOW_OUT
Message-ID: <d1b5ef61-c0e8-405f-bf33-12ee695b73a2@chenxiaosong.com>
Date: Tue, 15 Sep 2026 07:49:11 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: keep compound responses on query info errors
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
 chenxiaosong@kylinos.cn, Mobin Aydinfar <mobin@mobintestserver.ir>
References: <20260914111543.12381-1-linkinjeon@kernel.org>
 <20260914111543.12381-2-linkinjeon@kernel.org>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260914111543.12381-2-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 9/14/2026 7:15 PM, Namjae Jeon wrote:
> Do not reset the RFC1002 length of the complete response when a query
> info buffer is too small. The current command will add its error response
> through ksmbd_iov_pin_rsp(), while resetting the base length can truncate
> earlier responses in a compound request.
> 
> This lets ksmbd return the earlier responses and the query-info error
> response together. Remove the now-unused rsp_org parameter from the pipe
> query-info helpers.
> 
> Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
> Reported-by: Mobin Aydinfar<mobin@mobintestserver.ir>
> Signed-off-by: Namjae Jeon<linkinjeon@kernel.org>
> ---
>   fs/smb/server/smb2pdu.c | 31 ++++++++++++-------------------
>   1 file changed, 12 insertions(+), 19 deletions(-)

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

