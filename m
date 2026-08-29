Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C83175A74
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788022366; cv=none; b=He+RNsBl5tvgoWZpMNF6TRmkMdLPLGFqJURG2ORyzwNJBzkqKFMv6EloweXsCfc0tzn7PluxQ0g44YjRq7rcLPE7oxealX1XKnfzN10jVgD+b5zR0B+hS2pajbnyBEYmRjg0W0IAT1gWs0IVD7FcMHyaBEP9R/pwbHXCwmO+/hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788022366; c=relaxed/simple;
	bh=1yKwZ6ZvkRR6i5NPWjGVEMUG4997wUO12yeLzomVEHk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KkvU+AQMpxuo7wKs+mOX4ud2GiI3nsWfopOaxPmybQI5RqIlcl9mHXxFC1M581Zy8OVQe2Qoz+p+pGluj/1YXjWrC50tdHhTHka5JThhxq0q62w/5t0S/UPH5i2yqI8N92jLIVxuQ+Q0JJwrsqqGquTdvrHzaz7qOD+8Z+z0Oto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jAZ4iFM9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fldFLEwk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jAZ4iFM9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fldFLEwk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788022364;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OjinuWNCoCWPerwCVDP7RZ6stRlkZpmuayoAvTI4RDI=;
	b=jAZ4iFM9F0KCDckPZr8uhnxXbnyqXE+qo7KSMdXPa08l0/I4JrPWPSmryOG4gdYDRNAsrv
	U8uK1zQdcVAhCLy+RBvp5INuO4z3fumXS4lzXZJbXUbpxv8cD9JanYU3X4sAI8ACMhmJ6f
	CrQWa4PrK8WsNXJHJs1R1+pGkhw+bUs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-MHyqvo1nOcKNKrwCJwrFfA-1; Sat, 29 Aug 2026 12:52:42 -0400
X-MC-Unique: MHyqvo1nOcKNKrwCJwrFfA-1
X-Mimecast-MFC-AGG-ID: MHyqvo1nOcKNKrwCJwrFfA_1788022362
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-936708f129aso233636185a.0
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 09:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788022362; x=1788627162; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OjinuWNCoCWPerwCVDP7RZ6stRlkZpmuayoAvTI4RDI=;
        b=fldFLEwkCxG6KPtP6zSm+FXKGM50ZOQYCvWIPiV1r0G/E6CiQKSKzQ47gblwah5W5i
         9PaA2Z19w+cJoJMP5jC7D1GVHVI6+vBARZThHXOu/hV8byhapZvyrVXkIZ2P7wZwhBAN
         whICqOb9x8ou9t8CD3q9B0guaoY0cY391hIGs2Bw24DcwCFWlezqrLM5qDSt+VFJRceb
         YBObaEN40U3Oz+jrGIYLo3P83X/Y4KeObHs7cSlAIt9RBANU08AVuJj9NCx8Ug8ESW3c
         Xa1ZpBVdPnvu6DDIpbm5w89RgGY97tF8r1zeKfLBQWgxqj3Q0lSTdoyv1NsnQYJnCxCj
         881g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788022362; x=1788627162;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OjinuWNCoCWPerwCVDP7RZ6stRlkZpmuayoAvTI4RDI=;
        b=Tk51CJGvExwwRsF4Z6u/s29cZAk7uq2QratG8XsjLN1LIiRBwRDSVRJuN+GNcuq+ub
         xI1Ah3cY89XRLSpZrCivx7/ek2YSQX7KObcRfaoJTHAazGKger4knj20q0pYrqCIjevZ
         7rPLmBAeq2JFnHq/mRisF2Xad6ustQTDWgE3h5qbuOWYCLi9nYEx5WwMzAS8H1iP95l4
         PqMqFZaXCfgFSc+SIHfJZrDJsNEvO+jgcbsBWt1h4czuoznE7EI2UJmNV25evEC1E3GY
         CDXHanguS9qvpq/AbfTxpOMZnFtQ0zgwYwQth6CD1ZtUX3U5DMiEVl5xNPDaj9gV6FsC
         xrEg==
