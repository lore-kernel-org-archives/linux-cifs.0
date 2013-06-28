From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fill TRANS2_QUERY_FILE_INFO ByteCount fields
Date: Fri, 28 Jun 2013 07:33:12 -0400
Message-ID: <20130628073312.5dd80f9c@corrin.poochiereds.net>
References: <1372412853-25917-1-git-send-email-ddiss@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372412853-25917-1-git-send-email-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 28 Jun 2013 11:47:33 +0200
David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:

> Currently the trans2 ByteCount field is incorrectly left zero in
> TRANS2_QUERY_FILE_INFO info_level=SMB_QUERY_FILE_ALL_INFO and
> info_level=SMB_QUERY_FILE_UNIX_BASIC requests. The field should properly
> reflect the FID, information_level and padding bytes carried in these
> requests.
> 
> Leaving this field zero causes such requests to fail against Novell CIFS
> servers. Other SMB servers (e.g. Samba) use the parameter count fields
> for data length calculations instead, so do not suffer the same fate.
> 
> Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index a58dc77..efe794d 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3940,6 +3940,7 @@ QFileInfoRetry:
>  	pSMB->Pad = 0;
>  	pSMB->Fid = netfid;
>  	inc_rfc1001_len(pSMB, byte_count);
> +	pSMB->t2.ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> @@ -4108,6 +4109,7 @@ UnixQFileInfoRetry:
>  	pSMB->Pad = 0;
>  	pSMB->Fid = netfid;
>  	inc_rfc1001_len(pSMB, byte_count);
> +	pSMB->t2.ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);

Looks correct...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
