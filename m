Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85583093DD
	for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2026 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785695083; cv=pass; b=WOsKTFbwggVh0tPSeHBZMUDthZGF5cpwHkmVbEOogdAR/Ay3rv45Gyzxjs94Ps4Tmpj7XA6gf7fvwUr7ZxckGOZbRHvuAZA1nIfCZBRBNx5S/1KHj7wE5c/tDmDZ9IVMBVobFB1H4goBRuCOkT8CpUPsdu2+j1md0DNq42R813A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785695083; c=relaxed/simple;
	bh=S3hGAi3pbyOkEQqEsCsHkGp4kTIe/5H1Igrb53l70QY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cs0tNab06Aq5vt0tc8CELom13N9rfW6/G9lwYfbbXkHeJFSBLCxPGAVM69WkLUFJZVVjayWWEekca7jbLcxhFDhk2Ubt+ZVwwR7Jom++4iNLU0JJrpGSaKtSpRvFi0gK638juBIDbwH//wVqEX0czDPBAFQn7m1Y6RR85GxXfP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qYzgsTgK; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qYzgsTgK"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c1372f84dso14586821cf.2
        for <linux-cifs@vger.kernel.org>; Sun, 02 Aug 2026 11:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785695080; cv=none;
        d=google.com; s=arc-20260327;
        b=k0DCYsBJTVrNorg/n2DpBNsdmUXdoqLFDaMs/yDkJ+UIBi6aaV2YgtZs3c6L52Eeow
         26dvkoLmhlwteQF5t+zWkTSsQkVKpfYUSutMN1fXCsEwQUfztTHym/WVTYFQNLkwnGeL
         Nl/ZT5scZCIZni4hpL12ItbSw+pbov8qrbZAj4OFY4npBbyYK3REme6bSk2GjO4/35Qb
         abEeLlKI1vg/OMu3r78vfh6e3cRW3qGEtueM3/5X4G8iSFbILZWnD4eb8R9Gt554RRz8
         EYX3X1XYtVE03Lmc5PwCeRiasS0uDqaWZH0DP7dl2PMzIrCuqaK5ITaMV/JOv/1OvoBV
         lt4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qzuqHjhcdUgLDDxnbPa7JUIcXrZvYqrd5LXpYqrxwNg=;
        fh=szN9/maq/p/Sc7PaJx3odEacn9erdayd+YQaalp4InA=;
        b=chiY4Z7G8l90vmxIWL/9m+OmWyHjL0ZSGlJmFdEqy2T4PxGe8lqfYSHTjWn26/wGwo
         C/yH1O8WlUYRBN/vzmvudSqVqOZ76gvGRetRHxmGybSeoetSWkJdTIKI22YdPXDSGMJg
         oZcivwKgDIRObRPyueywyLtNBESofBhpe1JXOYtjZ7FfPyJBHQTSs/ER2E75P91nF1Td
         nmHMqDZhdNotRHncbu1iGXHOCNuSdYnsWT0mp7wMs/TVPU//aqOHeU1xlolYP5O8ICxm
         iGpFusYkmw79aDxVKERieMd9oVq1cnEsGYbn8NaQdRXAtIkz8s2iuyqyo0EgfEasVW/Z
         DC3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785695080; x=1786299880; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qzuqHjhcdUgLDDxnbPa7JUIcXrZvYqrd5LXpYqrxwNg=;
        b=qYzgsTgKJkJW423SKcGPgmqpmkEIqcXk2JphWUL53rce4bX9GDNIEJQcU8pu2CWzxk
         ggQ0PfG6tn5NSYulP41lXPMbVbyL0tjp2lBb7ukXY91TBmz4gBS8ni5VmaerLSNj1j+h
         WNi6a1OJdYT4znTv+Ki5V9C/K2V5L5OSbDcf76qS6BlviyHsxlJteW/F5HVe24ehy3Ke
         tyHDC6n2e4Kt++C9KiFVKB5AMkKXdzdLOWXIwYBV8LSnF+sksoFwu0eTywyhNM5N5TLl
         7imN+KeiGS7V7owe98UYwyp+krPNX+baCEaoeJcAnV+P9/ZIcaaHAGfOd2hAvfmRKcW1
         3nyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785695080; x=1786299880;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qzuqHjhcdUgLDDxnbPa7JUIcXrZvYqrd5LXpYqrxwNg=;
        b=Jq4LCjUQioGOP7DMiYk6mmVAicKh6PQLqMwb93aOMDdAWTkIFV9L24ANSY/kzE+JVT
         QAq77KBi2w757W1gEYdwsAVeOLpByENRswz61YHYPwBByzQukyLut8iU79gkfu9uoFYa
         kyTNf9o3UMQBYkUl55o3s8vmF2CaggRc0apO05fjFYgAwildnR2c8tudegz2q7m7mf3f
         6vV4wkQWvoEXzPIi2mTGbDmtt/pmfk8EZ2KFt7iMXuygZJHfwz6Y5p8jp7U1oEKvCeF5
         PttK64jnfpgaZN7UlHrGS+J5cM3ErrWE5n492j6ME+VkqxYruOY7JIl3WHOkRmbgkFYQ
         Yuew==
