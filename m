Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE415C433FE
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 21:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJBVXS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 17:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJBVXR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 17:23:17 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4CD360B8
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 14:23:16 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q17so9922615lji.11
        for <linux-cifs@vger.kernel.org>; Sun, 02 Oct 2022 14:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=PgfvoedX1CczGxkSAI8qvl5fuihpKYSMdcJFmY8gmW0=;
        b=OiJSRJO1br+KDbTKsQkPxRX6jKH5ZsvzvkiYCdE5sRahXm1WQ32vFUwN8fph6hN1DO
         FJEIShL8u8VF6+jWKUS8fyCoBlxFca0K0ww0f43MOGHQJk+32cYbzhC3Cws+HegsAsE8
         BnIjLLr9bqLpyt2giDxgUPiWzi4vbFN6icSprMipD7q5Kq/LJ+NOiBmR1rdANky8OaG4
         MllvvPRzbAHlLKB+FS9Etk8WWtkP3MK2TjZuV3cQF7+LZzqh4ojztzkRj0jNKT1Da49R
         aJxQ47drPfjIiV8caVB1gSNfslUmQd7qg0xqTCh5zxaQmesfAELX77j2jcf9S9vliff/
         BvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PgfvoedX1CczGxkSAI8qvl5fuihpKYSMdcJFmY8gmW0=;
        b=X6q+8QabJmcBJdP9e1CZWlICNDcmXUbcoOIcDZZ572E9s/E9oum+YvSE4qVoJlNaog
         UorTKwhS0IJ67aHcmctbtLKcdxcrzvYdlcQStvgZj/tENBdIc+JWTWl8qBZ44ZxXpHG+
         tzzLwx/7uaAuODWdnRXxH6ftnfHEjEujxJ5JN3dRA37jDxjlaGNe68fs0gQq5jGjoVox
         LG+pDPxH9yw79KHQdFO8Y1mwBtpMc6dL4JPD2NFbtLWsFNyx0lP+PjeiPd5KdOr0Vy0U
         9UyaZMvRxeSEnmYN++2CKZ3LCiKYVrWaf3aQ8zAScgvWeCUtJumYrHtgbJ7I9W5nKrG0
         1uDQ==
X-Gm-Message-State: ACrzQf3Xy0e+c7kUkOCDZLyuM7wY6Sppkbu40Q18m4HJMg1VbIjUByiW
        +qD2CdpfsbmDL0NInsiqWIk=
X-Google-Smtp-Source: AMsMyM5yLiSnLy65O+U/QLnxbpqZMxmBA9vsKqbBZTzhXN5rP9bkoMAYKYzdqThK400Zho5jGa7Stg==
X-Received: by 2002:a2e:2e14:0:b0:26d:d636:4972 with SMTP id u20-20020a2e2e14000000b0026dd6364972mr897394lju.221.1664745794157;
        Sun, 02 Oct 2022 14:23:14 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84be-149.dhcp.inet.fi. [46.132.190.149])
        by smtp.gmail.com with ESMTPSA id i8-20020a056512318800b0049ebc44994fsm1189071lfe.128.2022.10.02.14.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 14:23:13 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     tom@talpey.com
Cc:     atteh.mailbox@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH v4] ksmbd: validate share name from share config response
Date:   Mon,  3 Oct 2022 00:21:37 +0300
Message-Id: <20221002212137.156711-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <baba86a7-060b-c878-95ed-0310def52850@talpey.com>
References: <baba86a7-060b-c878-95ed-0310def52850@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, 2 Oct 2022 14:34:43 -0400, Tom Talpey wrote:
> On 10/2/2022 11:40 AM, Atte Heikkilä wrote:
>> On Sun,  2 Oct 2022 05:46:28 +0300, Atte Heikkilä wrote:
>>> ...
>>> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
>>> index e0cbcfa98c7e..ff07c67f4565 100644
>>> --- a/fs/ksmbd/ksmbd_netlink.h
>>> +++ b/fs/ksmbd/ksmbd_netlink.h
>>> @@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
>>>   	__u16	force_directory_mode;
>>>   	__u16	force_uid;
>>>   	__u16	force_gid;
>>> -	__u32	reserved[128];		/* Reserved room */
>>> +	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
>>> +	__u32	reserved[112];		/* Reserved room */
> 
> I notice you still have "112" here, did you reject my suggestion
> to code the size relative to KSMBD_REQ_MAX_SHARE_NAME?
> 

