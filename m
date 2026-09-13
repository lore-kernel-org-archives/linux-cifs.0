Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2930D341ABB
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789314349; cv=none; b=Qa8GejPJkNUXasFLCmn6Pc1a0GxFkQ5B/Mbro8Iv/PnT5MdeiKa8st8VnQc+n3Lu87eksTTaSJnXs+Q/Kvxe4QDgGDb6xdKTLQkdgY+mYemI7OmJ1nbUSHZAfxZ6jYdBnmsBep7aIQmwcLkibQlAIJTCrZr+6xEUig3BMr0yw28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789314349; c=relaxed/simple;
	bh=TvQ1vU6fRkT4x/cgFcxKEJbQD6lvwCd8mYsRes5vruk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tK9F27Q3GIP41/Fj/SiVO+0kBTU/eielvxwDisLpXrTo1gOn06y4j5XJQltMbLLbLQp8ki2pq8x86AJ4MhdWgvN7Hk/Ak/EfLQ0Nl8HfIoEu8PL4majW1xtTISX9RFDLQFoaS4DYkMTLOYn9Lp4U50vg+IuFuUF0t75FpdyAvJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Z6DeJwtZ; arc=none smtp.client-ip=91.218.175.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Z6DeJwtZ"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TvQ1vU6fRkT4x/cgFcxKEJbQD6lvwCd8mYsRes5vruk=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789314341; v=1; x=1789919141;
 b=Z6DeJwtZulZAoLAS85Mc6DiXLvrqNHy8CdBqfnb4wFakCOX5l2YyS3POmiVrNpIxkJPTfJcs
 Fz/nmDoGM1OBZAJSIefxtweY+535BAAYVsnhLw+FF1034+mghMV7nq0V+FUuibIuy2doLroiTti
 ODwa7bd0VMTTJDpJqiG52VgmrFChLVQR/REFWZN8UjxExsOhRd3I3UXbvkZ0QnJUB+E1s5mSKSn
 +vWqixtpgjNSdMdDCZshUUFsjGm8ehaISqcfhIPqvYSU1rMEX+n3TO5OFp6qEGcQkEWwa4P1dcM
 EdFt5b8eWjeMXFnTF3CB9OdNEJXSdcqAckt7+ZjeQvhhw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e491f35724909c93;
	Sun, 13 Sep 2026 15:45:31 +0000
X-Mizu-Trace-ID: e491f35724909c93
X-Migadu-Flow: FLOW_OUT
Message-ID: <07866f8b-5170-4fc4-aa78-503038f2ef5c@chenxiaosong.com>
Date: Sun, 13 Sep 2026 23:45:35 +0800
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
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260913113552.11486-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Should we define a new macro FILE_NORMALIZED_NAME_INFORMATION_SIZE?

On 9/13/2026 7:35 PM, Namjae Jeon wrote:
> +		case FILE_NORMALIZED_NAME_INFORMATION:
> +			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

