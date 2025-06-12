Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207EE10957
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 03:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749698798; cv=none; b=GnE9WwCHn4FLWhvhuPJQzEdt/lDRyYWyeG2//P+XdJDdb5B80qvbQL8q4uwNErARaQ0zwcHvllUlKHvbMiORGJO6dxAYcLcdQwISTefTKKVqByzNi7tc+wg6PRQ6wtZx9NtLOOqDKabi2DIsaKsHMrE+gj/KAeztA63nlYhBo/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749698798; c=relaxed/simple;
	bh=a79qoluoy1srk151sjKF3ZJYIeFU5H1W4VrjbSvhIEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czUk98GFhZJ6dBiGgqmri6TlvyEv9l/oVfc+3J0l8q3XL3f+YJ4QWtqV+k+mZ+2WFoxMLCsYL4GbsrxWGaCh7YgVbQ/zuk5hOaCxtC4Cugnv7/pawPkgpEKyGg9czNuqJxzM9gg5YqTkPBFgVpdQETIMnJ8lR468OTkebY+dfEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=5d6xbEy+; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=s/H+Xz4h; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="5d6xbEy+";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="s/H+Xz4h"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1749698669; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=vsa2CuuEm4AyAqI7a1Qurdo+dQWvL4EXfFXRtNM5698=;
 b=5d6xbEy+aEM+V3Lq/fPEBMjMHJPeEzb1poknr9Oa78L2T/vpz8Mk/ma1/0sqM1N717Djq
 VPlD6fYVAe7EMFbDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1749698669; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=vsa2CuuEm4AyAqI7a1Qurdo+dQWvL4EXfFXRtNM5698=;
 b=s/H+Xz4hAr6m8ct0bnszYgtQgOHTcobKAzRvDO65j9habzvFGSdAB5mIbQd/VNlxyjddi
 Kx1xKO8sM5K2XNKKoNP/sRFM5S67kO92THsVS6fMVV3nOukqtVfXAe12smFCIUWYCGFxIni
 31SPYtiWRWHUIm91zFOoZ9LPCkZCzavjbOXDOeUTw9E3O7lvIsFAqPDmYsnZnHW3TXNjkfC
 mPfJ2MQF4rAIQVvvU8TN8KLNhAYFObzVLwfoIlwHNLGBq1hyR+tMmCTxoxK4V1NoYcsGkzC
 wxkB6iaUH0spLqTQpYKY5ca9Xqads0unmBEJR4vmwRarOpGyUAFuCP4uwlqw==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id D6BC78186;
	Wed, 11 Jun 2025 20:24:29 -0700 (PDT)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id DE8378C1E05; Wed, 11 Jun 2025 20:24:28 -0700 (PDT)
Date: Wed, 11 Jun 2025 20:24:28 -0700
From: Paul Aurich <paul@darkrain42.org>
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com, pc@manguebit.com,
	henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 6/7] cifs: tc_count updates should be done with tc_lock
Message-ID: <aEpIbMKyUh-6eqsR@vaarsuvius.home.arpa>
Mail-Followup-To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org,
	smfrench@gmail.com, bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com, pc@manguebit.com,
	henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-6-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250604101829.832577-6-sprasad@microsoft.com>

On 2025-06-04 15:48:15 +0530, nspmangalore@gmail.com wrote:
>From: Shyam Prasad N <sprasad@microsoft.com>
>
>We had problems with deadlocks using the cifs_tcp_ses_lock for
>protecting a lot of structures. So we broke it down into smaller
>spinlocks. cifs_tcon struct fields are protected by tc_lock now.
>Hence we should stick to using that.

Is it really safe to adjust this to tc_lock?

There are a number of other points in the smb client that (AFAICT) only hold 
cifs_tcp_ses_lock while adjusting the tc_count (which is why I used that 
here).  See smb2_handle_cancelled_close, smb2_get_dfs_refer, 
smb2_reconnect_server, smb2_find_smb_tcon.

~Paul

>Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instances drop their dentry")
>Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>---
> fs/smb/client/cached_dir.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 2746d693d80a..4abf5bbd8baf 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -650,10 +650,12 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> 			spin_unlock(&cfid->fid_lock);
> 			cfids->num_entries--;
>
>+			spin_lock(&cfid->tcon->tc_lock);
> 			++tcon->tc_count;
> 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
> 					    netfs_trace_tcon_ref_get_cached_lease_break);
> 			queue_work(cfid_put_wq, &cfid->put_work);
>+			spin_unlock(&cfid->tcon->tc_lock);
> 			spin_unlock(&cfids->cfid_list_lock);
> 			return true;
> 		}
>@@ -767,11 +769,11 @@ static void cfids_laundromat_worker(struct work_struct *work)
> 		dput(dentry);
>
> 		if (cfid->is_open) {
>-			spin_lock(&cifs_tcp_ses_lock);
>+			spin_lock(&cfid->tcon->tc_lock);
> 			++cfid->tcon->tc_count;
> 			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
> 					    netfs_trace_tcon_ref_get_cached_laundromat);
>-			spin_unlock(&cifs_tcp_ses_lock);
>+			spin_unlock(&cfid->tcon->tc_lock);
> 			queue_work(serverclose_wq, &cfid->close_work);
> 		} else
> 			/*
>-- 
>2.43.0
>

