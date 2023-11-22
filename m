Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Px6vDO4L"
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57373DD
	for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 17:49:09 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2c83d37a492so77582801fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 17:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700617747; x=1701222547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziFoHX+4kCiKcRbktHrzMuyijvTMJEebMtNMTmeUZeE=;
        b=Px6vDO4LCIIyO+AJdYdHP1yLdOs4TuEOREzla5G6rySi6IchSaqQnTFCL2ZWkPsUwi
         fUNHjMtnhrtm8xwhfMFUrew+O2aTM6BcMhWN0thlJMhtks0VPgw3MHgU8dk/iji45IXh
         zqSY0t/PoWw1RrM+hOYSsmEc0S2ZbgnGRcuB1IyEN2JIOGHc6MW7j9gIMJk6cNtwks4U
         R+kYGr5GGka7teVjlTKgu4mzwqC5+UAVIhUbuk2lSlXgzVn+iNud6p4x07Q7JUtbLh0s
         2NERi/XFQX/jd6zsXZn1GiPBeoq6C5e/MLMt5j90jcsgFsN2/sdiuCOk7ZHukCB311eo
         kK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700617747; x=1701222547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ziFoHX+4kCiKcRbktHrzMuyijvTMJEebMtNMTmeUZeE=;
        b=RqVjqMW8nJCAXuAical/hKmwN9QYlYwaaFUcxpvGa+rsBra432FLfKDa5jOPh0L6KJ
         NsYqmX6/978BD8oz4U9e38sTdVgMIN4TAxjPZRqK2SvICqee87QkVCQfNsk8BkXjsrvn
         ZC41Eb7LOEaj61sLOuR1O5IDT/3QqdHDWszyOc5MUVP9oqV8tvUVmlhhBegNxs/mpOCo
         d3V/gpFI3B6lXIpv/in85nG0rE5e0i+XXyNk5syDqqUAVlSZu2/Royqc0hWJ39bBDv7d
         l4Rgr3fDCuIRkkcdErejgRR2t1NHlHpBg5cIJBo2s9/CDzS3bfj/iZkchFZtAhEvE4I0
         6nUw==
X-Gm-Message-State: AOJu0YzkltuTJQuqkBelo5UWmd6DLuT84VG+6Yc6NFfO48g8j4jagAIj
	rFrZG19ISUJCcEnsGQGVEq13dM9W6jWpeBYrkEM=
X-Google-Smtp-Source: AGHT+IEmsJsmo/6KSMZLFPdhgevEKhK5clb4Lx9ephJg4UfziAigfctwjViRzrR6eGYHBFA4+v3QmTUkwi9JhTT+Vew=
X-Received: by 2002:ac2:5e7a:0:b0:503:99d:5a97 with SMTP id
 a26-20020ac25e7a000000b00503099d5a97mr544919lfr.20.1700617747233; Tue, 21 Nov
 2023 17:49:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231121134347.3117-1-rbudhiraja@microsoft.com>
In-Reply-To: <20231121134347.3117-1-rbudhiraja@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Nov 2023 19:48:55 -0600
Message-ID: <CAH2r5mtuRSEYtbJGpSTpWDB7moUPKnA8fAj7L6CERSiP_LZFbw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix use after free for iface while disabling
 secondary channels
To: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Cc: pc@manguebit.com, linux-cifs@vger.kernel.org, sprasad@mirosoft.com, 
	bharathsm.hsk@gmail.com, Ritvik Budhiraja <rbudhiraja@microsoft.com>, 
	kernel test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into for-next pending testing

On Tue, Nov 21, 2023 at 7:44=E2=80=AFAM Ritvik Budhiraja
<budhirajaritviksmb@gmail.com> wrote:
>
> We were deferencing iface after it has been released. Fix is to
> release after all dereference instances have been encountered.
>
> Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202311110815.UJaeU3Tt-lkp@intel.com/
> ---
>  fs/smb/client/sess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 8b2d7c1ca428..816e01c5589b 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -332,10 +332,10 @@ cifs_disable_secondary_channels(struct cifs_ses *se=
s)
>
>                 if (iface) {
>                         spin_lock(&ses->iface_lock);
> -                       kref_put(&iface->refcount, release_iface);
>                         iface->num_channels--;
>                         if (iface->weight_fulfilled)
>                                 iface->weight_fulfilled--;
> +                       kref_put(&iface->refcount, release_iface);
>                         spin_unlock(&ses->iface_lock);
>                 }
>
> --
> 2.34.1
>


--=20
Thanks,

Steve
