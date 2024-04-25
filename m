Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1C36A34F
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 19:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714072891; cv=none; b=AM30KRUFD/q3O92lAwGMhNwBKZ5PIHxsZl068CQl9ceg+JMg+E4gAn8kqEJTwD5evhLYXTYKfwdmz7oW2z9bhDhE1IzcHAtLZj4V9tZmwlpprgmbMK8LtzS7usM7l5eRVLiNjUSNTmb4nT/3nDmuk7bjyYpdG4fvs6deiS0BGcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714072891; c=relaxed/simple;
	bh=YzcXH0qa/xvOr0kPe5ojSCdR4wu5iXLCl7n6tcrM/LI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DXnxRRPPW6CXI4m1wnL4FF7Zx3ubD0y4NAYHoTT3hwy6A2s5fIKLK091mZBg1uucmRMO68gtUaSbtQA+gUoSxpvlb/iCTPCkbPo4F7Y686ycGhxhublKVXC/vLwsWuT/pGrdz98CifyT7/H3E7yto5Fsx9LM0cnYf6SsFpB/Qsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PaHFOxOZ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PaHFOxOZ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a58872905b5so166837866b.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 12:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714072888; x=1714677688; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L787oZLJk1F4+3FcFdd2II9qvyuGNAjeCP0n/kbaXdY=;
        b=PaHFOxOZVDRPDabU5+ZFyHj+aGK2arhjMEPBG3ruQhK8Qv0iQOzq2ejdKBCjeBHux/
         DZ0znfhNpzssn7VDzauGgsOJcDW8K3DdvKFiiJ6E9rZz6uKrPmunfVqLE+5qZLhA24Oh
         pcdroSBT0GyYg2tvL7HlGl0RBIzjzarcgxBhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714072888; x=1714677688;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L787oZLJk1F4+3FcFdd2II9qvyuGNAjeCP0n/kbaXdY=;
        b=M1LWzTZiVbiG5aZr37/1Zz+6AIySetwmDx2+ZahCsLXpuAYVkblII/GstHRam5l196
         5NR4TK/ozgMp6qeWods4e6c6432EMbT2SvX1vxNhuurKy2clPyK/55dkaK5QZjs7de6x
         UoRsNMODhvc9/vtdVLA9ALA/scvuqikcb8z6VlgOm2a8Mx28gVXo0kP0cpTa8WrOpoIS
         aFalZCtqefKvt1vgCIvOBFv277zlpJC5Go5glEUtQAHiJ/bBVsWTHUDt0TgkWg7a02Fp
         5tfOUKO6LalOoI6B4/FzY9oQQWYlfixBbgmRrBl6BInOmQyr/MLbZlTG57rHbxEBf25E
         BiOw==
X-Gm-Message-State: AOJu0Yy3lTwCOFS7HHfTwvDbPbuMc5S+/RJwmrECANiOJmgjQjMns9vP
	3PoxrAy5Oxnv53ekDIhrKQAyhQv2WDOTy9iI4AFfolsHA8YEN4SvGbKOTHwtQ7kGLkBXNeVqqYX
	xIVcfZA==
X-Google-Smtp-Source: AGHT+IGlabTTRLt6UegCwackoO+z21Z0OYMDtxoDqObBhIPAbMryUr6hwGpsfBegnTX/+xmKLx7sWg==
X-Received: by 2002:a17:906:33c7:b0:a51:9911:eba8 with SMTP id w7-20020a17090633c700b00a519911eba8mr429552eja.4.1714072887758;
        Thu, 25 Apr 2024 12:21:27 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id bu6-20020a170906a14600b00a57c75871d8sm4390984ejb.106.2024.04.25.12.21.27
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 12:21:27 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a55b93f5540so185340866b.1
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 12:21:27 -0700 (PDT)
X-Received: by 2002:a17:907:3d94:b0:a55:b3e2:718f with SMTP id
 he20-20020a1709073d9400b00a55b3e2718fmr573424ejc.23.1714072886710; Thu, 25
 Apr 2024 12:21:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <fdb2c85a-3692-4e99-a25b-4b17759071ba@suse.com> <54d8dccd-f224-4ad6-875c-774c45f9ba9b@suse.com>
In-Reply-To: <54d8dccd-f224-4ad6-875c-774c45f9ba9b@suse.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Apr 2024 12:21:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiaWr2fsvMx3EWdXRegQ9Fo5VzhRFn7cmLDErh1jhos9g@mail.gmail.com>
Message-ID: <CAHk-=wiaWr2fsvMx3EWdXRegQ9Fo5VzhRFn7cmLDErh1jhos9g@mail.gmail.com>
Subject: Re: 128 bit uid/gid (UUID) possible?
To: David Mulder <dmulder@suse.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Apr 2024 at 12:17, David Mulder <dmulder@suse.com> wrote:
>
> What is the possibility of increasing the uid/gid size in the kernel from 32bits to 128bits?

Nope.

We don't have user-space interfaces for it (st_uid is 32-bit), and the
pain is not worth any theoretical gain.

                Linus
