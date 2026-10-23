Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792746295;
	b=K4kwqoN4+o8nOcG1g49Y8L1/aWZsT32+s8cSQOCQfL9W/xx2vq1+5bDDm/rvgSWVRd8B
	 wCHBisXr5O3QgV9jykA/6nww8R0n72dPyqKaiSVKPCVtBW3DdQp3MWLxq/oeePfi2a4e1
	 EM2ft5/jeQ3WnxCy3UFqD7KbPou8zCw/5vLvSWBk8UpP2VLILM1Bs8Term+buTxRWgzCm
	 Uo4uSuFqnFgExMMVv1beoCa4VaiVKIZJ6fAp1sNtPX9GWArVa+Y8UiejSwzhgb1PdnuJ1
	 hM22OdIe/gVYJatsaBjUtTZRgCuQF57WKnA+jWGwIdj8kh2jdu/bAWx63D0y+zKvVYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792746295;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=faIsz4RJtbl9Wyh1UWy+8yul7B/MZVQyWI/kJ9Az+XE=;
	b=3qbc53IARHrGD/0A0fmCwYlJW+9qGu2VeGauALAxbINLtDNFtRALc3BpaMSUyoObYmS7
	 x0lQ7sMoDXjoSD2CdF+/QpPNX1mJsdWyET7IjuXZrT3Kw5mSCT4NWlSYed6CUHtlW8JwE
	 PRMG336x4XsVLKEN2nGEKzaIfOIvpY1L4z/vIkBmf5CnQNFZN0pIsh6mFrBfNnghPgiCT
	 8CdQkkGz01FdiweEOfOIbTRM5Qf5aooOQ3uJaGjYxs42Y99Eqpf3CjvfOWC2B9kKS0f3Q
	 qviJhIXOJP74Yg9AzFtpfBG8jdvqwcw+dnmwnqqVzgRj7PV5O5yFKbnN4PZztHE+ItQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=rb+5ENTQ;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B05606A31B;
	Fri, 23 Oct 2026 09:04:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5B05606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=rb+5ENTQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=faIsz4RJtbl9Wyh1UWy+8yul7B/MZVQyWI/kJ9Az+XE=; b=rb+5ENTQFnC5+mUdi0N+CIp4gK
	QtESP0dLl1DwzG7oeWsEYHalIQmRm5Bm2vxTzYAt0x1bv39G2JF1cNxDIdb3Uc+FNQm3mQrFzPdt0
	u2fX8KomsBuIgLgpKwBF3hGx1r1MkgjezqpjxlOuYyjrBD/G2w1ae8vJaTtHd3fpoiE2hNdGW29jI
	nsNI0p8yiw4eTmz3PaIrbsrkN5PQ41LFISQ5pi+6GXWhQuoBQ/eoAa/zNuhX0NVHAXTmdO0ghAPQT
	MDp/dLqznJfzE53iz42UCaZ/qy4jlt4nud6l9ujioGGUm9DrmuBsTdrwxLh9ZkWpVx0nqcuZp9f4K
	1CHmDeNhrPbXlFdRrU22lQEN+N72VAAjcfUea+ttP0V3U75SQQ51o5QIDnt4XX8L7OfG+L8CseKqw
	QfrpCGRC2gSKDORZSiweSAQ9TjrZOd9xIOG7NuG5mw6Ff1hZ0vs/1lIo3sftI1E+qzJiQqxdwT435
	yJr+3Z5h1b5w+KUPdlm9u6xl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xKBCg-00000004f3P-2Pj4;
	Fri, 23 Oct 2026 09:04:46 +0000
Message-ID: <dec5c659-a8bd-43db-a5b4-55d78fa37db0@samba.org>
Date: Fri, 23 Oct 2026 11:04:45 +0200
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ZDI-CAN-33549: New Vulnerability Report
To: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>,
 "security@kernel.org" <security@kernel.org>
Cc: "open list:SMBDIRECT (RDMA Stream Transport with Read/Writ..."
 <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 "moderated list:SMBDIRECT (RDMA Stream Transport with Read/Writ..."
 <samba-technical@lists.samba.org>, open list <linux-kernel@vger.kernel.org>,
 Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>
References: <BYAPR01MB3830472B5702C089B0BBB77D80662@BYAPR01MB3830.prod.exchangelabs.com>
 <bd43bd47-688e-45ba-9fd3-e32da2bb691a@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <bd43bd47-688e-45ba-9fd3-e32da2bb691a@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.10.26 um 00:16 schrieb Stefan Metzmacher via samba-technical:
> Hi HYEONTAE LEE,
> 
> would you be able to test if this is reproducable on this branch:
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.5/smbdirect
> git clone -b for-7.5/smbdirect  https://git.samba.org/metze/linux/wip.git for-7.5-smbdirect
> 
> I guess it's already fixed with that.
> 
> Thanks!
> metze
> 
> Am 21.10.26 um 23:16 schrieb zdi-disclosures@trendmicro.com:
>> ZDI-CAN-33549: Linux Kernel KSMBD SMB Direct Integer Underflow Remote Code Execution Vulnerability
>>
>> -- CVSS -----------------------------------------
>>
>> 9.0: AV:N/AC:H/PR:N/UI:N/S:C/C:H/I:H/A:H
>>
>> -- ABSTRACT -------------------------------------
>>
>> Trend Micro's Zero Day Initiative has identified a vulnerability affecting the following products:
>> Linux - Kernel KSMBD
>>
>> -- VULNERABILITY DETAILS ------------------------
>> * Version Tested:7.3-rc3
>> * Platform Tested:debian trixie
>>
>> ---
>>
>> ### Analysis
>>
>> integer underflow in smbdirect_connection_rdma_xmit()
>> The reproduce kernel built with CONFIG_SMB_SERVER_SMBDIRECT=y + CONFIG_RDMA_RXE=y
>> Here is the target requirement
>> 1) RDMA device
>> 2) writable share
>> 3) smb direct (ubuntu only)
>>
>> ~~~C++
>> int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
>>                    void *buf, size_t buf_len,
>>                    struct smbdirect_buffer_descriptor_v1 *desc,
>>                    size_t desc_len,
>>                    bool is_read)
>> {
>> ...
>>     for (i = 0; i < desc_len / sizeof(*desc); i++) {
>>         if (!buf_len)
>>             break;
>>
>>         desc_buf_len = le32_to_cpu(desc[i].length);
>>         if (!desc_buf_len)
>>             return -EINVAL;
>>
>>         if (desc_buf_len > buf_len) {
>>             desc_buf_len = buf_len;
>>             desc[i].length = cpu_to_le32(desc_buf_len);
>>             buf_len = 0;                                            // (1)
>>         }
>>
>>         credits_needed += smbdirect_connection_calc_rw_credits(sc,
>>                                        desc_buf,
>>                                        desc_buf_len);
>>         desc_buf += desc_buf_len;
>>         buf_len -= desc_buf_len;                                    // (2) integer underflow, and leads to heap overflow within rxe_mr_copy()
>>         desc_num++;
>>     }

As far as I can see the problem is solved in by patches,
but we should have a simple fix first.

I think removing ' buf_len = 0;' should be enough for a quick fix,
then 'buf_len -= desc_buf_len;' will result in buf_len == 0 and the next
iteration will break with if (!buf_len).

Namjae, do you agree? Can you create such a quick fix?

Thanks!
metze
