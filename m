Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1DCC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 02:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJCCGh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 22:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCCGg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 22:06:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16C432DB7
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 19:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39040B80D30
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 02:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBC2C433C1
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 02:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664762791;
        bh=LE3wruHICAw8QeA2tFLfQtyoPeaOUUdzHiOkfOUB7JY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UntZKgchBl12PH5+RINWg4z4Rt5a2bqYS6lnOq/vEHA90hvPRN4Um2jFaCaCd2amD
         FozpQfekYDSEmLbI4V26aJcX9yYHqb1BCiOTUo68eC8h6xcsxhQqaghpHwkIJJwCne
         p+GVXH92K91LXryI41q0kFuLjU+xaeMEik6F3FhkSm6lpciZ3UamLadwSfzL1FhXmI
         vDJMF4JcAwpt8QDC4g5kPbqjVGnuGDhO1SJg61ZElDkKdoOzEgUzaLaeSwgdloHLO7
         xeQ8rneR0LV0DW9axgeZ+SpHYz8IZyUCVRgg/SEWsWkSezIezuT3zT/RZ5Fy8CYCo8
         QHBq2e0RkD3Qw==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-132555b7121so2547491fac.2
        for <linux-cifs@vger.kernel.org>; Sun, 02 Oct 2022 19:06:31 -0700 (PDT)
X-Gm-Message-State: ACrzQf2RlCsuaDXyvFTr15QR/y5TjZGmZPRnguRpWXxz3J2dYxEHjobQ
        FY0j6bQacKjNnUugF9XaLdGogk+q8IMEelkmBU8=
X-Google-Smtp-Source: AMsMyM6A5QERrdtDCbBQNCYHr1DuR4ERuoiZfz4NRVMjDiJw8sMAp3Q2xSSTauUGrUZxnBo5uhfW59ErnH+AzGnYA3Q=
X-Received: by 2002:a05:6871:893:b0:131:84aa:5b80 with SMTP id
 r19-20020a056871089300b0013184aa5b80mr4621836oaq.257.1664762790889; Sun, 02
 Oct 2022 19:06:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 2 Oct 2022 19:06:30
 -0700 (PDT)
