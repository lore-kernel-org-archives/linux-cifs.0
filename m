Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7847C2BE621
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 06:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787294872; cv=none; b=GVKoKqLT7L/9frDgrmvLEAZIK4ZLTwXLSldsCkx24besB/FsQTP0MfrZiGKHffbEkDXl85FEEokAoMTf0xFlTHbcYl5Qm5KsEJwALkQWEBy196/DtNNymLbHlKadALhVOkAPEePlqWvSHiYm8AprXiuBxPh4Ob1bSyXeOzqTJXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787294872; c=relaxed/simple;
	bh=QZdN5++Hycxonz7yY49LlDRxMhgmpCk1TZitVCYEcRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AvOTmTvMGx+U/5Y98+Myq5WdebznU+cuhol1PCQmbzms+LeeMRKrNQV3WL7xfFKxjJ/l7yW5idkVJEMkPCEeZFzcHiX/80j8xh39TiPxIh2Ho9WFIiuEdGZYgpJHOyUoHL1OAIP6u10mFUAcR1DkLo/ZWlob7p3GJIGECErlnzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=A/VxL7sZ; arc=none smtp.client-ip=91.218.175.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="A/VxL7sZ"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QZdN5++Hycxonz7yY49LlDRxMhgmpCk1TZitVCYEcRc=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787294864; v=1; x=1787899664;
 b=A/VxL7sZo+hDvAXdw7KZwk+HvDKcu3vOBPOQ9QJwmtV9E4MRba8cVBA2hiLorAGgM3Xw68NE
 Kj/3i2zZYES8fcknunYm3vMn2oCKEfbBGQfn9IQbrqOhdcZPhQV+1hz2UvW1v/WjPhBcpr+CknK
 C0yNEP2QAbFaYy0KyV5euAcZHtLMgQYUOezvwXnjFvRgDCxY2yuw2TLO4wOf1sbH8jYQEBa7Hdd
 PE2+jpD+HZuaUV62Hf2DiSqa5bFmWKPy5KChAjJ3RIZI4BEjYh2l/v17CW41Y1X9yt+7jJY3ZLh
 xnhUcPKMylWeLqSRaAeMIDMbk7EvZdJYE+FiNrUZSZk2w==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.3.216] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 7108a605b655a81e;
	Fri, 21 Aug 2026 06:47:34 +0000
X-Mizu-Trace-ID: 7108a605b655a81e
X-Migadu-Flow: FLOW_OUT
Message-ID: <9aeb9ccf-dcd0-48a7-bc24-4b6948943f62@chenxiaosong.com>
Date: Fri, 21 Aug 2026 14:47:25 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Namjae,

Before this patchset, the two test cases also failed. I would like to 
know your test results before this patchset. I am not sure whether there 
is something wrong with my krb5 environment. But I tested the 
`smb2.session.expire1s` and `smb2.session.expire1e` test cases, and they 
passed.

failure: expire2s [
../../source4/torture/smb2/session.c:1611: status was 
NT_STATUS_IO_TIMEOUT, expected NT_STATUS_NETWORK_SESSION_EXPIRED: 
smb2_find returned unexpected ss
]

failure: expire2e [
../../source4/torture/smb2/session.c:1611: status was 
NT_STATUS_IO_TIMEOUT, expected NT_STATUS_NETWORK_SESSION_EXPIRED: 
smb2_find returned unexpected ss
]

On 8/11/2026 8:50 PM, Namjae Jeon wrote:
> Can you check two smbtorture failures from this patch-set ?
> 
> $ ./bin/smbtorture //ksmbd.test/cifsd-test3/
> -Ulinkinjeon@KSMBD.TEST%1234 --use-kerberos=required
> smb2.session.expire2s
> ...
> failure: expire2s [
> ../../source4/torture/smb2/session.c:1482: status was
> NT_STATUS_ACCESS_DENIED, expected NT_STATUS_NETWORK_SESSION_EXPIRED:
> smb2_notify returned unexpected status
> ]
> 
> $ ./bin/smbtorture //ksmbd.test/cifsd-test3/
> -Ulinkinjeon@KSMBD.TEST%1234 --use-kerberos=required
> smb2.session.expire2e
> ...
> failure: expire2e [
> ../../source4/torture/smb2/session.c:1482: status was
> NT_STATUS_ACCESS_DENIED, expected NT_STATUS_NETWORK_SESSION_EXPIRED:
> smb2_notify returned unexpected status
> ]

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

