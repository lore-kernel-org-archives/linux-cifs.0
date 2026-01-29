Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC1129ACD1
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769688800; cv=pass; b=UAJS/TPf+2W33PEsDgev9LA/tsiKP7LwOKJZM0KemH/Sc9Y3GyFsIZsDgq/OY3M0QaFD/w0WcUF/A1hKf9h9XDD3GGF8pI5KTgnW1lPMq3wQrX0DWg5e+4kRpcBwnQw5d/ntjgbFlgU9fLHhAXWfbjFH5pwaWVp2uGK0WKdDjoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769688800; c=relaxed/simple;
	bh=OFkhbvXyiQtGuGUYi0Xxrr9+QTe7DEqriM+02bUoq90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MnDSRsRDP5oxEjuzSvoivt/MENCGiZqXpkGeh/KrRrQ4Z9PNTglPFN5Ge6lApqFuUpcm6cM8oy0tsXMU0uvDhDVmSlLkpIS9/L0sDEWSzWHIgx16RZLAwc1IcuyQRzHD+IhqdIl+3kpEwf3SNylG8MfpxE+SfQSQ53ap31EF+is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LlIWBjUs; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LlIWBjUs"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-658cc45847cso1163506a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 04:13:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769688798; cv=none;
        d=google.com; s=arc-20240605;
        b=dz1Qm/mtl+NUdhbcGZIjYhBUM0FfHb+KJCnik/j5Cy3+sJbGdYZL+fi4oXvcrst6Dc
         mWG/vd8gIAuq8Kc3YgRw2/EbVg2ZeGjhuP8lnr7OPCJ2FgyCtauYgWfxlhjBEENeMZCt
         GvzNgd71X3PYd6aJU471mVCbMeuYiI1fIioHYEqpPtMuiFCfqXpKhBZ3FTvud1LqOFnW
         7PVZP63wlC8CPfME1jrgdnVUYzoO3RrQcWb71te1hm9RpapnB55IZsV12aYHEbBKUm6P
         FeL/HUkVINLUyHRdckvAigKqMoalZ98Knh+uLLDLuUM2QVMABwLNqPr0o2ROBVg5JibK
         PLHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dVRo0gb1o6gTeziHK7Wfsfwm0G0vzfIXHYbGlbgsvDI=;
        fh=ivCwkVCbTDUI/zL2b/roBiCbp/G9xQ3FpSiz58Fn7qk=;
        b=fsJJ7UOENtHpKuN8aOtstqIx8epNMTHI1tOXwuersN0arltzqBnEvvivJLELASBPRS
         gUS9ASQ14echrvJNx3T+GPoEqwGNp1XQDtYKIhq6D8iXJK2GRipkzjCgS08kIJHIF08W
         IMQuHkgTvakr2wPLti8pONXjl2ZhCWeUHwUWhAr2WLUVVdM9PR2vShiAE1HUK6Ld+VR+
         XgAj5cPIhlImdTTMiZ5XQw72cDa3WJmpZuWsLNMDKanleWS1Plo6CkohQnoA8zYl0Zot
         z5x5rtN78PAgUuXQaOt2EHsJknl+z9vnDb0RcADui6GL43QD2MA/OQr8BErEUKT3Xi5K
         VcxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769688798; x=1770293598; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVRo0gb1o6gTeziHK7Wfsfwm0G0vzfIXHYbGlbgsvDI=;
        b=LlIWBjUs96F3yscCvayZTXzjkLsq86hcxsele8I94YiONdnEOPjK/e2U3f9Z60o2Vy
         sgl1M8neg0R6Oixk4ohjTMck3AC4cRKyhlcyi2NixdCih5IJofm0/OgPI1DPTxeY58Lx
         0H/X0OaCQWmffamcICR6z+3+EOsstmFXON/Ixfaa24ss62YN7CTuascpQpFNJx3UtGXV
         Tep1h2KGFmwFsmIQ0TwAzvssiGkjV8FAW9DBtFgom8Ox3kP/camujhZK7yvgBcnrkrTw
         i+FtzXsAzGwnVuiiyzrzgt1SPD7Kc+8ylJGCMQ80M8bij0MGAvcXnmcOPQcn2jo+hCyo
         aH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769688798; x=1770293598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dVRo0gb1o6gTeziHK7Wfsfwm0G0vzfIXHYbGlbgsvDI=;
        b=rHYxuoXxDR3e89S2u5KV664u0JXLyrGlMPL0dLfTiXiYL0BBHJQ1PXqEEPe6m5ytR+
         owj9cHMDwDgR5Jw/Jl9do7/hUsHUtPR393jPvF78Pp32N9zxKBrnTe5D5vb6lzIbysvO
         mHvd67VRFTKGwxx1iPsSxncKzzTpV0cEJF2Xkzc5IUm8ztsGaXi+VVw/t4RglBg6G3Hn
         qXpWT6B/Iv0v+UclTF2c6DIuhRm2FVoGNeUXRjOD4zR2R/SEvq/PjL78Jy7ZTppmqvu4
         e9qphNioXRfw3BFr3C0UG851BRG7fP6eFG6HcaxrBj3JoAqx1ovShLgmBqOMOD6OFYI4
         g8Yg==