If size of `reserved' should be relative, then it would be:
128 - DIV_ROUND_UP(KSMBD_REQ_MAX_SHARE_NAME, sizeof(__u32))

Since ksmbd-tools already has the 112 (128-64/4), I thought to keep the
kernel side consistent with it for now.

> Either way I think I made a flawed suggestion. The "reserved" field
> is __u32 but the KSMBD_REQ_MAX_SHARE_NAME is __s8. So, two things:
> 
> - why is share_name an __s8? Wouldn't __u8 be more appropriate?

As I understand it, the only reason for `__s8' over `__u8' here is that
`char' is most often a signed type.

> - why is reserved a __u32? ISTM that __u8 would also be a better
>    choice, and then the size would be "512 - KSMBD_REQ_MAX_SHARE_NAME".
> 
> 

I don't know why `reserved' is `__u32'. I agree that it would be better
if it was `__u8'.

>>>   	__u32	veto_list_sz;
>>>   	__s8	____payload[];
>>>   };
>>> diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
>>> index 5d039704c23c..dfb4bb365891 100644
>>> --- a/fs/ksmbd/mgmt/share_config.c
>>> +++ b/fs/ksmbd/mgmt/share_config.c
>>> @@ -16,6 +16,7 @@
>>>   #include "user_config.h"
>>>   #include "user_session.h"
>>>   #include "../transport_ipc.h"
>>> +#include "../misc.h"
>>>   
>>>   #define SHARE_HASH_BITS		3
>>>   static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
>>> @@ -119,7 +120,8 @@ static int parse_veto_list(struct ksmbd_share_config *share,
>>>   	return 0;
>>>   }
>>>   
>>> -static struct ksmbd_share_config *share_config_request(const char *name)
>>> +static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
>>> +						       const char *name)
>>>   {
>>>   	struct ksmbd_share_config_response *resp;
>>>   	struct ksmbd_share_config *share = NULL;
>>> @@ -133,6 +135,17 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>>>   	if (resp->flags == KSMBD_SHARE_FLAG_INVALID)
>>>   		goto out;
>>>   
>>> +	if (*resp->share_name) {
>>> +		char *cf_resp_name;
>>> +		bool equal;
>>> +
>>> +		cf_resp_name = ksmbd_casefold_sharename(um, resp->share_name);
>>> +		equal = !IS_ERR(cf_resp_name) && !strcmp(cf_resp_name, name);
>>> +		kfree(cf_resp_name);
>> 
>> Well, kfree() is *not* a no-op for ERR_PTR() like it is for NULL so
>> this patch is not good either. At least I'm running out of ways to get
>> this wrong.
> 
> :)
> 
> Tom.
> 
> 
>> 
>>> +		if (!equal)
>>> +			goto out;
>>> +	}
>>> +
>>>   	share = kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
>>>   	if (!share)
>>>   		goto out;
>>> @@ -190,7 +203,8 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>>>   	return share;
>>>   }
>>>   
>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
>>> +						  const char *name)
>>>   {
>>>   	struct ksmbd_share_config *share;
>>>   
>>> @@ -202,7 +216,7 @@ struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>>>   
>>>   	if (share)
>>>   		return share;
>>> -	return share_config_request(name);
>>> +	return share_config_request(um, name);
>>>   }
>>>   
>>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>> diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
>>> index 7f7e89ecfe61..3fd338293942 100644
>>> --- a/fs/ksmbd/mgmt/share_config.h
>>> +++ b/fs/ksmbd/mgmt/share_config.h
>>> @@ -9,6 +9,7 @@
>>>   #include <linux/workqueue.h>
>>>   #include <linux/hashtable.h>
>>>   #include <linux/path.h>
>>> +#include <linux/unicode.h>
>>>   
>>>   struct ksmbd_share_config {
>>>   	char			*name;
>>> @@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
>>>   	__ksmbd_share_config_put(share);
>>>   }
>>>   
>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
>>> +						  const char *name);
>>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>>   			       const char *filename);
>>>   #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
>>> diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
>>> index 867c0286b901..8ce17b3fb8da 100644
>>> --- a/fs/ksmbd/mgmt/tree_connect.c
>>> +++ b/fs/ksmbd/mgmt/tree_connect.c
>>> @@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>>>   	struct sockaddr *peer_addr;
>>>   	int ret;
>>>   
>>> -	sc = ksmbd_share_config_get(share_name);
>>> +	sc = ksmbd_share_config_get(conn->um, share_name);
>>>   	if (!sc)
>>>   		return status;
>>>   
>>> @@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>>>   		struct ksmbd_share_config *new_sc;
>>>   
>>>   		ksmbd_share_config_del(sc);
>>> -		new_sc = ksmbd_share_config_get(share_name);
>>> +		new_sc = ksmbd_share_config_get(conn->um, share_name);
>>>   		if (!new_sc) {
>>>   			pr_err("Failed to update stale share config\n");
>>>   			status.ret = -ESTALE;
>>> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
>>> index 28459b1efaa8..9e8afaa686e3 100644
>>> --- a/fs/ksmbd/misc.c
>>> +++ b/fs/ksmbd/misc.c
>>> @@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
>>>   	strreplace(path, '/', '\\');
>>>   }
>>>   
>>> -static char *casefold_sharename(struct unicode_map *um, const char *name)
>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name)
>>>   {
>>>   	char *cf_name;
>>>   	int cf_len;
>>> @@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
>>>   		name = (pos + 1);
>>>   
>>>   	/* caller has to free the memory */
>>> -	return casefold_sharename(um, name);
>>> +	return ksmbd_casefold_sharename(um, name);
>>>   }
>>>   
>>>   /**
>>> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
>>> index cc72f4e6baf2..1facfcd21200 100644
>>> --- a/fs/ksmbd/misc.h
>>> +++ b/fs/ksmbd/misc.h
>>> @@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
>>>   void ksmbd_conv_path_to_unix(char *path);
>>>   void ksmbd_strip_last_slash(char *path);
>>>   void ksmbd_conv_path_to_windows(char *path);
>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
>>>   char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
>>>   char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
>>>   
>>> -- 
>>> 2.37.3
>>>
>>>
>> 
> 
