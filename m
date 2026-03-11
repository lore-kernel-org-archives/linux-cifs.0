Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A34B337B99
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252334; cv=none; b=quvXA7ipXv6bvHDzI1jZChLqLgggrz43UwvRU3vKy1ECxfznQiajChV+xWVpbRAR4h9t/Kx29nnHeruXXraFqLMQswmLv+H7/LYpzLZKjjR72ni3/MrWZo85TOSEKVTNP5z6gVFau5FlGMl72dyAZlm29pXWEOfWDLjpTK2EdOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252334; c=relaxed/simple;
	bh=AL4IXq6iPYsWryMg2utdwYspGX4JCOQveTu5QegF1jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRHaXNY5UbR3R6xvwFbO6vEjXrGGPkQ5UzolNydENxK9v8wyUyZF0xpuwINucYhUB3rKTbGR8BSOC2XSsGk8hKt8/xgIncOmYRugNFT9+g8vIJ2Abh6x1YFnQDmjfU5RJQXJiLsP+PQ3CQyF4+LN7q/93CjnZdAN0egCyhBQuAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eBtR87qP; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eBtR87qP"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so1224965e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 11:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773252331; x=1773857131; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xO0XJEJMI0VhT27CaLqa2S0ptnjebbKGDNoewgUI+WA=;
        b=eBtR87qPMTASFWRN2WwbxgNu5qCAvf9N72MF1jxlDq9zXIShT0KyGhuRsYDwGErxID
         0zhDuWZAsBa+6UtdxGy4qXFnnIhcD5w/fe5M4/E4CoTwYVX+iJioV1e4XD3RXJKLYZmH
         rF8/Wcjt+65HgGauQIG7aMBc7fIod/HB8p3QyZ3g/m7GLz144rUiWEEZQ7EqzdjlRDah
         qvhI6mlTMxT+ebOq+NsAXTInO23QKE+MdgNmWjwnGyvUlp/n3spAz3q/TeYAffoN2N1t
         mZjMOdbOe3EkUwirh9MvX3ey6Nq6CCRMRqHjON7Y478h64ByQs/DdGtBNMAyQwTxdKl9
         7P2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773252331; x=1773857131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xO0XJEJMI0VhT27CaLqa2S0ptnjebbKGDNoewgUI+WA=;
        b=uW0i4zpDUD99o3ziLcct+ZP3/liLE6OrSOcvAJrF8GWVaLD3O99PWdYUC+yvF3JQJs
         Y7HRf784uF19nkgGn3yjKEXObxMTVAoV0oIW80eTUTxbGknNW6y1sQGRhcSZfUQaZHX2
         k6M2nGnMiNF8IBUGW5P906g276K+E+zwi2fwHVAY9ShNmag4qm9q4LiZrtHEPEBbu0Wb
         doBZ9/hfthM1blW513uxI4m3604qxFZJANrG+l1ZKNQn5AdaISxezweZ7WyCGlkwHngN
         PmTJlySPG+N5hatawo9gICbxU2pjgSfNZVnQ2T+rM1poMr0ESsdfAsByhpn+JbhteinH
         K6dg==
X-Forwarded-Encrypted: i=1; AJvYcCVmoZ3umEqVkv0hwaNbAphvto7ILRWjE0dD/kx/z6/xjTinPlYWV1D2+VncDOwWfeJyNgd6pH0j1CJC@vger.kernel.org
X-Gm-Message-State: AOJu0YwOg/9AYqMEN/ioR4GJl7EnRSbbW9JGxNVbbjj+miBR31SUUdTZ
	BiiMg0EcboaobKIhRTGUYepQVLfjJrN/VOSpxra4iOLJo7wf/bvZ42igKi+1g3MaVZ8=
