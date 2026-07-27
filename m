Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7C825CC79
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785177656; cv=none; b=ke/Q0piUHqvvbWgR7dzyIOovJBei13/zXTbvoiMd7tH7aQ+1GyGKeno4lzxPXhbeuFRctKyU27n+BenF2KTQhBKqWOCGdT87BFBOgO8aOtxMrvtcGTZQzBWAibGy5TPWCv6T/yEmFFqWK4yuRBfoHwGq9nRBdDvbr4/lYJ2YCog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785177656; c=relaxed/simple;
	bh=gN2n6HVonTVVY5RUxGyroVEfngLQON4eG6AmGqWU64k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tYmTAnK2huIn1/Gpq6dr7QdULxoaSz0PQvOx+aTCoYCVXhDdJnnG+7Z2Zmka+GqRnQQ4G8uRvd4eHadoPPpq5xqrzZm1J5G1RUynv8EiW+0qaMRnzBcOS/kH4szRsetwua3pSnX6cpIwLfrmeWHJzX4nH+AfkGat1rlgNxU7Pls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G3EISYi3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ShtInepE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3EISYi3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShtInepE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785177653;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5htpfKAJ0tiaPHVobFw+9Qbwgd0UVHrLBU/rphDqng0=;
	b=G3EISYi3UYtZEWCE2FjDC0n0WFhze1Q0F+pIExc5hX2fZoRxL2X44REzVOjck2t0T/Crsx
	JU9wXQeAOYiuAv2blNTeydNqkktmbVwN09RYqqcLR3xZXWyH8rS/DmGnFNAeifcyQ3oYU6
	mNFy5aIeCSHheCvscmyYHGWDKxoLjMA=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-yEJ2L5iEMP2oV2f2RSkAVA-1; Mon, 27 Jul 2026 14:40:51 -0400
X-MC-Unique: yEJ2L5iEMP2oV2f2RSkAVA-1
X-Mimecast-MFC-AGG-ID: yEJ2L5iEMP2oV2f2RSkAVA_1785177651
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6aae0178901so2058221eaf.3
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 11:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785177651; x=1785782451; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5htpfKAJ0tiaPHVobFw+9Qbwgd0UVHrLBU/rphDqng0=;
        b=ShtInepEH+7SrGNErP0l+JX/hzjP3n5RFKyvTC9eucaf5Q4/HW85HyVYP4IIfk5BTy
         sK2hA1+bHmNJ+utsl2NHZa372QKnMwUt+yU4USlCE5oa5XCnyC1IWp+IPWSPi6JhO9n4
         fjN64/YJnkt3TtAKcgxdVFku/gIvjju/eJes6Dp8r8IsY0GgCm1jIDO2LzInfm5Y7eiE
         wqDN1MuZbB/oc5L2ekAkopA5bpYKsxZdG/8j/s+2sc7n3zmglt1bxcEXUp0xtasVBaRd
         5QpCa9dZE/ox4WM5r4rRGb6cFbmfS3ZOrrKLEfTgX/RBzx2nGAFPvO8Hty8XgpLbNBCz
         OAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785177651; x=1785782451;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5htpfKAJ0tiaPHVobFw+9Qbwgd0UVHrLBU/rphDqng0=;
        b=acg0sKvdRdfXSeRd01KPtYpaw5H6Ahr2sCi8gy1JkhvFxRqe4RB/MiHqV5XJXft9vU
         LB7KcJU4dvi8rhWUfPaBAKiHa0xdbxJl9wKgqho+9Z8+t6nUz3IhABovvO5tvhW6IOVd
         5NTQD0Dfrmk8RGQUXIFZ+Aw1e1iOudEtH6hulEwTeEd1wOMoQHcARSVUDoDIeaxSF2R8
         MAR7TwAh7TRY+EQL3ub4JClZk9lxfCYKVkDAwYcPOFtz/u0gox1LBDpAL/s4HRXQU5UT
         XKvbBXJl+xLdYf+0Bh7CJj/ViCJ4TbE6XI1RhSS+dq/Z2FplFf+8wy+iDYFJrp5I/gv7
         3GEQ==
