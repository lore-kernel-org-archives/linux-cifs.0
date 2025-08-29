Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF40211A28;
	Fri, 29 Aug 2025 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756487119; cv=none; b=GFozPxiwWOCUlNX3XrWj/AqR2DZwRpgCRg8XoJxkA2fKA9ATnx47Z24Zjxxdx/R8/adkcq5WKgkuW+GlgTKE48rvjgkQH9YXy3C8g0BCNzrJgsLcGcuYx0L2YeUQHBo9HJt4VhqVLwK4csfdfRJHsgC7np+eizEP1D55erf/phY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756487119; c=relaxed/simple;
	bh=rVzpQ8dQsRUwfUEEStWTmRiJwqZXIJLfkCDEBAMGKM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YcY2P+Q2u1SONLAL3TK0g5PqkkJr+tsRpP4Svb7U7+nbEYfIp7PKc4UIpoyCJKlOPV4PY0dae7u+ARao2AfYaCQsHb5v8uqqLKk/+IC2Tpl6MLE4ZpllwGKGpZgYiTGQ75nYAHSM1SDMeBkgBd1xjP5ed5OLYVdeNlS6RoGrk3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YLwrWViD; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YLwrWViD"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70dfcc589a6so19138036d6.2;
        Fri, 29 Aug 2025 10:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756487114; x=1757091914; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3C88U5kzwPM12OywuB+rF2YIxAqomnjTRojoRztls2s=;
        b=YLwrWViD/U73Djc74mTez4XYUYjy7oEUj801BaJG5XSXk8zW1rvifqG3xoizFw6AKf
         LuLCcIIF6s3PDC+9AMvK6YRPssLlaFsLHdH4Y+ZHmiXCe2XMnRfj0js4z37Qw6Ts9tGa
         YahhOYwWiMq7KaWo+/jEapwI4m5Dg5kSKmzD7evnQXsqigiQomiyF3ZFVZomoW9UkeD0
         M8n2AIprkE2ZWWphGK/WCgZg2k4FkQsmkfv7L0SkLf/waD7tcABH45sbTIWKdPig4dMX
         wO+yjs99FUqPhEYJTmUSMQ43zWKy1ohqTsHtVf4gI4n3C4x50Pj5nhQ+9WdKg5sutrjI
         +arQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756487114; x=1757091914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3C88U5kzwPM12OywuB+rF2YIxAqomnjTRojoRztls2s=;
        b=bF/cHLmBD6sxwjnVKGc5ZWBB0os867ynyfAho40m0hRHAdgNR89G/tzc2KVL/Hmti2
         Sn9ZONy6MvoUoA126vH4mMkpbh51HrO0xTKpoeyR+09WaUi1SEPxvtX5ChTaQPTtYlyP
         DIItde71Ht5/QLfYsAa9nzNuBMuUtBgY3s+FqZG5FKhMJoBDN1esSrg7JnG4wa+nLlKP
         3bSV6pNMg0y+p4yMvrRetEqk5EWxayf7azWt2Mp0D/MmVQ3Nb+ZwE2Qj3FmIMCygjbzj
         YHXQjVnNfi2FA19Y5FWHQqPK3ASc5w4I006dD/tDO3oFUgRO2BssSmtiJGcs9OX1vr3X
         4Ibg==
X-Forwarded-Encrypted: i=1; AJvYcCV+iJgnJcPOymNq+1dv3bghalyw5gI9SiVTr4Lg9DR2f5zMQ/mMl7uLEXTDVrUR+A4kSla6dkRjPO6b3MF7@vger.kernel.org, AJvYcCXNFtToMEvjQrBMbH4PjzNJcZPYwS9fv7C+DMIn8n+5rG24EteKYWR5omxlZpgRzW9W/OoGgKh2QTHk@vger.kernel.org
X-Gm-Message-State: AOJu0YzhnY4oJq6l8TBAvOxkls68mHNQrh+EB45bQCRhg5ADa3k4QF64
	YJJirWR7vryRnagBiStb/K9oavvaZa4Iw4dMBxoNrq3XnMsrK41rKm8cxzMH4LuU1ayNAL/9FQx
	n+aaX90g1VTnU5IDLykM/4BdqYT1wM+Q=
