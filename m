Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9053BFE5B
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 12:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768911822; cv=none; b=BER9S3x+LzlGTlsUTQnz8VNV5ELSyuIn3sRomcBVcy2XcPUFzLLSmlXVvL6c6Z0Ugyj5sZjcqtnI/uC6WQOK3iY8cNBPlyXXDgkG6w3djCdvMuEoSq47Qx13ba/zPkbVtEJ87VCKKJa0tysD0ilWYAx6yaJZa1j6A0GkqDc0+ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768911822; c=relaxed/simple;
	bh=1XPv3uNkmWHVj9nBvtujA7kYi4ti9RusPKYh5MYQv+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KuxWXx0cHpuJia+FoxsTtwEmrccNs0jeac3ETQftyYJLytblBxAom6QM3alKdfvfOp25OouNt75Sppf5q13aaMAAR5NBLIpwKbSEnPw82kpOrsq5PHYn4a3S0PxxkIRox+CJgNzGudgDLZKvQptKyTwc8v8OYzhIqwnh0jojSrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Drdyl/Vp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EkvhBGSu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Drdyl/Vp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EkvhBGSu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768911819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEG9JILWJtDxSikxSaJuovdTLx8v+TifArul6/N/tD0=;
	b=Drdyl/VpUYttoby8mcxl7CUbA4qM6usq2UTT3YFy9ghCdUCQfXpUDUzfH0eqVQZtctBTsY
	R+wmAy8tws6uMR8u9Re9Wjcgegnr9ZnBksIVoHpZMBchkRM7Rjc+gZ9daN44bvL+IEabkh
	4QsAY1sI5m6f1sIK1ZvqFer6vO7/tuo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-KjRkcWZGP1K_-k8AOhyE9A-1; Tue, 20 Jan 2026 07:23:38 -0500
X-MC-Unique: KjRkcWZGP1K_-k8AOhyE9A-1
X-Mimecast-MFC-AGG-ID: KjRkcWZGP1K_-k8AOhyE9A_1768911817
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4325b81081aso4407438f8f.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 04:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768911817; x=1769516617; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aEG9JILWJtDxSikxSaJuovdTLx8v+TifArul6/N/tD0=;
        b=EkvhBGSuPfqPRphz7f+oayrtgHhBvdVxYzE5GcF/IyrZA7lM/kGbqA4VS27Ykp9NA1
         0IEzlcHcPAj935jEcGsWeyvOkNedsJiIbPF9FsG9R7rZ1QHH2Xwu3UO2uXJnn4UobcJV
         Kd3tcwi3y4tPZqi3evFqZfbqhP33B5X+/xO1BnUlMJQXMtJfiifOREZsDga1hc3Ea+b+
         zkRyzq8AUwCgBQHRLe059aU/spsq/thxQWl56Dz//LTkGl3olYmyzMCkJBqG97267d0q
         COlWlq8Y2Kou2ZEYkTUPyEzGkMXfnHu+JS0QnpK3qK8iokzuy5TonQLkPfLmkMqT/6Dl
         eeWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768911817; x=1769516617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aEG9JILWJtDxSikxSaJuovdTLx8v+TifArul6/N/tD0=;
        b=ZjscGN8Lj7N2HHBko8AeJ2oSD928BlN4xoxtu7gxBvLm/9FFdNz4lkQutKMm1rSPPd
         RJjwNIjF2Ld41SxxvpKrXXVhbKEwE1uE/sn/HckzSnT6WFwEZsn7oB9f5ArBsNCAgOtw
         rhJmErcqrKJm2tKZnYknfpeBJbd61tak2CLJsmPC9yHjQf0bVelE/lIwwluZb9lue2O+
         Xxp0fSMeaLk0BOwqZsCc3bEs2tLIIruw1vL//gx888jz7v+I/GHH0Rl5mhjVH9tix4hD
         CIeBwni8YXQen6777mc638LWGhpcEjk1d+kZKXW9IS5+Rz9ekcnmoK2yMWJPuMk2W+PL
         t0+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXTtD+SokJ0d+G7BHe5IR2dGdeGoiKzjf1UOZOSIFrpE4FYWkWlYDW1YdM8pvobLDhpIEmWwKRDHGRT@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/QroHXewzex1wPe1Qde9yfFmKL8Fhu/JaLsccvc5VkSzLTwuj
	rO6TkzL+/tc4AIvo9URnpmqMM0b7UNrPrGfOYq/MRa6tGmWEqN7OemG+I0J5bMHflowFq/O/h61
	byh6e7PjUSImSE4VVum/SRWx8dGtXXKt2hbeLKwEkmo9msGdbEOmYcGINO47+i6g=
X-Gm-Gg: AY/fxX4V78HS8/1AJFJmUNFdDWVP1tsV85X9l57qvlbooaL90XAUn8qwBRx1nnnIiRR
	oR4Nm33fZ39j1fu6CneeoVpv1s+bMXBMqcOuFVDxeDlaaQAaCHWc69sv8+5ieNBlPPBQOVMVU9W
	IZsiDbzgpJu6CXP1nNPjvnjcy8WrdUese8XGe+K4faKqb26hP5ay0tR+zHKskL0xIPE3VVFCwGo
	VR3mVW/rW5M7bubzVW47l6jRsSbMwZvEMEMJB8XTGhmyH44bQRpgJw5p7icVnXQ1gTaCZbPgg29
	yt4AXu0S96TkJ4U2uHsQk5FFaBJJ84mSzrRFD+OUjcFLC5sdwB+w1iKPjTPEvVFXH6WP3Q3mp03
	ejG6HumjaES51
X-Received: by 2002:a05:600c:3b1b:b0:480:3230:6c9b with SMTP id 5b1f17b1804b1-48041472847mr5520405e9.7.1768911817129;
        Tue, 20 Jan 2026 04:23:37 -0800 (PST)
X-Received: by 2002:a05:600c:3b1b:b0:480:3230:6c9b with SMTP id 5b1f17b1804b1-48041472847mr5519745e9.7.1768911816688;
        Tue, 20 Jan 2026 04:23:36 -0800 (PST)
Received: from [192.168.88.32] ([150.228.93.113])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e86c197sm247488175e9.1.2026.01.20.04.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 04:23:36 -0800 (PST)
Message-ID: <a9c9f16b-f695-4009-945c-ac3b03631596@redhat.com>
Date: Tue, 20 Jan 2026 13:23:30 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 05/16] quic: provide quic.h header files for
 kernel and userspace
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1768489876.git.lucien.xin@gmail.com>
 <32a34bfa4fcd69de5c738db95dbd71ac8e361d24.1768489876.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <32a34bfa4fcd69de5c738db95dbd71ac8e361d24.1768489876.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 4:11 PM, Xin Long wrote:
> This commit adds quic.h to include/uapi/linux, providing the necessary
> definitions for the QUIC socket API. Exporting this header allows both
> user space applications and kernel subsystems to access QUIC-related
> control messages, socket options, and event/notification interfaces.
> 
> Since kernel_get/setsockopt() is no longer available to kernel consumers,
> a corresponding internal header, include/linux/quic.h, is added. This
> exposes quic_do_get/setsockopt() to handle QUIC socket options directly
> for kernel subsystems.
> 
> Detailed descriptions of these structures are available in [1], and will
> be also provided when adding corresponding socket interfaces in the
> later patches.
> 
> [1] https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
> 
> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Thomas Dreibholz <dreibh@simula.no>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

