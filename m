Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7AB37A48A
	for <linux-cifs@vger.kernel.org>; Sun, 26 Jul 2026 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785104893; cv=none; b=Sd/IOboTGufls0cbapnMvX2KT3TB8kZKtdCzgz+SQIGdbD8YW/21fA+qC/iemZQd+lVXV+KmLm6sbE9T2NSeHPHqikFENe4m5PqyXDIhix6oM2mrPjAmlijk2bffcoFqM71WDd6U4qFKBGbyvCZNvVtAQsGBLdoLQQ7FWkqUySM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785104893; c=relaxed/simple;
	bh=a0KSbmd3qDhQXVMCCGxS3ColaptR5/CWKz7dw4zAfww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kNV3SbJVY8Y8ih74mHIjPsYOxYnE5oGihR4D3K//V7Du2VFgt7T9wVQZpiOXWBtTLESi6FxFbZWZKHC6qOq1rspLJX54G5297dg+Mg8TTqPY6F4cOh8vOt3C6ht++PI1aRpmYDKgt4hVhNOTg8wfCPSWLurRg9mdklaVABNpf+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NimDF8pi; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NimDF8pi"
Message-ID: <d5baae81-b845-445b-8be3-2d927116a941@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785104886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2hKojXNoABOIb7YmsyuBA0fuzgcHftrOmK7/tvqhB+g=;
	b=NimDF8piVlkatC9gw25rQbf97zq4QnHrFrtbXZNXkgawNrVxTUx5g/OwwaLEmYMLgH2wtv
	8ZPYUnxa1Jze/f6gGxCxl9KnE9raNfiwbaqJEvx/sOJ0+Klz8VUCeO7WruVKdqFxDnRoYA
	vFBVC9NPUFrngnSfNU9uV92w4FTXTentepoLIWL2/jz6d1vbs7e+JO/Hv9U0d+8uVYgBgD
	LhOWxtsFUmmtX3uQR5/jdz3CC1Uw6yWykMy3g9vsupsguVwJblnlHfQAw+v+8e9D5FJjPQ
	tIL6tEnEstA18NsTu5twbSizCjZ1iTvXHNHjKyejK+VUb2vh3oY6KG+SB7GxMQ==
Date: Mon, 27 Jul 2026 06:27:58 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] ksmbd: refactor smb2_notify() to a blocking wait,
 matching smb2_lock()
To: =?UTF-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>
References: <20260725102737.33616-1-g.blivet@me.com>
 <6813f121-5fe0-4542-85fa-7f06e093c24a@chenxiaosong.com>
 <627eb275-ca13-468c-87fa-f40c4e887145@chenxiaosong.com>
 <C65108ED-0865-418A-B2DE-F8079369A142@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <C65108ED-0865-418A-B2DE-F8079369A142@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I will update it.

在 2026/7/27 0:05, Gaël Blivet 写道:
> Good catch. I also confirmed after testing that it is not needed. The initial analysis was based on packet capture and I mistook it as a macOS requirement. My apologies for the noise. Could you remove it in your new version of the patch, or do you want me to update it?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