X-Gm-Message-State: AOJu0YyIE07S9Gk/sK3kxPygqj5aNeW4UZV+s6xVq47L+vmnzT1Z7jgM
	ffn5HIZ0OfsV6oHetAcnnA0g6MWyZJFh9d8vorifog1CMmYpRPxjZBc2hJgjMU3q4ANsEP0dQ2o
	6l14HahpxrbYvbOhmnjCNsvPExaHXg8E=
X-Gm-Gg: AZuq6aJw0B2Wa95gLS8H9eTXBAasAwX/XfnX3ZnX7SxkXAV/RK9X0YG+Tvbswo9sqOK
	YrQu2ZJiugrSOjSLxa6mCG4+s5Oyw6+xcssAiq0lXYcMvbwabjgqni3jbDgGDI1ExB2gaa6jvJ0
	y9HDkRrQr77oTpJlQI9Fw0KROlibbmszpt0QQsIDcSebTJzIoCU7iF6C0iyg8auZjNBgL84/+PW
	Od10CsRYLfeER5nE+3SS4B7/LzYGKsbP23IHPTA65bvldYJAY3wRsez1N1cqlOXZWoMqw==
X-Received: by 2002:a17:907:6d16:b0:b88:641b:b0e0 with SMTP id
 a640c23a62f3a-b8dab35550dmr502605766b.49.1769688797729; Thu, 29 Jan 2026
 04:13:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120062152.628822-1-sprasad@microsoft.com> <1652302.1769037531@warthog.procyon.org.uk>
In-Reply-To: <1652302.1769037531@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 29 Jan 2026 17:43:04 +0530
X-Gm-Features: AZwV_QhsWUMtup-9SGLmiCEsP0i6Zj36exRvFntaJU7Wwt8wfm8t9oKOPM-No3c
Message-ID: <CANT5p=qptmBxhOoO_y+OnuX+_rjMeqGUTJ87y_tA+eVX6eJqBQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] netfs: when subreq is marked for retry, do not check
 if it faced an error
To: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 4:48=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> nspmangalore@gmail.com wrote:
>
> > @@ -547,13 +547,15 @@ void netfs_read_subreq_terminated(struct netfs_io=
_subrequest *subreq)
> >       }
> >
> >       if (unlikely(subreq->error < 0)) {
> > -             trace_netfs_failure(rreq, subreq, subreq->error, netfs_fa=
il_read);
> >               if (subreq->source =3D=3D NETFS_READ_FROM_CACHE) {
> >                       netfs_stat(&netfs_n_rh_read_failed);
> >                       __set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
> >               } else {
> >                       netfs_stat(&netfs_n_rh_download_failed);
> > -                     __set_bit(NETFS_SREQ_FAILED, &subreq->flags);
> > +                     if (!test_bit(NETFS_SREQ_NEED_RETRY, &subreq->fla=
gs)) {
> > +                             __set_bit(NETFS_SREQ_FAILED, &subreq->fla=
gs);
> > +                             trace_netfs_failure(rreq, subreq, subreq-=
>error, netfs_fail_read);
> > +                     }
> >               }
> >               trace_netfs_rreq(rreq, netfs_rreq_trace_set_pause);
> >               set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
>
> I think I suggested moving the check for NETFS_SREQ_NEED_RETRY up in the
> function - above any checks of subreq->error, but after the initial stat
> counting.

So you want to do this check regardless of whether there's an error or not?
In that case, I think I'll still need to check if there is an error to
set NETFS_RREQ_PAUSE only on error, right?

>
> Ditto for netfs_write_subrequest_terminated().  Actually, the
> transferred_or_error argument of that should be got rid of and the filesy=
stem
> update the subreq->error and subreq->transferred fields directly as for r=
eads.
>

I can try making the write path similar to read. Passing just the
subreq. But that will mean changes to all the callers.
I hope that's okay.

> I can poke at this tomorrow if you want.
>
> David
>


--=20
Regards,
Shyam
