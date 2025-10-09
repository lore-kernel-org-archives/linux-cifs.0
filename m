Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F820D4FF
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 15:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760024603; cv=none; b=i4jZBB8ukpjWEtbOG6+xGR53A9ZC+aP9BAWezvWhFzyENW4gUk0jO/CyUUspetBblOIBph9PDkLaGRGSnrdVkPeN2+j1H/XdAOtMuqXAQQuvD4aCku5gP9b4+1G6dh6MR4OsuuU5bIGxBDbwgzhPHrbBUlGCxbm65nTzNqnQPLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760024603; c=relaxed/simple;
	bh=te3lK6IWUoqi/wAYbc+4g/fP/ekfKZqS9oWgxvjZ0rc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H/etzzq7IQEhV04I5VWczqciSZJyECq7fg25JgorJ6ytvwfgtKLsUrVz6yoX1CexsVu/nXcLXpgMCT0NQ7bscfH0EgI1PEKBSNhdErCWbXGlGXXaSfqnZri7uneCM3KPhaKusuzjFUX1hCXDa4CTKE7Ml/Twgcr6xUwf8rgMiHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O5IK4OCP; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O5IK4OCP"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7e3148a8928so10682396d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Oct 2025 08:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760024601; x=1760629401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uNVjPOkZQ4/5TQpLx5EDj6qV7WJ4xTniFhtjleJ40Ko=;
        b=O5IK4OCPguzzR1HnnG11tlVqTHh3OF3Fv/qXLzbXFvE8ceBPYss8GF9Ce9OkRuIvta
         GkJy6qalK/ePV+Uh3tW/YNL/Aej2dNIbnrNMXea0znWeo7oo6JgrDrxRBrXUAhpQKIhT
         RBfHf1emrQzLYpVBwDWw2/hDtcNG4H42zgaMWP17cZejWoFx/qLtfPHYfBjsjdBEnm1B
         nAgDzPMJq0feamsRcZ2R/avlbGjtEgSHAHJO1izz1MydN2OwMQEs9tygudUwb/qjDgsU
         r6wF0KraM9AOfbl/9hytl0xx5wwAv/RlWRSP1ZqeD2Iobn5dRxokou9cIVLxZqKOHL1g
         bMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760024601; x=1760629401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNVjPOkZQ4/5TQpLx5EDj6qV7WJ4xTniFhtjleJ40Ko=;
        b=V4xC99UHBDjjyrQTvcI6sbpCHdCJDbU6fdzgDY9mwEkdJ3qeEAKPq190edDHmP2BrP
         NCQI8Y097jM8iJMnecjYvJs8KWGcfNDbJX36uSjINVTo3wuR+uw8tpM31oVbRri5uAxP
         QEPrAx0N5bvUq9ORQn8ub9Okr2/y0/aJlNBTImKLOdPKOtccRFEek9Q8OLwKjD80UXH+
         Xr408PK89cTt9qB1QicXq6NbMRc5CfUBwTj5l6V8ObrlnQ/VubBNDRUDShA9f1HIxAWb
         CTDC2+veMlY4733oCFP8XjCmoeikmktzqkjuPEr2vu9Jkhx3nEF2icpF9TI49gsZSUMk
         zG6Q==
X-Gm-Message-State: AOJu0YyOmb5ThewGzVRjKG2oZcR3/JsI4vajuWKH0huajzATnm6xIZX6
	bPP0LXKUK30lbvs74u9l7oUbbb1N/RASssdej+RiDIUTww3x4eoIsUlSHcnkE8nA4k5stt3Ola5
	8Pl2/UFXoye4S4HMcaVX4i9HfOvrsYf8=
X-Gm-Gg: ASbGnctcZyrYM9V/IgN/5g+Rj6JWKQKqRK7PEyIcfx2f0t3iVoGpDGzCjFUHO7gvFEQ
	cS8DyI7aV02yIDkKijkK897cXmPTwgAPfLMHs5luKKl3o/RmTg5FpyLM5mD5bAqCB2AM21hvgoX
	+S5v0+6EPHQtItzENi6Om8+zHJ/HTBjLsS8fxFumHLyl/nC44jR9Uflk+Alk8ocJz2vMAsiERS8
	BSXNNfS32U22OUkgCaxZzLIiwUv/htToiRL6OsNvA36gIjB1ZGtxU30M7GQYWs0jNHQw6fJ6AAI
	sdbLr88WO/1jGiQUWVqLt8Bw4pn1vGxFr23S4q/6zy/R5vmY6qAXqxQ8uD3LSg4pDP6r9yQocrm
	+c5k+WtIQOr3TJ0cScqnCgiHDv4SBAqb+xHRK3XqPU7ClWYF7AtLXjoOu
X-Google-Smtp-Source: AGHT+IEYrpzc6SMoRQfsWO3qThn+WGHDuSzBgj5HClu2LTLami2LK2vOG7hA85WdSkdDUqm3JQ980vltGEZBu587cu8=
X-Received: by 2002:ad4:5c83:0:b0:79e:88e2:1e60 with SMTP id
 6a1803df08f44-87b2108abedmr105123276d6.29.1760024601139; Thu, 09 Oct 2025
 08:43:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7a5c4b6d-f15e-4071-8a82-dca6b71b6b4b@web.de>
In-Reply-To: <7a5c4b6d-f15e-4071-8a82-dca6b71b6b4b@web.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Oct 2025 10:43:09 -0500
X-Gm-Features: AS18NWBOW4IMP5XCqIx3vf6oRH0bz8isK0u_b-ctyASqmWxzGVwLMu3pjongCW0
Message-ID: <CAH2r5ms+S+G-wjB1MPTp1G6MyVLf+yzq6r+_Yg9PLb6HmDCtYw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Omit an if branch in smb2_find_smb_tcon()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Bharath SM <bharathsm@microsoft.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Paulo Alcantara <pc@manguebit.org>, Pavel Shilovsky <pshilov@microsoft.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Sachin Prabhu <sprabhu@redhat.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Thu, Oct 9, 2025 at 10:12=E2=80=AFAM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 9 Oct 2025 17:00:13 +0200
>
> Statements from an if branch and the end of this function implementation
> were equivalent.
> Thus delete duplicate source code.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/smb/client/smb2transport.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index bc0e92eb2b64..33f33013b392 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -240,11 +240,6 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, _=
_u64 ses_id, __u32  tid)
>                 return NULL;
>         }
>         tcon =3D smb2_find_smb_sess_tcon_unlocked(ses, tid);
> -       if (!tcon) {
> -               spin_unlock(&cifs_tcp_ses_lock);
> -               cifs_put_smb_ses(ses);
> -               return NULL;
> -       }
>         spin_unlock(&cifs_tcp_ses_lock);
>         /* tcon already has a ref to ses, so we don't need ses anymore */
>         cifs_put_smb_ses(ses);
> --
> 2.51.0
>
>


--=20
Thanks,

Steve
