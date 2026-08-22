Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1633C1D62
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787395531; cv=none; b=bp3BAg2JtUcmhKZdEeATSw3CUo/tcORSQPS0zZt3vlai8h46WIvy//MVKUmQ9s2y0ouFM9MO0tVzWp0NDZoKKu0FJ+ArbkyCUmN58lD1c9AwfuJ9OCCuY3nmncvAn2weN+P31veUCqCb7qhhoG3M6Q6DyRCTgTeyWHwbPtMzwG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787395531; c=relaxed/simple;
	bh=SA9YI/0lZ0vaLyK0geOCgau7AUUjlHK70+wxx3CZlco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lLylYoQ1LO2FkWtaVz+lRWIkjnan9AQubFck8V645TPENsRuVhIuhDjYuSOts1CPrW6tRT3byfP4HzhiaIal1Y28E/heI5SygJiXv0BNZQhajVsmlH1Cv5rrYySnLl+visncTLDTisb7hvnrtdyPE/mLD+PnMcXyDlieKTxHDp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rvu9n80F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rvu9n80F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3801F00A3D
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787395528;
	bh=RdvjQyZKwewCPeWayklU3iGh3k6jn4If1Cy/L8wfOlM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Rvu9n80FdyWroYrY51crj5WVjSo5eD0S6a5X+KcG3ij8iqMXvOLsJvCTHdZaYLJqN
	 N3nvULxH8MUmmP9iP2/+WkvXRTEHL3J/YMs9UlBbEsaF/a1G+FBF30iCpklRzw5urp
	 u2+JHIaoWvxaqkcWXIqVqM47/aLT2olj9F1+k2f7EhhQLJ48QkIcvdueIa5pLLg1bD
	 JxDMJrepEmRpBqJPSBJhVZbgzqmX7cXCzEDTFtsKizHqYGi/8f83uR82MwgqAdSTAw
	 z+PXJ9SE44GiQTRy9FtHcSTizm9br+WFKLPJQF5e9w5hJfRUtWtmGLS0ZtOWqIcJoB
	 +sGNVtPtjM2zw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15b1da6b82so198948366b.1
        for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 03:45:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrJ7MSxjxSAAJZwNJfewoUncs/VMCc8x4vzHR/YbV3xIhsiUGk/YqTzGc3ZlMDieyr31/Q3GuBfc/Uc@vger.kernel.org
X-Gm-Message-State: AFuF++l/RCxn/0WPGNKJjFaiwEB5GgefnnLcPf2fzPNLOy9w3nBOLfHx
	acQ0DNwLwFVxDlOgDHKzyCXlJnK9ZOHE10wnQHufuVyuDyULpMMioGqT68jzbTUmdqLQWWAQvYs
	fKQywOjOM2V4CS70YKRznoGSowJzRrGo=
X-Received: by 2002:a17:907:c20:b0:c15:f4bb:e663 with SMTP id
 a640c23a62f3a-c246a3ab3dfmr1353710666b.10.1787395526782; Sat, 22 Aug 2026
 03:45:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820071526.826926-1-huiwen.he@linux.dev> <20260820071526.826926-7-huiwen.he@linux.dev>
In-Reply-To: <20260820071526.826926-7-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 22 Aug 2026 19:45:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Fe5EUYjmf9dp-aHw55YpaxuiKwZibcx8ePQYkJ+E0=Q@mail.gmail.com>
X-Gm-Features: AcwNN1Xr5wZSP6rHOcd7rIdw9aEHvATcxOrNoQyKa8Zh8nSG27E5No2IzzKPQlk
Message-ID: <CAKYAXd9Fe5EUYjmf9dp-aHw55YpaxuiKwZibcx8ePQYkJ+E0=Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] smb/client: fix stale page cache in
 insert/collapse range
To: Huiwen He <huiwen.he@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -4107,11 +4117,20 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
>                 goto out;
>
>         filemap_invalidate_lock(inode->i_mapping);
> -       rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
> +       rc = filemap_write_and_wait_range(inode->i_mapping,
> +                                         round_down(off, PAGE_SIZE),
> +                                         old_eof - 1);
>         if (rc < 0)
>                 goto out_2;
> -       truncate_pagecache_range(inode, off, old_eof);
>         netfs_wait_for_outstanding_io(inode);
> +       /*
> +        * Invalidate cached folios from the page containing off to EOF before
> +        * moving data on the server, so subsequent reads do not see stale data.
> +        */
> +       rc = invalidate_inode_pages2_range(inode->i_mapping,
> +                                          off >> PAGE_SHIFT, -1);
> +       if (rc < 0)
> +               goto out_2;
Could we also invalidate the fscache ? If yes, we need to check
collapse range, zero range and punch hole as well.
