Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5699A23D7CE
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 02:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787710735; cv=none; b=OQZC1W5+AE2jGS64zhYcsgmCYQZ1xvoCKwGn5Gvne9e3Q42FzFt9LCqiu3o1r0EqGjPZEtIR3tJ0bLUe2UJYzC4qKHJumkjJY9RpsC0Y6+p0G7vRINRyUUMFUbTuy9FDjNS4dnnZ54BERF2+cduHxaFdINrjLwkxzBLe2cAuwAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787710735; c=relaxed/simple;
	bh=j+CrrqJ5U9rhRh4V+bshURtBPDKSxCOAt7CPGjL1VFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sELPg1gmfMdjURie0WG4yy3TOnvf+IU/MLSvD6tT0CVmW10tKz71+6R3k/RLcGKTDAuRCA7nwGtX2g4Oj2Mdjp7nT1aiRlv6KatltWaUDq0Tf1ErKJ5yfRQwYv46VeFKRBOCAJb5epiPs4DOoG0HInF7woQvs8h8mA6i5kdGgJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFzwH7+i; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DpSTRdzg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFzwH7+i";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DpSTRdzg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787710732;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TNHL0tgt1PFAyzqNno/DSDpq06p1lgEtXfZS7qyuVY8=;
	b=ZFzwH7+i5YmL7HdvnxiwmG0lKCaja4Sp/a2Bbf0LGiiMSSFQbgm/kNwR9uT+oZE6SeGHDp
	nma9Q8+MfVl/TBr4rKII56dHNZfdoIE9zKmQp904xw8AVpbal737I5vOKQN905/ti7ZKjM
	6yt6d7cicPOGWSQAz+oM3Tvf7G5lhM0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-zlCv1ZF-NQqgoyxMFkuWSg-1; Tue, 25 Aug 2026 22:18:51 -0400
X-MC-Unique: zlCv1ZF-NQqgoyxMFkuWSg-1
X-Mimecast-MFC-AGG-ID: zlCv1ZF-NQqgoyxMFkuWSg_1787710730
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93494527488so62867185a.3
        for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 19:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787710730; x=1788315530; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TNHL0tgt1PFAyzqNno/DSDpq06p1lgEtXfZS7qyuVY8=;
        b=DpSTRdzgE6dvtTIcMqiJLmBpJ2OFdLzCR58z2RbwlGh0KpqzxUOhM3KW1SdavGuRdz
         VdKInp4Aopcyd/lAKj0Y2MHI9jeQOyZi9OZpGBQUnckZCQWtug5Z1ZLItAoV00n9LhZ9
         kdYyGb8XZS7IkS/1SJ8d2uF9LRudFQgwB8/0DxBfB/JQ43XxqwWzwuUlsLG+L79JqHDr
         xMIO9gOjHLoYN0xW4H4ChP2n6jS/SUbNT9gcTaefB5Uod/KD9WTomS7tQ858k8j2Tdxl
         Vu7AFJujApv5tg1FFhD9+ZxHlKdyJqFoMiRB+CWViUhUkOpzC+etAHfH4K89W6y8ZvuN
         lvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787710730; x=1788315530;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TNHL0tgt1PFAyzqNno/DSDpq06p1lgEtXfZS7qyuVY8=;
        b=RwQUgDxkyaEHp0PClXSTwS/PIfcyTukWgds3JxLeGfiVXhJHM7wjOU0QyuspKJkbuH
         y5cnhqsHr2EqJnT2LotoglJrrYElVZB26I2m8BUKQJ6tiOWGJmNT1XRgbWtH9OqYuGUW
         slC0xT7/PLeq+Wyz9jYazkgznF86BOY+swE0sXzZwqCuyvIKgKkvoi9TVtaewl2XCGVh
         YyuqI0jyWSFZ9U3aM1VG7VTYuqvWUPmkbeEUxxrI6CK3Cs3zHh5gHJA0ABlGxTyGzO9l
         /GHWwUAjTE+9qNmBoik/7Anerl3Ju6BFO56Yijj/Zk6v63NYrwL6sNIJ3S+QFfw+sUX2
         Lpxw==
