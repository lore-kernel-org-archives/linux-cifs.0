Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0921E376BE4
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 07:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784877022; cv=none; b=sJD4+j60Bx0YqfR/RGkGA62FDeqFI8YmKcpwPHIYK20QLBQlodTYmMK7ps1XAP5vaAnkzwhv+ffMg/cIkefXjXMlTWmwxBvUo487FOLuAK7YTKCeWj0F6gNgTLTudr4TGHxYLY8GXD273ZTTyTJut0lttrzYZM2/BISey6T/bec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784877022; c=relaxed/simple;
	bh=XRXAK6IRPXIajbABlvGYP6eqZL2KlFF9keLXznVDZ20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tQvtvQPN+vgmXpgLZ547YzAk7P0jJnjb0wbGTNNbTtyEssOUYp22Gf65Z1By0Tx5ni3lR9Hps2RTHPxAameP/u4tvhf8YBLDLpc78JduXXg1g3lu5hKJz5NmckxLTNxpYj248fvdyGsZULwzPKTA+RWpmEmrDiFl8i0TFn3Xnws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=a5XOxbEV; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="a5XOxbEV"
Message-ID: <f855bffe-c601-43a7-941d-72ee7a7f852a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784877007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YCAkrxJjKEwauTF54bkyleDW6L/FX8KecwCMVU8dhko=;
	b=a5XOxbEVI/R5s05TgORsRhtyeUZQmg0koHjqOFJVaue/bWz2kImDChImYALSlYUQkD1IMQ
	tDxwWhj0JuA53JJTh8MiJNlLROfCYcH4jIyObyXPhHYH2wUvYLPhN9VqSFrgXj7lqI4JR/
	9Bibz8ihU06Y9+UE1OeNqj0sP0hjxpeLscluDNAn1yTZoiQEQKb/q9XQRtGQNk278yYuxj
	Y1NXdjPf9fWOYvQxlxOnxwUu/Sjbg2t3lnCUgwCKfF5V5xWsXd8Qb8QQMY0kK/bKmLB+SK
	IMgtjsw0tiCtaJVrG/8zvA654AIumVOtjP1Wp5do59WzRxHeNHOn/klWzKI60w==
Date: Fri, 24 Jul 2026 15:09:11 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: use copied ACE count when walking DACL in
 set_ntacl_dacl
To: Namjae Jeon <linkinjeon@kernel.org>, "Xiang Mei (Microsoft)"
 <xmei5@asu.edu>
Cc: Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hyunchul Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
 AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com,
 kys@microsoft.com
References: <20260722235908.3564560-1-xmei5@asu.edu>
 <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Could you share the steps to reproduce it?

On 7/23/26 08:19, Namjae Jeon wrote:
> Thanks for the patch.
> Could you please check whether this issue is still present in the
> current ksmbd-for-next-next tree?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

