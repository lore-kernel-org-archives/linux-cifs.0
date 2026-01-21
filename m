Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3F1330679
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 18:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021999; cv=pass; b=Fs0cVSvPkLpMTaT50Mgg7ZEKOJaLJOcuKRH1Ws3rHUQZ/JLUVjx4Dvf7RT92oD47tC2G77Kj3FcfiuPYbFx/U25MQRlNa/GiKcfC+YwLGrfz/Ksl953ZOHbRjr5pItGBmv83sXAD+5DGt4LR6PjC2dWXkSPFVe1LQc0DrVvow6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021999; c=relaxed/simple;
	bh=0g11WUsJt9cOA2Y9tdkQTYooIxWC13epF+iUWH3lAFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rf3RvPbXCP2cqElyEPZzBIMeOTMe1ob9j5uwvYvPQL0O6rkEHp2l1rIfQzeVxiboNK+Ygg9tJCuNXE8OFHR340zngzoZYSnMyitUEd8i1SKBpXCPu31XjoSjY29kCZS2fuJ7Yq0BVtc8rIQNkG6xOVgPzb0o+sDYbxMz5XjjPoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5QOXskU; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5QOXskU"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-888bd3bd639so1573446d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 10:59:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769021996; cv=none;
        d=google.com; s=arc-20240605;
        b=UN1Wq3ujzE6EtqZTb8NyGnuIioYaoNmfoy1czL3lv7/o23RfYyIzDZNgmhJJNAesro
         Ty/diThgICv624xaqyyT7hFqqrSvrGlrN9E476QbFIJsHAjnF646lfXBfjD71gV1pbOS
         Fo0SrqeS0urOezLYuitf1CMLh+C7Y5DTkMV4E5fFNVtamH6vSfPEZuyDG0smpwpWFEaI
         mjKZ2a4DeHKdqM2wVeudsVhNvd9/CGwB+YJiAdUp8leQFaPuqywMLO9/mwl2anRkgw12
         gTLR7StSXEN25qTav3jgsDNXPTF51yoEMkE77rrRgzswNQc9AYfoKUk64ZahbKM2Pzlt
         kRkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kO7WWK+KC5k2InywWarhMQ20qyxjNQJl0ylzZyDEuwU=;
        fh=VNwkftLXIEhvENIYcK/ONI17znYYwUE1BfUsjFv5sRg=;
        b=i/gEim47cv9WdVL9dXJCLo1cSWHThtSV4w4gYw4OHlM+EzH/FJTbEoT5GxBJiMwOX4
         S7uMCa91hv79czSUoPwNREGf8emNpgoyZaWAH6VK5xnCgeDrT+C8EfFuzmcuIv4/bbJL
         4I/TmbNMiQs06h3jzmcxjCR4hsBNN1GYxciq5sOf+Tj1qmfZydzSjGod0HJ/DB902KgC
         KyAkYsIgniyfEjrmSjMxBONxormrvxvKzFDbEP5nMdazgwS2aVLELzv9W5fcQmVUXt3V
         X0YPfs7p3+ZYhNiA6lWs6Ygg2wAGdn+Fwllgi8AoSVS9/0L3RSc5tFhV2e2mhF2RPNHC
         37Mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769021996; x=1769626796; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kO7WWK+KC5k2InywWarhMQ20qyxjNQJl0ylzZyDEuwU=;
        b=M5QOXskUIXbK7T6VAtmvRaRhrDoHjgCk7UUZL8AnwPj0TE6hiDaKLoBQyD9CiQNGMf
         4BavbqJT/sciI1eFZl/43ppfkB745Wls2y9+5qwRR+eprxPrYh8tkta8N4GztAMgx45A
         oOLyC3vhdPa9NzPeWvNycU/w8aJj5aroua0Dzi1OgNJuF048zN53SMZio3rJxX5r6OMv
         yvZkdtTGpgpi9t6q4YKDlxTUUxLzl9+YXfg73BfuWEfJT5Lek1fpdYY1hPevhOl4fD5h
         y9Zh48fHYpWrvs0hJYs9CtJaoDwUHc/oR5RF7kHmOgB4sb3QhBxa2xqKwfHy8z+nEbRn
         YGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769021996; x=1769626796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kO7WWK+KC5k2InywWarhMQ20qyxjNQJl0ylzZyDEuwU=;
        b=cJtz9CIEhm9lZ++gcI6MtaoomePoVNNjXqa6dAOiHw5cBJgNID8fwcC+Pc5ZHQSI6Q
         CLvc9G5lHsxE6RErPVgkFdyAcpWUE2bdmewDztw7MdJTQVKVC6Fg7xbDfNLCcMA2XlTG
         eoupPxpg+fY6Ig1uOHuxRRG1pHtfk+OUdvylL5ga85FpXbEjNys9IC+aNVI5U/zuiT2T
         mngmbDcrdoVK9+SL10eDisL4lSQN8BAErvSH2m2Yn3wMYnScIAaix/e1XiN1P9zO9Plh
         YWwXJz3Bu/wP8VTQRsz56lZuGeL3ja/nybzn0baob13foZbiFcJ5OTj5PG3Qb4PJ8Nrx
         ouEw==
