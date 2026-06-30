Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57E733ADB2
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 23:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782863701; cv=pass; b=gBlSoNc11sAtCZgAH0KDoZUyRPqAfJ4a1UO4mhP3RrXA0aoeslbSXF5jHWdqBlh3QfszOfcR+jZmV6JmYrCN2YII7ir6a0OHxTMMX1mireYfMwDxp1ySFz1K13QyrnC5bvfDvtCePk/hySbFCCK3Ki+1On+zJ2YunV2JkRlowzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782863701; c=relaxed/simple;
	bh=VFKTazKxgYnEB/K/9ppbBrgbpsras6tcl/iKBqAt7a4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uomw0nWymDj2IuF+e8KmaUDTAonno3K/Yynd3NOmKYm1v3bu53MSO2jaZjcogwvs/q5sEUYeHIqSu4F/WdNml529Pu4dBFYnOWjMp0IBR/+STR9jo03vUk0x35FmvJUVhom0hIs7s4E8RgFIAgXtKy/4fGbtLfoj7h94+hN0tL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LwIV4Jnp; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwIV4Jnp"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8eaa7b5e31eso10309746d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 16:54:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782863699; cv=none;
        d=google.com; s=arc-20260327;
        b=nQkll81XnkIZ2Rh1hRG1J3hn1nbpmdILMMvUJRZjBvjIudL8yBFCXdCxHYp7ieyr/p
         EuEzqs8toKkl5T1ag0hvudTHhwD0SIRUWUyjfC5AOvdslasstCfHvwVYTcSO7Q6QuYxR
         OJB7x+akKBCtFxU/tTmjTKLr2FyH9X/4LQZ2WF5uGtCagiTlMh+dhDbLG3oK4iVrMrr1
         IFcLiVdha0qWTtBjD6NHyZmzLS9L2yafDEgBcQvO5BpopgVkBuEjRiFLCCjJ8El9dH86
         sz6qwCnK8WgrwcXJMo1/VIo/hc8StosnInsBw4G3EINp01rRAN4qswllRiuE61U+lw1t
         8yMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kC3bxahuis5xWq9GT1+0gRbbixZiOHD7l7KOGR9ctnc=;
        fh=jswW0zAyzh2mnEgFFeUOHEYoxTDtP7NkmW3ZQPiJu8o=;
        b=FBaYfknzjz3nfoJtVjoOiTzKgsyQDubMcHK93xUXExApFu/nzz8jl+wjRYRYHjgkwm
         XrJNH7WaHFWV4cmGdvaOmxKK4qGpNE4+NuBn4q3+EyYUF0r2Zjvj+63b9S4lh8i7HbkK
         9cfrpAps2d53OE9l3TQT455/ctNOVu5e1WJxpio7d84JlFK6+IafD/AU0LWV28vxl+rq
         jE91JA4HFI5xihCwZPZjAqeD8gztDxCtXyWEUWJBSF3HL78GJ5rtvCVb33jyGfdFMa44
         3lqdRVQFBX6T0kzA4opZ3/j7uBveSnrnAbcDysL+jmOCefsW875QLFahjVaK6MB1kjWH
         GaUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782863699; x=1783468499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kC3bxahuis5xWq9GT1+0gRbbixZiOHD7l7KOGR9ctnc=;
        b=LwIV4JnpTNCO97cnRROWcfTGRZZDCQBxv7a852vK+CF+oJ5WZ9QIPrzvzq7mh2N0/Y
         gYo0JfSsHcYyXHTSVKoMpkQfoOgcmoAjPJsIFvoZXvNWhaZ7Jxu2Z+vPsKzu9Z3aasqE
         elxjSAZR270XuUdCMm5cFJRm3wYAXFEHpVXKNy110FM4R6NjK+tJwu47s4+9E38CrRG3
         axOtFTAk8RRWEvNbhr9Q/AmrgaeSWLB4AnB6A6zgNGDisoHjRUk746n+nfXq1YLsaCYN
         z8JGiAwTyxi462X+Y8EzzPjG9GStwbTwMZe8ZZ6pdnA+J644s3ClNI+NNAazZIiHwWQw
         alTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782863699; x=1783468499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kC3bxahuis5xWq9GT1+0gRbbixZiOHD7l7KOGR9ctnc=;
        b=Y9TBhVDcTGQ3TAdxW7yplmqxQpeTeXkMSW5UTX55tGQ1winEKUXHPMteTxBmFAQ7Zf
         VeIw6Bgg2EkEXUgbfB63RNgfjsnINtiGK2zJJh3W69X3uA+8cPAH/RWePPUFdUsDGz9T
         YuvreD/DwG57UHRR40yygN6bPnRUZd9QRZDz35yHzZZfWQRNcAKq/Hp/o7dUOs7k+bDG
         uZg2HIEfnnJcFE+HDkzPYR3+ogBJjpVQD6u2C5nwOO/UbJK5CkzvXcMR7ekQMGrCTkI/
         +n1bI0f3JF10nkFJ/0oZCy67RYWCWh/LxFMnbv5XIVDdVB4RaryzqBiyW4EMYhSEvhFR
         KBAw==
X-Gm-Message-State: AOJu0Yx2wxwWm7g1ysC6qGLLU0K/UOieLjEjOXXNM3hodmOarzY+2a+Q
	an9x0ZDYVN33Of0gq2uuWviVA6MN02jhcH7I+jqc8wQCqhR+iGvsJr8jM3ZfXpjsfJQ+SXK+sNJ
	BxdCtfFv2H1tmMufouHTuSePDFmoYTk4=
