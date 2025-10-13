Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDC1D5CC6
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 19:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760384742; cv=none; b=g+iI743cbEwd200z7h78UMeOgUH3bUR/pCoTdEEqTbUPZTJ4hu9j2YxkoL+H9y4aQOhMm/F3tl/39+MIoPRa9f2CTABNJLSQJyEdx/CZHEhg5xcp3QdUNW00l5Ltz9bsLejwOvG3tmW1x4hLybb1Oroy1Z5dlURzl8A7H880h04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760384742; c=relaxed/simple;
	bh=xP+zHGnOtpfP5QFBJ8g36SIoM8qYnQZm2nJvGRd9Yrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WQADjPsfXvqLUumzg75WqVI7u6B0Q9oIm6QkkrMfs0aKwH8ah0/5hhkB+VBbDPBkBQStKNr3nAdjEROPl0ermAtPPNHaNqPe8978iJ/YPnKuRwo6LKkewl/0gLo4dQESVCFpWXRuFqE+XsZxfKl2JfkKASK8/8XnHl1Mc8ijEDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHJ8NdXN; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHJ8NdXN"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-875d55217a5so632988585a.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 12:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760384740; x=1760989540; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcmZEKTNBTIPCp8q96eFzSv9hIg6mWUgJbBgwmUh3jc=;
        b=UHJ8NdXNDOWJKAw/eKhG85roRU6qN5mkCVuhu/0AlebmXVyKR3xFdeimYZc+WKg7Zs
         zw7NMTTa9mNbNjdHrO+I+lBybzXYwh7qNQUngRy5pPg2lqhwS1+SZAlIKZbikonoIqfH
         OwsHn8Qq6X969ODkJnjOwUvurf+CM/KrSdvD2X5pufLfPBkzQMA5u2twfDTjFwdBs2oh
         JrrnTTaydJecyoqP8V2e2bl4ub4TIw6edgzhzZRUTFec4O+ntLn7qKg/qiVj142Io/1/
         AgxfefI4I6jwSdiR5Ea1t5VaFbjFDYvLc4CXq74I/HYG7bv9WPCdbd3BQhQvlUNSSBjB
         Ynfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760384740; x=1760989540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcmZEKTNBTIPCp8q96eFzSv9hIg6mWUgJbBgwmUh3jc=;
        b=qicRU/Ud4fQOHhZIryUmFTu1OFOCDasc3CGvESeWv/OFOVyYIeEeZhIbEOxtakLV7t
         m9boanIX4nbEkzJOBaX8D62MsDwIkTyrfuwsKy3v2Mj5goBokBsOBBcYylc6HagJ14cX
         Dnz/vNe805IJUXmgP4CkQT83ps9KX2IVXpIMUk1We7tr1VNmqZQKijVb2igyKRMhnxVg
         ncdrMSFLhUVWjfbLO/AuS+aPs2Y4F1Kmp6b7aNrWOcbR1agm2LiUzKD10DRrdKN3dlvo
         l5eJ8gSZxoMdoxq0OHcJkqqFnoBKeRrJjxNyxSeQjENQYdzbKdPa4XkliA0TUiHjSVcS
         +ijA==
X-Gm-Message-State: AOJu0YzCLY+Rw20yI7AiVd3X/BMvsWLPqObhhEiwgRSPtfXA7ZWmqNue
	tljZoTZI880lqpdumxrYtWOvHdPfTnV/tobG277zGS+zYb4mRKAjPTjMoSwedcovpJJAoVW+gzK
	vwSb3r3VtiC8YPBeIN595yahsJI64XdY=
X-Gm-Gg: ASbGncsQlTFmedhwaVGLzvJR2BwlymBxhKIKwlx0ATZh9B/uKDRkD8rT29z1riw5kKG
	bXqN6KCZTW2LGoVdbj6OpMct0RAXOcCLKFj9SBKraup6dsnSKML4QWyUA47jKDG4yBfFowYSYxj
	IRoRvQXKlePkzVsGNtQQ580SoiwQD1p4p2p6b+6VURZWxtwwREXft6apAcj33P5Lyo4jl75o3ff
	df06m8liKh2i+z/4/d8hYMny81AbzhVoeiHAi7UcGfQXMUhKPTsgp81xS56fsKkirO5agC9804V
	CV/z/txWfL+vN8PEOcVLBhB3SF9ASS9gK00la1voOI9IUw8uo0YEEzt0fe/2zJT3zNcHIco6Ngq
	5PgpmqU9gnZe8iNhnKLiewa2NmFj+mPyeJvWbnu+enazPlcpCHss=
X-Google-Smtp-Source: AGHT+IF9sCYKN0g9TVqil8pUkwyUn+jjklPZeGO8CcLdwB2We9WKmu9BxTJaYyjQC5nrE6Edju/O9ncg/zr0gPWjkuo=
X-Received: by 2002:a05:622a:2cf:b0:4b4:9522:67a with SMTP id
 d75a77b69052e-4e6ead12f0amr281990381cf.33.1760384739785; Mon, 13 Oct 2025
 12:45:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de> <8f7ac740-e6a8-4c37-a0aa-e0572c87fe9e@web.de>
 <CAH2r5msRAejKX=vo7xGxMZDG_s++zZyHTazoFomd6GKOSt1XQA@mail.gmail.com>
In-Reply-To: <CAH2r5msRAejKX=vo7xGxMZDG_s++zZyHTazoFomd6GKOSt1XQA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 13 Oct 2025 14:45:28 -0500
X-Gm-Features: AS18NWCd3IA-GCOJgEu5wU-1WGwlNGLY2Cee4sZPgpXfTbOgHjuM5rizQnQvuHk
Message-ID: <CAH2r5mv46wgNC5E=y+0hU9u2SWBreBOU_=F9Y_UxYFRwo_Z-wQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: client: Omit a variable initialisation in smb311_crypto_shash_allocate()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Paulo Alcantara <pc@manguebit.org>, kernel-janitors@vger.kernel.org, 
	"Stefan (metze) Metzmacher" <metze@samba.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Removed from cifs-2.6.git for-next, as it conflicts with Eric's recent
patch series ("smb: client: More crypto library conversions").

Obviously one of the problems of minor cleanup patches, is they can
cause noise like this

On Fri, Oct 10, 2025 at 4:47=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> merged into cifs-2.6.git for-next
>
> On Fri, Oct 10, 2025 at 1:52=E2=80=AFAM Markus Elfring <Markus.Elfring@we=
b.de> wrote:
> >
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Fri, 10 Oct 2025 08:05:21 +0200
> > Subject: [PATCH 3/3] smb: client: Omit a variable initialisation in smb=
311_crypto_shash_allocate()
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > The local variable =E2=80=9Crc=E2=80=9D is immediately reassigned. Thus=
 omit the explicit
> > initialisation at the beginning.
> >
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  fs/smb/client/smb2transport.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transpor=
t.c
> > index b790f6b970a9..3f8b0509f8c8 100644
> > --- a/fs/smb/client/smb2transport.c
> > +++ b/fs/smb/client/smb2transport.c
> > @@ -50,7 +50,7 @@ int
> >  smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
> >  {
> >         struct cifs_secmech *p =3D &server->secmech;
> > -       int rc =3D 0;
> > +       int rc;
> >
> >         rc =3D cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
> >         if (rc)
> > --
> > 2.51.0
> >
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
