Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E97338B7B7
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773060253; cv=pass; b=E8pdeH5M2CP0936RzcWPfCws86Skb6N/7W+UCtEgnI40hqu1SKHZmJsczG44ZZTxV09NqND6D+PVWH0XPwcN1haKOytO8eJ7OcDRBTA4huobo4fwqXPSspADCf6QBBaazWL1j8wueoUL0hI5WgEFTsmDXQlYMMx+lHJrFIERRs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773060253; c=relaxed/simple;
	bh=ghZjzPATcHPOBiNLTfUQLB6Q/MiIhtQ6K37tFegJD7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tTEonbKB+mfULwLpitM+NYhT+yEO4XBX7Afb2fRIiMXknCiR465/CJtdOWfNfeP2hbYGhtqOb5Wz4H5VP3Kiw8a/qyGiaHdpJ8OwB6v8rQwHA2K4JpOns7OObu8Lpoo/NLQujf1wn5KD4c+5d4w1WHrd68Vu+ey5NChrYghxs0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZkPschPx; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkPschPx"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9423d62cbbso417827466b.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 05:44:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773060251; cv=none;
        d=google.com; s=arc-20240605;
        b=ht+3/666Rn28zMIGFo1gt/NgYgI3pq6dSW06j+33CUB6OiZCYPIaedzeSEFH/afq9V
         47U49NW/jA2G6EgkfmeLlXFCBLYm0NP41OUdQUTNaXt6i8yHiXraWmsSJdDvYKf9cFkc
         Xv+ODqG7vn7DbM9imJf9RM/dzUG7v8wPPb/KqLSVqN+iHTMK4O/A7uO5NvBe/GvjRn8J
         yOJy/BraG6kJ/VUEYUfdaVh3gzLCw3CQRAq1ZY3bxLSGuBNlmysRigon16xRzGF31Ijc
         8WAbArUYuURPg0QmuNyX7d6GKJ7HtkkopDy7NTSA5LwB9yt6P3t56Vgc8q2064Bg4RQz
         L5Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2Z7S/QO4us3YQsSc9qxuM/DMfpNt7mt8YV2bewLgj9A=;
        fh=LdJTNvsKCQ3x8CvCoIMITtZHWHOIcDbwA1UETGUDuak=;
        b=XZ9rJ1bvveWo7hycmJ34QgKgi8uVbm4GWq11U9tUvtrcWponwqlgpbZlE/TjH8rYU9
         KoDz/X2qa46GlGto3aDBcBQSi2mWkLi292L+ue+p/T9bkT/5rNPsq7HIwfO7NKEpvbNK
         c+fb9YMVPRa3buTRw9fezk5V9Ht43WRtUyrEna71Q9yhdUlJ3RgZ5FeEO55FIQTjinDp
         ny9Us3K8ehb9I3efvUxxdbpYDFuPvXlIfr6qwtN2PDsECf1Jc/INm4pzRFmK49Ah+hN0
         5YZgzJgJlpizv0olExgJLM1zj5nWxc8dC2ETky7FX+bGZyy1T+qHFJG4VynW0O2Ot38s
         nHPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773060251; x=1773665051; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Z7S/QO4us3YQsSc9qxuM/DMfpNt7mt8YV2bewLgj9A=;
        b=ZkPschPxPe9rWmETB7ab4f1atPm/wTSezLvi2dDIGhriytZGIp4iqJWvL4l9rvTAmL
         469mKn8C3GyPdK9F5UYk0hh9cv6Zni92PmXSNQTkB0ERWMLaYXx7g4sNi2dKaX+yqtSV
         SqRDlpB9fv3lGWfLXgFgLn2SWqcdCOVahWrd4OVK1iiFArnki73ytsLrJ7Obo3N5ZEqg
         HK2dOp1FAOrVBMllwjxTxyn7Lu5SDQsBDm2vNOYDRarWr5F5x9t3UUd3yez5FdvGFo5h
         Fd9S6tke+O5IlIMFXRmVcun3WNgirtsJDEV+Op3JHfKKWSVBCqMLFuNXljsAkYjtw0vt
         b8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773060251; x=1773665051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Z7S/QO4us3YQsSc9qxuM/DMfpNt7mt8YV2bewLgj9A=;
        b=Zd1wVECIJwqrcH+JobU2iImraGYn8BStthmKudi7YJVkvfv5YF/5I3vfQ0JpqxxX7S
         Oj9dqGslD9OfjO0slXqzaxeUB/Qqita3mwgXzHPZmdrmuDqZ+lyWcqN9HTOq9iEY0/OO
         cfDE1S1ovBqvCz8hd7tp8IIVZtbJt7F8u4VV+5i8K1ZRk0S9KtxLDiNAPEpBpSnf1/Ac
         86e0zt5PgzzB8kc90lpkhe7Q4vl1tarC1MBBjiPZGujfsFrFkMsSUe64fA5ciNHOlnt6
         yogzMVr0f0pntL1b0D6570J/a6IuA5LZiPVIXx/oW9yijvDMdLupUPAFsltu0A/QB1yD
         cQ0A==
