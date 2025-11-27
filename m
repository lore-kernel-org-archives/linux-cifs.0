Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516F92D7D2F
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764261298; cv=none; b=aeqwepjMV44oru09JyK0vH/C85zsZKt+vu3VqkLNPpAORfQGQmEEsCrMVcSxpm+RQ5hRn2rxbZNYr39FD8dz/sPkcQXtq4uluFvK+//mWwWeDe9tpBuCElnwElLKflFvtxRnOappupxUs6SzEiGDmhHf05qVRKhwja4n1C8Hc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764261298; c=relaxed/simple;
	bh=qbwQQeYnhh5Jp+VwwIUbFfb16SXJjHTfT04dLegf2aA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aztR3Qq++a9Xc0URwPlA9clNYPom3e4N/lql04bGS2yfeKyKsSf/Jd8F+mETJTCMFAlTRt7cZD9IQrbm7mnVMlp1dH80Z+Lqf4B5bM3Dx33IlOdoYgfZEEFwwx240SXHN+GZkg39jS14KhSavxrOtErwHE8RBRl507atPg4m8mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FbT4Kp5J; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N2C5DMv4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbT4Kp5J";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2C5DMv4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764261295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4iwbs1h8WPfjtCWRn3LxmIB+8Vn4N4Td3zMk03YVIE=;
	b=FbT4Kp5JEh7tvFojDAoPB9nmDPJ3gbOF1FJLdq8DnXxdiTf+3rP3q532DziiX9deXqbztK
	5hHrUZ9YXQXO9/UoPa7IUlVauTThZ+NNx3zjXE0ZLaJykrU3FvkaRlXq4ruIOKXPsp6mUV
	HQPkIEqRqcIhsdY6qGlk+SGNGRkwvPQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-eTeKy9njOma5Gm_QvzIKXw-1; Thu, 27 Nov 2025 11:34:54 -0500
X-MC-Unique: eTeKy9njOma5Gm_QvzIKXw-1
X-Mimecast-MFC-AGG-ID: eTeKy9njOma5Gm_QvzIKXw_1764261293
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b2ffe9335so687310f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 08:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764261293; x=1764866093; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C4iwbs1h8WPfjtCWRn3LxmIB+8Vn4N4Td3zMk03YVIE=;
        b=N2C5DMv49YAmipiVLj942vrUXgAqs8MW/pqT4xpbd2xp7SNzLOsxY5xE9E8ofIetrM
         FnKxyvQTqNbUKB7X4HDCj2i/QBomZ7bXVlYdX21Q6VWjI13LirRLYiY3Xcir1SiCkZ8U
         qTsI5oBcjc8k3Kd4piiaWHCiw+7bzTlvgpfc02gxn3WFmmqKWhA9wNVNzqos/gTzzpv7
         sDKE4qh/4WQ9dXak5jbdLyD1MhGqNqzb1AEbE64sxOgF9Hl5JGaQr26bIgIXic9bHrR3
         BNoiIgD8xLj7aep8mTK5byHIfcCZaQydHYr+BxFiX59iXqPvC3AcO9klq/JQgldDlkfC
         ySPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764261293; x=1764866093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C4iwbs1h8WPfjtCWRn3LxmIB+8Vn4N4Td3zMk03YVIE=;
        b=EbCFax2gByJWgPDLx1My6m2jAOdp+PCUKX5XBLe6nxyCVUC+fh+wt8DcbhZumL4Sy7
         co7xsAeaQ4B3szojfUIBDzZ2lJ9I4Qya6QW3IR7+ulSSxCaGCaMOP1j01tjmEqM4efdJ
         2ySEtJl0dl7pHyrf6C+HPAV52Vsr8f2m2GODB7+VKKEuCt0FcKpms7OgN/ooXiklNtuk
         dKmu8qbo4DmTUpZUdWRWjG/CRj8MdF6rtrUi8HCDzNiUGiJAhLd4SXoiNObX4Gld13Fg
         uvdIVx6BRwt2klSbdjB54hwqkME2UYbmQwQWhLkZHOwvhsCPefb2F+Wc8MQ9xTCQyJRL
         kHpw==