X-Gm-Message-State: AFuF++kDYUkPMKg1ovAIGicRti73MvYMh4p7s3LJJ5H5AIbbmXRwJoJp
	clqnle/NbJZFvkWMFDfpk/Vq72nwBrX0IWcuYTOxO4DM8ABn8NucQls3P415w8uAbI81lfYpTFV
	pugTRVgD1op/9msH+/P954JccXWIHnWRwazj7GhAeZxjn/eOcY8YImcMVWrcoAws=
X-Gm-Gg: AR+sD13WD7W6Kk6+jd4p326p38A4iLFwond/CPjrDsBEwd+5w2feSxT/Vj5G/5PpURA
	Sn2nlb8AqjYUVWGePGa/1MQmBV/7f7Ru3iHHfEYkDmZ2I8Jd7g7o1UzrscnB28FDfADrQzxGvc9
	FL59neEwq8v6QMTZIi9RcsCziTgjhFvUQnNwrT2M+zb/CZVBQGT4fiC9U4JTTcDD/YQTTw6PqVE
	IVt3kdcfduEEX1mrk+n3mBAzWTTGIf1u2/Wdf0qwrUNLgj/ZfROAWsed5YW4syNEJ00jffC0LLf
	Bp+GIFHel77xGo+PTLHtZn0AzLfMiWXpOZ9IjzhNZItgMVAObXkDG8AJz+Ksi2M6ufTBtx1fPdl
	4Lk/pZgaQPPo8Qtm1cpxPFVuDQHYVOLATU5xrQt75
X-Received: by 2002:a05:620a:468c:b0:92e:5cfd:154e with SMTP id af79cd13be357-937803bf227mr287431185a.14.1787710730455;
        Tue, 25 Aug 2026 19:18:50 -0700 (PDT)
X-Received: by 2002:a05:620a:468c:b0:92e:5cfd:154e with SMTP id af79cd13be357-937803bf227mr287428785a.14.1787710730029;
        Tue, 25 Aug 2026 19:18:50 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e36879asm112213985a.17.2026.08.25.19.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 19:18:49 -0700 (PDT)
Message-ID: <7cf2a25c-e28a-4962-b0a6-b9578128adad@redhat.com>
Date: Tue, 25 Aug 2026 21:18:47 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH 00/11] smb: client: fix OOB reads and UAFs in SMB2/3
 receive paths
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, linkinjeon@kernel.org,
 yunseong.kim@ericsson.com
References: <20260825235434.765005-1-yunseong.kim@est.tech>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260825235434.765005-1-yunseong.kim@est.tech>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/25/26 6:54 PM, Yunseong Kim wrote:
> Hi Frank,
>
> Thank you, for your security works!
>
> On Sun, 23 Aug 2026 13:57:56 -0500 Frank Sorenson <sorenson@redhat.com> wrote:
...
> Just a small question: I wasn't able to verify the call stack from this
> patch series alone. Is there a reproducible test case or script that triggers
> the issue?
Not for most of them, although I'm sure I could come up with something.
> As a security researcher, I'd also like to independently verify the findings
> and cross-check the behavior on my side. Any reproducer or additional details
> would be greatly appreciated.
>
> The reason I'm asking is that I've been working on CI coverage for SMB. I hope
> we can integrate tests for this issue as well, so that similar regressions can
> be detected and prevented in the future.

I ran a static analysis tool on fs/smb/client looking for potential 
bounds issues, had Claude filter out false positives, then started 
looking at the findings for what could be fixed.

The bounds checker is at https://github.com/fsorenson/kernel_tools

# python3 bounds_checker/cli.py --kernel-source /home/src/linux 
--source-dir fs/smb/client

(add --llm to run the static analysis findings through an llm, but it'll 
really chew up your usage...  should work with Gemini & Claude, which 
it'll figure out from environment variables GOOGLE_CLOUD_PROJECT (Gemini 
via Vertex AI), GEMINI_API_KEY, ANTHROPIC_VERTEX_PROJECT_ID, 
ANTHROPIC_API_KEY)


Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

