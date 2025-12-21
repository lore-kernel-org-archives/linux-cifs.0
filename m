Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569B1E521A
	for <linux-cifs@vger.kernel.org>; Sun, 21 Dec 2025 22:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766357533; cv=none; b=bvH9ZpQ4FgLB33tpX16S0IWZXQYAN1GMRcbLOm7Etss/vFx5EFwbDRAjCmgWhBfqRGSVbTI2hYRP5NqcVQwQee7kg6pAFqwJnwzkZMsUWieX4aw6VcGRI930TsgAydlv5xaMPDzoi5iZ2R3tMUVMWZqhbxO87NjQMZLnmQrAtms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766357533; c=relaxed/simple;
	bh=aZMvnn7LD/NHu3G1/+mh7LKsL4jY/E1Son/s8JEcUAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VrFbCyyI3rAHeIy+Iqcn3G5r2XrxIU/vgA+UaDTj9zcUGVMZdOylK2Wq7hTKs9U/Z+mDE6yxcpBRsaQg6lCADjNyj7yJyJpzZeYXO+zsP/wtc2+8PFLNAzLqds4Q57zabjyB7EcjAJ0gOUc7C0jKuxluEE7FBpn3Ks4vDVYCKbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dN+A4Wd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dN+A4Wd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B359C2BCB1
	for <linux-cifs@vger.kernel.org>; Sun, 21 Dec 2025 22:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766357533;
	bh=aZMvnn7LD/NHu3G1/+mh7LKsL4jY/E1Son/s8JEcUAc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dN+A4Wd3RYTSTU4j3dnw/VvsAJXebJpdOzgGA/xpn8ZvxJ453JuN6DJS36xYQ2Dh5
	 U/fpg/7jIXINtiYoZj1UT7nUY8JB1yVTJAV0kQ7GUvbn6ebk1xHepZEaG4ZiVoeGL4
	 o3XLy1zJGk9g7eDkKgTpYptqpLzNfDcZA9rwUxUB2X15GJceKv9VwnyjdAwXfQdwFw
	 VWzEtydQnbjpWf7kUSHGlPqGjjT0QFtfILmaCSoT2RVVSxScx6hDPrVzQ0FnU1Y6uq
	 B4M0E51Jg1vLmKsvOt8eQeek774Byv0STmNe9k8SotmDLNPCD6FTfQcm4TnWDJlsTP
	 cg/ybS+3hqgow==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64d02c01865so2115033a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 21 Dec 2025 14:52:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUWCzNAQUEZRph58DO/OjF9T8i8nXg7uu31LnwKOnb0Dsxj3ANh8TXXJScvMzyfQ98V+P8L+lZ3z4S3@vger.kernel.org
X-Gm-Message-State: AOJu0YyizjmlIKdEawpjwyiVLOLrtDpH/ag23XG/4hMjALwuVIQcmhEA
	GJeZytDOhszV+qnSDUCmlyN/OrEK4AK6qYPYv9mKVAJ3UlOCkuOmag2b0V/PcNvtP0f+a6kRjmA
	naY+FcEamVx7jKn+qJ3xDem6w7sHy75A=
X-Google-Smtp-Source: AGHT+IHYQcTHziTNc2Ad6HCP2WFWF2a+fhWZ6N3fhEVgImyw3TuGVPs/jcUn4fsmrW0kmdKssquDJnZPrMMPC94pLZw=
X-Received: by 2002:a17:906:c147:b0:b80:751:ee5f with SMTP id
 a640c23a62f3a-b80371d448amr984746166b.52.1766357531482; Sun, 21 Dec 2025
 14:52:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 22 Dec 2025 07:51:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_F93CF6OYyv6DzrD+JdF9-7GyZqZUAdxkFaV8yx+_REA@mail.gmail.com>
X-Gm-Features: AQt7F2qNspHkcUPHEEh-prk84Xl9KvCAS8NuYay0j362Lwg12lCTGdeqSKlGGAg
Message-ID: <CAKYAXd_F93CF6OYyv6DzrD+JdF9-7GyZqZUAdxkFaV8yx+_REA@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] smb/server: fix minimum PDU size
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org, 
	dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 20, 2025 at 10:26=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> v3: https://lore.kernel.org/linux-cifs/20251219235419.338880-1-chenxiaoso=
ng.chenxiaosong@linux.dev/
> v3->v4:
>   - Patch #01: remove `struct smb_pdu`
>
> ChenXiaoSong (2):
>   smb/server: fix minimum SMB1 PDU size
>   smb/server: fix minimum SMB2 PDU size
>
>  fs/smb/server/connection.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
Applied them to #ksmbd-for-next-next.
Thanks!
>
> --
> 2.43.0
>
