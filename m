Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A97041A8F
	for <linux-cifs@vger.kernel.org>; Thu,  2 Oct 2025 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759376402; cv=none; b=StvQ6PW8Hs5RAaAUOKB7qR9s2sxFyIibFFrYD2iZnFD41To4xozcJVqE+H/POwk4vlkhCOltXRmtHBGIyaLk4EKRX4bDUirbRkjUQKR8rCxFNe+HUmgx2gpfeq0uKzJSjh83ehLL38tvg3HNaFXA+UJWrua/JiPj9lCLYtZuYNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759376402; c=relaxed/simple;
	bh=aaUmqloiEV1h2doOf5xLx1I5IUvQK38YOV/LmMeiyq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EmfvmRAhkBF3TdgdpVliV5/J9jAeKKqqFJi5j9hQwFFOkS9JjjI/ewjJfyGmT5SgLG1HNl9WxNZz5QBui2UvGYFhIYyAnKOU8z3iecBxuq1BkhL6a5tm+FO3Nx0D6/nEnAD1j9XisLgl87m6x6EDpxknH2lYv9fPqEszAiNOF/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQPvKz7p; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQPvKz7p"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-86278558d6fso46349885a.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Oct 2025 20:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759376399; x=1759981199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwgKf2GRghji3XIeZ30AgjaDwaFXa2MtOyYBsSAbeH4=;
        b=lQPvKz7pRpMg6rf3QZfqBr5trJkLy//OPzmUGSWVrp8B27TvlVUTu7kHRFzVEHKVgS
         7AEZW8qU0Pn1chu5lfl4/8W1yo4Yf+8uSpJ72UYmXDXFEGETf3B+BXL8TOTY3xfTsKb0
         ockA7qZZmsOyRTo5cSsJm4MGX4GOytJ870hud0VIkxj+oxvTalfIKUSNnDSSAZRtPXvI
         4UUrK3IuMPYe20izp1xjxG5ZQLrzgxg1Lnhz0sSSfi2ZVkPFtb61IgjLI9kJToeEvVej
         AcClnCA2nrU9NPa8DB1lVxhPsjZwJHHzHBDkwH8olIaEdoRNVF/AI/7ah1QBLGojGgYj
         eVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759376399; x=1759981199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwgKf2GRghji3XIeZ30AgjaDwaFXa2MtOyYBsSAbeH4=;
        b=tyjJfws73ozmyNiYmmId4XKUCkImQYtFnF4K3GNbIJtYDpfOkItkGJIhCJnJo/rYqZ
         9BuQyj6KOGvLgeYQEu0/LqkzBsC0RZbfcdGuzlX8Zn2aO0kzPpIiiAl7XfBqW2Ybn1o0
         sJFw8ufOxpWL36gwW8wy1pNEERK8n9UxQI9hoGhf/G7s0LoTUiM6MGpWaMink/Vyj7/3
         X14zhZRxyE16lGYQ41peK/MkxexvzR4xDftgKSxlgcJ/d7JTr8RsZxcB1LRNB3dfnf7p
         aCLeWJH33n6zBBpWXf6+wD9wpycFSKue9l6E+5NeX0RrvGjyz+lrlRNwkLU0BWXUtVVg
         RfOw==
X-Gm-Message-State: AOJu0YzeELYRMwhiTMDMRDU+k08qW/23guAGkFT4US1Eq1+v7yg6N9HT
	cvMu6wweGuo+YJdymVbJGL7zpS57+D30zy8G/SbpuRyI3xF0jm651S4XU6Pvwn6CVy7FQ01dIg4
	uwosGJjckZ94spTL7mDFzDm0pkGLadnU=
X-Gm-Gg: ASbGnctNlfVwc6AdFD61cOG9mrxqfDbUJjfaqOW9nMe9GZUjZIJofLsljBCmoN8BfxU
	6i6DAEsWZlCuBKHWbvXfZBgifVs/597RbU08D0qfs5egwkrRQPVXuMOvhLFQhGqjj60zgFKiCA/
	1v30svIOjhVftaw2kXQTRaKsdyZ7ttrDiyLUzPapLL6myzLV9wkJifE7zKXiYSaffmxZQymYp/f
	vrq3GWGiOzf19xgjZFiMc98dI3Gd0krR39IRff+y3p67lSqLV4LmJSUjXNOyOU2c1OqIGtBoI7U
	QMLssScfPYmkQ9EaiV8qsBPHpJNOYd9pdHQOphv7txfiMGHELWoPMwbos3HMQkPaV7ulEUAxFE8
	6KTLMLTuboQfPn7pQsj2h
X-Google-Smtp-Source: AGHT+IGYQVD6e1SHVrB64/Xp2eoqmfoFMdkQT+5F4yM02QCT9gAFW5Lbl1VaUEb8Z8Q+b5hIQBNNHZf4SKWhYgNw+Wk=
X-Received: by 2002:a05:6214:21e6:b0:7b4:d622:84d6 with SMTP id
 6a1803df08f44-8739dbd4220mr68646856d6.22.1759376399150; Wed, 01 Oct 2025
 20:39:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
 <20250919152441.228774-5-henrique.carvalho@suse.com> <woexc5yya6d6idhmkasx2hwppdcydldhsdb4rhr4a7rj24tk66@exwhhyxh5ojj>
In-Reply-To: <woexc5yya6d6idhmkasx2hwppdcydldhsdb4rhr4a7rj24tk66@exwhhyxh5ojj>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Oct 2025 22:39:47 -0500
X-Gm-Features: AS18NWC14zuAVNVrPqXq2nuJ-XSUj2OtsIfgQ6ZyRjZwaSCaCgeIjv1E910k_94
Message-ID: <CAH2r5mvXztpAwUCqGf5XqzFU4t3WUynbQfvf7-95TZ=uAgA2yw@mail.gmail.com>
Subject: Re: [PATCH 5/6] smb: client: remove pointless cfid->has_lease check
To: Enzo Matsumiya <ematsumiya@suse.de>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	Bharath S M <bharathsm@microsoft.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Had missed this when for-next updated.  Added the RB from Enzo and
readded to cifs-2.6.git for-next

On Fri, Sep 19, 2025 at 1:55=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 09/19, Henrique Carvalho wrote:
> >open_cached_dir() will only return a valid cfid, which has both
> >has_lease =3D true and time !=3D 0.
> >
> >Remove the pointless check of cfid->has_lease right after
> >open_cached_dir() returns no error.
> >
> >Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >---
> > fs/smb/client/smb2ops.c | 5 +----
> > 1 file changed, 1 insertion(+), 4 deletions(-)
> >
> >diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> >index 94b1d7a395d5..e6077e76047a 100644
> >--- a/fs/smb/client/smb2ops.c
> >+++ b/fs/smb/client/smb2ops.c
> >@@ -954,11 +954,8 @@ smb2_is_path_accessible(const unsigned int xid, str=
uct cifs_tcon *tcon,
> >
> >       rc =3D open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid=
);
> >       if (!rc) {
> >-              if (cfid->has_lease) {
> >-                      close_cached_dir(cfid);
> >-                      return 0;
> >-              }
> >               close_cached_dir(cfid);
> >+              return 0;
> >       }
> >
> >       utf16_path =3D cifs_convert_path_to_utf16(full_path, cifs_sb);
> >--
> >2.50.1
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>



--=20
Thanks,

Steve
