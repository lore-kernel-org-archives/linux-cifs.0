Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5778F4A
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 06:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729234; cv=none; b=j9OCu4EhYZLOfDTErNEftOWFTcBDMuxQfQ3nSzTkYKHPnGOfxjbB2fOCII0lCGBdWl99gopSnKG61Fhr0Lw8tyseWuOGc9BXgGDD/TJOm+ipx75JTv4ZHikIMR5jTdTUR6sy+4zO6odU8xrVInkB1dc0UicotAeLV9doA4BqM2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729234; c=relaxed/simple;
	bh=DrdarfVGbQxXBQPdqeKiK//5hw237bElJAzqzmM2czM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tcq525Ly0HqCKTSMoBvMDAHHxkJ5Khwolqp7vH5XnoC5pDRXE7X5zDBBPRLlbQrwOO/dcI+PXOnkFYKfJR3kjEH9KNNUge1+kFPJ+2J/gvBpDJl8ipD/UQl28bXoobWvXY//tdRE7hLUYkPP3b7UWMJYWJbOuomBFUeWWL8glsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=XrnY/N/+; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="XrnY/N/+"
Message-ID: <6b98c261-b17b-45a8-ab09-efdb0d658f4e@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1773729228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5J4BPcjXWE79P5QWR0kb3daUGe7Wy+vHtLm9w9OY5ro=;
	b=XrnY/N/+WhYkkSbDwW+PeMjmIR99IJXIqqSzvTPqaTanFz0zRDpqHa1KGKKkro25LyQBPa
	L2UBTzjBqerdJFCpI1BT2QEMdaN4nRWX8lwdEtqHwFY0qESMAlh1f3b3PcKsycsvypbwuf
	NyJl2GbbfNF+e54T4hArP02pwyyAuRdWlL18dBmkPivRjHV7wwRBLNGA1gVUbGZ1QX3ajj
	GXTh1CP5hGYo9i/jKPDlIyiiEo86Pvo4Nh8KgL7vVs0R/4wGSxMrEOHKQB6eYW6fNt03qH
	hEsMSuiXtDj4xlG8R2+8z6UvCfnXU3uh3sVO6+NIItiqvhCeY3h/jOfBtF30RA==
Date: Tue, 17 Mar 2026 14:32:57 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
To: Werner Kasselman <werner@verivus.ai>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc: "linkinjeon@kernel.org" <linkinjeon@kernel.org>,
 "smfrench@gmail.com" <smfrench@gmail.com>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260317021757.962692-1-werner@verivus.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260317021757.962692-1-werner@verivus.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Werner,

Thanks for your patch. It seems the changes below are not included. Do 
you have any follow-up patches that haven't been submitted yet?

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

在 2026/3/17 10:18, Werner Kasselman 写道:
> - Preallocate lease_table via alloc_lease_table() before opinfo_add()
>    so add_lease_global_list() becomes infallible after publication.
> - Keep the original m_op_list publication order (opinfo_add before
>    lease list) so concurrent opens via same_client_has_lease() and
>    opinfo_get_list() still see the in-flight grant.
> - Use opinfo_put() instead of __free_opinfo() on err_out so that
>    the RCU-deferred free path is used.
> 
> This also requires splitting add_lease_global_list() to take a
> preallocated lease_table and changing its return type from int to void,
> since it can no longer fail.

