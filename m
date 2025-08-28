Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B45266581
	for <linux-cifs@vger.kernel.org>; Thu, 28 Aug 2025 10:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378159; cv=none; b=AnhdXphtx0cFhyvSZexerytJyxHWqDSNHfhjuBUOpz1if6cqUe12BljEjN+ZLRfULEjaTg6Y6wHlnexazg/cjTv1ntI7/qE1P7f443Fk4ADI0nFvfivVzGExa8m7n1LSvu+X3QXy+xSzj/7po/4mSn6siv7q466mVhWFW7KSDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378159; c=relaxed/simple;
	bh=n8+eU0VrPhhIi6FgJbsrIQDdy2YerxEjVsET8cvJHhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3Uoj3K3ukbdgCgF96DV2/z+RpXFfmoqJeE29jOSTVvcj12Y3wVTHDS9oTgtkoCW77HfvTsKNJ0hrPokgEnwBJZJ/41+x2aJPDPRZGDIFAVjgrEVq/liATzE/SmqsyUSQtrdNT/eBb03yVAe02q5VIg4K/hiW3dSD/R+6cYeEQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NU02UUC5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NU02UUC5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=4u4tRB9Jft3hCsCmQIN/yW4yT45w6uGXsbqKC1vuEDI=; b=NU02UUC5VJTsaDEph/yTEiqwpc
	d+7jcsOjj+HLMyUQ19jm1WfwIvFZnVnI5HTv6o6F5/nbjGxs8Ew5FWQ+rSpl4287Ukw5nIR+66N2e
	S3sAnjZUIS76mDoGqvXMrvcRvPCMCF5N2g414anrLZlwWk1SgK4zhNy9jTr4B+27ZFamVaReRf2K5
	l/0I6Cg4mvJsY4LxdBEYOsKM3WNRAI8twIcyVB9Xa088Ae+My4NLp8uiyji1DFIx9pg3x1EeMiupj
	lzChG/BMrkQbYyhfD4JMYEwfjnULYCqHBQjPzzr6/xrp2G74bzbA/5gGGxFMbM2UAwNAwxMWJP5/N
	epGZDhgKLpUT8gcyNrW5v5usHRjcKSMklMTIx9E2BhGa8es2Dg3hS6J6TW7vsqDuZZONMdHbl1Ed0
	cvwnH61AjV2FBJ7HgIyuB3TDigdStYw3Nx+gK6oHj1guF04/4ciCetkjVRMTwGiHmH227/wqbSl3J
	O7bCkhqwCgLnR/NO4LRlR6Tx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uraBv-001FM4-0R;
	Thu, 28 Aug 2025 10:49:15 +0000
Message-ID: <2375a643-9163-49b0-b9ae-65378cbd1b78@samba.org>
Date: Thu, 28 Aug 2025 12:49:14 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: smbdirect patches for 6.18
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <CAH2r5muHpZOTU+CHrmG1OnpvXNmfia8CxAs8v_uEPOZrHFr-1w@mail.gmail.com>
 <1f5a4297-8086-4914-af44-1cf76393c8c7@samba.org>
 <CAFTVevUWWrPgs=Kb6E3WtSiyTmWtoD8QYiONJ1hYkS37ri=NrA@mail.gmail.com>
 <CAFTVevVn8sZr6uyBpA9uF80reRNty2izFCLWU_t-6gyAx-K3gQ@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAFTVevVn8sZr6uyBpA9uF80reRNty2izFCLWU_t-6gyAx-K3gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Meetakshi,

> A concerning log I saw on the ksmbd server side:
> 
> [ 5437.417703] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for
>> 10000us 4 times, consider switching to WQ_UNBOUND
> ....
> [ 5446.096614] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for
>> 10000us 7 times, consider switching to WQ_UNBOUND
> 
> I am not sure if I will have the time to help debug these issues.

I see these for various workqueues. Running against ksmbd
over tcp I'm getting these:

[Do Aug 28 12:44:03 2025] workqueue: delayed_fput hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:44:05 2025] workqueue: delayed_fput hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:44:07 2025] workqueue: delayed_fput hogged CPU for >10000us 7 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:44:12 2025] workqueue: delayed_fput hogged CPU for >10000us 11 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:44:18 2025] workqueue: delayed_fput hogged CPU for >10000us 19 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:44:35 2025] workqueue: delayed_fput hogged CPU for >10000us 35 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:28 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:28 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:29 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 7 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:29 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 11 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:30 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 19 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:33 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 35 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:36 2025] workqueue: delayed_fput hogged CPU for >10000us 67 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:37 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 67 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:41 2025] workqueue: delayed_fput hogged CPU for >10000us 131 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:49 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 131 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:45:49 2025] workqueue: delayed_fput hogged CPU for >10000us 259 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:46:03 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 259 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:46:05 2025] workqueue: delayed_fput hogged CPU for >10000us 515 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:46:24 2025] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for >10000us 515 times, consider switching to WQ_UNBOUND
[Do Aug 28 12:46:53 2025] workqueue: delayed_fput hogged CPU for >10000us 1027 times, consider switching to WQ_UNBOUND

I also saw ib_core (when using rdma) and others.

So I don't think it's critical.

metze
