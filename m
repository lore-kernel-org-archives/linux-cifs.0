Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424A534D4C1
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766590180; cv=none; b=OjlsRzkMzuus8MuqD699JfbETrnbszLih8tfcxuQXgDk6jcar76wJvTPYMuipn4kEHTBOCX9HALFfe92vq5/XlNb6KPpJxqfNN7K63BaZwK+Rt5OQUvYwDsmB3KR/1r3gmKGfD/xTmq/RP9rdpYjn+2ZuonehdaX8FSHPcRMCds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766590180; c=relaxed/simple;
	bh=kgmbovITcXgW2L+toZztyIOs0YJ3TwKIe2J3Jy7qfsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=APUaNMRpfTeSCkNnkiKY+m8TvSuQ5R0L76PZATXNFFItLfpNhRcWAc/b0U9RIev+u1hdIRQPES/YEaFWanaGVyagOnXU2/VI9QMwbfuwXowS1hXzTJMMHip0H12XRpvh5N4XqmXrCXia00+UkJQKztw7T5W/08eZ5SBUiwfeIWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fByLzBxn; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fByLzBxn"
Message-ID: <b6db33b8-b81c-4095-b3d0-ca72b636feb7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766590169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acA9/Zo0NOx3ozHug5d/KTKvqfHtmT2j7XAKVvpLFCA=;
	b=fByLzBxnHcH9tkhem+G6fiHW7mxmPlj1KJIa/ZEPyecjG5wcA9B0Se21TS0l9Eh+IB6Ur9
	vP1UgNxUxqt9rgaVRUffW6111OFyrKqdP7IbJM1gxFcd3p3kxbxzUEDyncWMOPA+gxRHu2
	aCNKlWfceBZ4XHwTu1ZaUrha1fGX0mo=
Date: Wed, 24 Dec 2025 23:29:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 5/5] smb/client: introduce KUnit test to check search
 result of smb2_error_map_table
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>,
 ronnie sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath S M <bharathsm@microsoft.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 CIFS <linux-cifs@vger.kernel.org>, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251224023145.608165-6-chenxiaosong.chenxiaosong@linux.dev>
 <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
 <1168035.1766564530@warthog.procyon.org.uk>
 <1b7feec5-aaa3-4bbd-ac7e-76aa871f779f@linux.dev>
 <CAH2r5mu604z2DSdfYYaCoRJ16AdCdUdmNUDYEAU4Z5mXttEFSA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mu604z2DSdfYYaCoRJ16AdCdUdmNUDYEAU4Z5mXttEFSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

When CONFIG_SMB_KUNIT_TESTS is disabled, it does not add anything to the 
size of cifs.ko.

This configuration option is useful for kernel devs running KUnit test 
harness and are not for inclusion into a production build.

Thanks,
ChenXiaoSong.

On 12/24/25 11:21 PM, Steve French wrote:
> Does it add anything to size of cifs.ko? Does it execute any 
> instructions by default that could slow module load by default?

