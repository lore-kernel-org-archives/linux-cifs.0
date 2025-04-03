Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D322907
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 01:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743642861; cv=none; b=gSJxDoSI0gqUs1lYA5HpFLXitr+ug6eyjDwFlF1aiCgH9VXoN4ekVSZNOC2p8ECYpfRw3MPKjcYt1WmVksSpwDJihl2AMiaJFiVbvaVQbF3Jjqn6rJkoZsiHYJcOEVSF43VGt6gl0X0oUhpLv7W4xQ71JbQ+S7csXnFUU0qCv54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743642861; c=relaxed/simple;
	bh=Y9BgQy2KX+CfcDOrAbK6ebfAq7UvR4HS9G9gGPSLWp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WD1Gz6IQOrF1Ios7ya8PmZ5UQz1M17D1qnwC5dUhxgyK4ZyATp8x/5Rka1tTeyCuAvNOuILbPLzCn4Krofot/+KYbISGRpzrNZycgEvBtIb6BOPUfLhdMzIiMMeDdS61WLIrYXEcUd/o41vLh/DRJJ+hrOn08gIEriZjvMQnsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fxj6jzSy; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fxj6jzSy"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-54991d85f99so1474440e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 02 Apr 2025 18:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743642855; x=1744247655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hohzDYZ6FlI+cb3uFQ5CJ3xazJWQcQVGVVZ8oxro6eI=;
        b=Fxj6jzSyUzgpm66+dRjXUX9IW4uz7oH4+hfhLnYrWNqAAtx/YfGvthl/oCXilsi+K4
         3hOxIIVWAvj7A/Zq2PRUQlUw52afiEaLFfPgjnue4ySQPQtUk3T6pcVjVwYRD4guf+j1
         8mQATpFdfDb4/hgk7FxGlm1kEHC6mt3ZVY5HMjKjEOBdl6y0JLlGURMr3jeC9RE8/lsb
         RMyulus5GGxc8elojewhC8NuhKLscRIxLLG2I/7DeUKJWlDBkJTXNPOHt0+zasnHN+C9
         oSrScgS/T+KfLeBG0c7pwwqNjKxdNWPQRtrGcW+cJJ/ieayUv9Bv28ua2PAyeCNiY4a4
         zjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743642855; x=1744247655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hohzDYZ6FlI+cb3uFQ5CJ3xazJWQcQVGVVZ8oxro6eI=;
        b=PQaY8kk1geILedbH7A9oGMc99h7BOzmO4MrELp1Pyy1NUiSRgvdDoWQik5dwJhmfCy
         mE6+aiRqn1CMhNdetCNOOOpS6k6ZzCiH6o/+MvgHw9atD67v1eeGUPcCYEQrLmN/b4Cs
         V0oMTPNw6kbbcJ6UFRKqNrVySwYz9Es/UfgR7DdN8yrhujsy+DNJFxEPUf1N3V5Cir3J
         hta4GJ3DvaOLcYI0olLIoO4k8XWbGjhOjvEilR+dDNDwKGIJpnBwbmsHuFnRGwu+sOjD
         S6stgSOdupahGRK/PL3WO3KyknBkMl+51ua+qk+Xu9o+4pgFhShvofIOx9zXpXFWJKHF
         9nTA==
X-Forwarded-Encrypted: i=1; AJvYcCVj2kzafkWkVCkVP5Mj2I2+6YR/xVh2rDCrnW0DdHu8q/eINu46H7A909JYI2ebYDJDzDCCXM1Uoye3@vger.kernel.org
X-Gm-Message-State: AOJu0YyMC4jPfl3gD8NM9MrPtJ9luKxzVu+w4XBZxUJPwpExKZLpEtna
	ddQ42Y+oQumJOZJziy/dhj7xOSAg3otwmNcRd0y7nIzE9DdpObaGeCD24ZgcfbzKhsoQsqE1yh5
	0QVacnkKXSSA+fBVqh3yo97ysquI=
X-Gm-Gg: ASbGncuiNAUSUVDFUtntbDsswaVqV4vB9zf0sC8VPS6uUVQtI6na4OhBaAb6ONoa/4/
	vC7PYjUcAG40NvgZkwdqdHA/Qggvl0f4VPgGCc7wSNbP3VGKStkt269y07M8moI9Vc1iCEeM9yh
	CTHVdlar5gc4+IiQaXGcdk5L8VaSGQvRqD5n2yXA10PXbMS1BeAZkaehZKASXYNbPrPX7fzw==
X-Google-Smtp-Source: AGHT+IGuljGeIJ8V+UnF5jeVqiCJaHoqTcV9VjMiV89lFThrlMNWp5FWVsSlRnwQFFKIgzfsXe7cWnV0yKQGQAvRCmg=
X-Received: by 2002:a05:6512:2c06:b0:549:5dcf:a5b with SMTP id
 2adb3069b0e04-54c1ca56dcamr510439e87.4.1743642855318; Wed, 02 Apr 2025
 18:14:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402200319.2834-1-kuniyu@amazon.com>
In-Reply-To: <20250402200319.2834-1-kuniyu@amazon.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 2 Apr 2025 20:14:03 -0500
X-Gm-Features: AQ5f1JpOfPXmxLBAK2JBQEl3k57ch86u5v63Nw177_ohPVCem745BX31RIrob7w
Message-ID: <CAH2r5mt68AFyJGdBcPB+eqzdAdbx=0QXC_U8MY-te26Wb0ye5w@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its
 followup commit.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Wang Zhaolong <wangzhaolong1@huawei.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

might be helpful if there were eBPF tracepoints for some of this that
would be able to log warnings optionally if refcount issue on
sock_release and/or rmmod


On Wed, Apr 2, 2025 at 3:03=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> Commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
> rmmod") was not only a bogus fix for the LOCKDEP issue but also
> introduced a real TCP socket leak.
>
> I'm working on the LOCKDEP fix on the networking side, so let's
> revert the commit and its followup fix.
>
> For details, please see each commit.
>
>
> Kuniyuki Iwashima (2):
>   Revert "smb: client: Fix netns refcount imbalance causing leaks and
>     use-after-free"
>   Revert "smb: client: fix TCP timers deadlock after rmmod"
>
>  fs/smb/client/connect.c | 34 +++++++++-------------------------
>  1 file changed, 9 insertions(+), 25 deletions(-)
>
> --
> 2.48.1
>
>


--=20
Thanks,

Steve
