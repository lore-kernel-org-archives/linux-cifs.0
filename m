Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9993E408025
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 15:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205307; cv=pass; b=vBLjzFYLJIllSrSMDXB5NJT8N/nZET13p2cBBjn4cFn2P3laLlXSgF41E0nvKrcIylFojVhwJkef3cS1eel4QvDDBa0I3K4QD+A+uxd0gsaTbB50l7//NsRULN+j1bRHsT0/oExacxSzN6zVOFGL4grICneelZrchQPqaNNPtpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205307; c=relaxed/simple;
	bh=Lpl616BgB3IUw1Q+gy0rvy04eisObBSfn3vQmGN97hg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NASkYn3zR6a1UfWixxqbYzOuhqwLZrCFkfBx3wJEHTDhD5B5QXiAQQD3SY7YquuDuK9F4BIgUzfgtV2MXONB2lMzsNphPpDVBkVtge/gvWhgDhduLXlIeyxGjwu1E6zSO4G14dlluE9vd6cNnQCzZwFCNoUqMdjlK9+PX7O/nMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sTFNc8WN; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sTFNc8WN"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50e594413c2so27775371cf.0
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 08:41:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779205304; cv=none;
        d=google.com; s=arc-20240605;
        b=gG0mvXQgrUCbp5rKkeU3b9vMyiIc2wvqriMsQGw+uEiWC9hNsGE1P1xxdv9j3WJUK+
         vs5q71wLo/srRMcQJpMohbFMBeiixgxdQKF5bkZOUwUmBvTnRdNgGC2QglQPzD7y/FPA
         DNpW3GWCMaTze/CCmgn5grT8qXyvmxb6L6XI99L2kOSgmIPbtBHJPTcWZNfCH3wgBEIv
         bQyAS2pN255yF7VI8L+nb+wJdzr9/k3PcWU3KlTAvxQJB0bBDS5m8ID3fOFBg2eBQN4/
         cw/0V9ZiTp4ZbhF1XqdgsqLE3h3PqPIWVbCWnxkSb/dVHynJXDsH/blQaCg7XPvX8XeC
         2C1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IAp2xiApO8lc9wQP8pHj1BbvMXpJrB4rB4UYF6UjT2k=;
        fh=69GtoDrryIvAP9i/qWZcA9EGpoGyFM90vJC+7EqrmWA=;
        b=Q8l8pmdWKWdTM6A0a0NizdAG2UsKVefVbrBjceyx6n1EqWjMGW0AUv8mSrg3fVX/dX
         32vieaqIB6f1OehPnoYqDSbwuAFrrCbsatxKOLlFf3cii2eZLcuY6XakYtQKx0IyD+xB
         9K3D6BIM3u0Xoy4tiYfkicFlA9woNgONqoArEf7MLUEDiuXja+W5A2aFhR9xO5/wEPTl
         dVkC2wneCevYKvxXpsH2HahyhSf/y+hntKPYz6MwHp7wlDQzONndDT+Gda82dCKxN59p
         30IdpYHk/9u2d3lwwbyuipD8tmrkA3TWKMPoU2l+xSNbmHUxN3jLAVJovIy/GCzq4a57
         MFig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779205304; x=1779810104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAp2xiApO8lc9wQP8pHj1BbvMXpJrB4rB4UYF6UjT2k=;
        b=sTFNc8WNTLv2+JXRSrBN+SY2KhETVHoMlqT0qnmIU/1g9yNAJ0aOK8S7oxEx6L/dwc
         6k6cqUCWm6+Da8kLC9LkDE+HbA6NUWtcW3BzDjrUMntovGAVgoYo2dPnGACgUSHqV2/c
         mPLNjKW8vhPGRiLxlE8LCLn88zug1we5X/Uvw/x2iNvRMds51nfVTz3xCHF56jjLL0ab
         yh15pocH9TiIHS2s3NmG7hDMXqNnvU6CohYPuS4lRqkK6Ks6ObtRWn2yPZAIDNtjecMH
         CJqdZvFMNrWfoLZLT2B5pbtGtFLBO2wwAVWkjGBUVXkn209LDzO3RP4LzTR39fGMm2AI
         pH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779205304; x=1779810104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IAp2xiApO8lc9wQP8pHj1BbvMXpJrB4rB4UYF6UjT2k=;
        b=JxC6wkWyYIsWS0GXc7lpazjH8YJe9bEvYfo03eLPwNT51U5HV24KGAt2NaA1htQ5QV
         CI5xoueX1YYOOBxkVaYAOjazpxMGlwmZyN+G3lHMO0d70cVVzf5Gx2Awu9pMFbhp3BaM
         CH1doUGGhVQZFNIyv6im4rUJN+ZcCLeSjdGimk31Wh85CfkQTcy34cPVSoTlTBwvpw8S
         ae6kM4JJkpc4i8py4ll0ugeUasi7iZXKRj6thCHxZ6nG61O4aJCj8/ZizAt7BUUN4bcT
         djuS1uyxjWQdog5wcf7BzG97bYbqKhAXmPGzSHDACwqZ7jMt5/QllYb0GbBx48JhkWyi
         kcIg==
X-Gm-Message-State: AOJu0YzeeHx/xXhGklfKDhr1mwjg/ivZQ9lxtreKwxnX31pysSYX95kI
	GvaktRkC2WVAEwlr96H/L0Cjk/EVr3l4/wHaRsR673Es0yglaaRf6ErG9hximWVq5WtvblxyRpe
	bsJuXXEUlf2usf/u++OKsFfhvL5g+uw69Ombson0=
