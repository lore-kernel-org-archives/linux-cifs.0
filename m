Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30D8C46467
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 02:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjAKCZA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 21:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbjAKCYd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 21:24:33 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7262AC
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 18:24:32 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id F36077FC04;
        Wed, 11 Jan 2023 02:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673403870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ViJWm1vf7VQXEGSozSJ8el6dBH03e7I6jG9GOMr9eBY=;
        b=QCT9qcznKxMCEwBDQkS/6G9481/zXl3eqOFyxW4u0ylRchSBOb+gA244ikYKk8a6npbjlx
        ojsNi3EzTatGrL+O5wpJA6NJWR2l75I73R75ixLnb4y4FcAQqv94BF+Z2N28jBz+mIeitp
        ceenVzXyXfYB3YQG8iUbkA7ioqqMvACTU/P8FWU+QHIvuHrZvvE+Tf1vuSAsxF4V8ZwuT3
        en0wjKERjmBbQ58Vn1L5qzFXFSWv1iWkd6inZVPLy4s7m7IMpoaNacTo0cOEAp7U3Y1bOY
        RYHkUKDXIe+XH9T6xaKIXMdJjXOs1hdU63lfk46UleqjsPAHmhp2rIctn4EWhQ==
Date:   Tue, 10 Jan 2023 23:24:22 -0300
From:   Paulo Alcantara <pc@cjr.nz>
To:     Tom Talpey <tom@talpey.com>, smfrench@gmail.com
CC:     linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH v2] cifs: do not query ifaces on smb1 mounts
In-Reply-To: <25f67260-e483-b81b-2fde-7df7d3359370@talpey.com>
References: <20230109164146.1910-1-pc@cjr.nz> <20230110222321.30860-1-pc@cjr.nz> <25f67260-e483-b81b-2fde-7df7d3359370@talpey.com>
Message-ID: <4F09ED4F-E76E-454E-938C-2E6EFD1F871F@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10 January 2023 22:42:33 GMT-03:00, Tom Talpey <tom@talpey=2Ecom> wrote:
>On 1/10/2023 5:23 PM, Paulo Alcantara wrote:
>> Users have reported the following error on every 600 seconds
>> (SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:
>>=20
>> 	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list
>>=20
>> It's supported only by SMB2+, so do not query network interfaces on
>> SMB1 mounts=2E
>>=20
>> Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from =
server")
>> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr=2Enz>
>> Signed-off-by: Steve French <stfrench@microsoft=2Ecom>
>> ---
>> v1 -> v2:
>> 	remove cifs_tcon::iface_query_poll and then check version and
>> 	server's capability multichannel
>>=20
>>   fs/cifs/connect=2Ec | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/fs/cifs/connect=2Ec b/fs/cifs/connect=2Ec
>> index d371259d6808=2E=2Eb2a04b4e89a5 100644
>> --- a/fs/cifs/connect=2Ec
>> +++ b/fs/cifs/connect=2Ec
>> @@ -2606,11 +2606,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3=
_fs_context *ctx)
>>   	INIT_LIST_HEAD(&tcon->pending_opens);
>>   	tcon->status =3D TID_GOOD;
>>   -	/* schedule query interfaces poll */
>>   	INIT_DELAYED_WORK(&tcon->query_interfaces,
>>   			  smb2_query_server_interfaces);
>> -	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
>> -			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
>> +	if (ses->server->dialect >=3D SMB30_PROT_ID &&
>
>The dialect test is actually unnecessary, because the server
>global capability, indicating the support, is what's important=2E
>But it's harmless to be explicit, so=2E=2E

The dialect test is still necessary, otherwise we'd end up mixing SMB2_GLO=
BAL_CAP_MULTI_CHANNEL with CAP_LARGE_FILES[1] and then scheduling the worke=
r for smb1 mounts=2E

I quickly tested it and the global cap test passed for smb1 mount due to C=
AP_LARGE_FILES being set=2E

[1] https://git=2Ecjr=2Enz/linux=2Egit/tree/fs/cifs/cifspdu=2Eh#n533


>
>Reviewed-by: Tom Talpey <tom@talpey=2Ecom>
>
>LGTM=2E
>
>> +	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
>> +		/* schedule query interfaces poll */
>> +		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
>> +				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
>> +	}
>>     	spin_lock(&cifs_tcp_ses_lock);
>>   	list_add(&tcon->tcon_list, &ses->tcon_list);

