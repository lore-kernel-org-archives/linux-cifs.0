Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A9633936A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 06:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787034476; cv=none; b=A5Bqro/QQsjlAsVXd4+0pcyDCWzMQUXHK46B27WLBOM2FiubMmNrejegI2+hj7Pr9S1bTnXkvUVjwWDSrwhWetEz20EIrxv7X72lF07O01lX8jPE5fTUBOkEGUcFSG7N8iQji8z+y4EkIUUxiiCbeWbP5vRuOkIDfeBR0Q3Dymw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787034476; c=relaxed/simple;
	bh=XY+l5Qqhwnfhk+WflcqD231yF7jpJ414W7aQUz6JDG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJS8pLm32ukuUnc09nptv5o9+qClXa221h3ukKnjN0dq0cWqy3R2uBLZDVupeFyJ3i6PcCsTVbcqJV5//dRpTo6n8Er4aRyjjpIbDfjvR0UcIiUZIKgvQK515yjyR7rLNih3L7Jr/VDbFvEOWCvPvi6eQ5cwWbMvjCOzeWb3oXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zakgyrrg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FTCczSam; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zakgyrrg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTCczSam"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787034474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/q8Pe1QuqFrKisLTTAMQw0LcTpFJzgKv7Tx/tDvibGY=;
	b=ZakgyrrgZ5EFsVfoKKakENwTjewWBFGCo2c3qGWMKM1RHEcZGPI61BTz34K6COBUxWxa5g
	NR/XPz3Z1F/ciYIRdgV6P3YHa2u3F9KtQBR/7UnZLJHZE6UTK4wdDq6gnwEeFJ4ubjq6C4
	aI3eaJYKYnqxV1cmJale1PSAxQYqVso=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-1P9myfxWP1iSWvGiJ-xvLA-1; Tue, 18 Aug 2026 02:27:47 -0400
X-MC-Unique: 1P9myfxWP1iSWvGiJ-xvLA-1
X-Mimecast-MFC-AGG-ID: 1P9myfxWP1iSWvGiJ-xvLA_1787034466
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955ce558d8so45291895e9.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 23:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787034466; x=1787639266; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/q8Pe1QuqFrKisLTTAMQw0LcTpFJzgKv7Tx/tDvibGY=;
        b=FTCczSamhy0HWT4tWz6e8QBjvoH5b4bG7O+vtttz+o6tlFYQy0Z5shFgxqKqw04Nlh
         vLz9DCqeFYy7hsknL5nNfbUA4EZDez3WTRnOjNKl/KCmKALUXHopzohi9G6C/zuQ7Uzx
         J9yKcD0STi+giXFzf22XQgT/2dIMU3Wbv9ZdvHK/TylnO5ty8fOe9xFrSAn9es+m7ub/
         seJIQfwybgync4q/Ek1jjP0Q4Tz+Q3/Mmto5JBFwZB1E+Oq8Ro3BSCdFqZKm0V3OhUZG
         z39dJZ/EiJAg/w6O356nd0eC3BgA5nAqqnRRnVCpOeQEv8K8dJOigPqs1VzS2X1pHm/i
         PRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787034466; x=1787639266;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/q8Pe1QuqFrKisLTTAMQw0LcTpFJzgKv7Tx/tDvibGY=;
        b=mcrA9YZhhiRLa3jXfT0pyrFcaxE5vLqu9FlIToRROXQ5JhdP9jzLp+s+D32zLmfoXF
         BVaAow5cz8OVWukWkFCII/fI25tIc351S6HpXCqERQ5jppUSMfjvVxNaujN3mYPp14yC
         wirPq0VuV9+TlaQPRkimvbv86DfTlOfUXOfPaSuJvLhXRO7wNVGs+Y/S0RC7fbO4rjaa
         gHQ8Mhh3CUt7KrTGuEq7fk5fsg2w53svsIikNnJtivvYYZvHS6jzngyIj2vatgaq1Dod
         jFvMIiGgUOUtu9C986aQibWJNAtVpifZtzFW2x5rqedAd0HbQiqyCw9unWv1P055FiWy
         huvw==