X-Gm-Message-State: AOJu0YyUao1IhSVsUhSb7dJJxrxDBAoNHXPTtMquiqTSOB6xDAZzCFjA
	hztAnAVovrp7UJJwYzJNb/KP/ok9sIsqvQQYnoweFRPZKwWRczlvoEf4QGuo7R22/Rqc9C2jWAI
	eZbk6wQCqbAGdbQg8NpJKGFCT/QnDDp8=
X-Gm-Gg: ATEYQzxb2SqJtHODEAVO3f206EWPDKg4Ns1L7mk+PYtLc3UdEArlShS5NIhNYT1t505
	m9WRkNn3pFP+dz80wcTiPs5CKf4GIDIc8+GkV9WZWHEIb5Sjoll463crYw0ttMXDXXTP9KHDSdM
	QM1dZb6/S6rJWKG9xCB9EFLpUapmG1i7uampSalw4jTS7lcoVf5lYcQ+J4FgLVs62LI4zR+rb4p
	SRXjUd1KlvNpPjxff6CzWPa0DSN52RQKyPfxbG6jA/D3OH3SWeli27MsUJLZi/q0v51/Zq0zsjK
	OKZAcA==
X-Received: by 2002:a17:907:d20:b0:b94:827:c561 with SMTP id
 a640c23a62f3a-b940885921dmr839250966b.4.1773060250251; Mon, 09 Mar 2026
 05:44:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309103049.22169-1-bharathsm@microsoft.com>
In-Reply-To: <20260309103049.22169-1-bharathsm@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 9 Mar 2026 18:13:58 +0530
X-Gm-Features: AaiRm51MeZGB42U6Of-ndj1kWrLWpw3HUpD40MPwjn4ioQmPFdZ8A2eaEwskY-Y
Message-ID: <CANT5p=rzJ2czo1dFE2+oF6tM7z7u5aZKXJHqCn3OBtpMaHBwFg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix in-place encryption corruption in SMB2_write()
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com, 
	sprasad@microsoft.com, pc@manguebit.com, ematsumiya@suse.de, 
	henrique.carvalho@suse.com, bharathsm@microsoft.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 4:02=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com>=
 wrote:
>
> SMB2_write() places write payload in iov[1..n] as part of rq_iov.
> smb3_init_transform_rq() pointer-shares rq_iov, so crypt_message()
> encrypts iov[1] in-place, replacing the original plaintext with
> ciphertext. On a replayable error, the retry sends the same iov[1]
> which now contains ciphertext instead of the original data,
> resulting in corruption.
>
> The corruption is most likely to be observed when connections are
> unstable, as reconnects trigger write retries that re-send the
> already-encrypted data.
>
> This affects SFU mknod, MF symlinks, etc. On kernels before
> 6.10 (prior to the netfs conversion), sync writes also used
> this path and were similarly affected. The async write path
> wasn't unaffected as it uses rq_iter which gets deep-copied.
>
> Fix by moving the write payload into rq_iter via iov_iter_kvec(),
> so smb3_init_transform_rq() deep-copies it before encryption.
>
> Cc: stable@vger.kernel.org #6.3+
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/smb2pdu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index c43ca74e8704..5188218c25be 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5307,7 +5307,10 @@ SMB2_write(const unsigned int xid, struct cifs_io_=
parms *io_parms,
>
>         memset(&rqst, 0, sizeof(struct smb_rqst));
>         rqst.rq_iov =3D iov;
> -       rqst.rq_nvec =3D n_vec + 1;
> +       /* iov[0] is the SMB header; move payload to rq_iter for encrypti=
on safety */
> +       rqst.rq_nvec =3D 1;
> +       iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> +                     io_parms->length);
>
>         if (retries) {
>                 /* Back-off before retry */
> --
> 2.48.1
>
>

Looks good to me.

--=20
Regards,
Shyam
