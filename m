Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82C923C4FA
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 21:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771189710; cv=pass; b=AM8j/HO2LYDnyS+TH1iD4fdpZg+trGAojyUGxpJgnTEO5weAQEB4OC+wxXdzq0l4CIAAFkwSGcSSRXTZ03zCejza/ZvQQ0Mm2Wfs7Jcq6JuTYaPtpReZGZJJyRMOPXnf+45RHzeI3O1d0ctA5RFURiVMmkyfKM6oIX7Jcj5vPvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771189710; c=relaxed/simple;
	bh=7l/ZymWKj0eLurQ0Vt8TS7PQ7tdnGEmDZwt7EeeqJo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B8ZrOimrLihUlpE1w+4lndWLaYIrrpxsrjTDVHx8cHpmerl48yCdxClKEpf3yAlid8MlS40jTSiXTV8YPejs6jCxg4rJfwCL1PogGvmrwzqZJK2B5rqQlysbRdQCAqpPl25wUy2srka4Gf+IyL9scEkOjHBJOoaYA16IPoDyNFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fdt66ZlL; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fdt66ZlL"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8947e6ffd20so34217086d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 13:08:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771189708; cv=none;
        d=google.com; s=arc-20240605;
        b=KxmsrdchBcQVtLRWBcX8pXHN7HXHXjQ/v7jxDaEiw5/unL78VxeO8HNntMQ17fxfL1
         K/y93COOOi/pnjzIHtuQIDU67atq5r+fK1caXfY6DuM3BIey6/tKXxPg7F7cUixvMyiV
         DCb4YWFdRi64se0y3RixDidPvefpsUpVFUIhhbTF2Qfko+DvP5T3B3HN/5md7PdfrRJn
         MFCDAu2w1i3OhvRXnvSwN7yyaGJjksGnzZvBmfobpO/I9ZGXRtt4ZEwZ890ZMm0QjsUp
         +6LRvR3t+D9ZWBdwbK4V2uW2/j2vkgVeEQmEZgxVI9cdIANOaVH8+EMRDkhoyOk8AaQ1
         I2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eVxAukju8Xw754N8JNtmkJ3zmFWFFIBd1l11oeVhrbw=;
        fh=gYB3LMaUUq8E2buA6hzved46qcwrSK9O4o2IAHpB6Zc=;
        b=kX3aNxXzFRAHVDN1/sawDvqSYgjLt8UQRvtIiwseRbvqdE1+VU4H5iAaqptrzv5dy5
         lOhR2N4TcXxqIzGVicny24V1FWnwbDSAS3QV/9kiau88XMzqzxZPxDWKA1Hvw28ETf+k
         tDoR8+VPRwxRtalalFT2QRFI69hU86fSv1RsL4PUzIJVXT57PUjxXT3CE6puYgbL1m1B
         +3B7WKsX3ygF69mQQ+6cSbm56S4D4dMe5fY9GLCA1qQL/3ujLhokHZJXk9UsyKNiCo6e
         MHka54ZZjHowCIkkATF+7BrqgoIUD9HmNP8EDl/LB6p7QYNcMDEUh+V3zVqLJk4i4NNj
         Tcbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771189708; x=1771794508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVxAukju8Xw754N8JNtmkJ3zmFWFFIBd1l11oeVhrbw=;
        b=fdt66ZlLKdvgLQzycJLHvcA6T/kTakwjey8v2vdKiRtaaoUMyJHKTttGAeHqgGDoSu
         sWPWaa9wPEdVxoL8dRb/t67laddI9EPYeL8CFl0dAy1qzC470UHQJQGiZC4qEnfimNOV
         p4RZqZbz1zy+ZFp0InSAxR/+uaLJI1nkCUrBun3q6ToXFXvaMstViX5zjDwDJfQidMKa
         MF17bYqqGaJ7+fKqcWL1aNjJb/RKt9fDhdRZy4eDuxZ8pqhK7fCj5lsjgC4ljNWxraC4
         FhNim2bucC6fii9HgGhmxs/LR1/hSnRpMxgnCcDQI44KHc+yM4MppjM42bky9lSBXvOk
         cW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771189708; x=1771794508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eVxAukju8Xw754N8JNtmkJ3zmFWFFIBd1l11oeVhrbw=;
        b=NUCarA6+CtxR5ZX3X2KwXkzWAxT4i8hudlSMRV8YWFCWEUjBJcu8bOcjq7W4dSfLC0
         Bc0Rts6XTrbVjamc9F30iXslI6JPQLbM73cOGLClKa488tnTkPr/B1bKmrj6ShAumh50
         6iru4/5V4eZqlF5Aua4Z9Ysf28tbPKXnLPCaxmPaGtd00pJmh2a8D0Yu5948qZogg4sl
         uUjWF1KNQhmgTCkE21kw/9M8UG2FD2aawB1ox4tmsFXpAYRZ7Jqh2e8h8o8zQwWY2ZFc
         NNk3YFhELFBf3thAgtUvuQbKpX/Q3sRGVqTHDXwksi4SfRROs7oQJqU5wetc4jxaI1Vz
         igxg==
