Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316C32D3ECF
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771517269; cv=pass; b=Tci7N7oLmfl7cB8N+JQogeuM9qB7Y8Hqt2zk58CZmTNcpALloqnalgKSLXb6oJz91obJGrpdy5iuhxeNx9k8iMabE1yxGiykEO+MtkH5iwlxeciiVPYt2zmDmblkdHaEELCO2sFN4d7kidF378bTP+j5xdQMVfz/E3OyY+mRNbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771517269; c=relaxed/simple;
	bh=s33d5q8PF0qbSw8A373yA78fZ24lbbhVmFTFnEaTPvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P3gRRNdf50hgjBeHqbI/sMaXXou2gFkYP9QZaslSEnbzVpQtKboZgDv/pwQmTfzZ5Zg20dBsZWaXebFQi+SE1PvdVnPe3UolAVtK4NQA3cobOur3Wdb/HHEotmWKz0bgWK4Nzp4dl4XYl1TfpJM/Zo0WAwsQ1oj2lOk0EM5M0Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SRJxstH7; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SRJxstH7"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-897002b7576so13812786d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 08:07:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771517267; cv=none;
        d=google.com; s=arc-20240605;
        b=VDbheIqrfMyFTvZhjyYRa4KINC2nrn3Pk0oKy/d3ZNcSPlkToRjwVQpFQTJJjH1xpG
         79Rsu68Tx11a3QFgYGa2QmTRz6MlOo5Nae9SS9HhsSKgVui2X2O8wrPtlkkoSl4K6SJZ
         JmW/YFHwBOUmUVwsW14yIBpJg8rUYjFB4ePO0/WIYtH1MfA5Z9V2RBlWrhFKiyXfK53F
         mdiwlc90ggnRz6DezLsUKBdD/PU4MqEEd+qrVW70iCblGswFF6O4bNr0zrCJqLR9IHm7
         uE/HmJeO9WR6ttctUwd4B94tPQtHXVYeI+5s2axsxMPb2uaW/70RhBeD386w1ybvpdlO
         xAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=87d7Hv2bQcpQQT95ywR2SjHEEcC7loTpsx1pjgmaVVw=;
        fh=67tHa2+95eAmSJXjaXOR+X2vOxKGpB4VcyfjAEMgyoM=;
        b=GaLTmsrPic8oBMV2NshKI8Hfg2qZIVcW4KuN0LIa1YFDFTc0CbXM6XK75oBtqQ/0z8
         MO1jVSwG8wBo8kHYcg9QXn8omZ6011K4jHlstmNdmVo+lHuXhOrGx95RsKvvtLYMyI/r
         cc+w8RBHDDlj2F2qsG+t0+XzQ6NShnjIJaXCh4R11cfuP1E4N6T52Tfac9BMR4roDd5n
         c1H/byoUD1u5Ene5GSpXtxAqjdVWakx+jet4QyI85KFAePTvuJO+1+amdZNVQhuAL3In
         aGfAowvd70AP71LFQRdlZJVsmjRPPMLHn3POyqSnF/GR0/2REN3194h2+X+D7YIjjsai
         V5Mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771517267; x=1772122067; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87d7Hv2bQcpQQT95ywR2SjHEEcC7loTpsx1pjgmaVVw=;
        b=SRJxstH7Smb3vjAS+oAeAcb9KpcnneY/wAlXnNdtqe58PC1RyjFTW8Rra7B3SROiEU
         eFa5YxpuY9P8sXnKIDy4Nfz8R5DoEyLdH9vb2ohPzwAd/ZHxn5mKvSBydItK4+pDZ7VG
         x63Sl5JnJ+/p7A1IZ+PQgEyrFnIZivc0L01klUbPv8ezJDNChIxdkYHirizKHQ/VmoQL
         UKgRbMfnZaJDX6mmZBgrTkxdJhiqZ87YbpCoacdwyS6TKTr6UU99uPKl2cvjrmNOaMu+
         vIbKce++Bz2w7a6R8aWxPPOcSfxi63+pIQ6gnlQ8XIHoIjNKq/mYl7K8Z+WSek/0VhQB
         KdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771517267; x=1772122067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=87d7Hv2bQcpQQT95ywR2SjHEEcC7loTpsx1pjgmaVVw=;
        b=ahgn/d9JNpsckB8ruTUMGJmdgpOuKhOCo5GtWM9Z3TxGajz5TimV5EH1Q2uhI2J1+r
         HUz+U6CWlKOjeKqPGLsuFEV9a6uHUa3OFeQFg4udtArK4ThHKxei96bChhk8wCNQQX1E
         MbydSh5jRum0M5/ZShAOEx7SNwdY7DRh+Pq23ilIlC8LRUimBz8f0+4wjPU3DCoGjOB+
         geKCbZNDoZ24jCTvqxdn3a517RZ7MUbndThRhNGpHoM4SPV3bXxzMAk7Ace+dMzsi6mH
         91j1U8ZU+2hM5a0N118g13hYEU5PUNnegnsd9lE+UeX5ts7Q3hEpOG39wOFp0VOE5/gc
         j3Vg==
