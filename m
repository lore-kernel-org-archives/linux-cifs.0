Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C03B346A06
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772165604; cv=none; b=XmaG/4pJ6Tr9Kapf8sOSkuEBDp7JO5eNzHH2chYnJ7CgP+OcNEigX2pKL8+s9JfDFm34NtSVhKpm72o+PCgJQ/BCAS926AistcRt6FfoxQrbq8zA0sewzqQhFx/cQPl+gmGK00netrVbwtK6L13CCZqSmLzEt5xF58ZGT+nOFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772165604; c=relaxed/simple;
	bh=qZgAKZ71FptSTrPhLg3idNbD6udVe5OvGVFiq8nnwpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NYk+rueJkFsEh6yOVe7KlJ7KP4hQcJZdEZ5pdnUICCD4mW1rEJ0+EgxEsyW5UNvje1pOrjn2vSQARWJ7g0nw/Veb+vPjjW1sVsPVr7ji9e6EdwNCJOACcUXEskYkr/XbhoKkLT3u32o32D/GbGYXeBw6wZMqIWeP4F9XEHltL3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=v5vp2kOR; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="v5vp2kOR"
Message-ID: <90fdfba1-e0be-4656-87fc-1921d233da37@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1772165600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6ulSfKjuLuE3Cra3Fb4w/6aiZ0mC10Js7TDP7CKbNQ=;
	b=v5vp2kOR8PyyVViUW01AWVQPaWA3+JhM2YPxy5lVsben/itsGdO3B2cteBk6ZljifsaCzZ
	V1Tmws1hmM41PKF4NlC4uFHSipJigpddxwPRs7IYbwg1jrZo8eZAYF1Rjr8oak9pz2Axm9
	7pE2IfoI/zgPjHka495And6sv4TEEvETrxgVHODYmttCzQ+4fJ3MBp8S3yVeMjcshhdBtX
	NEym7NL0vOVI1i5AbItG+oQXCC7gv9tm2lRpicI1gmHZRJid1BmAHylaYVIgOkl5AtxKEC
	lAuA5qc3xsxa8gQRMTNTyALw9pRd56E+9Tmrf7tRCdMPztb/PyqCM3hlIXVMuA==
Date: Fri, 27 Feb 2026 12:12:21 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: linkinjeon@kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>, smfrench@gmail.com, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
 <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
 <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
 <59d5c1a6-7a7f-464a-aa62-e53daff8870d@roeck-us.net>
 <f3604a74-3caa-4737-bfc0-d93feb988176@chenxiaosong.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <f3604a74-3caa-4737-bfc0-d93feb988176@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

By the way, smb2_open() is over 900 lines long, and we have already 
encountered several memory leaks in it, and there may be more. Perhaps 
we should consider refactoring it to make it easier to maintain.

What do you think?

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

On 2026/2/27 12:07, ChenXiaoSong wrote:
> Hi Guenter,
> 
> Sorry for the late reply. I had some family matters to take care of 
> yesterday.
> 
> Please see the following process:
> 
> ```
> smb2_open
>    smb2_check_durable_oplock
>      opinfo_get(fp) // inc refcount
>    ksmbd_reopen_durable_fd
>      __open_id(&work->sess->file_table, fp,
>        idr_alloc_cyclic(ft->idr, fp, ...)
>        __open_id_set(fp, id, type); // insert into file table
>    ksmbd_override_fsids // fail
>    ksmbd_put_durable_fd
>      __ksmbd_close_fd
>        __ksmbd_remove_fd  // remove dh_info.fp from file table
>    // dh_info.fp has already been removed from the file table
>    ksmbd_fd_put(..., fp) // fp == NULL
> ```
