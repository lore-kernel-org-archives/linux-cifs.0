Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E32D3D75BC
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 10:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779272145; cv=none; b=bj4H7oZlV0EFzoVsQqF5+w0uee9nZq65xLUiQHBufSbOg0ygbS9ya1Jzrn2he7oqsNklqrF6uK7OKpqpwuA+50yZo2kEc1qVqPZTC69jfnplCUrIMdBLqg/rKLfFcNhKl7zxGiUu0z6IP307C2uPbkadj5zPzW2wiItwKxNfzE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779272145; c=relaxed/simple;
	bh=O3l666MUC6Pyp4eW0VYmAj+Bn4HTGDeodXKqc/WGeCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrzrG9AHbY8xHrg2lWsqySMaA3PrW8cnhSHCC/gE8iIEPhBQPH+O77Ob7aQXlbMX6bSAby4tveGLVi3NJXJEBZJ0i1UXJ4Ke6k6lglh6tRbr/eSREXQEm2yxngax/cmKPyuZkv+3XARWcLbXYUX+/1oCifZuMyQO0dG+xMhNBD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=n8SMUX6Z; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="n8SMUX6Z"
Message-ID: <6e1c1b2e-d4e7-4452-a518-81c06a0314df@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779272138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yweyZ03Yma/zpudAf6bULy3Z+sih8uviERJMSup73Dk=;
	b=n8SMUX6Z4ev6OmLtc7YgMf4zTh/it+Io6rzCb+2WcnkxmfA8MESDP7d6lp/BDz4Zkr5WB3
	yzC/LwaXdDTyXLi9UpLwHykL1yjpWwDag0GYNCbz0HNSR6e52v2gIdzWmj8fitHUMj+taX
	Dnx+H2WDuWjz4KQ4psQ1jVDOkbJJAi9bOYc8qUZptAU6ro7wi0jl9BnuHsqWGtky2IlWP0
	3jUlY8eMyoZbupGtygAILNgStHAEH7p5lELUlw8UmqYb+ZtVE6KCnv0fsWOvQcE+Y5KYg4
	ttK/LnejI/s1DZKgpuhccLPahqbpr/YZYgqazKSX9pf7Fgej+jl9etRD8LzPAA==
Date: Wed, 20 May 2026 18:14:57 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: Stefan Metzmacher <metze@samba.org>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
 Samba Technical <samba-technical@lists.samba.org>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
 <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
 <60328fa3-1370-46a7-9114-0267ef0551ce@chenxiaosong.com>
 <9b73c105-03af-4e71-93b5-a94e13b8c7dd@samba.org>
 <3a43f239-f35c-4d69-9c21-b410f0e38081@chenxiaosong.com>
 <d23c9f3c-4c0b-44d3-ac0e-6f054b955c85@chenxiaosong.com>
 <f5d913ed-6e36-433e-9549-66b8a76eab62@samba.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <f5d913ed-6e36-433e-9549-66b8a76eab62@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Got it, thanks for your guidance.

On 2026/5/20 18:12, Stefan Metzmacher wrote:
> See https://wiki.samba.org/index.php/Contribute and 
> https://wiki.samba.org/index.php/Samba_on_GitLab
> and create a merged request 🙂
