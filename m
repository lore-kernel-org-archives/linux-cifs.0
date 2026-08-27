Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE6C3B2FDB
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787838329; cv=none; b=sVzhQBvvCJt0rK7WxQReOTaVy8/PByZKdyMOhB094d5XLSIHjWhBNJKEA6vwMvzpBwuuR28JlBLrr/KEHhC0tFq/KhTCM21+zXkYh8VoDw+09BFT1f19p3uxkB/OIZ4FzkMdMvfkKIVD5uajPssz6E6iYbMwY95b2lWDY9b0lQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787838329; c=relaxed/simple;
	bh=+dI2iwCHyEnM/wK0AhPsWh7w7YUkwpqVsloo4ng0xAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oxu7kwzRsp26qFN89PfhENBCF+YweJ6saxv5PfaQPy2XHPgtIuBqVNmBXa911EC9tKDr1kMprgQtZ4S3wN5lauiNDUF0a3LHWKjwjRifxVTERyo0lavVW7Bc1uIPKRuc50Y1YkUDLn9kzvIoKhsT8fehSMHgMeJk9dZ0mecg5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jQ0AvFM8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qPaH5D5E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jQ0AvFM8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qPaH5D5E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787838320;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2Pe2JsSBSamTxW+jC0IgTUMPFV5cHIlg1QJSOQvf+0=;
	b=jQ0AvFM8gbHJ/Q9SMSfgaNa9scVdpPx0hTFUol0m5jSsQ/LNSzYxPRgRhYnPL0wbhm+qtN
	i7YdddGLzB8v7D8w0L4IZZ9R9BeHavlHgSWmsStenQ4atLWFio7QWjMX6zlRaEgURZ16NT
	ilFJ9FL9tkilH1sd085KQc6AaT2dck8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-kV2587IkP6WwntUcrzffQw-1; Thu, 27 Aug 2026 09:45:18 -0400
X-MC-Unique: kV2587IkP6WwntUcrzffQw-1
X-Mimecast-MFC-AGG-ID: kV2587IkP6WwntUcrzffQw_1787838318
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fb2a46cb5so4978561cf.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 06:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787838318; x=1788443118; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f2Pe2JsSBSamTxW+jC0IgTUMPFV5cHIlg1QJSOQvf+0=;
        b=qPaH5D5EOlXQnsjT6OHquhXSrYxfVI35qr0pZeaOzH2v9QxVOm0AgD8t6ZHaqJ0xxD
         Ypjb0kdNOR9rcafCnzxInE4+ZTujycE675YGBUTmykbcrG9YZcQlexkkEfqjJtJr33p2
         F+dkaX2/NbeDHp/mO/BOaYDEBZnMVV8MxjMLJo2yJwEfItsYVrpv/pofV47idFpOYuxk
         o3lkYfrjt2YWXeUjcn3Pn7LLjG3N+aXdmre1FUIff2tIyNOpfAqABFHD2bCL5CJA589o
         upmhuCWiGouhHtTxmEkMabTOs6yFYvS/v97Q8dqpt+iO3sAX0q02CcPOR5iqKdt3hr4l
         8/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787838318; x=1788443118;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f2Pe2JsSBSamTxW+jC0IgTUMPFV5cHIlg1QJSOQvf+0=;
        b=DAlPsz3Hwm+CpjLCxtyExG22LYk/EI8nHmjV7WNgpyQHFBMN49Wd3XoAGmHNH3+3sI
         qfz84kV8qC55+BmjIMJeKqGto/7kntsPJ7F+bGmSmAFE4O2RvMAPZV2PjyvRfRoebUCd
         yA2LIlQ5jVpAeOHbC7vIoIMLZiacP6wUooWgK08fsyEVZsFqUzUTjfFR3v8/9lXDDviv
         T25B6kMnLdSw8QJNsNdgWod6d8Ym8ADb8dAlvbXLA7+Cvo0QCRrPTdASiA8HaalkjTTT
         MHUGidcuGpLEnc+dg/fZg1b8SvQNTK8GIaQdoly3kp1aV12+eROtvy0AaCYydNVyjsaZ
         Qy7w==
X-Forwarded-Encrypted: i=1; AHgh+Rr2YYUtXl+nrQJEwgbgaUfJhfb3N6kv78h3qdvMog40pSqMfTilYArerA/0SIDtN8T0AouziZbFGSxC@vger.kernel.org
X-Gm-Message-State: AFuF++m55ZBYUVDBadOr/TS2QOZ8Hw0GLpQPfgn+viZQJphtxQmHS++J
	H91C42qdd7MsBLMd8rOQk8tsPPZnUHItBh7JyaaUt7l7ZxaDzgZ6wWegKBDEJpNpsoqSAFb//SJ
	zXiSVWS4KvAFmWAQEuaqW0IZ2U8ScFRWsgm/3qMMtlk/GiHoQjmNVHLIjsODpzagLWyvn8EA=
X-Gm-Gg: AR+sD12P1nwmg21SXQ1xMJwnxTQyT8zl1m3IdgEHRwaffONlZT296tqw464YDrHFS4p
	PeDxUXKRbPDDfHClKkzrgNKcrvCXMF974hYki3sL8crTN5xIfjinfeAbIxLp3CAoQqTHc9ktNKf
	K2zLr7ZrpWYvRP61+E1DopP21qYnne5Hbv6+/Opit5GLtc02JvpPdglaZLtNFVRAZIdiuQ3JC18
	1RVtbEeHZJcShbhWpl3nUR2R2qkshEEjtFt0lBE7AASY4dcIJezRFuF11/Wuur8xhPzIAJBAPP8
	y2Srs5xjGYz1YfhA5vq4eJltjPPvymngVihmrIxwU2RDASYtaVGrFTEsiPlnEUA4x8uJXKjXeEx
	U7JvE7Qic0aEil5zYl0jzHKmtPo0koPXJ68pZqIB3
X-Received: by 2002:ac8:7fc1:0:b0:52f:b627:6091 with SMTP id d75a77b69052e-52fb62761bcmr13206201cf.5.1787838317873;
        Thu, 27 Aug 2026 06:45:17 -0700 (PDT)
X-Received: by 2002:ac8:7fc1:0:b0:52f:b627:6091 with SMTP id d75a77b69052e-52fb62761bcmr13205291cf.5.1787838317300;
        Thu, 27 Aug 2026 06:45:17 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e4270a950sm36897281cf.15.2026.08.27.06.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 06:45:16 -0700 (PDT)
Message-ID: <8b7e30ff-fbd9-499e-b371-725c7b85a189@redhat.com>
Date: Thu, 27 Aug 2026 08:45:15 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH] smb: client: tighten validate_t2() offset bounds against
 actual buffer size
To: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
References: <20260825030948.3577275-1-sorenson@redhat.com>
 <f67877e37eeede299fbbe86914cd58f2@manguebit.org>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <f67877e37eeede299fbbe86914cd58f2@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/26 6:03 PM, Paulo Alcantara wrote:
> Besides all these LLM-generated messages and comments, would you have a
> reproducer or a real use case that would require such changes?

I just want to apologize for going so far overboard.  I identified a
potential type of issue, and then kept expanding the scope without
finding a concrete problem or reproducer.  That's a definite
overcorrection; I tried to fix things that have no known impact in
practice ('malicious SMB1 server' is a pretty weak threat).

And as you noted, I relied too heavily on AI assistance; that's on
me.  I'll be more careful about both the scope of what I do and how
I get there.

I'll obviously withdraw this

Frank
-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

