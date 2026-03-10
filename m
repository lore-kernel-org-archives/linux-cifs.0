Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F153B0AC3
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773148929; cv=none; b=XGZyz3zgf5vHSCBbtLdZQoVuzDELqk/29Oxeo8Bt6ptVNe26Q6VuONR0xNtkt/lIozpMfwReD+40qDj3kNLHOuqCInSxcLSx9Jo2IjEGJB9cDv+MM/LGppjIlkAcewGhDpshuZieOfC6fURJv7uPYwg7CkkcCuIm4INk8EA7r3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773148929; c=relaxed/simple;
	bh=7C48eJwQxF2SZSyojjO4eehKdtPdDBqSboD/LkVXOwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0S/mMXc1coMhSS+u0hnx/1c/hoLxne/tu9Q+NbGD+CFyPJNewwOq+lEYkB6nr3nAk1vwUyz0uNYpJ/+790LMWu5mUEdzMEesSvLZ0iZpAVtBCImEUL3CwHY1KUV2unbKIr6tYZfTHeIIvDGnmz6RHZd7+lTkXBtt09VJP9jzOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADQQpd+b; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DLhvlaPb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADQQpd+b";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLhvlaPb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773148926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	b=ADQQpd+bpcMvyiI6BuK6I/AtlFPVjRaT1jbvm8x0bcg2sn4Mv+l/q+wGsOaa7zGZavpvJL
	HOw6n0NTrJxN8BVrJlzy+3Oyq/AicE10gafpjzfnHFVMImjvlOy3qRSEO7jpexZVWETsUQ
	RoRPrXnJkd5ZbUZ0X+x9wM3CIJYSD9c=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-uS8Sr600P0W-lsNncP9eFA-1; Tue, 10 Mar 2026 09:22:05 -0400
X-MC-Unique: uS8Sr600P0W-lsNncP9eFA-1
X-Mimecast-MFC-AGG-ID: uS8Sr600P0W-lsNncP9eFA_1773148925
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd849cd562so1322192085a.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 06:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773148925; x=1773753725; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
        b=DLhvlaPbwaSFQKg/FmxemLJJZifDd7cIIhpxvIrZaWROKjgqKnQK81zS2r/WSu9mvZ
         1x4TVLhhO06glvOYJXTBYTQHe1C/lCEECiyKmpprEGkSpnbhT/+Xy+wfN5x6paEUKxsd
         eleVUcWebznHZRscghpqRSurxi7A6fJyr8+SC/oFm4tth2mVEOc19JKZit9S00HY03E/
         XNzQnAGkguTRFL3rrkTJWt1Ev4Xq7DVoDTHr6r9kNjeVPxV8v11X5FGr4E58NddnvLYv
         QUA4HTbgZjVMx4thX/P6FGMyY+HUc/G2+EnczacjtLqtmfpojjqt59bZxWNPmXy2pn5x
         ulpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773148925; x=1773753725;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
        b=p6M6vb5dK3UnpPEDRVSx3sUvVYiz6SKVf4I7yr0Wj2jC+a5FSx63DNyK9gYcRrY2Zg
         i++nBwFtYrEbZw4eJkMO7nQuUboeP8ZcZlONfv7vXfJvIcqzfVUntVtY9+/3Z3HHLDK2
         xlubzZ4scbypHv0qDU+c+gEujt53f2MJPEy6KaCaTJR1ctcTNJ6dMMwEdLhV5CKzT6N9
         A8mW5QfzpepMaT1PBtFDU31r+Q6Yr62dPtuPMjiH9ufYTD/cnr/FPakrEGU8f7VasfsV
         ZUKNOhY8oEiqxW2Ryz3yLxB1rJAQW9D7/mJ5V31MdQMOJ3cqJEyn14drTTyy5iGGURp8
         NZTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVre0x38RODOg+La3oyQLzEtYno5JUMd1+lveTDa2yX9v0EXWi0LyeUafjgyC0g7GHvaavFt5RNMVM9@vger.kernel.org
X-Gm-Message-State: AOJu0YzpzME01LalQBQwuGbG85ixmstvn5TkhZmJTene3ecw1d5/Ovcd
	yVIsAVdG4vvUAEXZ5MYAEVd5gjR6rTM2FhgIxVJ4RIehbyFMEae2mRfKUZhcCGQE2oc41H91l9n
	kNPiWNdUw3wLpxRYWZzRTnCTXrDMAw2Xnq4MpvX1T5KgHa6EJ8kX8tMs8qAN3KT4=
X-Gm-Gg: ATEYQzwFF4LS66dOS/FU06oPk9jNQfwBZBHCk/b4xrbJ6zOZX8O8YyPVV0keBBvqMUv
	HPLW/NJ+vCYPJcCdvQ7YUIQ9Iuq1OMSlkgFrL1Nu9UspOBKEh+RlFYYyoane1BI40qd69YhgLYP
	zMqLQEZJx16c+dmU8WKKc4ri3Wz7C4/kYjbgd8Q9Cqdsj2+HnNB9IbCxnAiBoM/fNw6WnsGknKd
	6GQa18S7UFU2ZDaI7HrRR2sD2kPyDexbBYpP4B+8//qeQPImABZbyDz5Z+8JUahJbkFwDFGsQ29
	gR8RNTDNMWx//s9Mxc4SmXv+iNgBYKkK0MR8wBVHJIdeGXirgIYF6/H70XCpPUMYlNdDEQE3Cm2
	dKutfXd35SGYD2JR09/0YPOs4np++8je8GkMXjeNnBDPVlAZ9QCWLu1l6
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830786085a.45.1773148924709;
        Tue, 10 Mar 2026 06:22:04 -0700 (PDT)
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830766185a.45.1773148922638;
        Tue, 10 Mar 2026 06:22:02 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8576db0esm474754485a.47.2026.03.10.06.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 06:22:01 -0700 (PDT)
Date: Tue, 10 Mar 2026 09:21:58 -0400
From: Brian Masney <bmasney@redhat.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abAa9vQg4BSxl1BJ@redhat.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
User-Agent: Mutt/2.2.14 (2025-02-20)

On Tue, Mar 10, 2026 at 12:49:22PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Semantich change: Previously the code only printed the warning on error,

Semantic ...

> but not when the pointer was NULL. Now the warning is printed in both
> cases!
> 
> Change found with coccinelle.
> 
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

With the minor typo addressed:

Reviewed-by: Brian Masney <bmasney@redhat.com>

