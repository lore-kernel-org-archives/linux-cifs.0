Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C838BE7
	for <linux-cifs@vger.kernel.org>; Sun, 30 Mar 2025 03:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743307129; cv=none; b=UF9s1dFdfGVpcbnQkUVDawhMQtf/p28WJaFTGUTt9k+xm+R03WWDh4fhfDVaAMC8EP5fqiqWfmhWMfTbWvQi0p0zUf8bpCZnxGx+NCp7duPDgM353RGHvK0Ngn4YtE5hdZTEBxpUsbFDCRbt65Eo3g6UkdvXA3eouX4a2MV0ZOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743307129; c=relaxed/simple;
	bh=Okbz/aIkqwpMftdSZ4AWw0LKdoqE7ipPdCYwmW1ZWBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=hmA/OKGfdFnlP0zzX6Y9h8y9F/Cj+P9RZyWVqLntlJJYh08F3cAHhpB3DW3PLK555hcSHmQrFt0ZXv0ot7Sv7yKbJQ+BQAupyQFQHocTqsatTRCjIrHJUPFoo6xFqKw583oSxO+eiUVjwPgOTOoW2TC5/8rXbQFGJ07IicQ85d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G5UhJ0n8; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5UhJ0n8"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-30ddad694c1so16209331fa.2
        for <linux-cifs@vger.kernel.org>; Sat, 29 Mar 2025 20:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743307125; x=1743911925; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOVX48A4gIqA2iTKvPPBYWsP3A/DWX3ZHD+njMhbhOw=;
        b=G5UhJ0n8sm3pVQ3XqnUUF6CyhVksPacS18a8M5yRRRP4OGXKH2p0dwuEG51RyrqZjA
         l9Bj17RqSPG0hKcSosp1nTqCHAF+tqyUp+bCqDq6DjjTDFdDw2/x8YfjGcvk1nmhBoJ/
         +Zlvx5dplMfA5Vove2Nv+4VF9cryOjJ60sA36CW/zn4siylKp7B25uLggHropI0eSrgF
         8f13FQRFyXRw6ztVFL7TeY7/ZSomvPCTDqXJPuFSW5CXWk825T3/Su6RdEKniw0i9Zu5
         oVW5fbOtg/26nDeNLZCo8HxPNH5wqhNbC16OY+9Fvw2P3c5rgICaL9XdRGVtzJb5mTad
         Xt9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743307125; x=1743911925;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOVX48A4gIqA2iTKvPPBYWsP3A/DWX3ZHD+njMhbhOw=;
        b=wbKST0u6xv5J/FbzVii5t0mDKbzkEifpE1G6RC/qztb5PiQrn6vBH3G+3lJsJLTMPY
         wMEYuKvtchY+E5eaq8JNMegoRMVAfeNXhJoGoXvqkQk8ko1tsZy9aw8LXcmEhdh9yTNX
         KZNKb0ZKuiIvZTfrphrVWMhEg805p3DAi/zNtHAoVKssQBsOkXegI/U2XWCheq0FC3tO
         YcLvgcNP3ozMTo4g7/eUdwD7Ejc0wS4zRiMlXhC696i86przRNQ7IEWVeFUTpxPuxoVV
         aSU+vZDORVO+hlSHdpgPfvHhe2ZLhV7VZW0MNMG55QzEqbACqqq9M+73u9qntZZRTu5J
         JRuw==
X-Gm-Message-State: AOJu0YzZAaj6sOuPG6pkC7cHHGH3TlPNJZn+hO/0kRcp+NlBLu/uC0A4
	CtBxDsZaqiM1LZMA5+azvwCFKmpFFMyDUDPwfdm/MY5FCGon+vYNUd+kma/GUgXM9rq92jcmvoa
	CdAYzgDgow2GWqN1PoEMtk1exo+oihw==
X-Gm-Gg: ASbGncs/a+opQTJEr6BtE/bYcSBLoMFQbDaI+dYo+OG7cHz4ihAWqctOGT8g4yCHlR8
	z1Hxhrd5T8QjcSxuaUTKizpiLf8DvPUn/yL1fyEVbCnK2CVSc0HOrx11xjKxN172aXxVz9zsv+H
	lBR+YoOhcTmFpwYe6tr8BBd66Jtfx5pMs88E+bM3PgjSqh4j7qeCQTWA3cG4U3
X-Google-Smtp-Source: AGHT+IHMQ9cUBaPZ/XXX5BbXWNw/NFYnmFTEiku1WTwocwXlaAdZgDJw/oEFU2PAaR7OJ4ctkoMjnZAOllQQJ/4myjo=
X-Received: by 2002:a2e:be09:0:b0:30b:ad2c:dfe4 with SMTP id
 38308e7fff4ca-30de02fa546mr17366661fa.30.1743307125192; Sat, 29 Mar 2025
 20:58:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z66BwJnHAI8zDOzP@linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net>
 <20250328061312.3043039-1-aman1cifs@gmail.com> <CAH2r5mtmHNisb91cr4jSBjuTRJp-J2DOHDaYmSRTM8MbdKEG_g@mail.gmail.com>
In-Reply-To: <CAH2r5mtmHNisb91cr4jSBjuTRJp-J2DOHDaYmSRTM8MbdKEG_g@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 29 Mar 2025 22:58:33 -0500
X-Gm-Features: AQ5f1JoWB8xbjvUIQxNhr8ktwVu-eTIey0mot6QlVDAFf-qwkbCUiBYp_HT92eE
Message-ID: <CAH2r5msN-mtDnjUMVYUp0KD=+G+TTZvY92v+7OqkGegRmdVBfw@mail.gmail.com>
Subject: Fwd: [PATCH 1/2] CIFS: Propagate min offload along with other
 parameters from primary to secondary channels.
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have also verified that ignore_signature is not properly propagated
across channels (the original patch , so am looking at the original
patch to verify the remaining five fields (that are propagated across
channels in the original patch).

On Fri, Mar 28, 2025 at 1:13=E2=80=AFAM <aman1cifs@gmail.com> wrote:
>
> From: Aman <aman1@microsoft.com>
>
> In a multichannel setup, it was observed that a few fields were not being
> copied over to the secondary channels, which impacted performance in case=
s
> where these options were relevant but not properly synchronized. To addre=
ss
> this, this patch introduces copying the following parameters from the
> primary channel to the secondary channels:
>
> - min_offload
> - retrans
>
> By copying these parameters, we ensure consistency across channels and
> prevent performance degradation due to missing or outdated settings.
>
> Signed-off-by: Aman <aman1@microsoft.com>
> ---
>  fs/smb/client/sess.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 91d4d409c..35ae7ad3b 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -522,6 +522,8 @@ cifs_ses_add_channel(struct cifs_ses *ses,
>         ctx->sockopt_tcp_nodelay =3D ses->server->tcp_nodelay;
>         ctx->echo_interval =3D ses->server->echo_interval / HZ;
>         ctx->max_credits =3D ses->server->max_credits;
> +       ctx->min_offload =3D ses->server->min_offload;
> +       ctx->retrans =3D ses->server->retrans;
>
>         /*
>          * This will be used for encoding/decoding user/domain/pw
> --
> 2.43.0
>
>


--=20
Thanks,

Steve


--=20
Thanks,

Steve
