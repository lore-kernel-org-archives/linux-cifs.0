Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4A013A875
	for <linux-cifs@vger.kernel.org>; Fri, 26 Apr 2024 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714113995; cv=none; b=Q1TKov++sOwsKYIvr9gUJP/ftOcDfv/+P0YwwqF+PSe7ughSATDXSun+2v6Myi/vVnxuUckde/peLMW/mLyrPEQqotSNXn0Tcx3DZ6L6HvR6MAvHpSqfsEeAvIdlPPFV0ViWQQ/QBfck5z/dKk64VhPurFuiV6J0ZCBVWkXXHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714113995; c=relaxed/simple;
	bh=PdJbjXcI5l5uQ68geH7lYdewvq/jPzw0J7cD9VwIX6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qsaaBJ2QA/d+9li1my4rOVHoCMtA3KiVgAGkeUPre7Xn1r2hggqtrYC7yqBkzd4OSrs3Gc/AofX6ocR9OFlYxXaAjUdwV5prbAsi/bIYjT7/MwnevxmV/ex0R6Uoj9V5nQPYJtmzJKSfZzDyQP6xvjXpD6jSrdYAr7zfg01vU5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrbMsxDM; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrbMsxDM"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-516d2600569so2182609e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 23:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714113991; x=1714718791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6aNPLFBGr76gCVgR+bUuKhSIf1fCnP5p4dRrl7dMQ1U=;
        b=jrbMsxDM+HQX+6I343WMwxd/O97dheqmli3Mr210ZG4bpuLJMS3SNta2HJNNgxGMRK
         ZH5KgVkrlYO/ou2xxn11t5o7M3JmQee7WqRzxl/B1P7znGxuHKT+htUeFrdSc4Jizu/E
         VtaUW+j7bhdzN+8hH6IloRiqGz/gt965B0NYQqXaaZJPSE0sLEV5pDz7tBYTemd+gLGR
         HHuECpHAkn8Q7ga5BAs0lpg+YPkbgDcTRRU1xYt3g1GVSvS8jw5HfNTmJ98lDxHstAUn
         EPLr8cMdFbhZGpETimJSHpcrgKKIb/LRUlSpE2AIIehQlFDIg5DFJiMAErEu26HLMde+
         lciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714113991; x=1714718791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6aNPLFBGr76gCVgR+bUuKhSIf1fCnP5p4dRrl7dMQ1U=;
        b=Z34WLcsZBgFBFN4wtIohGh4tvipDZI+JeT4gYmTkyadQzrshkwixVHikvKE5HvHisB
         TMHoTwwJTzJ8pKUnWu3xuxna6Okogkw4hI8tlNR/yrrFzF/KwtcaZY2gAQA2PSUz5Qlv
         zyTu9tF/mBcyEooZ5QIZyXQdg5RXQZ0UBxyv5/t9DpKUyF96pdeLdTqa2S2mf3vaRUVe
         euD38KMIwavIMRYhNhIBBd0liFCz7wdeJ/TbD7ai09FfQSapn4I7WwgHLTg9FfQVQcB4
         oNFsuYA9GvXZrhS3byQJZkkcLjF2FoZwmpN1GFrwbB5109oC1E7yr0znPVORsSb4UlTW
         IL7w==
X-Gm-Message-State: AOJu0YzlqYWrIBMiJEEtpVVr9j2EYkTOsOTHnD7vNmN/wFPVEsrQNg1N
	DUQjBXNEFMcDGArmswiX86Xb3ZjLt/ppn2r2A6yHVONNP4bBka+x12zhr2iFTDJC2lny6GGIVjm
	r2UVi0Ij/arWw4KtWT5F1sY5aKlu9nQ==
X-Google-Smtp-Source: AGHT+IEnyQI6z6l7UprRSJSnGWw2MZpbE/F9IrqExWC7FJb1Yk3WVk5pyvzTHfcQHmrDvC7bKuJSFpZ4VbukRhB+wS0=
X-Received: by 2002:a19:5e0f:0:b0:51b:aa42:67bc with SMTP id
 s15-20020a195e0f000000b0051baa4267bcmr955875lfb.57.1714113990776; Thu, 25 Apr
 2024 23:46:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5ms2xmxgZ08pecifj+Za=_oWnrhVOUgifjYLnCw+Rz9_kA@mail.gmail.com>
In-Reply-To: <CAH2r5ms2xmxgZ08pecifj+Za=_oWnrhVOUgifjYLnCw+Rz9_kA@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Fri, 26 Apr 2024 12:16:19 +0530
Message-ID: <CAFTVevV=nv2-BDotSu+Y2XNFTRGkdc=rv1QFOuzA6aLorFjPsw@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] missing lock when picking channel
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks good

Thanks
Meetakshi

On Thu, Apr 25, 2024 at 10:14=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Coverity spotted a place where we should have been holding the
> channel lock when accessing the ses channel index.
>
> Addresses-Coverity: 1582039 ("Data race condition (MISSING_LOCK)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/client/transport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 443b4b89431d..fc0ddc75abc9 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -1059,9 +1059,11 @@ struct TCP_Server_Info
> *cifs_pick_channel(struct cifs_ses *ses)
>   index =3D (uint)atomic_inc_return(&ses->chan_seq);
>   index %=3D ses->chan_count;
>   }
> +
> + server =3D ses->chans[index].server;
>   spin_unlock(&ses->chan_lock);
>
> - return ses->chans[index].server;
> + return server;
>  }
>
> --
> Thanks,
>
> Steve
