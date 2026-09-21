Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5404C1B983F
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 05:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789969529; cv=none; b=u6azE8Y6nSrJClkl8CUFIZEHdv3+eL4YxAkWHsgd5qKNJ5RJ27l76rN5BKldToVGbZoqLV7Gsoxd/gpymyhQ+NUIAD/bTSzQWgZxQl3yK27iJlmzwwTJf7mCTAhLjK4jygW3gduuf5hs1jBYB22sjGubCtBXtZhhF8ikAFV+dmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789969529; c=relaxed/simple;
	bh=XTCHOr4Hk/4Kl6K81nsVO8yiL167Svx/Z1C8X6lJAYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qt/ij6P/GDOg1MDPAHw8VukNDP9u4S44T4N87IU6G7KO3siDHiLrHm4X85XzkX5KNxnMYZ8o+1WKxp5aKEfWsEoXRlECxe/Q/rFey9xvuJ1GeTi+qX9DwaR6O+RZcdqrwH5zeSk5qB77Y5PV52hJHDjB5hevhMEyPixaNaryzvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDAdOQPo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDAdOQPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128471F00898
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 05:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789969528;
	bh=XTCHOr4Hk/4Kl6K81nsVO8yiL167Svx/Z1C8X6lJAYE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UDAdOQPo0yyfv5JyKMcrVWdS2nBx8ROnlG/VypPNRiZka6774JcSCMCpHInGtUAbJ
	 mbAyGNv+jlDIvffUomw/RihKBmqlxw9k1+bCLDjY+EXSLsmn57Zwp7bxlY3UTuFiAS
	 qs7m5Lfvh2CG3xHbiQXfGrsbbPLQBLhEJWdh6dwzXpt81r8P76ZjQ9TkblGN+x5vCx
	 pXX0CQX/MTzefGHSq1bkQjzoFWt+E73sqJ/xsY/rPY2N0fVALYm3+aPylLKG9/0ow7
	 N9Hnok82EhoFRz//4VlAUoG38oQUtZJRREwZnE8XwUM91TCXl9x+tPyPdf59ehdQLz
	 4/o73En9u9fYQ==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa663c1so292311466b.0
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 22:45:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy7hQdjeuihFrok7HowEcHFk2oT5QsV4hI3pn/XY8cqS8shoGCpONVnRaV4DH3p6D+oSmPUE5Aznomh@vger.kernel.org
X-Gm-Message-State: AFuF++k2VjjdIzKJN8w4TQijkY5kR+vrW4PxLTq/odSplbKAhJyTt6mG
	1XEtvC2pHLZfa43EMAwmNLw5lszrdAJp2jAg+/sz77pQ8c1/Gy87atXQL1ZJfeRLXoKrPQlqCWQ
	oBDSfzJMk3KG6nJhNsdwiCgqU8btrckk=
X-Received: by 2002:a17:907:971e:b0:c25:fdbc:52df with SMTP id
 a640c23a62f3a-c2a15699d4cmr694532266b.10.1789969526700; Sun, 20 Sep 2026
 22:45:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921014130.147229-1-zhang.guodong@linux.dev> <20260921014130.147229-4-zhang.guodong@linux.dev>
In-Reply-To: <20260921014130.147229-4-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 21 Sep 2026 14:45:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_FX0Lzji9xcZ=SF6u5jNCa=XHCahTTvMzv27Q2w3xEkA@mail.gmail.com>
X-Gm-Features: AcwNN1WYW0b-cg_aRAhytglsxvsUyKbXPyuQNAZ-UVpIEK-5drs1OWiODqq723M
Message-ID: <CAKYAXd_FX0Lzji9xcZ=SF6u5jNCa=XHCahTTvMzv27Q2w3xEkA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] smb/common: update POSIX extension specification references
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:41=E2=80=AFAM ZhangGuoDong <zhang.guodong@linux.=
dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> The POSIX extension specifications have now been published:
> https://smb3posix.org/
>
> Suggested-by: Paulo Alcantara <pc@manguebit.org>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!
