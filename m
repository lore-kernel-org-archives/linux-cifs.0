Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350244A32
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788011028; cv=none; b=fLJpHbzvN8X4htX2N8pkIaKoC9x0szU5pU9KZvT2RlIAl7jIYuMhpflk2hqvql5AHZyRqXc9y5rGzA2l+u+itaaR00GOq24zgV/PFyCr/E4OvGRcMJ1r7OB3pVHtgddoOiLWy4ZYaG0qmF5vYM91D+xiC/lwuEIPRrIraFQVK0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788011028; c=relaxed/simple;
	bh=E6znvuU71GuZaYIEr4+jlBhjDF7IPMkQ/+m/bu9Ti48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dL8nuVktBD+KfvOK1axTdnGq+uAOLdwBRb2udfDhy9Ctf64D1QIUnHDr0/TCLtmEviuQbqKH2HGoZxzxa8KdqstysP3iLthALmmOhQS/jLr0J7srzDQ5/hP4N6uW3R4EiJhi4tmralpmL7prFGr4zlTAToPPQx1L/5mU4mz8CLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxI6pFxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxI6pFxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE511F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788011026;
	bh=gzgK8R/esFymbOUDq7c8sRrGunjQgAXuMQrpYBPR7f4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IxI6pFxrkyjUuxeAVaT4n+m5hsNhc87r714uyBz7UeasVj2XEDq2TU0gqlREQskYt
	 2GC9zoVFDAhtjcnZH4qiX3nZ76NINtG/moeJvan2CvF1q2jDIEqAxBItA3BNWcROOB
	 TVpv+7O9A/KuE+9PrXRNXIcRDFKEmDYRnsM0aSI4y5XGLTIOiqb3X1O+P/Wz1br+Uj
	 FJuoQCo5hzzCKRBU03EUx0bXFwddMx6j8d3fozFCqpkQRTDneCbtbReX8qL1E+w2kf
	 z8/wj+jqlnP3QBl/1uZjoZNG85QUt/Q+5eNr8dFiuJe024YQyoqXTVHYi6KgsOOdVb
	 Tf8IziaFoKa0w==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c20e70a0962so254760666b.2
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 06:43:46 -0700 (PDT)
X-Gm-Message-State: AFuF++nNpPc+RCX14NsydIjXNVOwtVc6R9CkPviqWfv0obyaewql8ZZe
	sazIRY3cwd+ygJ6YP7Zy6pvDpRVugGtEZ+0iCCst8s8hATZj0OcQZ8d0gPA/HfpV3Eh1GkLFJW6
	9Se6HTTrLWs7QbSBHTZas702G963hRV8=
X-Received: by 2002:a17:907:3e29:b0:c20:1bc5:7002 with SMTP id
 a640c23a62f3a-c2556c24f92mr854174066b.3.1788011024864; Sat, 29 Aug 2026
 06:43:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829113917.26882-1-suruurism@gmail.com>
In-Reply-To: <20260829113917.26882-1-suruurism@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 22:43:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-PDvGyUc7834fVGAvDGnqaOxcrJE6XXMF22eLS5=dzLw@mail.gmail.com>
X-Gm-Features: AcwNN1VUZTgxPCSA-cmif0sNP3piWZ_UjGJ4gXReasVXVX7g4ln7h5-n-t8yfiE
Message-ID: <CAKYAXd-PDvGyUc7834fVGAvDGnqaOxcrJE6XXMF22eLS5=dzLw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix use-after-free in oplock break notification
To: Abdifatah Suruur <suruurism@gmail.com>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

> +
> +static inline struct ksmbd_inode *ksmbd_inode_ref(struct ksmbd_inode *ci)
> +{
> +       atomic_inc(&ci->m_count);
Using m_count to pin o_ci breaks delete-on-close. The last file close
will no longer drop m_count to zero, so __ksmbd_inode_close() can skip
unlinking a delete-pending file.

> +       return ci;
> +}
>  bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry *dentry);
>  struct ksmbd_file *ksmbd_lookup_global_fd(unsigned long long id);
>  struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
> --
> 2.53.0
>
