Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C833D668C
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779946; cv=pass; b=MFcEKEF8gKl4k0BRWUzr4gZxdBpO4YaQIdjJgR4D6gc8mjdPVWkr5BylWkEglPrYgA744wQTOyAaWsbcNaQdaGDzMBsnwTxLel+WgFuKl3LxJwQNTyGBMMIpT4QTQ6+zhKajaJg77SyJ+h+7B4/fYVqB+7iFZwAaIedKkh8t7AE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779946; c=relaxed/simple;
	bh=vngFtp9AeLG5ds+k0SkthlclKPw8RLFOUhDs4uq8AdM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgWC1kEGzOtIEKDaYH1LieZzQaYkMwVoulJo3Jn6XM7lZGfDiVn3AiBQvTVCVYzd1cR6ojvMD9kmVco+cZeVy1qYy6cvRaMV4dlLQvZHfduU02YKe7JNo8ArFcO7StC2fGz0fhN0xPlHVGcQF5EujH8SIRmEkE14MG8Ck0jQLGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5w8ECvy; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5w8ECvy"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-651cfaa21e6so4064116d50.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 06:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776779944; cv=none;
        d=google.com; s=arc-20240605;
        b=d9DiMUq2ka3jdC9ytnrP8VwOqkkYH+Liib4BKVLpadvzge/CW9niq480TllbDCn6Ti
         WRJjhLDLJ40B19PaTgULM06U4mx/GMgivK3/UkYJ+sGNY1obaoaDw4UuPb/Wh9FdFbzl
         tIdA5THMCiiYoGadv9HKj/YCC3rLX4iV/GGgis5Z540xJQg39YNMOQqIRB67u3GdF7d0
         y1rhut+9+HEwXEdaRQ2Zr9S0dWYuxJIqAHLNj0UYUnTCq4USxp5msiJ5bufxDQuUX21Y
         ZKQqyQzJa16OYL1zlAfg7O9rdyb1+beP9nhKSrisUj+Y9EHN0wJEooH+pYvKZ55pADeX
         gIOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=roxDXwIduMjQJK6VmEDL4k1Le+y/IZce1Pjw2/5KXLg=;
        fh=6l+b+8TgNjskIbEdKAy7jNhDycv+isEey1OBJZGhKP0=;
        b=eYy+sOP2l2B5rBhHCp8DuwyDh58xy295G0SloYeebXNEGGN5pQcyp4vrLNxe02M95I
         p5e1nIBnmKtlTkN+seFHREzzZQnVb/YZRv+rJW4tlPxqZdNEc7QM9UxrbhEhlCjexp+E
         lRh8bz4VhwgL56e8mm23o/4nhNfKIHPYbqsxRVDnQ6g4AIgWFx7qEUBXE4GwrecB3yJC
         dQd8kSdZhvM5GCl5lYMSkcZGewDieya8itJqnhYizlZVzxNJFhiguEtd+bLzza88ZMag
         XMa1EzwN56bt94pjcNBA8tNwnh7PBJIjN9xYEWXWsaF8HOxqsTN18D3zHXsMU9EQ+qm7
         Ftgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776779944; x=1777384744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=roxDXwIduMjQJK6VmEDL4k1Le+y/IZce1Pjw2/5KXLg=;
        b=N5w8ECvy2V78SnDZyE65AxRxQ+2IP4PQu1m0O+hM/olwhUGAuRgcT0poXCmmP8OG68
         MycuysDNIjEgR0F0ioGwSrPfeF8vgoiyMpfjWc/wsCCXbPfYOVEde92sCf4QRjXPJLOW
         W0BOIsNEg38+R/cTk9eLCKJa4uYHR9iSZ8doScgcYDauzeHSaV7BFDgYXSnz/VYKA6cD
         /G+uzf4No/uYtlnolyHEqaIwsjjqs8BAG5JAUPkoxlu93LuJjsIIRx9WJ5J7uHJF0dIZ
         Ug/6B3K7Z9xsgEKDW2G0Ttp5ga8PAGNgbyXmejK73h7TmT9XVchE7Gx5PJ5sVQWvoo73
         zeIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779944; x=1777384744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=roxDXwIduMjQJK6VmEDL4k1Le+y/IZce1Pjw2/5KXLg=;
        b=ApiWTKLnlPfRbw1cNLq1RPSB1E4EkQgBx6HrshppusSJsnqWJeWIgGu739GFTJ8o/h
         MstXErm2Gppmte5c5ADWCJmBmSxmm3NXnZ7an4I1lmXGdgnIBJ+C0GQOVSrM2d/3qx+f
         pdHBZuvrSLGW5B8uI1FHTJx40K8iD1MihZSc9Tcr25Gtgx56XTfeFOCwvWaPV8Svcs3r
         7g0to9VnHNLpSTM6ktTEBYy4obSeyAfgt/kX1/X78tQmWnjxp3eucqgg12JANxXn5+I2
         NfOmydAwip0cI/r7CMA6ZTI8FyVwJAVgMs4FeYsnN/hP8kAKqkwrA+cK/dX1riGWrU/6
         pveQ==
