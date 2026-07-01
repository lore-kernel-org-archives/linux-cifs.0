Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2EC370AD8
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782924841; cv=pass; b=ZA+DgwxK8nlXR6p2GZhmxFfuQWxydDQ6s+jd6XY2o374iECTuZK5tPV5ILWvOK6nZ9LnWd+k6Ijz/GhaDK33mmnF3dMNxCr/uNEjuhV1dh3KsITlnS9I9tiKfM526N5Kz6RyDa8WBjtGzoGmDrwoZXOcWie/d3ob3zbQf/X3GtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782924841; c=relaxed/simple;
	bh=/zOjjc42EakNoyDjDVh8gkia55+68gY8XTD9YLvq72k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mhb/y7JHl9J+9eSDaFYg/MbVdi5Cs3hjad3WpaOU8XO7vilAmNAnhulBnLrSHtTNX02LzdLuWn9lLvisLkdM3WNfYdjMsEjgzILXG1vFdzfHjYdkxMtqlLNh8fRuQLpN99mtnzaOn/Q2FdDdFjxGTdFzdTBPgv8k69cVleceUqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dOSdz99l; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOSdz99l"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8f3cbaef818so5179076d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 09:53:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782924839; cv=none;
        d=google.com; s=arc-20260327;
        b=eWbh/P+O8N5utM7dsjwrYpDYVaVNkkdViewOro+dDewEjg5u+bysveDSpYLCnHuW0s
         mymhz8qPQWJxHJ4HKNfZ9mf1/ljhryWdoVhGnBd7NTy+7d0ZE4sjM0btc9S4ZqPdqMM2
         DaxHwIkW01ugcBJ+tk0hLIDjLYiVKR9/bLht7gdinx54qNfKuUKK7K4fLZpMFGQWddFs
         OGdFSLDOlVfBuJga8SOtnEpMuzF5i/8fvVkdifNPZKZwSfn9n2v6rmSuJKpM7Pq/htWB
         LVW6TjIn8Vf4WL6qqBZfbMS8qkRF2WSBYyMLCUzLW7Xf0NZgxx4nLQGz1wBn/qKlJAzJ
         I8Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qsT7Aucdo3WB1/6wu36t1SsQsjdxfjkNbvdDVuWW4Xc=;
        fh=QLwhZa/DH9XJT/cGPdtevNKN5L07PBEhyt6AVsIEV14=;
        b=NgG7BpF4rk4WfvWfJrwlSR+7JBHNAP2hrojor62OXMAQjCm++OnVLv289lLWU+05JH
         0ncftoMCWFZWno5t1EtkQgGEsFcHZrjU2QyFXIy5U0DHK8tNCH4+bDRgOg0zvGgoCkOo
         M6Lkyl0eD55dNcSD5y2GM6JQlIid2juqubFO7p09hzT5d2whO/ZC891z/UGZYYIm2ix8
         arIr5mpGaB3X4cawxCwyF0XZSwQIo42ytyBSkB6JZdPUv3CH1Kw+wBvGLhJgUwZ4yhDV
         kOP3KlsOkboHCGWKQPypoo70FDB/zVL/5Ktj9XpBibGFjMVYVjxhSEVPyVL4GW8Dl94v
         tbIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782924839; x=1783529639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsT7Aucdo3WB1/6wu36t1SsQsjdxfjkNbvdDVuWW4Xc=;
        b=dOSdz99lNVVTnoE0fFLtUuiWd4YkifXGXr7H+d92/bM2tiyQri6QntaCL+ZRX37lGZ
         15pOpGvlSYEmuLtmTiPrJArzp8yYvn0tnp+doRbRYkbqipA50F/5LyEjns4gYjUKPlhw
         lBv7PWOyuxAMq48To1j/9GjrJHeX17zhSeS+XjktzTnwrYSWkYHjdpygns0R81NZrtrl
         zrpFXlf1p5HsMT6VAVSSmg/UiYCmA+3kv+WNmhg3hmYBfws67a6EOE35eCzOf9WISEin
         R3WrnA11MS9A5gy7EvQdeYaNqEcjtBqZn6fh0e/NdZeVE5DlzKre6allrALl62r793oz
         EVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782924839; x=1783529639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qsT7Aucdo3WB1/6wu36t1SsQsjdxfjkNbvdDVuWW4Xc=;
        b=Q7165sigkMs4lGHseMzp7AueP0IoTV+T0HHqG12apJCteBYI7Q5kF6uuh1Wf8Eqw0O
         Bwo+IkSNXqPMcoXc6+gDdJon9yutuZ2dZ6UMCWmiLXRx4mXR7oK89DSpyijUkhVZ/gtz
         0gOpEUSMTWVT2eZeliX97Y+8fzjClsLHEfyW5+w8++sX63Gx67kD4QwHFhIQvgLJk3bF
         aCVu5SHnXj0xIL+asDmq9aRF/KC/9rXcwF9+9dPSSeC/HpQj1IUdjGqS95wssVB25JNz
         +b5wt1LtTWK27O6I7nIubc0c950j9pnPYGpsgV1djOva3mCICAvSS938q34oC8fQaIqx
         KVLw==
