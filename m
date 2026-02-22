Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C684E1C862E
	for <linux-cifs@vger.kernel.org>; Sun, 22 Feb 2026 07:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771744796; cv=pass; b=kOc8nK1oIq+tuVqgIjfISwd7pc8GFgvF/CAPSy5rhRjCODcUkTvjitPOdNS0KEqSSEI172RhC+Zkx6I7X9chkt7C7TzY1/njYvI4l8BWBas0JKfvJmFq7K/i8sxdJSlMvuxNUIoodcdoWcJCgfRjqWSiNQQlmamvTLzDGyCu9BM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771744796; c=relaxed/simple;
	bh=0lDfK3AuaNxxPB1Mx5JPD44YULX91cix/sE9XtEee8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdobE2f49SmPRRSGPjrUB2uGZU9+5EIYVxLPKfWcrPZtcBO93acWtv9mUcbr4owAudTUvK4e0utsD8lppXfDmsoMOYJk8xkQTgeVBxFnlFCruAj1e2aKIZkaXKX88sUUuJvANJjBuxguomLZbuwgoTGpWBdOFJ0/lKFdRqdHpSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwtvKFVx; arc=pass smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwtvKFVx"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-56739adfa1aso2531002e0c.0
        for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 23:19:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771744794; cv=none;
        d=google.com; s=arc-20240605;
        b=JtKsFhQRn8v8zBLvS0L6wpbn/yjubLJQAViwj34qHVqYuhWcgNEcYvK4rzHhfpDTyo
         juI+TluSh81jlWMy1qY8bbiXnF8JDULLIj7MQyGcWhqa7+DZ2/0SJmu3Uvw60rZwNKVt
         nDKo8GJH7fFAq84nWUo2NL2ebxJPv7cNLfQU3ZycBodwYXLd84RSjH+X12XcEQ0Uh19c
         ZtapUvF6bO6EGtr4+xRFEIJfCunTYwaX/7uSl2mYMe2xY6t9RpBGBsMAd4xWkN2P3LYG
         RsBryeELNOlvay2EwGsqqTM1gh5EyFk/sqntKGRMtcj8rS8FEx3lKM59Thd0RTjLU4gu
         i8yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OILCq3HcP44ucOZfdh81GCluvZoTsk6wk990N+3C0dA=;
        fh=Ak2ITSLt8ZCEbFzRoQalJWt25c0N8KQ/YeQ1+FntRwI=;
        b=gLYtS552NbW5zC9JpcUAsCw1pwFyb0rkUBXui8mO4VCElQI7tREUYqFB9FpKCl9TZL
         D55F+brxq7htYgNrykmGqqURw/GkizjEjSmzJywl0HEd+NRsG0wUgWTEazhGbsFSm4eG
         45IYUgZMAoqGYC3kf1LCN4H/w41nMMfcfj/jiFgHj1IRaLfapsTQtOEp3G9cSkVS1euQ
         LIXkpnStPjPOJ35n7a5vWOqvbZZyqd715lksv+g6L7fxK0I2a6S+JdPnkPWuEoMgy1VZ
         8UBxU2KJ8QZTXUBF15XNbO+lxcd3lyBN4walnIoAGEsVQHJqTYEKzFEr/tPzTb80VRNF
         bf+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771744794; x=1772349594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OILCq3HcP44ucOZfdh81GCluvZoTsk6wk990N+3C0dA=;
        b=iwtvKFVxJY411/9ogEeNuKuIL+swHngOLh4yrtBI6Td3Zvrhz9GAxS6djLXc2BeeOf
         nwptn4OPwALolDkNO4yfUKWVGz6BTUQ/ZjsrhDkQelUcEp3u211ABAUwyaGfWUa3xyIl
         8TncN5e/ul82aK3psRyH0mTUkoioWE7HxKEG5Tl+V4ZPPo1duell20yNXLiz/uGQbSYH
         7yGlXL3++eZgdVawMupcKZlupPjYixQ8Rl23W+szYf64S6Jow0ieM/ciHxBMW07CFwOu
         mPqgTy21kVuM+pHA2DPgrWsLpiGUpwbZYMi/pXNbvGHP1UIGZhLEeFn1TM96mjwZUN8t
         bpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771744794; x=1772349594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OILCq3HcP44ucOZfdh81GCluvZoTsk6wk990N+3C0dA=;
        b=UseOGWbqDZqfy+DROE+XRZF94Z5rcZPbQn42zmNOd0Kqu6rDffuFG+IADH3pyeNpZh
         zzHi+HXklrEHl02n+9XAOC/kY0u3V7L+H9OwgmQl5WQnugBN036Vc+7VJKeMwrvBE37K
         CY80ktK3bpWPNz3e9HgiE1m8bgbQlEpzoRn6UaK3pR/Y52kqU6v/CL9ymOG5QFa/rrjn
         fDIqaoj5A4jrA2GB+FhNbscF45xcjHpw77aO8gdWL3sjoL7hgeYAIRnnVIt2a76neUEh
         T3li7uMc1Dmk4/DDa45xWxeUDnwdOZ2dXnrIa45bMBUXdDjagBOK9tS1Ub4bp1KwcuNM
         Ggjw==
