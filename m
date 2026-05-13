Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC53E39099A
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 11:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778672750; cv=pass; b=P1iGYjns2BbAWz1QjwcuP+cSn0KNIWpgElA7Ah4XkSGUIXz1Q3DCp0Fm/5vwnAC0EGeFAZ6g07E0esR0k2Zu5Sam4dnv0qRV0ZUabZPJjJ+DT80kMsLeurAwQtcdaJoz75TnGUc5qN7bRlhlF59AMgIHXYBdWdS9uBCDxBoju1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778672750; c=relaxed/simple;
	bh=OCJVZ9t0cA6gJISiESruJqN1hqsmmd1ukxjNi7yLY5I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aFsE19/KQ41Fi6Lw3JJdorxh2vczpcbPJw3Y5ujT9VhuOvwEQl+Wfn7K6x9xDNm9SVtUeWITtePyr/OxDltXrEpmEC0FnNRmH20NaZDRiERAhl0I7LtqM9k9XmwB6O4+rO9QiLPmHIErEH+mKLitAYFI7asVy8ThpciIZd3y3Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com; spf=pass smtp.mailfrom=enakta.com; dkim=pass (2048-bit key) header.d=enakta-com.20251104.gappssmtp.com header.i=@enakta-com.20251104.gappssmtp.com header.b=PSh6g80k; arc=pass smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enakta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enakta-com.20251104.gappssmtp.com header.i=@enakta-com.20251104.gappssmtp.com header.b="PSh6g80k"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso66696745ad.0
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 04:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778672748; cv=none;
        d=google.com; s=arc-20240605;
        b=MEHBmydZwcvXk3IC+eDHmimeNzYnSJH8fp8mQsXR+2a0PclDB/m1LQNyRoYrOz68JO
         So15DxEi/gs0yC/dRBHRVh8mBrKCjeDFAGU4aOSGdVd82Kp3LOygfH3AxPCYdqbgFKqh
         +A6KDXZc9ic/p9mbOdsxuHg8IuP9Wl7TpjMx+mnxHh4Jlyw8sXjDY4cWC/yoTm7je1I4
         aYcFfdlLjjd40iBIIHhzOI9tv22Kdi0EmZHC29ugV1EnzT6rN2QbhzwMdiKZdOV6P3Bb
         ubB7Luo/tLNxeThuUBadcloabIujaF0XwTunTo3qsFGA5msPtNCzjIppnLuDWqgSlF/X
         uaog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OCJVZ9t0cA6gJISiESruJqN1hqsmmd1ukxjNi7yLY5I=;
        fh=XdpHtknMr1uO8UnA4bKdwg45vrboHkG7r5Xt16QW5Gw=;
        b=ZY+llq9WR+DGB9FZngNjPnnugSqgJDU/tvt6tMpVlRSiHFZqS462WG+yD6jaJsJcxG
         FOyIzGrT8s1xAFfB/pJlUWDias28mwgFgak8ViQI/mvib4HfXVTS3KoOOqSWP3NHT5YQ
         Dp4+qUnr9E+8mTSUsmOmpGTaeBB7oiMyJLe6LJlqcKPGwjFSGS7+9U7GvZE81ShEb9qs
         P56gfmxJjRbF+LlzEGfN/rANJAvXyOkGfZNgkC9Lyy7LFPItTX2MGXwnHeSygHIHcvhn
         dknNb2/faVXTfz8mrqnHMGG5eA1LbEOv2Ub+iLmCPdc8mIKcKyG+FhrnLQoy7V0fydln
         ohcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=enakta-com.20251104.gappssmtp.com; s=20251104; t=1778672748; x=1779277548; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OCJVZ9t0cA6gJISiESruJqN1hqsmmd1ukxjNi7yLY5I=;
        b=PSh6g80kifnmmIxLSTMkhURoIa/QMdzoqVnrOdg1+/SdzbI2/FFWSdSvxHketbfhE+
         VJ2UyfmjkBqCav4Wgrp7MTNYgH4wPvs9Uc+lbwKoBFlc3okokWEbyNQPW3OHbPh2EDHQ
         +tA7/hbt2Gp0p2Rv8xNFYzdh1afNDZPJ7YiK0OIx0GMN1WISY3Met7A5ygVPNk1HmXQd
         4gmGu4fWTt73N9tKJywlSByFt8CDM5xzE3yL7yseQeWxc5RZEvKF7OCHNzzJibc7ZOol
         ut3o0zKsQvosm+zwHr5xYmKE16FUvfZ/p8yrB12Iw4j4rvT4dZYly7bJQHnNOgyNzoou
         40QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778672748; x=1779277548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCJVZ9t0cA6gJISiESruJqN1hqsmmd1ukxjNi7yLY5I=;
        b=KX/Ehtz9fr29HlJNQgGju7mKa+Qd0UuHgAcQrg1SZMdFu+Hpd14QZiND3hcjs+88oR
         UBrKYGGpMNxnYON3Vp0YOqPO4qL3CDSxbXTyOY/crthOUhIzZgfgz96V2ihVHwdUmnoj
         yt//Lg7XhleZN/7bihfV8DZG7BG9fOoaVw2vKGbKYulqbkJIOOZOOZf2nY6xsUpUEX86
         ztC3vpgO+nF3p8FEp7fjeC0giJRUknOtDHP5bm7cG1SEqzgHevsFLM9hT3axLQIGi04y
         OsRU10DTseq1cik9Ek/jsXiVSBXN9lAtvvQc1xHdrqnRAnFuUU7RLdmonwba+u6VkUia
         ArVA==
