Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9346AC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 15:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJBPlL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 11:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJBPlI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 11:41:08 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA673FD77
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 08:41:01 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j16so13482993lfg.1
        for <linux-cifs@vger.kernel.org>; Sun, 02 Oct 2022 08:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+xgBNmC0MF1m5JwJ3Dfm+FLEnRhC5x/621qvSD5ZvPM=;
        b=gtEhtbZnU7aOx9J5FXhKtOQNzpywxWVOpvRyCpZBsfRYe7fgVsOMpEqGoyRfL0ElHr
         6A9gc42uemQdC8xjlJljKCAiq/npfF5JnmoudwCaw9W3C2vmeMvnR5maYvK+0WgV95aC
         RbTdfzX0n4tI6Hzv4hN3eeTHw9vmibBdqQROF9Z8txAR3Qw/nvs0w88aJDN/F++hlKzk
         whwgBQqKuwsmmP4FnCBR9X84VIOnxSL6+yLs8xvOC2bAwMr36eMvgfaemAk5QCTNMlGw
         VVkrOiIpXRTrxKAUcoYpgq+vS6tG4UVMjf77/Nv7sG2LHv8GN0KJu1N15ub2brGQVwTs
         pXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+xgBNmC0MF1m5JwJ3Dfm+FLEnRhC5x/621qvSD5ZvPM=;
        b=m7bJu/+0EVovb97IieoFtgfB83QYGkANAsCHXPufTtBMC0NdOHvEHXfC6uhGNlTsA6
         FkXhid6qkQR/JnOj1xkE2I4+CF7NoFsRrxJzMINNaQvzgmek1bCg8UAySrnXlR5abseZ
         fgDrDAJaM5fzdHmx4OSys01els4L7HPYzDjcQySVfYhrWhwCxmEbq8+issAjRC1a2dRk
         dY1NWiWN3onEw8zE6zji+Mc9aFbQyHtULsd4T1WtnLOtw397iWrKve6VvbVK+7W/e7RL
         JjkRIiTQw1p4DUe5CipnRpDbpJnXbzhVlD7n+0RWcae8OZuUEUqCoyKACy0jjf0BBP7q
         VD6Q==
X-Gm-Message-State: ACrzQf2CcyatEtR3nrSMHYrF6vq4NeO11ASU8zBL/3H80YdzpPeFGPxm
        QyT8oOdclFltnXWEkLBpOEw=
X-Google-Smtp-Source: AMsMyM7lmDkQ/41VlLFDVPYtj9VafUsdrySCkH+DWUN5AnR5I1sb9KxYuyYhyL7bo9r3sxWdWxZFSQ==
X-Received: by 2002:ac2:5e66:0:b0:4a2:e52:2dd4 with SMTP id a6-20020ac25e66000000b004a20e522dd4mr5136489lfr.271.1664725259295;
        Sun, 02 Oct 2022 08:40:59 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84be-149.dhcp.inet.fi. [46.132.190.149])
        by smtp.gmail.com with ESMTPSA id b18-20020a056512305200b0048b0696d0b1sm1120016lfb.90.2022.10.02.08.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 08:40:58 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     atteh.mailbox@gmail.com
