Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AC835838E
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686264; cv=none; b=LOpttl1+7ucrQPMw86YT8OztuD6UYXlAlu/m4tC/8lsvzQQOX6lUsZvcv9Rjc/VbW3ZJOM6p9L+rC90THoaqBURJduWUVveGPQMFbNu93cFJis874COoH4yB7dOdEkClSSUjl5HDmzknBrdal+7SxarLGEChq1jQ/PkAxLW4qnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686264; c=relaxed/simple;
	bh=I/vOajJ08bZ4orSw1f4UBKbRo3hcz8Ae6px6KMWRWgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CxIh/Lcgu4qL6LAbqtw9crkCnMQkuwN6ef8hYbES8oG1zFu52xBv1f3mMTRrLcHTDuZhiklMYE6dqDVFnwBQhqc3Qg2EnKfc42PAoPg0h9gNaPMnz40aVs+4wISBuScRJS1lpdwgVh87/kzuhMnx/Uej8iXSiSolJrFVYAvTfM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hc3elbkg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hc3elbkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D1D1F00A3D
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786686263;
	bh=i/hIV03qUHKywZWV/0PToQ3xVO+F8rvugjE688mb/xE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hc3elbkgi77lbGQUefrLED1vPeYC/mJZYoEB2m0KPGe0HclXR25HiAlh+VxCRavNG
	 vYOqPqN4lryibnmYcIH9DOXOlNo9KPqws1u+gTHKCLowsxvS7wkEDjDGHb1O5RU2Hf
	 j/AtNsXviD806viy6Y1GkIEJrkY80WJTdN60DIQreo1hNq3bbCvoZbLkolER327MmI
	 x1gid6KrMdzSmUI2nmr8Vfnhn2NeTgG2scGSpTrk/eJccdwN977W8WblPgsWTe1KS9
	 5LSSQEAkoZGPQ4hkcBnVfgJ4VYFR4DOB5lfcqbgYx62reV6LiXZNMcrpDefWGPzDsQ
	 ykaQJTgzoGnJg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15e2dab83eso108633366b.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 22:44:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrenieYt3KKgjMp9fw6naxhcWBy+t+ly3p7SZkeQuFT9gtEL9pIu1SKP1DB2Tk4VF+PN5nh2846IBgY@vger.kernel.org
X-Gm-Message-State: AOJu0YxirofWX8ZYQLRwMrDWxlFPh3znce6RFzQfdIkeb06hIsHhHyUs
	u0dNA10eYv3EYVYkf8aV+vbWUiAI6byIZg8JJFZ0//4stsN0ZRmUPctEVrMyBGXheZvd7Opkzyt
	Qn+dAJgNttoxRTuNi4V4PlAp0140khog=
X-Received: by 2002:a17:907:ea8a:b0:c16:242a:472f with SMTP id
 a640c23a62f3a-c212a1ff274mr129123066b.23.1786686262133; Thu, 13 Aug 2026
 22:44:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1786674373.git.tanze@kylinos.cn> <82181632662a23ecc9a3b8b2321982071037a288.1786674373.git.tanze@kylinos.cn>
In-Reply-To: <82181632662a23ecc9a3b8b2321982071037a288.1786674373.git.tanze@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 14 Aug 2026 14:44:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9-mkdArzM573FPUo0cS8ZuuY21OgMMQ5d9kLOknzy26w@mail.gmail.com>
X-Gm-Features: AUfX_mznYLBvV0_lAdiw7rooRtRYeFE9D5vtgWPdX9XmqnT3tUucho9f7YUEY2c
Message-ID: <CAKYAXd9-mkdArzM573FPUo0cS8ZuuY21OgMMQ5d9kLOknzy26w@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb/server: check create_proc_shares() failure
To: Ze Tan <tanze@kylinos.cn>
Cc: sfrench@samba.org, senozhatsky@chromium.org, constant.lee@samsung.com, 
	tom@talpey.comm, chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
> index 14431adce9b8..3c318f529927 100644
> --- a/fs/smb/server/server.c
> +++ b/fs/smb/server/server.c
> @@ -627,7 +627,9 @@ static int __init ksmbd_server_init(void)
>         if (ret)
>                 goto err_proc_cleanup;
>
> -       create_proc_shares();
> +       ret = create_proc_shares();
> +       if (ret)
> +               goto err_proc_cleanup;
create_proc_sessions() and create_proc_shares() only create optional
procfs monitoring entries. SMB request processing does not depend on
these entries, so a failure should only make the corresponding
monitoring file unavailable.  Do you think we should abort ksmbd
initialization when create_proc_sessions() or create_proc_shares()
fail ?