X-Gm-Gg: Acq92OHjT0khxdEWx4UJBBvOslskKj1u8KcjwbZD0CQKqwz0SO4AkoQaupWRLP7QqUF
	O6Jd6T84aS+XE5IvC6cSTitMLsmDdFpriUhU1bCGd/M4OV2DymnJnHn5RcpdmBuBhTNjADOgDkU
	zS7C9wmTlbQilOP+VPCczsqoQPeBGt8bFX5/NFJhTkq4SLU89thUJUR1cHhKJWidqAg7gxuWjED
	4v1kW1YHklFYndi/1GxI3MaNmwj6O9HMhxbn72DwcidVf/zYMD6+F2qCWy3nw5i9lmDimQB0uvR
	4SWyrf1jmMp6k5gJAGZy+aNwkysjoJ/1C8YLpt6COONiYKmmw45fnTaXItuLkZW+UYJNeu+YV8c
	JcXfzcSQ/vfgEQzBgEpXGDvMYjBQQnxURLnru7Xfq6o9GQz1mG9weyuau+FtcKustmcrQ692RKi
	njOXHvPRDvPZ+KSeotCWVjJaIZpZWlahSL
X-Received: by 2002:a05:622a:1981:b0:50f:bcd0:2235 with SMTP id
 d75a77b69052e-5164155c01emr307992481cf.7.1779205304458; Tue, 19 May 2026
 08:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtBCP-sg6f3RH3RxO=-Fv9WznGmAwHHBQJBa=1+_DEnZA@mail.gmail.com>
 <20260515193141.542623-1-mendozayt13@gmail.com>
In-Reply-To: <20260515193141.542623-1-mendozayt13@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 19 May 2026 10:41:31 -0500
X-Gm-Features: AVHnY4IrLr7T92JPiEPawqWjlFuOlBhpjNQtSs7PRnGjfh63jSP5PAJWkEvVdFE
Message-ID: <CAH2r5mssJFGv_p2Z6UMaai8vczjp4TNzi9JuEGiuDqvJ2T6Tzg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: use data_len for SMB2 READ encrypted folioq copy
To: Jeremy Erazo <mendozayt13@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Don't remember if I had forwarded the sashiko AI review of the patch to you

https://sashiko.dev/#/patchset/20260515193141.542623-1-mendozayt13%40gmail.=
com

Let me know if any changes needed

On Fri, May 15, 2026 at 2:31=E2=80=AFPM Jeremy Erazo <mendozayt13@gmail.com=
> wrote:
>
> In handle_read_data() the encrypted/folioq branch
> (buf_len <=3D data_offset, reached via receive_encrypted_read for
> transform PDUs > CIFSMaxBufSize + MAX_HEADER_SIZE) copies the READ
> payload using buffer_len rather than data_len:
>
>         rdata->result =3D cifs_copy_folioq_to_iter(buffer, buffer_len,
>                                                  cur_off,
>                                                  &rdata->subreq.io_iter);
>         ...
>         rdata->got_bytes =3D buffer_len;
>
> buffer_len comes from the SMB3 transform header OriginalMessageSize
> field (OriginalMessageSize - read_rsp_size); it represents the size
> of the decrypted message after the SMB2 header.  data_len comes from
> the SMB2 READ response DataLength field; it represents the actual
> READ payload size and may be smaller than buffer_len when the
> decrypted message contains padding or other trailing bytes after the
> READ payload.  The existing check `data_len > buffer_len - pad_len`
> only enforces an upper bound, so a server that emits
> OriginalMessageSize larger than read_rsp_size + pad_len + data_len
> passes the check and the kernel copies buffer_len bytes per response,
> ignoring the server-asserted DataLength.
>
> Two observable failures with a crafted server (DataLength=3D4,
> buffer_len=3D20000):
>
>   - the kernel returns 20000 bytes per sub-request to userspace and
>     sets got_bytes =3D buffer_len, even though the response claimed
>     only 4 bytes of payload;
>
>   - on a partial netfs sub-request whose iterator is sized to
>     data_len, the over-large copy_folio_to_iter() short-reads,
>     cifs_copy_folioq_to_iter() returns -EIO via the n !=3D len path,
>     and the entire netfs read collapses to -EIO even though the
>     leading sub-requests succeeded.
>
> Use data_len for the copy length and for got_bytes so the kernel
> honours the server-asserted READ payload size.  For well-formed
> servers (where buffer_len =3D=3D pad_len + data_len) the change is
> behaviour-equivalent.
>
> Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
> ---
>  fs/smb/client/smb2ops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4825,7 +4825,7 @@ handle_read_data(struct TCP_Server_Info *server, st=
ruct mid_q_entry *mid,
>                 }
>
>                 /* Copy the data to the output I/O iterator. */
> -               rdata->result =3D cifs_copy_folioq_to_iter(buffer, buffer=
_len,
> +               rdata->result =3D cifs_copy_folioq_to_iter(buffer, data_l=
en,
>                                                          cur_off, &rdata-=
>subreq.io_iter);
>                 if (rdata->result !=3D 0) {
>                         if (is_offloaded)
> @@ -4834,5 +4834,5 @@ handle_read_data(struct TCP_Server_Info *server, st=
ruct mid_q_entry *mid,
>                                 dequeue_mid(server, mid, rdata->result);
>                         return 0;
>                 }
> -               rdata->got_bytes =3D buffer_len;
> +               rdata->got_bytes =3D data_len;
>


--=20
Thanks,

Steve
