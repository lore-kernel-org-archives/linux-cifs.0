Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965483AEF55
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780755967; cv=none; b=MMyzU5fm8/n9/8PJZz+NU39PDFmerIh2OD8IS6ecA+nFCRYsX4qJVFM/RPqhM0qqaJ7F80K8hSoMXTJ1zS5yxFcZlIWR+cKhwkqzz694ZNY2yDEfz3oEJrBNZwjfOcIwbHq/JQQvbQH7kmBUxNkF2/Fx/1VrjuJ+MNwNn7NDgTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780755967; c=relaxed/simple;
	bh=wBvFXYit1ASMRnegrFZWhwX8w2+NXNvHPzgkBXChsi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Se4YM/fhCaPaWvzzOejdHEnpPJEk3G7b91aVWsPzJW+huRLqpiTEChDJa62E9CJYbJZApLJCK20fj7pd6zwoD4A/Ymt996vBFTiYxNvT7d9LCMGCXOJJ3pW2poGJH1CmQU9uGIuG9zV/RUbY9I1NF+eTQIGZ/bam0AsdVIaNqpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=XjbTESGL; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="XjbTESGL"
Message-ID: <0c16d764-91ee-4e58-bf31-18d671bc9bda@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780755960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k8t4rThStcXCdTT+xTFo9PRACXruukugqT0mO7KE7Q4=;
	b=XjbTESGLFJ3O7wXVs1oYBnTFtQLbkaOzTX6RTpPcT6w167X4KWhOgRwER5tDL2p6YEQgGO
	LDCWL8a/5gKU0LDToRjpGcs+18Th4X2QJ4Z/n4Gx7ooWkMUPbs03PqAXR9wX2yRuLpYBlx
	vg+MmlrQ59TJEh5bmHMj5XFSyPGHng4BHG1RujUhXDjVIBM+1/A48a9iNWNpj3bPnZ2y7q
	5I2wAIpswT5CM2Im/Z+OOmguI60S9cvU2s2cAQzcz/NBFgtcRSLw5J8ZlfiYBCZ1vmOe+j
	rPDrpZcNn4p/TPxsapb1RKz8IAFpluJBnQ8UzYcKPe3u4vuoiQOxyWMmp6LwDQ==
Date: Sat, 6 Jun 2026 22:25:41 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] smb/server: implement FSCTL_SET_COMPRESSION ioctl
 handler
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-5-chenxiaosong@chenxiaosong.com>
 <CAKYAXd_Ls0jSyH_bHvEMjgGivBpHLcEk=J-Ts70jjMNdUTWnhw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_Ls0jSyH_bHvEMjgGivBpHLcEk=J-Ts70jjMNdUTWnhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Yes, thanks for your suggestion. We shouldn't roll back 
fp->f_ci->m_fattr here.

在 2026/6/6 22:11, Namjae Jeon 写道:
> If the xattr update
> fails, we should either properly roll back the filesystem flag as well
> or don't roll back fp->f_ci->m_fattr. I prefer the latter.

