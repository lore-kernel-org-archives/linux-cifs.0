Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B873BBFB1
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 20:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999514; cv=none; b=seGqJ652nViRRAjBRLeJZ29c2Sbwo77bWIi0nYuEf2MOcJdlWSqJCyWwksTJo9fNr1ep+cDaTrZ9prynQCcg3HqUBLykuzwlE5B4ZAzUYb1ju2ygpFxriA0k+w1oqJadu5OfKqHKpJ9GlUP6FBy1InGA0slZoatU8rzi2Esjw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999514; c=relaxed/simple;
	bh=mIUQ3UXgIQKzSLkCrkr3uy/3bn2erMtM8Ntw5Sxq3mY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=i6u7RzMqhKOE4q+ao+GgqfbwvoDvjCYbvcioUHBGag6AxnRKUkCaJjLI9HtpTwyxVuuG/rZ2zScz5XesUgEzmT5dw8fKn8eQl+IGnBwaYsC4UTSXrUaMEiIJCnbqaJzVaQbcb+EotLLcsrw87OQb1WRWXXoA+lkA77HPq6iOXbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XxOjdPEL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SjElBlbg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XxOjdPEL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SjElBlbg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786999508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dw8JGsbs4FSa5dEldFM9N96xFR4Uqf8/0f1/Ed51E8k=;
	b=XxOjdPELciCO2m5nZ+sTz91A/vWxR1xjnmKQxmwThguaygo2SXW1N8Dj1TdmEkWGp7s7N7
	Q7FD/IpYQRB07Vdyvl+Cu5dV+hgCbZEiwibYfLPLFfWhhOfNtQiKcdGO4hIMBogS9qU+m+
	CJjPtVqF/yuWcN8NVz1v6IxjR2K9jY0=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-Xgh5SiX4POWPvYwAopgThw-1; Mon, 17 Aug 2026 16:45:02 -0400
X-MC-Unique: Xgh5SiX4POWPvYwAopgThw-1
X-Mimecast-MFC-AGG-ID: Xgh5SiX4POWPvYwAopgThw_1786999501
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7f4026a59cbso1090593a34.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 13:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786999501; x=1787604301; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dw8JGsbs4FSa5dEldFM9N96xFR4Uqf8/0f1/Ed51E8k=;
        b=SjElBlbg9SqKNnCciTCjdHYqRilsfR3lDbyCY9Z1jzWypLSwGFFujrpLr3mYIxfAaJ
         reO5G0JegOHqtbfYRj0aPLUle3l9doHsfSwvaXzCydNiPPR8qTOvQbU3BLLwFIDqmwFm
         ZV4SJhSSB7Oy1dmuGzfQtqWmQoNsqjGKFlgU5V24mC6Odl4i4i65hA0Nl8ykx/9MXoQC
         a3ObPAdG47OsbxP/miJZ7vgkkvkVyekoIV9Hu5h+Bjg3sXU5SATbX48jK/rZf7FyoP5R
         zocFXQkeVSGvCIi2w2D/uoWgF3ZmUeu0blqDxM23x+i7PhDfK7e2E/+D3i9yhyysI+LJ
         N7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786999501; x=1787604301;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dw8JGsbs4FSa5dEldFM9N96xFR4Uqf8/0f1/Ed51E8k=;
        b=eTwsfsRmAIkuXkPY1Y/IaFhGLSubkPicduLKI4eEhtXrvoRlB+iUc9Fe3Q0ILzXvGe
         o/KFJHEXJYK8b6gPVJDt8X+pDcVYxA7ANooQnrfHHvToqeJeIez7griHG2aOBo+336d1
         47VlU3fv7FAEp6xDNVHqj1D8bFLtq9HEXo40ctyzZZkoNu+it+NpGVonqTJ5KtuIm/cV
         TpeU4mpeMDlwZRp0MwS2D8DGEe2TG0g6xD6oMJXaOmgUem0+5KWTKKdaAoGlEUQecvVw
         qFFKEcnLeZOhFecynKl9W27EeEegPsR1ZIv940oJVZlfnC9z+NqBlI7MndgFJJmMjGMy
         rGIw==
X-Gm-Message-State: AOJu0YzrYp/wdKTnMDMp4i+1o1vDyzLI2RG2yQyDSu+X4CZCuZ0Ep8GT
	QTaHfAKBY8RnKTf0UOv6Pi7gKImztNLnSrA3zspYeBS0blYwVjcQ0XWRthvObxu9rakP6lAeQCM
	p01xwgl68nw6nIVUIqU9YPvURkKU0ca0RXyhyYVW5skh9avzLt+HAK+QOCPPeIr8GWoqHosW87l
	PxoHKx+1AaQOFYE6yrIh6vQateydqoScUhnjjwEyZn0e2aKvQ=
X-Gm-Gg: AR+sD12vQOiyNRv/oCG7hNqF05NeA990eask2vhP4SxvC3sE/pDW99KfpEaQKONd3tE
	2S2STgDHs+doDsVat+PBpM5FNUTrJt9QOb92d4KtmaxZzBX/Dfk1SVNBuTmMVStf9OAdNf3u3/D
	qdl+cqymCcMWi1tWnon5JzxwX+Ztjnvk+SmzLAqd5MCMkT9K9XZDgigtGigj+17qtIu0fqyiWgf
	1I3igG4OVX1t0u/ggxyfZwKYfEPND6fwciPT9gb12k/JIwJVTGJLQ3bPfPzot47rsaRIJTbfPGT
	q29m6lsD6dom9NOd8+r0fiBpSnznYOKXjQWd8njlD4kUZg8cZ6NggxcJz+QInZbY91eWRr4hJWL
	cJcRZLzpO0DpP9NjHGc+kNWhCItbWsYAXfRAbHGHn
X-Received: by 2002:a05:6820:628:b0:6a1:211e:3c6c with SMTP id 006d021491bc7-6b11e1f7e54mr2867813eaf.18.1786999501503;
        Mon, 17 Aug 2026 13:45:01 -0700 (PDT)
X-Received: by 2002:a05:6820:628:b0:6a1:211e:3c6c with SMTP id 006d021491bc7-6b11e1f7e54mr2867760eaf.18.1786999500823;
        Mon, 17 Aug 2026 13:45:00 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1165cd4f0sm2615735eaf.4.2026.08.17.13.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 13:45:00 -0700 (PDT)
Message-ID: <e0a480cf-9518-485f-9d53-88f2a97e3dc5@redhat.com>
Date: Mon, 17 Aug 2026 15:44:59 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: reject lease breaks with reserved
 NewLeaseState bits set
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, stfrench@microsoft.com,
 Paulo Alcantara <pc@manguebit.org>
References: <20260817171634.212571-1-sorenson@redhat.com>
 <92add2b2-825a-4f1f-ab43-9105106daf74@redhat.com>
Content-Language: en-US
In-Reply-To: <92add2b2-825a-4f1f-ab43-9105106daf74@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I can't find anything in the specification to say what the client should 
do if it receives an invalid NewLeaseState.  Does that mean it's a 
condition we just don't worry about happening?  If so, I apologize for 
the noise on this one.

Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

