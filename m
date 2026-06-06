Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDD22236E3
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780758891; cv=none; b=AOnyrKVAowGzVeP47Lu21LCFNNoFYQhsNQm/mMFRuW2VwqO7bCp1SRBMoV9WSJqeKp5Ir+43LvPSzVd7YVbEXOJS8y3ZquF+lw8IzbhCEEb9Q4x382fMZubbrLcY+5c+in++4qiqzLxmDZRF0QozEkTsxI0JAxl65UH/uDsBcX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780758891; c=relaxed/simple;
	bh=k91A7xPTB1f9ovgfzvgXo4/xwSIa+A5Rdi4wB81MMjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6WfHwSrgsBi8Hq69+RGq668mRbgFJPgWeGxqYJyuSdSis5M3X+km+Genav9zCvQPRJ8I9WbwGOwbU6HfK9s2aIAHBAhDIvyrIWAG8cQU5ck5fgjPH6otWBRY+8zynz/h0EG0w2fDOg71DPEPWX5NVd69LtcG491BucbHgweDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Zxryhiee; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Zxryhiee"
Message-ID: <7b58996f-270f-486c-bba2-0e3971c11b91@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780758885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7F9/Q8aknLDC/Zz16tI/YD3k+DJACosWjxhhI0ClqMA=;
	b=ZxryhieeMld8fcf9eEqFQCPc0Lfk0tD4ITMtc7Si05bXlIUcTeo8k80oz+F2GH6+fmmH5m
	punLn0UKL5Qh2TPYeJas09lzYvT4v29kquCzJTBP0RG3NFDzCX+HDdPPWDFPBLtFm++R4x
	A6qyUzFoweaO8HQ8znIZP4iu/cFFw+eSPdbuYLiORmPlNpws5Xh1HLxEdN6i+2vJ/5WsSh
	mhtFX+uISicof4Ky9Ax2i8gVO1XrIfzspmsmh+mR3ZlRQA3OqZ5bRwHNbz3B8J3nDdTTqF
	bV9pcwXOUZCEmw9t3ji5hd265zqYRR+U//QBlEwWODHQODJBjBgulBioB6JNqQ==
Date: Sat, 6 Jun 2026 23:14:33 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl
 handler
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
 ronnie sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath S M <bharathsm@microsoft.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 David Howells <dhowells@redhat.com>,
 "Stefan (metze) Metzmacher" <metze@samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
 <CAH2r5mtmggcLnkBrFOX-ob4KC=v8LmfOGfmzH0X-WR5nxNTceQ@mail.gmail.com>
 <CAKYAXd8V9XYaRLFviyBTxLQuWAsvDuab1nmuX_i4v4nY8j6iHQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8V9XYaRLFviyBTxLQuWAsvDuab1nmuX_i4v4nY8j6iHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It's more likely a specification error (an omission).

在 2026/6/6 22:35, Namjae Jeon 写道:
> See:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms- 
> fscc/62de177d-ed90-4884-ae04-9de52f1180f1
> 
> It is defined in the FSCTL_SET_COMPRESSION request but not in the
> FSCTL_GET_COMPRESSION response. This patch is for
> FSCTL_GET_COMPRESSION. I'm not sure if it's a specification error or
> if it's intentional.

