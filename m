Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C34A26461F
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 23:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789516350; cv=none; b=kKMBVrEGX3Jpe757ZKzzE+RtQVmQbT8TWGwqnn0MOxck5IM3vSsUX1/N3Fzv9WA+ldYx8yyR+vmiGXEDLtsWY+htpHStmNQTfxiB4RJzoqGMu6Yka6d0sq044mw5VXPu1fbB+ryxVkXMhjos923IMfx9JMW0LPd2fn1rSmGyp6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789516350; c=relaxed/simple;
	bh=M4j8QpN863Kjl5w51J5NNynUyW/9GQFogFPqQiWxDWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N99B1Oo457nkAfd25l7Gy8HdaOABlkOGCXyNS78xLeXDJ6Tseld1EhXs6m6bQ0Kj7L5hXpqO5wHNC8bil3PedMcvDPIocJK0OEKEkoeRSu5QqtGqVRQ7HTGU79KOm5bim+8CQvbMBDLlpVaQIlvsLK5FQZI2EifLvKHIqbnGACI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=RVOjByeQ; arc=none smtp.client-ip=91.218.175.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="RVOjByeQ"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=M4j8QpN863Kjl5w51J5NNynUyW/9GQFogFPqQiWxDWo=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789516344; v=1; x=1790121144;
 b=RVOjByeQJbCiGoW1sNCRs37Beqmo7W2ehDvWVVhOIJVWbLMvTcoTweUoJb0u/eGt7smaLhlY
 r0Ld1UtnkSjWpmwuqksfYqsZxzlE137186tyhRE03E38BA05KkxlIZdra0VWQwD7xEfCDMFyP1d
 PA1VVKyoZnlj21RkJD63ESczXkeFQD7exD3W9xEEF5C23uVYfKg0x3l+SBPnr9E33TTLN1FMr8D
 gjWRgqtsAjEgsOJX/qdUK/uyydCcWqF4TBWWpQTmPnd8ZwSVCqspCqDSaRj2nf9WyGLl1atYrpJ
 ErD/Nv/ERfmYj+AdsKUUUdznjfXTNIBVCahk0E0kL0pcQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ba34751c86c1f7df;
	Tue, 15 Sep 2026 23:52:13 +0000
X-Mizu-Trace-ID: ba34751c86c1f7df
X-Migadu-Flow: FLOW_OUT
Message-ID: <cb96d64b-d50a-47be-adb5-014b9102ff58@chenxiaosong.com>
Date: Wed, 16 Sep 2026 07:52:17 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] smb/server: align partial normalized name responses
 to UTF-16
To: Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>,
 samba-technical@lists.samba.org
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
 <20260915064657.110687-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-t_Guuqiis4i1bC=CBACk8dp463vBH929KF_8ijyvsfg@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-t_Guuqiis4i1bC=CBACk8dp463vBH929KF_8ijyvsfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I had the same question. However, the protocol does not specify any 
alignment requirement for `ALTERNATE_NAME`, see MS-FSA 2.1.5.12.4: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/5051d021-8d06-4b7e-94e3-55b118193427

Maybe this was missed in the protocol, or is it because an 8.3 filename 
is at most 12 bytes? See MS-FSCC 2.1.5.2.1: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/18e63b13-ba43-4f5f-a5b7-11e871b71f14

Hopefully Ralph or someone else can explain this.

Some people may not have received the patch. Here is the patch link: 
https://lore.kernel.org/linux-cifs/20260915064657.110687-3-chenxiaosong@chenxiaosong.com/

On 9/16/2026 7:14 AM, Namjae Jeon wrote:
> Shouldn’t we apply the same alignment to
> FILE_ALTERNATE_NAME_INFORMATION as well?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