X-Forwarded-Encrypted: i=1; AJvYcCW4PQ2xn00fVtptffJmFkva53DaisVCKxVFykj44bajdlA9EKEiv3l4qKgDRBNJSa9I3Z7oWft61Bef@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1aLZBZnmhE9Y981selUc7oiYJA8qzj37xSktGZWYvwKZ92Ega
	p2xw7Y7AKunq6vUAHGturDbDxZGXnBfV0tXXlq5c+ACDqR5ARH01tiJrzpL1Ig1Elop1jjC8MDS
	REwsiwrVCNB4fLwguKwH5Tdt2OcLih7o=
X-Gm-Gg: AZuq6aJaf0+Rnu7gU0dbp5qsd0RuF58BtnyE/aQGNUqcbVluD5C6hqp3dFeadA7NM1u
	lPDjZihkmWNDsnJh9VNLPZaVq20bNU9dSpvIw2LZyMXjs1chAWCSC04dFaOXqjaMplSpC/ITLM3
	Aee0wMrlbeABskG/vBkuM3ZKFIQPRTqQbFTMS6Fy08AepEJnyNFPs0rvQw0iHzRbU2e57eVZpJc
	cB0hxseaHhwOUfU/5SV4iV0dX9W0VUXfqpJ1QcjZfRljqeJrkDeQHtJiTOE7Wmeuj26/6dRqsWH
	Tsnq0rUn2vyB9SARmNtXabWB8m/nUUXnNjBbYsb27WjsMGyQOsRzVw==
X-Received: by 2002:a05:6123:2c6:b0:55a:ab0d:bf74 with SMTP id
 71dfb90a1353d-568e489e04bmr2702083e0c.13.1771744793575; Sat, 21 Feb 2026
 23:19:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFfO_h7TJbB_170eoeobuanDKa2A+64o7-sb5Mpk3ts1oVUHtg@mail.gmail.com>
 <20260221234553.2024832-1-safinaskar@gmail.com>
In-Reply-To: <20260221234553.2024832-1-safinaskar@gmail.com>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Sun, 22 Feb 2026 13:19:42 +0600
X-Gm-Features: AaiRm51yAd7WZH0JTtET-y37usKeLDtT6X5Vgs22uOg_jqenzkdmMaQOnOQPf2k
Message-ID: <CAFfO_h4dNydbmKSTP8uD9X6ouEZTyJUGoTBXrEHWeHtD1B=p5w@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] OPENAT2_REGULAR flag support in openat2
To: Askar Safin <safinaskar@gmail.com>
Cc: ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-nfs@vger.kernel.org, v9fs@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 22, 2026 at 5:46=E2=80=AFAM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Dorjoy Chowdhury <dorjoychy111@gmail.com>:
> > I am not sure if my patch series made it properly to the mailing
> > lists. https://lore.kernel.org/linux-fsdevel/  is showing a broken
> > series, only the 2/4, 3/4, 4/4 and I don't see cover-letter or 1/4.
> > The patch series does have a big cc list (what I got from
> > get_maintainers.pl excluding commit-signers) and I used git send-email
> > to send to everyone. It's also showing properly in my gmail inbox. Is
> > it just the website that's not showing it properly? Should I prune the
> > cc list and resend? is there any limitations to sending patches to
> > mailing lists with many cc-s via gmail?
>
> I see all 5 emails on
> https://lore.kernel.org/linux-fsdevel/CAFfO_h7TJbB_170eoeobuanDKa2A+64o7-=
sb5Mpk3ts1oVUHtg@mail.gmail.com/T/#t .
>

Yes, indeed. They showed up after a while.

> So this was some temporary problem on lore.kernel.org .
>
> Sometimes gmail indeed rejects mails if you try to send too many emails
> to too many people. So I suggest adding "--batch-size=3D1 --relogin-delay=
=3D20"
> to your send-email invocation. I hope this will make probability of
> rejection by gmail less. I usually add these flags.
>

Understood. I did not know about these flags.

> If you still expirence some problems with gmail, then you may apply
> for linux.dev email (go to linux.dev). They are free for Linux contributo=
rs.
>

Alright.

Thank you!

Regards,
Dorjoy
