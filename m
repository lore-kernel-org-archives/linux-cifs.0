Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1DE3E3151
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 07:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785915028; cv=pass; b=KUMHLK5RugUs1JywIdT+6UX6pZNbdW59jWORAGohySZ9S270A6s+OvRRjwdOMTDxXHEd4or6a9+8W/FOzxN1y7BcLXCV7KmM2o1F9Jg2Qltc5dwUY4A59OoasSHYs3MmzUl2KhW6G+SMPflrBMrBajPkHP+oPTRA0L+sg3fS20U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785915028; c=relaxed/simple;
	bh=X1ufRRgK2plwrPqPXEvcAY/uskA0Re2iFrcMKCYLpQc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Qhii7jXqzqcc9Sc1zmX8Rg6M/tuHyoGX9jgVRQRC6DqEE4mpfDHqyez0P/YFTGoO+/rHkM5QBy4UO/0fkw8DziGU3UrsjdEDek0ZEntPzTRgfFNDpTrXhmnOSxhZ0qP6UBzUehyacrPKkq3GObWUZQYQmncEGnKBQY5UegpDRa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gs9HIJjx; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gs9HIJjx"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cbb85186d43so331558a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 05 Aug 2026 00:30:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785915027; cv=none;
        d=google.com; s=arc-20260327;
        b=ad9I/RWHloedoBJKwlLvaad2dx8/C3nbZ8dl6d2Ds5E4gpvZbxFw3XFuKvwnUz09Wg
         WMdnYz7G2EQ5Iia09FDldImbYEGFeYo8gmxfmp854voVIeiv5DxflX8ORm26bsBgf5wM
         Iu5ucnBAh2EUBddhHjTUsU6BPr4LQU2mZJMFxA4cA0FuQ3Gm0LHDMRmY7QqrIwHf8PSr
         /cGLoMKJTzfdhyig6rV1yOsKpOOCQdrrVf7Y1DZF8uzf48UzOsg6Gr/LOs4snAaQiZNO
         EcOT+CAv8n/YmzeF8OffNiWtL57M1U7nYJnGzEzNDDhBtJWcbNaOz0nhWcb68foocV1T
         ze7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=X1ufRRgK2plwrPqPXEvcAY/uskA0Re2iFrcMKCYLpQc=;
        fh=KObKM3Q6Yr1/+wZIcjdUfDifrrk54PSVoAKl6qa1QA4=;
        b=Lb40r4biRV84/I0pRk6YYmduyKYfY2GG7bZknTJ+2WRVEA5u/yv57jI65U397nplcY
         NBN2uh8VU3QSEo0ZDyEIJTfAK6E7/3ay9MBdU0PNrThmx9cvH61UaOyWVoFkwBUzvdQa
         gZ7J0NJb2JFv9mcjDanwM7rqYAwtXoySv/eChToGwdXqZQU2go5w//oI6v3uBbYvGscy
         dKhvVEF03sNZtMK/6WMXZSDTtICx+BfqcDklIwueZ7uLNfkBV57QCd22JlI0StZFVtBw
         7G1DMoI6aGJR7cQm3Xv1Ilnv9ITHiWLGzBMMTefVZrxvOa/5A6YKGgvd9wjRXVME44D8
         9myQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785915027; x=1786519827; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X1ufRRgK2plwrPqPXEvcAY/uskA0Re2iFrcMKCYLpQc=;
        b=gs9HIJjx49LNVvF2WRLciCi3ir1QUI+/MFaWUGWs7/xXda/LaiZxwYHcL1aiZRR/zv
         wKvQQUcmjYmm0UV5vtTQ2knWZcDE5/EGT8t5bdwy4U/z11SA+PSEgNXgjoPapnxnwalo
         ghkd7uYCMvo+EoCkfjj343WGRaFjiu99y9kBiD0QQJ37E9usQjdr05DdOwYqpNz8rKXH
         Zp+gOfchcY6hR5aGDXsPJGFHIK6Sm1PfpAz1G5r+y9xRj9CTzQ9Xjz2UtPBTLCCQDD33
         uONzvHoviYptdHUaOjLIRtKvYPYcnlyQeTRX/kK9Xr0kH+gRwIjHy/BwdElWTWMXB1/v
         eoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785915027; x=1786519827;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=X1ufRRgK2plwrPqPXEvcAY/uskA0Re2iFrcMKCYLpQc=;
        b=eU1gqir7nU07/m2M4iNu8KX3BSWzjQMO9yLtqrU6c8mbb3P6DWtlX17hvlu3wc9cNo
         xTV85HyYXP/aHIUdY4hniQOeAS6M8flBuQsILI9vV/fOA/4tHWc/DRDN/oaHPOs9zMss
         EAMzxkxFOPzZRjhiy4yK3O7pL/jwo5fxkKuT1TeHvyvy57mVhc+Yie1ooEraGmqHdzIS
         R1sJKqwfVoBYp43aRbuOC1eJ2TVbMkWtIsB7WRIjRqt04I00yXgrfW9IvGLwgSg/f/10
         MyyC81JKzWbCFJb5Pc2/1G69F8iuEl2QCqKIL4VK2Df1QoNOk5FHWZ1F0SfoB6KXnPHQ
         AYaA==
