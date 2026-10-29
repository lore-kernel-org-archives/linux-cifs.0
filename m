Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793289040;
	b=PgzOpQ0ly0FJ8hg1ElmyY5npKMeugNQsYaKoNUDx/c734cn0njzc86PinXk4tSAHkDDr
	 ckeIE9jmrbZrl10UsUkWInou+gcWOU6Q+aSClQ1yAjiq6MljUAQ9qkME1XbgfmaEcFeIc
	 yLTGCFbtIxqIF5Yjk4ShlfQd9pNUUhv2VYO4FN8JB029zD93ntKp1rSHIBlOPatEABfKk
	 +R9red5ckds1mHqyIPLoDyhzKI10nqiGfaXfiwduu8MoA4nL2YriH+qH80HFACT2ejl0h
	 6dEfQcBEiakD0oxVtAdfujetRvJXskpLGNi5insKL7VUvAsL4OOhpRjFnTjVouDamAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793289040;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=XTXAk3xXPUgSSlYSBEKFxO0EtkwpuyrpEnArRai3PhQ=;
	b=3cHIEypQGaDFtv3VZQLTThdxbdBrkO0BfaCqdtSzxX1ZNQxApULHDedDP7//YWb9NCaY
	 toeb/3FBwoRtD174UVtatP6+qP4yDPyYRY7UtrDo5Hkiz2ZS9O/bGWokYv+TQay5/a4dC
	 /OuH69+ehZU8izPh6UMFbz2iNNPtN4Pql4ccbfyFam5JozS6nCq/2NmbF/4qearcXcyUl
	 ciEisBh3NbFEzAypM6ZZYSaG4BR7mFJO7aB3cbsbIhbp1D5K1AbWLfvVJ0k7QUDKRf4w7
	 2IwWLHAqpgEDrIqgG3egVnv46vRhcV9gJGQkAs1ZIxp2CZMxTvVZr7GZxb9/1644r3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AOPBZUpn;
	arc=none smtp.remote-ip=91.218.175.174
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8060B606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 15:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8060B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AOPBZUpn
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=B9FHC8KG/+vE+zt6AKqt5Y1CXop9kLlRG+4oSR7pzX4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793289036; v=1; x=1793893836;
 b=AOPBZUpnPGeXox5bHPAO7hB9MroJwbu4lsFdymYprRzFQilA6eVvNQcLYs8Uj4fUT2HJrOld
 u0sAka39rzDN2rVn/KbbMexzDuZhROB/9op4AM0vVi7kh1JqFwfOVZmru7PVzR2WjYUeJ0Ot34x
 1w4SlQ2XVa/jGXg9yTPXMYCY=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 112fd546f967c449;
	Thu, 29 Oct 2026 15:50:28 +0000
X-Mizu-Trace-ID: 112fd546f967c449
X-Migadu-Flow: FLOW_OUT
Message-ID: <174fe1ca-7b5a-466c-b20f-fccbccff6eff@linux.dev>
Date: Thu, 29 Oct 2026 23:50:24 +0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] ksmbd: send READ payloads with MSG_SPLICE_PAGES
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com,
 chenxiaosong@chenxiaosong.com, tj@kernel.org, linux-kernel@vger.kernel.org
References: <20261022092514.2590010-1-huiwen.he@linux.dev>
 <20261022092514.2590010-5-huiwen.he@linux.dev>
 <CAKYAXd9SW_D1gwMhD8gVjVJAcPoxiXvHB0TvDLqnjw8TpGCKRw@mail.gmail.com>
Content-Language: en-US
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAKYAXd9SW_D1gwMhD8gVjVJAcPoxiXvHB0TvDLqnjw8TpGCKRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/10/24 12:44, Namjae Jeon 写道:
> Order-8 and order-10 allocations can easily fail when memory is
> fragmented. Since MSG_SPLICE_PAGES does not require physically
> contiguous pages, could we allocate individual pages and use a bvec
> iterator instead? Please see drivers/nvme/host/tcp.c as an example.

Yeah, I agree with this. But I tried individual pages with a bvec 
iterator. It was about 9% slower than the high-order page version.
Anyway, it still faster than the original copy-based implementation.

Thanks,
Huiwen
