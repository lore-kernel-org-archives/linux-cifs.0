Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FE6175D5F;
	Wed, 21 Aug 2024 23:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724284660; cv=none; b=qYKEa2r4jLpoTd+e6fPKGkK6t+HqkNLmLPepdWGukME/tEcVDPnVvo9Wnqg1gPG0ZH4C6iQzmnUhBwgwxrJwnMbx2cM8qz+F9mEXP4gqrjhb176RVxFpXNexN0reEW+2T57qq57IjYeq/7+sYsLWohFwplyl3/NqFJjTniuM9RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724284660; c=relaxed/simple;
	bh=IJkM1dY+FBljnFbvFcPVGaRth6L5Mq9ocJsfxk6R5O8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AArPZMOCD9wI81h1dFu4v9sZmNpGraFUoD7YM3bHuVO+OXqBYbb9Kr6qPXEz9hb/A5bwY9Gv9mcquhVZ/opwJbZgqBQ7fQTg2XnmBLpZjqwphggdbOP02L2FtcQsJ5QfArutVbiCjLdej/tz/HtVVgk44o4tPuBL6SJL14XsIxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhqEzCNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhqEzCNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A811CC32782;
	Wed, 21 Aug 2024 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724284659;
	bh=IJkM1dY+FBljnFbvFcPVGaRth6L5Mq9ocJsfxk6R5O8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QhqEzCNbX1Lbf9FuneTejzoMknNS/7lD7cOLLlU/pq6QcSZ3W2YSBYg1vljAVM2Cz
	 616Nn0h6OBzQ3oL5DKtxKRItD4KDjQEBIqrNfIdKsQ1NUmBcew0PuFswlHZQK8tI5G
	 J3z4X3zy6/+0fHjKwLoTYnOzb9fEQ1G39gpURWnEDMqVMWqPX39U2JzovI41nucV8V
	 ywg0n1+L0+n2wKOJiyAogYSckNkm5ZyT2SmuylnQDQX+wtUGO9DdXuKa7t74y2xuMA
	 /1+bvgL9FVBA6+SYZi8dh7Fg200FOtI9mnjSh1J6mjdJLrlIhmPZqdCg0QeZJaD8SI
	 rs3bBG3Pi3ovQ==
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-27051f63018so144724fac.3;
        Wed, 21 Aug 2024 16:57:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+p5O4dA4F0YBvgh9s5aww7fWPrieeOQeREwv+sXuwabIJZB5KkmkGQkTkLH9U7nOYnmyya+6U685w@vger.kernel.org, AJvYcCUEJV5vNwzXgFRNMs6jGWgSzxtqMcuE/mnfDh+cQGNumGk7TTyl53a2audQP2SIDiEi3CIvkD1nG7z/IyGH@vger.kernel.org
X-Gm-Message-State: AOJu0YzBBFGDsRWjHR9jaOBhNVAiKel7t1Kxo3wuhrIx5Tsnz+qLJgHc
	I6C+5y638HxM5J1VHkCqQ/0vLLKafhRjlGn5URgwk9R7njtHq7j3RUnXddfRew19xHPdZDabpHs
	xrW2KhhaO5OamQth8u99e05hwAuI=
X-Google-Smtp-Source: AGHT+IH3tIvVIs3VB8AI9ZDOIws5zX/O4ZqawG7RPpLMmc7unGuzpRV+ROwe3CpLH7N4EpHz+wbfusTH3l1KUhoYP3s=
X-Received: by 2002:a05:6871:1c7:b0:250:70bb:1a97 with SMTP id
 586e51a60fabf-273cfc95542mr324034fac.24.1724284659001; Wed, 21 Aug 2024
 16:57:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-8-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-8-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 08:57:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_XWf33rCHMh8AjhXKZEdvcRS-xXew9FDeitExNaezW2g@mail.gmail.com>
Message-ID: <CAKYAXd_XWf33rCHMh8AjhXKZEdvcRS-xXew9FDeitExNaezW2g@mail.gmail.com>
Subject: Re: [PATCH 7/8] smb/client: fix typo: STATUS_MCA_OCCURED -> STATUS_MCA_OCCURRED
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
> Preparation for moving the SMB2 Status code definitions to a common
> header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
STATUS_MCA_OCCURED is not a typo.
Please check microsoft's header definition :
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-erref/596a=
1078-e883-4972-9bbc-49e60bebca55

Thanks.
