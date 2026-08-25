Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB1811CA9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 02:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787624494; cv=none; b=U41Il/FRN5/C4h251mYFehmaKNg/CCBLM90C41K4dXY88Ry/R2YX5eUVhi0NIYE6OGAY6I+jyCBOJxmGLeeXmWR5ZhzVMed/SdKBzcE0ieFT0AUkqXxL3h1fdelmRnNh3P9iQHa312gNZJHhmNDBZWKn7JXNqqyFiQFJjZoyM2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787624494; c=relaxed/simple;
	bh=mlFMa7vglT7lqDi3QdqbpINNRAXMVZR/az7R8YzdFJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I+VBbYs4S+OniJbG1dtHm+kI4h3bVJufzGh9aijKtjC4aAvmOfGX3yoPpGwjt7WzSyhSdtCPslULy2aOg7gHOjXjF16VIs/+3wxFQxt6KRyXObL4W7fBm23X8AbeOZc/hojRblWsbXyKWG/+8L7hrZIqCOHveNkiYhzP3oXegAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SXcwdqfE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qc9ueYe3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SXcwdqfE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qc9ueYe3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787624491;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vMXu7YvAgSkgB3IplsVQSj0uA2SLhYSZAaqiMsWSuXw=;
	b=SXcwdqfEcIoOHihNFSrUK5szY+GCqpjqjXhq8GIHHa0YHh/iHAxe/2g3UCYUjrETJL7w8/
	944iHKGgwLS1P26xpRGFSqnnpmnIxsTlvw/GYV7CFniJ7OVldjLoioHpHielC0/jxsBAz2
	qI31KmIwUlcBNe6QpPw0oHwPEKLqbyM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-ekXf3hzEND2mP-sIK2hikw-1; Mon, 24 Aug 2026 22:21:30 -0400
X-MC-Unique: ekXf3hzEND2mP-sIK2hikw-1
X-Mimecast-MFC-AGG-ID: ekXf3hzEND2mP-sIK2hikw_1787624489
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbedb8673ceso3791385a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 19:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787624489; x=1788229289; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vMXu7YvAgSkgB3IplsVQSj0uA2SLhYSZAaqiMsWSuXw=;
        b=qc9ueYe3nH48clbQPy1pnaQjeungJSouOKGLZed/kw6dJbSz81yK1M0j/H7LFDLgU0
         f187pp1bOBs3cS0ZYqZvaHtDwwseMj9HhTA8OzZ1VxKXgiE/MDnh9HNhiFHhsfQkgq06
         q8kno2Qg0XXLr89ldk8HESkW7qmQokSsBS1acH0RyWKsNyo8hyiHKqWDRM1sElCR8436
         aBSiJ8ZiWXMme/w9g/GUgNXAUkFSkKUISShvt+EOAwlDjSgx61LkohUPB6wYCYTLUO/X
         1yF/Da3Luu8h1VmulU9qjXJx/dpzAnOrruzzAtFtCaj/O00ceN+wxoy0XPr5K7XugUCe
         ONKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787624489; x=1788229289;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vMXu7YvAgSkgB3IplsVQSj0uA2SLhYSZAaqiMsWSuXw=;
        b=LePNJBK2ZvynJSDjhB4gLfneXEZ7ZIaDdrQHn/rSMJR+5V4X/l8ys2+Q1n2VvyKU1q
         BOna1n4xezWF0lho2sg+OjqdWcq5nTaFLOO7dlZ/oyFtFQxdS70PgdORSQ/H6k7gYMBH
         lDL73TY3NKml3GEHUSw5/v1eE7dWZ+3NptbyVduLCuwKDalCz5PL29SzLh2/U3V0vve0
         Ri6+R2Q6CJD7+2n40+YA1Qo1A8fnTn0mNxyj6yUIx/Dt/ZJCIpppW3TAIRlIln40j60K
         CGUUkSK0PUSlamo+b+2mSg4rcZ/hHCoPK+JLfUj4KGHcpou95udy0tiwQWph/WsYKO9X
         A3cg==