X-Forwarded-Encrypted: i=1; AJvYcCWec/wJ1eQ4EmX2/TVfuQSt0NQtpcZWqX/b+wUISBJaROLroepJPCNTwCnjBjOe5MilIyc7xxLXr1pX@vger.kernel.org
X-Gm-Message-State: AOJu0YxPRRiJqOVcAyqVry0OBDL0yPMRxobtRZ4Kj7mre7aTI6mGFJWX
	7k6aEb6KmjDaky9DjkSItSHuZio/RkYQv5FjSi0myBg0lyXj9F5Z7DmqLgnR0vM5D+LRUhTumML
	9cMxxB6t65M+s+0GxhwHHkNASDw7DsDbS4g==
X-Gm-Gg: AZuq6aJVUw4q1qVvp05QGYRfMTpY5ykfl2ARK77l8r87MOfb3HucOO+ioaRcX5YsAws
	DbQSZXegx72FBJMQ/FZxYkZPg/F8v0pqQEECq203haelv9Moz+7qqgnDLorhP7plF4CZcN8mkDh
	NGgsOhLpH26pCNqr1YKVSZa5TN5m56ILv6VGMwVNWJx+z7+9pvH1upRFukRZQc6LbG98IIINJkw
	GMbkr989G+UmUjYlkmEAAa1IVp5DGSR74GBfH9XSM3LJ5aWUj7PtAvlGxLRmrO3b/b8H80hMneD
	pdxdj7pixO55tVGCnalklS4YdQSCtUT3zzCv9qHH6BAf9Bu9vtleKweY/oRF+BIweTcmSEBtcAv
	wZGD0SSxFdypwmyabZVEKTxS+gCb6xzMgUfLODV5atRP8+KC92g1qWAajhhK+FTfgz25UnUOdIY
	OhIwfSRf2J3XL+PsIP7mFCAw==
X-Received: by 2002:a05:6214:27cf:b0:896:fb19:97fe with SMTP id
 6a1803df08f44-899580d934cmr78990826d6.51.1771517266665; Thu, 19 Feb 2026
 08:07:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120201822.2218308-1-henrique.carvalho@suse.com> <CANT5p=rWExftaNObvdueWpL97C0CEAUzx5G6cwKrd6ZhfjNRnw@mail.gmail.com>
In-Reply-To: <CANT5p=rWExftaNObvdueWpL97C0CEAUzx5G6cwKrd6ZhfjNRnw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 19 Feb 2026 10:07:34 -0600
X-Gm-Features: AaiRm50629mCYVQ4fKsx1b9uoZ1uVJc2lUmJPx02X2HIpq5LQqTKMjQx6wupZXc
Message-ID: <CAH2r5mtpPrbZazwSQfMQRjTauHC5zPv3e=NLAUpqY0pTyqDutA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix cifs_pick_channel when channels are
 equally loaded
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, Jan 28, 2026 at 6:05=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Thu, Jan 22, 2026 at 8:13=E2=80=AFAM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > cifs_pick_channel uses (start % chan_count) when channels are equally
> > loaded, but that can return a channel that failed the eligibility
> > checks.
> >
> > Drop the fallback and return the scan-selected channel instead. If none
> > is eligible, keep the existing behavior of using the primary channel.
> >
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/transport.c | 17 +++++++++--------
> >  1 file changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> > index 75697f6d2566..26987f261850 100644
> > --- a/fs/smb/client/transport.c
> > +++ b/fs/smb/client/transport.c
> > @@ -807,11 +807,16 @@ cifs_cancelled_callback(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
> >  }
> >
> >  /*
> > - * Return a channel (master if none) of @ses that can be used to send
> > - * regular requests.
> > + * cifs_pick_channel - pick an eligible channel for network operations
> >   *
> > - * If we are currently binding a new channel (negprot/sess.setup),
> > - * return the new incomplete channel.
> > + * @ses: session reference
> > + *
> > + * Select an eligible channel (not terminating and not marked as needi=
ng
> > + * reconnect), preferring the least loaded one. If no eligible channel=
 is
> > + * found, fall back to the primary channel (index 0).
> > + *
> > + * Return: TCP_Server_Info pointer for the chosen channel, or NULL if =
@ses is
> > + * NULL.
> >   */
> >  struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
> >  {
> > @@ -850,10 +855,6 @@ struct TCP_Server_Info *cifs_pick_channel(struct c=
ifs_ses *ses)
> >                         max_in_flight =3D server->in_flight;
> >         }
> >
> > -       /* if all channels are equally loaded, fall back to round-robin=
 */
> > -       if (min_in_flight =3D=3D max_in_flight)
> > -               index =3D (uint)start % ses->chan_count;
> > -
> >         server =3D ses->chans[index].server;
> >         spin_unlock(&ses->chan_lock);
> >
> > --
> > 2.50.1
> >
> >
>
> Had a discussion with Henrique in another email (couldn't find this
> one initially).
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>
> --
> Regards,
> Shyam
>


--=20
Thanks,

Steve
