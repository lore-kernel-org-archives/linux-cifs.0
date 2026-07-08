Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEBC1A9F82
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 04:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783486726; cv=none; b=b2wBpM8Flj4TqUmhf4bL4sPoI6x+A7WATLU7eKaYemx/ExPBb2XADGEs2rz9RZPCAjLuKTGROWaKuKTE+vGkDs8PHjRbIMvuotR0gPotvlEXYHFgypjEIDLyuDD7FJnlk6o85WLhBUDtoUEtMX7n+9QHCmGa2zrRCG+S9Bh4dQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783486726; c=relaxed/simple;
	bh=RqKKttKtZu8bVVMUgc9sSYCBno+in1I76elCLJnK+sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YIY6oFqr7h2smCoo4dJTV/Fn/wi0mJZUe2/GWOx4Nph8nYBxDbHsyRFfekVqRHA60MK7DWCYowxe+tdTcNWDgEQY13xZy01QIIMD1aVW0rPzV70Kyx2XRWuEK0LggT3muELqqUgGww6+MHg6aCvmF9UXl9c0oS2nOmtc+AcrH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtTirco+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtTirco+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6E21F000E9
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 04:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783486725;
	bh=9OCW/BM5nbIhbJB54wnBnDdqgxiJqv+zlPAKv0GfI2s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XtTirco+LgG2hMCUPYSjKkLqfu3EpXA2ZB79Lju6hTK26gmiin1mgCFbxqwHQMlYf
	 3TlckvYH1sgoHBRipclL6z2zhhdlo+WZNzpaXCVcuWubx+yoFvgCaVmjFoq+Mbq/na
	 erVlAdr+MlQIE7Zrns7CQX17RPKJv+5fAHcZX3anDLl/hBrcTCZxz7HuOE+ZbPJ0+d
	 MXNVetHODgh5Zl//cogWhhO2Bxo4sCPZy2Jeq/yI6TWJXJjc2X4mo1dBXg8DjsNKb8
	 +g7/oybhz+ogAWUUCkQXrNw5ZRgFKiqdQb7oi/tNGJAB/cNUjorS4wC9DkdxEgjr0A
	 Hp76EyUND6SrA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-698ab9aae16so496153a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 21:58:45 -0700 (PDT)
X-Gm-Message-State: AOJu0YyuNUfQswWLQaGrk92BDmD6UBXPRFq+5Gc8TxTmRfooGVCFgQQl
	3rsoYtb2viZt097Ga4/zzheAD9QwCyBoazeSSt4JMPkHgqPDqry3hbPsRSu423W3J6M4gwySOdr
	Tyhdv1ONDR+gZvdpopMI7vt/2Rbl3l30=
X-Received: by 2002:a17:907:982:b0:c12:c5a2:995c with SMTP id
 a640c23a62f3a-c15ce10dd56mr49259966b.51.1783486723761; Tue, 07 Jul 2026
 21:58:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707100129.47563-1-g.blivet@me.com> <20260707100129.47563-2-g.blivet@me.com>
In-Reply-To: <20260707100129.47563-2-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 8 Jul 2026 13:58:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_fuBCffmuuEWNKhERrXDzN9=QWacMhDpqc-F-k6pZ-Ag@mail.gmail.com>
X-Gm-Features: AVVi8CcbdQpICZkP3dkUfvIgPasfK1r-pkl1u9nLrwpV61cUF1m3FW1W5e-AAaA
Message-ID: <CAKYAXd_fuBCffmuuEWNKhERrXDzN9=QWacMhDpqc-F-k6pZ-Ag@mail.gmail.com>
Subject: Re: [PATCH 1/5] ksmbd: add Apple AAPL kAAPL_SERVER_QUERY create
 context support
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
> index c9e1b0b68..1ea0a367b 100644
> --- a/fs/smb/server/ksmbd_netlink.h
> +++ b/fs/smb/server/ksmbd_netlink.h
> @@ -113,7 +113,8 @@ struct ksmbd_startup_request {
>         __u32   max_connections;        /* Number of maximum simultaneous connections */
>         __s8    bind_interfaces_only;
>         __u32   max_ip_connections;     /* Number of maximum connection per ip address */
> -       __s8    reserved[499];          /* Reserved room */
> +       __s8    aapl_model[32];         /* AAPL model string for Finder icon, e.g. "Xserve" */
> +       __s8    reserved[467];          /* Reserved room */
>         __u32   ifc_list_sz;            /* interfaces list size */
>         __s8    ____payload[];
>  } __packed;
> @@ -378,6 +379,7 @@ enum KSMBD_TREE_CONN_STATUS {
>  #define KSMBD_SHARE_FLAG_CROSSMNT                      BIT(15)
>  #define KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY       BIT(16)
>  #define KSMBD_SHARE_FLAG_HIDE_UNREADABLE               BIT(17)
> +#define KSMBD_SHARE_FLAG_TIME_MACHINE                  BIT(18)
There probably needs to be a ksmbd-tools patch. I cannot find it in
the list and any PR in ksmbd-tools repo.

Thanks.
