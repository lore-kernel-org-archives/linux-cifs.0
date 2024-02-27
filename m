Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57631146910
	for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 15:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709048882; cv=none; b=BsqajvPnk+DtTaMXql/mzi7lJhMgwoiDFdv8B4QFafJaApEEVjcToGoZE/841ffjeet1EHtaNRRLG46tU7/GZU3/jJkLDIEpmsIUNLPzN5ulctDeqvlm8orZZUM8xQKqjN5CiKl9P6kD4n0H1uzUBIx3OBRb7O3gqjFHytLLwlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709048882; c=relaxed/simple;
	bh=rK976GM0NfQRLEZ7KvYJt736T3oPNTXPPb6ghZwH7L0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bL27bDGCY4CJx3ySf9ejyt69uCVdjbjII0soBUuc2Ggt2egTgJtEWM7EcQUJMnx7zDETc+BhoUpDzjOhCDZjEjXhhd/sESB7GvrCYVpT9Si8X1MGN3AnQSaGCzFXqHI+5bW7bWQFr6TC7S9QC/PTrGlSjW8R2M5lS8kB+43hBfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0stk9ga; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0stk9ga"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5101cd91017so6502595e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 07:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709048878; x=1709653678; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1MGBbSzvtwuuCtHZzSqR/M9/BdzWA7+3H/5O2qLehk=;
        b=L0stk9gax83bH4YZjAs3esuxUhgxRrvn7CdqKC2M96Cw5eIY3TJEmPmp7zOErRUPgU
         I+Qm0mUt0kdSzJsFcclqmjtwTEXPUi0jML9Bppjh+m5jWxssCI7UJVae0Ep5XkBmKWVN
         FO/3evni6q37QOa4OOTyRwQTQC4mYlv2xDk9GTGUfiGh5bkmjc4pCeJlRp710ZJmxYgr
         Y4kRdIPJkObOyNFYqJaEaDUCD2tMhUtoekc5PTrJDmgXCHRHqWAyS2ZFwjcIAKuuQi25
         GFeZ5N3PrTWW17dGdsrkwVhXUrQoqMrU75WnwwEAAKQSE0NXQEEiUutgYMiswOC3+0tt
         6zTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709048878; x=1709653678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m1MGBbSzvtwuuCtHZzSqR/M9/BdzWA7+3H/5O2qLehk=;
        b=if+qrsQ7ADS8cxg4hpRX2LGQ1dLvbxLkStIH7YfaIHjqi+3nL1u97yl4tkWCJqvcVT
         43XJRnEFQnZZ+/Xmjil+hSsgfshHq+jhPGIAQhpTdTKb7uVnuPSnx9/f92r881r/XVyA
         fJ/M2v8ZitJXndi1VFMtPG1OAgSrqOBYX/+f2jagXPfZz7rhEJG5/Z4JFwclNdzsfyGq
         TJa/sjPoHd7b0R0ajRKV8Mh1+DsCWW7QF6k4Q8goRwe17aoKCkqe4fKTCqWmyktPnTmX
         cygRtPkyehgW0CvC00efCxQOARJh1nUwOH8uAlbv+h/tbjGKzloTYoN46qTPnJvOmT+4
         vn6A==
X-Forwarded-Encrypted: i=1; AJvYcCWot+uV3eyfep7cYld9J5Oxh0OtPVe7FPUNKqyiNUoAKYzieHYsGB9fd3oJgaGzwGa1dgL7SzS/xD5Ny0R2ETbLJgHOyzK3srigrQ==
X-Gm-Message-State: AOJu0YxAkV/4+of/FOFYTWdPdPE3kdBgGMEcmDbdPN+RTKLlA/hFuWe+
	Tusd4waDFQcDI/98Hs+H2Lh/lv1g8BKr3vY6JyjO9kVCZb+Xn9UxPbYPZ+f1A7fyIQXRkKkM1FJ
	iqnLLtbZq9hcfd18iG02i6YsQdvY=