X-Forwarded-Encrypted: i=1; AJvYcCVDXMvCKQ0HYsjttPUhzccZ4KmZW1aJSFrFC09m33Mn2T/hWMxnyOfMFw6zgh+t8KivR5Z07omcBOZT@vger.kernel.org
X-Gm-Message-State: AOJu0YxuwK7MugJcZApC/6iMp5z8nLI7XBPdA291N0TvnW6idsdpRkYL
	9QazyoK55ARzOHBivHlKWu9r2F6RWLpiLBNz4IxuqzikoCYeOtkpDIAxNoNRPfRTT0VaSbD5StW
	MwSL7Gv+UiiXdCZDKLYB5/6MWIM/rDNU=
X-Gm-Gg: AZuq6aLEa99BNojN6XPyfY5rmeKeIQmlDEQsFYFIBBjgvtPh9rdwJ0A9SBkhv7ly5R2
	k5dfkIb835A3iDIHvQFJD8716NWxUV1VPrxUbXdTOZBehDx/Ys3doAVtTvphR06bSljx/whG7dU
	OUqDHvQthwydP6hhSMRx5nitrWJR7Lv5k9UWcYzcSRt2okUb2NHvbbGvz964rA1bU64wMTnZrfo
	ngU7SuZBJ6Girt7E9NaLjqRP/SVQH7Mmp9IfEUlNNrCLXeGKU2ktnd/k6I5YEES8jxBcWjtw+oE
	KUPDe7ycnh653FJtKM5sLvviMv0OEyplDkCnGID4dhiN2MYNs/9CyridXnr+LH85M+vGh5cLyTi
	lq3dUE2WWGLkhjs+PBqBZL3F9AemSJcdetf6X/EyVVoociWmdOV1AdJhyateIEgxkXPjfHTLclb
	WijDQFKxq2JbIcVX+hgFvtHg==
X-Received: by 2002:ad4:5f08:0:b0:894:6667:7005 with SMTP id
 6a1803df08f44-897361a9075mr136583306d6.35.1771189707717; Sun, 15 Feb 2026
 13:08:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205010012.2011764-1-aadityakansal390@gmail.com>
 <b36e2732-0678-48c4-a50e-58512b4d9f6c@gmail.com> <CAH2r5mt+608DDhj93Fa55PZ_-1yfJZTa5v4LQ-D48V9ZYPDJUA@mail.gmail.com>
 <edd75933-91b7-428e-b88b-dcc4e8bdcae7@gmail.com>
In-Reply-To: <edd75933-91b7-428e-b88b-dcc4e8bdcae7@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 15 Feb 2026 15:08:15 -0600
X-Gm-Features: AaiRm50-vulH-WR3NJZ-2SEItY9OeFLWXAc7FNLUa1guCfAle4349FpJscyS2YY
Message-ID: <CAH2r5msF43X+Gm-7eY3m=wyf+K6Hwzxx0522QrqD7VSWeJJwog@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: terminate session upon failed client
 required signing
To: Aaditya Kansal <aadityakansal390@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 15, 2026 at 1:23=E2=80=AFPM Aaditya Kansal
<aadityakansal390@gmail.com> wrote:
>
>
> On 2/16/26 00:01, Steve French wrote:
> > On Sun, Feb 15, 2026 at 7:17=E2=80=AFAM Aaditya Kansal
> > <aadityakansal390@gmail.com> wrote:
> >>
> >>
> >> On 2/5/26 06:30, Aaditya Kansal wrote:
> >>> Currently, when smb signature verification fails, the behaviour is to=
 log
> >>> the failure without any action to terminate the session.
> >>>
> >>> Call cifs_reconnect() when client required signature verification fai=
ls.
> >>> Otherwise, log the error without reconnecting.
> >>>
> >>> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> >>> ---
> >>> Changes in v2:
> >>> - reconnect only triggered when client required signature verificatio=
n fails
> >>> ---
> >>>  fs/smb/client/cifstransport.c | 10 ++++++++--
> >>>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransp=
ort.c
> >>> index 28d1cee90625..6c1fbf0bef6d 100644
> >>> --- a/fs/smb/client/cifstransport.c
> >>> +++ b/fs/smb/client/cifstransport.c
> >>> @@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, str=
uct TCP_Server_Info *server,
> >>>
> >>>               iov[0].iov_base =3D mid->resp_buf;
> >>>               iov[0].iov_len =3D len;
> >>> -             /* FIXME: add code to kill session */
> >>> +
> >>>               rc =3D cifs_verify_signature(&rqst, server,
> >>>                                          mid->sequence_number);
> >>> -             if (rc)
> >>> +             if (rc) {
> >>>                       cifs_server_dbg(VFS, "SMB signature verificatio=
n returned error =3D %d\n",
> >>>                                rc);
> >>> +
> >>> +                     if (!(server->sec_mode & SECMODE_SIGN_REQUIRED)=
) {
> >>> +                             cifs_reconnect(server, true);
> >>> +                             return rc;
> >>> +                     }
> >>> +             }
> >>>       }
> >>>
> >>>       /* BB special case reconnect tid and uid here? */
> >> Hi, I am writing this as a ping for this patch. Thanks
> > merged into cifs-2.6.git for-next but had to rebase it to merge into
> > current code.
> >
> > Have you verified the behavior of default (smb3.1.1) mounts as well?
> >
> Thank you. Yes, I have checked it for the default version.
> Tested for both client required and server required signature verificatio=
n.

You were able to verify (simulate) it as well for default ie SMB3.1.1
(not just for SMB1
which this patch fixes), and no changes needed for SMB3.1.1?


--=20
Thanks,

Steve
