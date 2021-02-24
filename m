Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32849C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 16:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C11F064DF2
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 16:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhBXQV7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:21:59 -0500
Received: from p3plsmtpa11-09.prod.phx3.secureserver.net ([68.178.252.110]:50791
        "EHLO p3plsmtpa11-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232806AbhBXQVl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 11:21:41 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2021 11:21:40 EST
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id EwlBlfdpwysOoEwlDlj0Zn; Wed, 24 Feb 2021 09:11:35 -0700
X-CMAE-Analysis: v=2.4 cv=Q50XX66a c=1 sm=1 tr=0 ts=60367ab8
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=yMhMjlubAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=TrMXproF9k-TAc-nbqIA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] convert revalidate of directories to using directory
 metadata cache timeout
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5msdUQ=CVM6s7ENeH7SP-teYAOioOGq7zY5sDXZFrFYiCA@mail.gmail.com>
 <CAH2r5mv6Oo5UUMOyFmKO_6xmdXZvQa_TtmFjgdN_ZoBcgSbJkA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <10881e42-9632-30b0-344d-66ed8e9cb340@talpey.com>
Date:   Wed, 24 Feb 2021 11:11:33 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mv6Oo5UUMOyFmKO_6xmdXZvQa_TtmFjgdN_ZoBcgSbJkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfP6YtrD/UtjCJkiacL5evgBhv+WCoyAiOI9fuv/bBzXtqXiEm0JB13lVW2K4Iy31x9Cc6wW1EXdiOtTex8ijavZRPdIO3ivokCiXbL5ERZuIlI6uv4uD
 p8FCAzDQMGEJjKGj4/QIASBrS7JJCmqBtjO/GwBzDRH2rz+NPAEtIora5zHAT4ov4nLZLp9YyfsPFtsenboHYT9+5P0Qo8CtaQYL9xjU0004Pd20KmnousN/
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/23/2021 8:03 PM, Steve French wrote:
> Updated version incorporates Ronnie's suggestion of leaving the
> default (for directory caching) the same as it is today, 1 second, to
> avoid
> unnecessary risk.   Most users can safely improve performance by
> mounting with acdirmax to a higher value (e.g. 60 seconds as NFS
> defaults to).
> 
> nfs and cifs on Linux currently have a mount parameter "actimeo" to control
> metadata (attribute) caching but cifs does not have additional mount
> parameters to allow distinguishing between caching directory metadata
> (e.g. needed to revalidate paths) and that for files.

The behaviors seem to be slightly different with this change.
With NFS, the actimeo option overrides the four min/max options,
and by default the directory ac timers range between 30 and 60.

The CIFS code I see below seems to completely separate actimeo
and acdirmax, and if not set, uses the historic 1 second value.
That's fine, but it's completely different from NFS. Shouldn't we
use a different mount option, to avoid confusing the admin?

> +	/*
> +	 * depending on inode type, check if attribute caching disabled for
> +	 * files or directories
> +	 */
> +	if (S_ISDIR(inode->i_mode)) {
> +		if (!cifs_sb->ctx->acdirmax)
> +			return true;
> +		if (!time_in_range(jiffies, cifs_i->time,
> +				   cifs_i->time + cifs_sb->ctx->acdirmax))
> +			return true;
> +	} else { /* file */
> +		if (!cifs_sb->ctx->actimeo)
> +			return true;
> +		if (!time_in_range(jiffies, cifs_i->time,
> +				   cifs_i->time + cifs_sb->ctx->actimeo))
> +			return true;
> +	}