X-Forwarded-Encrypted: i=1; AHgh+RohWW8S56pPQoMdNApI4BHzb6RPiv76NbDZ8HLCmAa6OBqstKdfZ1uKZjk3n1ek5Os3yiobzButdP7/@vger.kernel.org
X-Gm-Message-State: AOJu0YwbONldO30haP8Onub4r7+ehTCyVS1kv1CbCeXLED/4+vhh2ki3
	HkWItwv4jpxqlVTXRjoD/3F7IyKVH1o+NSowBjbByPpj/wU1wcrTZwy7mVn+NcKCxzlgVHhY2DU
	pm5XQUEssOI1Lo1YqKz1iJrvimkd0SD3W1LR1NOPV3ZU+xNHM6CF6zL6HT2Upj54=
X-Gm-Gg: AR+sD13fi9LS5wkyGwN9zqnxcUyqarcZGziw2ph1Rr5JoKqZxNl2PR1vgfnEs5GZE3L
	ILfdhuCmv5iCj+zh0gQ/6407QUyCrtq0ux/96GBSE2sU22OzfpW65dvsLMYjhpVUcCkV3U8AgDy
	BdNRWIChsxm2mCetvj75V7/9F9CwG23SVic2WZU8yEdd3KmXe982N6K4C3MKhA3wb8k8ghE5/SC
	W/XCFwD6+UuWiHIhBSr4HiOsN4BOgHjXjQa+CBYJ2/PKje3spKqvr2C19yn68Mabn2KjlESfoEF
	B/g1Srlu40vlrSohKnRmgmU4+7ALQUaT0D0YjcJdHarZPO80zmwbFK7zqXwB3v3+r5O6l5H3ths
	g9uVHBZglDmrHD9gwSW2d8/mhEbgmqANoc06/
X-Received: by 2002:a05:600c:840f:b0:499:a5fc:207e with SMTP id 5b1f17b1804b1-499a5fc2164mr4341255e9.8.1787034466165;
        Mon, 17 Aug 2026 23:27:46 -0700 (PDT)
X-Received: by 2002:a05:600c:840f:b0:499:a5fc:207e with SMTP id 5b1f17b1804b1-499a5fc2164mr4340885e9.8.1787034465876;
        Mon, 17 Aug 2026 23:27:45 -0700 (PDT)
Received: from ?IPV6:2a01:599:b20:fbe:bc54:ff69:ca5:383c? ([2a01:599:b20:fbe:bc54:ff69:ca5:383c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999610ed6dsm276002265e9.8.2026.08.17.23.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 23:27:45 -0700 (PDT)
Message-ID: <621b2dd4-fd61-4af8-b855-be6c82065acd@redhat.com>
Date: Tue, 18 Aug 2026 08:27:44 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] smb: client: Clear sensitive stack data in
 smb2transport.c
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260812130152.2861834-1-thuth@redhat.com>
 <20260812130152.2861834-2-thuth@redhat.com>
 <CAKYAXd-0RLf6uYZO+yFnF8+gvDX_2AyMMPF75B8XcKL_qSaKzg@mail.gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CAKYAXd-0RLf6uYZO+yFnF8+gvDX_2AyMMPF75B8XcKL_qSaKzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/08/2026 07.47, Namjae Jeon wrote:
>>   struct derivation {
>> @@ -482,6 +485,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>>          memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>>
>>          rc = aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
>> +       memzero_explicit(key, sizeof(key));
> cmac_key is not zeroized, and cmac_ctx  is not zeroized on error paths
> in smb3_calc_signature(). Please zeroize both on all exit paths,
> taking care not to clear an uninitialized context.
  Hi!

The cmac_key and cmac_ctx have just been handled via the new __cleanup() 
functions, that's why I did not add these to this patch here. The patch has 
just been merged:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2b240733f27c8dd7e192f36540a10dcb88339222

   Thomas

