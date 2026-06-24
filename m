Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D442F360A
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267787; cv=pass; b=uHVWK744F8NpE/hCqEt30ZshgC1zmysagutiwo0eUf8K/UJfBo+U4barN8RoeIGKV07iPXatjD/Wv8BhODevlJFF+oqSIO8y9A9HKzAOnU9T8SWhyP0+EEwarxH5P9wYbCDqur9jjeSYQbnJSBqlIJu3HFvG0WYjEqsYyJvQrvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267787; c=relaxed/simple;
	bh=jsac6rbK4xMauh48LXVsFpmG/TamCoh2jALMIzpP6z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+ZJo2dXhH5WDggMuWPVM+UHRrupOe2CiEmXCZriLjujx6bQRkY+l0/U668WLqF/nrJGazM2IS/WWwZHmbHROxO/S/pL7QvDEWXsLljzZhCn198/HWIszUxeMFPQZne26UxPfqRPGbL1nkLMzC55OSToFxtud6O1+BZA/z+tVAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HxFNwmee; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxFNwmee"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8db4b249ebfso7146136d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 19:23:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782267786; cv=none;
        d=google.com; s=arc-20240605;
        b=BC05yQS+Cj4ai1D31pTt2UqnxVQ396ObTHHUFheAaHdmaCWDlaIGVJEnFwrJxZLUbv
         sphDsvMVk3GZBpTDk8Cz1bRKk8JTtsyXN7zUYTwlNSGEsGskh1ztO7RR1vSEP4Fd9ie0
         iHkW63Eswf9Li9dtpMbxT2i7pqRasxlcX2BXRjNCfwRBPM0vgSgiK4tHtNCKOHbsGtis
         Zre6EyeYCOvjMR2C3qUWCUe7+cN9lHPw841bKU82wWJcXp6zsX72krzSKeV1a7YfXnB1
         ARsLg5XBMj4nzz3xcuboiLkiAWjE4MpCjCZ/outC3Coy5pcjPMbnChB1VzBV6ncukjeI
         5ocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UG0ncpJL7hCVBEGIAE8tEHhgRG/Yb5WAzpKilo1RSVI=;
        fh=f+ekOSf7zbvlcqtdZ+h7SX7xT0iC3XH4zO6s0oR6C04=;
        b=WundnLd6WXQYmiDy4+S8b5qqTQEiZ+jcE4KA54hXdB34zmQoDZGWl+txwUHk9REqNp
         mogYWRr2aLEh5BGCzH5oUGzpKXGPH17BmKLAD7YjdRh6bfKgv/rvj3XqFFWzeC8+A7Qs
         NdbY/LLuqV4ggq2NoSbKQvVWon+WYddIvXDZ277WMtYMdbUOVlr9K781tocnMwmX/sAn
         wGQ/Sa/+SSjToOZSpfrNBsLc+3KqzEYnmEk8IhvJAsInsKiGlgH66tvJwFjVi/vN3im4
         uAmW0Mmn/hTqsuDoei7Wzozqh0w9R9NNbI/kSkHqOTBfEw1QVLk/3djhngYQ12pU8JLV
         kx+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782267786; x=1782872586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UG0ncpJL7hCVBEGIAE8tEHhgRG/Yb5WAzpKilo1RSVI=;
        b=HxFNwmeeLELoJKEcwaB14XD2BST1mMymKhSV69GCNC6NJcAHGHMads2g3i948fzDQZ
         I1oQFRLCvEoPg5gDhMfVtkTOcMa71uW33eWmW2xvy2t0hDnnbMAqlEmtL5BVsaZDNx/C
         eeR1AD8C0b78yE3M6XQ3AHBjFy3jGi6vlTbxJ3nKy3UojYhmcXFTC2t2K4CwgPzuSLQ9
         aCS9FH8r5pM35SLCxrw2NH8weEF9a8t+ZD9vuWvUc+EyFsAo/LkzFbUZagXntlHLX0pQ
         1FCNDm1AqRlqr672QrMa7j2Jb1UAkMTToMpnaO7T6MjS16o46uPBH/EdWMdO3A9nUWyE
         v/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782267786; x=1782872586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UG0ncpJL7hCVBEGIAE8tEHhgRG/Yb5WAzpKilo1RSVI=;
        b=ag736oHyA+nO3u1eKodglTcBwvRDREYZ9UHt5mchWNWvWk33WRtzTbmcOAkEM2MlwT
         q4Bq/jTIsTF4+T5Cc8ZWR6QBb4xwGR+eXBYapgeodtyGMdw+S7o8I7N9oSBcGQrI7SD3
         88m8y0RLr3UZttEDXdRtlYGNmILpSEj6nFy044kj3SfUP7r7mCinKb8T2cyOVbr7nncs
         8bHLiM2WTJe73s4/gBsb8TXBGHxoC6b9s2DHG22QYioWfUZdNviVbB8xOFLdwuY001mY
         QUmE20smgLKyUUL/kW4OJwMRaAY1NwdlUqQOGn8DeaCX7aY6IczBQUx2wK3uXPL1iPEd
         dMXQ==
