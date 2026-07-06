Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4E436EA82
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783345026; cv=none; b=CKr43Y4XCffa3kXnj35ncWy453iGqV036FmXcAF8lDYhcTJa2QZ8BfLOR1/6dTubziS+rFYht+zYwHjZaCAOLa3W8Np1QvKc68qmBPTOC1UGZuwAq1fhLsnla6yVjUtfIsXABjyrRlQQHm7s2XnakHYwI2N0nPxCLta4YBnMwRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783345026; c=relaxed/simple;
	bh=L9XTNFNPZhzjwnOK+rBX2MCsliZan5dT/RhJeiWG25A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=S0Hu00oOH34/O3Cm35ykQiL/3gyY18dF+ZfuxnQRcusORG9gAMdQ4kNKiNU5gjyz7RdfRc8PkXxPfayQIHWIRynn28Q2jCrpEQrTCH9adCDofxSUpgMlAh7kkp116T9/0JJZYVfqr15Ovt0Z0dRU8o2GW+4OqnvQVM9tiRr+m/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=AkIpSY4j; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="AkIpSY4j"
Message-ID: <b2396e96-5923-4617-b1ff-d7dc0fd9975a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783345020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WOiTNRG9w/U+4nhkqJURqNxRd96Aqxpk8uKDr+6zg90=;
	b=AkIpSY4jCDcVaEHPwMAEkBF1ul2f74Z3y5OBJ4F45OeFuu3ovWPmOIsPDr5GI6Ffxb16Og
	4ohy3ak1ywOaz/zsPHHNBc5tNWCG2V61Z2JVllb2kyVFuMnUQvlpbSv8vo5CqUy7sZrXaV
	diEBJ3ly8dugyGR7ky5XF7GatPMqJKuFmnw/zcsozz9E+Hnx7ociXAwLsJqsFu4ZDwPe4U
	WNu/D/ROJagiO9VJ172gyArjlbWvQ5nSDwLQoyCaSKJ1EX8Tl51Z7+ms0pFeWsDXXExh9c
	sitMQSF6UqAJBqdehhKX4E9kNdhHR4Chn0GH8TG/vKGptEt8e0bpeW8YFsbUUw==
Date: Mon, 6 Jul 2026 21:36:45 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] smb/server: preserve compound prefix for async
 interim responses
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: Namjae Jeon <linkinjeon@kernel.org>, metze@samba.org
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org
References: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
 <20260702110522.911411-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8F_2ZTFc5eUmo2xS_irPnsmFmEq9OKhGSSY-Ra=b882w@mail.gmail.com>
 <b6525ea0-43e3-4175-b47c-4914c9785c95@chenxiaosong.com>
In-Reply-To: <b6525ea0-43e3-4175-b47c-4914c9785c95@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Samba tests passed after adding the following config options to smb.conf:

vfs objects = delay_inject streams_xattr
delay_inject:pread_send = 2000
delay_inject:pwrite_send = 2000

在 2026/7/6 20:07, ChenXiaoSong 写道:
> These three test cases also fail when using Samba as the server.
> I will also debug why Samba fails.
> 
> smbd --version
> Version 4.25.0pre1-GIT-bffb51f09ab
> 
> test: compound-padding
> failure: compound-padding [
> ../../source4/torture/smb2/compound.c:1175: Incorrect status 
> NT_STATUS_OBJECT_NAME_INVALID - should be NT_STATUS_OK
> ]
> 
> test: write_write
> failure: write_write [
> (../../source4/torture/smb2/compound.c:2549) Incorrect value req[1]- 
>  >cancel.can_cancel=0 - should be 1
> ]
> 
> test: read_read
> failure: read_read [
> (../../source4/torture/smb2/compound.c:2653) Incorrect value req[1]- 
>  >cancel.can_cancel=0 - should be 1
> ]
> 
> On 7/4/26 16:52, Namjae Jeon wrote:
>> smb2.compound.compound-padding
>> smb2.compound_async.write_write
>> smb2.compound_async.read_read

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

