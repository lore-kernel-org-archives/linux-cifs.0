Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A413273D81
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761623507; cv=none; b=dOoqws7bNOaZux1jBmcUbNhgnUGUzacR4jv1xQlBAyCahkxYy9yD85XKVtSrgvHrp10NqklND6H8Lbham3iVMVO9ZX46CZ3G3Parov/8H78GMnYQ/uK3Shmfr6r4FYbjxux8USmGr9e/KOLHlJ8JJrXWeic2mFHQVJ0k2wGLANk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761623507; c=relaxed/simple;
	bh=5xMYtSEok4bYyLtlLowAuhEnBHAtxF/58LNkN8fxapg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=neUyJ2Mt8+wq96vcYr46B1V98Z6kM6QUYnIQFUXYl5Yu6g9MCUqZXod+tnIM2NnJzEUIddyiOf374ZBwKkrJAtWlIzEZq4o4gEE4dAHRl+HgiSgiggbT7o2P4UMbMpDQgNaJ/DzRLE/UVItD1awgrS1NmcGORh/SFGbtfqlyXf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VTv3uyI9; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VTv3uyI9"
Message-ID: <ed7e7c83-6ff3-4a10-89ec-1b38610fabd2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761623503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CwVf5Z+boA1bEp6FLhaWmibblYnli4umc6NlcbXHDZc=;
	b=VTv3uyI9pTP9vVQN+eL9q1tbWQIzsUZQBv0c47NoCWr3YGGDaqppbAe28rwLwvMlOQkmbz
	lHZw/6NmG6bsDxLYjiytjC4IezQfaqZZBMrvUDYgNB8ophi5LzWC4I3e/pDscd2PX3/HH/
	PIX26TmsTcqvLQnWFCPhvhmJlvKtE2M=
Date: Tue, 28 Oct 2025 11:50:53 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 06/24] smb: move file access permission bits
 definitions to common/smb1pdu.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027071316.3468472-7-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_LqhpKCJAPKm0yBC-G+tTJpVQJSoTCbEN7Gdz1kMnQDg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd_LqhpKCJAPKm0yBC-G+tTJpVQJSoTCbEN7Gdz1kMnQDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Yes, maybe I should move them to common/smbglob.h.

On 10/28/25 11:36 AM, Namjae Jeon wrote:
> Please don't move them to smb1pdu.h.
> These are common definitions that are also defined in the smb2 specification.

-- 
Thanks,
ChenXiaoSong.