X-Forwarded-Encrypted: i=1; AHgh+RohFFxe8pfq93ukm080PZ2f9m3avmSHAexmtPe4JqZ1m+Pq4wuXsTvZtzHwcjmXOQU65GEicXtQA96V@vger.kernel.org
X-Gm-Message-State: AOJu0YygH/B0MpQGLf/MQ5McVvjplFVqLuaqD1IBqyYZeeZ/OOA02GPo
	9+mBRUugcow4Qps2ZiH3Uw9DVP1/T3aWxaJH54YZTJXXNPAR998oI6CO9ZbkLfTQlhd39LwznIn
	zAYw/YtJmBycTWADpypWM6LUoxGdQTgM=
X-Gm-Gg: AR+sD12ueSjTYXXueOsay+MOft0544MxWgnUgGGv5XYI7AMxV1/48xRiMOuVubAOfOm
	am7UV5uu0DoULwKsW5QesRSH/rzoSTOhxb+GDkH+RFPKa8BBueKEOBnfgvNahN6hsVDbTwoknns
	ShoT06HBP6n9C/Q0vUc8mc1asqDJJHvXIk6S1l5esSQUxJnRbEICtikkH8Pm7Y9BkRizanoUW31
	CCPeIR0eXIEHGn3mhy+qgzuIS/CbXx73lQNzt+UYVS8zTmhWn8w2dNqnSdWt6KRpFRzR6fNAyiI
	AGuzKI+BkTRRy2QAvsmeDxI3AUNZh/gfcWsy9R5xjhER1vq4R7bZLa96oGhkfipgsBSuhX8cmeC
	JP3X/r4n7GlH5paI+GBec1h1s8xVef2AlavAcCVGRzO8m27O1WRbi6SE8HuCyi7tQ3WK7gUHZhR
	MoL8AjYnr5JywJspLTSFtc4KgiNVO51KT9mzwKD4BZYV8RwlM0Wr2vsDgf3bA=
X-Received: by 2002:a05:622a:2cf:b0:51c:805:1be3 with SMTP id
 d75a77b69052e-52b56795c2amr146778511cf.31.1785695080560; Sun, 02 Aug 2026
 11:24:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801075515.140004-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260801075515.140004-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 2 Aug 2026 13:24:28 -0500
X-Gm-Features: AUfX_my2zfRfjhv3_LB7PcaNcZR_GyI_dKc1HJSlwarK5OVCBXKGN1HEP9Tv6Jo
Message-ID: <CAH2r5mt+trRma4YjjBf8uDs=T_D_r-vSfdpKWak0cn=PMCqP3g@mail.gmail.com>
Subject: Re: [PATCH] smb/client: show compress mount option
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Sat, Aug 1, 2026 at 2:56=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Example:
>
>   1. mount -t cifs -o compress //localhost/test /mnt
>   2. mount | grep cifs
>      //localhost/test on /mnt type cifs (..., compress, ...)
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/cifsfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 1788d93a2522..a1dacc7d8f74 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -692,6 +692,8 @@ cifs_show_options(struct seq_file *s, struct dentry *=
root)
>                 seq_puts(s, ",seal");
>         else if (tcon->ses->server->ignore_signature)
>                 seq_puts(s, ",signloosely");
> +       if (cifs_sb->ctx->compress)
> +               seq_puts(s, ",compress");
>         if (tcon->nocase)
>                 seq_puts(s, ",nocase");
>         if (tcon->nodelete)
> --
> 2.54.0
>


--=20
Thanks,

Steve
