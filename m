Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9581D88C4;
	Mon,  6 Jan 2025 08:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736152230; cv=none; b=VRSvUTCc7Grd+xNkbB0/JEdZT/2pGdHCRaBcURg3OKiGFYQus0sMa5DjuWaffCN2HcJOVzl1rkyNkzCYaWiEuDuZcvaR4QZk7RT+vW0DTotPUqEm7dACODVZ5gq6NdzWFNLalT6q80u0mFF1WduM/5NYfY5CXZS0//hNwzVQzP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736152230; c=relaxed/simple;
	bh=CpolfdFrC3t51fcB/mO8yBjdVlyXPaFs/c8hWmPgsQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QvZZcqm+duS92wq2e1b+YraL0xeiWYTFQD0PSyfWIc5eAJkZ6Kxh/BjTXX/5F7rH4d+17tzsHyI9yalv+w5CWjGccJ7M925yfbgUKQ5Q/pQVQ3p8eov18FmrnLqoQoGL9RBLFP4cE8USoBQ+ILl7VT37r1qTWW1ALwAMNuM5p+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZESBSzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZESBSzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B669C4CEE1;
	Mon,  6 Jan 2025 08:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736152229;
	bh=CpolfdFrC3t51fcB/mO8yBjdVlyXPaFs/c8hWmPgsQY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jZESBSzRb6IMekkUj28abgZD0WtOBnfutEG52MvZ8wXvwICy9qmuQdJmTEp/HV+rP
	 lAs/ucnMgcCoYtpemWi6Vjwi492Xoaf46hSQ/hIQlLLph33jQUwwLC7cqjgkFMG+qA
	 G8uut5lbAGXgtRKPO8Et+B2UvZaBjcKcUD9I6exwqvApaijZSG9Hc2z5+GWvCl7Xcj
	 Py4FF/D+JXHAyY3GYUYkW6QLAPp1HZlY7fn7TcqMGvTXanWYVsiSajrPfv2KRhBXY0
	 hMSdFl5BGuDQehqNIWyVp5jASmNqpwhS05f/7D59etvaC/oZmDcY/yZcl2lByNc00k
	 iqXypjKSV5dUw==
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-71e2aa8d5e3so7710074a34.2;
        Mon, 06 Jan 2025 00:30:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV0AuXWJ0WJ23HA+kkjphTFOvm1H07Qgszk4a/ouA6Gbmk5ybI13qaV7ahcLBRs9v93dOJkfCwuK9Sp@vger.kernel.org, AJvYcCVG1K+mZwauc/veRagF61hdzchXpNuFvWs+SCWyhP3ypRzRnnwNB9BqWES7GuGXdNKUoPcH/tBTZRaPXIQX@vger.kernel.org
X-Gm-Message-State: AOJu0YxsBNKzmReGZCvLPqkVEPd5FuA12VB1bl2olRo2LfTWBYaVERtS
	9ed8Rv/7QqiEsNcZq7ucEG7jGC6TEaic3qhPGLzLPg+7+2pzk44hdppaaYSmMuewUwuG6mvZf2+
	mhvD50gyR5rfBH8YZarzdE0weHWU=
X-Google-Smtp-Source: AGHT+IEBqXlqzegJA2lUKji/P0MyggioP/jCdgBIRIMESNpE+lZwOIeqXx15Vd6ggRSRmbcmrr8/dPCE2Zl6RNFHeNI=
X-Received: by 2002:a05:6808:1a29:b0:3ea:448d:1bac with SMTP id
 5614622812f47-3ed88f3f13dmr36661974b6e.4.1736152228387; Mon, 06 Jan 2025
 00:30:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250106033956.27445-1-xw897002528@gmail.com>
In-Reply-To: <20250106033956.27445-1-xw897002528@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 6 Jan 2025 17:30:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9o5d320CT6UNxLHtEnyf=5bS-93+YRAoWaiJQasgr6jw@mail.gmail.com>
Message-ID: <CAKYAXd9o5d320CT6UNxLHtEnyf=5bS-93+YRAoWaiJQasgr6jw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: fix possibly wrong init value for RDMA buffer size
To: He Wang <xw897002528@gmail.com>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 12:40=E2=80=AFPM He Wang <xw897002528@gmail.com> wro=
te:
>
> Field `initiator_depth` is for incoming request.
>
> According to the man page, `max_qp_rd_atom` is the maximum number of
> outstanding packaets, and `max_qp_init_rd_atom` is the maximum depth of
> incoming requests.
>
> Signed-off-by: He Wang <xw897002528@gmail.com>
Applied your two patches to #ksmbd-for-next-next.
Thanks!