X-Forwarded-Encrypted: i=1; AJvYcCWxO6fAYOSIGntKV9SP9qqyUAENbhjueGmMnz8lA6I4vECHr9FVimgt9vPdAhU4K2b+Ffje0Zp7904F@vger.kernel.org
X-Gm-Message-State: AOJu0YyVXskuVHULJkQwbNAYJwETemar5mRxLVEQMfdUCse2Lb22qIe8
	1gfU6OFP/FCq0M1SDQ3V0w1Tq3Bih3mzgI9IFPm6hb5PFAMeJsNZQlZTm0Kbg5OBww+g9oxBgq+
	2HWlEPugCHRAGCuFcRnbjlcVmd+eVSj+7lNE3brSyPHdEzf9JXZpO9fgLqTQP6oM=
X-Gm-Gg: ASbGnctK0wH1QfZdOvz8ZfPkJc2k+C2BcGAwIrmMNPKDbUUYlmvhj1TMdRSaUf78l4Z
	24plRpw10Mhx7U3fjdQomgHFzZ9gVW0aDo6zFLjnj7qFQ4k4123AGrmNoihy/RT/IffQulTYkeH
	qs3sQ1UbktkIzAhkJ1eHQobvBmEUA1S7Q4XoCF0CscYIyD0ynzKppypfJtP9u7PhNY8192GqtyP
	7/v/g4J3fI3juhgMeFT3F1p8nmP4dwwPaubc1nw1CpZYaF/sjLVdHDD2/LalnbJJGr/Z5X6otxS
	8MJx9+YN4C5BWJNQ5jj8EOjSElFr6WBVpgh3EPCzto6OWGC2NOGE9HJKiRQwXXed44lhM5k+70f
	WwiMuXF6ciEIf7g==
X-Received: by 2002:a5d:5e01:0:b0:42b:3131:5435 with SMTP id ffacd0b85a97d-42cc1ac9de0mr25419574f8f.2.1764261292609;
        Thu, 27 Nov 2025 08:34:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBjcdBlqLKajPU/sQcGkGD00QWIR2/Z2jTb31o5tzKYhK4fsXo5kSSU+5/YPOKYslbkKRh+g==
X-Received: by 2002:a5d:5e01:0:b0:42b:3131:5435 with SMTP id ffacd0b85a97d-42cc1ac9de0mr25419529f8f.2.1764261292099;
        Thu, 27 Nov 2025 08:34:52 -0800 (PST)
Received: from [192.168.88.32] ([212.105.155.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c3c8csm5641761f8f.2.2025.11.27.08.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 08:34:51 -0800 (PST)
Message-ID: <3dd5c950-e3e4-42b8-a40b-f0ee04feb563@redhat.com>
Date: Thu, 27 Nov 2025 17:34:49 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: define IPPROTO_SMBDIRECT and SOL_SMBDIRECT constants
To: Stefan Metzmacher <metze@samba.org>, netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
 Willem de Bruijn <willemb@google.com>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Xin Long <lucien.xin@gmail.com>,
 linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-rdma@vger.kernel.org
References: <20251126111407.1786854-1-metze@samba.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251126111407.1786854-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/25 12:14 PM, Stefan Metzmacher wrote:
> In order to avoid conflicts with the addition of IPPROTO_QUIC,
> the patch is based on netdev-next/main + the patch adding
> IPPROTO_QUIC and SOL_QUIC [2].
> 
> [2]
> https://lore.kernel.org/quic/0cb58f6fcf35ac988660e42704dae9960744a0a7.1763994509.git.lucien.xin@gmail.com/T/#u
> 
> As the numbers of IPPROTO_QUIC and SOL_QUIC are already used
> in various userspace applications it would be good to have
> this merged to netdev-next/main even if the actual
> implementation is still waiting for review.

Let me start from here... Why exactly? such applications will not work
(or at least will not use IPPROTO_QUIC) without the actual protocol
implementation.

Build time issues are much more easily solved with the usual:

#ifndef IPPROTO_*
#define IPPROTO_
#endif

that the application code should still carry for a bit of time (until
all the build hosts kernel headers are updated).

The above considerations also apply to this patch. What is the net
benefit? Why something like the above preprocessor's macros are not enough?

We need at least to see the paired implementation to accept this patch,
and I personally think it would be better to let the IPPROTO definition
and the actual implementation land together.

Cheers,

Paolo