X-Gm-Message-State: AOJu0YxAWsV5efLuXRCk/kYJLiEGY92B901wGoFLryzN5TmNGDjCa0MU
	1BEZFiKJQ4qMQ+rwSJzf08VMaEeJe8hpr//WirHENkqEEcP8bUWh6uvMVcfQFWiUk+uFL6ogh96
	KsKRKx6C5Hxa1Mfrn6xONoTrITHtEwhZu7jQ9KYt6qQ==
X-Gm-Gg: AeBDievONYq0WoaiZfH8OPeWXZPUPiI9I7YJhTl/CkROF3JLSz+fOcQAKxEXrm5HWUR
	/i9R3W0zOD8h3E5dCK1tHnk5A/x2VhWF/WUtLDlHSqkPB7279Cetr+DswVdBSuTRRdxGWK+NOMd
	fKDEtrC/0dwh4JddkHHwmpcHuyHUYui/iUwu4rFNYupCp9/Ea1jd90f4RdDWW+xNa2y58UEOSmB
	gajcMf7eeBSVrXU54ayxSrcZk9OAwdQ2a6IqXUme/PCAm4M+U6VNLtqMTl1k8ok3Iq3A+/ZnWqr
	FB1/wc8e40Yffg0MltwCCHT7jCmU4N7U926peASKPL4txVP2AQ==
X-Received: by 2002:a05:690e:1384:b0:64a:ce57:cac4 with SMTP id
 956f58d0204a3-65311b20b91mr13031091d50.24.1776779944292; Tue, 21 Apr 2026
 06:59:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421063955.99164-1-sprasad@microsoft.com>
In-Reply-To: <20260421063955.99164-1-sprasad@microsoft.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Tue, 21 Apr 2026 06:58:53 -0700
X-Gm-Features: AQROBzCyLVN1vX3c5odyoOOK8vJQAPPhS4kSDQE94UmW0F0hKsRss-X2OtJFJks
Message-ID: <CAGypqWxMLSdPhpGcomCeokiRXFR5kb+CQGNON7bsUiOPfswLKg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] cifs: change_conf needs to be called for session setup
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	ematsumiya@suse.de, Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 11:40=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today we skip calling change_conf for negotiates and session setup
> requests. This can be a problem for mchan as the immediate next call
> after session setup could be due to an I/O that is made on the
> mount point. For single channel, this is not a problem as
> there will be several calls after setting up session.
>
> This change enforces calling change_conf for the last session setup
> response, so that echoes and oplocks are not disabled before the
> first request to the server. So if that first request is an open,
> it does not need to disable requesting leases.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2ops.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 509fcea28a429..3625030d1912f 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -111,10 +111,19 @@ smb2_add_credits(struct TCP_Server_Info *server,
>                                       cifs_trace_rw_credits_zero_in_fligh=
t);
>         }
>         server->in_flight--;
> +
> +       /*
> +        * Rebalance credits when an op drains in_flight. For session set=
up,
> +        * do this only when the server actually granted positive credits=
 (>2) so a
> +        * newly established secondary channel can reserve echo/oplock cr=
edits.
> +        */
>         if (server->in_flight =3D=3D 0 &&
>            ((optype & CIFS_OP_MASK) !=3D CIFS_NEG_OP) &&
>            ((optype & CIFS_OP_MASK) !=3D CIFS_SESS_OP))
>                 rc =3D change_conf(server);
> +       else if (server->in_flight =3D=3D 0 &&
> +                ((optype & CIFS_OP_MASK) =3D=3D CIFS_SESS_OP) && add > 2=
)
> +               rc =3D change_conf(server);
>         /*
>          * Sometimes server returns 0 credits on oplock break ack - we ne=
ed to
>          * rebalance credits in this case.
> --
I think it would be good to add a comment explaining why the ' add >
2' threshold is chosen
here and the assumption that the final session setup response SMB
server returns '>2' credits.

Otherwise, Changes look good to me.
