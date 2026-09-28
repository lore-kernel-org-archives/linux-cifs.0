Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A773D73
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 00:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790555912; cv=none; b=a9ExyE59weV5/Q9DEf8BeRLMtKnaBEeCTurIfK/FcgFi+ynIk6AQUgdPzxiWtcDLSEKEdyXUzfNrzyNFV17GUBxFIkEgGk8Unii/G5InkeKGiz7TUAwypG6Of1igWHVeZwau6789/FexArPtQTyMfU7ZnOTGMGAihMQn+BLUBZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790555912; c=relaxed/simple;
	bh=zVj5nOUfi4CUttk9TvZPa6fa77tlRjsUaCF+FnG7GMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UUVQNYAmvrMmas123bof7dNn7ravhtOznHeYbtQwWwKSFeKUE+K2TRxOyzD6gYlT0dmcZqV2UDrxK0M6FR20yAhr8yKrF44jnR5CCf7a83+uVk3vX8mHdWehIXNC2Mpo8BJvxSczbCX8xtIgqwCJ2JgMF10nkamGsuDZ+VS/LNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=kxkyOpP9; arc=none smtp.client-ip=91.218.175.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="kxkyOpP9"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zVj5nOUfi4CUttk9TvZPa6fa77tlRjsUaCF+FnG7GMY=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790555906; v=1; x=1791160706;
 b=kxkyOpP968cBmgNWvhTjPbuTDEddvuqh3DxeNHuIMMXCn7QmwwdGwxHgoI/OSNQyM0zXtII3
 MAXxVt33yt7dnyaKEceu6cdwNddz36h/Af3Yrq4NHX2huwjE1RdtN3u975yw/aPVu+wcAfWl+zA
 Tzj3RpjcPfFczZFwMt5tIxN8ThnU+Z9fLPRpGv+zWqXhI7zkvxvtW+hazSWa68PyypGlizZ5w2O
 7+iN4+SyCA6KwzXovkBLTBs5OIFciwXdu4sEFnFT38qDSIQ3br7iMY9CniRJvuKJ6/BbHPbD9P8
 RvqvBs3tI0ISCsa97728WKJHu989E3+gqDMTwr214EMOg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 361e5ae07208bade;
	Mon, 28 Sep 2026 00:38:16 +0000
X-Mizu-Trace-ID: 361e5ae07208bade
X-Migadu-Flow: FLOW_OUT
Message-ID: <8426bd7b-d0e7-499f-91d8-8549a8c1e591@chenxiaosong.com>
Date: Mon, 28 Sep 2026 08:38:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] smb/server: support non-recursive directory change
 watches
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
 <20260926090518.78547-5-chenxiaosong@chenxiaosong.com>
 <CAKYAXd9OTKFO1actbPQUJqorAw4ZW7iBVEmbo_nVe1hjCL-uug@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9OTKFO1actbPQUJqorAw4ZW7iBVEmbo_nVe1hjCL-uug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Yes, makes sense. Thanks for your suggestion.

On 9/27/26 18:51, Namjae Jeon wrote:
> Should we also map FILE_NOTIFY_CHANGE_LAST_WRITE to FS_MODIFY and
> FILE_NOTIFY_CHANGE_LAST_ACCESS to FS_ACCESS, then add FS_ACCESS to
> KSMBD_NOTIFY_EVENT_MASK? With a LAST_WRITE-only filter, ordinary
> writes emit FS_MODIFY, but this watch subscribes only to FS_ATTRIB, so
> the request can remain pending. The same issue applies to reads with a
> LAST_ACCESS-only filter.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

