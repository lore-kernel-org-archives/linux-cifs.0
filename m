Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792817106;
	b=pOVG4XtqHx1YImssvaJ5FLcml+tfJDf6JuJq8/AM5lB+RyouP44Fc9FqKTeFdttwNlki
	 I0DBZiBbwYNHtdrSFcUjgRZsCJSHYTqR2aZxprlpJXcvOkDEXd8rJDoXsXb0NRM6eRSyT
	 KHOap27DFQFnsBn2iO/wM5EzgACDHJQAczhRYGjtQzVCBR8HoGwMtjxHmkY0pRIAfCHwX
	 be6x1sz/V2hHnOJNP8RqoZ1VIS7266s3mRBdsMtN9CFPxeHhMFSRaaQdKPDoa6knlUFY2
	 o4KXMDanH6INkOeGATok1zU+pU4cK8pJQg3o9CbnXAYSLQTT1/dZMsd1/7eJ7fvK3yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792817106;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=IkTExJ1xt4czrppb7I7mUL52p2q4p/WVjeziJB6ECHU=;
	b=CmVd8gMihGMLe3/mTtG3c6muMESsxqdci5f/Q54UJ6DaTwtW0KNO9iRQA5fmudzP1iGz
	 2yRoGcETLqYLJql9yIWW/36mjB5MDXCfdW/7si4b0QqAPrqUzt4LVS5N2oCY41U/FC8NZ
	 MSGtnzEzzAeJCmjPt7DJtl7dQq62dsDKw/S/MDOtKNkUwNmigUIFSfaKULNqktHX41N+J
	 xt3VUZDwPJ08qaylOPzsxhSTdEbu++dyGp5gjMtmkFpNSklXybTBQDDjYc5GKx2L5gmVp
	 ND5IlLI0o6i5F84Az2uXKGMf6Cqjrzthfzi0Y57hGVk/e95ZHVwf2S+eTNcABf+fvRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=if3Z+TJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F031606A31B
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 04:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=if3Z+TJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11B41F01829
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 04:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792817105;
	bh=IkTExJ1xt4czrppb7I7mUL52p2q4p/WVjeziJB6ECHU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=if3Z+TJxI1bXf/vuydBkj2ivHmkCVAqHzVk9OFXSEy1B+mOLms0ke7TXA039Z7Gs6
	 t6Vs5LOQzauh6G1nEpx5RCtPuzRJTEay/IMWkhsmTi1M2RUff6El4JtLZiqA1QhtAP
	 9QZhqJhvRvybwETE2aMycuZrVEaTrWYsh2XHZJIG1QLtK25HKoBztPK+a22j4cOF5g
	 an2a6xFpk1tKLwkrc+YpotG7GR3bTVFn5Qe5ofiv1NITJel10SbKWb9lfy03vZEzmP
	 uVGipa0d1fp3Vp6xNAoWHtCSjUZVf7UF0m3YyRuiYpqgW+B73VhJoeOa4GGbJJAtuH
	 3gwadCRud0pEQ==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b40fc523faso1545384a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 21:45:05 -0700 (PDT)
X-Gm-Message-State: AFq9FYIpLAN82Va+LCu9k+BBZet2nJrEMD9Dhgv5Z59d1vI6TBSM8jMY
	Q8ZH4HOH37+jbMcADPgj2GRXc0EdzB/x1JTKJvZXB1ldiCyuiDq4K2AUnPCshM/kUrfJDbtkMBY
	usDXCE0ACXJ/kLvOiZyqF8r9UkhFz/5s=
X-Received: by 2002:a17:907:d9f:b0:c45:c030:732c with SMTP id
 a640c23a62f3a-c46bdea5694mr92508966b.41.1792817104588; Fri, 23 Oct 2026
 21:45:04 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022092514.2590010-1-huiwen.he@linux.dev> <20261022092514.2590010-5-huiwen.he@linux.dev>
In-Reply-To: <20261022092514.2590010-5-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 24 Oct 2026 13:44:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9SW_D1gwMhD8gVjVJAcPoxiXvHB0TvDLqnjw8TpGCKRw@mail.gmail.com>
X-Gm-Features: AclHuK8Kwr3rWA83HAQi48hy7B3QNMUE-TB8Aiiq6UAFJonGlI7eqeiW9f6hFRw
Message-ID: <CAKYAXd9SW_D1gwMhD8gVjVJAcPoxiXvHB0TvDLqnjw8TpGCKRw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] ksmbd: send READ payloads with MSG_SPLICE_PAGES
To: Huiwen He <huiwen.he@linux.dev>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, tj@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -35,6 +35,47 @@ bool ksmbd_queue_request(struct ksmbd_work *work, bool use_write_wq)
>         return queue_work(wq, &work->work);
>  }
>
> +struct aux_read *ksmbd_alloc_read_buf(size_t length, bool allow_splice)
> +{
> +       struct aux_read *ar;
> +       size_t alloc_size = ALIGN(length, 8);
> +
> +       ar = kzalloc_obj(*ar, KSMBD_DEFAULT_GFP);
> +       if (!ar)
> +               return NULL;
> +
> +       if (allow_splice && length) {
> +               unsigned int order = get_order(alloc_size);
> +
> +               /* TCP references to tails must keep the whole allocation alive. */
> +               if (order <= MAX_PAGE_ORDER)
> +                       ar->page = alloc_pages(GFP_KERNEL | __GFP_COMP |
> +                                              __GFP_NORETRY | __GFP_NOWARN, order);
Order-8 and order-10 allocations can easily fail when memory is
fragmented. Since MSG_SPLICE_PAGES does not require physically
contiguous pages, could we allocate individual pages and use a bvec
iterator instead? Please see drivers/nvme/host/tcp.c as an example.

> +       }
> +       if (ar->page)
> +               ar->buf = page_address(ar->page);
> +       else
> +               ar->buf = kvmalloc(alloc_size, KSMBD_DEFAULT_GFP);
> +       if (!ar->buf) {
> +               kfree(ar);
> +               return NULL;
> +       }
> +       return ar;
> +}
> +

> @@ -47,6 +49,29 @@
>  #include "transport_tcp.h"
>  #include "compress.h"
>
> +/* Switching affects allocation, not ownership of existing READ buffers. */
> +static bool read_splice;
> +
> +static int read_splice_set(const char *val, const struct kernel_param *kp)
> +{
> +       bool enabled;
> +       int ret;
> +
> +       ret = kstrtobool(val ?: "1", &enabled);
> +       if (!ret)
> +               WRITE_ONCE(*(bool *)kp->arg, enabled);
> +       return ret;
> +}
> +
> +static const struct kernel_param_ops read_splice_ops = {
> +       .flags = KERNEL_PARAM_OPS_FL_NOARG,
> +       .set = read_splice_set,
> +       .get = param_get_bool,
> +};
> +module_param_cb(read_splice, &read_splice_ops, &read_splice, 0644);
> +__MODULE_PARM_TYPE(read_splice, "bool");
> +MODULE_PARM_DESC(read_splice, "Page-backed ordinary TCP READ sends");
Can we set enable/disable it via ksmbd.conf also ?
