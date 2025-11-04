Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A100314B60
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 09:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250109; cv=none; b=L6siYZOmJI7DF7ANlEbKWsJd+odnA3ioQ8NGaokdWM+ux2TVjrxI5bHJ7D0jnUSy/5RZH92V1o/KTMgP1I2uikemIRGYALkrKxZ2BSeVKKE8Q7N/iD7R/OwL77HBTSWJpjMHwE1Lv/yz2H1OeOgtBG7GAkUe1ROfYWQkqKdh9y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250109; c=relaxed/simple;
	bh=QfSQ5cpqVePGEDeF20Ht8A/SzrjwwOLDakiJXtv47U0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dij49+He0QowV5qti8Of03rdKR0oMcJjQ/IvmiMS3HWfRJ2e1STT/NQDZ/iORT44RNUaHjCTwP61Ba0lECkomkLB82IvJ8sExDQVOMFwZwxjMppK8EsEOTiH+65bZKBC/GCV7qmGsrd8j0G90FlWISYzJC6PGHf5jnCKm+TL2Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQcTEQX8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pbc3IeyS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQcTEQX8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pbc3IeyS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762250107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VP7vTJNouoan64MmsnztfHu0gZfK42bIBxJmyPWNcv8=;
	b=IQcTEQX8PW7A2EKkkLPTeicvAX6AybTRM/I63+gtKb1r0BknExu5V0NDKBDFFKj/XVwDzm
	69tlH6mI7FQQRAeQt2LjomSn2O7GJ9W0sjRuhkXQ6wAjoplEHT7W1VtxzE330RnUkOMtl5
	GLPCQ/FP9t+SIvhCEcmbRDYcaktJRIU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-4-eddJtROPCSwxOu6-1_eA-1; Tue, 04 Nov 2025 04:55:05 -0500
X-MC-Unique: 4-eddJtROPCSwxOu6-1_eA-1
X-Mimecast-MFC-AGG-ID: 4-eddJtROPCSwxOu6-1_eA_1762250104
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47106a388cfso41627595e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 01:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762250104; x=1762854904; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VP7vTJNouoan64MmsnztfHu0gZfK42bIBxJmyPWNcv8=;
        b=pbc3IeySiscSqzEdQYt5Wpr2mSDzBCnlBaqG3f5dO9S+G3YnSb0Vbfgi8zeeAY8voQ
         9e0eKr96WW69lKxIxCiJwQ9WuBgNQKA/MTGl9Y+VPG4hM6N8gJCkGBQxsmv3c4hxhzZ4
         6VtWxtZuTk+jIGa6hUZiBjLqIR2wgR6WtCDblrdOYSauekxG62tukqEwDcEEtBbbJ486
         rhEuT9bkaGiWfZ8SUqsu59vlXaXtveMl4a/k64SI9AXJkeQ7dcwrGd7Oq6KTBzBJAfpd
         3kNjcuQuGJxrlQ9K6OdR44QtulcVK+Q84HDtNOyhWLi+LnRjneOys4iEbqflwYhcsjp+
         fv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762250104; x=1762854904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VP7vTJNouoan64MmsnztfHu0gZfK42bIBxJmyPWNcv8=;
        b=T5oLYU5N4i+GNGDvGwIXPGYVvukN1pZijDxKVaAO0SEvXuNWKhcQ3ocBApU1B3EtQw
         9zfeKVRyFwgsSH06/tBlw9VSEBhR1HxuPwOR0Q9buiHF9gZPGu7z1KMbiFdMBYRmoYbi
         ZZhctSZAHoQctZbc1lm/cppiIbzQiUolvRQHiCh9FGQPzZwzwqGiJlvts6kuGiQmK14X
         6w/6KHeYx3wOjGgD7i6mcW1pBumd3imRGmItDyAISaUBOW8JIVyzqG6PWCgOx+lwrj0G
         0MbmGP7NtIYuM9T/Voeg+oaD8TTEJ8FhjtDuAGLIyKxTPkEuBPqChh2mR6tvAAc7HGSY
         Opyw==
X-Forwarded-Encrypted: i=1; AJvYcCWQcLOZvSNApcA6EORx6UG9IbW26Pbie6+e6zDFisCkVJdNi9+Z+SAGLwAPZeUsHrPCRlFTq27iusRS@vger.kernel.org
X-Gm-Message-State: AOJu0YxVW6zmL6zPk7sJGdryDpapXrz6t49+k3J6w6sj/3B+IWFWJ28n
	axIcUe1F60USofUtqnzYaMWLRKlqStx48rbj/7/gGZjMEo7ptyarNd9fklCHwNSUyL+srdBDhUb
	B0et8y90scW2JlJDpDRaNnIieB2WWWRPMLFp7a9km/Rj1ro6kdqC9sqy0z96lGLA=
X-Gm-Gg: ASbGncuVj2WOxiaXVYInPEJIQGZuNjt1Vg3oGM1Ygm6gWhxeq3i9tNvxJS+/SQXurGq
	gB+mMrCFBPqrjQmcGTAteluLXXjE9HSjvtisrSW/GqARmLDycePSS+ol3EEBu+uldzlG38aQd1E
	qebWfBRKUNl5L103eFGlpAGZoH/sLz4D6FUF/ifFhqxvXO1AR4zD1kEaSofqwZ8FN4cJfissRNl
	qQYvJ1+jAkBlqL5iNEi/H1Smp0AA6rt7nEbELrR1qN3W33okA0oMAmQJWAH5e26psVPU3cXbHhE
	4uDC/NtegXNfz2jHU90QtFBv0/eVFnBXxJQW/CxWn6y3atoZifHy4oy0wiSZt224Sj5EovQKrVw
	lAdQB2FzbGvZt6ypnGOqMQIIFmPrU5PgLyGce6hFxmHt0
X-Received: by 2002:a05:600d:8394:b0:475:d944:2053 with SMTP id 5b1f17b1804b1-47730ef502bmr102634485e9.2.1762250104370;
        Tue, 04 Nov 2025 01:55:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6j3suXJsdE1W3rADP1TPpeXGC+84lF7jrCGSmoPCopSvWPQsrXeTI2soLtfPTzeuZHI21IQ==
X-Received: by 2002:a05:600d:8394:b0:475:d944:2053 with SMTP id 5b1f17b1804b1-47730ef502bmr102634195e9.2.1762250103915;
        Tue, 04 Nov 2025 01:55:03 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775598c2c9sm28545315e9.8.2025.11.04.01.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 01:55:03 -0800 (PST)
Message-ID: <1fcf4639-4c3e-4c07-9d01-0537cadcff42@redhat.com>
Date: Tue, 4 Nov 2025 10:55:01 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 03/15] quic: provide common utilities and data
 structures
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
 <66e48fe865ea67beb2a7f5cf084ea86d93592dff.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <66e48fe865ea67beb2a7f5cf084ea86d93592dff.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> This patch provides foundational data structures and utilities used
> throughout the QUIC stack.
> 
> It introduces packet header types, connection ID support, and address
> handling. Hash tables are added to manage socket lookup and connection
> ID mapping.
> 
> A flexible binary data type is provided, along with helpers for parsing,
> matching, and memory management. Helpers for encoding and decoding
> transport parameters and frames are also included.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

