Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B068330214B
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780754359; cv=none; b=i1XELn+JW8JcZOPWvbFswAwrzOJCp68j7CcWE/GjIIUGHphB7q390dqkpyFG0YOgOQX5IMUc7XHwmy46TSRfscJpsNQx9PVxTSTqgrUxTlQbWX327hrrgqv9Ep5qa93F4TgM8OvsiRexQQt7t5x2jkogqsg0EkNGJ0cF7H/kHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780754359; c=relaxed/simple;
	bh=otJ/B8SUR8vr+1YcDjebADl1cxeiQSZZaaxF0ytOtVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFLUQU8HK+F2ThCQf+t6iwbbRhTU9q6mqNRmaoPYmr2x6KsRwNo/N1PvxqlV3/4ofUvt/RGexZhKnn/jNflfWMcMeaydsZ+MOhx82R0NMOXOxoclfwhdqRn/RnrxKeQQceafE5tJ7vJNKAHUc6CGiI441BoEw9EyBV2c0pQMWaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=o4wZmaEZ; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="o4wZmaEZ"
Message-ID: <8135aa2d-d576-4cb1-98cf-d76bd2bdd20a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780754354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxaEVu+rsTzqFIo+GKF8pxFNTswc70kZdT1W3L+mKWs=;
	b=o4wZmaEZa4agmI3b574o8XGCbsyEftNvwQ3BPAWboZPqtiyHC1dp8JSGMFtsXEWvUsTfGQ
	EHCsv/dO0mBeRlg+Q3Ch5EcFQ0+zZ3JVUKSB5weuGUDa/SPfaFLMWO/7tvDZi9b/GzW+AV
	cI6kIqG4VYWyqUE+l4ICU2JXChDTvIjwW14e3ay5kSyXgBZp5YeBvH7cCMK9wlx7m41XBk
	dU2rdFA4gqOvg+0WjZbnb03uONzoDmkfX8LWjJZj5rdAAvDoJPsKtnK04xJMuwKZlFEcHS
	eIxUNkweuKRhW0kIUWOSIpES7awyUN7Td314/Ky1DgMKbL2TkmTfwYDKH31DjQ==
Date: Sat, 6 Jun 2026 21:58:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl
 handler
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It is defined in MS-FSCC 2.3.67: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/77f650a3-e3a2-4a25-baac-4bf9b36bcc46

There's one thing I'm not sure about, vfs_fileattr_get() seems to only 
tell us whether the file is compressed or not, but it doesn't provide 
the detailed CompressionState. Namjae, do you have a better idea for how 
to get detailed CompressionState?


在 2026/6/6 21:50, Namjae Jeon 写道:
>> +       if (fa.flags & FS_COMPR_FL)
>> +               *fmt = COMPRESSION_FORMAT_DEFAULT;
> Again.. The definition of COMPRESSION_FORMAT_DEFAULT doesn't seem to
> exist in the spec. How do other smb clients behave when they receive
> this response?

