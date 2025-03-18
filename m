Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977624A07
	for <linux-cifs@vger.kernel.org>; Tue, 18 Mar 2025 04:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742270488; cv=none; b=HvK0te1Hvung+IZ4NUqQlWJfjdZonej8RD8hXT1LJnbhvMjovSWnKFqMrbaXe79IKyWJbWcMZEMuV8X4XfGT11t5DL7NRVwhZQlLZijFkbiWBReJ3vFAJ79PHBlI7GOXPPafedefhF05BSo4kmsUvxf4u88UqqSmzc0pSHOgTBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742270488; c=relaxed/simple;
	bh=ci9XaiRUNpClGUCP6ozOqJwx2cdMzpC3F3WPbXygzZ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WogV3LLndbBYr3Tq0R/WSSKGeKm+rOYZuR4nk7FAgHr0icerhfZbxPWQMmOd7D31VSpN/T2HQ4/URW/EE3ELnWZhrMrZB6E1inmCGWR+PM5KEBF2I8zJ32xjmBRIe2cDyc33XbW7bH+/y351vSK4cvAFL2wJ7epdPrPoFfBmjCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bgu+21xq; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgu+21xq"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-30bfc79ad97so63876931fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 21:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742270485; x=1742875285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpzrzU/I1EmT33WE64mLW8tFsGXCmXmbqyFjyD7nefc=;
        b=bgu+21xqF3D+LLIL9/bi9ZSalbFPKmGzSrfW1Wyg4ViWSu1j79iMyOLddcbEFodjzt
         7QbmxrbhTc+6qb0571M8NzBWosBAgAfC4s2DzugvFiWf/F7l/UZNanoLU8SIRnuAu+Hn
         EP2eWrUM/108mEENdwfEkA0SClSe5GGKBSp3lIs0d8GR6uyf20im6eVCRwcTbBZH6eTQ
         HBQ6PjlULvPNKrgI76iapnUE2cCkYblSqj/WXdNzi1a8YXhg8Z7BaMf++6/2b2vLdvjq
         UcYYkN+N0YYxXpn1mRWa4OcxcxyepDvfc0GLnD3T95HvAegJrSuPeYJcptgq/H0XJ1/q
         IcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742270485; x=1742875285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpzrzU/I1EmT33WE64mLW8tFsGXCmXmbqyFjyD7nefc=;
        b=MI/N9cvLXosgBMmwdy5iqg72UHX4+PqLyYCbVR/Jh4OBjfjgqgQLRyfAFUzIAGzkBC
         coxYobfmeGDjiLbdSBj4pe2saDeJd3GTPQV0pTsnIDYMxJ7KxPsGERhSeRo+YkFaCuVv
         LYnfovqd464ZHQfLGrAnnwY6Rq4og34dSbQ/59oezcNh8VN8msg4mVUDpBPyKYwKW5ID
         IugGB5ErSOEiD7VOyz7YCe+jHMnWksp50woeDoZiqJN0z+UI9Nb7q3YxCvrPSjdeoTyi
         6p8h0TriYX6tINZ9WURQ6RG+CgmJlghLrWlbyGrU1Bd0IEYeF/83LCVRWQ6zZnb1aUbD
         dsVw==
X-Gm-Message-State: AOJu0YxpmKBi/qaV4FmUb9LbH3F0oNVanbUTd2mLjkbkgWJHc+9SJXw6
	9K2e/Trj9LERdjYA/uE1xptRZMjKRbp4hkEXZPxhu+1VU+v/grz9juY8M5Nu0VMUyoZxLdYrWV3
	91adEaLS8gX0cZlfyxwWdCla+rhkbkA==
X-Gm-Gg: ASbGncu4aLqMSn/1hD1qds8TGMwh54slX1pj7cIPR/LSJPcsrwHm48iyVZOAaU8+n3e
	r7jAYketFQ6mK9O0iZ0CqM2eoQrL6oys0JmAb/XUTnUcu9xHJrOMDn37SvObCHT/Zv3O71+BFPY
	5knk3VkwyRFks8sngycQv5DbRjiQWkMbtiEtnKsSnsCy1ubqXIuRC8MjiJoMc=
X-Google-Smtp-Source: AGHT+IGjMq6EdhfOU7z3JA615fo3IdkCvMfvqRYUtDwYC4w9qq/94S4ejZygCQ+6PcfR38fuSq/WZcg6YDUNIszEJtY=
X-Received: by 2002:a05:6512:3b8d:b0:549:8ccd:4538 with SMTP id
 2adb3069b0e04-54a37353eccmr1886204e87.26.1742270484363; Mon, 17 Mar 2025
 21:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317102727.176918-1-bharathsm@microsoft.com>
In-Reply-To: <20250317102727.176918-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 17 Mar 2025 23:01:13 -0500
X-Gm-Features: AQ5f1Jp4shBOxx7jWVm7hNK_u4_pgxRcsymKdQpfHebjZ4VbiaJ-th9fiCNZwk4
Message-ID: <CAH2r5msjYwZa2H4oxuddGbbhbCH5=qsPMEQdYRmiYHSiyvYaKQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] smb: minor cleanup to remove unused function declaration
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, sprasad@microsoft.com, pc@manguebit.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged all three patches to cifs-2.6.git for-next pending additional
review/testing (added Paulo Reviewed-by)

On Mon, Mar 17, 2025 at 5:27=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> remove cifs_writev_complete declaration from header file
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifsproto.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 81680001944d..39322b4931da 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -592,7 +592,6 @@ int cifs_async_readv(struct cifs_io_subrequest *rdata=
);
>  int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entr=
y *mid);
>
>  void cifs_async_writev(struct cifs_io_subrequest *wdata);
> -void cifs_writev_complete(struct work_struct *work);
>  int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>                           struct cifs_sb_info *cifs_sb,
>                           const unsigned char *path, char *pbuf,
> --
> 2.43.0
>


--=20
Thanks,

Steve
