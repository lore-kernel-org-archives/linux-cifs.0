Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8548B2EC0AE
	for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 12:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769601919; cv=pass; b=fH5xmDKKdFGN/omSVFh0W2eo+ZmtMij6r0ybKGVA86/8LmImk46MeDSmqd8oeCfPHn9Tk91Fwxp+Bx+lUmnaM0nbWdQCi2LmbSum6RhP9RFDIXTOngE1cu+y+xlLzguDtTBlV2OGI/z9gdQ2djec4P4dnfYODvEMYPp7hQ9hXJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769601919; c=relaxed/simple;
	bh=Xet+zqbR0Q7vYaJKQH3HoB47fDZ/6aYTsw4IUv2RXb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LCI+4Oi4qzxSoBZKZt+ZlS8ODg1nunsNNIfZH671HiVxjguP5dyJm8VP59/25vSsNfJ2Xn3+N8j+HjwyA8G3cufcwsgCUXYpPQy3Oa4BSt5MY95xehV9Uop+jdwx5S3rdff4IO6Jj5MSP20S6O65VUhq9qHDOiqMbg3BUYB8Xgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c43XgAf3; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c43XgAf3"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-658078d6655so13444664a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 04:05:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769601916; cv=none;
        d=google.com; s=arc-20240605;
        b=cMjtQzcthV+yRAKyqlxbqW/26lGpWiwlHQ1WNqANNZJrKlgknqmB3kBMNU7tWX5AvC
         D8dY6A77ZNVTaEit7/tjMc+qGaRYxS4Mp4o2SyYEbJSqrufznm/ip24fgP8HD2omKfla
         8ontuhkuuxtvKkiBiTTJnmOMuKmIhByhZzYD/TO4q7/nL3Lw4k6QCeY7FCwkiWsz+u97
         5LBueAHcFxjje2b6NDusj8Cod4nqjo79TMhFXub8c9YiQJcpOwH0AB0EgmUbzIzdXQ3q
         GORzS6a9VHG3YBNpamRvqj5O+ulj6RyUXTW24TEujGp7GcLMm1yiRc9DZTPP3oFr0OXn
         5Z3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fMv/EpiNb0nG8pWat35ocJtDPRMc86TRqcWBpckrYKs=;
        fh=MI7qOEP8zHbFGp8RlubuOwC54SNvw2fEJj/AlfixDDA=;
        b=S1G4ReDrMyOpAHBGwspeQO4RmhBdGSM4vdoFDHOZJaWpUI2PB+PWAV8qtAyZWIECJD
         f3WMNru11VLAWb56VZtJcG+qAHACx+teFq38T2hL/CLztzBsQipEDO/TSQ1zPCct2CY4
         ndFtKGEY5eKKJJSN1eQBJsl9pY8JBwPYhaqqTD3kvdqjTPjhXuLaNhRNoQQtWxfuoTNi
         G22lHjpQRPvGXRyb7uJFx6LnlAyWtWmw/eCzcsc/KqVtCKlL55wpf5m3HzkgJSISYaHq
         vtUEOTAn3DOeARbzGdRitEtoS3a5fMi7yT6Y/HlMQdXbeqtliz1ueQ3RCjUAfVy4IVsF
         H5cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769601916; x=1770206716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMv/EpiNb0nG8pWat35ocJtDPRMc86TRqcWBpckrYKs=;
        b=c43XgAf3xZ8ImZPjJ7Z92zeKrJIuIiJeQUG33yNiphgB2o5U7KKwQ24AHSBLel8KBs
         iPp2Q4nBCMJ81tMS+QjXHyUWRRkXTAFaTurUbFdYAmqunjVn3sSY3E5g3b3tW4jl0tJc
         HaA+Wh3HFOAnVGdkpfoX1l9XoXHpsvQgHHHDj+gxJr7sGFwLmFo7wE+oGeVTQ+2XJKSg
         Sz1ZDEd/qyF2yEjSQhGdju+/7oXwua/NcenvcplJJ6jF+a4NYB0Ur3IRdvx6sLEtXJED
         ohT3XMej9exyBCW6aN9yi862tq+okfqYORj/57lvVY0cBlFEbCq/zd9tR8r0WCCBJUfd
         zPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769601916; x=1770206716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fMv/EpiNb0nG8pWat35ocJtDPRMc86TRqcWBpckrYKs=;
        b=c5BQsQFSElgEaX6fmftffP4jc/CBAhSis5vIsU8TIeE4e359gwIe9nPlKTv2WedAFN
         U8Hodsf45tF9Q9nhsh4pYYRs8d4GsCRc/3q35c9pjwkyaAs3EelGTCi+0vodUZqg0EDT
         n8HtaNk+h/n95nJSkwLTAjDUPAW8+rlLSIi5LOj613j01KJ5ngNn3yPnm3FbDNPpGdp/
         6ew9Vasf7lno0bhtJRchyCqZPRhUu/RqDbjPtWGFdh/Eqhy64zn9my92Ei8/VRyjDFDN
         el9J6P2sRi4MWWq3MknkGGdp1V/o0jAcmvRfbdp/M1ryjXGxlpJ646p7ICUeSE6nThmC
         q49Q==
