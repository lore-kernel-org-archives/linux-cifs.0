Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D8F42AF8F
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785834381; cv=none; b=alMZ650MgvsyAQCcZGuvEW6mcRI7wGz/cwjjj5yAx9pchUIWtHCozjKNY0F8Sjw3q3ztOG76NGACn57YF7iSA7q0TVqKlvbqESaP3y3KQ8E0Xi2t7VXoARlYpuOsEppAzoHvl/jp85BmqmWckOSnjQ5CTkDGyQTN1k+eYCge+Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785834381; c=relaxed/simple;
	bh=ehjRfHr4Ad71yaDMxrvbkEJvrU2rtavMXlAzqotdoBc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=MJQoT2no/TjF3Zdx611xFmIJT/N5Z7MdsMu432WCO28gdl6pLku5uh4NtVoYT6G/VfuqGHtJev4FqTfs+8y1zAr9tN6lPRuu9Z4uVIT15yB+8IsXNSFshw+x9zn29R6PuU+238K2g6A66VwrZjOVlg7VHj0CMTSL+3VfCd3pymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NHI2iPyR; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NHI2iPyR"
Message-ID: <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785834374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8vjD9Vzo1HETX/Pgis5TIroUwMYOh3nUJvRriW+nPaE=;
	b=NHI2iPyRD29nkmNDsycUoAc0IhF9Qn+NHTDmpecFHp3n/mPyvO7M++XTIKiZamVY31u7hz
	d9Mpd2CQ7sc3V9jhbz1DKywSgXIX/abmtb9JwpiF3sRfztSRbtFG9WHki9ntMJ5NB3VXpS
	GdUkzC4WwgQRkACH09utpPl2m2M1ii1A7QK2NmHKWkl1+SPgE5VANIXWJpwUucNLUeA44c
	fge04lQ1VDuTl8EZQVOZwUQlci2iSjtyM0Lz/QQqhLhvcAS0iwYydlfSaFoD6R4EEwBM2R
	tGBij1R77yeyTq3HuG4MLRmq5naLfK51soLVO55U0nftxsedLwpOOFA+0BPzbQ==
Date: Tue, 4 Aug 2026 17:05:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
 <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
Content-Language: en-US
In-Reply-To: <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Ralph,

Thanks for your sharing.

This seems to be the rule for determining whether there are any open 
child files or subdirectories under the old directory of rename operation.

For checking whether the new file of rename operation is open, there 
does not seem to be a POSIX-specific rule.

Please let me know if my understanding is incorrect.

On 8/4/26 16:44, Ralph Boehme wrote:
> 
> - allow rename if there are only other POSIX opens
> - fail the rename if there's one or more non-POSIX opens
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

