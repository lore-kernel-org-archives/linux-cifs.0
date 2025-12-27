Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C1614AD20
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766827769; cv=none; b=IImTgX8dcI+TkXhmu4FuPtfDu+QHH+jEeBufq+iTa+3OtwD6LHFayuioCSNpVH8bqWJK1ahs+bWPGj9VNHWtQNPRIZM1fs2ZnyadLMHPqdfN7DtXvcv0A2YyZl7lAFczvlfO/MLJsq3h5hy27jZ+rjjwox77K1H5ji7tvgbsU30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766827769; c=relaxed/simple;
	bh=flgUUfETzAgWp+/blMK2m+/Doq6B6/GZgO8OWP4DEgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EYyjaLfHiPPxvQXpH0R9Fo+oMH1jfqNbSrL0+9OSXcwwX3GB24cFwkNtllOmAeqJFl5O7pl6zAdG9PKShTyjSDNA92RgRXQL1B5byhQqOjPnEZ2g0I2KbOPqUjNtSoNiYTATnYWj2/fxefw7mfSFsoWA/7tUorOJ42e/fj5TjJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oGqjdSQ2; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oGqjdSQ2"
Message-ID: <d84af000-7d6e-4104-82ce-de9d08e46f92@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766827764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t046Ze3C8fLc5A2OU8Kece97QPVJ/ioaqt7aUv5/mjw=;
	b=oGqjdSQ20uuM6L6KVZdwsQSJTFSohoDOQ3PTiSQYfPsbdN2KQi8uR4nXEQ4BrlwRyjZXD6
	XqhTtKjP+TdPNYJsGxvMmk1wDwIvA0lnwKuvjErd2C/uA8/bISIQL+iqHjVXiYn8Wwmn6L
	lyJTYr3S/hseU+Q32la4JZo1xKooM2o=
Date: Sat, 27 Dec 2025 17:29:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in
 smb2_error_map_table
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <f0740fbf-1142-42f8-b56f-937fa915a4bb@linux.dev>
 <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <1236711.1766750798@warthog.procyon.org.uk>
 <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev>
 <1264023.1766825812@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1264023.1766825812@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 12/27/25 4:56 PM, David Howells wrote:
> __le32 key = (unsigned long)_key;
> 
> Ummm....  u32 key?  I'm pretty certain it's sorted in cpu-endian order.

Should we update the `gen_smb2_mapping` script to sort the table in 
little-endian order?

> 
> Also, check the assembly - it might not actually matter as everything is
> inlined.  The compiler might well optimise away with the thing being passed
> through _key and any dereference of that entirely.
Even if the compiler optimize it and the function is not inlined, it 
seems that `key` is never dereferenced in our code.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>
