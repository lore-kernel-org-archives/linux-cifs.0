Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA1C219301;
	Mon, 18 Aug 2025 21:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755553326; cv=none; b=lAwnAR/o8k3EEQpU7omds0UvM09i9YKbkwIfcp7J02IF0vZMnq6PiqRVcYVs6L7yEd0fqvc20AHo6Repe8V3J+NU1Fk5s/iID7RlyZ7hmSBxGSt9DNy2Zvo/w/25gGSLix1E5n35VNnt17LD8QqqLe7/fhXXFc5hmF46C99OGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755553326; c=relaxed/simple;
	bh=mwt0RsO9ZLR/VreoDtBPUWsIShYKP2N6Lwyc1rX0pu4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BZZLNNiHANrKa8QtzfOhSh5tALJc4lSC+WLPoXMJ2T+BqJQNzfORSO25lfy+IvLINlN7hiKR2HLEc5r+cAHo05Z28uf/RMuJSk/xpFc+CXm/kJOqK4MzxAm0u0BqKXMWZNEaKwQyBsGdx/JzmunFiQfkZ7h2wqYeglgZ140DIgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmIPp6QO; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmIPp6QO"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e872c3a0d5so457887685a.2;
        Mon, 18 Aug 2025 14:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755553324; x=1756158124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVrApoP14f9caj21OlfYIfBa76LwsWl3k/rrsNeI8aU=;
        b=HmIPp6QOB+50JYjYI15+DwQogP3mGqgGwYx2b1CLwwZvuanTN0qfxAxUy+IaJCz4pe
         lG+YY98U8MD2n98DvaONY0ZjaqSVgxxsMj3Y+6G6CwuvR1rkJpTDuF8oP2eSNvniAICd
         IRCI8KPSdbbn71AzYkuV6uZ5pAocQv/w3WbM4Squc9PvfJ0ynzXniylMZk324Svy11cS
         qIjJT+gq079cQ4VpNqcVBVzk/e9uC64fSw3IbCuLRhfApajcC2AWHixAT8I2fK3CM5tu
         Zyzs8KVSvC3+2d5FWxtCukNINv40C5htj+lUUv228y0qoTBUuXwoTexLQ3AkCWZZWTY+
         K0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755553324; x=1756158124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVrApoP14f9caj21OlfYIfBa76LwsWl3k/rrsNeI8aU=;
        b=Q91Mc4r4y1z3WmwFG4hQB+MMT+eL8KnMQww37cp7e88qYhUF7GTICz8fSOkZy1I6Tx
         j4Mw9gAG0NAm51Q1C5IspdaJtWx2fivU6wSLFySDndOl6gV5H5He7b/Uj2WAykNCjcK/
         qXp279giprwfd3qW2LeHafnDR6QfpjRG9EYtbHYAc3XKuTahYNe1ZDJm5NYJl94+l3+Y
         OPW/i4E0K75A9FUKBtb4hPj8OEFpxL/jVO4wppGf67D3BWz1Vpn4ewgevN+g1L+6TTzB
         FZG9kZp3S8nliGkSDlMCjuR8r47Ck3DI0JAOR1yUztsrKgk01C1/OYctoXOcALHrvMci
         bD9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUPozVaz/3zUAf3QrfZMQYOCMbtch2s7Pr5DZgNudVYBHB0EmxI0qvsbTCS62tIyoosK6YKCcto58LRwpY93ak=@vger.kernel.org, AJvYcCV7D82IQHxlG21YEnqPpDpecHxc5cOd4RJcdsv0hKkAhE9RaMspVKHTTWaEOB8mtl44jdLdnYYbqGsEP9V9@vger.kernel.org, AJvYcCX8rAbt9CtWAMALYbZriA/m+/AiwoyvcLBHjBhhMRmU4P9MLSd/9u6kbFER7q/w1BpBhyRiSlg3xFH2gg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf12U8tZQD5ysVrwiF1djQxfrjdNO/znL6xiEmOwc1h6u9TLeP
	OeqxmwQUvx2l/1TQM5SywVSgCz94RIQ0vB2IBcxIh19K1O6H8S/+ho16GmmdsKb2CP7aa8NAEF8
	zGCUmJIuJKja94hhhwrBcyd551j/hwWY=