X-Gm-Message-State: AFuF++mofiqGUAfUKHSUiENIAo9Yx1DY5zq5j9by5CyxZpAOug+Rv4v/
	Grf/4sdgTHFftjkglmYgM9dhSuMzp1VJre6PQpiQ2wg6JIlRZmJ1NLhR4zZU+VHAzgjLwy9UAva
	nXyOMgNS3IA8eDI32GPGkIlzqouiFoYbRX5+fEUFAL9w+bK5wpiY+lgbMPNm3XkU=
X-Gm-Gg: AR+sD11EoAXlJ23ZLktqD+QRgyjlNbRng6O5Y9jC4TyYSQ8nzQlcp3bhotl+jK0hk1e
	KwAkcVQ3vd+t+vMTeFMT+eyN4wBFxcihr5E89049VDLU/jQQdEezMIahMG9NENk8tWmoKe9+RmZ
	JMpDmCw/bOdUCRaNZgCYwHPDEQ8V54LZ1zBYEwT56TDFwx8sDVpPxQeth2TyOVn65fyBPDx/sqt
	Zn3H+m1+8gvbUUtQdAsMjezeafU9dyPQoYHtv0sOPlX7TXS0hXwv9vpaYDG9W3ySE9SVJFoT+kK
	BH1h1SMKLYq5SR+39w9I95Z/QT6v2Vfq3FAhq4VX0IioMWk06EtW67OQgajyZoaOyaGUJ+TAsP7
	ON56rA1FziF06Jqzr+LcNrkzZaq40BwyPNKncCuJq
X-Received: by 2002:a05:620a:6c0d:b0:938:fd60:4f9 with SMTP id af79cd13be357-939138ffdc0mr1669555185a.27.1788022362061;
        Sat, 29 Aug 2026 09:52:42 -0700 (PDT)
X-Received: by 2002:a05:620a:6c0d:b0:938:fd60:4f9 with SMTP id af79cd13be357-939138ffdc0mr1669550885a.27.1788022361613;
        Sat, 29 Aug 2026 09:52:41 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939173db029sm393233285a.35.2026.08.29.09.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2026 09:52:41 -0700 (PDT)
Message-ID: <9b064466-4403-4ced-b6f9-7f92829f3414@redhat.com>
Date: Sat, 29 Aug 2026 11:52:38 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v3 11/11] smb: client: fix NameOffset and Next field
 validation in smb2_parse_contexts()
From: Frank Sorenson <sorenson@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
References: <20260826153147.4112943-1-sorenson@redhat.com>
 <20260826153147.4112943-12-sorenson@redhat.com>
 <CAKYAXd8_jvTz6DX-1OjkCu1UAe7qKKHKOyW7-yOqrqVtxC6dPQ@mail.gmail.com>
 <666879b8-5117-4c41-ab1d-e50637e68a5d@redhat.com>
Content-Language: en-US
In-Reply-To: <666879b8-5117-4c41-ab1d-e50637e68a5d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/29/26 11:26 AM, Frank Sorenson wrote:
>
> On 8/29/26 9:01 AM, Namjae Jeon wrote:
>>>                  case 16:
>>> -                       if (posix && !memcmp(name, 
>>> smb3_create_tag_posix, 16))
>>> +                       if (dlen && posix && !memcmp(name, 
>>> smb3_create_tag_posix, 16))
>> Could we check that dlen is large enough for the fixed POSIX fields
>> before calling parse_posix_ctxt()? It reads 12 bytes even when
>> DataLength is smaller. 


make that 24 bytes for smb2 and 50 bytes for smb3


so if we test inside the version-specific function, can we simply return 
0 if the DataLength is not large enough:


smb2_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
{
     struct create_lease *lc = (struct create_lease *)buf;

     *epoch = 0;
     if (le32_to_cpu(lc->ccontext.DataLength) < 24)
         return 0;


-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

