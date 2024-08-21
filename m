Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3B1422A8;
	Wed, 21 Aug 2024 23:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724284115; cv=none; b=tLJr3FR4jOUR4sXUgVgwEI/o95KSKYrw3OEtJ+P0norPFatNO3hgQ2FC7/UBKb2wGHPD/BT0Rk6tHorFayoMpyZl4iIaj+gmQh2ZcWrB1jPByeJU43aHrd7Db+2/Q/8WB51tXLpGPdV0q0aJXfwxXjgGZmZXNZRX9bnYu1ElFXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724284115; c=relaxed/simple;
	bh=hXSJ4Mmd9gPQrlu3YE7bd5xMU96bAR9vgU4B86SF1FA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c+S1I2PUxQoDrAgTBgNotJMpxRG7PGSFcW1e5PClPOPim8KH5xjLSW5KCZBjR+daonDPG4W2GsHM4rxcxxu/AkK8RAsIU5zoJr4bXaZbjihZt4VJOagcYvex8qXmhL+63C1p9eBQ3MJ6qYlCw3I9gjlGrFheJkJRKd0d5WZeAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIsrpYOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIsrpYOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0C9C32781;
	Wed, 21 Aug 2024 23:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724284115;
	bh=hXSJ4Mmd9gPQrlu3YE7bd5xMU96bAR9vgU4B86SF1FA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GIsrpYOtDeCU1G7jUVZrTXaeZ25v3Vf+4IAV15NPYnUAZJSFK2BdBZbMKt/0wyAjO
	 nhGIyIGqEfMKGKn00zuhtLPwj1627ifCz4ITQDVSKDrKt3UcQtElLoWQwxEIYEjS38
	 vxQiCbQi3xBkmQKCxI3X7z2a7BhV7qX2JeW2prwhpxP7Ykt4jhyqqPp1rZVcsCVFsT
	 bHZ3RejFRglQdQc+ehUlKfozBpgTP3RH4dtLELOth0Vwf2/ysbgqUMijyTS8Zs7+nP
	 3gmNIL23HpueWx8miV7s9n8Rj1uid71Rl+F5VpK+mc8RSpMl8J+sZKbjfan9akDPnw
	 r4uaoUA7/y6Dw==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-270298a3b6eso86610fac.3;
        Wed, 21 Aug 2024 16:48:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUuuM8jOy3EXxfh8ViLaPeZWqzkXDSyeiaLmxQCd3L82A26ozBjyfgrHDeYWEMSNDNFdEXOIil4q+Zf@vger.kernel.org, AJvYcCVuwwnjc+hz4RFnHHhEPIK+s2s24XfancSp1HNg+/KD0f44AaTE4YPhUW8RzH+E/GWxET9JgMSOmog4bIwX@vger.kernel.org
X-Gm-Message-State: AOJu0YynJcNeaEJUxtSzY7QNVfK7OvhZ8ooJ37fHdu0gSJyt2K4/RQne
	wXkIc386ilSodxy1KfeO70Mr9ApfN910QcS+IZgKhpHK9ItXX8KTPanKX0uAcTkf4/RR2mkUwSm
	UumMsWfQ1MmGqgdGTLVX4cLmnECc=
X-Google-Smtp-Source: AGHT+IGkO0u6+FCMiR6QA14j6GO/MRJsNyrOSex6RyFNb/McI8uR3YJ5IM/x4P8mfsK9ypmuwDrW0vBm6nMnmE8AW6I=
X-Received: by 2002:a05:6870:2248:b0:261:877:7459 with SMTP id
 586e51a60fabf-2738be38e6dmr4145472fac.38.1724284114333; Wed, 21 Aug 2024
 16:48:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-7-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-7-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 08:48:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8mX+2gRuPyEuamg-nCTdyLb7G6bYKw0YiUrGb2GGTaaQ@mail.gmail.com>
Message-ID: <CAKYAXd8mX+2gRuPyEuamg-nCTdyLb7G6bYKw0YiUrGb2GGTaaQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] smb: move some duplicate definitions to common/smbacl.h
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 11:35=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> In order to maintain the code more easily, move duplicate acl
> definitions to new common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
If you rename the prefix of cifs_ntsd, cifs_sid, cifs_acl struct, we
can move more ones to /common/smbacl.h.
Looking forward to the next patch.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
