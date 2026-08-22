Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A9733F5A5
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787417186; cv=none; b=kNLTgCGVAoLhWWOGRht2WOv9qKqUETIjZkSkLU00voiIsW13CT0rB4qCzJT/tipYlKMFuDU1zJEhGofVt7d0l5DG6HxOaNea7x4vqac1Y3B9rvd2I82aENwsih7vYh306VjzcZa33kZIdPNFBL6K70EuVqtVKjQDEsQsfpwMJXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787417186; c=relaxed/simple;
	bh=xGpcJT9zP5vA1LDcD19HHMMH8E2yS5BFTXvRnR6UOWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SFmd5XVmp0BkosnXyg/wmaE/WiLRcXSfxb93puudMMDSfDZy6M3IitpXjQ5rfqB6zl0nYB0uBWoIRyIbnoVQFlt0a6TvTTSM+Z3Wb7Ld4rw7PRONJ5n7TIeq/5cq/j+oqyvhp4linyV0ZRfAz2C+sQdRDs0V94TbzEbwXdF51OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=fVX7PJEk; arc=none smtp.client-ip=91.218.175.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="fVX7PJEk"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xGpcJT9zP5vA1LDcD19HHMMH8E2yS5BFTXvRnR6UOWU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787417177; v=1; x=1788021977;
 b=fVX7PJEkVSs/4mOWVuhPei99bfOCMazm+L4xccLth+peRn90F2ZuKODupsI1X6iLlcDE8L6/
 P9AQvNrnb7b708+ujeCY6De10vCZ//QPH0R6kYp9qyXCs4kJeWGJJH8eDehfSB6o1XGpqmOENNT
 kE1Zy5z1MwBEl2wYNwHCaAN3KEJmgfLWCH69evuQ28lVrIjY96QYXj0xtnle1sLBeOCO0huTPUF
 p2cudYOabejncsMNao68zB+EzcwKjRf26ivJqvjb2aStB187uKnF/qd4EojQvruCcLhY4RBvcgd
 USoKjlmyGF90bZ/Fym9aeRiQphqWelEbpOmod9KFlyOiA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.0.104] (220.202.230.161)
	by smtp.migadu.com with ESMTPS id 159901a8b53e3948;
	Sat, 22 Aug 2026 16:46:07 +0000
X-Mizu-Trace-ID: 159901a8b53e3948
X-Migadu-Flow: FLOW_OUT
Message-ID: <af06aa2e-a02c-4b8c-8a83-d6e11c0bcd62@chenxiaosong.com>
Date: Sun, 23 Aug 2026 00:46:00 +0800
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
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
 <9aeb9ccf-dcd0-48a7-bc24-4b6948943f62@chenxiaosong.com>
 <CAKYAXd8JMs25fdyZhPn9KYEfv1WH297nxAV0enFHm6T+q=VTFQ@mail.gmail.com>
 <51fba35c-967f-46b9-8252-d433beab7129@chenxiaosong.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <51fba35c-967f-46b9-8252-d433beab7129@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

For ksmbd-tools, I am using your github repository instead of the 
cifsd-team repository:
https://github.com/namjaejeon/ksmbd-tools.git

On 8/23/2026 12:29 AM, ChenXiaoSong wrote:
> After this patchset, `smb2.session.expire1s/1e` are passed.
> 
> On 8/22/2026 4:48 PM, Namjae Jeon wrote:
>> Can you check if smb2.session.expire1s/1e tests are passed after
>> applying these patches ?
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

