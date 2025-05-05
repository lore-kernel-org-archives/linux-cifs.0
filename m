Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4199D35975
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 00:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746406138; cv=none; b=Rjn7zohTX9Vp3rTXHTeso3grZP2/TTw/7pbfKGpQu9R+LjNAXWInxKA6dZcf+Fy+v5jc+WjcE+YiEoB5nmXjYgAYoRmJELQnT1AYpaKVKmG8WsWU6syvsI+qH8b/wm1HOLpPtWaA+bnM0pnWhyZKmZJz2JJoK2VkeXeQjEMLZF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746406138; c=relaxed/simple;
	bh=awxkJuzva4yaobEdqdCFDpAKDyz46EFnirKCoDWunSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HEpL1hXsro3zc3UvMPyyXPQx4d4PhC1Ky9hNkTkKi18f0uhj8X5V2VPC5ufN9uolvNoYNxoos3qnAse4XukDQBsRYPVjwsdl2DVt2/7kFfJ0PXVlkv9s8w9DLxfuzrIhlx8RbFPUgQzvqlNrA3Adjp6zHu7j4AnhwXBmZfIWdIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gLnUAU2a; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLnUAU2a"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54e8e5d2cf0so4539341e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 04 May 2025 17:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746406134; x=1747010934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=de+Bif1CLZ3WPQvSBwJf/ZFNWH/Jx+Jm283KroKCAs4=;
        b=gLnUAU2avxmmMO6CSH+3k9A2LzIJM6F4q6n3N10w2Yn3D0zNRp8W7q93iuIgWGw7DC
         LlVOXF9aaLpwxA7fTjIBbHp3LzkBUproGcudiPUobd2EfX/8jMVVDBsi4Ztj8u3NQxNp
         wqhjJV2TXL1FtbnhneM0PmS5Z5M0Ye0F8lWH7JAcKS7GbAdbb7F/33KjdPq2DUj4TVxh
         X6zJS9kQbWawdH7MK5abCBwQhSoEmWRsir1RCSGi1W7SkexcR/LyZAN/mEZ/ps9Xac/2
         S/kkFesOEpSADJqH0s8JW3qVbdGb2Jzlxw1UhPNfI4AdNVJxtnFTz4LchdhbawFa4E1Q
         OWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746406134; x=1747010934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=de+Bif1CLZ3WPQvSBwJf/ZFNWH/Jx+Jm283KroKCAs4=;
        b=Q14JmyB3Zls2AmnSMVBljnQEVfyGWceZYqYoT+3gVmyMUF1WLwVnM8rB9DlQhc5pIk
         PwQMuKAlnQqBIoBJJ/cqz8BNafEyBl9ag1RmCW4pKxSOu2hNu68JFy38TcjGvmvlre1i
         GVxHrTa0v22X5eEWOBtHgAByjtiPMSq8Ob9h8gFL6RqUeuxv/ukuaT4+W+gu4vNcgKVr
         KFYdSQONCYJrN9bsiwuG3t4VGZ1DU7Sw7kjsIHupN3eiUu9uUdPNhwxqaMVjIFuXalyP
         Ek+RpbFHEBa/Uu+zwlShl1z6l3CWk5itunIepJyfjzFvdmHbQLPa8OCkozhuj4TmjU8P
         i6Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXEg6mWJ8A/kurL5w/n5LQS0mTih0BS+czEIfc8+KcVfdBTzVaQ+u7F7F6S45IiJsFVE5C9ipceADqC@vger.kernel.org
X-Gm-Message-State: AOJu0YzoAMIQGHRKLJCrOrRA3KN2Hge0zBRjDE3Ikqq+aP0YS1jOiHJg
	xTk4ODeyjeTx4UB+vW9eSHLxSVDZfZBzs4C+UROa0rWlJwCqYFtv9j/yGsatNcjIlPFO2a5cUsL
	P2mbCRZVkl5f5SQHHbXc6cbGCgtA=
X-Gm-Gg: ASbGncvU62HbHQuBI1T9Ar29BBYumYgaLPLrVBjK0hSaviFKxaFq+OTQZjYVvhe63u3
	BjDswSSYDUZc0SC4SRH8zzUeUsMyHYZrskL8yElS0XCZXKzZCWOZrv8hD35gSwLVM8uV0AjCP7Y
	mx47Z813E7/NwIp3eJVGNMGuioCmNVotdUrQ==
X-Google-Smtp-Source: AGHT+IHNu1biylI5a+ApleH2hVPkdu9ZYSzlKBtATd/9YJzeieG6Md3qQMIU0JUNNNF+2sfKNb8ipTr/1UbrAQDm10g=
X-Received: by 2002:a05:6512:3b13:b0:54e:a2f8:73d7 with SMTP id
 2adb3069b0e04-54fa4f3e9c2mr1290107e87.31.1746406133981; Sun, 04 May 2025
 17:48:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502051517.10449-1-sprasad@microsoft.com> <aBS8jg4bcmh6EdwT@precision>
 <CANT5p=qGspYwczDEnp6oy6F1UQJZKJ9vYw_3pKdipcByqjjuTQ@mail.gmail.com> <aBgFcc9SPRPOUFHw@precision>
In-Reply-To: <aBgFcc9SPRPOUFHw@precision>
From: Steve French <smfrench@gmail.com>
Date: Sun, 4 May 2025 19:48:41 -0500
X-Gm-Features: ATxdqUHA4Ec2jrz1ZKftkKbIHGAMSqSeLFFxV8PotKfdtEHFmnOLWUxM0GRTuCo
Message-ID: <CAH2r5mv5T4LM6FPGtma-w7StY_vi96qutEYX5AMAgbFEiMYHmg@mail.gmail.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, bharathsm.hsk@gmail.com, ematsumiya@suse.de, 
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2025 at 7:27=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
<snip>
> > > Also, the lock ordering here is lock(fid_lock) -> lock(cifs_tcp_ses_l=
ock) ->
> > > unlock(cifs_tcp_ses_lock) -> unlock(fid_lock), won't this blow up in
> > > another path?
> >
> > Can you please elaborate which code path will result in this lock order=
ing?
>
> I was referring to the following pattern in cifs_laundromat_worker():
>
>   spin_lock(&cfid->fid_lock);
>   ...
>   spin_lock(&cifs_tcp_ses_lock);
>   spin_unlock(&cifs_tcp_ses_lock);
>   ...
>   spin_unlock(&cfid->fid_lock);
>
> This was more of an open question. I am not certain this causes any issue=
s,
> and I could not find any concrete problem with it.
>
> I brought it up because cifs_tcp_ses_lock is a more global lock than
> cfid->fid_lock.

That does look like a good catch

In the lock ordering list (see cifsglob.h line 1980ff)
   cached_fid->fid_lock
is almost at the end of the list so is after
   cifs_tcp_ses_lock

"if two locks are to be held together, the lock that appears higher in
this list needs to be taken before the other" so this does look like
the wrong locking order in the example you pointed out.

The updated lock ordering list with the proposed ordering for the new
locks fid_lock and cfid_mutex is in Shyam's patch:
"[PATCH 4/8] cifs: update the lock ordering comments with new mutex"

--=20
Thanks,

Steve
