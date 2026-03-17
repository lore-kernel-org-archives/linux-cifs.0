Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DC32AAA0
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 09:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739861; cv=none; b=bZ9Uu8tLsVc038QY9IUoMQHKwOfhAFmgFKr7HXSYOLMFzQ/f60rRVQpMBOhcEabz+K8XqjIXDHkLW5VjfhMvPEgiEEPnZ4BUYSkxE21K+YiiBgQLOTWWBzD5sZMR7gEw7aP7E5Ncz1PhfosSyzUUgh7oNsC90i/1ePE8QJMuB18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739861; c=relaxed/simple;
	bh=O5DSdIqTHk7OX5HsHlZambbQZOQmknmjon0UeAAbfjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bt3HFIvyeaqC8Sx82viSh5lsJdal4KiPZi1BCQTkqVAzio4ENgdygNPNxtztGAXz/BAqF4W8aDely/AhfrkU5Pkz4CLFp0QN10DJB2CSfgHGn0ORC0RLOuNLZNRxzwaL562LpCjckNNpPQnajJSNAKYHUjbQYF3h2pEMVj9wVgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=L5/zEI3n; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="L5/zEI3n"
Message-ID: <9192ff4b-770a-411b-af5d-ab06d20248f8@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1773739846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mqbZ7WkERoPH0cKH1jw4JhyO0brCaIl0BBggy4u3jAM=;
	b=L5/zEI3nfky2rX7HL3+HTFfZ+1xiEATNZB+hSmA3CSTXzN5C3+Z8aK6uqzSYDQE7GAL1wA
	jpKRavGLchHHi7q2NHqNRZ5lv0a4YUEzilNt7BEGWn18TFGflZGEcjcnwOG8Rnkeu8gOha
	55fNO3lMBG0UR9+l2x2fFE2KKWmemRdSLDtDpanphzKeBWxZvhNsiRqg06mPee37TvEUsB
	TyNnQltYSTbqQdqrKfD84T2Oh8sT/i+aIiRS/qNmw9VYVq8WWFewsj2nsIVrw5Fl2G/IiS
	nfPMIndJ0Po2foEg/DIUnxwB4gmSegV37T51e0yPGmS7kHC793MK5VfbKgNwzA==
Date: Tue, 17 Mar 2026 17:29:49 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: fix memory leaks and NULL deref in smb2_lock()
To: Werner Kasselman <werner@verivus.ai>, Namjae Jeon
 <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260317080835.1947664-1-werner@verivus.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260317080835.1947664-1-werner@verivus.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

And it might be better to change it as follows.

```
@@ -7685,13 +7686,17 @@ int smb2_lock(struct ksmbd_work *work)
                 struct file_lock *rlock = NULL;

                 rlock = smb_flock_init(filp);
-               rlock->c.flc_type = F_UNLCK;
-               rlock->fl_start = smb_lock->start;
-               rlock->fl_end = smb_lock->end;
+               if (rlock) {
+                       rlock->c.flc_type = F_UNLCK;
+                       rlock->fl_start = smb_lock->start;
+                       rlock->fl_end = smb_lock->end;

-               rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
-               if (rc)
-                       pr_err("rollback unlock fail : %d\n", rc);
+                       rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
+                       if (rc)
+                               pr_err("rollback unlock fail : %d\n", rc);
+               } else {
+                       pr_err("rollback unlock alloc failed\n");
+               }

                 list_del(&smb_lock->llist);
                 spin_lock(&work->conn->llist_lock);
@@ -7701,7 +7706,8 @@ int smb2_lock(struct ksmbd_work *work)
                 spin_unlock(&work->conn->llist_lock);

                 locks_free_lock(smb_lock->fl);
-               locks_free_lock(rlock);
+               if (rlock)
+                       locks_free_lock(rlock);
                 kfree(smb_lock);
         }
  out2:
```

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 3/17/26 16:08, Werner Kasselman wrote:
> @@ -7685,6 +7691,19 @@ int smb2_lock(struct ksmbd_work *work)
>   		struct file_lock *rlock = NULL;
>   
>   		rlock = smb_flock_init(filp);
> +		if (!rlock) {
> +			pr_err("rollback unlock alloc failed\n");
> +			list_del(&smb_lock->llist);
> +			spin_lock(&work->conn->llist_lock);
> +			if (!list_empty(&smb_lock->flist))
> +				list_del(&smb_lock->flist);
> +			list_del(&smb_lock->clist);
> +			spin_unlock(&work->conn->llist_lock);
> +
> +			locks_free_lock(smb_lock->fl);
> +			kfree(smb_lock);
> +			continue;
> +		}
>   		rlock->c.flc_type = F_UNLCK;
>   		rlock->fl_start = smb_lock->start;
>   		rlock->fl_end = smb_lock->end;

