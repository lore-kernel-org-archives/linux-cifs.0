Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D442D2496
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762249094; cv=none; b=KSs3ZFh1ZwDPid+ahxATx5h1rTcLoRB9T5tz/PneXLzj0GhJ6tdIt5NaFhwFDRL4VShzUr6wGzICug628vhtUB7FLp8oF6V18p/XlYH2xAws8LIw2tSmv2RLutZrH0J+y4EVIGDGUZd26HfRZx2KtJh6yG8dRgkc4mS+cmjPvSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762249094; c=relaxed/simple;
	bh=ArUnwMfmIEzmSnA8EtwjQrV26Mp15GPDfG/Jc+Af2u8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jIAxExVSsTVdD0P1jlmcjlb72SgFiA7sKl9PRoe69c6gGt9iXxD/SROJgbMEd0YB+O938QVip51ZN5t9Zj7whMPT269ujQiBR8IWfN6gEo5jSmPONV9Se6CsKUnLh6B0mCbzy66whjZS1q4iD3H3NCx1X18EH7W1olhVqXihTOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rqj1F5/A; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YtWWSJs9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rqj1F5/A";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YtWWSJs9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762249092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/pyvHBDgoa9Lgk2kT7iDSPcIKDbs+wNswe6QWBYpGLg=;
	b=Rqj1F5/AOpswRrO7lL1NWiM6Oq2JdcgEdyJewKRoXyFtNZP5hfkx8i+zbJwsObFAEfzzla
	iiaRepznQXJMhsbNWIgV7y0iEewMKZ5tQr4TKlfvkNSg932bKB1fC2yO3EiOJ9TW3+u/OX
	PvzbTPtW9aAzMBoFWNzlEooT165JvVk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-7TGLS1-7MmGwpvulLfHBMw-1; Tue, 04 Nov 2025 04:38:10 -0500
X-MC-Unique: 7TGLS1-7MmGwpvulLfHBMw-1
X-Mimecast-MFC-AGG-ID: 7TGLS1-7MmGwpvulLfHBMw_1762249089
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-475de1afec6so18505675e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 01:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762249089; x=1762853889; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/pyvHBDgoa9Lgk2kT7iDSPcIKDbs+wNswe6QWBYpGLg=;
        b=YtWWSJs9zg3NSSLRVdZCz4cndOeWKzlW3/yp8+eB/uDmDL5rxF/w4m3weYkguNjlsn
         lTzKkFBnz8kjoRCcATR2jvHgojM8MH/n7pNjDLhfRXKduTHg59TyG2rq0kqvaYisAsh7
         Enb1H3OGs1GrETn3PnYxZDQPqjUct28uX53mLZ5gqitASOmt+6dzxJgczv9bDZXcVXf7
         PpkD6BCRMldcZbyAHzwUSY1Ub65pORcV3LspEMRUB9BTSHNqGIDBceDRvFKQHxWwgKMv
         YAPBL+K3zqWoaCtJL26S/fSTgNsaV56KhQ6tgV71NMa0PItYhXEIkxYSiWuZUyBALiJX
         e/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762249089; x=1762853889;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/pyvHBDgoa9Lgk2kT7iDSPcIKDbs+wNswe6QWBYpGLg=;
        b=RYiMhbKYOKWpGHHR17tWTfw2JdyNP3kgqVNe+zNTI4FjnYtn88+faqhkwg/nabU5QF
         Bw45I12caw9/RvjkQCZtl8kCBGruxKRHAw5wGZz+oS2RuHZmFNy7ahK0qQapQMTLnKdO
         DuWhoAxkcEtuI0aVfFKpoutfBcnHw9M6uH18Ce4KLuBwnbzt3/exhf4kvMNB3JXjZ/aT
         fOnlBTL7EuWW4I5HOcYj4q1LJhOg1pjZFPs/8WBoNxV/s7XwziOa8tiBYFeQDux04JA/
         VWUxTgZwt7Y7UBJdRK8EC0hjD2hw8g3cFM47l8TqI2kcyJNi1z8o5IqoBeo4QPTRcoz+
         BSLw==
