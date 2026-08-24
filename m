Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F8240861D
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573456; cv=none; b=KzXIGETjY0toET2ojGuPTY9mwgdQTJhpxzS9E3hMw2PtpuzpSFeA/PX9VqstMqeSqXmWne9h1KHd0ZKO0QGqyDr06IbVwMzHdtuOVi8PbzgQhQBvapQzyWwEslV6E5HMoDOjaZv2ge8uvbT2l3e7rbsxVSlbybr/UJHUVOfaka4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573456; c=relaxed/simple;
	bh=GSlM6OIdMiLIl0CjWUcx0YNdKYzwfIZjFwJ78LuagDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZcFBWIUljfvPvsKLcSvrGU1PhMn4WBjkv3thib5PDElLWaPUAMmTT7Ukji8oJLBAZRTtSanbAiaZD8WEFpWwYAtqKAdoPeByD0EsVBPK4ZIhvN7/ggSV7yxVOMF3RxKS2+/4uhH358cq4wi6XnOFAv7zG5j6KmbsmZO4ZO2Jzys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TouP4G06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TouP4G06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33C91F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573452;
	bh=EfxyJxW5Up1XHPEaTMaIqUEPaYjhpQusSBgvDHSESeY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TouP4G06LoYZTg7XTZZIqGySmS+zZ2BXWHJjuZXJJGfI+fjSNwnGqX6U/jH4q7Opx
	 IbD/H00M+ECi2T9MWQlx11IE7kduN62o6ToaWq03qfAiwbFMBlcK1irSBwhbk4rNkH
	 LGygEKN/eD5Yn1rOMZsSxTq8LGebTEsdU7EvjgJJmKnvPtCVcZWxkpreqvHBTbFqnK
	 Oc29oagIgSI94It4qK3CRnyEFwc9n/SajdH1mRkXkQQOE3icbz3Lc/KOjlMm/m4OZ/
	 +0ADxrPdZq9gIenR9+QvGOZQ7Ep4vm/Yf/QltMVvtcI79irsqMKE19YwoQ6GO5EC9G
	 gkMNKeewY5Sig==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2055573c8cso508785366b.3
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 05:10:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqsr1juw9fuGyDXrcsOCYNATVtlM7vt/8NO3KdDtUpNXrM+uQz+uucRVLCfV8NsHKaxjv1IpCpKVffV@vger.kernel.org
X-Gm-Message-State: AFuF++lrfxHJTLW/plpayLVlxnPbhujGefaKz1F8kv2HJo0UyVJ3jGNm
	KiecPE+CbpRTRSQ+kr37cUOgNcdKSAJalqUt6WL6+pvHyqmciC9kFvrBap3AtVr4VMrK1rtgls2
	FkGiLK7KWmLhWd+WLfVadhwPmF5wW6x0=
X-Received: by 2002:a17:907:80a:b0:c12:9b93:61fd with SMTP id
 a640c23a62f3a-c24925a28bemr1914367666b.6.1787573451335; Mon, 24 Aug 2026
 05:10:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821135801.3790290-1-haa@amicon.ru> <20260824102248.178152-1-haa@amicon.ru>
 <20260824102248.178152-4-haa@amicon.ru>
In-Reply-To: <20260824102248.178152-4-haa@amicon.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 24 Aug 2026 21:10:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-db=9kDTige44CD5=Mkx_=5p24w+gf9pS1iVs3Z5zd8g@mail.gmail.com>
X-Gm-Features: AcwNN1Ug7Nc57E38Fa4XwkrLlNjbcw3A7zSv4Hrs3119wW0BagmjTO_b_IYnccM
Message-ID: <CAKYAXd-db=9kDTige44CD5=Mkx_=5p24w+gf9pS1iVs3Z5zd8g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
To: Aleksandr Khromov <haa@amicon.ru>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, rrv@amicon.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 7:23=E2=80=AFPM Aleksandr Khromov <haa@amicon.ru> w=
rote:
>
> smb2_get_info_filesystem() reports 56 bytes for FS_POSIX_INFORMATION,
> that is the whole of FILE_SYSTEM_POSIX_INFO, but never assigns
> FileSysIdentifier.  Those eight bytes go to the client as they are found
> in the response buffer.
>
> The buffer is zeroed on allocation, so a standalone request leaks
> nothing.  A compound request can leak: the offset of the next response
> is advanced by the length pinned for the previous one, so a reply that
> was written into the buffer and then dropped in favour of the short
> error response of smb2_set_err_rsp() stays there, and the next reply is
> laid over it with only the header cleared.
>
> Report the file system id statfs() returned, which is what the field is
> for; ksmbd already hands the same value out in FS_OBJECT_ID_INFORMATION
> when the volume UUID is not available.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
> ---
>  fs/smb/server/smb2pdu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 5e83ad4f085e..7f200ba103ba 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -6167,6 +6167,8 @@ static int smb2_get_info_filesystem(struct ksmbd_wo=
rk *work,
>                         info->UserBlocksAvail =3D cpu_to_le64(stfs.f_bava=
il);
>                         info->TotalFileNodes =3D cpu_to_le64(stfs.f_files=
);
>                         info->FreeFileNodes =3D cpu_to_le64(stfs.f_ffree)=
;
> +                       memcpy(&info->FileSysIdentifier, &stfs.f_fsid,
> +                              sizeof(stfs.f_fsid));
Since FileSysIdentifier is __le64, endianness conversion is needed.
Thanks.
