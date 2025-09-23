Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E64326FD9B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644196; cv=none; b=bVySUs7mnSExr30beONmpJDveUVCrk+5QkIPQeZX6IK5WyuWuIoY1XEVXD9ldM8KlsYUyibGu9ankOiL+mZ5pySnanGvTbkRFBD0Ucg700aPe4OOuYhnGB/435DlSzNZI20lHG6xyMtHnMbIeQAOvPwCdao4q8bmBifnokkoIBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644196; c=relaxed/simple;
	bh=01h131GEes9ZShcFBHBPA2gaR+HNq+JOCWb1zU/gnIU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=CF8Z9tE7bcYGnTMV7FjVFARwvvjQO5D56Bq4uudtvDJcvkd6QwbVvxAbR40mcgL1zQ64rtPjg4VfPyXGHBtVWR8i+9T4uCc318QwVpNPn0sXwzfq87EsWhpCqpDlElL4e6WU73VqpVZRk8+CPpbwkYIQxNBDxWuM4VFxoxATQTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=9CTaKalp; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="9CTaKalp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T+vKlFVN4+1DE8PNHPCVDUcMZnYz4vxKWS+rIiitbwo=; b=9CTaKalpfEVD7CHhL7jR3nPD5J
	uJBBsCs+/xyca3pDygZgGYQX3NPAXR0QQczi09bdvQhYbFVU9RVtm2GMUFZ3kJ6dEG4rb6h8gh0PK
	3KP+xEVx/nSJgHqtrsnA4qv/kcwnACuJ57n9+MWFicEGHxKVsLN6YZ4rJEBZnOWX812NitjJD/rpU
	AZntlpkKsXewGHOL5TjAM0/x3gO3a84q1kqa+2HdTJ5nOWzzLqjyXGdfTKzhFZEvKlm4QEHMbiB4H
	qrzTTYm2vR+AK/V/UWm+bTMjONkoUQ4HJCjKocQES7UOG4vwBho1bgWmzfYRXtrYeIMZ6bl7VIfWV
	1a6x1qlA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v15gm-00000000Bgt-1kzL;
	Tue, 23 Sep 2025 13:16:25 -0300
Message-ID: <fa97b6eadd270511dddb268cbe9ef777@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>, sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: Re: [PATCH] smb: client: fix wrong index reference in
 smb2_compound_op()
In-Reply-To: <20250923081645.269534-1-ekffu200098@gmail.com>
References: <20250923081645.269534-1-ekffu200098@gmail.com>
Date: Tue, 23 Sep 2025 13:16:25 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sang-Heon Jeon <ekffu200098@gmail.com> writes:

> In smb2_compound_op(), the loop that processes each command's response
> uses wrong indices when accessing response bufferes.
>
> This incorrect indexing leads to improper handling of command results.
> Also, if incorrectly computed index is greather than or equal to
> MAX_COMPOUND, it can cause out-of-bounds accesses.
>
> Fixes: 3681c74d342d ("smb: client: handle lack of EA support in smb2_query_path_info()") # 6.14
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> I was unable to reproduce this issue in my environment, but the code
> flow clearly looks like typo error. I have not added stable cc-ing yet,
> leaving it to the reviewers' judgment, but IMHO i think it should be needed.
>
> I would be happy to help with testing if anyone can provide reproduction
> steps or additional help on triggering this code path. Always thanks for
> your consideration.
> ---
>  fs/smb/client/smb2inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Nice catch!

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
