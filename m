Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFF533030B
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760979610; cv=none; b=H9PGtE/h/+OUFM6yXh3eygO26lpV+PYxatXkJWeI+31eDGPXGMBvl+VDh2v2yQlR2L18mLgf/10wO/T5q6Yn+8OnMQlFAoVNgx29NosnamCY4ji451Fjxq/qdk6A0RtJUwYkLUeV/x/CwiNpCgRG895EnuhkJDG2xdiy+8qd9lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760979610; c=relaxed/simple;
	bh=EXc0jOYLRmr/3jRYSk2fLCR4EdRJhtPN83IRY/bFlt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MUJuWuD7x1mV7jio5O9i6/Oh8fRPxhP1AS8duxjYV7L6ew9GhYaT/NbWG3fjIjQUAXAmfJXlMU3XBu7DHl20qIOsTBhrnPQVXkK0IPxriA8MFnFOTMmL9b3KYVBAeJtXmiWH3tdczBm2bEo8UwPP+IpjuRyeUs5Hda8BU8RPSJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QIW234R9; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIW234R9"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-81efcad9c90so84393526d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 10:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760979607; x=1761584407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4RSN4YFTB3br2+B3ySD6exiSoPsxEwCTC80by1DxrCk=;
        b=QIW234R9WrrlKJk2HVXisGbrYjBI/eH9cDZ6nuGqUJb351Dw9HZMBHEWsS0MhTrkRk
         yl87JgGgm6rlD/1yygbS30JSKHQ/6z07pgw/4HxYa4TfOwXcgSS4qqVZO7F33j3IFG9b
         b0p22vkt/1RGvQt4WwxJI80tKU9I0tQhTUVyAsvc5IazWbvRl4LqkJZCyeakz5DwLzg0
         j8RncyqIdyh5eUWp04kAy1pV71aDeGRTVHw5gZxfXeWNAuk+GsL0OhCu4gylJtZfXNlI
         ty4l/DrsXepycl2SgRP8hC2kIqc86eYHioc79PuPoy5csO+El7od88krnQtlRk+lc3Ba
         bqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760979607; x=1761584407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4RSN4YFTB3br2+B3ySD6exiSoPsxEwCTC80by1DxrCk=;
        b=f69lFZFg3YxP3esMTVLCmyF5H4+LB+iRLmhjQdwzv52m4V1PrdPFUujmET6e68gUHP
         Vyzq4WInyKBspyV0Lj65OzxvV5OIh6pGbnnP4Kzj8oCRgYDPrBTYVm0IHLbB5uUBmv/6
         aLFi5AplM4pQLW66uBXipJ9hmdmKNLCTZ5rNlxAJypfdKt7yeV+RemNFZDnoxZx0d1z2
         pbSzfojZsCXeLjEVZaUvqaVq5Ex0i1XYW9mrtcuudalU7Bk+LSr9JWj14ha0N2bUbCQJ
         Dilw/PRi4qhRawwuU8wU7Z5GHS9tG1YyhT9gi1bp2XQDKbp6wpGYu/AKH1qH+kywAcGa
         vjqQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8OfIiU+m57urHLwFIkQCQ9ATNpa1SyVjSnh+O4/jojBFGUlcTu3JRkgMNv4z6EoUe18xIilCojn9z@vger.kernel.org
X-Gm-Message-State: AOJu0YzMtqawAd06k/mCouXyJ5B6VFx+bRQZLtCdaDtJBKSWyktAj+3J
	hLLM+Y3PN2zYNMJzC0UDkXQEF0thSKZ+Krxbdq2Zk3QioS3OLYa30ASlu3E+cvYoKeTDNEkMynf
	e//d15PD5zGwtDY5r/86I6w6JL9LbPBA=
X-Gm-Gg: ASbGncsOqb1Lk3U4E4k573gscw9JAPpRGNBbIAQcwfzswn/UoaJyaipRf1Bj58hENu4
	HLKWF4FBDcl/iQeFN5x5PuQ8Micxj/zJT97QpPFuEa9/n7L9fAcMHaxa4CNRjWlLTLxjdpXQ1bM
	vH9tTlEh/gboOmcvHXSUswwdgY5EpHYPUFQk6RPmDn5eLHRHm97Y8CEPhYMwHWZoTsAxAubV0/6
	KTiqcha5Jb3z9EmQzYPeeGpObw8GojMKsQ4MsMESR/ytbQGGADAkHM8PyjqqETcCfxz4CRcoe0u
	P/DHXDVcPafVpGfd5274yvhxtz6pWtUTi7EQjFNgcQrkEO+folzfhieKPnQb4UBZywlymnNVLQ2
	ZiMG0tmA1c2PgIMJTMBmEx7DPRyXwad6/69wIoSwjs6XQaB9P5b9lrowzzNAkcnpbUlBxlKdaHv
	4=
X-Google-Smtp-Source: AGHT+IFHQ5iz8/Saro2LRp+bwSIlhkAJVCK9/l8+MswododraUp4Qz/LXmzQtrn4f2pjW8VxdwrV1XzKCjcqyAUk8lg=
X-Received: by 2002:ad4:5cea:0:b0:86b:4ffa:a8b2 with SMTP id
 6a1803df08f44-87c20576935mr170951986d6.22.1760979607465; Mon, 20 Oct 2025
 10:00:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1039410.1760951767@warthog.procyon.org.uk>
In-Reply-To: <1039410.1760951767@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Mon, 20 Oct 2025 11:59:56 -0500
X-Gm-Features: AS18NWB_wm78_JKAnPCw2RD98jnwlVQ7_i0H__VeQ2TBjimWfb0DUiLikj1O_Qg
Message-ID: <CAH2r5mtLDTExHRhbr3yyK1Jm1Azq8PyN_TkWsf3gyEWVhybrnw@mail.gmail.com>
Subject: Re: [PATCH] cifs: #include cifsglob.h before trace.h to allow structs
 in tracepoints
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you have patches in process that will depend on this?

On Mon, Oct 20, 2025 at 4:16=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
>
> Make cifs #include cifsglob.h in advance of #including trace.h so that th=
e
> structures defined in cifsglob.h can be accessed directly by the cifs
> tracepoints rather than the callers having to manually pass in the bits a=
nd
> pieces.
>
> This should allow the tracepoints to be made more efficient to use as wel=
l
> as easier to read in the code.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Steve French <sfrench@samba.org>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/smb/client/cifsproto.h |    1 +
>  fs/smb/client/trace.c     |    1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 07dc4d766192..4ef6459de564 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -9,6 +9,7 @@
>  #define _CIFSPROTO_H
>  #include <linux/nls.h>
>  #include <linux/ctype.h>
> +#include "cifsglob.h"
>  #include "trace.h"
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  #include "dfs_cache.h"
> diff --git a/fs/smb/client/trace.c b/fs/smb/client/trace.c
> index 465483787193..16b0e719731f 100644
> --- a/fs/smb/client/trace.c
> +++ b/fs/smb/client/trace.c
> @@ -4,5 +4,6 @@
>   *
>   *   Author(s): Steve French <stfrench@microsoft.com>
>   */
> +#include "cifsglob.h"
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>
>


--=20
Thanks,

Steve