In-Reply-To: <20221002212137.156711-1-atteh.mailbox@gmail.com>
References: <baba86a7-060b-c878-95ed-0310def52850@talpey.com> <20221002212137.156711-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 3 Oct 2022 11:06:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd__JiXd2YBnAmLwtBMuRkw4penZYrASsrxepm7UaZBBrw@mail.gmail.com>
Message-ID: <CAKYAXd__JiXd2YBnAmLwtBMuRkw4penZYrASsrxepm7UaZBBrw@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: validate share name from share config response
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-10-03 6:21 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> On Sun, 2 Oct 2022 14:34:43 -0400, Tom Talpey wrote:
>> On 10/2/2022 11:40 AM, Atte Heikkil=C3=A4 wrote:
>>> On Sun,  2 Oct 2022 05:46:28 +0300, Atte Heikkil=C3=A4 wrote:
>>>> ...
>>>> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
>>>> index e0cbcfa98c7e..ff07c67f4565 100644
>>>> --- a/fs/ksmbd/ksmbd_netlink.h
>>>> +++ b/fs/ksmbd/ksmbd_netlink.h
>>>> @@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
>>>>   	__u16	force_directory_mode;
>>>>   	__u16	force_uid;
>>>>   	__u16	force_gid;
>>>> -	__u32	reserved[128];		/* Reserved room */
>>>> +	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
>>>> +	__u32	reserved[112];		/* Reserved room */
>>
>> I notice you still have "112" here, did you reject my suggestion
>> to code the size relative to KSMBD_REQ_MAX_SHARE_NAME?
>>
>
> If size of `reserved' should be relative, then it would be:
> 128 - DIV_ROUND_UP(KSMBD_REQ_MAX_SHARE_NAME, sizeof(__u32))
>
> Since ksmbd-tools already has the 112 (128-64/4), I thought to keep the
> kernel side consistent with it for now.
>
>> Either way I think I made a flawed suggestion. The "reserved" field
>> is __u32 but the KSMBD_REQ_MAX_SHARE_NAME is __s8. So, two things:
>>
>> - why is share_name an __s8? Wouldn't __u8 be more appropriate?
>
> As I understand it, the only reason for `__s8' over `__u8' here is that
> `char' is most often a signed type.
>
>> - why is reserved a __u32? ISTM that __u8 would also be a better
>>    choice, and then the size would be "512 - KSMBD_REQ_MAX_SHARE_NAME".
>>
>>
>
> I don't know why `reserved' is `__u32'. I agree that it would be better
> if it was `__u8'.
We can make another patch for both ksmbd/ksmbd-tools later.
>
>>>>   	__u32	veto_list_sz;
>>>>   	__s8	____payload[];
>>>>   };
>>>> diff --git a/fs/ksmbd/mgmt/share_config.c
>>>> b/fs/ksmbd/mgmt/share_config.c
>>>> index 5d039704c23c..dfb4bb365891 100644
>>>> --- a/fs/ksmbd/mgmt/share_config.c
>>>> +++ b/fs/ksmbd/mgmt/share_config.c
>>>> @@ -16,6 +16,7 @@
>>>>   #include "user_config.h"
>>>>   #include "user_session.h"
>>>>   #include "../transport_ipc.h"
>>>> +#include "../misc.h"
>>>>
>>>>   #define SHARE_HASH_BITS		3
>>>>   static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
>>>> @@ -119,7 +120,8 @@ static int parse_veto_list(struct ksmbd_share_conf=
ig
>>>> *share,
>>>>   	return 0;
>>>>   }
>>>>
>>>> -static struct ksmbd_share_config *share_config_request(const char
>>>> *name)
>>>> +static struct ksmbd_share_config *share_config_request(struct
>>>> unicode_map *um,
>>>> +						       const char *name)
>>>>   {
>>>>   	struct ksmbd_share_config_response *resp;
>>>>   	struct ksmbd_share_config *share =3D NULL;
>>>> @@ -133,6 +135,17 @@ static struct ksmbd_share_config
>>>> *share_config_request(const char *name)
>>>>   	if (resp->flags =3D=3D KSMBD_SHARE_FLAG_INVALID)
>>>>   		goto out;
>>>>
>>>> +	if (*resp->share_name) {
>>>> +		char *cf_resp_name;
>>>> +		bool equal;
>>>> +
>>>> +		cf_resp_name =3D ksmbd_casefold_sharename(um, resp->share_name);
>>>> +		equal =3D !IS_ERR(cf_resp_name) && !strcmp(cf_resp_name, name);
>>>> +		kfree(cf_resp_name);
>>>
>>> Well, kfree() is *not* a no-op for ERR_PTR() like it is for NULL so
>>> this patch is not good either. At least I'm running out of ways to get
>>> this wrong.
>>
>> :)
>>
>> Tom.
>>
>>
>>>
>>>> +		if (!equal)
>>>> +			goto out;
>>>> +	}
>>>> +
>>>>   	share =3D kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
>>>>   	if (!share)
>>>>   		goto out;
>>>> @@ -190,7 +203,8 @@ static struct ksmbd_share_config
>>>> *share_config_request(const char *name)
>>>>   	return share;
>>>>   }
>>>>
>>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map
>>>> *um,
>>>> +						  const char *name)
>>>>   {
>>>>   	struct ksmbd_share_config *share;
>>>>
>>>> @@ -202,7 +216,7 @@ struct ksmbd_share_config
>>>> *ksmbd_share_config_get(const char *name)
>>>>
>>>>   	if (share)
>>>>   		return share;
>>>> -	return share_config_request(name);
>>>> +	return share_config_request(um, name);
>>>>   }
>>>>
>>>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>>> diff --git a/fs/ksmbd/mgmt/share_config.h
>>>> b/fs/ksmbd/mgmt/share_config.h
>>>> index 7f7e89ecfe61..3fd338293942 100644
>>>> --- a/fs/ksmbd/mgmt/share_config.h
>>>> +++ b/fs/ksmbd/mgmt/share_config.h
>>>> @@ -9,6 +9,7 @@
>>>>   #include <linux/workqueue.h>
>>>>   #include <linux/hashtable.h>
>>>>   #include <linux/path.h>
>>>> +#include <linux/unicode.h>
>>>>
>>>>   struct ksmbd_share_config {
>>>>   	char			*name;
>>>> @@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct
>>>> ksmbd_share_config *share)
>>>>   	__ksmbd_share_config_put(share);
>>>>   }
>>>>
>>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
>>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map
>>>> *um,
>>>> +						  const char *name);
>>>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>>>   			       const char *filename);
>>>>   #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
>>>> diff --git a/fs/ksmbd/mgmt/tree_connect.c
>>>> b/fs/ksmbd/mgmt/tree_connect.c
>>>> index 867c0286b901..8ce17b3fb8da 100644
>>>> --- a/fs/ksmbd/mgmt/tree_connect.c
>>>> +++ b/fs/ksmbd/mgmt/tree_connect.c
>>>> @@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn,
>>>> struct ksmbd_session *sess,
>>>>   	struct sockaddr *peer_addr;
>>>>   	int ret;
>>>>
>>>> -	sc =3D ksmbd_share_config_get(share_name);
>>>> +	sc =3D ksmbd_share_config_get(conn->um, share_name);
>>>>   	if (!sc)
>>>>   		return status;
>>>>
>>>> @@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn,
>>>> struct ksmbd_session *sess,
>>>>   		struct ksmbd_share_config *new_sc;
>>>>
>>>>   		ksmbd_share_config_del(sc);
>>>> -		new_sc =3D ksmbd_share_config_get(share_name);
>>>> +		new_sc =3D ksmbd_share_config_get(conn->um, share_name);
>>>>   		if (!new_sc) {
>>>>   			pr_err("Failed to update stale share config\n");
>>>>   			status.ret =3D -ESTALE;
>>>> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
>>>> index 28459b1efaa8..9e8afaa686e3 100644
>>>> --- a/fs/ksmbd/misc.c
>>>> +++ b/fs/ksmbd/misc.c
>>>> @@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
>>>>   	strreplace(path, '/', '\\');
>>>>   }
>>>>
>>>> -static char *casefold_sharename(struct unicode_map *um, const char
>>>> *name)
>>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char
>>>> *name)
>>>>   {
>>>>   	char *cf_name;
>>>>   	int cf_len;
>>>> @@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map
>>>> *um, const char *treename)
>>>>   		name =3D (pos + 1);
>>>>
>>>>   	/* caller has to free the memory */
>>>> -	return casefold_sharename(um, name);
>>>> +	return ksmbd_casefold_sharename(um, name);
>>>>   }
>>>>
>>>>   /**
>>>> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
>>>> index cc72f4e6baf2..1facfcd21200 100644
>>>> --- a/fs/ksmbd/misc.h
>>>> +++ b/fs/ksmbd/misc.h
>>>> @@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
>>>>   void ksmbd_conv_path_to_unix(char *path);
>>>>   void ksmbd_strip_last_slash(char *path);
>>>>   void ksmbd_conv_path_to_windows(char *path);
>>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char
>>>> *name);
>>>>   char *ksmbd_extract_sharename(struct unicode_map *um, const char
>>>> *treename);
>>>>   char *convert_to_unix_name(struct ksmbd_share_config *share, const
>>>> char *name);
>>>>
>>>> --
>>>> 2.37.3
>>>>
>>>>
>>>
>>
>
