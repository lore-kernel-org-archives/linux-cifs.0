Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DE515D5B8;
	Thu,  8 Aug 2024 21:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723153913; cv=none; b=bYpKLNbnE04nG522oCzchu28m9BDu/yzZcIyAxSuAFcktjuc807ymMRNFGHjLjCRHPoaD6FTJLPIh/OcNhMk/sjN6JtVulDOEVu1woHYka8qNOguM9SYQlS7w3Ugq0mQa69ZExB74tEDKqEfj9f/qLW1IUjG9uRJT5Cao0sVvcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723153913; c=relaxed/simple;
	bh=DTz30EgiQatv3b3Mf5x670oIHDaDHPcPkrLDKRckk8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V7SAvRB9YPOtOvBtxSQQdr6TjVWwDQPYqxiiTNvJAluCe0xg5MPdecrWogUEB1Eckw+cal3H9h5C6IKgdERAgUD9jUGL2hSWd02SRDscyHYh5lVTt/AlkjvEK0Kraj12q+/qGGmioc+9LXKOro665TVd54EySbhnnPwLLXoA5+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RKjTNqgh; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKjTNqgh"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2f1798eaee6so13758191fa.0;
        Thu, 08 Aug 2024 14:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723153910; x=1723758710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTilJSTMzzmTUfM8PwyjqnLeW2jPuc+7Tc/WpwcfYso=;
        b=RKjTNqghkpGIVR3bL/EYmcntQ4ApexBlQ9r4LtfBM+WZDKZ5LhrLkm8vhzO/oA3Nbk
         RxSzZ1s8+TPLyZ6oLZ0xaWIJnK3CRsSdJH8Yu/sxDWPMEVV0YOdzPMdVKx9A9ZXHjlPn
         yt2zyrA4IvtoK0cSOwXzsJV0OtnVM3GGZyivf7IamgUP7Lq0pGy8VqeJ9z1u8hzR1Isu
         Ak7ipouiiauHcUWbXPzLCUqSUuy6MPJ1Qcs+2DWN7xAUSuZwCswpdAmmVJM0+jfhRngy
         kjFymzJ2D6Vcl7mxVm4DeiYV+myh38XmrG59vazjMWq7pmlZmMhe7s7JcKHdKxafjicp
         pQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723153910; x=1723758710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTilJSTMzzmTUfM8PwyjqnLeW2jPuc+7Tc/WpwcfYso=;
        b=Cp1MqTxaaR5bWVhhTBZya9pt2et4VNfuUhtOKsdqx+j7NkjKY+UISnzYRxdas7xlcu
         3wfhwVjj9rcSG+s7zyjGj9tgbVuP/Z74Ui5KeYiLOLfMe8orRsm+Baa1Y+tf+940DewS
         mjyuP1c7eDvbaLtKrzx5JPIJx8I8Q7jvY2ywl53CWJii7oSSsi9jBPc+a5m/1anK9vDx
         B7t+vwEYZmjIVghAxn/1t3feItrawt7Gcc7yztNB1BNWeBMPBkly6xBeppFwknCnks9a
         KU3JyxcUUnFRtK73QxJwUffL4+hmZC2FSTKkLMjoMtTHjLf4PRZTrHs5D44zG1cxwHKG
         AYEw==
X-Forwarded-Encrypted: i=1; AJvYcCVs0R5zQoT/NJZTN5UxOlPPIbwPV5dyUakpkmpLwnnTlH3VWCLA6veGX9NMFP1O832LsJR6+YunOgpHg/TOJ7gNkpRQo7GRKl5XRcPdceMk5P/erkpsMZ58qHAVWX2nSdCjmgPHo1S+6yUJnBiL76KGNNYiBkaGUzd5wH5D27iSHd0JSho/yXkJCQ==
X-Gm-Message-State: AOJu0Yx/huGQ6lho3h41kM9JBrFzgiblCBOAE+i4BH+OAIeh2+o8DvcE
	HyWFad9Ih5Fh06GuYd+QBMS6mIQhM2kZ0Q+P/GSMH+tYiyKvPIWP5sPmMqvRAHv+b/MxgrO5CIw
	EEFKZcGvwZItUCMoHgJQjn6+mjZQ=
X-Google-Smtp-Source: AGHT+IGES8fNHsGvpYv7uRV9s1I4pkbSiW25z5WmM1/EEFB1wRmanyCXIXI8O8RexuT7mqGHIaX1FSuWqO2mBT4epPY=
X-Received: by 2002:a05:6512:15aa:b0:52e:987f:cfe4 with SMTP id
 2adb3069b0e04-530e5876b8fmr2151699e87.30.1723153909723; Thu, 08 Aug 2024
 14:51:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808122331.342473-1-suhui@nfschina.com>
In-Reply-To: <20240808122331.342473-1-suhui@nfschina.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 8 Aug 2024 16:51:37 -0500
Message-ID: <CAH2r5mshFXCMO38WMZP0NzrugKZn1QexLSH+2aEMcZnB2S0+zA@mail.gmail.com>
Subject: Re: [PATCH] smb/client: avoid possible NULL dereference in cifs_free_subrequest()
To: Su Hui <suhui@nfschina.com>
Cc: pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, nathan@kernel.org, 
	ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	kernel-janitors@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tentatively merged into cifs-2.6.git pending review/testing

Did minor update to add Cc: stable

On Thu, Aug 8, 2024 at 7:26=E2=80=AFAM Su Hui <suhui@nfschina.com> wrote:
>
> Clang static checker (scan-build) warning:
>         cifsglob.h:line 890, column 3
>         Access to field 'ops' results in a dereference of a null pointer.
>
> Commit 519be989717c ("cifs: Add a tracepoint to track credits involved in
> R/W requests") adds a check for 'rdata->server', and let clang throw this
> warning about NULL dereference.
>
> When 'rdata->credits.value !=3D 0 && rdata->server =3D=3D NULL' happens,
> add_credits_and_wake_if() will call rdata->server->ops->add_credits().
> This will cause NULL dereference problem. Add a check for 'rdata->server'
> to avoid NULL dereference.
>
> Signed-off-by: Su Hui <suhui@nfschina.com>
> ---
>  fs/smb/client/file.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index b2405dd4d4d4..45459af5044d 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -315,7 +315,7 @@ static void cifs_free_subrequest(struct netfs_io_subr=
equest *subreq)
>  #endif
>         }
>
> -       if (rdata->credits.value !=3D 0)
> +       if (rdata->credits.value !=3D 0) {
>                 trace_smb3_rw_credits(rdata->rreq->debug_id,
>                                       rdata->subreq.debug_index,
>                                       rdata->credits.value,
> @@ -323,8 +323,12 @@ static void cifs_free_subrequest(struct netfs_io_sub=
request *subreq)
>                                       rdata->server ? rdata->server->in_f=
light : 0,
>                                       -rdata->credits.value,
>                                       cifs_trace_rw_credits_free_subreq);
> +               if (rdata->server)
> +                       add_credits_and_wake_if(rdata->server, &rdata->cr=
edits, 0);
> +               else
> +                       rdata->credits.value =3D 0;
> +       }
>
> -       add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
>         if (rdata->have_xid)
>                 free_xid(rdata->xid);
>  }
> --
> 2.30.2
>
>


--=20
Thanks,

Steve
