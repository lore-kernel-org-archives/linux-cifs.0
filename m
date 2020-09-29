Return-Path: <SRS0=6FgL=DG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB538C47420
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB7C2075E
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgI2Ra2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:30:28 -0400
Received: from p3plsmtpa11-02.prod.phx3.secureserver.net ([68.178.252.103]:56026
        "EHLO p3plsmtpa11-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728205AbgI2Ra1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 29 Sep 2020 13:30:27 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 13:30:27 EDT
Received: from [192.168.0.117] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id NJLIkbl8Tff3BNJLIkJ8Ws; Tue, 29 Sep 2020 10:23:09 -0700
X-CMAE-Analysis: v=2.3 cv=JL9FTPCb c=1 sm=1 tr=0
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=vggBfdFIAAAA:8 a=VwQbUJbxAAAA:8 a=hGzw-44bAAAA:8
 a=4OsUFv_FbRoPP-9s6jYA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=HvKuF1_PTVFglORKqfwH:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: Fwd: [PATCH] Convert trailing spaces and periods in path
 components
To:     Boris Protopopov <boris.v.protopopov@gmail.com>,
        Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20200924003638.2668-1-pboris@amazon.com>
 <CAHhKpQ4UFhtfRhByRiAm6KPy=KAzttYzZADLfakbMwpsp5GjpA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <9f6ee329-b91b-9d43-a787-0450a2c8143d@talpey.com>
Date:   Tue, 29 Sep 2020 13:23:08 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAHhKpQ4UFhtfRhByRiAm6KPy=KAzttYzZADLfakbMwpsp5GjpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfA8VYISm6+QuhnsyfPxelmv+j34UTbruYIHx23a7pTHRi+J1aJJ/3fECa3XdrOrykdrJvg6xo5JKLx/4ss498JYX8nZflFIS6IQeiArA9rVmhgnRJp8U
 mxVS5fMnztBoQSXAIv6OOlObLTjhkGGRV9AqHwnRU3wfXTBOZ/feup2dJNpbCYoA4vTyS7IWIpqUpBudPRLVx+1Mq5k4VOun5RVEJJFrSKUg2tODK/BZ+POR
 pa+NGr7IqKP2Yp3qhgMRPg==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

What was the server for these tests?

On 9/29/2020 1:08 PM, Boris Protopopov wrote:
> Testing:
> 
> Prior to the patch:
> 
> % mount -v
> …
> //host/share/home on /tmp/diry type cifs (rw,relatime,vers=default,...
> % ls -l /tmp/diry/tmp
> total 0
> % mkdir /tmp/diry/tmp/DirWithTrailingDot.
> % ls -l  /tmp/diry/tmp/DirWithTrailingDot.
> total 0
> % touch  /tmp/diry/tmp/DirWithTrailingDot./file
> touch: cannot touch ‘/tmp/diry/tmp/DirWithTrailingDot./file’: No such
> file or directory
> % mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
> mkdir: cannot create directory
> ‘/tmp/diry/tmp/DirWithTrailingDot./dir’: No such file or directory
> % find  /tmp/diry/tmp/DirWithTrailingDot.
> /tmp/diry/tmp/DirWithTrailingDot.
> % find  /tmp/diry/tmp/DirWithTrailingSpace\
> find: `/tmp/diry/tmp/DirWithTrailingSpace ': No such file or directory
> % mkdir  /tmp/diry/tmp/DirWithTrailingSpace\
> % ls -l  /tmp/diry/tmp/DirWithTrailingSpace\
> total 0
> % touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
> touch: cannot touch ‘/tmp/diry/tmp/DirWithTrailingSpace /file’: No
> such file or directory
> % mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
> mkdir: cannot create directory ‘/tmp/diry/tmp/DirWithTrailingSpace
> /dir’: No such file or directory
> 
> After the patch:
> 
> % umount /tmp/diry
> % modprobe -r cifs
> # load the fix
> % modprobe cifs
> % mount -t cifs -o...  //host/share/home /tmp/diry
> ...
> % mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
> % touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
> % mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
> % touch  /tmp/diry/tmp/DirWithTrailingDot./file
> % find  /tmp/diry/tmp/
> /tmp/diry/tmp/
> /tmp/diry/tmp/DirWithTrailingDot.
> /tmp/diry/tmp/DirWithTrailingDot./dir
> /tmp/diry/tmp/DirWithTrailingDot./file
> /tmp/diry/tmp/DirWithTrailingSpace
> /tmp/diry/tmp/DirWithTrailingSpace /dir
> /tmp/diry/tmp/DirWithTrailingSpace /file
> % rm -rf /tmp/diry/tmp/*
> % find  /tmp/diry/tmp/
> /tmp/diry/tmp/
> 
> ---------- Forwarded message ---------
> From: Boris Protopopov <pboris@amazon.com>
> Date: Wed, Sep 23, 2020 at 8:39 PM
> Subject: [PATCH] Convert trailing spaces and periods in path components
> To:
> Cc: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
> Boris Protopopov <pboris@amazon.com>
> 
> 
> When converting trailing spaces and periods in paths, do so
> for every component of the path, not just the last component.
> If the conversion is not done for every path component, then
> subsequent operations in directories with trailing spaces or
> periods (e.g. create(), mkdir()) will fail with ENOENT. This
> is because on the server, the directory will have a special
> symbol in its name, and the client needs to provide the same.
> 
> Signed-off-by: Boris Protopopov <pboris@amazon.com>
> ---
>   fs/cifs/cifs_unicode.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 498777d859eb..9bd03a231032 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const char
> *source, int srclen,
>                  else if (map_chars == SFM_MAP_UNI_RSVD) {
>                          bool end_of_string;
> 
> -                       if (i == srclen - 1)
> +                       /**
> +                        * Remap spaces and periods found at the end of every
> +                        * component of the path. The special cases of '.' and
> +                        * '..' do not need to be dealt with explicitly because
> +                        * they are addressed in namei.c:link_path_walk().
> +                        **/
> +                       if ((i == srclen - 1) || (source[i+1] == '\\'))
>                                  end_of_string = true;
>                          else
>                                  end_of_string = false;
> --
> 2.18.4
> 
> 
