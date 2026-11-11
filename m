Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403815;
	b=INNx8S9nLy+fPMfGbrNdBqqL/lSkLbHNE92Iyz2/XzbSwanA4kXlCKUnQOgIyyFe2zQM
	 rUi2Z1RZG04vFsd7PA/8yPjBELshjpVDj7Y6Pnq2RLGbKkr6TAjKlu4HE4wiZXG8WCLLi
	 ulm4CFLG/FX78/Busu/jb0gXPRpXSRLKwGhkgchs45hkRPYFDU7EZ6kicwxs5sIs9Bl4/
	 9vAw2QXFaB2MTuIwnniNaDguk0OkHqH4hezq7p0CzBnaaa4hak4S4Nq9xaS/bLEjt8y2p
	 o//WUaLN5pCw9Do7CWLUm9Ih8FqfSMGFTJ4kBgbaF/g9apQVUwZ/PAJBs3OGq5ubM7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403815;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=0RxplO1mLFzUBYXU6brprN2sPBQWvCdnZ2OutIiXlC0=;
	b=Ytea8Km+URr45DcUlaldRQ0i/ZhIYJM/+dBNh6xfnAdKAJs71YnDMEZpehDARP40MfW+
	 YwCzUOWD6l+3gxgKtqiuhWG6buLDbK4RDw7tu9H31oB+3XyGHHgqB+XJCPKjrKabXrXsZ
	 XzBxSpBPQyhRgoFdrjg2rYticNTAeRAEntim4oXMY5SsxNKq0JgpPguGLLVrZVcy+84eA
	 k43qoak2r/yNtKEDvpYDi49RbZgAi9IEZPB/YUZ22lBmb9ePT1hGR95KEtVgdeBn2WAod
	 tIIWt1YsS5HmDFQkNg56tOQwPMAyn8hKE0/WVaHNssilCcJqsXkCJcJs1ytcPutXE1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7i2zk4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861AC606A32E
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7i2zk4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CFE1F00A0B
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403815;
	bh=0RxplO1mLFzUBYXU6brprN2sPBQWvCdnZ2OutIiXlC0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O7i2zk4ZrbYHmwxkjCRryhVZaWntMoZE8gCgKPyBdwcWQocwleTB2Yvsbkjsf5GvB
	 fgNjLDPILYGTLOru2D4X8Nsk3jJe18Sm15tLrqu5pSrZR9TmLMsGajpBh8OmmXZVt6
	 GUpwECkrZztup/qEn/ffwLGDFj/l+v6i5oXsuHfP/2TdhFcRImsQlrSZrsfdmoN5MO
	 Ztd9xUx+USUGcnY660sIsXwzeQF8TFCGGFGZWxLl82H27LYdL+pS+qkOjhautkDdKo
	 LrfwVg2MedOjeKwO4s99uzpRB58bfAwGYRW+xqLTCemGeoF4nSHfH5XgR9Egqj2ghp
	 QKQMcpvhjZPCA==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b70880c0a4so3492957a12.2
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 05:30:15 -0800 (PST)
X-Gm-Message-State: APuU4Z/9aWlbTAB9zrr7UOprtB3HDvzmoN0vCp5IvcH8WpOAXdWUYlE1
	yyttVGiyBpcDhdY+/4GuDMx6AgEoSSESiKaXtKwkKOOnFGlV3gsqLkqOmZSEsd8KwnqCb1CfZaQ
	Lu5p15xdkMApEEZ+KeqOK+cSPN58yvro=
X-Received: by 2002:a05:6402:42d0:b0:6b7:96ca:ca75 with SMTP id
 4fb4d7f45d1cf-6b796cacd4cmr129344a12.17.1794403813910; Wed, 11 Nov 2026
 05:30:13 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110225412.3937476-1-pc@manguebit.org>
In-Reply-To: <20261110225412.3937476-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 11 Nov 2026 22:30:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-VC8shz7r9P=mS5XvOuGoadBhjJ6XYaaivL1z8v0UGpA@mail.gmail.com>
X-Gm-Features: AclHuK_OrYgpF5a13YXs1lYPvyoXYAk-ZAYjoaZngRG19B-eSmvBFPb8FUUjIlc
Message-ID: <CAKYAXd-VC8shz7r9P=mS5XvOuGoadBhjJ6XYaaivL1z8v0UGpA@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: retry a hard link open without a lease
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Giuseppe Piscitelli <ooonea@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -214,6 +214,19 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>                 rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
>                                &err_buftype);
>         }
> +       if (rc == -EINVAL && smb2_oplock != SMB2_OPLOCK_LEVEL_NONE &&
> +           !oparms->pending) {
> +               cifs_dbg(FYI, "%s: invalid lease key, resending request without lease\n",
> +                        __func__);
> +               free_rsp_buf(err_buftype, err_iov.iov_base);
> +               memset(&err_iov, 0, sizeof(err_iov));
> +               err_buftype = CIFS_NO_BUFFER;
> +               smb2_oplock = SMB2_OPLOCK_LEVEL_NONE;
> +               oparms->reconnect = reconnect;
> +               oparms->replay = false;
> +               rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock,
> +                              data, NULL, &err_iov, &err_buftype);
Should we retry without FILE_READ_ATTRIBUTES if this retry returns
-EACCES?  EACCES handling above only applies to the first SMB2_open()
call...

> +       }
>         if (rc && data) {
>                 struct smb2_hdr *hdr = err_iov.iov_base;
>
> --
> 2.56.0
>
