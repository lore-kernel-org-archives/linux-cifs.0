Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060A52C0323
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 06:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774940355; cv=none; b=N7pbMRgUa4dO4hIFXfnu6WwYG2EL3cttC5PiuRHRM+47xc3QFhFlvktg1j52rYhfiGVWDxpmixhxoimF5syMbsSKwEvuhl6oy7sOOebJrL8UUCT5J20LtrfkIj98cpemFCQy4z/N+f9cjrk0YMZYpNxBNRhaBh71qjU9Lhh9QqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774940355; c=relaxed/simple;
	bh=57+hKfIZPpFepszkAZlPP1iv8WhctUR63y3BAVDRmBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DEtHvac2H0v4L/6ymxiwlPy3qou8bRGsX2wuU8EpX8IFjkOUfHblKwPH1LLYR0QBkrDxYO7c6d6hMU2PmXtjrv4K3Blr/yLosrBsjKXT6Tq8Iv7s44d+8DKDjA4ZOaXzumVLW6DPLkNoySlmftBP8xOEDw3B/KnOK7bCnwLDP7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=fi5ca9Jq; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="fi5ca9Jq"
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6A1663F29C
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 06:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1774940345;
	bh=iEC5MJ8obDg2CLco5IwokHmKBCd99zm6WFzGzuqDmRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=fi5ca9JqxFj91dEuwtXp8gX9vbtKmz3IvpWsxJJsJJaAWO9CLLqR9Uej0Y32fDitI
	 0BDaNnIB4sbQ+P2KcwBu/vovw0IE8DF1gg78zEipyqhLusxtnJjstJ6AedmOHE/geF
	 jYcCWoRP8vY4/7hEwQvRSbiiWnzrNg0O/KbZPtvv8NHF2ARfA4VQer8B9wNX9kab6B
	 jBqaFYs4cOw3mkSjPWO+9rzSCUYqqjhqMqAqM85Z3Q+9isCcQGaCCUQxid7l16svWH
	 VDgOCA9578//+VAZZ8tQZdYwxbL8BU3pgfMMocJurq8tx+GGXTtTYJzGWaiYAnclnB
	 k0rOAwjBqJX90+qn3Nt/HZjXOURxTd7yIL8d86JJZ51FnvEq2+sV0Q8cxnjXuLB2hg
	 U+wQ6Ge5dppTeX9Pa4GNzgiqicGTou3yxMvgmk6WRBxKX1yK5jkExcpWWqv5VvF5PT
	 VhWDIBDblAokyPjkOXu2sJrg+tlMVVtIufHDZDQcxWTpQv/lo2mDsnw7UNd4re6vQK
	 sZahz/v9a5DF1FSy4OiH3d/DuWoka7xCJ+l+2gclwTgiyXEN2EG1fHtOMU5+Nu6XCJ
	 6lwzbXQiUL/3hyhLrWS4nTywsXAcXq7MJv8W0se6dupQB3Xt7S0xStKybDDFmKiEWG
	 k5/FRDpAqc8zRD8NOy8IJKyc=
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43cfbe041b2so1356335f8f.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Mar 2026 23:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774940345; x=1775545145;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iEC5MJ8obDg2CLco5IwokHmKBCd99zm6WFzGzuqDmRI=;
        b=eRQdaXVDgddDxDyF6NKIW4PbzU5zjgHF2Gfs9R8cYAhmhRn7QF8dOlSL3K+lMhe621
         FhNokbDtqXRQOZqAbfVeW5gF+TSZdcKqvcXuVbHh0qvXfrrRlBvXfRVRGAGmHg9XYyL5
         mDwV6S5EXFptv5hrkAObMisfNl51Iv6MB2FnW3g3K2pNfzZkVi2kKbnYN0FESKCA2tdR
         5heb8hiH/7+NX8NH9sy4elqfQ/YeYfV8VFReWVTow/3OW3dcTqTLAbk4+zCELKgXXHeT
         2qkszk0+cNuMyHP2nClpVHFX5R/gpjnm+/5tGdLVmeDjlJ01yTzhuG2l4UMzjp/oaXYt
         T1Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWu990Z8ErP4H9scZYoj23Sr7VOYLJCPIvl10M9P2foL8PDrg682XMUJsN7BxFEnsdxmk8oTsu7lyu7@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq6OxInwBq4WAkc+a8z96RsIrJlLfzNMpH2aR+gRHjipQJxJCx
	4l31eszd+9Z2CQeD3EimeFaoJ4VnNnYjVvlQqt0d6cLreXbPNSYSdR+O+ZTYKbkWRTviQ+xosO8
	zvfdY8TbQLV3dTYvBMaj325VpbGMFcgaL1WtAwjl1ucpumahFkbx02b3ro24qi1lAc3DOQU6Ngk
	CxobY=
X-Gm-Gg: ATEYQzzxFNrH5Apjz40DZlPF0QYJ/IXn84qVEtO9HGqV2qdDsuAgl/dQ/Kl4ydg+raw
	z1+sW8dK1nyujLb0qi3efD9Oyc/nVr1AfXaij53PILFShSekAOrAf9DsPcJwzjRftPjmfDkQ6Nn
	UNofsUP5DLf18pxknepFs9FXJvJsq5afZlU7gKNJK9ZASaRPfYygs1tmML6ka4wvmE8Q4bs+D12
	bsofh/iWxSHtyJCTV8U9Hm7voQ/mQhgCFrBsRfYboMApNKmDLZafJtntxKdYEkQ2P2SMVMJFVlV
	dIIpbjy8142mcrFpOkbdzw5z0liy4qi1WqgK6kFoE4lstaDM6lTmoFLg0ll/BgSFUFKalhGvG7t
	GICJfE7Tb8UjaxPnfJNaHPm7lRvvPHBiJZSmt
X-Received: by 2002:a05:600c:a408:b0:47e:e59c:67c5 with SMTP id 5b1f17b1804b1-488783820d1mr28492295e9.8.1774940344880;
        Mon, 30 Mar 2026 23:59:04 -0700 (PDT)
X-Received: by 2002:a05:600c:a408:b0:47e:e59c:67c5 with SMTP id 5b1f17b1804b1-488783820d1mr28491995e9.8.1774940344507;
        Mon, 30 Mar 2026 23:59:04 -0700 (PDT)
Received: from [192.168.1.126] ([213.204.117.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c760320sm12494915e9.3.2026.03.30.23.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 23:59:03 -0700 (PDT)
Message-ID: <a7c5ecb2-d46c-4061-a70a-c7b149db56f2@canonical.com>
Date: Tue, 31 Mar 2026 09:59:01 +0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6.1.y] smb/dfs_cache: Fix NULL pointer dereference on
 session connection failure
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <20260319144929.455978-1-ghadi.rahme@canonical.com>
 <2026032339-irate-monsoon-76ce@gregkh>
Content-Language: en-US
From: Ghadi Rahme <ghadi.rahme@canonical.com>
In-Reply-To: <2026032339-irate-monsoon-76ce@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

 > Again, wrong git id :(

Thank you for reviewing this.

There is not direct fix to this issue upstream however upstream is no 
longer affected by this issue.

The commit ID I referenced is the commit that indirectly resolved this 
issue by completely refactoring the code which led to the removal of the 
function I patched.

Is there a better way I can convey this in a V3 maybe?

