Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9537C430B89
	for <linux-cifs@vger.kernel.org>; Sun,  1 Mar 2026 17:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772386669; cv=pass; b=B3mtR7W4D7AaBSr5RBXsvWBF8HZZ4LmR1X34cfMgCWPZCbyAb5Jt5dmYlApbbo45Zr1Q1qM/etNJI62sgCDogRJhiIhUWJoEUQ5LyTrZyItf4qvR+q1VPf2Q2Rawm3uMCKIqOolTjwD80fjX6dANjOGfLkGVzTsWsSnbr6IIbd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772386669; c=relaxed/simple;
	bh=bCm/2DMa2pzyxMwdlIuhkfeQ6pXlPazCNFi1TSv+NR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MnYSCBbiewMDGNr3zpniOz7y9iTAEpmHcOAxrxOYtHDgaPdr2ozuaR892PE1zYpOosWsNgEXFPjR17bClUFDEGAOF046hQFyiIzONREgIaSL773W9h4sbdlcoseKae9JUWOaIR9w2XaMmWbTgWtMs3qZiD8/wInsz3RzVfAZlU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVzGGhb1; arc=pass smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVzGGhb1"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c70ab3b5fcso538360985a.2
        for <linux-cifs@vger.kernel.org>; Sun, 01 Mar 2026 09:37:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772386667; cv=none;
        d=google.com; s=arc-20240605;
        b=h1JhJkHuuTiVl0NZpUZ1bJy8uJ7OiPSkTi46qg1opZ/8m0ly4utlxNOlJXAmdpCKvF
         Ctm0eXmri5c6LrbRYyHRAlXqp/gH451XtWeWicoF8kaeHpyyiNBaafd5h0L9fx9UWyCc
         4HczWMBwNN+CqY0TYmZkYjgOP7IT5XvFlVdhD6+gmMShUQG6Coa5m5g5/HUxG6+r7Rsh
         oB/HTN70KASYCLhTUY4sF4R94yG7wtwIbRqITS0lc49NmFBnArtxnhQEPe7akPXvWi8k
         JNeTfqnP/56YNt5vzvpKFjrkc5kuNVVmQ+Nxa8MK/+p5dEVTzAQzlfWq86YrMS5IYqZR
         9Jqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LZl8+gunEvA6uYKwNZbJf8bni2raZwWBuzBrJdmjKKY=;
        fh=7UNApQYTxMJElBFpJ0/sZ1bQG+ozU8se4fVnLzJE2N0=;
        b=YpKSwVB/Bu2HUi5xV7vHnbtyGQ/AwsWOjIWiTaQbDmRAstunkT4j7ziQ7bbs+4U5Zf
         xTPx4++6vQQTYauGJTbrnkCG4hBrlM6+4YCtYzWzdumIYlE1KfMgPzzVFvIZVP9tB3Ib
         EbKia70gdSXpsVmWYjtqci7gWRXn/jyLKQC8IIATtpkxFQON4dIdPUK2Iml+6oPFRjx0
         KCrccTYSfYKZjgwBV6nKvifY09RkLvK5+7wrr5QxEDMLYjHAG9GMiXGAYZT+5s1q4++Z
         iwyVAFVtiOG2X5nVrDWc44QLp9I/ItXUZk9onXdVMN8V7A/ZwgcsZyugCeA8OhyEHaVH
         ueLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772386667; x=1772991467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZl8+gunEvA6uYKwNZbJf8bni2raZwWBuzBrJdmjKKY=;
        b=RVzGGhb1DId30kRTbxihKriuJ6ULMMnGMaD08yMbIH/zZlnTG0B1cu+ibNHC5kTC3o
         cFX0ETTfChnojYvZkrmca8dY4TNdPSZJ1tb2pu8l6WEnyhOqkJ5FNJUwZ+94fpINHBex
         gg8hf3H6WQ03+8hdxxt9YiDWaZosMJ7SFoX4midinnLHFPC7hnTl9rrxMV+j6Y7UVeMl
         cLJ8z0iEVImV2xA1RDDn9lr2Gi6iH19KBWQKtzPOTctFu5W1XLQVwTzVh29EA69QH450
         x0KrmAQEoeH24EgAqkVqolvEKAidvXaNRgCjTAFRUznLzlM9yrJ/gkn6UYoskbtaqbXo
         NR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772386667; x=1772991467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LZl8+gunEvA6uYKwNZbJf8bni2raZwWBuzBrJdmjKKY=;
        b=IIn5MarMvkK7vK6FSTl7q1aA9zNkwsTrpWZiiTveOUny0HTsJ1S3oagelP7hq85qix
         AHwaLbSjPSLw8n85skgX+EzO6ED2lvHWqV0WF616BvpoDrk/irzQVsw81exvdtkr4Vy5
         2VTLSuZW9bcydX3ZXXh+sBJspUdE+MrGjvUO0NXVNvkZ7/wmyFolRIuxGN0L6aLGIkKd
         GYqfEFmyJTKyLZ/KsAX7jG4hj6YmFtabOTtw4dv3w3tD81NFC4moORKpkxkh9RT1FRN7
         RmYi86tNn4u5PEhWhlQFK0fD8f4cFGpyzVmtnUqgGbnXOGANKalSreMRxn/AhwmgTHE0
         O+FA==
