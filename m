From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: using strlcpy instead of strncpy
Date: Fri, 21 Jun 2013 12:46:23 -0500
Message-ID: <CAH2r5mtpdx7XwX_TdaotaaE+x2bMZ4F=q=02QmYL5E0w3sC9RA@mail.gmail.com>
References: <51C2DFD6.5070202@huawei.com>
	<20130621131453.70c88a9c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130621131453.70c88a9c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into for-next cifs-2.6.git

On Fri, Jun 21, 2013 at 12:14 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 20 Jun 2013 18:56:22 +0800
> Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
>> for NUL terminated string, need alway set '\0' in the end.
>>
>> Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/connect.c |    2 +-
>>  fs/cifs/smb2pdu.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index e3bc39b..2ea78a3 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -3738,7 +3738,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>>               }
>>               bcc_ptr += length + 1;
>>               bytes_left -= (length + 1);
>> -             strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
>> +             strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
>>
>>               /* mostly informational -- no need to fail on error here */
>>               kfree(tcon->nativeFileSystem);
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index 2b95ce2..99bf768 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -792,7 +792,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>>       tcon->tidStatus = CifsGood;
>>       tcon->need_reconnect = false;
>>       tcon->tid = rsp->hdr.TreeId;
>> -     strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
>> +     strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
>>
>>       if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
>>           ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
>
> Seems like a reasonable cleanup, but if you're going to do that then
> it might not hurt to convert most of the places where MAX_TREE_SIZE is
> used to use sizeof(tcon->treeName) instead.
>
> Either way...
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



-- 
Thanks,

Steve
