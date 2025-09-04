Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D049A30BF62;
	Thu,  4 Sep 2025 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757004339; cv=none; b=a8TDDYizp/glSXsCfjbMvrReQlQKM6QJzgQgWs6aELxjCfMyEsd699803T8bngjKlBQZBEdLhAtUAfR3I2dXlbcKyKro5AzCxn9/K/HqKhRNnlxyoncI4KHTpTROB19/HPZlgCYShsIAumNQmz0kgpUJi/YGBDLt5JDTSbw0u1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757004339; c=relaxed/simple;
	bh=z58fohIHjEeQhEpGCki3vj0PFTuHZ0s0bq9O6Orn1Hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Us0INkKyIrz54gCNDIe2qEsuu3PiTZVx6nvmGHmb480fqlyrZpYKI/OK8ezMYDsUBkruEXqoTHOX0nMv8deCeo8c0ILQivghO9C+n0FoTI2AdgbdgMql4emMddIpAV0pifgZvPljmhBJ9kpXp+Q9K2/8poAJ1py59Nxm7ppsKfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TuqE+LEe; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TuqE+LEe"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-722d5d8fa11so9703136d6.3;
        Thu, 04 Sep 2025 09:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757004337; x=1757609137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ia2wL09QeCuJKNsIERP8tUdHVHMgM08COMkA9RM3w9s=;
        b=TuqE+LEe6XrUKi5k8YtEnASxH5vkF6UDPfqVBoTey0p4bKZOQEdIRk80jitzTw6oID
         Jzcx4CpAztPp7oOlZvSmrZgf6Yn+ud9D3v+Fty1Mv4Bhoi7j5oYZI9Ecf7RmggHvfO77
         t7PzdlkWPfSKXh01BpXCtUmnWX81nv8S+cLioZFTLjrTZQaHOs22XF0yelKpyyo5Ci5z
         XD/Ag/YyEDOAjIqHjlWVM1b7eAcn4o7mzminxwPVQa0WJHVa5sPiEgXT6Ha3454CLjd5
         vqB2b/fKxzvHgfB86URAFkyOL8mLbaCLz3DApU9lLqYq8UbXLuwlPBHTcC8fIR6MigOb
         c+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757004337; x=1757609137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ia2wL09QeCuJKNsIERP8tUdHVHMgM08COMkA9RM3w9s=;
        b=osSfhz2sXm/syZ9PWW1GVgQCyBIm7TZZ2h8N9bo1g7OSoD36HhGDaqH1bNwmAtIUHV
         VTFA5Nskt/VOKEIKr7LcDZmCiXjNlplP7q6+rpEnwlu/vrLXg/Pw1aoLfgYTlYODz2nr
         5R/7vRqPnHId5q5sC+gSwKlPSnZttFGbr4gGKhtbtO/DR/OSAPnZwExcID3cGvByvJJ/
         nEg6tr69r+C/m2DdKuesbz2AVrKteZpiig5NykfYgRHlcH8B28h9X8jt8EZnsX8kI9+9
         ZAqVlrXUOX8psdf7E91Wk8qQtJbErpzUq3c9M3rtGtWztrH3CmafTebbWA3ZYbkSCfZ9
         iO3A==
X-Forwarded-Encrypted: i=1; AJvYcCUMl8RU+5qeb++W3Kki0ynegwy77I9y5rlz6cwkiW/FhwrZPUEZmhAggCfmkDcF92t5iyKdR+JKvveG@vger.kernel.org, AJvYcCUzS5S1ddc0fh9Rb91Cv76cjUMBB2tby0TUDJMYDbuiVmKgW2Hm+dWW9StDSZgK6VIS1WdEnWH46UgIOET4@vger.kernel.org
X-Gm-Message-State: AOJu0YwnWQo627AwGuFEcvLy1WROPIEzyZ/A/YHU7QRMgGZnlOF3v2py
	Z9jMdIkU+WqlH3JjJKjNui0qfg4WWKzBym9MhYrzn1zgRMjP6aFlyR7HhKS6XdN9E58bZ7OXO7V
	sllJTJ0TFe2mr4rFgT0WdcFqXz3bbUtk=
X-Gm-Gg: ASbGncuVM/Zpzzod+OpV42Tw9zzs8EXWy4CX211Z6XCuqj+l1qgJVeKIpAYfD+qxHiI
	U4QmyaNDd36UptLs+GXPbXKoABaolNNdsZZViJcGqW1DHsXLtSBNnhfhI4eRsifrY1Z9vcDiCyQ
	dXI0P88kKZ1t46SQ9AmygN8Be1spyGmXSyUBWo1fDtjgsfomMZuZhMSpfUWrwlhYQ8kuM/NTzEI
	hXdHLfWVT7Finh/PWQyzQ7Gqb4sTS1ZLAl4/LdWJnqnj5P9JeJtCESWv+Hxt7lcEG77pgS3f7tL
	RSIfNILfrfawpiMh+uMlugdWQnCXATLeFnqJkYwc6N5SKEGF7jj/EnGGkJUkpRQrrQ==
X-Google-Smtp-Source: AGHT+IEOxRfRzqGB/cImgAzKezg7nrkWN8WIrkfhgbzxJ6FrrSUzVS8xZTgfzxjmRnWACFC/rVa5oZtvvBBmGBWnmqE=
X-Received: by 2002:a05:6214:19e6:b0:729:9ec8:a1a6 with SMTP id
 6a1803df08f44-7299ec8a2ccmr27704906d6.53.1757004336633; Thu, 04 Sep 2025
 09:45:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904122843.1681269-1-m.semenov@tssltd.ru>
In-Reply-To: <20250904122843.1681269-1-m.semenov@tssltd.ru>
From: Steve French <smfrench@gmail.com>
Date: Thu, 4 Sep 2025 11:45:25 -0500
X-Gm-Features: Ac12FXz8JCL0cueiu-FAiIyvutc7K5G4KwOL5gaJEZUTzbvJ9TsJjvr8PLVZ_uY
Message-ID: <CAH2r5mugqRXD_OH5m_+1dyPyTEmH-Rpdq_6zDiGB8_XOHOMH9w@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: prevent NULL pointer dereference in UTF16 conversion
To: Makar Semyonov <m.semenov@tssltd.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next and added Cc: stable

On Thu, Sep 4, 2025 at 7:36=E2=80=AFAM Makar Semyonov <m.semenov@tssltd.ru>=
 wrote:
>
> There can be a NULL pointer dereference bug here. NULL is passed to
> __cifs_sfu_make_node without checks, which passes it unchecked to
> cifs_strndup_to_utf16, which in turn passes it to
> cifs_local_to_utf16_bytes where '*from' is dereferenced, causing a crash.
>
> This patch adds a check for NULL 'src' in cifs_strndup_to_utf16 and
> returns NULL early to prevent dereferencing NULL pointer.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE
>
> Signed-off-by: Makar Semyonov <m.semenov@tssltd.ru>
> ---
>  fs/smb/client/cifs_unicode.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
> index 4cc6e0896fad..1a9324bec7d6 100644
> --- a/fs/smb/client/cifs_unicode.c
> +++ b/fs/smb/client/cifs_unicode.c
> @@ -628,6 +628,9 @@ cifs_strndup_to_utf16(const char *src, const int maxl=
en, int *utf16_len,
>  {
>         int len;
>         __le16 *dst;
> +
> +       if (!src)
> +               return NULL;
>
>         len =3D cifs_local_to_utf16_bytes(src, maxlen, cp);
>         len +=3D 2; /* NULL */
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