X-Gm-Message-State: AFuF++k6WJ+tyBvs1b8py/U9D3qoJl/UoKgHXzSGG7YWR189jxFcD1N5
	2ByOSx0KUppPrP7N5CpAnI5rIGNsPB+TJWZdT/jG7XvkFbT7XCAismVVxfO0CAlJJ1lMzoA1Mu9
	7h6M+H9wpGmj/zFnLbE/u7rFyv1vjxIPy1f4cFSfZo9kng2AdYxKELe3rM2184J4=
X-Gm-Gg: AR+sD119GwMXYCuwTOSSPWRRjUOarm1uUvDv93ZoHHiCNNc3aFzmmr9Z01ZhAGDae8L
	7G+07RX+C9JIY15ny1v5JwiNVwEYHuXEPs0wNwdQVlvGeXEXwxch2sZLQb+vhW10HGe9/sUW7km
	SGGSyheo/pHNjQkIiFyHAkH7k7mtFAnJaMOxrjyKensFhRBolkAForYZ+caiGTjaZMw3Ig3QcMp
	qAFDFLrkgYTjh6krXiPKBAPSNoYAwe5WHsGkGouFD9pkVOnw0grFa/s2jytIRhTDMZpm3gaMAtR
	P9BmSPncsrTcVt2VjySW4A6fFbwGuQAeYBrW71+nznc6RhEx5hVhD1z0hzfPorCuGwFasY7Hhfr
	1RyQnui6HUw0TVwYJDS7fTfay5o/6/fOpa1epsqSs
X-Received: by 2002:a05:6a21:918a:b0:3cb:e8b4:f03b with SMTP id adf61e73a8af0-3cd912a03a2mr6511706637.17.1787624489085;
        Mon, 24 Aug 2026 19:21:29 -0700 (PDT)
X-Received: by 2002:a05:6a21:918a:b0:3cb:e8b4:f03b with SMTP id adf61e73a8af0-3cd912a03a2mr6511601637.17.1787624488597;
        Mon, 24 Aug 2026 19:21:28 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f90cb8e3sm45551831eec.12.2026.08.24.19.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2026 19:21:28 -0700 (PDT)
Message-ID: <bbbe50db-52d6-4ba6-a349-f84f67956e1e@redhat.com>
Date: Mon, 24 Aug 2026 21:21:21 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH] smb: client: fix OOB pointer arithmetic in
 cifs_to_posix_acl()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, brauner@kernel.org,
 stable@vger.kernel.org
References: <20260824231030.3502884-1-sorenson@redhat.com>
 <CAKYAXd_E2ZGzXzRJWCu4knD50LjXrC+dn4JPr8jxNMi5daWLCg@mail.gmail.com>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd_E2ZGzXzRJWCu4knD50LjXrC+dn4JPr8jxNMi5daWLCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/24/26 7:59 PM, Namjae Jeon wrote:
> On Tue, Aug 25, 2026 at 8:10 AM Frank Sorenson <sorenson@redhat.com> wrote:
>> In the ACL_TYPE_DEFAULT branch, cifs_to_posix_acl() forms a pointer
>> from the server-supplied access_entry_count before the size check that
>> bounds it:
> There seems to be still oob issue in this function although this patch
> is applied.
> Should we also validate acl header before accessing ->version ?
>
> +        if (size_of_data_area < sizeof(*cifs_acl))
> +              return -EINVAL;
>
>          if (le16_to_cpu(cifs_acl->version) != CIFS_ACL_VERSION)
>                  return -EOPNOTSUPP;

Ah, you are correct.  I'll respin with all the necessary validation.


Frank

>>          pACE = &cifs_acl->ace_array[count];     /* count = access_entry_count */
>>          count = le16_to_cpu(cifs_acl->default_entry_count);
>>          size += sizeof(struct cifs_posix_ace) * count;
>>          if (size_of_data_area < size)           /* too late */
>>                  return -EINVAL;
>>
>> The pointer arithmetic is undefined behaviour before any bounds check.
>>
>> Add an access-ACE size check before the pointer computation, matching
>> the existing guard in the ACL_TYPE_ACCESS path.

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