X-Forwarded-Encrypted: i=1; AHgh+RqOseWirbOxFuT7kEMgMTkxgGTbOG3MTxwKJUeXN0Xzclw2uf6tuWYsPUDvkKvtF04JT/auxydGszIm@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5tP52ErCzzDPoFYMbm/SCOyc4hJxFKmHIpDUvDeAfkSYjOKAa
	lgnjb9rdDVNv9qlcet7w/2rYvbHYTF12AZr318RXxsl8BPkFfnDIH/1mjEtij+TV2hRJlVgzV04
	hhrCbiuYqFumzWhb9PowTFty7usIubx0dzKSFl7UhAYUAoVIjbGh1ih7cM77ikdo=
X-Gm-Gg: AR+sD12vp2SifCp7XZoBu8XE0OO83pCz9MgNDRw7ey+TwZrqebqoGtASC4ar0E7ciK+
	19X/8HkkIlUU4THOfYbQXwGaK0XU0Ue9i8FufvZEjvNPjWgOr9w2W8SWCbJMhAAEOm3LQTgPhtZ
	gkVJCyERopCETLE0kslvlnxWmSyXL5jWp6BziFzAGYPf9bwP5qMH7b5yNVSzqbbmvApGeRgki7u
	Jc5ZUEKEf4ml/qFjRaxGuwdDIsrnqg4sP4meLaxaQ7fBoJWcqL/a7QIjCJTmZxQNqZEkh4tTYct
	FH93mp0F7xPUtVwAwa7l0eHNuIvhM2Ttq+0l0AHxh0mkvKysR+4sW0jZk8nTfarWE3zwvx4qfdA
	MCYRc+TV21a0vF9TaIZWff+nfBvdP/4kjDzsKjCJ1
X-Received: by 2002:a05:6820:5050:b0:6a3:7822:9396 with SMTP id 006d021491bc7-6ac90e92b9bmr436386eaf.58.1785177650950;
        Mon, 27 Jul 2026 11:40:50 -0700 (PDT)
X-Received: by 2002:a05:6820:5050:b0:6a3:7822:9396 with SMTP id 006d021491bc7-6ac90e92b9bmr436374eaf.58.1785177650578;
        Mon, 27 Jul 2026 11:40:50 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-457674879f7sm16838311fac.13.2026.07.27.11.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 11:40:50 -0700 (PDT)
Message-ID: <0cf6583f-7115-4771-9b18-62f842f53f50@redhat.com>
Date: Mon, 27 Jul 2026 13:40:48 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH net-next] net: dns_resolver: allow shorter names in
 dns_query()
To: Paulo Alcantara <pc@manguebit.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
 linux-cifs@vger.kernel.org, Pierguido Lambri <plambri@redhat.com>
References: <20260722-net-dns_resolver-v1-1-c3385898ccf9@manguebit.org>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260722-net-dns_resolver-v1-1-c3385898ccf9@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/22/26 4:28 PM, Paulo Alcantara wrote:
> Customer reported a problem with mounting CIFS shares where the server
> hostname was 2 chars long.  Turned out that the CIFS client wasn't
> able to resolve NetBIOS names shorter than 3 chars.
>
> Fix this by allowing a minimum of one character per hostname in
> dns_query().
>
> Reproducer with samba server:
>
>    # 'ab' and 'srv' hotnames resolve to same ip address
>    $ ssh srv ln -s 'msdfs:\\ab\\share' /home/shares/dfs/link1
>    $ mount.cifs //srv/dfs/link1 /mnt -o ... [EINVAL]
>
> Reported-by: Pierguido Lambri <plambri@redhat.com>
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
>   		return -EINVAL;

Acked-by: Frank Sorenson <sorenson@redhat.com>