X-Gm-Gg: ASbGncs1ZUv7GMLwJ8ZGsmJHqEq1VareLb3Pkptt/nKShBzHxX+7DVv1rjXB8+w2fw8
	Acib6fJsupV0F3Vwg+MFe9sxaQK/pO6bd+3fzG1VttzED185JoAx7RL62pT+TISD74/TfuW7XHY
	shepyazsikgKQl04YCHzVa6oUFA3NT4sHnWvIRiOdFQuWGoyg5CmsiSVC5widlEq5fOaij9wlp1
	gNxYkjaxcya8cTArbcI5K9dxxg4UKoa7JYAR0D3b9c8e8u6tTC3CKoCLn3gRQ==
X-Google-Smtp-Source: AGHT+IFjMAkT1mpPySflC+bP9ZHS64EiNo5JBjZgoMeWA3kK3ZsMgAjLbou5MIdDwNmOYm9WYdTpVGUD2Bs1b4gT8I0=
X-Received: by 2002:a05:620a:4686:b0:7e6:9644:c993 with SMTP id
 af79cd13be357-7e9f331f874mr67836285a.15.1755553323896; Mon, 18 Aug 2025
 14:42:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aKL5dUyf7UWcQNvW@stanley.mountain> <89a2023c-e383-4780-83e3-ba8f9e44c015@huaweicloud.com>
In-Reply-To: <89a2023c-e383-4780-83e3-ba8f9e44c015@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Aug 2025 16:41:52 -0500
X-Gm-Features: Ac12FXwxzyYRFXGH5ZrXXAIDEefWWgUFghEhiymRb0KWanoatFRoAiMK5AWyNkk
Message-ID: <CAH2r5muVjS+Y_NFSWwYoisPGfynyTkmynjpQHi2_Kk6Z8AiG0w@mail.gmail.com>
Subject: Re: [PATCH next] smb: client: Fix NULL vs ERR_PTR() returns in cifs_get_tcon_super()
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Since Paulo pointed out a problem with v4 of this patch, an obvious
question is Dan's patch "independent enough" to take or would it make
the v5 of your patch harder.  Let me know when there is a v5 of the
patch so we can do more testing and review

On Mon, Aug 18, 2025 at 8:30=E2=80=AFAM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
>
>
> > The cifs_get_tcon_super() function returns NULL on error but the caller
> > expect it to return error pointers instead.  Change it to return error
> > pointers.  Otherwise it results in a NULL pointer dereference.
> >
> > Fixes: 0938b093b1ae ("smb: client: Fix mount deadlock by avoiding super=
 block iteration in DFS reconnect")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>
> Hi Dan,
>
> Thank you for your patch and for taking the time to address this issue.
>
> I would like to mention that I have recently sent out the V4 version of
> the patch series, which addresses the issues related to `cifs_get_tcon_su=
per()`.
> In the latest version, the issue of NULL pointer dereference has already
> been resolved.
>
> https://lore.kernel.org/all/CAH2r5msLMNdqdo6EBuTvrQ0hwrqSRC-LSZuN2WpwV+Pk=
DwsCOw@mail.gmail.com/
>
> I avoid null pointer dereferencing by performing a null pointer check on
> the return value of cifs_get_dfs_tcon_super().
>
>
> > ---
> >   fs/smb/client/misc.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> > index 3b6920a52daa..d73c36862e97 100644
> > --- a/fs/smb/client/misc.c
> > +++ b/fs/smb/client/misc.c
> > @@ -1116,7 +1116,7 @@ static struct super_block *cifs_get_tcon_super(st=
ruct cifs_tcon *tcon)
> >       struct cifs_sb_info *cifs_sb;
> >
> >       if (!tcon)
> > -             return NULL;
> > +             return ERR_PTR(-EINVAL);
> >
> >       spin_lock(&tcon->sb_list_lock);
> >       list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
> > @@ -1141,7 +1141,7 @@ static struct super_block *cifs_get_tcon_super(st=
ruct cifs_tcon *tcon)
> >       }
> >       spin_unlock(&tcon->sb_list_lock);
> >
> > -     return NULL;
> > +     return ERR_PTR(-ENOENT);
> >   }
> >
> >   struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon)
>
> Additionally, I think it somewhat peculiar that in the current
> implementation, cifs_get_tcon_super() returns -EINVAL.
>
> I would greatly appreciate it if you could review my latest patch series =
to
> confirm if it resolves the concerns. If there are any additional improvem=
ents, I
> would be happy to collaborate further to ensure the best possible solutio=
n.
>
> Best regards,
> Wang Zhaolong
>
>


--=20
Thanks,

Steve