X-Forwarded-Encrypted: i=1; AJvYcCVBVujRpqMQPvIDDtKUciJ7Vw641wxCtxifm7Dz972GAhEgbuWir4/7t7+JZKJc5nfoEgPzNPuABolj@vger.kernel.org
X-Gm-Message-State: AOJu0YyW8YvbdbdLlaM/LjCB51drb2KJtTPUxqHJo4lSIGf3bEC0+w5J
	HzEMi3xvVaPShlUnWgOIy+tLHqmwePXu2J4NnZtfW1i1PXPIYwSn3xCi8xsjP4HXRf9xddOgu1C
	HL2Qx2sOYNi6OesjJqlUX5AD7ReaQuBQ=
X-Gm-Gg: AZuq6aIA1d2ODHf4ktNL3ULxFzFyK7iATjPEzu9wuMPmjTwQTdxDyceVBARPUG4+/lU
	uzlAqGDGcoA3suFrS25VEfKIqcdGCKeZIOyx1AXldlGng0KOihDt7YIhZeR1kGiNwHPdES9IxrE
	mK05j9HgR3RL0IMmg493xnobK2goYuyAeaaRbObTS6YHjRY8H8ZkmTfr2Uu1hsEC5lhuEQI526u
	WvNF4Q2cHkTukmLm59SKYk9Q0gGtqDhFfr15ED9xB/RryMIH+mjm2IRU4BvrsaNHEGcDTQC/g0M
	3asBhqD6m7JkdLDhP+M+RrxSyDHscCBfcj8+CUXxA3rdKeNjI0iHacSPqZX9Rw1I4AUK9//drlW
	B2PHC6c9lNVTPSMfJNdfeKEbZ9rM8vjasyM+9wj+jsCoz/ujCb1OOpFfEooK8cWwCiTMqCjjdz6
	SH40PcGJV+
X-Received: by 2002:a05:6214:21c6:b0:892:66bb:fdbb with SMTP id
 6a1803df08f44-8947df8cc68mr6555776d6.23.1769021995975; Wed, 21 Jan 2026
 10:59:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 21 Jan 2026 12:59:44 -0600
X-Gm-Features: AZwV_Qij9SMUytYC3z7_bs6WHM7CX5NEYJgvSk-Pa8y1WHEC3HHepVpYsVRAiO0
Message-ID: <CAH2r5msdoWT3wEyie7g0qX-U6yDcyfq2qxQf6L7gsQgVGX2wcg@mail.gmail.com>
Subject: Re: [PATCH 00/17] smb/client: update SMB1 maperror
To: chenxiaosong.chenxiaosong@linux.dev
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, hehuiwen@kylinos.cn, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more review and testi=
ng

On Wed, Jan 21, 2026 at 5:50=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> My dear team member, Huiwen He, added some NT error code macro definition=
s
> and updated some arrays of SMB1 maperror. He will also update the relevan=
t
> code in the userspace Samba repository.
>
> This is a preparation to improve the search speed of the SMB1 maperror.
> Huiwen He and I will soon complete the patches of improving the search
> speed of the SMB1 maperror (I have already sent the first version).
>
> Huiwen He (17):
>   smb/client: map NT_STATUS_INVALID_INFO_CLASS to ERRbadpipe
>   smb/client: add NT_STATUS_OS2_INVALID_LEVEL
>   smb/client: rename ERRinvlevel to ERRunknownlevel
>   smb/client: add NT_STATUS_VARIABLE_NOT_FOUND
>   smb/client: add NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT
>   smb/client: add NT_STATUS_VOLUME_DISMOUNTED
>   smb/client: add NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT
>   smb/client: add NT_STATUS_ENCRYPTION_FAILED
>   smb/client: add NT_STATUS_DECRYPTION_FAILED
>   smb/client: add NT_STATUS_RANGE_NOT_FOUND
>   smb/client: add NT_STATUS_NO_RECOVERY_POLICY
>   smb/client: add NT_STATUS_NO_EFS
>   smb/client: add NT_STATUS_WRONG_EFS
>   smb/client: add NT_STATUS_NO_USER_KEYS
>   smb/client: add NT_STATUS_VOLUME_NOT_UPGRADED
>   smb/client: remove some literal NT error codes from
>     ntstatus_to_dos_map
>   smb/client: remove useless comment in mapping_table_ERRSRV
>
>  fs/smb/client/nterr.c        | 15 ++++++++++++
>  fs/smb/client/nterr.h        | 13 +++++++++++
>  fs/smb/client/smb1maperror.c | 45 ++++++++++++------------------------
>  fs/smb/client/smberr.h       |  2 +-
>  4 files changed, 44 insertions(+), 31 deletions(-)
>
> --
> 2.43.0
>


--=20
Thanks,

Steve
