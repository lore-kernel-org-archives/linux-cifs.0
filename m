Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53485132464
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636580; cv=pass; b=DdUtN1N6LGmrIK0sDDQMsxjKjfFFbzmqvy4OS391L/M7byUyFT1pidwxMXioR07np00clcn/1sy7nX5RGFqeM59/9RCcWZXO9+r0JVzDUKtKeHBqAu7prNOt3KGfRiVN331j9LlTRTat3+hn/zQ0zurjQHATzwkxoSM/6f/vtbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636580; c=relaxed/simple;
	bh=9+FxDeUZkQnFlvbnQFCMQtJasPfYNhF7CVCe9NbS/+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0MHr83/kK6IMud3NDj95o9VeAT1QBNxOm5UNqe5Tx0H1CRPHk3wQDjkO8jdfPn6AHkn08QQLl/PCfNo0T11WLm4Atpnhdf/2SdUhDYr6p9zU7IlpkafA6vaLFcEI3PVbqclrkBGdn07pJVbmM2Wm0soKjfvV6DziI/T5SeGd/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=YP/5sozE; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="YP/5sozE"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35pYiSAOtdfHfdek4lP+dEnnScBBYjWTWYlQ53AlhNw=;
	b=YP/5sozEyN00pTWYKzDd/WW9JjCcAjrrmMNBW5co5DvZty+dACmhk6k76NNT+1c6w2ysk2
	NFNJShUsiMt634hYjUopgnRAhczs1vqCF/BlDKcvLTP6mOd99StSSXkxliyi7/zJSCpPJr
	w4pSC96ndUlEBiS6g4dSJOC7RTyry/wgPC6pt1572ajLrp+8ZhVwDX0nTEFklYBbf3hCnJ
	gHf9izEbCsp3af0XFyYPT2+9CYBP0aKclxZ0/YPSssW40HPXVeqIbkWb0c/C3rYm5XNFBo
	2ysZdvg1qLrXzyiOozrrfCZ1TrDUj4fUYLY5lNCoEkgpOGJSzl80YYVB89pqFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636577; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35pYiSAOtdfHfdek4lP+dEnnScBBYjWTWYlQ53AlhNw=;
	b=oJtLbu/ihUjd2O2V477VbstHxjct5Zlsdx4KfM7vlChFfjPG0tmVRyPsPtdhQymnXXmbod
	yZyrNuErtPS1HmFcYoG/UxWFJJWT0qf1BTkrffwDRn4ZHRogdUY0giEdAM+UFe1brt2/Xu
	EHlqCQGcxWxSDc3DYeEI8NI0FLpVL7OFhV8DoEm0QE62FFFwi6jnhLrmuiJM8mWajcFEPJ
	knqN6qoJNAOoyj54NZOKf71JC26OGU6P4drViu4QAPihgA1qdvX6Bov1/2ZjKtMVtfhZWk
	JYeilTpdHoTETdeZQIMwOj5W+bvMefumTs+P8Kxu/GWqL37pCouXQgnJ2pZAyQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636577; a=rsa-sha256;
	cv=none;
	b=Kg3847J0KemPcNAEGdPNhQgMz6qfdnwDCoc4sNmCqmlnfQzVgPkM+1v5gr5fPd10CHvQsc
	BBNByiDanhPbJ33XjPzXfbrsY+bdPp4dClOG+LetrfMZWjmqcSu2AjJN1Tkmx55RX3rU8X
	L0v+bW87hGoXQneJkpzq3SfKJrK/joS2j3aul4rL0nIhKr7AOD5pdVw6UyTkIvdx6gtsHX
	04AcSeHLIEJa38pk/3eV633dbSmdBh+i/LXACacfI6LpygpeT2wtJfEACVvmTjpNKaLCoD
	LMamH+wAHrf/5jV2jfc1NReR2/4P8vj7p0Z85B5fzJ0wfOY3kvrZw8rP+GxK3Q==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 8/9] smb: client: fix DFS failover in multiuser mounts
Date: Wed, 18 Sep 2024 02:15:41 -0300
Message-ID: <20240918051542.64349-8-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For sessions and tcons created on behalf of new users accessing a
multiuser mount, matching their sessions in tcon_super_cb() with
master tcon will always lead to false as every new user will have its
own session and tcon.

All multiuser sessions, however, will inherit ->dfs_root_ses from
master tcon, so match it instead.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 47b861517bed..054f10ebf65a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1111,7 +1111,8 @@ static void tcon_super_cb(struct super_block *sb, void *arg)
 	t2 = cifs_sb_master_tcon(cifs_sb);
 
 	spin_lock(&t2->tc_lock);
-	if (t1->ses == t2->ses &&
+	if ((t1->ses == t2->ses ||
+	     t1->ses->dfs_root_ses == t2->ses->dfs_root_ses) &&
 	    t1->ses->server == t2->ses->server &&
 	    t2->origin_fullpath &&
 	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath))
-- 
2.46.0

