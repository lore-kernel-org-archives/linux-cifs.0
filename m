Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60871624DF
	for <linux-cifs@vger.kernel.org>; Sat, 14 Mar 2026 02:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773454841; cv=pass; b=FWA3NSqpD5IWOOMTlTIZp1sbmLV5DyMBbt3BTnlMyqhN4f34K3H3fHElAoDoCBvBFeiJwyrTfA8aVWd6JDbeznQuyay40ZzyWn91+FBLBzPmhAAKj3Xt4PMRcvDrUzAbWUf8Nr631BbodJpWCpvh5pk/Ov3ipnPVYu4LTwXyoZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773454841; c=relaxed/simple;
	bh=dkdvt14/uh2hiuglWb2K5y94R1J8fmJqMRHUU6mPDXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ax3UegfhuWDZfhkv+C243hxeX5RjbsFkTPMTU2MCUZuwB2gaIQ30/L/aindh5xpW5aJD0mJuDh8bgZtyiFOZavVACHD0YgPvSMm7ZuLET/K01CaUXnPpQHDmJinpY8R5BjujsrVOIS4n9bDfZNNUQaXHB8yz5QdeVAK70xwkcNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKr6qUSF; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKr6qUSF"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899ee491af3so33450366d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 19:20:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773454838; cv=none;
        d=google.com; s=arc-20240605;
        b=RXzPHcbtitkbxrQIFUoZ/TRCUupvof5rUkWP0b9D8SgqG8mbMg8xbCkjrb/IRXkbdb
         rde9DVR7Ad4ua/J1sILLQfaY6Vnnqkwx5lpY7Ybqa5iw0tLVowgUPajmu6jR+hjLs4dz
         btHmBZXBXYafi02Zobn8YbdzUAj6w01JLZWVV292ZoXTweCk76Vv+avuNO47OcYjyYmw
         45iVnNqjyQGW16MvPwH7rrhk9o+x3JEtfAViHb3QPQiYieA3XE+JNBdsbNdaPn/ohNMn
         wedigVEy7ulNoAwpI5yvA3A4N/xRHxf/Z7gUJstuRXsI48rK7RGFmuOxy+ZljIO3nhSd
         r11A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ditbEY4Rl2l5oC5HDC28rMAUb8wx4HWclIDbLpcmS2o=;
        fh=kNURej2V95DFkobxZdd9zp5Hii4rlRu4Jg47tMWrCtU=;
        b=eYIAX9eDwHmjxXy9phrV8FGTCPOvG3yoDfcYyhxl0Ed2I8lMk79dQRKymShiCrp9Qf
         hd/+Y2Ik6Ebwyvf+P6yFTVmX09/7rT0TUHVa1EgWsunGKSYyJCGfUCQTu85njGkeXMuT
         5GiGZ3hWINvVZuKjPi5hssNYEIHoGlxBVXqbm5WzY9+DU+2wbCkU6WuoS7czovXosDUl
         4l2vRv+bezW8zCTQ2N7y6CauraxrEwaberTfHKxymx+Mf+nO3tKfnICu85INeN7GcrNM
         95n45Mrq9qDRwMtxtCUEVcVRIRq1R4MMXlKVTxD1M0bBpvLGei0LJtDGF9cDMIR+mpA2
         xTdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773454838; x=1774059638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ditbEY4Rl2l5oC5HDC28rMAUb8wx4HWclIDbLpcmS2o=;
        b=FKr6qUSFLhAWV8gH3auF/8e80HgQTTuDykzPeR/oHTPLHwjvcjlsrb64xTT3Q9TZaG
         fEjPnsHlZESSOgkpEqcpQF3D1Uw4lSBKnnbAemXG47YdcGTIZx1/GnqsFyLjzGH+HBxS
         kRvXltBTEJ5RF4WpQsQcYpxbXwCafhuLD5LZoWtBvzjMnDWUh//wL4Ru5zgPPQ2xEQ0u
         Z/ul48V4EywAGagoz00zfHSSljh7wSOsaA6mHBlsJcDPjTqW22J6rSQdmXj8frbvXnjr
         T6rnJj+yY4qYai1525Ul6JJMm5twZ5UgQcqXHDE+Ywf6X1Lfwj2Z3+tgIaScRS4BbSwM
         nhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773454838; x=1774059638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ditbEY4Rl2l5oC5HDC28rMAUb8wx4HWclIDbLpcmS2o=;
        b=kI0/5QC1mRg/Qj9PBfaTYlSOkDuubrmImEVbrQcQ0Ra3FxrznjPvPpmOCeYFfNiXec
         mzLWhNzSI5rd+hbERhNlr1qv0v5IG8Fiv7Tq+iKaxdQWZuSpsFcX9gDTjmYmlFXsb9Qv
         A5eJYtghrDzIukdcLZqdZmB5taPa9id5A+LpvcIa9ERG0p4RTBoNGigBE2ocqbDe/OgR
         Le4TzUf54+Ib4b/5j8o/XQVGujJBiIpaTseGoLykrg0OTLPU5PcT0Kt8Yw6vx8CuSPeC
         kauNq+zF+uDDE2D5i5IBDkRov4dTQe7h1LkA06SbUtMgfn2fN5astE+g05i+S7atNWMr
         YjeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVibPUPS4myULtdfR67ddQwLyGu+gOi2Zn+4nJ/pN5T1ox8BUmzkHOngc6ZxGkO9KCGVCnF0dx3rxxm@vger.kernel.org
