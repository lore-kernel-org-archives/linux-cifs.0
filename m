Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D7D331A41
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 20:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839929; cv=none; b=bjaql4ysuYi18zhcgg0DVyQt4FMoH712F+sJ7V5uJNSxxTonvNi2Z5kPKuWEfLNERtHDfIs0QyPQVxjVk2b0nL5oUfOq2Pq6evUU31cECaU+0cvDiecEy7nJzvi/K+Daak7DueNo/fyPOEvT4elWe0aE9UU8dQbQOTymNw2x8+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839929; c=relaxed/simple;
	bh=u++yPO6YlIVuBQPjkd/9269C31X2LLHEbNePSWjTCU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SN2pqlHo92eWgn6qoWVFj7DfQHl+1sp/ajLQ30vg0NI/McHE0dbmYGZMHYcVGrtCx2HyLw038v/4/2xPG1bRjUe3d5h4CHV0HLA3yKEDjazGmByFcnp+wxrlBda6rgaOTkXBgMpgGBZeWZCG/zC6Edq9Ek8uWAOaTJky7NXixRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFJiIAqj; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFJiIAqj"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-69c1220bd51so1831806a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 13:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1784839926; x=1785444726; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wEYGw+CgSbhLcefnxlBQYKksB6rpZbF93UL27O3lGWw=;
        b=QFJiIAqjo9ec2aJ+pKiemb74AGJi8WzzWw7pot8Ye319x5y1XL0FlH1vlUSNw3SHNg
         FkENFCvj9Pr7sFemIntqJ75k3CYRwORI4dsIy9bRySEhaXb9E5xRvSqEJLLq9+hdPNYN
         0dtNtDwPf56rKMveCcd5hR9CoZTyUI1siYS8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839926; x=1785444726;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wEYGw+CgSbhLcefnxlBQYKksB6rpZbF93UL27O3lGWw=;
        b=FWYu8QpWvS4aLxrjfQibGEy/L7GttyPsOrWH/7pENEV7ga2gB26N4O39Ly7OdQOmGg
         RsaI/ff/PMnBOh/Ei5Csk3j5gaX/1ZkEWqYm79Uqw4xrSvLjTYo9mPs/+UHq3t5mIWZM
         /L3lrBy8HnXX6wyzLT8gX0xWefkJ2zkn2vibNehbriMuVMB5vtSrjPmw2VK/CZX/Be7+
         v4B4JhKs83bfPMdbHUtHJvJ3tNHuRejTQbbQCc8wKYibOBb/vecExLYq2ZiIl/koGiyP
         fd0/wStxPpiu7riDN+qs7dMhVM3Fvm0+Z3YiePAXLbuh6NhVmYZTjDwJAOAaDPaLcUMS
         IRjg==
X-Forwarded-Encrypted: i=1; AHgh+RpDxGMnsDC5/9tVwQNmbkSYSObCFzx+Uaw3bHcmQZRah3NFl8WCCwFNG7PDnMg6onpDCyRQrIqrGK/o@vger.kernel.org
X-Gm-Message-State: AOJu0YxN2BgPzX/+XrAIYwknj1kQD3O6M//HEXBu19tWKQvoGKt81vxR
	IhOaaub4cVckjoEzWTFR7w7Gk6tRzbUN8zm0hgYg/BAI2bi0g+C9AQUH/h79OOMBM2pOUaThrwO
	emI4934w=
X-Gm-Gg: AR+sD10+tZQ1BNGID6XrjXFpcqBMhimLOQ60PXOyAFnGUCkCmnlRs/Z1IWuH1SyYqF/
	RH+DPPFmLNMbGyIHOyN2wi8Wf6d0+8KvRjb47+2PA/9XJV+iLRYP89miUo4aEF2AgSV6sWrpwHe
	q83J0oI/hzZ3eGUztdyAKEus/pE8XWI0Nhov/w7/EoOcsq/2H4RextQ+RuqiQDrHx98JDDOzm9w
	W/UsPKArrlif8FvR1hKfs2Uz0F/FvXojpuFVQ42pqwoJ7CYDWT4BeJtLgSBlLdu1PAkaL5JzeZK
	mk+eWVq/kCBBXpO/DFs66AdY+ktRC3XbGTcZZx9NZwvkhnQJlTQae8TrrRmebFaabVqk+CVganb
	tb8qKAUgXqQrfsKcE0exyWJga6rPkLIL0R6bE4prsahOnzlpUuZM4Nd+Puwqtff3HSRq6NGgIpM
	beaBDfOmCemqcfS8e/DnkZU3QlHFBupK5dNpsqTkjBjPw4JW3gBvM=
X-Received: by 2002:a05:6402:4555:b0:698:99be:29d6 with SMTP id 4fb4d7f45d1cf-69f6c4ef29dmr1344899a12.29.1784839926166;
        Thu, 23 Jul 2026 13:52:06 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69f34f1c824sm2563738a12.19.2026.07.23.13.52.05
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 13:52:05 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1c52d920b8so152173766b.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 13:52:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoO+lRqwggY2YgClN21fnWwZeRT5HsKM7j83nSvUhlPP8jaqiMFQlNYJvm1B5AKOYBz1AwAdixcQu17@vger.kernel.org
X-Received: by 2002:a17:907:98d:b0:c15:bea2:d209 with SMTP id
 a640c23a62f3a-c1c506e8a4cmr182834566b.4.1784839924942; Thu, 23 Jul 2026
 13:52:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu0Qi4c8NprbnviCv5whzqGuzriVT6qShQ91=Kx4=T3Zg@mail.gmail.com>
In-Reply-To: <CAH2r5mu0Qi4c8NprbnviCv5whzqGuzriVT6qShQ91=Kx4=T3Zg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Jul 2026 13:51:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wivHxCcsL=MRRjgVptm1KD=gf7qYnCRfnCWj3YnFUU1_Q@mail.gmail.com>
X-Gm-Features: AUfX_mxoW-6rmt3L7jwgMSBO36G04Dz8j7e4l-Q3w0gjZPuGq0IO1MwIL4gANnc
Message-ID: <CAHk-=wivHxCcsL=MRRjgVptm1KD=gf7qYnCRfnCWj3YnFUU1_Q@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jul 2026 at 13:44, Steve French <smfrench@gmail.com> wrote:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc4-smb3-client-fixes

This pull request was missing a diffstat. I've pulled it, but I really
want to see that draft of what I'm pulling before I do...

          Linus
