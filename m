Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10FA36606E
	for <linux-cifs@vger.kernel.org>; Sun, 26 Apr 2026 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777215564; cv=pass; b=M2TwRlwl+p6vGrSnoUTkEdvFGoCRuInUJSSO/1x46HtR/pmGyoGmkuUETlpGRAZWmJxJu1ZQAVfDUrvhZXduUFqC2zjU2STWpTThRsut1Rz18YahrHQApR9+chtBRbstgSTu1681KILDrQHwssEdXfKuH3Rc9tKnz9BZaeFWv9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777215564; c=relaxed/simple;
	bh=FyclejuoWn+ZBtJ70nHrI/yW4N8y/zuPq8g0XnPXNik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=KxJJndqWjChyE8fWUJXYGP8aP6ZbhZdPgpILleDCZvW38okt+ZQ5yMT01E6PyMpqHCgoFxyyf3RA349CjCpOIn22JfFLNHn/tUIW8BtThNJk5pNZjgR+Eb28GL09gEMKglyGLsd3UnS4Qu615nhIJnn8ApbwAsKZaWBtxJa/AfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSPoYPSG; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSPoYPSG"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a3342d301aso92816656d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Apr 2026 07:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777215561; cv=none;
        d=google.com; s=arc-20240605;
        b=R+5r/5RZxKV0SXNsJiWuyjsWxeHC6N4kalN7P8yFLFhOzWRK7XnheeeGMUY3g6hY0j
         jhsxEefe/rA01ULKUBkPfwPMknK6Ax4hUeAMZGuNxuoyGhUuv3dm79AFwyq6glIW8FbW
         M6Idmfs241LdRIdlLvwW5386su5yTBkqmU2wDPoWWGIMDBuzqPmH5nNwMzhlWkc2CKGj
         qkDI03CWfSKFtyPTNcrD6dpCGn+sSlUijJp2IP3JxU0OM//JkrPuL/qRvXCfUwbQt5e0
         ZgVc6eH6rz5afTUpRF4HZYCPj80heHDj7/ryV1beJ/kYS7la70619WwVpHFBe72UuVuC
         p2dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zF0mSkpCTd9gf0y2Vh/4eRYgli1GbY5jW0zYMELFAZU=;
        fh=GydoE0dVrH5U3riezLVKMH3u3AyK4m1H8UYvAkR9/9Y=;
        b=XI96Jm6U9U/Y1Ym+OnKT1w8qxeORyDIa7LE6Q9FVkmoxtP4axuElixg+6i8bI7vAVt
         pFyQLZG7+ZhXY9LwDYt3N8fzpKEzhsb3Wit9aFubmhQAbbQfKDM5euBhSrVZ+0yPqzBi
         DcM2bEP9PglIlzEC2wv571AvK2l91VDm9SYq5/23i8kvB53y25evfXMMzMfdjTozKqsI
         6lPyEbVpMTKWvR8ccCJCeDBRdDyH04AibGPidKvNBets+pL5cw3xqFKVPLxB5NlBl+ix
         6zVpTBtQBUgF6XpIQ236sL1p+qwwtLtcCTF+WaEuH0OGPC1JtHtQ0zzenUooGQYewWcf
         ecKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777215561; x=1777820361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zF0mSkpCTd9gf0y2Vh/4eRYgli1GbY5jW0zYMELFAZU=;
        b=JSPoYPSGsc0JYGdvpPFVtsVOdCiGgdc9w394x9mS8iT7NhIqqBJqgPaMKEGohPcQY5
         a3vHcKQJQxHLPaaEODrARQlflEMteyWeYXeO3MsdO+9ei0SqQW+qCfDM88/Xuv5B1rin
         kU1SOiXTjP4+kYZd1UDDSy0m3Czmy1wgzLcxEv4HOiFLRjltze8fKSR1oPAZgV5RO4XI
         XfHvj90qDfbpul3cknEHV64LYQihwHkW1hpolB4Mk/iO45LmBak0aftSkOZkb9P7MCan
         mn1d4Q8+EOM7vusMNHc+YVdBlej89esq+diW7uV0gHrnRrYLjcPz86BwCr+Lb7e4ZqZ9
         I8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777215561; x=1777820361;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zF0mSkpCTd9gf0y2Vh/4eRYgli1GbY5jW0zYMELFAZU=;
        b=ioArYaijMB4WPwUcgNmhKICqI/5XGgoGONcUNvsjjmehms19C3zwfi6VMaGLUJfkdO
         MexX1ciw+lBRNxCJbclDiSH5/75O4nXBXBtFwTUAs1gNUpa9zFdTy1k+rSeswwBm3b1Y
         QHF/JiwVOAJRpBwxI8nk/sJNXqdde7crD8Smr/uyq8qgy9trFjoNrpIacY4ICsofRgGD
         PADktB9dN+SQldPj0fmWHqBJRoK0c9OkO6eR1kvHT/cY1kaaq9AL0bMPVkTWocMZ6sue
         tPm3Ju3edf9z3+xhNm4di3l1uyOn9LjiQmfLK1fuwH02AjtpjcTOCQyaHAIRayX7iDVl
         bkJg==