X-Gm-Message-State: AOJu0YxbaROmAHSD3nRt3/glpImM4kZ9rBbHegFm80oEVhzOSlW3Ryb2
	wMaG8hcc96HMzNB30LDWWxWxpDyuZlf1TZv+tqt0C128zNj4kSfzBxhjASAEehqySzLFfCyf4yl
	qp1HlWEXetIW5TQGmNv6vPvQ/PTibVts=
X-Gm-Gg: ATEYQzxjRldpF+NNldRvrJgaLtG/1l857QQidLOZcD1AdorQWZ7/+crNGvutFSsUQsy
	maZrkopZVg+GTdj6CO++mYB/qW9MTNTA5v0qaLHiuCNAx0oWK7EyOjihfJ9uKUsCzifeiQyq16J
	H+BBalFRWn0p6IzT6XBqVwt0b0xvCRElGw5xmvhEGz0HC551d34mdQLzW4Mj71FCj3qiUfxNLDG
	+LJKI6ROB3DoXC0imbmG9zPxcukv5UCW+ecMQUqdjAM9JyJn9ULEHIO2N/erbvhbBj/ZnTHYLPx
	058dHJRP3J6AzZKP7v84D+eTRJRtlH9NxGjVFC8tAKCzYQoHA6tdOGcLtk4y6GDlD5uj4SFap8/
	xKX0enouxpa+VHt6ejvK3eM3nlmmdwUxE5TjEl33Oz1SaMdVrVwwalRjQx6pXSM9QFlq+YZBTEV
	t0ab7900gj+h35gaQhv9t6
X-Received: by 2002:a05:6214:daa:b0:899:fd8c:55c3 with SMTP id
 6a1803df08f44-89a81d5dc51mr84030196d6.22.1773454837743; Fri, 13 Mar 2026
 19:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260313034027.933719-1-pc@manguebit.org>
In-Reply-To: <20260313034027.933719-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 13 Mar 2026 21:20:26 -0500
X-Gm-Features: AaiRm52Dy-1e-FsV94mLe3dvkqcJC6jhGeQ2Y47QDtUq_0BpJcu23ZXgPmm-eRk
Message-ID: <CAH2r5msVE8d5DKM+E06n-LVVBOiJyRmJ_pfSD7Ksa7PTkZm60A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix krb5 mount with username option
To: Paulo Alcantara <pc@manguebit.org>
Cc: Oscar Santos <ossantos@redhat.com>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

applied v2 of the patch to cifs-2.6.git for-next

good catch

On Thu, Mar 12, 2026 at 10:40=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> Customer reported that some of their krb5 mounts were failing against
> a single server as the client was trying to mount the shares with
> wrong credentials.  It turned out the client was reusing SMB session
> from first mount to try mounting the other shares, even though a
> different username=3D option had been specified to the other mounts.
>
> By using username mount option along with sec=3Dkrb5 to search for
> principals from keytab is supported by cifs.upcall(8) since
> cifs-utils-4.8.  So fix this by matching username mount option in
> match_session() even with Kerberos.
>
> For example, the second mount below should fail with -ENOKEY as there
> is no 'foobar' principal in keytab (/etc/krb5.keytab).  The client
> ends up reusing SMB session from first mount to perform the second
> one, which is wrong.
>
> ```
> $ ktutil
> ktutil:  add_entry -password -p testuser -k 1 -e aes256-cts
> Password for testuser@ZELDA.TEST:
> ktutil:  write_kt /etc/krb5.keytab
> ktutil:  quit
> $ klist -ke
> Keytab name: FILE:/etc/krb5.keytab
> KVNO Principal
>  ---- ----------------------------------------------------------------
>    1 testuser@ZELDA.TEST (aes256-cts-hmac-sha1-96)
> $ mount.cifs //w22-root2/scratch /mnt/1 -o sec=3Dkrb5,username=3Dtestuser
> $ mount.cifs //w22-root2/scratch /mnt/2 -o sec=3Dkrb5,username=3Dfoobar
> $ mount -t cifs | grep -Po 'username=3D\K\w+'
> testuser
> testuser
> ```
>
> Reported-by: Oscar Santos <ossantos@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/connect.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 3bad2c5c523d..8573d5c5235b 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1955,6 +1955,11 @@ static int match_session(struct cifs_ses *ses,
>         case Kerberos:
>                 if (!uid_eq(ctx->cred_uid, ses->cred_uid))
>                         return 0;
> +               if (ctx->username &&
> +                   (!ses->user_name ||
> +                    strncmp(ses->user_name, ctx->username,
> +                            CIFS_MAX_USERNAME_LEN)))
> +                       return 0;
>                 break;
>         case NTLMv2:
>         case RawNTLMSSP:
> --
> 2.53.0
>


--=20
Thanks,

Steve