X-Gm-Gg: ATEYQzxmt0+Ut+M2uhYx0ATEXOHATjyMVtfTLMksdatQ5lfYz7CCk3sDh6en1Q+ki1i
	TMrdQmv/GlukfXhOguAO2aA8EzX2ocnbiNDCNlhlcfh3N5AuHn/Rex3ZvPQyE9KydavsbnA4lnb
	vlT3pV65qMKjlycCmlW61hVWFY8Aj511T5oP30EgsZayraW8DjySqk8nRnGIdlaV74TOomzaI7R
	rP7ZSHhT+nVTvWD6FN+DsmHwiUqS27Dw+1scSBb+q5fVfRkXPvitqeEpD+GWj11y86V3d+qpluN
	D9rUDtQbLdNuQSM5CqB3xtTqg84ujzZwi4+x6KKUBQoFuWI3Xk8wtKe5lpEP7TV3vkPffQy7DQe
	Z+qiQD83LkGAquSDmm3l4X9+KOokpCIHBPj8uR2fxoPfG2Wh5A0Z/xMSkwx0zCmyzy9AV0vzxWj
	GLgC4Vlxn/OrFEUIWfQ000BCBValxE0C85wUbyabA9K6zExC1JpEQPSKc=
X-Received: by 2002:a05:600c:64cc:b0:480:4d38:7abc with SMTP id 5b1f17b1804b1-4854b0b950bmr56222225e9.11.1773252330755;
        Wed, 11 Mar 2026 11:05:30 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7cb5208sm5510617c88.9.2026.03.11.11.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 11:05:29 -0700 (PDT)
Date: Wed, 11 Mar 2026 15:05:25 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, Thiago Becker <tbecker@redhat.com>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix oops due to uninitialised var in
 smb2_unlink()
Message-ID: <37stwkoyvb3xjcstdzyhh34nwd7nu6mdnjbkq6e3xayjncaycz@t2fhg4rpiau6>
References: <20260306005706.830672-1-pc@manguebit.org>
 <r7ojhnxu3jkr42oczp2o5w3hp5bs24ft5yav6nnlcohsybqeuv@zjvwndvvxayc>
 <353be345dcf906816d61e127583032d2@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <353be345dcf906816d61e127583032d2@manguebit.org>

On Fri, Mar 06, 2026 at 07:51:44PM -0300, Paulo Alcantara wrote:
> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> 
> > Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >
> > We got a lot of those replay uninitialised bugs. Maybe we should prevent
> > them by having a replay(func, cond) so we can take advantage of a clean
> > stack. Opinions?
> 
> Agreed.  No strong opinions.  I'm wondering if that should be
> implemented in the transport layer, therefore we could get rid of all
> that duplicate code.  Alternatively, having the thing implemented in
> netfslib instead.

Since not everything goes through netfslib, it makes sense to be
implemented in cifs with different approaches to netfslib.

I thought that implementing in transport layer is a good idea. However,
we have two problems here. First, netfslib callbacks also go through
this layer, leaving us with the issue David mentioned about performance
and handing in cifs before returning to netfslib. Second, we would need
to change the cifs_pick_channel architecture as well, because the replay
happens in potentially two different channels.

So I thought about doing something like the following, please give me
your thoughts. This would require a lot of changes in existing replay
functinos, but mostly intialization at the top, removal of internal
replay logic and definition of a static *_once function.

[PATCH] smb: client: introduce smb2_should_replay_wait() helper

Introduce smb2_should_replay_wait() to centralize replay decision and
backoff.

This wraps the existing replay logic so call sites can use:

        int smb2_operation(..., tcon) {
                int rc = 0;
                int retries = 0;
                int cur_sleep = 0;
                do {
                        rc = smb2_operation_once(..., retries > 0);
                } while (smb2_should_replay_wait(tcon, rc, &retries, &cur_sleep));
                return rc;
        }

This helps avoid replay-path uninitialized variable errors by encouraging
single-attempt helpers with fresh locals per retry.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c   | 24 ++++++++++++++++++++++++
 fs/smb/client/smb2proto.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 592c1609443b..43223389e2b6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2806,6 +2806,30 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 	return false;
 }
 
+/*
+ * smb2_should_replay_wait - decide whether to replay an operation and
+ * back off (may sleep)
+ *
+ * @tcon
+ * @rc: return code from the previous attempt
+ * @retries: retry counter modifiable by smb2_should_replay()
+ * @cur_sleep: backoff delay (ms) modifiable by smb2_should_replay()
+ *
+ * Returns true if the operation should be retried
+ */
+bool smb2_should_replay_wait(struct cifs_tcon *tcon,
+		              int rc,
+		              int *retries,
+		              int *cur_sleep)
+{
+	if (!is_replayable_error(rc))
+		return false;
+	if (!smb2_should_replay(tcon, retries, cur_sleep))
+		return false;
+	if (*cur_sleep)
+		msleep(*cur_sleep);
+	return true;
+}
+
