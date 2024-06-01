Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB5A846C
	for <linux-cifs@vger.kernel.org>; Sat,  1 Jun 2024 11:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717241523; cv=none; b=MgwWmhGAtPZhQtPwCuZXJwj9gBOa1qJAhu/CmtNq+DZZXw8SSCCghpRycGWldIr2PBx97BweuFRJwpXSXDWnTyEj/rPmd6Cm2D6bXTase4UaNxcwTmReP+nUbmjK/EY76HTrfhZxrVkmjbZqA25GGWIToJ3c4ergTYZiz+/+ns4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717241523; c=relaxed/simple;
	bh=AC3kn7FTNVJrdGn0doRL96kqlNkw7WWYeWOnGZTGno8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=i/BapGfUOvPulm9zaKn5QJGxo1anp7eSGTvQ6nSvo2ii9o9Hw74X5bHz2XPBIDJWpi7G3Zc46ZFQeHjpwlzPKel/1CdrDzn+zRi0PHm67qZAo/XFJT/iViRG04aohL15PN6yK+EXFLwc6yE77p5N84V/sdVoOOp1cEAJqWMiKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VryQk60XdzxR33;
	Sat,  1 Jun 2024 19:27:58 +0800 (CST)
Received: from dggpemd200001.china.huawei.com (unknown [7.185.36.224])
	by mail.maildlp.com (Postfix) with ESMTPS id 495521400D6;
	Sat,  1 Jun 2024 19:31:51 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 dggpemd200001.china.huawei.com (7.185.36.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 1 Jun 2024 19:31:50 +0800
Message-ID: <aaf165e4-a5ad-cb66-2c39-2ee6b39939d5@huawei.com>
Date: Sat, 1 Jun 2024 19:31:50 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 01/12] smb: client: fix potential UAF in
 cifs_debug_files_proc_show()
To: Paulo Alcantara <pc@manguebit.com>, <smfrench@gmail.com>
CC: <linux-cifs@vger.kernel.org>
References: <20240402193404.236159-1-pc@manguebit.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemd200001.china.huawei.com (7.185.36.224)


Hello,

I have some questions regarding CVE-2024-26928.

I would like to confirm whether the phrase "fix potential UAF in
cifs_debug_files_proc_show()" implies that the UAF issue does not
actually exist, correct?

Based on my analysis, `cifs_tcp_ses_lock` plays a crucial role in
preventing the UAF.

After adding `ses` to the `smb_ses_list` list, the only place where
the `ses` is freed is in the `__cifs_put_smb_ses` function:

```
__cifs_put_smb_ses()
     ...
     spin_lock(&cifs_tcp_ses_lock);
     list_del_init(&ses->smb_ses_list);
     spin_unlock(&cifs_tcp_ses_lock);
     ...
     sesInfoFree(ses);
```

The `ses` is freed only after it is removed from the list, and this
removal is protected by `cifs_tcp_ses_lock`.

In `cifs_debug_files_proc_show()`, the `cifs_tcp_ses_lock` is still
held, ensuring that during access to the `ses` that is about to be
destroyed, the `ses` will not be freed in `__cifs_put_smb_ses()`,
thus preventing a UAF issue.

```
cifs_debug_files_proc_show()
     ...
     spin_lock(&cifs_tcp_ses_lock);
     ...
     list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list)
     ...
     spin_lock(&cifs_tcp_ses_lock);
```
Based on this understanding, I wonder if the issue addressed by
this CVE might not be a genuine problem. I am also curious about
the series of patches considered as fixes for this CVE.

Best regards,
Wang Zhaolong


> Skip sessions that are being teared down (status == SES_EXITING) to
> avoid UAF.
> 
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>   fs/smb/client/cifs_debug.c |  2 ++
>   fs/smb/client/cifsglob.h   | 10 ++++++++++
>   2 files changed, 12 insertions(+)
> 
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 226d4835c92d..c9aec9a38ad3 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -250,6 +250,8 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
>   	spin_lock(&cifs_tcp_ses_lock);
>   	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
>   		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +			if (cifs_ses_exiting(ses))
> +				continue;
>   			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
>   				spin_lock(&tcon->open_file_lock);
>   				list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 286afbe346be..f67607319c43 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -2322,4 +2322,14 @@ struct smb2_compound_vars {
>   	struct kvec ea_iov;
>   };
>   
> +static inline bool cifs_ses_exiting(struct cifs_ses *ses)
> +{
> +	bool ret;
> +
> +	spin_lock(&ses->ses_lock);
> +	ret = ses->ses_status == SES_EXITING;
> +	spin_unlock(&ses->ses_lock);
> +	return ret;
> +}
> +
>   #endif	/* _CIFS_GLOB_H */

