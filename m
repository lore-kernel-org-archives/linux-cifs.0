Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F05408607
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664579; cv=none; b=CUnBNB4VgEB2SNXTvLWypl+rlDvKwhNLv1uxhkMoFXbSlQGScwu+8YnKbcpJhg8J9aBIUsjxdyeGwhXRbE13VM1Tsy3h0j0kzna+g83pYUTMz+cOh0gTNkz9gfnpxel01nY4kzD5z2WeQvpQCSEIYS+Akt5BXUYe6n2vAwkrnOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664579; c=relaxed/simple;
	bh=oGxNvPEwA9upizmiIAH8clEB5j46vUJkf+sCPlXBEcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=apZWrrpS2EMKbe3vpD9sgvRA73FvwxfMrS7vBeG44FdBdOa0k6oCqsuTLizPFkW1QCMqLW0MDyRvuqZi3FAjVIu42NWRe/P5fMFiIo808aS9LKkwldEngcQFmFVjhT9OYkzFdG5TpSPP6GjBB3T5xQwuJPbyzvOvcnvD1WFu3K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=UjOFvtDw; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="UjOFvtDw"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oGxNvPEwA9upizmiIAH8clEB5j46vUJkf+sCPlXBEcA=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787664572; v=1; x=1788269372;
 b=UjOFvtDw7qLEbCo5yWd7PNQHAAkYLiC6ueaQoskMBVsg+92EYqb670W9GPTpB2aV1sLO9bws
 HL80dI46/PhsqYpvGAKvIkGWAIV3GOSC4mvV304Zx2o61FvBwulnNAUJ0oj7l0/+ceYc9Y1X8/x
 sw1sBkw8uP0vZj6ugBDmieer7TtxUp3ZnR/+loDGE/NrZWck5iT935J0UrqJWFWMVg2N/TQpTHe
 4MDHHqntGgByrX1g1yV0/QKE3a1pQBpj90MaN9neK1dS9ADleEghKJtJs7VkTlOm260N8bPTjp7
 zJ6bxVce9E1yGef82Im/PUpdSwpRJFx3be6VXNQ8K979w==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.0.103] (220.202.230.161)
	by smtp.migadu.com with ESMTPS id 6b90914ac4aeb6fb;
	Tue, 25 Aug 2026 13:29:21 +0000
X-Mizu-Trace-ID: 6b90914ac4aeb6fb
X-Migadu-Flow: FLOW_OUT
Message-ID: <c5f4897b-c2b5-4085-8834-60b070c14302@chenxiaosong.com>
Date: Tue, 25 Aug 2026 21:29:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
 <9aeb9ccf-dcd0-48a7-bc24-4b6948943f62@chenxiaosong.com>
 <CAKYAXd8JMs25fdyZhPn9KYEfv1WH297nxAV0enFHm6T+q=VTFQ@mail.gmail.com>
 <51fba35c-967f-46b9-8252-d433beab7129@chenxiaosong.com>
 <CAKYAXd-1=RqAhykLJVgDrYEmr1AU6B-MUfiQb4o4S_JJyU0NVg@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-1=RqAhykLJVgDrYEmr1AU6B-MUfiQb4o4S_JJyU0NVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I will send the rebased v4 patchset soon.

On 8/25/2026 8:41 PM, Namjae Jeon wrote:
> I tried to check again, but your patch set isn't applying to
> #ksmbd-for-next. If you could send the patch again, I will check it.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