X-Forwarded-Encrypted: i=1; AJvYcCU/XpBZsD6zvlfyG0BXB9LUS1gG1qOcn3uFV57c9fs9EujddISi/3lfgGzKaV80KKiZNojCoY9MVIbq@vger.kernel.org
X-Gm-Message-State: AOJu0YwANTnelpBvqczCOegJiFU7gjPhrJfnr/pE0lDuu+i13UogVAxu
	zGoZmFQjYk2ct/1IRZrE1C5LKQ+gmT+i6RSpJnrBfRRaOILaheyaxcqtE4Q2hqeZav9/oLQEzK4
	hygl8xSC3q/wGXEOage8TjlmDWJUYnEWBS8n5YZjfGOcm0VouLexzh9wCyO/TOtU=
X-Gm-Gg: ASbGncvRoW7jMLmy+KvMhRpENRjz9gH3rvgw2GoaE+zxgX9Ykl57l8DmcDlVQUT0OtG
	Aa+TZ1yoCbElpgTVu/2oVeiQ+8InmFXIhjyFztztqMnlTPnweBnFsO4m1zJD6IucadyxzFlamy9
	Rg00dsBNJXAnkgDWBPcobJ5BeUDS4J0MVUkjJATFqUqnv7YGkEKkBXRyKANLN9rk40hc9jGqXWQ
	uVMqFCNNsnQmOk0hIsk58xce3jDnerLIydtPDGvp6pSLg0ltSFoaWSYthR3qIW99mS6J77LTlm9
	I6CNqe/YYNTstrlm3PgpKoB4gdEIb5LrOlzYKxNTq0exUcf31deBgYeHGvUsjCUr8rgxQzuhj7+
	IlYyBYjCDKfSML/eqyK5bpFXW7vVN+aUBdVy0BQPRdheb
X-Received: by 2002:a05:600c:a4f:b0:46f:b42e:e38f with SMTP id 5b1f17b1804b1-47754c451bcmr27965475e9.19.1762249088967;
        Tue, 04 Nov 2025 01:38:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG80tPo4mrfA3siN/+q+3zHsJR+5U2uhmtdOUUiclztFGU6pmZw6TuGG8AfTCenVCWwmNLdzA==
X-Received: by 2002:a05:600c:a4f:b0:46f:b42e:e38f with SMTP id 5b1f17b1804b1-47754c451bcmr27964725e9.19.1762249088492;
        Tue, 04 Nov 2025 01:38:08 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c383b75sm248333615e9.11.2025.11.04.01.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 01:38:07 -0800 (PST)
Message-ID: <ffe0715b-7a60-49a4-802a-a2bd75c7dac4@redhat.com>
Date: Tue, 4 Nov 2025 10:38:05 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 02/15] net: build socket infrastructure for
 QUIC protocol
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
 Benjamin Coddington <bcodding@redhat.com>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
 <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
[...]
> +static struct ctl_table quic_table[] = {
> +	{
> +		.procname	= "quic_mem",
> +		.data		= &sysctl_quic_mem,
> +		.maxlen		= sizeof(sysctl_quic_mem),
> +		.mode		= 0644,
> +		.proc_handler	= proc_doulongvec_minmax
> +	},
> +	{
> +		.procname	= "quic_rmem",
> +		.data		= &sysctl_quic_rmem,
> +		.maxlen		= sizeof(sysctl_quic_rmem),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{
> +		.procname	= "quic_wmem",
> +		.data		= &sysctl_quic_wmem,
> +		.maxlen		= sizeof(sysctl_quic_wmem),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{
> +		.procname	= "alpn_demux",
> +		.data		= &sysctl_quic_alpn_demux,
> +		.maxlen		= sizeof(sysctl_quic_alpn_demux),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_ONE,
> +	},

I'm sorry for not nothing this before, but please add a Documentation
entry for the above sysctl.

/P