X-Forwarded-Encrypted: i=1; AHgh+RprzD4COkGy/klk9IzDNVzJ8NSydiDiFUDYk0KREkr37trDqrWf/JA12w0vkwIKpm8yxZ3VFZiAN7JY@vger.kernel.org
X-Gm-Message-State: AOJu0YxvOpuUQMzmBvx/26nsp3/JY9lMt7M0Hj0Xe/OcDz3inT3MqMe7
	Nw88ZTfrYFykQjj5rlCQGMRQ/Ge9EbV9UNp08ztDCBf0Tg/1+uAhUV+7Mi9cnoVQQdZx7uhrGdh
	cVi9WnnEzNJtDZGuveQG8j/TePItf5Mg=
X-Gm-Gg: AfdE7cmXTJjEEpVk6EcH2+efysgHEEAQ0B2FS0P2ore/+W2i1SPiyA0Sh4Bxtp3TZjj
	rrQPH6C8vNrEdQoy0dtieD4LEhCsiWt1acFk9EuCm/nhyTicpRK8TXPzDoAZouXuYlfGDqq6ct7
	HwN0J08aXUvS6s7G8OtfnMs2KnzmYM5pxzkdvWLl+z9ZwNY6ItP+NWyKn6WLtsQ/bn999LVRZ+q
	F0uM8CEtLYRfOk2QnfhqIDoDMHtXl9eb21qi00om7vKbjCCgodCk60i9/a6WM5QYTmVE4oG2/V+
	pnWhqU8vKfgaVf0o13/pFOdxfgOktjb+96v920KEUzhkv8VGiPkVrbfEqLRHCLZPnUVDZJfpUgn
	531b1GdZntj/r5o/74CskzjWVoe29Z0/1VsTiVtDJxazsnmysR4QL/KvjteWrMna4MyJwEwsrEP
	KxsMjeLMoppRQ=
X-Received: by 2002:ad4:5ccb:0:b0:8dd:8c77:69e3 with SMTP id
 6a1803df08f44-8e400732233mr102978116d6.9.1782267785732; Tue, 23 Jun 2026
 19:23:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623014538.1705722-1-haoxiang_li2024@163.com>
In-Reply-To: <20260623014538.1705722-1-haoxiang_li2024@163.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jun 2026 21:22:54 -0500
X-Gm-Features: AVVi8CcwBwpsQHfJ27hjWZbAayGga5WgChQB-ZmOBEjyw5fU0tfa3tIkMrpJFM8
Message-ID: <CAH2r5msb9j_iX5OBz1OdR38StoSsmSECtBkrMsFchff4OqDSxg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix next buffer leak in receive_encrypted_standard()
To: Haoxiang Li <haoxiang_li2024@163.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	pshilov@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next pending additional reviews

On Mon, Jun 22, 2026 at 8:49=E2=80=AFPM Haoxiang Li <haoxiang_li2024@163.co=
m> wrote:
>
> receive_encrypted_standard() allocates next_buffer before checking
> whether the number of compound PDUs already reached MAX_COMPOUND. If
> the limit check fails, the function returns immediately and the newly
> allocated next_buffer is not assigned to server->smallbuf/server->bigbuf,
> making it leaked.
>
> Move the MAX_COMPOUND check before allocating next_buffer.
>
> Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle c=
ompounded responses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
> ---
>  fs/smb/client/smb2ops.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index a8f8feeeccb5..c39944dd40bb 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -5111,6 +5111,12 @@ receive_encrypted_standard(struct TCP_Server_Info =
*server,
>  one_more:
>         shdr =3D (struct smb2_hdr *)buf;
>         next_cmd =3D le32_to_cpu(shdr->NextCommand);
> +
> +       if (*num_mids >=3D MAX_COMPOUND) {
> +               cifs_server_dbg(VFS, "too many PDUs in compound\n");
> +               return -1;
> +       }
> +
>         if (next_cmd) {
>                 if (WARN_ON_ONCE(next_cmd > pdu_length))
>                         return -1;
> @@ -5134,10 +5140,6 @@ receive_encrypted_standard(struct TCP_Server_Info =
*server,
>                 mid_entry->resp_buf_size =3D server->pdu_size;
>         }
>
> -       if (*num_mids >=3D MAX_COMPOUND) {
> -               cifs_server_dbg(VFS, "too many PDUs in compound\n");
> -               return -1;
> -       }
>         bufs[*num_mids] =3D buf;
>         mids[(*num_mids)++] =3D mid_entry;
>
> --
> 2.25.1
>
>


--=20
Thanks,

Steve
