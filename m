From: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] SMB: fix leak of validate negotiate info response
 buffer
Date: Fri, 20 Oct 2017 22:49:58 -0400 (EDT)
Message-ID: <61197467.18033621.1508554198404.JavaMail.zimbra@redhat.com>
References: <20171020102033.22936-1-shuwang@redhat.com> <20171020124938.9913-1-ddiss@suse.de> <20171020124938.9913-2-ddiss@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020124938.9913-2-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> From: "David Disseldorp" <ddiss-l3A5Bk7waGM@public.gmane.org>
> To: "Shu Wang" <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
> Cc: "David Disseldorp" <ddiss-l3A5Bk7waGM@public.gmane.org>
> Sent: Friday, October 20, 2017 8:49:37 PM
> Subject: [PATCH 1/2] SMB: fix leak of validate negotiate info response buffer
> 
> Fixes: ff1c038addc4 ("Check SMB3 dialects against downgrade attacks")
> Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6f0e6343c15e..052ab5dee6b6 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -648,7 +648,7 @@ int smb3_validate_negotiate(const unsigned int xid,
> struct cifs_tcon *tcon)
>  {
>  	int rc = 0;
>  	struct validate_negotiate_info_req vneg_inbuf;
> -	struct validate_negotiate_info_rsp *pneg_rsp;
> +	struct validate_negotiate_info_rsp *pneg_rsp = NULL;
>  	u32 rsplen;
>  	u32 inbuflen; /* max of 4 dialects */
>  

SMB2_ioctl will set pneg_rsp pointer to NULL, so it won't really
cause any issue. Anyway, looks good to me.

1879 SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
1880 >---   u64 volatile_fid, u32 opcode, bool is_fsctl, bool use_ipc,
1881 >---   char *in_data, u32 indatalen,
1882 >---   char **out_data, u32 *plen /* returned data len */)
1883 {
........
1897 >---if (out_data != NULL)
1898 >--->---*out_data = NULL;
1899 
