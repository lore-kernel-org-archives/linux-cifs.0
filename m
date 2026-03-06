Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D0933DEE2
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 22:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837128; cv=none; b=J62e06d6mfJycmrZbH+SWFKmcCuw+BCj216DWD7Bp0CMZeMfVap/DBsgrt8Sc6tfX3mS3kzYOK/R//YA72E+cSbI3Xupt54VxF3Nt9/N+KupEbs6Cpc8LKDZF3qbhaK/ReitlNRGgoEcIUd1b9bszns8rhqHKHGM7vZ1x6Kzy6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837128; c=relaxed/simple;
	bh=VHhQbUZfXZu/RPcTj2iIVq6h8eKo4ewqUN9yAbmPgLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fh1+lV5NcsMgfOz3Ze8KfF21pwRftU1Q0kBKqZDs+kzWgUHjwIH1y7VF+bSG1wd5BccHQGK6AcW90a8nvOmhoILHY0dW5E/S4ZrTD0oMZGM76nwJG+4zop4do6DAScXWmP4X6MHebFQogXn8tkSyGj6tn0Nvsqjf5ZxlLVBT/ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YpGPtnf1; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YpGPtnf1"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso89326855e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 14:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772837125; x=1773441925; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wpz1ppCKDMbzqKbizYrTq1daWybIN3b+17i5BaL8UeU=;
        b=YpGPtnf1xippXELKJv+X7qlxVoSs23FFr3KIGRMRjTMxtZNFs49PgQ0OWNiAl8G/r2
         eu3E6idMbVvSYxw2j2EH4DK00coJmiMM/zI6jK79YHQHhquq3uedzoBNYHQmgPCu7mco
         cYmTs5uDkG9SPBRP0DK1PnZUqX+/AUgdFfxcQ9dktsxOE+j/LCT8bE2hbUZJrpJtXjUm
         OS3Q7T4Bfs2qC+uMz4dSKUhQUYnDOgKiF9IFcyDh2yLfssy79l1iNyoDDgXYkXlMvxt3
         x4nJ6aw301GPhkXLhlkc3EfZnWZmM/7+CAm9AEx9u0VjpxT1M2Sy+TBeL0yEqPjrJQg3
         QUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772837125; x=1773441925;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wpz1ppCKDMbzqKbizYrTq1daWybIN3b+17i5BaL8UeU=;
        b=DzEEGGQxz43mje+zJSMU1QMVdDfd4AYWGMKYOpnDWN6ZkkqjYvw5KX2Hw0DmKCOrCr
         sakfkvHpFBtzXVYY0t7ZwsoUmQoFgguulhJt8CkV49XAocYVBBJHrUmvIQaqo8BBsPU4
         P/LW9jBu4cNQVIZij+GHr2a8mG8su9/q8xxOZpSkszUnfctVaETjmBr1fotnySlYYiAF
         RC3K5aeNMrHONNaZESAGgdxsS7WUXFAalw5aVxydOYqFYSjyplfF6ob9A/J162LXF88v
         WjEvRWUS2JJIi63noUx6vv303dTnahxwkjFq/xz9n7kYP4vXZ8LgXE7AD7Zipf0Aqj7g
         4xzA==
X-Gm-Message-State: AOJu0YxH+/I7JidPQ6ny/PZHKr3AaIPIEXWiEoqhY08N4JqHTj2oGia6
	NfKyOACfc547MOXbccGI1SSpEe0GakY3GF5gNwqgFap6opwTQgIamtr4fGnARF46WG4=
X-Gm-Gg: ATEYQzy06NWg+U/ifYrbwQRgPe7RYCg7+8xJ4Im82egvLxaKOfnx60BL3Sre//U0/iU
	tL44/mLzwX9tfibFdutW/Sf/gP6gOIStrm/i4z+rJ9xHBKWYNlnWZR/gbaTF5vh1/TlSV214LH8
	X33Ws95FLdgrHijvBxtqvZnuqp+3LAfUUfMxQt4WhXZ9p3N96RdOvSCc/9vRA+KHz1uSk+B3vhW
	bnCqPRysBWNqPKf8JBq2BXbltyWnHWmYkzS2gywwMNcBVZm9Bl92esjpyquGaR6l/uOUB02trX4
	LNlGC9peIC6Ngk4ftG/gaQQbnUIwOjhEJsWiT7GRAdbK9Wiqn68mS3h3TMb3lLvgAh3cXLeQJEi
	S1UXTTKwUk0eug6/QCYUEwQ7fFYZLIV/arSjXsT9u6bgrLrOXBCk/LP62fKyxx6o+Pl9gMANaqq
	hz1xLeLUhfccicYb8UrnzbduXIMw2h2bBr871XF3gUXnvYaOJTx28iiRY=
X-Received: by 2002:a05:600c:870b:b0:47e:e8de:7420 with SMTP id 5b1f17b1804b1-48526957c7bmr62668455e9.22.1772837125379;
        Fri, 06 Mar 2026 14:45:25 -0800 (PST)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6401:b8d7:ea6d:8ea1:ec5a:953d])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94e7b3941d9sm2880960241.8.2026.03.06.14.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 14:45:24 -0800 (PST)
Date: Fri, 6 Mar 2026 19:45:20 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
Message-ID: <4rrxsl6mx3lbpt32l4ly6psg3ni5nsfzgfiufzt4xecsbjh22o@z272atyrzzvh>
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <CANT5p=rk44fGgUL_Swp1pbVUeE80GJS4hxF00U0X4_xUbb-7hw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=rk44fGgUL_Swp1pbVUeE80GJS4hxF00U0X4_xUbb-7hw@mail.gmail.com>

On Wed, Mar 04, 2026 at 06:04:05PM +0530, Shyam Prasad N wrote: > On Wed, Mar 4, 2026 at 5:59 PM <nspmangalore@gmail.com> wrote: From: Shyam Prasad N <sprasad@microsoft.com>
> 
> A proof-of-concept based on this draft from Bharath.
> Looking for comments on how to improve.

Looks good.

Just one minor thing for now. To me the cifs.ko module version doesn't
say much as it seems to be not reliable (apologies if I'm mistaken).

Also, the same version could have different implementations in different
distributions. modinfo -F srcversion cifs is a better way to
differentiate cifs versions but not to compare versions. So the solution
is either remove this or bump it in every change using X.Y.Z.

Further, have you thought about how the client can use this in its favor
other than diagnosing/debugging a faulty server?

I think we need to be clear on what is allowed here, to me it seems
quirks, workarounds and perf tuning? Maybe this can be used to improve
interaction between linux client and linux server?

Thanks,

-- 
Henrique
SUSE Labs
