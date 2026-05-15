Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095EC331213
	for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 00:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778806237; cv=pass; b=N0Fyl4UXvMGmY7jqzXN7U3YO9hdSVg1WVwJRw9k+unAnAurug+yVgZd323ZSeKvnRBJYFnGl9EPFB3QtKJ9jAfxYnkqp6RS+Ps3ZGPYzKgzHfxpuAohECrodl3GkaX8fQqGPIOawebu+4dB+PjLUCLgfDtlybSIogF/8+TepKHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778806237; c=relaxed/simple;
	bh=h7aZZPfBiNQip0iF1QmxBvNSaBlmSFlDsLahup/x09I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MEwqfIioPopNB6iPD+E8rRa2OsHtnxkTYG30RZ6u9/iCTW69Xjq6Y0fwEqD1oC8QPqBc+LiA3nHtxNo//P1WxAbkdU+gfD27y2h9pe7ps5uhBl4uMZOVikWBiZVnMPKlyTIV9/9ni61apdzz9dGvN7gx/jZLPhKfoUDHpcKtIys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4DdJ/KX; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4DdJ/KX"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bd124546379so733283866b.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 17:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778806225; cv=none;
        d=google.com; s=arc-20240605;
        b=Dxq58Q00rji40DodW4SbwT84wkc4dN4vQJdVaAE6KJS+QqaH6Tpj4MmAYaUnw52tqn
         vuKkCPdLiCKTHTPeihDML4AVIFflSFMFrfuTBf1OBeTUGbmRgzOCF07W2XkAA/wHINhR
         9Uczz6+uJdTgreJVCC4tCssYq9twyL6xVHpPtN33z/eHHoSGWUBthuH1s8IEqebthcfe
         ciOcYUO2ZDNstu2mtDwkrTop5L5evhsE8n+l/W8aPyFdUslvQw4mtcTV32o/DhHCbky3
         ML4Fwvc8H6RVP7cnhStR+wqYxyUH00f/LtjlSfwNxcWf2EbH36PIwyeKVCfnXqWOLO2c
         UFTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MM/tBbAryKwMsxmUqWSfBVPUIhCFEcLFQJCVxRl3Fv8=;
        fh=v5Ue6UQmH5b9J7MNO+sM3KMki0eXb9uVpyuzLmu59oo=;
        b=Bn+AFOi6xMWq+1hgn6557tAkNHtcdJSjfLCq4qv0WmHCq9t24UerOM6gHOd53BiETf
         7uf6X/tt2ZgzKCj/7mnKZzAnajkIoswamisMGkELZvCEZIl2li/29CBeci5P/FbDMD0F
         y/Ia1tVeYhnPV5Y1sEuNdPEssNqx7xMMiisT7wS0kmfUrnFwf84Xij0KHdTstynTwAwJ
         BgjWTS12bkttSo6B1bbQx2gPWk/C+RHrHJ0klfyrvwu1thgnSrr19PAtKJE7Ue1whycM
         LyZGvZsFp72xuPN1tdII1qrqeaC/Et4e1Nli4lIJm+zUYQ+/l/UZnimVlLvzZeYZu7iV
         P8Rw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778806225; x=1779411025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MM/tBbAryKwMsxmUqWSfBVPUIhCFEcLFQJCVxRl3Fv8=;
        b=L4DdJ/KXK2wYMlh92m9JfF+JRQ2ms5xCGW4c8tC0uLEL9Zsuei2GvBlQQ1VeX1nh3P
         u9GThN76hjHKGpnfCprcUKnpQTORtC2GThTNgO5H/B0FObbdJyaiwWs8n3FQtZIyD4IA
         4RVfgMHQ/MSWwfJHXECtKQ//3CYvYOBqqxe6w4V2DVSkYteKL0M3LUYKK3CmwKLXpOed
         x9jJOnjUEJGYuRjw2gdPBoTcWT4eFwMks7UI+oGkpzROS87QaCaWnJ3QJijELrr0xanm
         jHRvnPhVs09FeIbfh/xPwoi/1XW597qS9iLIsvBWW4vLjYy3x33RhA0p1gX51V6LaY6S
         8jmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778806225; x=1779411025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MM/tBbAryKwMsxmUqWSfBVPUIhCFEcLFQJCVxRl3Fv8=;
        b=X2762rqzoBxZ+hE/CcddE0rOUPAKnZHrib21S4h9dDMnzJ4a+ehVcpB3dRNE6sJ7PH
         r8q8vr5ihWhhvrDhgPeLoerk2TjJZWLQLPuOfehuqM/YmaWeixkYF6kli0GSnFi51Ckb
         Qk3+O5j0FgdO9+amxP/WNK7YEEcMaZBsXbMTbZerhFP3/+AX1u2UqxvNGnOL1ZYCOBrU
         oRHGYs3yKqzOER6/w16gdcs4+CrnkEdhw+/8BeDBGB9DfQyFJ2LQRoiXl7jf7Wpjk16C
         +mtpGW988gpQlc1XpIn2O4eDEzvQW95YQzVmFWcjYvlEMvZ/YCowStkFbd+iSu765i0a
         DedA==
