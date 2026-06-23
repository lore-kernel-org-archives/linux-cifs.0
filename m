Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EEB3B38BC
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782202508; cv=none; b=ZhUFC54NpgZwzdJAs2TzjaV+Aw3/dAcbN79JygltpJxgMCHu5IVqciOrCXSQ9LjaNG6Iswdf4MRVBcJdAcpK8Tt6/ZLPnDevPrr8idAvXvj8RVDEWOb0KjRUs5kHINUUZGTAnmzOiCj8qGqno3hyxo7SVTsmSIK+jS6L1m69/p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782202508; c=relaxed/simple;
	bh=/uMXazrxvO4fjDwqq6tXbo7DWWR//xi49PggxNrm39A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dbPenBwubZx8BAlOhCkH7OoJX4/M8dVKg4HbC9pK/9ZgT9SNL2xjlGm6PnLhODYkaW1g5V2/BqMVbYGY/DQbDorIgsIp2PY6q9XDjhHs7u7iEmm4PkoGvGr1GaFtTaoXv9LL6qNjrEZKJf+xU8fLN3JkCFDgY5yst0fMDc5euXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7O++RuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7O++RuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAF61F00ACF
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 08:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782202506;
	bh=I2Z5A1j32wL5TAdfN6QjolhGmxyDTylas0NAJ0zlY/Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C7O++RuEb84h8FNAb79dbkMcAc2Np8poRC3TkYeOwyRwMe9enNj1WSqX0NyuMOleA
	 vbXLwuYy0WzOP0q+mLQXTlkFO8PXl9M+y4DrZjGwSDUt/Or2ziYCO29F5+aZcMYI+e
	 gE3R5qL+3vwticOSm6OHOkVDWLOkMGJ5Z7EGiHoK082tvWxejBts57A/+9JRGOQdlE
	 +VVpUevTjGkJxIpBU5Ags7Ny6QzeOk3ZsWbOFEEOKZbhuAJh64ozI2HHvRqREzukuy
	 tsZ1Te2I48tXZsS3FCYGeQ1WZqI1106nCR/GWzBAifboUXPLKEsofopfvkDA4Y0nMN
	 Pu1upY9DytjtA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bebb72b845aso861885466b.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 01:15:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9D0rIU9pf+EkSBmXUkF5MQ+nJa0+lZFNwbtZEdxLTJwiYLUXLVi75hfzDPxMJAHHJHZak3iktKSziY@vger.kernel.org
X-Gm-Message-State: AOJu0YxrvnnyKV+m4au4Op+hTno7ZqlUhdwjFNP5ODKLNttukWJE62Xg
	G3gGOFL2Xn95M2Ii2sLfaNqWwg6M/x4TSJpm1ieTqpA+E+9zLmShFbMP1jDIrHyISAUE77fAhp/
	R6Yiy+3eWkkI2UAGG2iDMXCmCQON3V6Y=
X-Received: by 2002:a17:907:25c4:b0:c08:c6ca:411d with SMTP id
 a640c23a62f3a-c097c7b5e2dmr814182266b.25.1782202505448; Tue, 23 Jun 2026
 01:15:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_160379D932900C07E87A916577DA03F73609@qq.com>
 <CAKYAXd9nesneEmhr8pm_=4CtvyC8q7Ac+H7uhtk5R8QPf_VLbg@mail.gmail.com>
 <4747ff73-f57c-4c8f-9038-ee00c7561817@chenxiaosong.com> <CAKYAXd_3KmNbaUe5U-mp=vEOJQ0ovmnyxQxezY4fy_egcHJf+A@mail.gmail.com>
 <7e8352ce-884e-4f05-9e19-a21055bbfada@chenxiaosong.com>
In-Reply-To: <7e8352ce-884e-4f05-9e19-a21055bbfada@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 23 Jun 2026 17:14:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_DHhs1B5A4cJjE-XfeZ+zTUtUMLKH2go_YoSKcGRjcrA@mail.gmail.com>
X-Gm-Features: AVVi8CffDnkQIgMGssDSw1FfWitzGyMin1qKDPy-mQon6p0AioGY9qIU4mU3xSE
Message-ID: <CAKYAXd_DHhs1B5A4cJjE-XfeZ+zTUtUMLKH2go_YoSKcGRjcrA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Haofeng Li <920484857@qq.com>, smfrench@gmail.com, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com, 
	metze@samba.org, linux-cifs@vger.kernel.org, Haofeng Li <13266079573@163.com>, 
	Haofeng Li <lihaofeng@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 5:10=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Got it. Haofeng will send v2, he also has several other fix patches that
> will be sent together with this patch as a patchset.
Sounds good.  I appreciate your and Haofeng's work on this.
