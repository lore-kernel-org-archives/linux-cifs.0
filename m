Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF128368D65
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 04:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787028757; cv=none; b=RKMRB9F2P8dXjjfRUIITrCIMdqJRn75Vv6ufHmjpFtMaMLRgy/tqJu94bGCCqUf4bLxQoDByXyD7bFdt1ZTbJ0eRWNhNoekSDHvSblk4TTJAT0LPJElZL0TZoCWI/fY2y56NtqalxO0bzvsTqPj7lscd6P33s6BWVziH91E5/d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787028757; c=relaxed/simple;
	bh=0/rVj1nz20n5H0JtwLGLdqLRSY7BWdugh7vBYa6O+wY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LjafJkir8Dc7Va8hFfMoDgxC+ZPJJDI10GzIHZDfwnABHeHB1gDyUtX3NC+HZ+UTNyLG0VTq2370HHB7TdAQJAyFMEcMkeO1a1ucn/7LK7dDgRqIhSZr1kTpZf2v6frqFaKQCnrIMQr8FtOusHVujVPDUBJbiG2dytvALSSHLd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=e8hkw9JC; arc=none smtp.client-ip=95.215.58.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="e8hkw9JC"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0/rVj1nz20n5H0JtwLGLdqLRSY7BWdugh7vBYa6O+wY=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787028750; v=1; x=1787633550;
 b=e8hkw9JCZXgXF5f12Xt+zD5/CKZ9Tw7WlY+R7DVkj/v7iUkefG0rpiCK8KAfOrXv7hgj5v+B
 YnRCTG9Oz20K4fy89yhBJEHvW7HeZVKRuiNRGiuwy3UUaMfPu6TV+aek1jldX1Bk4Zgb422bAZN
 vHiTk8CdRCpTt0dBnOPOL+HMVgkNkx8fv00ZuXDeJdKKw4YlU45whr+Y2srK1F1r4A17uVOaYcu
 Kijo1+JRCXXkEpTZXO7e60e5pCAChQAylvt0nLMC96t+6iDe+VNZ+O7V35zEMC1zxQfN+h1kpJB
 8YoKsBPnCZMaggGVzmar4z8F7Xgas9zB2CRD4nLAaLpVQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.3.216] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 1addb81b58d348f5;
	Tue, 18 Aug 2026 04:52:20 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <12ad789c-a5b8-48b0-a2d6-33e14c61725e@chenxiaosong.com>
Date: Tue, 18 Aug 2026 12:52:15 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 resend 3/3] smb/client: fix nlink of an overwritten
 open file
To: Namjae Jeon <linkinjeon@kernel.org>, hehuiwen <huiwen.he@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, slow@samba.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
 <20260805051112.305078-4-chenxiaosong@chenxiaosong.com>
 <db018269-4591-4d37-8e6d-93a4942fde46@linux.dev>
 <CAKYAXd9Gf_BrtMAFx7Zx1MZhSRV_xby0KGaKfuj0v+uT_SPGOA@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9Gf_BrtMAFx7Zx1MZhSRV_xby0KGaKfuj0v+uT_SPGOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It is a pre-existing issue and was not introduced by this patch. We will 
try to fix it in a follow-up patch.
https://sashiko.dev/#/patchset/20260804234205.72986-1-stfrench%40microsoft.com

On 8/18/2026 12:37 PM, Namjae Jeon wrote:
> This appears to be a possible issue, so the current patch needs
> improvement. I will drop the applied patch and await a response
> regarding this.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

