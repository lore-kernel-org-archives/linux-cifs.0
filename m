Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7328F501F4A
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 09:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860926; cv=none; b=Pp//CCNMv27YARxWw6bmf/nN5UYlI7wbKiCpK773zhalkuJ1Tdvw4k1ZOui8c3bKgaujnE8oSFsVW8W4rOZiocGbE8D55Ezz5VPQHx+VFo58IZkElI1WYmfg8Mv5DjL0Z0ULVpvWoDmJn2eICnpvbKA2xibrBGNt3jRcUQy0x3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860926; c=relaxed/simple;
	bh=Blvn0uWkNwe49PloPyDuYxxfjFByrGWCHWjXd2Ojztk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MFk70piGTDertMA87yZwgtiSC+djUo9wJzUaOBhXq7jCQ+ExqneBqcf3lzavwKjbj4VwhWlKVdsU73JedErXRr79UEQhGvIeiaFB30k2+B9GexFRYYjpSac6GF3lUu/dBlt4RVIr2U+XxguwKZ30c3yeZK4dYIr4uTqXWq746Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXheTZKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXheTZKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0391F00A3A
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 09:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860925;
	bh=4Cf+UZQ9uYJ7kCGqPtyT8Ptnze6DfkvO3+nNpliRVl8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GXheTZKx+hbpJIFdtsxpQeDWYa7m9Mad1LnG+bmqVtuZG8BGx+xoR2WmVvuIEvohO
	 A+mw3BE6J0ZYlHhjKXBdOb0AC3jdUZaGmVohNSR8h8kXE3OhloEPlAXa21W+0bLj0z
	 s4186j+IwzTgB5u/vMkHBFxwNa5Fuq06ZegeNOnuPVMBZmbAiLN4j3uSMC/Dp1SLBm
	 xs6fyx2vEl+j3gzCX9QI9Qobi4j/w93C6XoV9H4D6gndlnOSE5MNdMvWi6GmIieM4k
	 E+A/9DsTo0azxG9cs8HFXVEDfLP4ImulJ8s/DeLCA6ElEjrnzAIZG0bw1U8xqoBi3e
	 p0z23czb/nq+w==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2530cabcf4so676605766b.0
        for <linux-cifs@vger.kernel.org>; Tue, 08 Sep 2026 02:48:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw/InklccNVTawEfz6iGhy3dQy0CFBIen7xiG392agrsfhVk4UwuNuchml0FN9bQ2k5EK9QPdK8k+Hd@vger.kernel.org
X-Gm-Message-State: AFuF++n8eP7bZY2PFoDXUH8wQga+3EGTRD9s2UhyX5Jgmps7bX4SagUb
	At9NgXEVNMHDGMvRUnZoJs9Z1TJqEJQw9PU1/6jeOpsKcNd8DCGa15iW4tbPxPQcubQpzkvZLBL
	HeG8jLngA7RaDOIjjGeKES6XKGI0zKDo=
X-Received: by 2002:a17:906:ba8f:b0:c25:c14d:1c4d with SMTP id
 a640c23a62f3a-c260c9ba8e8mr1898142866b.7.1788860924020; Tue, 08 Sep 2026
 02:48:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <AS8P251MB000178EC4EE49C074687E8CBC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
In-Reply-To: <AS8P251MB000178EC4EE49C074687E8CBC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 18:48:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-oexdTbBKid8tNEQiX=uShzssNQ=W6dQcsxzmSih2ccA@mail.gmail.com>
X-Gm-Features: AcwNN1W8WDN5_FLtEzP2xFQ0HjghcEWtHxnJRMPjUKs3po7v79lggASIXD8-RDk
Message-ID: <CAKYAXd-oexdTbBKid8tNEQiX=uShzssNQ=W6dQcsxzmSih2ccA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: initialise the reserved fields of six SMB2 responses
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 8:38=E2=80=AFAM Aamir Ahmed <elb12345@hotmail.co.uk>=
 wrote:
>
> smb2_allocate_rsp_buf() zeroes the response buffer, so a standalone
> request never leaks.  A compound request can: the offset of the next
> response is advanced by the length pinned for the previous one, so a
> reply that was written into the buffer and then dropped in favour of the
> short error response of smb2_set_err_rsp() stays there, and the next
> reply is laid over it clearing only
>
>         memset(rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);
>
> which covers the header and StructureSize and stops before Reserved.
>
> Six responses declare their full size but leave a field unwritten, so
> those bytes reach the client as they are found in the buffer:
>
>   - get_file_standard_info() and get_standard_info_pipe() never set
>     smb2_file_standard_info.Reserved, 2 bytes at offset 22 of the 24
>     they report.
>   - find_file_posix_info() never sets smb311_posix_qinfo.Zero or
>     .ReparseTag, 4 bytes each at offsets 64 and 72 of the 112 it
>     reports.
>   - smb2_session_logoff() and smb2_tree_disconnect() never set Reserved
>     in their 4-byte bodies, which are pinned with a bare sizeof().
>   - the FSCTL_GET_REPARSE_POINT case of smb2_ioctl() sets ReparseTag and
>     ReparseDataLength but not reparse_data_buffer.Reserved, 2 bytes at
>     offset 6 of the 8 it reports.
>
> The logoff and tree disconnect cases are oversights rather than
> convention: five responses share the layout { hdr; __le16 StructureSize;
> __le16 Reserved; }, and smb2_echo(), smb2_flush() and smb2_lock() all
> zero Reserved explicitly while those two do not.
>
> This is the same class as the FS_OBJECT_ID_INFORMATION and
> FS_CONTROL_INFORMATION leaks fixed in the series merged on 2026-08-31.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Applied it to #ksmbd-for-next.
Thanks!
