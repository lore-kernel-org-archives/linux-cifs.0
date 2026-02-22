Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFCF3D3B3
	for <linux-cifs@vger.kernel.org>; Sun, 22 Feb 2026 15:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771774966; cv=none; b=eDp3GZuDTnD22lQmrDKiXt40K6ntotnS9Jm/6Pn11ysE4WyJqgorcc19U1rPaA+VYOLmtgx7Gi00w4y1cy42sLSXna/9VMLKXii8qp3KFTYJtFj7q1V25F6Who7wKqvAwtr9b/aRtIBifQrv6jMPxzkpPzkhR3Mf3HVpsE+zUUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771774966; c=relaxed/simple;
	bh=EzG98uyqcabM0FwJWr60OtIfsMWBO6nWueWMXlAZ9qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLK3QfbA3Vik1YKElh7gZCkglRtYT1vGSqObycs8F/rxxWb1XRCbUaS/lfkYlfmSMHkB4+uiqmeBsQAxnQLQYg1+jNpL/V2INSnkJXjXSuqz/dKpswghamB5bdso+t6VEeGg+Ig5SYdR4uZVa1/0lAw+plxq4l5SOfoMGlSwANU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=nPis6mNq; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="nPis6mNq"
Message-ID: <9a8b5734-570d-4177-ba3d-14908bcc5e72@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1771774959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gda0gR/QLNf6nK340Fj95V6nXzkAs+quC0bvkbNDac8=;
	b=nPis6mNqzxbqwyd7O6Y6aX/hGauPSeDSa9e21Dz7kyxLeohQE9P/YEReEU99exJO+kwdcq
	a5g3lhhFwWg0/Nmkoh3iBu6jNLR9u7WoX+geFK0vTv9u92ghf/iTiSSSXFEkOE9VTyXnx1
	tRGmxywowQE5TCMe4hWOvvuX9cmRtGRuT7HKC7CwhllTDIv3sUp1o5uzJZPyZRCCESlFDm
	giymRinZXIArFEo/oAQbiuaiA75xzBfHzu4ppI5aZh8zbAgnq4MtV3eaeJ+XY99uBCBE4R
	tQUOISisOsbEG7uoZQTHZiYMoRMKvE0kex6HHR0BTNyJY5sGCMdIGEpKbvkxTA==
Date: Sun, 22 Feb 2026 23:42:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/5] smb: move duplicate definitions into common header
 file, part 2
To: Namjae Jeon <linkinjeon@kernel.org>, smfrench@gmail.com,
 zhang.guodong@linux.dev
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
 <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
 <5481d68d-9864-457c-9589-3bfd4cb6a54d@chenxiaosong.com>
 <2b43ccf3-9b2b-4f9a-8cbf-4213b0cdc484@chenxiaosong.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2b43ccf3-9b2b-4f9a-8cbf-4213b0cdc484@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

By the way, when the client mount option specifies `posix`, it seems 
that `parse_posix_ctxt()` is never executed, because the `struct 
create_posix_rsp *posix` pointer passed to `smb2_parse_contexts()` is 
always NULL.

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

On 2026/2/22 23:26, ChenXiaoSong wrote:
> `num_subauth` is incremented by 1 at the end of `id_to_sid()`, so the 
> code is correct.
