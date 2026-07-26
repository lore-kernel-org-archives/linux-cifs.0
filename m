Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F430198A17
	for <linux-cifs@vger.kernel.org>; Sun, 26 Jul 2026 01:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785027734; cv=none; b=VDImsJQ/qKdQRDqe36VESN7E9lm52eSPWECJpK41uZYTDN+gpoIgIierm/UfjL+Iu6WsFXl4Vao+12QdOOf2sP1pf9m5q8dblKMWD8BKv5gkJzqJ5/T7b3S3rwfpbnULJdG2Qd7IFfTP2pY8mRYXL+g63k0Z3REC3G8hcnZtTi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785027734; c=relaxed/simple;
	bh=Q0qBDHliN/Q5TJKK2AmmvmaRQiDyawkiAD+Uk9JxDu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kEOzlb1v4IubzcH4ZO7vNw2osKyHsjAMJugbJ4rkogF4lhO5i1w7ICP6yiTWdfIvf5xenm5ds8c0Z3TW/keo9QyIHvmf2+SaVjHWf5FFaE9Qu53Gwdcd72lvrsjAQkWoAXt1FJV58YfwPXEGjCt9BbJQyfYMJfOVgRsV0JKXt6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=vfUvtjQf; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="vfUvtjQf"
Message-ID: <bbd88341-dd69-4aca-bbb1-e22cb4be60f7@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785027718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YwUm6FsOkjadoFOo0Pvg5+AHTKLRQX9QxEXsjWFzfMA=;
	b=vfUvtjQf+eRD5fhjTQWijxss+yoUYpfMTQ+s25lknw2jZkndLPGnogYRDKSABbxvWco8tv
	HCzJcc8JCBOECoavtyIph2lVhlZ8TXEb+9k/aKeSeJYSMUkQ6Y01+rB898KzloON6a+Ci/
	/LpNrsAj9ffjIooQAEWmscJsmxYJvPfUqVms6KmS/IvNUUboZPabOPYuAhyfPwePqEoa2e
	OvFI/bHD7MTawO3+a+lelobEKs3cI0Xk9bh4lKncIozA4o/B7jSbXQChgRo6j9w31XyoZa
	dmGXDgAZ/LhOfdZwGfHg6KTELAPaOAO+lEsuHz7Z/BbBQiI5Gt+hmdL4LgW3kg==
Date: Sun, 26 Jul 2026 09:01:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: use copied ACE count when walking DACL in
 set_ntacl_dacl
To: Xiang Mei <xmei5@asu.edu>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hyunchul Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
 AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com,
 kys@microsoft.com
References: <20260722235908.3564560-1-xmei5@asu.edu>
 <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
 <f855bffe-c601-43a7-941d-72ee7a7f852a@chenxiaosong.com>
 <CAPpSM+TbugewAeEPb1qGyDGgHpqTYBXt4hkL30i-opsF2w7tFQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAPpSM+TbugewAeEPb1qGyDGgHpqTYBXt4hkL30i-opsF2w7tFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thank you for sharing the poc.

在 2026/7/26 4:57, Xiang Mei 写道:
> If you are still interested in the poc, here is the poc we triggered
> the bug with:

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