X-Gm-Message-State: AOJu0Yx42oywKPbRt4y4oDzbwOWolSqy1YGWMe9UYmGuDD5iEe02yAJ/
	Pn6c52pyMXkFGa5J/k6kxvikdwz0DVpBK4ZAykCz+5n2w02VfWuEKjU19wyMub0wGKx/5fJl6G4
	5OK+apAyWYai9ZxYQQyWbmNFWA+/iKnErNSwQC7UnyA==
X-Gm-Gg: Acq92OEZWhHMuMJ009Oi1QEU8AsP6Wbhy+ztAqJVtv27Cg4Z3FozDhuA30MbGkOnOot
	HC6TAJmCAitgTdV6MP8HvnaDQ7OOt0GJGYh2dqltvjz/boYt50tkIJ3P5G2zS/iKuKkAu/44Q4N
	LU+yMeyykSAfBz62K/GILXsTWk8B24pzzC48el4SpAfGzQPpKD9JYf0k6r9E69jEkEC4h0kVdHZ
	y5Vi200gAKJUXdKuLtuMbCXN2k9shzjQeAvRnVIm2z/8fvDZ3PpYM/Jv9j7VVds7Vtm84HT/1j4
	JUamxnCatxSzfsLupmzB6mx1TrogiRefj7JX9tOl3KV/MT3m/ppWV/BMKspg2mFH0exd
X-Received: by 2002:a17:903:2f4c:b0:2b2:4bf9:1766 with SMTP id
 d9443c01a7336-2bd304346b2mr28880595ad.33.1778672748196; Wed, 13 May 2026
 04:45:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
 <2cb12a60-32f1-4656-8a9f-305bd0be069e@infradead.org> <c7fda6fb-5095-4fd5-ad1a-22319bdf0d4b@infradead.org>
 <CAGk60SEw7xgSLc5+5EhgOnZkC6PTx-N98R94t5jQZ4wZKRVfkg@mail.gmail.com> <a1a8c33e-6e2c-4766-b7d9-b393204ea373@infradead.org>
In-Reply-To: <a1a8c33e-6e2c-4766-b7d9-b393204ea373@infradead.org>
From: Denis Nuja <dnuja@enakta.com>
Date: Wed, 13 May 2026 12:45:35 +0100
X-Gm-Features: AVHnY4KlvceH8GFdr9uIq5jDgAkNyz7qWuI32gmm6wzkPnR7a_Ph0dgkMunoo_4
Message-ID: <CAGk60SHx6e3cScvqWFLTph3ZmuzvmN_eqPu2DG79mDGLib1ypg@mail.gmail.com>
Subject: Re: Kconfig: CONFIG_CIFS_SMB_DIRECT bool option silently dropped when
 CIFS=m and INFINIBAND=m
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-cifs@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	stfrench@microsoft.com, Ned Pyle <ned.pyle@tuxera.com>
Content-Type: text/plain; charset="UTF-8"

I would like to thank everyone, we can see that
https://github.com/torvalds/linux/commit/6acc747906c5 included a fix
for this issue.

Hopefully, distros will have SMB Direct enabled on the client as they
adopt a newer kernel version :)

Cheers

Denis

On Thu, 26 Feb 2026 at 01:36, Randy Dunlap <rdunlap@infradead.org> wrote:
>
>
>
> On 2/25/26 3:05 PM, Denis Nuja wrote:
> > This was tested on kernel tree of SLES 15 SP7 running
> > 6.4.0-150700.53.31-default.
> >
> > Randy could you please confirm what is in your config for :
> >
> > CONFIG_CIFS
> > CONFIG_INFINIBAND
> > CONFIG_INFINIBAND_ADDR_TRANS
>
> CONFIG_CIFS=m
> CONFIG_INFINIBAND=m
> CONFIG_INFINIBAND_ADDR_TRANS=y
>
> >
> > in default builds of SUSE (and probably ubuntu i will check) it is :
> >
> > CONFIG_INFINIBAND_ADDR_TRANS=y
> > CONFIG_INFINIBAND=m
> > CONFIG_CIFS=m
>
> Same as mine.
>
> --
> ~Randy
>
