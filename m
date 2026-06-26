Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211BDF507
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 00:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782432843; cv=none; b=E/6GMqquw0I59MoGBsvBkpz6laZQ79YsG0LQM8NSq5wDq+XsjGAbOHBrO51JoZjINHF3NR9bpNZyCCQCjn1/rfo27Rm6wOgIO76iL6zM7FH8C2L8D2QDkcLtcTjiGXPvhlprRhRNHI2anf3J0o0vZL0ts8bUqNtcPlxU9V1421A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782432843; c=relaxed/simple;
	bh=bGZc9yhechKjQxzvTbpc5XYaqDUvlU16B09qTzti6bM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dIfxCO8r3DK42A4QXPAm3CgLDf6uVJBd4RTeAfVIl+io3Aw3K/8ch+oe82FHWJJAgA66Cqozna93n1ujNVmTQtOm3oMIM2YyEchHx4mpITAtBvG6KgE4kRa/O1081Lqpa4wZvSXd5AWCCrW4r881OY0gUnvHNOd5XY01jGh996o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYd0uQfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYd0uQfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7781F00ACF
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 00:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782432841;
	bh=pAe5Jj84EHdc67x2lt2zecXJbQGLOhgKFxKmip6oMKo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mYd0uQfgoh4zi7iqCF5SxgapoEiqX677WQmtBhYk9tre1ZlupILwXvKjH/E0WETrX
	 h+PGAp72SffkrstL7KNpTAWvL0a7OEBgWzIWQUQO1ye2TRU+VMfSyS2WaILHeEZkIQ
	 ZYBn3QrJsqiUQ7rMkFCWlXnK4wohm8AclxiBTItlNVZODcNg9EHwmOHXoMk4K99JeH
	 k2B2Xl9U89mni+QNnuGh7eJ+0c31Gl/BS0gV/ZQJxMtbdWRw0fvVoIVSuNem3lldAP
	 tkexYkld/CvAyWGLZ4JDBLi9vZhjWTe/7gWZdUCnthycQ/AABj0Ic2tKiWOmMkxZNQ
	 h3o3Kvmvg1B7g==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-697bd41a4ecso424912a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 17:14:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpTeGmec1migr0ZHo6kRa4pVB5m+j8xnNBPTVcMMXZoXvj1IKDP7ALUYGNuuDL0SBq7wvYqABQndYqy@vger.kernel.org
X-Gm-Message-State: AOJu0YzuAiurbIjrEMbC5mZKUplMjgdKHyxeCfF/LcnJhlb5/Clm3cnV
	Prc+XpsYa5kHYLAqt6AdrijLY7y2iCD8m9HIucBAMIG4CA+multpobKMrbMSmtBCG7qsxD6JwxD
	rvs5wxyzdtR+HiRtmeL5k05vGPLpfOiA=
X-Received: by 2002:a17:906:6206:b0:c12:db:3062 with SMTP id
 a640c23a62f3a-c1205f15deamr320398366b.35.1782432840299; Thu, 25 Jun 2026
 17:14:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625144021.513613-1-lihaofeng@kylinos.cn> <20260625144807.513701-1-lihaofeng@kylinos.cn>
In-Reply-To: <20260625144807.513701-1-lihaofeng@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 26 Jun 2026 09:13:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9bagjfPZJqsMf7ru_hEHV8EALFDP18_OpP-_iV=OMwXw@mail.gmail.com>
X-Gm-Features: AVVi8CebRZm5csO0yjRhdLzSyh3LwaAgdEYFuAtDQGminTB_f7I1xQwKLbTlhHQ
Message-ID: <CAKYAXd9bagjfPZJqsMf7ru_hEHV8EALFDP18_OpP-_iV=OMwXw@mail.gmail.com>
Subject: Re: [PATCH v2 resend 1/2] ksmbd: validate num_subauth when copying
 ACE in set_ntacl_dacl
To: Haofeng Li <lihaofeng@kylinos.cn>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
> index 340ea98fa494..693a550fbe34 100644
> --- a/fs/smb/server/smbacl.c
> +++ b/fs/smb/server/smbacl.c
> @@ -740,9 +740,14 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
>                         if (nt_ace_size > aces_size)
>                                 break;
>
> +                       if (ntace->sid.num_subauth == 0 ||
> +                           ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
> +                               goto next;
> +
>                         memcpy((char *)pndace + size, ntace, nt_ace_size);
>                         if (check_add_overflow(size, nt_ace_size, &size))
>                                 break;
> +next:
>                         aces_size -= nt_ace_size;
>                         ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
>                         num_aces++;
This uses goto next after skipping a malformed ACE, which causes
num_aces to be incremented even for invalid ACEs.

                        if (check_add_overflow(size, nt_ace_size, &size))
                                break;

+                        num_aces++;

+ next_ace:
                        aces_size -= nt_ace_size;
                        ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