X-Gm-Gg: ASbGncsldwOPTUSeYLIfGobEFwDoHozLupX86/oFi2GX8JBGAE/FhW6ulabIIUyMjof
	e5hwzEfvwH8D1mKfHelQ6OMtjcBXLkIbYyneX180nM57Wmo1lVyeujOZmOUJHLu4uQ6Kjx+tMY5
	FUwh9Clnf22edehcWCpW1aGwTm61PLUVvvylcBDkKYboelfv2xpiHZoXy45uT2wIPBnmQwhIE44
	GJdgzWMXsLafKpxg2xPFciNvVmpzOUPiSu6KYcG8cO8NAEjzYsD+zVSRVmhWxvDUXveoYhg36Yc
	13R6hDh4gzwRo24awBmOJNXh4rXF2Fq7
X-Google-Smtp-Source: AGHT+IH5/bPmpJrEbJA1Mefpey8CWdyOIdL4hdYgR5neUNkk8HTJlBB5aQrDpjjh1yjIKxicNi0VvyhHikBUqoxS4sQ=
X-Received: by 2002:a05:6214:5009:b0:70d:fce4:1102 with SMTP id
 6a1803df08f44-70dfce41333mr55912246d6.5.1756487113776; Fri, 29 Aug 2025
 10:05:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829005959.2205950-1-wangzhaolong@huaweicloud.com>
In-Reply-To: <20250829005959.2205950-1-wangzhaolong@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Aug 2025 12:05:02 -0500
X-Gm-Features: Ac12FXyM9kkkTUmEVsTO_O9B9CpR17KHIvOcOxtu30NwSlCW_D36vOjlvcK5_Zg
Message-ID: <CAH2r5ms7biGGTARH=cXPz80HaEcysRQztYgYHLL0vLTaVRsOBw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix NULL pointer dereference in cifs_debug_dirs_proc_show()
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.

Merged into cifs-2.6.git for-next

On Thu, Aug 28, 2025 at 8:08=E2=80=AFPM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
> Reading /proc/fs/cifs/open_dirs may hit a NULL dereference when
> tcon->cfids is NULL.
>
> Add NULL check before accessing cfids to prevent the crash.
>
> Reproduction:
> - Mount CIFS share
> - cat /proc/fs/cifs/open_dirs
>
> Fixes: 844e5c0eb176 ("smb3 client: add way to show directory leases for i=
mproved debugging")
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>  fs/smb/client/cifs_debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index beb4f18f05ef..edb2e7f7fc23 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -302,10 +302,12 @@ static int cifs_debug_dirs_proc_show(struct seq_fil=
e *m, void *v)
>                 list_for_each(tmp, &server->smb_ses_list) {
>                         ses =3D list_entry(tmp, struct cifs_ses, smb_ses_=
list);
>                         list_for_each(tmp1, &ses->tcon_list) {
>                                 tcon =3D list_entry(tmp1, struct cifs_tco=
n, tcon_list);
>                                 cfids =3D tcon->cfids;
> +                               if (!cfids)
> +                                       continue;
>                                 spin_lock(&cfids->cfid_list_lock); /* che=
ck lock ordering */
>                                 seq_printf(m, "Num entries: %d\n", cfids-=
>num_entries);
>                                 list_for_each_entry(cfid, &cfids->entries=
, entry) {
>                                         seq_printf(m, "0x%x 0x%llx 0x%llx=
     %s",
>                                                 tcon->tid,
> @@ -317,12 +319,10 @@ static int cifs_debug_dirs_proc_show(struct seq_fil=
e *m, void *v)
>                                         if (cfid->dirents.is_valid)
>                                                 seq_printf(m, ", valid di=
rents");
>                                         seq_printf(m, "\n");
>                                 }
>                                 spin_unlock(&cfids->cfid_list_lock);
> -
> -
>                         }
>                 }
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
>         seq_putc(m, '\n');
> --
> 2.39.2
>
>


--=20
Thanks,

Steve
