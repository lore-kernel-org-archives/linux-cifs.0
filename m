Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178CB23BCF7
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832148; cv=none; b=X/sNHE3UIc7BsgyMbqeyPOxDr/DCysx32xboZetQA/tif4YdaotUI60B2PXbkWZAJwn5OXyGHdyY/wOfXKgF5atiN08KeBm+KZlqCejfB72dEZ/QN+bTWC+aNxZnvaZOunPuXx8EmgBRLk7zoIUUD19TrcodqoP7n/EjqhHB4tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832148; c=relaxed/simple;
	bh=t7/HFQRo/rxSXX2kmxxevtpYNRGhW1igYxElZt7Ggb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lA1qZmA+XO7F7EBRGVS72UCpM5/K49t2R3MrppJ7vXYuDH0FedN9HFmTNiX7YR8+iITcCRZ3fw0sw7mOisX6iSNezVXcuD6MYBjn5JVD9TF7ohMq/zODk48fX91mXVoN3gGpUv2JJ0hGL9l+dI4QJZrHRJB1Pmhev4N1sawedWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=bOhzoPhl; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="bOhzoPhl"
Message-ID: <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785832141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fe7bt0bHs4ONoyyIV9C7b59G3cfbsQtifUSgf8jX604=;
	b=bOhzoPhlGx2/L57wS1b3IPFCxtzNMOUWDz/YkrKvQJhP/qUY6AUZ2jue7v1e3riQDpJBbo
	FL7mnjhqXnX4tp6WMbiSwXXMy83enwX6LRoPNQqNe7b51TkYcS/b3Qa4OVzv6y7IAzBN96
	38HlpV6Gb1kJqnYr4Q+8hJFuUT1O/kXdeH7tuI4VLllCFK3hYAtbDSfq4CdxkfueGIz9Vl
	cShvAKcppA+wr9CRVjcKvWbjzlmvaEylTaguus0HQdLhY0eK5sR6SGiDXqpXNrZIDMnzaE
	yCtR0HYpf4BZ8LldzZirfgG774QlTy8nx4Vod4Qm7QkX4gPuLSGb6zfMZbikIQ==
Date: Tue, 4 Aug 2026 16:28:02 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

According to MS-FSA 2.1.5.15.12, level 10 (FileRenameInformation), an 
overwrite rename must fail with STATUS_ACCESS_DENIED if the existing 
target still has an open.

MS-FSA 2.1.5.15.12 FileRenameInformation: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/87f86c9b-6c2a-4803-84b7-131a74a434fa 


On 8/4/26 15:53, Namjae Jeon wrote:
> Okay. We can implement this in ksmbd and cifs.ko to pass generic/035 test.
> 
> Thanks for sharing it.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

