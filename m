Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BFF223DF6
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 01:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766108587; cv=none; b=am9iVW3KXh+tfCrMbmSLhcXZLyVegLgcvsu795LbeE16VBO5aP+V6xGJyQgEsvDCvVU+p6a7cjTdfv3dB5fmswU/LeC6MLJZDhD0/aXYP8Kso2dORhP1Av3lRMqB751Q3PhVhQf28k32XvDTUuQDFq4xWJKWBmgGyqXpBYDVpT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766108587; c=relaxed/simple;
	bh=zxX4oQKK4Pd8/4usoyEx1DNBuZ1rK/92Bkkk4GRFGzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NtqvTVVs0gzGrl1mFSYOX2lROs9smdZe8dOjDtfvFvSPNuGgghQtdKYltHqvwP5Q7O+HGbxhio85qd0X2MpcxEZrjrEi6W7Cac4rbd8l5idEDP6ywJixtycoc30jC9DD9rYTfJhNERqjUqV+6OtAyO2EfSH3N0IrlYgdDeGL1GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ne6yLoaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ne6yLoaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87943C116D0
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 01:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766108586;
	bh=zxX4oQKK4Pd8/4usoyEx1DNBuZ1rK/92Bkkk4GRFGzo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ne6yLoaNNYL9ivrCC5zH/jAxbC8yAjjGdU3vx9gZOxVaZvPtXmVw74P5s+C4BcQia
	 qusTyfMRDOQpftYqgMRNgt71UYC4wwHBaVTQsWdz/neC7yq7P0cep5mbInUeDU/8A0
	 C72jTQQXgeokkdGP7obqzt/2UUaPwZeHQVxZEKXLzBQaW3xtRHF7orge3x+2XjRs/G
	 /XQfejVgw8RQVn39xMYFch/1XyTzBK2N5U9/dhAnMBlFuwWHCayFXRw3UYXJwNKUTA
	 G1X5cbUf4DUX7Uh1bqI2g3mZHPaITBEy5Wt8E2TLg6ID4UL/NVWHeuqmHXSj7sWq5u
	 H3KD+SrW9+wbg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7ce5d6627dso75430166b.2
        for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 17:43:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVT8cdSnqQfyurPnTtW7SJL6uzlatADSyOvgR68FYUVmL0390jpj3KBrcYIfGNC806PhlNRZ+O91FSV@vger.kernel.org
X-Gm-Message-State: AOJu0YzXb+cYI29Qsh+bQwdfjNBdG22uB22uBqC00TZSUs0ttTfcwfzA
	UDCYw6hs3nT45JGrc66zcaOP2+DXNphuH7ArdrdRYWV71ijCv0gXF/c/CLCuTBm7Z7ERwzGM/7+
	cs3yRqnQ/0iEv87fEB2LDWtsquqEIB/o=
X-Google-Smtp-Source: AGHT+IG15WJKkVwXFv3txuEO0llZkJh+OzKPCjvRXbNPPyfas5InMo0ziNRd2yCJSoEr8GG50VoEmoCruR97sl3tUXU=
X-Received: by 2002:a17:906:6a19:b0:b7a:1be1:86e7 with SMTP id
 a640c23a62f3a-b80372287a8mr128413566b.63.1766108585169; Thu, 18 Dec 2025
 17:43:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
 <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev> <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
 <9f9031de-6749-4de4-ae5b-d574b9fc06bd@linux.dev>
In-Reply-To: <9f9031de-6749-4de4-ae5b-d574b9fc06bd@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 19 Dec 2025 10:42:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-J2-t2315ibQX6GvvQx6Wqd-Y=tOc=if3eFANWBEggXQ@mail.gmail.com>
X-Gm-Features: AQt7F2qTvaN6l8yn8k92Z776vdBogPCsun27HN1rj-wArxEHmk0gc2ia4Gs3Acs
Message-ID: <CAKYAXd-J2-t2315ibQX6GvvQx6Wqd-Y=tOc=if3eFANWBEggXQ@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, sfrench@samba.org, smfrench@gmail.com, 
	linkinjeon@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 10:31=E2=80=AFAM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Hi Namjae,
>
> `SMB1_MIN_SUPPORTED_HEADER_SIZE` and `SMB2_MIN_SUPPORTED_HEADER_SIZE`
> are only used in `ksmbd_conn_handler_loop()` to check the PDU size, and
> seems not to cause slab-out-of-bounds issues.
Okay, I explained it but you didn't listen... So I can not ACK this patch.
>
> Thanks,
> ChenXiaoSong.
>
> On 12/19/25 09:16, Namjae Jeon wrote:
> > On Fri, Dec 19, 2025 at 10:00=E2=80=AFAM ChenXiaoSong
> > <chenxiaosong.chenxiaosong@linux.dev> wrote:
> >>
> >> Hi Namjae,
> >>
> >> We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and
> >> `SMB2_MIN_SUPPORTED_PDU_SIZE`.
> >>
> >> But we "should not" add "+4" to them.
> > Not adding the +4 will trigger a slab-out-of-bounds issue.
> > You should check ksmbd_smb2_check_message() and
> > ksmbd_negotiate_smb_dialect() as well as ksmbd_conn_handler_loop().
> >>
> >> The `ksmbd_conn_handler_loop()` function is as follows:
> >>
> >> ksmbd_conn_handler_loop()
> >> {
> >>     ...
> >>     pdu_size =3D get_rfc1002_len(hdr_buf);
> >>     ...
> >>     if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
> >>     ...
> >>     if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
> >>     ...
> >> }
> >>
> >> Thanks,
> >> ChenXiaoSong.
> >>
