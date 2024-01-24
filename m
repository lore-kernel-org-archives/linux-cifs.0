Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E937137B
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jan 2024 01:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706060257; cv=none; b=SvvOECxdR9+25MI5JStfDih/8Wt6HD0LnKO8yLubkoqFA/Hqzd63b33jjhKT5UgENAllhKNHz2ywgzCkrBj9ko2gFpWGovKbb8dg88zMVfmtmWl4b5a3xrnDo+mTwgRdFu/b8bQVhUSSBWjLOTVUt2mHS24ONNzzDGAAU5iYavk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706060257; c=relaxed/simple;
	bh=ZsHcTSPpDx9ihzWqxW61MI/k2SeZvxYTmmQ3kvYBUQY=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fPrjw6PbR8ZnJTjcnM/RpzQow5joQYrbW88WsfpUNTlEtW9BabpNeEas0b0Ns4eaMI6+oR3GQQpkqx1XjWX++NqQpjLSzvSK75o6wpu1kJ+kj4J8AXehUcVyvIRT3LcicHzU3WUxETELJYEyv1jO4U/OZ4bzvSGjsLw0BpTUOK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfMVOGge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfMVOGge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAC2C433B2
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jan 2024 01:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706060256;
	bh=ZsHcTSPpDx9ihzWqxW61MI/k2SeZvxYTmmQ3kvYBUQY=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=tfMVOGgeTsUzZwTKMZHtGsHSxqIV6qj7wTLIWyS8p9YeE0etq66WrORNcyMSZyKq4
	 dr1qSn+yuN/8gQqyKdiqN56xNqQX+dD77HEwL8tWOvTvkf+fsNmk2XlCZ6kjkWdA2G
	 ieWNzn+E9qMUaPFVE9wPE2jFuy8tG/hbTYSpK4iiIIu3zjt9Y65bVoGGqjT/m7J2Xq
	 WUK1qgcvNNQKwJhkfiYLRmoUKZi8Tz3WT0QLGArhaHtbCMC+3PJp8zPcGpEvDi89vg
	 +4bsqFl+QwrbmWiiPsOIGWGfE3se5eRl1DV8K93T0UMdNTqYfCvRIaKmH5RUdEievO
	 gpXlhyG39Ka/Q==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-599c38cd9f5so60403eaf.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 17:37:36 -0800 (PST)
X-Gm-Message-State: AOJu0YxhFN5h2r5z5v0vwZB1cAKk2bI2mKUffLtBzarmG1yOAoqAez0q
	QT8LETCMOivFzxhswCkwrmskNlOuIhdniUTGwvnvdr/Q3gcp6OWT74H19gWqZknCowk873ArcfR
	zZrNzKF8zfm6Mfw9lBkAMj7gRSFc=
X-Google-Smtp-Source: AGHT+IEp4EGnsccuGrNCJA3zcxyAvySVCfuzB4U+P5dSlNGcb/He9t4q4TOvuC1SYdvEVplXEYMLMcpxrAo63e5Dnd4=
X-Received: by 2002:a4a:e055:0:b0:599:2a77:5fd6 with SMTP id
 v21-20020a4ae055000000b005992a775fd6mr769518oos.3.1706060256081; Tue, 23 Jan
 2024 17:37:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:5984:0:b0:514:c0b3:431 with HTTP; Tue, 23 Jan 2024
 17:37:35 -0800 (PST)
In-Reply-To: <ZbAmi0VQRY2zdLN6@westworld>
References: <ZbAmi0VQRY2zdLN6@westworld>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 24 Jan 2024 10:37:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_8W=Dp_bEFJ1nsqvHE9fDeDfpG0kVTjEHnUUuu7sCsag@mail.gmail.com>
Message-ID: <CAKYAXd_8W=Dp_bEFJ1nsqvHE9fDeDfpG0kVTjEHnUUuu7sCsag@mail.gmail.com>
Subject: Re: [PATCH] fs/smb/server: fix off-by-one in ksmbd_nl_policy
To: Kyle Zeng <zengyhkyle@gmail.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, Lin Ma <linma@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"

2024-01-24 5:50 GMT+09:00, Kyle Zeng <zengyhkyle@gmail.com>:
> The size of the policy array should be one larger than genl_family.maxattr,
> or it
> will lead to an off-by-one read during nlattr parsing because
> gennl_family.maxattr should be the *largest expected* value
>
> Signed-off-by: Kyle Zeng <zengyhkyle@gmail.com>
> ---
>  fs/smb/server/transport_ipc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
> index b49d47bdafc..185db4d7f2b 100644
> --- a/fs/smb/server/transport_ipc.c
> +++ b/fs/smb/server/transport_ipc.c
> @@ -74,7 +74,7 @@ static int handle_unsupported_event(struct sk_buff *skb,
> struct genl_info *info)
>  static int handle_generic_event(struct sk_buff *skb, struct genl_info
> *info);
>  static int ksmbd_ipc_heartbeat_request(void);
>
> -static const struct nla_policy ksmbd_nl_policy[KSMBD_EVENT_MAX] = {
> +static const struct nla_policy ksmbd_nl_policy[KSMBD_EVENT_MAX + 1] = {'
Have you checked the following patch ? And can this patch replace the
patch below?

https://lore.kernel.org/lkml/20240121073506.84528-1-linma@zju.edu.cn/t/

Thanks.
>  	[KSMBD_EVENT_UNSPEC] = {
>  		.len = 0,
>  	},
> --
> 2.34.1
>
>