X-Gm-Message-State: AOJu0YxbTEZ9YFdtVCdBt2TdFpsgujtksIlz2Y54q/45fWvPYBsrJZBP
	YjoOMc9fWNu7sMzqdfLjufjY+/LJ5rcisqRoAWecxjkqBKrFhiQpjllvu72elgU8mUR+MVA19dj
	IQo/GPK59pC2VFQnCB4/I/iMh63mJ7AKlYA==
X-Gm-Gg: AeBDiev+s0w/pRBx4B2ihlbS5zxm+4c6lVzjiq5/mWcer4V4H79gUg51nt5LQIXD6xM
	LAjJx3mb2jHaTuhxH3RZoD7PPtyzTZhokcKYkwBQo0nskQ2CtfyA4OhY/EiRvyfphQxkRrwo/jb
	UQMKT5lIQUPEI/jprOfcUraGLzEKxtY/wC3porI79l9fm5i2eLa98MTy6zZJ98+iUFkm5bUl6f6
	uc9nts2VHZSpzHEQ7iOzU7u5CqFVDcdF+qbrx7VIMDbhWpM93G9sGkPeIYQxSHpNAkZ0JfvACGQ
	B3q58FZahlzZNs3nT+BWxaopb3JKEWbDSmLeJJTWkqNtAzv0FinzfvCMyNgx/lbLQj656E4CKet
	/XPCIxngAOrOVVSdeBCHSvOBh3LUvygIN8u/qrDT7OkYMIjvNhLMw07WcZXC/TfE1b+aMbORDxr
	Obd+MuQsniXt0v+cnui0Op7P3tpGhBy90=
X-Received: by 2002:a0c:e008:0:b0:8ac:8cbb:49bd with SMTP id
 6a1803df08f44-8b028114e9bmr592609036d6.38.1777215561570; Sun, 26 Apr 2026
 07:59:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260426113937.30818-1-ddiss@suse.de>
In-Reply-To: <20260426113937.30818-1-ddiss@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Sun, 26 Apr 2026 09:59:10 -0500
X-Gm-Features: AVHnY4In-YCUMovybsGDnc6igsUH1JOaZJREkKU7lgEcnJzuPFUKw0h3-QvHlIQ
Message-ID: <CAH2r5mtu3CR+YLc+AzUW4Q00dZcumxKGCjHJZoj76yweakW5ig@mail.gmail.com>
Subject: Re: [PATCH] smb/client: remove unused smb3_parse_opt()
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next


On Sun, Apr 26, 2026 at 6:40=E2=80=AFAM David Disseldorp <ddiss@suse.de> wr=
ote:
>
> Commit abdb1742a3123 ("cifs: get rid of mount options string parsing")
> removed the last caller.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  fs/smb/client/cifsproto.h  |  1 -
>  fs/smb/client/fs_context.c | 31 -------------------------------
>  2 files changed, 32 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 884bfa1cf0b42..b7cd67b64a833 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -89,7 +89,6 @@ int cifs_handle_standard(struct TCP_Server_Info *server=
,
>                          struct mid_q_entry *mid);
>  char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char d=
irsep);
>  int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)=
;
> -int smb3_parse_opt(const char *options, const char *key, char **val);
>  int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
>  bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
>  int cifs_discard_remaining_data(struct TCP_Server_Info *server);
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index a46764c247107..6433eb2093dce 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -536,37 +536,6 @@ cifs_parse_smb_version(struct fs_context *fc, char *=
value, struct smb3_fs_contex
>         return 0;
>  }
>
> -int smb3_parse_opt(const char *options, const char *key, char **val)
> -{
> -       int rc =3D -ENOENT;
> -       char *opts, *orig, *p;
> -
> -       orig =3D opts =3D kstrdup(options, GFP_KERNEL);
> -       if (!opts)
> -               return -ENOMEM;
> -
> -       while ((p =3D strsep(&opts, ","))) {
> -               char *nval;
> -
> -               if (!*p)
> -                       continue;
> -               if (strncasecmp(p, key, strlen(key)))
> -                       continue;
> -               nval =3D strchr(p, '=3D');
> -               if (nval) {
> -                       if (nval =3D=3D p)
> -                               continue;
> -                       *nval++ =3D 0;
> -                       *val =3D kstrdup(nval, GFP_KERNEL);
> -                       rc =3D !*val ? -ENOMEM : 0;
> -                       goto out;
> -               }
> -       }
> -out:
> -       kfree(orig);
> -       return rc;
> -}
> -
>  /*
>   * Remove duplicate path delimiters. Windows is supposed to do that
>   * but there are some bugs that prevent rename from working if there are
> --
> 2.51.0
>


--=20
Thanks,

Steve
