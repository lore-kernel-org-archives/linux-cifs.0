Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32103932C0
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 06:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527876; cv=none; b=NMxm63R5UmOW+/Rg3j6E75s+0TwTMrMF3J3KHWpeQxUnrYdJfLQZZGSFRYa8Y6eEeiIsoqikndRtbNUmeOv+paZLWN2RlB7R3qYjxtK4kxD9xRqOA5aWYvwNT/HG6EXYNIK0PX8YI67ZwiSFkbhwTXia8tlL4jffLhj2lqYfTVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527876; c=relaxed/simple;
	bh=VECZP0x0u6ze34Adru2zWW4JDOQqLFGvY+uakuUjKH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVPBnPKRZy95h3IyhiZtVWnTdEbX5z1Co6JWyIRXIWNP8UqZLnLJJBIMolXvITPo6y+/uoEKejWyGfpHu2ymeiYOBobjygKJKBO5aoyI3FCJ6OB7VIbiuLc1RhGK41mHRDl3MxYcKbrbJn+KpVLyCspV7fgcB+jDduqBDTFub4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=p6lALpVn; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="p6lALpVn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1784527856; bh=VECZP0x0u6ze34Adru2zWW4JDOQqLFGvY+uakuUjKH4=;
	h=From:Message-ID:From;
	b=p6lALpVnxzp96AG04FIlnb8y2D9wgPwzk88UJ42HU4+gHqKKk0dNNqAilTRxRWopM
	 G60qJYsk7bMPjDAAQ5dM8bD7y0EH1u9afi1Gtzh57Mqe3eACBLIoY2V9JbKXtjkWjO
	 TXIxlNhQH+H2QPwR74uI3QPdqXnatvUZ73rsmUMA=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id D9AACC09C4;
	Mon, 20 Jul 2026 08:10:56 +0200 (CEST)
Date: Mon, 20 Jul 2026 08:10:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Subject: Re: [BUG 1/3] smb: client: SMB2/3 signature failures are logged but
 the response is accepted
Message-ID: <al278NTFHuO3GaNj@1wt.eu>
References: <SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>

Hello,

Thanks for your reports. Given that you sent this to a public list
(linux-cifs), there's no need to Cc security@ since our role is to
route non-public issues to the relevant maintainers and help them
coordinate a fix with the reporter.

With that said, for your 3 reports, it would certainly help and save
maintainers' time if you could propose a fix that can be applied. If
accepted it would give you credit for finding and fixing these bugs.
For guidance on how to write patches, please see
Documentation/process/submitting-patches.rst.

Regarding any reproducer, usually maintainers appreciate them, but
please send them privately only (i.e. not to a public list).

thanks,
Willy