X-Forwarded-Encrypted: i=1; AFNElJ9ArzORnfm96kLA5USdorj+H8w1X0aqeJsBkZCkLurR+6w2ZkubWAckz+NVYxGsB8+lq+Z7m8WEoeUk@vger.kernel.org
X-Gm-Message-State: AOJu0YwtPiCUlZFX3qtGxvm5vKQqfrNmNPB2CM6hOf8X6r5CWEi10zGz
	5ZGTzlKaQ9lH8b3nxNySmpYKZRvAM7sqrl3ezbmV8AZ9Z0z0Dpz2JLrKNHw/qELYSo/bLOIZbOK
	jK4S5ucKoV3rZfHQq0M4xaFxYFxluR+g=
X-Gm-Gg: Acq92OFBgWiao2Hmjq4cy9vh4Qs0AaYlGhZuFGSpk3RCnYzXM3LuFmhfT5CwcZxkiRD
	ycdwegqC7Khp3mSGQsJH9vyzXOfktdklydoVDOHmkwIunspmFq9zdrSlHwmgDQS8ZhdDCtpqCuX
	J1g+vGCojNcKlpPkmag3c7J1y6S4vXamiO5wobAruwGnLcI/ID8UI9fql08UOle7ADg0UewBtlR
	sWWKYPJ9ikftTTggEKrwtSrWr72lvSxH/k9EHTDByTKxDzdjC62cRKAPUjIbp54sZjANQ375NSw
	Of4rHg==
X-Received: by 2002:a17:907:84a:b0:b9c:aba8:87c6 with SMTP id
 a640c23a62f3a-bd5179506e8mr75199166b.37.1778806225168; Thu, 14 May 2026
 17:50:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514231825.63211-1-henrique.carvalho@suse.com>
In-Reply-To: <20260514231825.63211-1-henrique.carvalho@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 15 May 2026 06:20:14 +0530
X-Gm-Features: AVHnY4LVtZnz2SQlZ9QCXUQAQJNIRfd74bXKezzuMgWGVmlcWkRm-Z3HpDUfv98
Message-ID: <CANT5p=r1Y3h44dE62DB+VWbGOToQv5CGBc+dR-tr14vah3SObw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 4:48=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Commit 96c4af418586 ("cifs: Fix locking usage for tcon fields")
> refactored cifs code to change cifs_tcp_ses_lock for tc_lock around
> tc_count changes.
>
> There was missing lock around tc_count increment inside
> smb2_find_smb_sess_tcon_unlocked().
>
> Cc: stable@vger.kernel.org
> Fixes: 96c4af418586 ("cifs: Fix locking usage for tcon fields")
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/smb2transport.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index e8eeff9e50d6..1143ee52470a 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -169,7 +169,9 @@ smb2_find_smb_sess_tcon_unlocked(struct cifs_ses *ses=
, __u32  tid)
>         list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
>                 if (tcon->tid !=3D tid)
>                         continue;
> +               spin_lock(&tcon->tc_lock);
>                 ++tcon->tc_count;
> +               spin_unlock(&tcon->tc_lock);
>                 trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
>                                     netfs_trace_tcon_ref_get_find_sess_tc=
on);
>                 return tcon;
> --
> 2.54.0
>
>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

--=20
Regards,
Shyam
