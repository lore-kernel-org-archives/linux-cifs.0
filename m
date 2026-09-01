Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2503CB57F
	for <linux-cifs@vger.kernel.org>; Tue,  1 Sep 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271567; cv=pass; b=nJQj33Z5wFh4ytxS4xzKuu/zsKb13JVK/LLBnyoRqgu4dlKPo++H0tMXZDBbM+8Cjp7pXaNEcCEIWFteJmyQ+aX3ooLkcRuiv+nOc72+lq3+xpA/oDgFX9/CKAFpE0ZqwQsQgYr92suZfV2d6/Jbnl27l2Eo40owtYWoFC2Cx/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271567; c=relaxed/simple;
	bh=4q6iuHKZ/050PNB6y0beFVr46SQsOfuApu0ccHHkTuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jfz6IN5cOsz9fwctxwBF29P65T1FbR3fHLCp8QK25v1gtYWLT4k5CDTWhKiVo7pEJoFrDAQCZEQJsn9okOTpbmQyPBlB/OAfDslUhJXfhLhnSEqV72NUeP9cKjED5Ck9A2uEf0st+7MAUH8mxyzsqlt3TFKj0cQMUbyXL9l7lwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=AJkfkWHF; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="AJkfkWHF"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-765c077b5c1so293940137.3
        for <linux-cifs@vger.kernel.org>; Tue, 01 Sep 2026 07:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788271564; cv=none;
        d=google.com; s=arc-20260327;
        b=f+bpIoMWbvQqq7J2zQdGKAYB5eICbyZ1sH0/z1MW6JA8V8ZxQ9uCYma+iCi+AplIvV
         ApgO7rAwQypnBTdAD226eLr74pKzRYFJ0xucXbkrbkqSKApvxznExR+krpBU/CWWhvwb
         KWawiJYgHLZD60YtK8Ug2shQYVd/AduPKh5ll4jpkWDg7vsPQPdpJk84r35O15suCiRR
         k71zCvj4nbt8bcciHzVwxlGp9PzOF0ilKWUQyYCMflyW5fSIpqzJh/DCAd8cY62ozT0R
         Kbio/2ZWHFr0qqFW42WXcGW4C/mGVuyYEaDnz/Bxzuu1xvH7nC8eI4aZvv96j963HkaJ
         Excw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hoBjSKSvVy1UEYsxbY/vRWyWBXYVCJ0DS+nH66eBBn4=;
        fh=pEmG/Miye1Q6ksurJOtOxtk1cYAFAh4dZAlvvin1JcU=;
        b=HkKADNsR+wo8uV5a2jeTmFAi5pbflXtEMKOBVrwnUxyk91C2QycpYbelpAsKcHiimz
         ZE0AHAUAuIhZt82a5vL0673jnOpKMkO7r6NN7mJVj36VuJ/kYZ1JYTGmIfntrfZmhOTp
         gqh2k/wn4vcnbpJji3UMW/Ms7tUqVjOQ9YIQ/Mg0dUeFA0ctvy1URLvCjvcjxwf9f/3s
         3KYEUszzNXyZhEt96VKeruF6YnwrQGxICMTLREnkINwxpzHetoKDImnCdppM8Nszatbf
         l/cusE8wY+jogkow14EEcCsvcMvhSTl36vAwJknEYvMyOYCOOBKe3Pn3YlzhIJdCOqBF
         fgmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1788271564; x=1788876364; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hoBjSKSvVy1UEYsxbY/vRWyWBXYVCJ0DS+nH66eBBn4=;
        b=AJkfkWHFgouF1QLMw4p9x41XAUYQKXUJL6PS9Mxs9uzWanuHafqwN+S4ZQloiAiPQA
         U7afngQ+LPJd9mTCzKCmJgPgrT5S8zX0OrV3IjJrpjqXCxW/z8sUe48A+YSeP9YNFjUu
         D3eZyurtL1w0/Hd4CSP1CBCWA4PpdWy5nVs+gp2z81M/QahGpoknp5tRrjabEtFesKci
         OfQ2VIhC2f3lKJXCwcaA/Ugo+VMNLOezXTCLEYhzs1eDjD+6MSPl2Sj9omXmQ1HIEjH1
         /c0h25tF65tNtMqo0nbC+dV/oE9xcGwR0NlElIRCWwvU73CnyyG+8FyAbyBN1+s1imAL
         kRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788271564; x=1788876364;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hoBjSKSvVy1UEYsxbY/vRWyWBXYVCJ0DS+nH66eBBn4=;
        b=SzhUJo2vkq0yEY9+4XX+XbFH+tqFStFp1SzZcA4GvdyXiYiise2Bnr6rtIz7hIBl0K
         CZMQl0hme5TNfx7mK+1vx8OZ/PHLPUaj/dlkaDqcE/OUOvzYFKOWNpeBV7PeNkyL6BOa
         fFRrYr3u0H2kvrbffe7kT/ij3b9KdJIH96JZubm/pfW+IBeQqlwC1lqqdNOrnrHx2AX1
         fwFp89zVNqusMvitGjTYs7XDcHnIl/+fKpaCuHa1YE78TiGeWikHuUvjoNP5gsJ6Tjp+
         kaLpNlWjUqNP65nrb8rbWZ+ibA4IKkNhnJy3sDR1wsz0wSNSL4MI1xFYw/VHR76ulr1I
         HYJw==
