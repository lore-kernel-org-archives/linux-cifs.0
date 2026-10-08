Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352AA22A4F1
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 02:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791426395; cv=none; b=ogNzNilCVtnFmVrAu9Jsb6F771Vox9Rp1vRK6k/3zoIv/1JRffa9svYUeVu9vga1Amvygqsd3+5l/jIfgJG49k+ZY/zDa0hMqG9zs63+PEY6psGFs0tvMXNqk5y4z8al4FFUfHVrPg97vdkF3VquEEIrJqMIg59bgCmEpxGsxzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791426395; c=relaxed/simple;
	bh=ex9n3hDB+0NdXLB2WCiEr318O8NqS3kXL+I+apCsm5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gfta4Cw1MqawcOp8gYzubyjwWvnDviAt8pVkxjLcw+ch+T8hysBI8BqpHKpV6ua0rTWc5J9E+ghXFshKPKIgL8eN2SCXyl8drRjrvbYy7SF3yDPiF2hI66Mg3PnHEFfAjYv0WndhhSWEeKk0r6hnQy8hyRq1ifQWvyCMCVyxGvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ebh3RBiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ebh3RBiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B229B1F000FF
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 02:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791426393;
	bh=0BDdCGTIFhxuiERDwOV3CXMKl39K3PjHf7a34vLTQZs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ebh3RBiUQwWuxaijk5FK4Sg078GXYMcQuG84PIQSB+ix4O8mzZ/wPAgyroLRxF30K
	 Oxm+UO0gV0esgiM9tHw1tbo5baLtGGJc3dJ27YIsjYwdtIJTi+45KvRjn/+V+BaCaZ
	 v+7f21gEpY3BRcyLcxuoAaUBHGhVzoXpFUsVDfRaCs93yAXSkGTZIK2cwXX9QnEygP
	 /x2pXQQQxDEEasC4/Gc1QzEuzu1VGEb0VURwsIqFls4ZQWPxpWS9p48RRqiCPyLwCv
	 BdBIl1hdNDNbXLWG4QL496c+hmLNilbbaDMm0J93j1RlvSCCsE26byAWxV9xCbDmEX
	 nJASfSfFvU1Jw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2e6df2742cso350127166b.2
        for <linux-cifs@vger.kernel.org>; Wed, 07 Oct 2026 19:26:33 -0700 (PDT)
X-Gm-Message-State: AFuF++npja4b2niSSProHdiUL2z2kw/0TqtxN9WEy3lNNpqMQrb4vHP3
	U4/86Q5/lrlzc2c5DfKH/7XYoY3gG65JbYuXBVdCGqQcwgHSEOZrZUPWVTKFoxqBQuoGxDlQqnw
	wRPEKUp8ZrCumfb8ivo+5GjDZ0J0NoPs=
X-Received: by 2002:a17:907:3e8b:b0:c2e:7daa:7645 with SMTP id
 a640c23a62f3a-c317bd9c34bmr348035366b.23.1791426392367; Wed, 07 Oct 2026
 19:26:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791311817.git.metze@samba.org> <ab714dc8161c7b23734d95157b0b86e5d0081f1b.1791311817.git.metze@samba.org>
In-Reply-To: <ab714dc8161c7b23734d95157b0b86e5d0081f1b.1791311817.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 8 Oct 2026 11:26:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ziPYkMzYodQ1=nEEL2JGnAeGe9eYR8d_jk5EOTOEMPw@mail.gmail.com>
X-Gm-Features: AclHuK9dDTiih_lk-9Ow0GjSFGENNoyqmZnW55u5RzHupDRwO4sVs5NzmlyFzmQ
Message-ID: <CAKYAXd-ziPYkMzYodQ1=nEEL2JGnAeGe9eYR8d_jk5EOTOEMPw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] smb: smbdirect: release failed pending sockets of
 a listener
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Lee Seong Hyeon <ihopenre@gmail.com>, Sashiko <sashiko-bot+sashiko@kernel.org>, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"

>         ret = smbdirect_accept_connect_request(nsc, &event->param.conn);
> -       if (ret)
> -               goto accept_connect_failed;
> +       if (ret) {
> +               /*
> +                * The rdma_cm core holds both the listener's and nsc's
> +                * id_priv->handler_mutex across this CONNECT_REQUEST handler,
> +                * so neither can go away under us here and nsc cannot receive
> +                * any rdma event: it is safe to hand nsc to its teardown.
> +                *
> +                * That teardown must be deferred though: nsc->rdma.cm_id
> +                * (= new_id) has its handler_mutex held by us, so it cannot be
> +                * destroyed synchronously from here.
> +                * smbdirect_socket_schedule_cleanup() only queues work;
> +                * smbdirect_socket_cleanup_work() then orphans nsc off the
> +                * listener and smbdirect_listen_purge_orphaned_work() releases
> +                * it, destroying nsc's cm_id with rdma_destroy_id().
> +                */
> +               smbdirect_socket_schedule_cleanup(nsc, ret);
Does this make return 0 unsafe? This path now queues cleanup after
creating the QP, then returns before cleanup runs. If DEVICE_REMOVAL
event arrives in that gap, the temporary handler sets sc->rdma.cm_id
to NULL and returns -ESTALE. The CM core then destroys the ID, and the
cleanup worker tries to destroy the QP with NULL ID, causing kernel
oops ?

> +       }
>
> +       /*
> +        * Always return 0 so the rdma_cm core keeps new_id: nsc owns it now.
> +        * On success it stays connected; on failure its deferred teardown
> +        * above destroys it.
> +        */
>         return 0;
>
> -accept_connect_failed:
> -       spin_lock_irqsave(&lsc->listen.lock, flags);
> -       list_del_init(&nsc->accept.list);
> -       nsc->accept.listener = NULL;
> -       spin_unlock_irqrestore(&lsc->listen.lock, flags);
>  set_settings_failed:
>  set_params_failed:
>         /*
