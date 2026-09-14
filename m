Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51753BB57
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 04:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789360003; cv=none; b=nJ5w0lktNrGebgMRx8TrQBhMfWgJghjlI28mwMPzUGB8DeMvZNfWk7gtrkOLHlgKm1QC8DiWCilxJQUbrjn0frjZB2KAgfa/EHUEKeI+VXxOTXb4pFS0Wski46el/Tj/blBTGoQ/CsmxEI6ZK1PsyDPMkb99lwRz1SoAspmVokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789360003; c=relaxed/simple;
	bh=VOAzvY2ei3ExZi4PV/bXr6gR1v5ceFpGp2NOgcCPx5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImteCZatvNJF12zAPRlL3GTRWyzntnacR7L0U/u1g+DQ86lHaidXDGqXIer+jenAZrlVyfQYbqTmMMvwqSi8Qgz8Sp2VPXBBtkRVaKagDnAyarRmR6qzCGRA9FA/il0GIHfSMU0lWTzoI2mgWbGwm82GpWEEsGZ9rVSUW/AWUpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=a1URwWAd; arc=none smtp.client-ip=91.218.175.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="a1URwWAd"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VOAzvY2ei3ExZi4PV/bXr6gR1v5ceFpGp2NOgcCPx5w=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789359997; v=1; x=1789964797;
 b=a1URwWAdiEYIC9VWBzRbfXbEtgIGWvlWTf2pLnrPYTpQ77c9j/EqAtAmRZfSwstIagVRPDdf
 4l/T2tLZjohzb3Zw3k4IVP86eEl3u2LIWH3btbyCbJhnrPkeCGa2yCFjnMfyml/WtLc3z8lihIQ
 g3k+nV9wnLmmCYhs8D5kqeh9TeERmVEgaOt1s5iXifdpQItAIpmcdLssadDEJ4KLS2MO1vlZjIC
 /v70QnBPymKcE05oKvgOB1fO6vlsWgdKW++GzKkScV16xUpFCvfN5/drsHA9TQhlw7yRvgn0Nqs
 6/rbJkT7qys1MhQ8PyRH5C0ZpTscY0dgMOx3r/13ObLig==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dcb88edd75cc1906;
	Mon, 14 Sep 2026 04:26:27 +0000
X-Mizu-Trace-ID: dcb88edd75cc1906
X-Migadu-Flow: FLOW_OUT
Message-ID: <d8330501-0a1f-41e8-b408-2e720f550657@chenxiaosong.com>
Date: Mon, 14 Sep 2026 12:26:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ksmbd: fix partial normalized name responses
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
 Mobin Aydinfar <mobin@mobintestserver.ir>, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260913113552.11486-1-linkinjeon@kernel.org>
 <ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com>
 <CAKYAXd-efarHzvWEXSc_0jx6KhK3KJOfmuwM+wsVCmcsFUBTWA@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-efarHzvWEXSc_0jx6KhK3KJOfmuwM+wsVCmcsFUBTWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It seems that ksmbd-for-next has not been updated yet. Have you not 
pushed it yet?

On 9/14/26 11:38, Namjae Jeon wrote:
> I think that both of them are changed in another patches.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