X-Forwarded-Encrypted: i=1; AJvYcCWl9QOhqphq2is2OYUyquPLIok7BWOTquBemOEz8TBYWLzR62zTqq2F95ZhvtZ8Qmjkc+d6f80FD0+G@vger.kernel.org
X-Gm-Message-State: AOJu0Yzam0guOxv8xNIWboGK0ZKeUqP520/Qe61MLZjSkJEl73/ninom
	mR94ntzLn10OCXedm+AzFxMaW+Dlz0Z91I8xfKD/NQu+NFRgUZrnThvSqnZxBpkdXeTfrsFukgI
	G3N55s00kXxA1S3n0h02GkuLA9zqsD18=
X-Gm-Gg: AZuq6aIwiZ3YayWEo5HaHqiBDpmURc2ZA2FeEAKzZZHNO5GF77KTDRiJOC66H+VC/j5
	xuj+OTm9uViH0gsDnOi9y7o6gjM9jJUoaQnCRIV0oGjD5aMnzFmNCE2UDLY4DmAFgAJdmrivD1E
	Td13oA6rBWnFhJkDGIXsri/j8u5o+h2JCHk7WP78GVJuGVakn3ZX7gMnYlSgSWRodOm2OxL4IT9
	cp8cGaurxUE9kMmDkdBxPT7IhSfDbfkiOPbaetjvTKTJKMvQORfYorl3VnjyfrE0bAFtJFKo8qb
	oaC/
X-Received: by 2002:a17:907:3e8d:b0:b87:7485:b4bf with SMTP id
 a640c23a62f3a-b8daae2888dmr325993866b.0.1769601915559; Wed, 28 Jan 2026
 04:05:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120201822.2218308-1-henrique.carvalho@suse.com>
In-Reply-To: <20260120201822.2218308-1-henrique.carvalho@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 28 Jan 2026 17:35:02 +0530
X-Gm-Features: AZwV_Qh-ZyGYcPzAIbwAqp1woKw6N3_UThv2o_MKFnK8i8L-jjWGry-fQEUI7mY
Message-ID: <CANT5p=rWExftaNObvdueWpL97C0CEAUzx5G6cwKrd6ZhfjNRnw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix cifs_pick_channel when channels are
 equally loaded
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 8:13=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> cifs_pick_channel uses (start % chan_count) when channels are equally
> loaded, but that can return a channel that failed the eligibility
> checks.
>
> Drop the fallback and return the scan-selected channel instead. If none
> is eligible, keep the existing behavior of using the primary channel.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/transport.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 75697f6d2566..26987f261850 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -807,11 +807,16 @@ cifs_cancelled_callback(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
>  }
>
>  /*
> - * Return a channel (master if none) of @ses that can be used to send
> - * regular requests.
> + * cifs_pick_channel - pick an eligible channel for network operations
>   *
> - * If we are currently binding a new channel (negprot/sess.setup),
> - * return the new incomplete channel.
> + * @ses: session reference
> + *
> + * Select an eligible channel (not terminating and not marked as needing
> + * reconnect), preferring the least loaded one. If no eligible channel i=
s
> + * found, fall back to the primary channel (index 0).
> + *
> + * Return: TCP_Server_Info pointer for the chosen channel, or NULL if @s=
es is
> + * NULL.
>   */
>  struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
>  {
> @@ -850,10 +855,6 @@ struct TCP_Server_Info *cifs_pick_channel(struct cif=
s_ses *ses)
>                         max_in_flight =3D server->in_flight;
>         }
>
> -       /* if all channels are equally loaded, fall back to round-robin *=
/
> -       if (min_in_flight =3D=3D max_in_flight)
> -               index =3D (uint)start % ses->chan_count;
> -
>         server =3D ses->chans[index].server;
>         spin_unlock(&ses->chan_lock);
>
> --
> 2.50.1
>
>

Had a discussion with Henrique in another email (couldn't find this
one initially).
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

--=20
Regards,
Shyam
