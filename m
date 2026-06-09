Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AF63C4B82
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 05:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780983514; cv=none; b=EaoeB5Uxl+WXK8GmgA/gkdbzFTQYqBkyHh7N1W54qIcJ7/lW9xXPkQn5q/sxtnWDkXuPNASF4jy6aLbHRAUACgwCxk3raQxFA0DAl2k26xqeL7SuTVrYJJXuIqo37+9L1/YtVSYNq1iQX3I7Hz6ziQAOtgNCvoM4m2KDL53wYYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780983514; c=relaxed/simple;
	bh=7GbifgZL/MhGcLGyWImmqY+waObzIZXfTNBGdel+9a4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ocCWX7CyC8V+/P1alWOCHalXi5FXNRfOppLklSXJECA5C/zULK/9FBCx6WxE5oe2xIjPGb2Gmx1r1kVUf/ZxOA8EdM7tNgGeA8hyy977ox2VicquRgcGSWw6Esq/UzPiuxgmLuhIHH0tGDr4skqAxqtWjYVrmImyhbhNZyZrd/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDzIksyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDzIksyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5F81F008A1
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 05:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780983512;
	bh=e7IbNwzSWf05Gx1e35a4hcETt1kk6A3PCGGtU+OmZvQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CDzIksyW/uksHMq9IbesiNXaIhFyOnDHJwHPGOtSH3yTVg+lMdY+PMWV4XhP+5mL9
	 1WEoMGhI6BDbPB5223gEmNs8vbKr1MgRUip9ur2s72kAIRM90XAmdABKu7zhaPXGuE
	 KbcXE4R251PA+KK6IiKgZS/kXhZ+BdYASiEjlaFUNI/xxtzNFJp2AFm7Rj+RfcOrtZ
	 WxTXnVihdDNomki/v/3Sev28rUvSn883FPdeqJBvjny1PQ31sFcsqm+RnHjpud4t/7
	 15STw4Oyec4Dv9fsgL5f9ApSdbde/G1hyJF+WWKMFLffjy4sL6Ovzlj72+FwAvon68
	 bDzcpeOLEHQLA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec405a6ea5so733257466b.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jun 2026 22:38:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/pQWPdRNlMAyclfYi3lnh6b+FpvgbwnUeX9jvjUI9Iq7f6Yz21arg1TOjgdiydS8pvyX2d/tWTi8Ln@vger.kernel.org
X-Gm-Message-State: AOJu0YytU9jKYQQOL1tS4POOSHwON3EBT/cp16kvXrWjQ0P75XWtEPi7
	0N1U2oYyQxrdmwyYMQhuAx4K61vWihBndqFd8FBoqJGYOm1QDb9UcNtqrJ7LAmNIlJA/mD+DuDX
	adju4xJDKC/6x7rme5iM6tlvFSZ36kdE=
X-Received: by 2002:a17:906:d552:b0:bec:fa92:d377 with SMTP id
 a640c23a62f3a-bf370673d8fmr925555366b.16.1780983511179; Mon, 08 Jun 2026
 22:38:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
 <20260608140128.387844-8-chenxiaosong@chenxiaosong.com> <CAKYAXd9JGDYJvtO3fZcjLh_qY3bs198BYW4ijYaHsgZDFF9eCA@mail.gmail.com>
 <ad83865a-6890-4a6e-8805-48bd356cabf6@chenxiaosong.com>
In-Reply-To: <ad83865a-6890-4a6e-8805-48bd356cabf6@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 9 Jun 2026 14:38:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-YQc5D57POf63Xqr-cDhkW06XfRMtOYUCYxE58Ywq0Ug@mail.gmail.com>
X-Gm-Features: AVVi8Cet7PMKOPtQZpcI2DlosAInd__uIRG5YAlCI5XuVEw430olwg4BSPiqXiY
Message-ID: <CAKYAXd-YQc5D57POf63Xqr-cDhkW06XfRMtOYUCYxE58Ywq0Ug@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] smb/server: fix incorrect file size in get_file_compression_info()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 10:26=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> It seems that the actual compressed size is filesystem-specific. I
> haven't found any generic kernel interface that can get the actual
> compressed size. Namjae, do you have any better ideas or suggestions?
>
> However, `stat.blocks << 9` is definitely not the actual compressed size.
I don't have any good ideas either. At least,
Shouldn't we set the smaller of the two values as the compressed size?
min(stat.size, stat.blocks << 9).

>
> On 6/9/26 08:31, Namjae Jeon wrote:
> >> -       file_info->CompressedFileSize =3D cpu_to_le64(stat.blocks << 9=
);
> >> +       file_info->CompressedFileSize =3D cpu_to_le64(stat.size);
> > We should return the number of bytes allocated to the actual disk
> > after compression. Is stat.size the actual compressed size?
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: chenxiaosong.com
> English Homepage: chenxiaosong.com/en
>