> Add new mount parameter "acdirmax" to allow caching metadata for
> directories more loosely than file data.  NFS adjusts metadata
> caching from acdirmin to acdirmax (and another two mount parms
> for files) but to reduce complexity, it is safer to just introduce
> the one mount parm to allow caching directories longer. The
> defaults for acdirmax and actimeo (for cifs.ko) are conservative,
> 1 second (NFS defaults acdirmax to 60 seconds). For many workloads,
> setting acdirmax to a higher value is safe and will improve
> performance.  This patch leaves unchanged the default values
> for caching metadata for files and directories but gives the
> user more flexibility in adjusting them safely for their workload
> via the new mount parm.
> 
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/cifsfs.c     | 3 ++-
>   fs/cifs/cifsglob.h   | 8 +++++++-
>   fs/cifs/connect.c    | 2 ++
>   fs/cifs/fs_context.c | 9 +++++++++
>   fs/cifs/fs_context.h | 4 +++-
>   5 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 6f33ff3f625f..4e0b0b26e844 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -637,8 +637,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>    seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
>    if (tcon->handle_timeout)
>    seq_printf(s, ",handletimeout=%u", tcon->handle_timeout);
> - /* convert actimeo and display it in seconds */
> + /* convert actimeo and directory attribute timeout and display in seconds */
>    seq_printf(s, ",actimeo=%lu", cifs_sb->ctx->actimeo / HZ);
> + seq_printf(s, ",acdirmax=%lu", cifs_sb->ctx->acdirmax / HZ);
> 
>    if (tcon->ses->chan_max > 1)
>    seq_printf(s, ",multichannel,max_channels=%zu",
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index cd6dbeaf2166..a9dc39aee9f4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2278,6 +2278,8 @@ compare_mount_options(struct super_block *sb,
> struct cifs_mnt_data *mnt_data)
> 
>    if (old->ctx->actimeo != new->ctx->actimeo)
>    return 0;
> + if (old->ctx->acdirmax != new->ctx->acdirmax)
> + return 0;
> 
>    return 1;
>   }
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 7d04f2255624..555969c8d586 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -140,6 +140,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
>    fsparam_u32("rsize", Opt_rsize),
>    fsparam_u32("wsize", Opt_wsize),
>    fsparam_u32("actimeo", Opt_actimeo),
> + fsparam_u32("acdirmax", Opt_acdirmax),
>    fsparam_u32("echo_interval", Opt_echo_interval),
>    fsparam_u32("max_credits", Opt_max_credits),
>    fsparam_u32("handletimeout", Opt_handletimeout),
> @@ -936,6 +937,13 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,
>    goto cifs_parse_mount_err;
>    }
>    break;
> + case Opt_acdirmax:
> + ctx->acdirmax = HZ * result.uint_32;
> + if (ctx->acdirmax > CIFS_MAX_ACTIMEO) {
> + cifs_dbg(VFS, "acdirmax too large\n");
> + goto cifs_parse_mount_err;
> + }
> + break;
>    case Opt_echo_interval:
>    ctx->echo_interval = result.uint_32;
>    break;
> @@ -1362,6 +1370,7 @@ int smb3_init_fs_context(struct fs_context *fc)
>    ctx->strict_io = true;
> 
>    ctx->actimeo = CIFS_DEF_ACTIMEO;
> + ctx->acdirmax = CIFS_DEF_ACTIMEO;
> 
>    /* Most clients set timeout to 0, allows server to use its default */
>    ctx->handle_timeout = 0; /* See MS-SMB2 spec section 2.2.14.2.12 */
> diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> index 1c44a460e2c0..472372fec4e9 100644
> --- a/fs/cifs/fs_context.h
> +++ b/fs/cifs/fs_context.h
> @@ -118,6 +118,7 @@ enum cifs_param {
>    Opt_rsize,
>    Opt_wsize,
>    Opt_actimeo,
> + Opt_acdirmax,
>    Opt_echo_interval,
>    Opt_max_credits,
>    Opt_snapshot,
> @@ -232,7 +233,8 @@ struct smb3_fs_context {
>    unsigned int wsize;
>    unsigned int min_offload;
>    bool sockopt_tcp_nodelay:1;
> - unsigned long actimeo; /* attribute cache timeout (jiffies) */
> + unsigned long actimeo; /* attribute cache timeout for files (jiffies) */
> + unsigned long acdirmax; /* attribute cache timeout for directories
> (jiffies) */
>    struct smb_version_operations *ops;
>    struct smb_version_values *vals;
>    char *prepath;
> 
> On Tue, Feb 23, 2021 at 4:22 PM Steve French <smfrench@gmail.com> wrote:
>>
>> nfs and cifs on Linux currently have a mount parameter "actimeo" to
>> control metadata (attribute) caching but cifs does not have additional
>> mount parameters to allow distinguishing between caching directory
>> metadata (e.g. needed to revalidate paths) and that for files.
>>
>> Add new mount parameter "acdirmax" to allow caching metadata for
>> directories more loosely than file data.  NFS adjusts metadata
>> caching from acdirmin to acdirmax (and another two mount parms
>> for files) but to reduce complexity, it is safer to just introduce
>> the one mount parm to allow caching directories longer (30 seconds
>> vs. the 1 second default for file metadata) which is still more
>> conservative than other Linux filesystems (e.g. NFS sets acdirmax
>> to 60 seconds)
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 
