Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5EEC0502A
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 07:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiH3HH3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 03:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiH3HHM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 03:07:12 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BDCC6CDD
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 00:06:47 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MGyxF4SpyzKHrj
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 15:05:05 +0800 (CST)
Received: from [10.174.176.83] (unknown [10.174.176.83])
        by APP2 (Coremail) with SMTP id Syh0CgBHmXIEtw1j4i2BAA--.32422S2;
        Tue, 30 Aug 2022 15:06:45 +0800 (CST)
Message-ID: <495c09a3-003f-7852-ef14-ba7e26984743@huaweicloud.com>
Date:   Tue, 30 Aug 2022 15:06:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO
 message
To:     stfrench@microsoft.com
References: <20220824085732.1928010-1-zhangxiaoxu5@huawei.com>
From:   huaweicloud <zhangxiaoxu@huaweicloud.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, pc@cjr.nz
In-Reply-To: <20220824085732.1928010-1-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgBHmXIEtw1j4i2BAA--.32422S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4UAryrJFW3ZFW7AF17trb_yoW8XrWrpr
        4vga48GFZ3XrW8Cw17K3Wkua98Kwn5Ww47urs8C345JF1rZasFkF1v93s5W34FkFWYya1j
        qr4Yqa45twn0kaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1j6r18M7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Could you help to review this patch.

Thanks,
Zhang Xiaoxu

在 2022/8/24 16:57, Zhang Xiaoxu 写道:
> Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
> extend the dialects from 3 to 4, but forget to decrease the extended
> length when specific the dialect, then the message length is larger
> than expected.
> 
> This maybe leak some info through network because not initialize the
> message body.
> 
> After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
> reduced from 28 bytes to 26 bytes.
> 
> Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/cifs/smb2pdu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 1ecc2501c56f..3df7adc01fe5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1162,9 +1162,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   		pneg_inbuf->Dialects[0] =
>   			cpu_to_le16(server->vals->protocol_id);
>   		pneg_inbuf->DialectCount = cpu_to_le16(1);
> -		/* structure is big enough for 3 dialects, sending only 1 */
> +		/* structure is big enough for 4 dialects, sending only 1 */
>   		inbuflen = sizeof(*pneg_inbuf) -
> -				sizeof(pneg_inbuf->Dialects[0]) * 2;
> +				sizeof(pneg_inbuf->Dialects[0]) * 3;
>   	}
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,

