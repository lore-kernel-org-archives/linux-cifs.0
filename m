Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE93B2FF3
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776080125; cv=none; b=MAtj6rk2dFTv+0eD9sOo6ED3rw6TCHwpMoNqBKY169l6IJkq2+CJr7d3qjp4WLCst4Y5m0r/PrGQI/J2LtIl+F7d231r8LS9F8GZEyBkygNgjhFEwsDucujkT221snY4/rihTmXXKDKOUkGfCdq4z4ONKkxn73NKHX/n7cixpRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776080125; c=relaxed/simple;
	bh=NkCG5dNKR/7tGXgar7zGy+QPPRGsKbzTG4E+VZxW6kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/ZeYDbFYcYVXOkRLfUAvLKxb92ZtE5Fxz4T6h38i/iRFOiIyJlKJHB9iafePZhxN4eTSSFl0ri6qoMps36Uso6svsqhri8smXB+WXBF0sfAsMKhuzHC2zor5EdJ/k9YlNlN1dpeSbo/UW15PoJPDmzn0SnHrXbwjH8yv+II5Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I/fYNAoU; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I/fYNAoU"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-482f454be5bso45806825e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 04:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776080122; x=1776684922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4lt6lkZuAvrUzCTFC1yOHD1wDn40gr5BAHBhSXGovSE=;
        b=I/fYNAoUu+SIetY210TSK2rVyW1q+WfXLRx3GChIlpzKSnjJ2oPDEBHbiPECvoUy3t
         H9Ml6HdWbQP56sim1n6azEQ6+M2LDrRgmV3hRf60iBLav9n/cbXCuWEyEreIYyQDMkPX
         D0Nh7urgW/UaK2xGMLspocFjEeo1U7717B6cEFGAPDgw5cn3PxB4IsBcpVYRPrcuFAmQ
         SnHh+LI4/s31Lc55ImBUZC744N3F3l1C4W3OOfvJ4nBQSxNvoXexA++eaOsUZTv6e72Q
         EYoum5DieZ7URBASJv0l6zKjYgVmESBDWhbWadA1fjSR5C0Yiy0ai0Z+Vnh8QGPHpvai
         cz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776080122; x=1776684922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4lt6lkZuAvrUzCTFC1yOHD1wDn40gr5BAHBhSXGovSE=;
        b=r2ncUa2pFW9bnD9z6/3eaNmiM28ycjjwWPnBQgoJh9oH/WwH6mkwSKJJuK9CAI1P1I
         B4zwI+iho/j+YeEHq0YyANuvp0Y3UEXt2QT5BjqTSPlbePo7OUwVBmJKlS6OG+t+jtuT
         7L2RqRHUtlkNm8dbmb/pNiA16qPgFqEryPnsfp01WDIpSArh4r+zSoh1zBFq8BQ0+Ewk
         J3zHXbpE5s/Krv8hQfVPVttJxMsPt2dv4pvKCHgA3EFRrCveqCV53tFEIKV331Mn/xj7
         0eodB9i+A36sOju2J+vK6DtmgZpwnVTDLOXj6Q7pMcB/bZtXYwqXi2pS7mn/THxLcbJW
         Zyig==
X-Forwarded-Encrypted: i=1; AFNElJ9D9OB75pnUG8H83zCPHXTrircUxQ3eTENOkPCbn8eOFIN2YMyHAN+WfyJJENbqo2OX2M7sztVaBt23@vger.kernel.org
X-Gm-Message-State: AOJu0YzWK1uNPryLiXI1bFhlNHeja4Q4jfJbkzdMfBsBnfZCp3ETc9rj
	p+6GGM8BYD9UBAkaTYuCL6k/UzH9qcAuTDpeGAHsaPaFKDIJqdN+nZJ4+SHnwN+w+CU=
X-Gm-Gg: AeBDieuoYLYZuprSsLxNJCTEeo7/Ry4f6YDLNCksCFZm/Y9ZSPn5W2GSj5yoddmfxLa
	pd/tJ+cJyIaVXmMvNv8QJHB6MIec/pVr3xgQkx2zhdYz3AfwfkKbtnE4JR9rt3XZQ2RTCBSnVEX
	SfLLMCDSJ8vLY3FoOHZlfqQsPzRnx8a9nqZJcSH7Fg3HVb0qgdODKqeLp236kk5zfA9YRIAVM+f
	H+FTT28mv7XDnL6d5KUmGH5DOeOBDaBMEG0vA03MGQG5PM0DErQfLJ1zuNf7z2UpSY7/0kq2EgC
	JIqVI5ud80gY+F7Ky+fgV4+mjR8KNRXRmEk4Ktd5rwSrsUjNw8lZOm2D88bgxjJ0t2N1B4GYZ+m
	JyauvShmsFR2YHyN47ZgODkIIlNxbX4jLFVIwzy2wMlGftEO1pL663E0yxPwBTIPALTGJOXL9jV
	eYUrmsBYy0kRLTxJC/YGwZAssupvJ5AXU=
X-Received: by 2002:a7b:cd05:0:b0:488:a9c3:44a3 with SMTP id 5b1f17b1804b1-488cd4f463dmr164345755e9.2.1776080122044;
        Mon, 13 Apr 2026 04:35:22 -0700 (PDT)
Received: from precision ([2804:7f0:6401:5290:433e:afae:f475:c9f7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55faa586bsm18631266eec.11.2026.04.13.04.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 04:35:21 -0700 (PDT)
Date: Mon, 13 Apr 2026 08:35:15 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, 
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <xsj62z4aad54cseq4ug2cpj3x3tqjucjxkgv2c45lihhc54l5r@wjmkrz3q4r5m>
References: <20260310235642.6d9798f4@plasteblaster>
 <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
 <CANT5p=q2Lv4pSvEm5EWcM73b7NZsbt1kYEFJtjaAZRS6Gz_OjQ@mail.gmail.com>
 <42utcrhajix2x3feckj7ap373osq65sgfz6ximnaj4rasszret@ymhf44ddz2wh>
 <e21c9e47-36e2-4f15-a7a5-af239a0abb89@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e21c9e47-36e2-4f15-a7a5-af239a0abb89@leemhuis.info>

On Mon, Apr 13, 2026 at 01:16:03PM +0200, Thorsten Leemhuis wrote:
> On 3/12/26 16:03, Henrique Carvalho wrote:
> >
> > Sure, I read the comment in the code and the MS-SMB2 protocol. The
> > protocol states that "client MUST ignore [Port] on receipt". Since we
> > are not using p->Port, I don'se see how this is a protocol violation.
> > 
> > We're using the port that was selected on mount and copied over to
> > server->dstaddr, so that when server->dstaddr is overwridden,
> > server->dstaddr keeps the user selected port.
> > 
> > Now, even if we only fix that for primary channels, the secondary
> > channels will still get the wrong port when they are overwridden, no? So
> > I don't see how that fixes the issue.
> > 
> > Apologies if I'm missing something.
> 
> Lo! What happened to this? I saw that Henrique posted "smb: client:
> preserve destination port when parsing server interfaces" a month ago at
> https://lore.kernel.org/all/20260311160856.635916-1-henrique.carvalho@suse.com/
> which looks like a fix[1] for this regression, but unless I'm missing

That patch was updated. PATCH v3 was the one that made to the tree.

See commit d4c7210d2f3ea481a6481f03040a64d9077a6172 ("smb: client: fix
iface port assignment in parse_server_interfaces").

Best,

-- 
Henrique
SUSE Labs
