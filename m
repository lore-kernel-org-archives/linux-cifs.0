Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B6038DD8
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761622758; cv=none; b=UZvBzHaDm7BQcw5Z3/bf5WvQg3rQfGEsYRxhLoxWTdLj1Y5ei16AdcsX2ADBQTfVI1VQOCOar96m+svYOuWciicQakiDez1FlGaQ4hVNkmTQOVSDdr5SDk3S3LY7kk2ejlFPR+slN448fVQ/ypabtD22Iu+RXSngVgnZrAeNB9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761622758; c=relaxed/simple;
	bh=kj0QwRWTBvqzuYL6wrgyPhdXKfU1rPAv11+ipLNL5hI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cXGTj3D/rDAlL30Ntw0oLs4UfnQa+jkt760EJm/0QQImq0CQZW7XpPaiAVKfIggu10rX1kpJDVxf2zQfftjjXbOcXKrUTyh4817YsRTKcAHMABIjct0vPGqYEm9PJ8BpDQvgKFC7h0IN/5E7tHvEHE91q7t4pXSgtTABkju9AYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpNmMuaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpNmMuaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F2AC116B1
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761622757;
	bh=kj0QwRWTBvqzuYL6wrgyPhdXKfU1rPAv11+ipLNL5hI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kpNmMuaHM4PCZknaCykw06DVI1yiyOlFMXJ40J+QQ/zaR22DvAWwd+dA07TwwgaiZ
	 GnP9fGpVTssskd+UJD3lh71oCbRzLB97oxbIsNVYR64CNHlSpCKq423UA5ZT0Ib29+
	 xOsAwa4j4SISZloWJqOGq/4WjiuWewraM1yzaF8QCXyc8ODLMHIaCvAZ13HBZqWDur
	 0Yx4EcAQsLeS9Kh6QZTTZcM681XPwaT76RiMyna4zLXKrJIJXcgqwLbRbt82ZOmYpD
	 fEpHO+/yEaPlWacnoKXT8s3kmNAoGYO76Ez/yl+BC83um35vOLuBp6yCmvXQdgfkuP
	 utpZGqI0oCdXg==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c09ff13aeso9408055a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 20:39:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWOmwYznbVSJyheeLjAl5pebbhstsjWbwyyntVzJXzhyO0cxjpcElywATQkLB/Kdavh1HuRggPpMUO5@vger.kernel.org
X-Gm-Message-State: AOJu0YyFReLKhnT9aaio+3bo/AHHc5LL+SqKbhmq4tVTUwDl3UshVST+
	nzLK5cOpjGRDikFLXFfWKiuqXbcOeIsfzcIeUHr/RaaNMeashxGGi1hr7HXhRlTHyme0lOZWrke
	S6MR5qw942CN9C7ezhfKGYnvvQAMEEtE=
X-Google-Smtp-Source: AGHT+IFd34KpBwNWdksrlyvVGU59v2INwoAdDVmvSfxuzuAXW8hQkuojE85M5v6JgexJUSF546LzBDRNO47Obfwh7IE=
X-Received: by 2002:a05:6402:2082:20b0:63e:14c2:2805 with SMTP id
 4fb4d7f45d1cf-63ed84d142fmr1456699a12.17.1761622756252; Mon, 27 Oct 2025
 20:39:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev> <20251027071316.3468472-14-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-14-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 28 Oct 2025 12:39:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Jh2ucT5E8p5=jbU5NSrsejGUn2-DJb8-mzrERQcSGBQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmJJvkqfuRjYFlxDeiCPexjELdqxUj6kQnHeljVAIP8u0rc9B8o9v9yebw
Message-ID: <CAKYAXd-Jh2ucT5E8p5=jbU5NSrsejGUn2-DJb8-mzrERQcSGBQ@mail.gmail.com>
Subject: Re: [PATCH v4 13/24] smb: move FILE_BOTH_DIRECTORY_INFO to common/smb1pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 4:15=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Rename "struct file_both_directory_info" to "FILE_BOTH_DIRECTORY_INFO",
> then move duplicate definitions to common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
file information classes are defined in ms-fscc specification.
So we can move them to fscc.h. Please check other your patches also.