X-Google-Smtp-Source: AGHT+IFJbOze3h9tBOmOFH8ql1ichr77RPxBPn4Khx2WEu7sWUgSUWd8h4w7N8IAsTII+qZJyM9zRHWRQ8G8qvHtRCw=
X-Received: by 2002:a19:9117:0:b0:512:a9aa:ab48 with SMTP id
 t23-20020a199117000000b00512a9aaab48mr6617770lfd.7.1709048878082; Tue, 27 Feb
 2024 07:47:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4bd0de41-528f-4506-9c12-d635ee478f64@moroto.mountain>
In-Reply-To: <4bd0de41-528f-4506-9c12-d635ee478f64@moroto.mountain>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 27 Feb 2024 21:17:46 +0530
Message-ID: <CANT5p=qGARj-SsPuvZkyHtpeii605KQkSS0WLwXhKsFq=QyFKQ@mail.gmail.com>
Subject: Re: [bug report] cifs: missed ref-counting smb session in find
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: sprasad@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 8:53=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Hello Shyam Prasad N,
>
> The patch e695a9ad0305: "cifs: missed ref-counting smb session in
> find" from May 23, 2021 (linux-next), leads to the following Smatch
> static checker warning:
>
>         fs/smb/client/connect.c:1636 cifs_put_tcp_session()
>         warn: sleeping in atomic context
>
> What happened here is that we recently shuffled some code around so
> now Smatch is aware that cancel_delayed_work_sync() is a might sleep
> function.
>

Hi Dan,
Thanks for running these checks.

> fs/smb/client/smb2transport.c
>    204  smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, =
__u32  tid)
>    205  {
>    206          struct cifs_ses *ses;
>    207          struct cifs_tcon *tcon;
>    208
>    209          spin_lock(&cifs_tcp_ses_lock);
>    210          ses =3D smb2_find_smb_ses_unlocked(server, ses_id);
>    211          if (!ses) {
>    212                  spin_unlock(&cifs_tcp_ses_lock);
>    213                  return NULL;
>    214          }
>    215          tcon =3D smb2_find_smb_sess_tcon_unlocked(ses, tid);
>    216          if (!tcon) {
>    217                  cifs_put_smb_ses(ses);
>    218                  spin_unlock(&cifs_tcp_ses_lock);
>
> Smatch thinks calling cifs_put_smb_ses() might be a problem.  This is
> a cross function thing involving reference counting and I haven't worked
> through where we're holding references so it might be a false positive...
> But I see below we drop the lock before calling cifs_put_smb_ses() so
> maybe it's okay here too?

The function here just decrements the ref count that it incremented in line=
 210.
There may be a theoretical chance that some other user of this session
decrements the ref count before line 217 is reached.

However, calling cifs_put_smb_ses or cifs_put_tcp_ses itself is a bad
idea and can lead to deadlocks.
So this is a valid find, but for other reasons.

The fix would be to exchange lines 218 and 217.
I'll submit a patch for this soon.

>
>    219                  return NULL;
>    220          }
>    221          spin_unlock(&cifs_tcp_ses_lock);
>    222          /* tcon already has a ref to ses, so we don't need ses an=
ymore */
>    223          cifs_put_smb_ses(ses);
>    224
>    225          return tcon;
>    226  }
>
> The call tree Smatch warns about is:
>
> smb2_find_smb_tcon() <- disables preempt
> -> cifs_put_smb_ses()
>    -> __cifs_put_smb_ses()
>       -> cifs_put_tcp_session()
>
> fs/smb/client/connect.c
>     1617 void
>     1618 cifs_put_tcp_session(struct TCP_Server_Info *server, int from_re=
connect)
>     1619 {
>     1620         struct task_struct *task;
>     1621
>     1622         spin_lock(&cifs_tcp_ses_lock);
>     1623         if (--server->srv_count > 0) {
>     1624                 spin_unlock(&cifs_tcp_ses_lock);
>     1625                 return;
>     1626         }
>     1627
>     1628         /* srv_count can never go negative */
>     1629         WARN_ON(server->srv_count < 0);
>     1630
>     1631         put_net(cifs_net_ns(server));
>     1632
>     1633         list_del_init(&server->tcp_ses_list);
>     1634         spin_unlock(&cifs_tcp_ses_lock);
>     1635
> --> 1636         cancel_delayed_work_sync(&server->echo);
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Sleeps.
>
>     1637
>     1638         if (from_reconnect)
>     1639                 /*
>
> regards,
> dan carpenter
>

--=20
Regards,
Shyam