X-Gm-Message-State: AOJu0YxPwp/dqAWR0wJ36XbyI8jqNuD3hBqSs7lqLCrU//5ryq7OWIO8
	s0M0IhKeZGnJACMUNj0PpC53QL2P0OFVUAGCwG1NsaX5VhjLTy1tNB2xZYZ+pBSyx4xX4SPL2sz
	rT8w1n07v9VCrfmXlCNlvYupzYFqq1qQ=
X-Gm-Gg: AfdE7cnz5N2KyKpc+1O6Q/gPtjsIjkp4DL1OmOAS8As0m+Z8vqSe6NTWUWEy6OPA606
	+vjE5fh+qDE7erp53+JOrpcY4fIkh1wogWePrFD0eZ1pWuoRHSuCJU5GrGXcrAhItAzFrbtCqz5
	4y7OyNJ8xUpaAqqI5BPLbOkwKLFxhgOErPdeHFgjna42SL764ApXKYYv+ZQULEWZJ0VJ9SdfY72
	FULy1loZY6hdCFOAqAsJGTmgltSYDJcg7v+91/AcxV75KxfXUV/86jLlUSZ7lsuWu7P2vFPAmI4
	5ovU3aGa7IKdxOOz0tYYFOGzKlY7imWLQv4/odwDqauZFqApQTT9DMv6yqZAPBmzfgonNt/dRRJ
	FlCcOot9bhsJjlLFNpXVtVJ1UcG17GSuJ8Aw5FjiwZKw4c8UAL0QJR1uauptE43+f2EN7ICUtVo
	sQbM1FT0Hv6Qg=
X-Received: by 2002:a05:6214:470f:b0:8de:25f7:98bc with SMTP id
 6a1803df08f44-8f3c76a6861mr30338866d6.22.1782924838802; Wed, 01 Jul 2026
 09:53:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782898568.git.xizh2024@lzu.edu.cn> <60461bf5482d51ebd950fc84fd19ece9ac1917fb.1782898568.git.xizh2024@lzu.edu.cn>
In-Reply-To: <60461bf5482d51ebd950fc84fd19ece9ac1917fb.1782898568.git.xizh2024@lzu.edu.cn>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Jul 2026 11:53:47 -0500
X-Gm-Features: AVVi8CeP-uYebO_940PnvqKmRxHZJ91p4BVXyipkQta1aLMLRiTtTwvpSlt6XZA
Message-ID: <CAH2r5mtndSB-94YqcfNJMxJ2jDYbVdsBxeRvPhj6EeJqjdpFng@mail.gmail.com>
Subject: Re: [PATCH 2/3] smb: client: check posix_info_parse() in cifs_posix_to_fattr()
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, xizh2024@lzu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ren and Zihan,

Thank you for the patch.

I have a concern regarding the placement of the error check. It seems
like the check for posix_info_parse() should occur later in the
function, specifically before the two lines that utilize the parsed
output:

sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);

Perhaps we should use something like:

if (!posix_info_parse(info, NULL, &parsed)) {
      sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
      sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
}

Could you please take a look and let me know your thoughts?

Thanks,
Steve French

On Wed, Jul 1, 2026 at 5:26=E2=80=AFAM Ren Wei <n05ec@lzu.edu.cn> wrote:
>
> From: Zihan Xi <xizh2024@lzu.edu.cn>
>
> posix_info_parse() returns an error without filling the output structure.
> Check the return value before calling sid_to_id() to avoid using
> uninitialized owner/group SID data.
>
> Fixes: 9934430e2178 ("SMB3.1.1: Fix ids returned in POSIX query dir")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  fs/smb/client/readdir.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index 1ff77f3d1de0..df46aa919c27 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -244,9 +244,11 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct=
 smb2_posix_info *info,
>  {
>         struct smb2_posix_info_parsed parsed;
>
> -       posix_info_parse(info, NULL, &parsed);
> -
>         memset(fattr, 0, sizeof(*fattr));
> +       if (posix_info_parse(info, NULL, &parsed) < 0) {
> +               cifs_dbg(VFS, "Invalid POSIX info payload\n");
> +               return;
> +       }
>         fattr->cf_uniqueid =3D le64_to_cpu(info->Inode);
>         fattr->cf_bytes =3D le64_to_cpu(info->AllocationSize);
>         fattr->cf_eof =3D le64_to_cpu(info->EndOfFile);
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
