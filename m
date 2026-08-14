Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DA2357D17
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 06:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786688842; cv=none; b=GM6YMapLgzCZLUZZfLkQ1J458V9cwSQkgS5csEV6zUvkOA70i8ZIQbQcV0A9DYIZyt4SrhsaOyS3/EyU6Gtc6ohY9oxm8eg1agY9/hXBmZ1IHxdywNBigKcpAIVYNzb+/hYUC5+Ga83EsKysR58KmyVlLeYp7VWUXEPEG0D/9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786688842; c=relaxed/simple;
	bh=LRZpPMDN6u5Jd7Ipt+60oHYOL9AAamgB/nsDZ9afaa0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isK6XHXaysVB6QhtU+QRYggy7ufedEIsAo9/G2j+fQPserTAgMPWGd1BryTKOnogCTAK1XB79n0bfsNsuGaJLmcySNykK9Zbqi/gfkQ3tc4dU2QhVAh5d5J880Zf2QqAQagpzHRBNsI7dQ376hPguupeDobTuXYHoFu5PMfFyQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=uVruuBMw; arc=none smtp.client-ip=95.215.58.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="uVruuBMw"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LRZpPMDN6u5Jd7Ipt+60oHYOL9AAamgB/nsDZ9afaa0=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786688836; v=1; x=1787293636;
 b=uVruuBMwtDMl+EYrPlqGqsKUM3IxcAV8pJPGaDh2lgn8Aok9jZaeCoJNmDSI4aEZmRgiVsqI
 8Urq1EEvKn37RVnHCgkXJ1Y1WBaPQncxdwwpkTHPrPMZeytW7KC6gbQ8oWal8JRnOGpoN1KBfZJ
 HW7QNQV+woWnahp5WY3jiCd8GeUNS7nvmC6hvSOfMsiaHDYkV3lGZwPMr8iYKeISlLgZyi5f8qw
 ulw0KQhQSY2wZzJItfawfk21hSiegBIjY9IyPfANGVDo9G6AqVO4CJ1ywUDhee2hUjOZCresQn2
 7pGgHe/p64uZKqJopbOpCgsna59YzD13WtDCemYYzFcdA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 8bc562be64b96736;
	Fri, 14 Aug 2026 06:27:06 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <d7cb5234-fd5c-49cf-82ab-590b5a1e902c@chenxiaosong.com>
Date: Fri, 14 Aug 2026 14:27:03 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] smb/server: check create_proc_shares() failure
To: Namjae Jeon <linkinjeon@kernel.org>, Ze Tan <tanze@kylinos.cn>
Cc: sfrench@samba.org, senozhatsky@chromium.org, constant.lee@samsung.com,
 tom@talpey.comm, chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
References: <cover.1786674373.git.tanze@kylinos.cn>
 <82181632662a23ecc9a3b8b2321982071037a288.1786674373.git.tanze@kylinos.cn>
 <CAKYAXd9-mkdArzM573FPUo0cS8ZuuY21OgMMQ5d9kLOknzy26w@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9-mkdArzM573FPUo0cS8ZuuY21OgMMQ5d9kLOknzy26w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

These two procfs monitoring entries are indeed optional, if their 
creation fails, we should at least print an error message with `pr_err()`.

However, initialization does not happen frequently, would it be better 
to make sure all features are available when initialization completes?

On 8/14/26 13:44, Namjae Jeon wrote:
> Do you think we should abort ksmbd
> initialization when create_proc_sessions() or create_proc_shares()
> fail ?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