X-Forwarded-Encrypted: i=1; AHgh+RrHLC58rBpIZQh/V3GsM+oNYeKIYi9cwjSuAfGxRzqdfPV5JSAVVgeaqUjjMqttoXR8vyCOCHTTiroO@vger.kernel.org
X-Gm-Message-State: AFuF++mvt9Icv7lFyxpcQrS8KKSrwp6aVN+anlee0O+FyyeeK52Kzm9l
	BGNPOw/y/moVcORLzEQu/dkB7n6rXk39V/91WO4LUIOCPQ5I2LG4cci9VZdG7NwNZGGcIIn0hzw
	pgTNn4qXKPtLFYYT0H1iX1DWmbVCBig8HgWStc3zUugA=
X-Gm-Gg: AR+sD10f7aXN0BBuNSB2vzCsL493xs/Qwcg/YNVKi3P3IuuVuVWzq2sQs7xMa5Ob+9B
	01v8hlyCYZr9obCa9IC8eUsk0mfnDKO3Laeo48BQZ+ZSiWSuh+5pRBfpQPejnbXn2bKs3TGtlRI
	H47wpfVTMAt/ig/p7J/CenVzmh/uxP1gK3nU3g6SptRbP7S8ztzrxnjPDPMEeLwjs1m1YE9TmDK
	YKe75OzRPLWPkmsxceyDGiyUBNv8XvG4XGnjCWt10zY+39Lc5BdeJZs8gx/9bM8pesp6GdM3/bE
	IKqTJl5NbjlNGkAOXP0mwcwuh4MHZRDMR+zTGeGJVg==
X-Received: by 2002:a05:6102:418b:b0:778:721:53db with SMTP id
 ada2fe7eead31-7859426191emr10137186137.0.1788271564295; Tue, 01 Sep 2026
 07:06:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828150203.1419003-1-diego@bynar.io> <20260831125045.479576-1-diego@bynar.io>
 <0abfb2d2f99e54aceac4cea63947b65a@manguebit.org>
In-Reply-To: <0abfb2d2f99e54aceac4cea63947b65a@manguebit.org>
From: Diego Oliva <diego@bynar.io>
Date: Tue, 1 Sep 2026 15:05:52 +0100
X-Gm-Features: AcwNN1WU18vieHng4ytPQGO18uS5XIOEm5pHMhikRsNphUH1T23WWbWetU5SBiQ
Message-ID: <CAExJZk2r1wycZPrkvmFpUBM+3vyOBpj4+FAqs0uZ-ZUx5a_jcw@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()
To: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 11:15=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:

> Shouldn't you also validate the minimum response size so that you can
> safely dereference the above fields?  E.g.,
>
> if (rsp_iov.iov_len < tcon->ses->server->read_rsp_size) {
>         rc =3D smb_EIO(...);
>         *nbytes =3D 0;
> } else {
>         unsigned int data_length =3D le16_to_cpu(pSMBr->DataLengthHigh);
>         ...
> }

I've reproduced the scenario you referenced and confirmed an
additional check is needed.

> @data_length is now unsigned, so use '%u' instead.  Also, print __func__
> in cifs_dbg().

Will do.

Thanks for your time!
