Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6120FC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 14:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC8264F18
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 14:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhCSODf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 10:03:35 -0400
Received: from p3plsmtpa06-02.prod.phx3.secureserver.net ([173.201.192.103]:42131
        "EHLO p3plsmtpa06-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229925AbhCSODN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 19 Mar 2021 10:03:13 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id NFiXlbXRcBt9YNFiYlSQSH; Fri, 19 Mar 2021 07:03:10 -0700
X-CMAE-Analysis: v=2.4 cv=C/0sdSD+ c=1 sm=1 tr=0 ts=6054af1e
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=3-RhneuVAAAA:8 a=eswUgBqCcl90HEgtvx8A:9
 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22 a=VLVLkjT_5ZicWzSuYqSo:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v3] cifs: Silently ignore unknown oplock break handle
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Steve French <sfrench@samba.org>
Cc:     kernel@axis.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <20210319135711.11802-1-vincent.whitchurch@axis.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <4ebdf34a-bd01-68ad-6d27-b1c02d21aebe@talpey.com>
Date:   Fri, 19 Mar 2021 10:03:10 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210319135711.11802-1-vincent.whitchurch@axis.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCNVZxyNVbezDCGi8/jg/8PjvDCrHEwezT+McuGoN0CXy5Th5eqKF5XuMCO8hDLaNqnroiUHmRq7ntRMuzxwd/jiOvW0Fw4pcz2PHOTdcWOdcbyMgqCu
 bTbpqcmrgY5DOmSnY5TZzFQxR/BBIdCVaMwEA6mm5phg+NRQxCa8baUhnlY8qMMxO4RAyZc/1vOTRW5k3VezQGyJUh6a3eoAbOVdyFq439wpGkYLcptzBYV7
 VA9Mx/9N1Qc2XzPIdHVL7kTi7L1kxTV+YjiT78bjj0v9lYZA9nZyhu/suJCRM/4wgCe+III5k9pglpv5IEM8KImRuIRvtHZpCvX9LJbf51AuKKNSNh5lbmam
 rDBSBzC3OQOAMefOwCPEus5xkTJhlg==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM feel free to add

Reviewed-By: Tom Talpey <tom@talpey.com>

On 3/19/2021 9:57 AM, Vincent Whitchurch wrote:
> Make SMB2 not print out an error when an oplock break is received for an
> unknown handle, similar to SMB1.  The debug message which is printed for
> these unknown handles may also be misleading, so fix that too.
> 
> The SMB2 lease break path is not affected by this patch.
> 
> Without this, a program which writes to a file from one thread, and
> opens, reads, and writes the same file from another thread triggers the
> below errors several times a minute when run against a Samba server
> configured with "smb2 leases = no".
> 
>   CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
>   00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
>   00000010: 00000001 00000000 ffffffff ffffffff  ................
>   00000020: 00000000 00000000 00000000 00000000  ................
>   00000030: 00000000 00000000 00000000 00000000  ................
> 
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> ---
> 
> Notes:
>      v3:
>      - Change debug print to Tom Talpey's suggestion
>      
>      v2:
>      - Drop change to lease break
>      - Rewrite commit message
> 
>   fs/cifs/smb2misc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 60d4bd1eae2b..76cd05b8d53b 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -754,8 +754,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>   		}
>   	}
>   	spin_unlock(&cifs_tcp_ses_lock);
> -	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
> -	return false;
> +	cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
> +	return true;
>   }
>   
>   void
> 
