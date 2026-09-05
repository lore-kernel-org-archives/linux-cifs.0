Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE88326945
	for <linux-cifs@vger.kernel.org>; Sat,  5 Sep 2026 01:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788570952; cv=none; b=SGNquuw5feG5fgZPH7f95TzMKZket8ic4jgRKfgnUX1tLPr6SVl3O0m/7B/uFsmcYgyfHhrwcowIlcUwox2I43iAVvGZ6yEZqYbbjJatTVbBLr0NYwR27D2iIScGtm0ytuHlZNuZ42FU1QlL+iOvbdrs2g6j/XLkEwwblZmUTzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788570952; c=relaxed/simple;
	bh=8vBOD3iAA3Gcnq0ytm70An3cQqaSF2NQ9pZmWAH730Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H79QsgCd5Ti0xZwtVx/ldSsSteFK2yvyVbTM2hDuOOfu88vPW6HRHZKqUjJS7g7yoZ3hUnd4ulC52fmJuBU2qpc5wnIV1biHpjZEXS1QD4zDKJpiFbp8rOPDuY8ERQJgv85IO+QnR8yJsKCNQb7G33B5WMEnjAqaoLmXW8BuVpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OH8zvEvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OH8zvEvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB4D1F00ACA
	for <linux-cifs@vger.kernel.org>; Sat,  5 Sep 2026 01:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788570951;
	bh=wnqQejRb8zTN61yNVlvFHsGj5tl1v37bsmIXzCAkc7s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OH8zvEvR++KBfxOgVyaH/HfI3yuPPtRvk2jQdDrUxoK0D1YVQE6QoOKYmraE8JGsw
	 onB+TdVdONRNPac8c0RNj0XR8IyTBI46SpH1Tx8ipt8LoR3Wj9+SdEVvUQGEwihvzj
	 OBF0iEFcfADsuZLse3eDqjmkheBpq4TfKJrKQDGGgkfjfGYpEiOWvwrY2CxyeXHO0i
	 ccbXMCkV6lqhPjcoyrrNW56+9m5C/yhktd6cZe4ug802cs0cuAhdcA0nwLc6zjku8d
	 anTSlD4lx1VNColDPDVxDrjDD2acZDxGAdO0DNL2clDLI3xi43yBZACcd7dPy9P31a
	 Nr+G11DaWqhsQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c160420289bso195158366b.0
        for <linux-cifs@vger.kernel.org>; Fri, 04 Sep 2026 18:15:51 -0700 (PDT)
X-Gm-Message-State: AFuF++kKasOnzcxNp159OYADi71pY3Cp/BebzLmNrxUzMwtkmB2Y6YuK
	ROmKLwlw+o1p/FZLw8vFeO6M4M2ocZttWJaY7CZ/7cnV9xSdr2OgpnsaOh3dJFIvTTQt3r0e05f
	RF2ESLpgj0hxZA7tzQgDwFcYAq5XeouQ=
X-Received: by 2002:a17:907:7290:b0:c08:417e:3696 with SMTP id
 a640c23a62f3a-c260ca459c9mr606304266b.20.1788570950084; Fri, 04 Sep 2026
 18:15:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709155440.2132459-1-doebel@amazon.de> <20260904125844.1803343-1-doebel@amazon.de>
In-Reply-To: <20260904125844.1803343-1-doebel@amazon.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 5 Sep 2026 10:15:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8r-zvLH6Ecxu33jDAjM_6Uv2KFS4Naa-tYFHAwntgreQ@mail.gmail.com>
X-Gm-Features: AcwNN1XLMLJc8HxJFK5Dl37fhlyCCd4jZbYJRtiT9fYiNdk5XrcPZmADDZ7vkb4
Message-ID: <CAKYAXd8r-zvLH6Ecxu33jDAjM_6Uv2KFS4Naa-tYFHAwntgreQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix heap overflow in DACL owner/group rewrite
To: Bjoern Doebel <doebel@amazon.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	samba-technical@lists.samba.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -1815,11 +1815,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
>                                 cifs_put_tlink(tlink);
>                                 return rc;
>                         }
> -                       if (mode_from_sid)
> -                               nsecdesclen +=
> -                                       le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
> -                       else /* cifsacl */
> -                               nsecdesclen += le16_to_cpu(dacl_ptr->size);
> +                       /*
> +                        * Worst case: every ACE is rewritten with a new SID of
> +                        * SID_MAX_SUB_AUTHORITIES sub-auths -> sizeof(smb_ace) each,
> +                        * plus the smb_acl header replace_sids_and_copy_aces() emits.
Since you mentioned replace_sids_and_copy_aces(), please check whether
replace_sids_and_copy_aces() also has a potential overflow issue.

So for this patch,
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Plus, there is a checkpatch warning from this patch.
WARNING: Unknown commit id '5c3564852c58', maybe rebased or not pulled?
#78:
Fixes: 5c3564852c58 ("cifs: Minimize the number of cifs_acl memory allocations")
total: 0 errors, 1 warnings, 18 lines checked

Thanks.
