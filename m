Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CAC399899
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 23:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789429740; cv=none; b=aCPOOx85KV9rUT7A3DkPcrBac8tjq9HPtYBUm1Qra1eX8uQVWp+MBV3nooNPDN423p10GxerzY7Eg3PPwmRG3iL3c/EYDs03VkDffAiwFY9NxbqZGdSB4xHoWI8/TY8bDn5/nKZ3A1LFMJYFNDAWgM3vCTTAXS+Jxd34NxI4hIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789429740; c=relaxed/simple;
	bh=lydbf8R836lpdb5f7eJQzRThGz/VP11/1Dwxly2Q1vY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aAPy/WPDYG7LeJmiHj3Q4+zbfyDHZOz0jMxAOrUH0SnsHnGxTLRAUPgUogzFfzWXPHP5MGaw/czKwGA5QBMyh1pQdhWoSdRSjLtEJXgO4bcU3Rn+LSbXxylwMVTFZbWGATxF4CVh3BHpYpouR6IuLCIdgMA2ui4HzIVWEUVE19U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=YsKC/jwO; arc=none smtp.client-ip=91.218.175.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="YsKC/jwO"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lydbf8R836lpdb5f7eJQzRThGz/VP11/1Dwxly2Q1vY=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789429731; v=1; x=1790034531;
 b=YsKC/jwOKcPv2YIF/QBh58ZWD2r5nxW/1xzo88FSuAGlpTwU66DCFmhPpdZrgOwuh/DJVNtP
 kM7SOYxjfS9BfZcmSF3l8Q4rQrNsFwRp2PyEouuapzYHZu7mra31bx6fv/46wX/5dSv6y1i3agQ
 rhvC9Sshg96Yvfn+sQotujKM6w/VeLfXTVNpl0/8Rw1zYPJq63S0NElfKGxESI8bXFsUgCImu2S
 FC57RfDutSpAgJseybLv2TmNZeSHG+QSTlAgLPLDpnwWfouRqT+5SjHsbREUgKi1TM4AAIr4oWk
 PEPdrwQA0/HttLssXm04OndPV7x36CulleFJI79rekjVg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0e07bb01f6e26aee;
	Mon, 14 Sep 2026 23:48:41 +0000
X-Mizu-Trace-ID: 0e07bb01f6e26aee
X-Migadu-Flow: FLOW_OUT
Message-ID: <f407051a-ca2f-4b62-9d6f-86f7cf673821@chenxiaosong.com>
Date: Tue, 15 Sep 2026 07:48:41 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: fix partial normalized name responses
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
 chenxiaosong@kylinos.cn, Mobin Aydinfar <mobin@mobintestserver.ir>
References: <20260914111543.12381-1-linkinjeon@kernel.org>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260914111543.12381-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 9/14/2026 7:15 PM, Namjae Jeon wrote:
> Windows may request FILE_NORMALIZED_NAME_INFORMATION with an output
> buffer that only fits the fixed portion of the variable-length response.
> Treat the fixed portion as FILE_NORMALIZED_NAME_INFORMATION_SIZE so ksmbd
> returns STATUS_BUFFER_OVERFLOW instead of STATUS_INFO_LENGTH_MISMATCH.
> 
> This avoids rejecting valid partial normalized-name responses.
> 
> Fixes: 6b8b79226bc3 ("ksmbd: fix partial file information responses")
> Reported-by: Mobin Aydinfar<mobin@mobintestserver.ir>
> Signed-off-by: Namjae Jeon<linkinjeon@kernel.org>
> ---
>   fs/smb/server/smb2pdu.c | 3 +++
>   fs/smb/server/smb2pdu.h | 1 +
>   2 files changed, 4 insertions(+)

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

