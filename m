Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AF91917F1;
	Tue,  1 Jul 2025 02:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751336459; cv=none; b=JgLWlrbYGAm+KXnhRpBnYC3AhSdgKcC3i1ZdRDYKBl/g1JYveAZHhQbskGSp+2OSiXsT9zyxcL7ueiHpb1aRys9pEGevgtB1MqqSgXEMJJZFT+0YpD/deBOcm/I6GtsWj9trPRnP8KStKKauvAP7+8AN+zCzE0r5NUpaqsAiPFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751336459; c=relaxed/simple;
	bh=UQK1K/8AjN/ed7zGRgmjFNcMMKvnbu3QZaVDcn1BSMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c+OZptn/pYE7YWCuYJxUs/28FAZKFN665TfI3zrN6g7OA8XRBIOdILqCBGhERxXU5GehwMh9cXAeaaYVqC91zWZSfUmfBxBa2pssR9CVXmVHwKEhKGGgYgE0ZxKr5qGPDMnhIpY/czs7kVsln4a6gu5aP5kkFFwGaDpLBNpP2kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRk/C3dh; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRk/C3dh"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60bf5a08729so5926842a12.0;
        Mon, 30 Jun 2025 19:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751336455; x=1751941255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8c2vbb9gJxCkMktav4zEHdcZ05yBTFdozTdnnSMg7+M=;
        b=aRk/C3dh7Qqm034ZthNf/3gEtTOlugVpFVhhyp+FWhmymw+rpUqSDIddnU1D56UI5q
         QIDVvnDkBsifc9T811id6hjHy3qC7MckEUeoMqQwlFiWopGKeyuOPVIA0MqWY8qQy+dU
         /9mx5aph8UPA2a7qzWr+rBp3rnRi5VGW0WuB8uiqOxnONLjjKMIm6kc/iV7QuQjueHG9
         /tPD45iU9sbFbr7+cXvqDcKRwcNEQmtZU7HQMZ7KhI12tqDlMlZw0Hk2Ahb/hrSZgglr
         fknR0YvBCCxMweMq1DOt1sbwcoPEvNXyCCzQhRjr+IJszUCd9+rpl8YZDboorfctb11V
         ikLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751336455; x=1751941255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8c2vbb9gJxCkMktav4zEHdcZ05yBTFdozTdnnSMg7+M=;
        b=DbrEOGYMTU7wUa99nGz9TTh8lSp3elBe471nmfgUndSVMIoNq/FRiTYzqGPdTXqCwe
         GofdNQCpPduzsEfVO54/qwpuTBTM9KX9TelS/k0Rt5Qy/k1wIW84jV0nF1txftSGLcgd
         rzPOzMM4uTS9MTNsrkJko3s7fo6chjbQkyTI/uB+kDFOkWli7JqVwE2/4o6Jkge5MiHj
         bbby85JaGySl9d0x7zkNC8AxPtd8yzUbvzoZg8Nf00V9UMCp8wMYLlYlZssh6RDbQb8n
         ikx406slWHgAsLlLMWMEYq1YDw3kKWZuAvhKYz7PHHDW51zGT4WckfNczOfZMkvfM8mA
         1n8A==
X-Forwarded-Encrypted: i=1; AJvYcCUXIvq1TUFWYBFVXWiIGjKh56uOfqcHo6nGnROPiIbcGqKAvflLmgiiIqr6dMk+5/EVzodhi0xX4P3T@vger.kernel.org, AJvYcCVmZoe81Sap+aOaRM0RkZFVXoTciUJ2wD+Mvji5aVpqFp+ov96HveMWZevfQiUBOmFRuBxL4U8j@vger.kernel.org
X-Gm-Message-State: AOJu0YyTt1Bb8BPXLwt40CtvcZlxqNr08DO+8CXdEdvY6WTeCZEuiWjn
	yVjs+QHZXC13gcnvMgon7aZPMqBt/DSUD43hjW+P9sefplwe/pk6uVNSgbO+6sE7WQOMcdg0k+1
	fFDInFGu4ooxFZ06XXu8ZiG1D/gRUxauwvjbe
X-Gm-Gg: ASbGncvojFRwPeV7tz6VneiGOC9q+xgR8ORXltwGJzeepvQcHUrcd9Hy+qP69rnMFok
	ReKkHkjFxUm6e6kWkqh19Z28hxUWdHwfnEKOqIMD0Nf3t6f5yRyKigyB84zPRCBIWhqmqQW0O0r
	qealrGMTYDCFa4xX/QhVATRdd8rYjYVVcH+zj+XuLC0w==
X-Google-Smtp-Source: AGHT+IGNFNbhilCOJJyOdnpcryO/IwqMwWsq8uviPHqQSqZ3ZmdRNOS/jFE13ob7OMFpCRdZmtmLA9ZWfxqfYLwsb54=
X-Received: by 2002:a05:6402:354e:b0:609:7ed1:c791 with SMTP id
 4fb4d7f45d1cf-60c88e4d734mr14468736a12.32.1751336454511; Mon, 30 Jun 2025
 19:20:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250630174049.887492-1-sprasad@microsoft.com> <87104723045d2e07849384ba8e3b4cc0@manguebit.org>
In-Reply-To: <87104723045d2e07849384ba8e3b4cc0@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 1 Jul 2025 07:50:42 +0530
X-Gm-Features: Ac12FXwmrqFJRoWmaDbzkfDUnJAZVDZ9hhcl_fvg71UCXQwWFfC_fUs6YM7ck9E
Message-ID: <CANT5p=rEUppfa5E_ySYnXtB8cq5x=V-Yhia6c+1W8a9b7ctLWg@mail.gmail.com>
Subject: Re: [PATCH] cifs: all initializations for tcon should happen in tcon_info_alloc
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 1:06=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> nspmangalore@gmail.com writes:
>
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today, a few work structs inside tcon are initialized inside
> > cifs_get_tcon and not in tcon_info_alloc. As a result, if a tcon
> > is obtained from tcon_info_alloc, but not called as a part of
> > cifs_get_tcon, we may trip over.
> >
> > Cc: <stable@vger.kernel.org>
>
> stable?  Makes no sense.

I feel this is a serious one. If some code were to use
tcon_info_alloc, they'd expect that it's fully initialized, but they'd
end up with the problem that you and David saw.
I feel that this is the correct fix to that problem (although that
addresses the problem of unnecessary scheduling of work).

>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsproto.h | 1 +
> >  fs/smb/client/connect.c   | 8 +-------
> >  fs/smb/client/misc.c      | 6 ++++++
> >  3 files changed, 8 insertions(+), 7 deletions(-)
>
> Otherwise, looks good:
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

Thanks.

--=20
Regards,
Shyam