Cc:     linkinjeon@kernel.org, linux-cifs@vger.kernel.org
Subject: [PATCH v4] ksmbd: validate share name from share config response
Date:   Sun,  2 Oct 2022 18:40:21 +0300
Message-Id: <20221002154021.10926-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002024628.106816-1-atteh.mailbox@gmail.com>
References: <20221002024628.106816-1-atteh.mailbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun,  2 Oct 2022 05:46:28 +0300, Atte Heikkilä wrote:
> Share config response may contain the share name without casefolding as
> it is known to the user space daemon. When it is present, casefold and
> compare it to the share name the share config request was made with. If
> they differ, we have a share config which is incompatible with the way
> share config caching is done. This is the case when CONFIG_UNICODE is
> not set, the share name contains non-ASCII characters, and those non-
> ASCII characters do not match those in the share name known to user
> space. In other words, when CONFIG_UNICODE is not set, UTF-8 share
> names now work but are only case-insensitive in the ASCII range.
> 
> Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
> ---
>  v4:
>    - check for ksmbd_casefold_sharename() error with IS_ERR()
> 
>  v3:
>    - removed initial strcmp() check since it could only save a call to
>      ksmbd_casefold_sharename() for matching ASCII-only share names
> 
>  v2:
>    - no changes were made
> 
>  fs/ksmbd/ksmbd_netlink.h     |  3 ++-
>  fs/ksmbd/mgmt/share_config.c | 20 +++++++++++++++++---
>  fs/ksmbd/mgmt/share_config.h |  4 +++-
>  fs/ksmbd/mgmt/tree_connect.c |  4 ++--
>  fs/ksmbd/misc.c              |  4 ++--
>  fs/ksmbd/misc.h              |  1 +
>  6 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
> index e0cbcfa98c7e..ff07c67f4565 100644
> --- a/fs/ksmbd/ksmbd_netlink.h
> +++ b/fs/ksmbd/ksmbd_netlink.h
> @@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
>  	__u16	force_directory_mode;
>  	__u16	force_uid;
>  	__u16	force_gid;
> -	__u32	reserved[128];		/* Reserved room */
> +	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
> +	__u32	reserved[112];		/* Reserved room */
>  	__u32	veto_list_sz;
>  	__s8	____payload[];
>  };
> diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
> index 5d039704c23c..dfb4bb365891 100644
> --- a/fs/ksmbd/mgmt/share_config.c
> +++ b/fs/ksmbd/mgmt/share_config.c
> @@ -16,6 +16,7 @@
>  #include "user_config.h"
>  #include "user_session.h"
>  #include "../transport_ipc.h"
> +#include "../misc.h"
>  
>  #define SHARE_HASH_BITS		3
>  static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
> @@ -119,7 +120,8 @@ static int parse_veto_list(struct ksmbd_share_config *share,
>  	return 0;
>  }
>  
> -static struct ksmbd_share_config *share_config_request(const char *name)
> +static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
> +						       const char *name)
>  {
>  	struct ksmbd_share_config_response *resp;
>  	struct ksmbd_share_config *share = NULL;
> @@ -133,6 +135,17 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>  	if (resp->flags == KSMBD_SHARE_FLAG_INVALID)
>  		goto out;
>  
> +	if (*resp->share_name) {
> +		char *cf_resp_name;
> +		bool equal;
> +
> +		cf_resp_name = ksmbd_casefold_sharename(um, resp->share_name);
> +		equal = !IS_ERR(cf_resp_name) && !strcmp(cf_resp_name, name);
> +		kfree(cf_resp_name);

Well, kfree() is *not* a no-op for ERR_PTR() like it is for NULL so
this patch is not good either. At least I'm running out of ways to get
this wrong.

> +		if (!equal)
> +			goto out;
> +	}
> +
>  	share = kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
>  	if (!share)
>  		goto out;
> @@ -190,7 +203,8 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>  	return share;
>  }
>  
> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
> +						  const char *name)
>  {
>  	struct ksmbd_share_config *share;
>  
> @@ -202,7 +216,7 @@ struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>  
>  	if (share)
>  		return share;
> -	return share_config_request(name);
> +	return share_config_request(um, name);
>  }
>  
>  bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
> diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
> index 7f7e89ecfe61..3fd338293942 100644
> --- a/fs/ksmbd/mgmt/share_config.h
> +++ b/fs/ksmbd/mgmt/share_config.h
> @@ -9,6 +9,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/hashtable.h>
>  #include <linux/path.h>
> +#include <linux/unicode.h>
>  
>  struct ksmbd_share_config {
>  	char			*name;
> @@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
>  	__ksmbd_share_config_put(share);
>  }
>  
> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
> +						  const char *name);
>  bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>  			       const char *filename);
>  #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
> diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
> index 867c0286b901..8ce17b3fb8da 100644
> --- a/fs/ksmbd/mgmt/tree_connect.c
> +++ b/fs/ksmbd/mgmt/tree_connect.c
> @@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>  	struct sockaddr *peer_addr;
>  	int ret;
>  
> -	sc = ksmbd_share_config_get(share_name);
> +	sc = ksmbd_share_config_get(conn->um, share_name);
>  	if (!sc)
>  		return status;
>  
> @@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>  		struct ksmbd_share_config *new_sc;
>  
>  		ksmbd_share_config_del(sc);
> -		new_sc = ksmbd_share_config_get(share_name);
> +		new_sc = ksmbd_share_config_get(conn->um, share_name);
>  		if (!new_sc) {
>  			pr_err("Failed to update stale share config\n");
>  			status.ret = -ESTALE;
> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
> index 28459b1efaa8..9e8afaa686e3 100644
> --- a/fs/ksmbd/misc.c
> +++ b/fs/ksmbd/misc.c
> @@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
>  	strreplace(path, '/', '\\');
>  }
>  
> -static char *casefold_sharename(struct unicode_map *um, const char *name)
> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name)
>  {
>  	char *cf_name;
>  	int cf_len;
> @@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
>  		name = (pos + 1);
>  
>  	/* caller has to free the memory */
> -	return casefold_sharename(um, name);
> +	return ksmbd_casefold_sharename(um, name);
>  }
>  
>  /**
> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
> index cc72f4e6baf2..1facfcd21200 100644
> --- a/fs/ksmbd/misc.h
> +++ b/fs/ksmbd/misc.h
> @@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
>  void ksmbd_conv_path_to_unix(char *path);
>  void ksmbd_strip_last_slash(char *path);
>  void ksmbd_conv_path_to_windows(char *path);
> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
>  char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
>  char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
>  
> -- 
> 2.37.3
> 
> 
