Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9CA2F873
	for <linux-cifs@vger.kernel.org>; Sat,  1 Jun 2024 11:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717242651; cv=none; b=krwULif3j/6SUdK1+ln/WKZzbulVCuvg2f33IaCj6kGK2YYuZhvlri0IZ/Os16IzEMmZ5YcBK2aDv5bnZ3QVGnQJYGOHBvkU8VYXa7rLFo0XrnNpv1F5cvWUK5SikPTDmf6tIw3yFUXCmJedo/hFUZCi+2nipRSzrwKDbv+m0M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717242651; c=relaxed/simple;
	bh=yYXyiA14ao049FQ7flJ+HIxg6pDJqOqUvO3LBVIYlD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=j5wWZ8vk663RkVkLsf4Ypa2rjv2+dQGHlFg2f/1/u3B9a6brUcRZTwuhHiotBoX3QVWQnohcrhczxqW1eFWm54mHsHNoW0DywgXQ9nJoLGJRS1euNan2Tsw0rphSphqmT21FaDj6tKRzf0Ed3O0fMljNtSSaEWf8nvfZLt3GTnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Vryqt0bCZzmX4k;
	Sat,  1 Jun 2024 19:46:18 +0800 (CST)
Received: from dggpemd200001.china.huawei.com (unknown [7.185.36.224])
	by mail.maildlp.com (Postfix) with ESMTPS id 4BB2818006C;
	Sat,  1 Jun 2024 19:50:45 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 dggpemd200001.china.huawei.com (7.185.36.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 1 Jun 2024 19:50:44 +0800
Message-ID: <60fcd1b4-c9d3-c072-a5d1-64a8b3d7cc1d@huawei.com>
Date: Sat, 1 Jun 2024 19:50:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 2/4] smb: client: fix use-after-free bug in
 cifs_debug_data_proc_show()
To: Paulo Alcantara <pc@manguebit.com>, <smfrench@gmail.com>
CC: <linux-cifs@vger.kernel.org>, Frank Sorenson <sorenson@redhat.com>
References: <20231030201956.2660-1-pc@manguebit.com>
 <20231030201956.2660-2-pc@manguebit.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <20231030201956.2660-2-pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemd200001.china.huawei.com (7.185.36.224)


Hello,

I encountered some confusion while reviewing the source code related to
CVE-2023-52752.

I was able to reproduce the issue, and the original problem seems to be:

---
process 1                   process 2(read /proc/fs/cifs/DebugData)

cifs_umount
cifs_put_tlink
cifs_put_tcon
cifs_put_smb_ses                cifs_debug_data_proc_show
   spin_unlock(&cifs_tcp_ses_lock)
                                   spin_lock(&cifs_tcp_ses_lock);
                                   list_for_each...(ses,server->smb_ses_list,...)
   cifs_free_ipc
     tconInfoFree(tcon)
                                   if (ses->tcon_ipc)
                                    cifs_debug_tcon(m,ses->tcon_ipc)
                                      // UAF
     ses->tcon_ipc = NULLl
                                   spin_unlock(&cifs_tcp_ses_lock);

   spin_lock(&cifs_tcp_ses_lock)
   list_del_init(&ses->smb_ses_list)
   spin_unlock(&cifs_tcp_ses_lock)
---

In commit ff7d80a9f271 ("cifs: fix session state transition to avoid use-after-free
issue"), setting ses_status to SES_EXITING was moved under the protection of
cifs_tcp_ses_lock.

In cifs_debug_data_proc_show(), the logic that checks ses->ses_status == SES_EXITING
already seems sufficient to avoid this issue. Therefore, it appears that ses->ses_lock
might not be necessary. Additionally, I am curious why ses->ses_lock needs to cover
such a large scope.


> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 76922fcc4bc6..9a0ccd87468e 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -452,6 +452,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>   		seq_printf(m, "\n\n\tSessions: ");
>   		i = 0;
>   		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +			spin_lock(&ses->ses_lock);
> +			if (ses->ses_status == SES_EXITING) {
> +				spin_unlock(&ses->ses_lock);
> +				continue;
> +			}
>   			i++;
>   			if ((ses->serverDomain == NULL) ||
>   				(ses->serverOS == NULL) ||
> @@ -472,6 +477,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>   				ses->ses_count, ses->serverOS, ses->serverNOS,
>   				ses->capabilities, ses->ses_status);
>   			}
> +			spin_unlock(&ses->ses_lock);
>   
>   			seq_printf(m, "\n\tSecurity type: %s ",
>   				get_security_type_str(server->ops->select_sectype(server, ses->sectype)));

I believe in the latest mainline, this could potentially be modified to:

```
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index c71ae5c04306..2d9e83b71643 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -485,11 +485,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
  		seq_printf(m, "\n\n\tSessions: ");
  		i = 0;
  		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			spin_lock(&ses->ses_lock);
-			if (ses->ses_status == SES_EXITING) {
-				spin_unlock(&ses->ses_lock);
+			if (cifs_ses_exiting(ses))
  				continue;
-			}
  			i++;
  			if ((ses->serverDomain == NULL) ||
  				(ses->serverOS == NULL) ||
@@ -512,7 +509,6 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
  			}
  			if (ses->expired_pwd)
  				seq_puts(m, "password no longer valid ");
-			spin_unlock(&ses->ses_lock);
  
  			seq_printf(m, "\n\tSecurity type: %s ",
  				get_security_type_str(server->ops->select_sectype(server, ses->sectype)));

```

Best regards,
Wang Zhaolong