X-Gm-Message-State: AOJu0YwC9SfmkX44QMJUETPFRSkoQb7V2lK2/o58XnznhHN0Rqf8pF3X
	u7/S1sv7j/BLcCJc7Z7aQzv1tA3VrZt7M+nAYpdYWGYP/UH+Y6UYFxcpsUlbE8SG68DWgyBhQB/
	BSMtVkp2cSMfCT3DdKyv7ChB3W8OLmMM=
X-Gm-Gg: AR+sD11038aOlRQWuCyQw7W55Vp6dEl/zfCXzCFM9stPyRXggZwDc10gt5Y+tiXG1g9
	8yu2/OgELFWJ74qjXlLSlyFgP2tz31b4S2u0EQxiFMe3I2R0k6Sfa+RocEnVMqvcdYq71bdtmij
	LCdjyTcmmS9kg/tBwCfnLJ2K8qEYux/jVENk67/DabZwSkWoGfaI/ekkBjaRpK9nGHB+W27Zxa0
	Q8/3Zy150jVMlgCbMKZBe9NV19Fzie4mYAZyQvkDf1U7Hnf/C+sltC3g+R6OlBEbPz3u3oWCN3i
	7LbqwOwTqz6e5SarhMM851Dc1OfQDF/+FHo4BPx8J43qjfzPq9/mxaBKAffAIGbBM7nOoFmByK4
	o+vS9p30iN7M5
X-Received: by 2002:a05:6a21:6e43:b0:3c3:7762:5d5f with SMTP id
 adf61e73a8af0-3cb85e6afe9mr5657770637.19.1785915026644; Wed, 05 Aug 2026
 00:30:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: khj <hj351016@gmail.com>
Date: Wed, 5 Aug 2026 16:30:15 +0900
X-Gm-Features: AUfX_myZYgcXotlNwWzZL7SG3HE2E5KqufWMNFUWpkpKnuNAXuy8klWq_isVk18
Message-ID: <CAGr5VtPLAy_N0N4kE5TDndMr3zYukVXDHD49AfToGoa-vMk24A@mail.gmail.com>
Subject: CVE-2025-38728: Request to add Bugzilla 218602 as a reference
To: CVE Request <CVE-Request@mitre.org>, cve@kernel.org
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Linux Kernel CVE Team,

I would like to request a reference update for CVE-2025-38728.

I am not requesting a new CVE ID, reassignment, or reporter
attribution. I am only requesting that the following public Linux
Kernel Bugzilla report be added to the References section of the CVE
record:

https://bugzilla.kernel.org/show_bug.cgi?id=218602

Bugzilla 218602 was reported on March 15, 2024. It describes the
missing bounds validation in parse_server_interfaces(), specifically
that the server-controlled Next value can exceed bytes_left before the
pointer is advanced and the value is subtracted.

The fix associated with CVE-2025-38728 adds the corresponding
validation that rejects a Next value larger than bytes_left:

https://git.kernel.org/stable/c/7d34ec36abb84fdfb6632a0f2cbda90379ae21fc

Could you please review whether Bugzilla 218602 can be added as a
reference to CVE-2025-38728?

Thank you. Regards