X-Forwarded-Encrypted: i=1; AJvYcCWBvFR/3kUa8lF2tJFQBL/kMUTu6fNW9rLe2DBz/7z0wPzrtz5hb2LpU80oCihEJqbdkMyaZcXjC3f/@vger.kernel.org
X-Gm-Message-State: AOJu0YyNLxqKX4hh4VhyXm548L+UV3+SCFFjsXkqBi5vGE04P2xG/GP+
	76g741/jLJb4Bv37mWnsMS3ZPsZ/CahE7MOrm7slO9e1+hmSK+fGebvRit4Zt06/nSENEBcC/st
	9qNd/16I95+dXkRfG8h8Omp/1ZibPVxw=
X-Gm-Gg: ATEYQzxPuvZh8AJk+xmno55NNPHbHj2KgFh4MW/534wc/J2Tw5pJbJNaNUyQpou0zvL
	hymbjlBZ86Zm/j+fMdnQ4HTyy5M+/+gNMXeTyMehJ3XIVoJpeR0K7cLtmEM9AFBWVphpg/t63bF
	Mj1w5HepFywFPiGjB9mMaBZJ/57xX3HlaIUYKQwWDJkUACSz274nDf3Zah/g9YdVcGTArJWbeiH
	hcEQ9ErPVs46KN+2hs6hiL6AXskI6Co6bxhJWkv9UO3SULWg5DrIAuMqkToO5jqxOQ9qUrJ7D+E
	GXgJc4605cYGceOzJtx3xjwh6/qiK89O7OorrTeI6mKZeTseaoh8pNHD1EwpvhvxVTZLffRfLdH
	T3JxXIbXWMxU7izwbpZtOooU0j5SbTTrhzSKxTE0oUuYUfI7/dXY93BfJAC4=
X-Received: by 2002:a05:620a:d82:b0:8b2:d256:d064 with SMTP id
 af79cd13be357-8cbc8df094emr1270665885a.41.1772386667322; Sun, 01 Mar 2026
 09:37:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260221080712.491144-1-chenxiaosong.chenxiaosong@linux.dev> <830a3b8b209e9e276da7ad9398f8711b@manguebit.org>
In-Reply-To: <830a3b8b209e9e276da7ad9398f8711b@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Mar 2026 11:37:35 -0600
X-Gm-Features: AaiRm5035WPIyLBJaY8VSToZotVprPEHW3DaspR5B9CCfQrufeDS5N3R0zjFbGA
Message-ID: <CAH2r5mvoHT1O=5nQTXjY3zXwXU+DjXeM18547SdPiW=1AVjgLQ@mail.gmail.com>
Subject: Re: [PATCH] smb/client: make SMB2 maperror KUnit tests a separate module
To: Paulo Alcantara <pc@manguebit.org>
Cc: chenxiaosong.chenxiaosong@linux.dev, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com, 
	geert@linux-m68k.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next

On Mon, Feb 23, 2026 at 3:11=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> chenxiaosong.chenxiaosong@linux.dev writes:
>
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > Build the SMB2 maperror KUnit tests as `smb2maperror_test.ko`.
> >
> > Link: https://lore.kernel.org/linux-cifs/20260210081040.4156383-1-geert=
@linux-m68k.org/
> > Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > ---
> >  fs/smb/client/Makefile            |  2 ++
> >  fs/smb/client/smb2glob.h          | 12 ++++++++++++
> >  fs/smb/client/smb2maperror.c      | 28 +++++++++++++++-------------
> >  fs/smb/client/smb2maperror_test.c | 12 +++++++++---
> >  4 files changed, 38 insertions(+), 16 deletions(-)
>
> Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>



--=20
Thanks,

Steve