X-Gm-Gg: AfdE7cllrDIYwMYaH/Kbdu/O3Ia8BCDdH1k+vycUxKRBvF4XUFYiwZrnJVxRRahy3Gr
	WL/bNZ3LwSh+kaBKSR2536UFFpiCo7xr5bPWYlj96lRSKO5My7+whp2fuUP0Azosn0CprvPmov0
	fenPT25sLvkCcbqMPGkTLlPiPyVsahVMAOW60l9QrCCoI8GPsVTE81acQZT6TIYCjr57wjERsXW
	7+7M7p2qMiaux6ZEXArqpCxfvnT7yVh9fUwJ4J4Bq9tROj0vMdTEN0Ov8svEcIFUgzBuAu0wMVm
	yTLP8Z1/i8k6ysKuc37L2S+2WpDHTvnEJckMoRp9MztBjfs3iQwrYsuDVPl8IfBs4JqwjZwdidx
	DCFO7HbUMWgCDmPijVE2ZwTJjcHVpVrCFLBsNg4vzaeJ52Kd29nF72COiP9t2AUC+VOMQacVtnT
	dKIPylrFqWuBI=
X-Received: by 2002:a05:6214:55c1:b0:8e0:c0f3:a2cb with SMTP id
 6a1803df08f44-8f24ead200amr52257496d6.0.1782863698871; Tue, 30 Jun 2026
 16:54:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782579149.git.xizh2024@lzu.edu.cn> <eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn>
In-Reply-To: <eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn>
From: Steve French <smfrench@gmail.com>
Date: Tue, 30 Jun 2026 18:54:47 -0500
X-Gm-Features: AVVi8CcuBeMrNXb0-XgqgYKkYBbsJyadiNW7THAj8x5pXANqM9UhfApZiz5jxUE
Message-ID: <CAH2r5mvzR7npgJirx9e4GAKdbva9YAJBj6P71bSxJ3SbpF9dGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: fix create context out-of-bounds reads
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	pshilov@microsoft.com, aaptel@suse.com, yuantan098@gmail.com, 
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn, 
	xizh2024@lzu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This regresses all xfstests when I tried it.   Looks like a bug in the
patch so have not merged this one (although have merged
smb-client-harden-POSIX-SID-length-parsing pending more testing).
Let me know if you update it.

On Sun, Jun 28, 2026 at 4:20=E2=80=AFAM Ren Wei <n05ec@lzu.edu.cn> wrote:
>
> From: Zihan Xi <xizh2024@lzu.edu.cn>
>
> smb2_parse_contexts() validates generic create-context layout but does
> not ensure each handler's minimum size before parsing. A malicious
> server can supply a truncated QFid (Query On Disk ID) context with
> DataLength zero; parse_query_id_ctxt() then reads fixed offsets past
> the context boundary and triggers a slab out-of-bounds read.
>
> Bound each context by its Next field and reject lease, QFid, and POSIX
> contexts that are shorter than their parsers require.
>
> Fixes: 89a5bfa350fa ("smb3: optimize open to not send query file internal=
 info")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  fs/smb/client/smb2pdu.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 3bd300347f16..840bc81718da 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2405,6 +2405,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *ser=
ver,
>         struct smb2_create_rsp *rsp =3D rsp_iov->iov_base;
>         struct create_context *cc;
>         size_t rem, off, len;
> +       size_t cc_len;
>         size_t doff, dlen;
>         size_t noff, nlen;
>         char *name;
> @@ -2427,9 +2428,18 @@ int smb2_parse_contexts(struct TCP_Server_Info *se=
rver,
>                 buf->IndexNumber =3D 0;
>
>         while (rem >=3D sizeof(*cc)) {
> +               off =3D le32_to_cpu(cc->Next);
> +               if (off) {
> +                       if ((off & 0x7) || off > rem)
> +                               return -EINVAL;
> +                       cc_len =3D off;
> +               } else {
> +                       cc_len =3D rem;
> +               }
> +
>                 doff =3D le16_to_cpu(cc->DataOffset);
>                 dlen =3D le32_to_cpu(cc->DataLength);
> -               if (check_add_overflow(doff, dlen, &len) || len > rem)
> +               if (check_add_overflow(doff, dlen, &len) || len > cc_len)
>                         return -EINVAL;
>
>                 noff =3D le16_to_cpu(cc->NameOffset);
> @@ -2441,16 +2451,23 @@ int smb2_parse_contexts(struct TCP_Server_Info *s=
erver,
>                 switch (nlen) {
>                 case 4:
>                         if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4))=
 {
> +                               if (cc_len < server->vals->create_lease_s=
ize)
> +                                       return -EINVAL;
>                                 *oplock =3D server->ops->parse_lease_buf(=
cc, epoch,
>                                                                        le=
ase_key);
>                         } else if (buf &&
>                                    !strncmp(name, SMB2_CREATE_QUERY_ON_DI=
SK_ID, 4)) {
> +                               if (cc_len < sizeof(struct create_disk_id=
_rsp))
> +                                       return -EINVAL;
>                                 parse_query_id_ctxt(cc, buf);
>                         }
>                         break;
>                 case 16:
> -                       if (posix && !memcmp(name, smb3_create_tag_posix,=
 16))
> +                       if (posix && !memcmp(name, smb3_create_tag_posix,=
 16)) {
> +                               if (dlen < 3 * sizeof(__le32) + MIN_SID_L=
EN + 2)
> +                                       return -EINVAL;
>                                 parse_posix_ctxt(cc, buf, posix);
> +                       }
>                         break;
>                 default:
>                         cifs_dbg(FYI, "%s: unhandled context (nlen=3D%zu =
dlen=3D%zu)\n",
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
